public with sharing class XMLBundle_old {

    /**
    * @author Ryan Scott updated by Adrian Pichardo
    * @date 11/02/2015 updated 09/13/18
    * @description Used for manually throwing errors back to the Visualforce page.
    *   Usage: throw new ApplicationException('This is the error message');
    **/
    public class ApplicationException extends Exception {}

    /**
    * @author Ryan Scott
    * @date 12/02/2015
    * @description Primary function that initiates XML document generation for a Deal record which can be sent to Hearst. 
    *   The Deal must have a Program and Schedule(s) linked to it, and the Program must have at least one active Bundle Pricing
    *   record linked to it. Data is grouped by Station into individual XML documents, and within each file the Station's Bundle Pricing
    *   data is displayed as buylines.
    * @param String dealId - Record Id of the selected Deal
    * @param String scheduleId - Record Id of a specific Schedule. This is optional and if included then the XML files will be generated
    *   using only that one specific Schedule.
    * @return Map<String, String> - A map containing the XML body of each file that was generated.
    *   Key: Filename using the Station's call letters with .xml added to the end (example: WMUR.xml)
    *   Value: Base64-encoded XML body content
    *   The map also includes a list of Schedules that were used, with the key 'scheduleIds'. The list contained record Ids separated by semicolons.
    **/
    @RemoteAction
    public static Map<String, String> getXMLFiles(String dealId, String scheduleId) {
        // Setup map to contain all results from this method. Will contain the generated XML files and a list of Schedules that were used in the process.
        Map<String, String> resultsData = new Map<String, String>();

        // Get the deal and fields using the passed variable
        Deal__c deal = [SELECT Name, Advertiser__c, Brands__r.Name, Bundle_Start_Week__c, ContactAccount__c, Length__c, Program__c, CreatedDate, Program__r.Bundle_Name__c, Program__r.Logs_Contact__c, Program__r.Logs_Contact__r.FirstName, Program__r.Logs_Contact__r.LastName FROM Deal__c WHERE Id = :dealId];

        if(deal.Advertiser__c == null) {
            throw new ApplicationException('The Advertiser lookup is missing from the Deal. Please add an Advertiser and try again.');
        }
        if(deal.Brands__r.Name == null) {
            throw new ApplicationException('The Brand Name value is empty. Please make sure that the Deal has a Brand connected to it and try again.');
        }
        if(scheduleId == null && deal.Bundle_Start_Week__c == null) {
            throw new ApplicationException('The Deal is missing a value for Bundle Start Week. Please fill out this field and try again.');
        }
        if(deal.ContactAccount__c == null) {
            throw new ApplicationException('The Contact Account value is missing from the Deal. Please make sure that the Deal has a Contact connected to it and try again.');
        }
        if(deal.Length__c == null) {
            throw new ApplicationException('The Deal is missing a value for Length. Please fill out this field and try again.');
        }
        if(deal.Program__c == null) {
            throw new ApplicationException('The Program lookup is missing from the Deal. Please add a Program and try again.');
        }
        if(deal.Program__r.Logs_Contact__c == null) {
            throw new ApplicationException('The Logs Contact lookup is missing from the Program. Please add a Logs Contact and try again.');
        }

        // Bundle Start Week field requirements only apply if a Schedule Id was not passed in
        if(scheduleId == null) {
            // Require that the Bundle Start Week field has been updated today, or it's a new Deal that was created today
            List<Deal__History> dealHistory = [SELECT ParentId, OldValue, NewValue, Field, CreatedDate FROM Deal__History WHERE ParentId = :dealId AND Field = 'Bundle_Start_Week__c' AND CreatedDate = TODAY];
            if(dealHistory.size() == 0 && deal.CreatedDate < Date.today()) {
                throw new ApplicationException('The Bundle Start Week field on the Deal has not been updated yet today. Please update that field to a new value and try again.');
            }
        }

        List<ScheduleChunkWrapper> scheduleChunks;
        String orderId;
        // If a Schedule Id was passed in then we will only be building the XML files using that one specific schedule
        // Also formulate the Order Id attribute using either the Schedule's Name or the Deal's Name
        if(String.isNotBlank(scheduleId)) {
            Schedules__c schedule = [SELECT Id, Name, Week__c, XML_Sent__c FROM Schedules__c WHERE Id = :scheduleId];
            if(schedule.XML_Sent__c) {
                throw new ApplicationException('The XML Sent field on this Schedule indicates that an XML bundle for this Schedule has already been generated and sent. If you need to generate a new XML then please uncheck the XML Sent checkbox and try again.');
            }

            scheduleChunks = buildSingleScheduleList(schedule);
            resultsData.put('scheduleIds', schedule.Id);
            orderId = schedule.Name;
        } else {
            // Get all schedules for this deal sort by week and then group them into chunks of continuously scheduled weeks
            scheduleChunks = buildScheduleList(deal.Id, deal.Bundle_Start_Week__c);

            // Combine all Schedule Ids from the list of chunks and add to the results data map
            List<String> scheduleIdsList = new List<String>();
            for(ScheduleChunkWrapper scheduleChunk : scheduleChunks) {
                if(String.isNotBlank(scheduleChunk.scheduleIds)) {
                    scheduleIdsList.add(scheduleChunk.scheduleIds);
                }
            }
            resultsData.put('scheduleIds', String.join(scheduleIdsList, ';'));

            orderId = deal.Name;
        }

        // Get all active Bundle Pricing records for the Deal's Program and then group them by Station
        List<Bundle_Pricing__c> bundlePricingList = [
            SELECT Call_Letters__c,
            Days__c,
            End_Time__c,
            Rate_per_30__c,
            Start_Time__c,
            Station__r.Market__r.Name,
            Total__c,
            Units__c
            FROM Bundle_Pricing__c
            WHERE Program__c = :deal.Program__c
                AND Active__c = TRUE
        ];
        if(bundlePricingList.size() == 0) {
            throw new ApplicationException('No active Bundle Pricing records were found. Please make sure that the Deal\'s Program has at least one active Bundle Pricing record.');
        }

        Map<String, StationWrapper> stations = buildStationList(bundlePricingList);

        // Generate the XML data for each Station. Put data in the results map using the Station's filename as the keys and encoded data as values.
        for(StationWrapper station : stations.values()) {
            String body = generateXml(deal, scheduleChunks, station, orderId);

            String contactAccount = deal.ContactAccount__c.replaceAll('/', '');
            String brand = deal.Brands__r.Name.replaceAll('/', '');

            String filename = station.callLetters + '-' + deal.Name + '-' + contactAccount + '-' + brand + '-NEW BUY-';
            Date d = Date.today();
            filename += d.year() + '-' + padIntegerWithLeadingZero(d.month()) + '-' + padIntegerWithLeadingZero(d.day()) + '.xml';

            resultsData.put(filename, EncodingUtil.base64Encode(Blob.valueOf(body)));
        }

        return resultsData;
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description A wrapper class for holding chunks of continuously scheduled weeks. The start and end strings mark
    *   the start and end of a continuous chunk of scheduled time.
    * @param Date chunkStart - Date object containing the starting date of the scheduled time. This is converted
    *   converted into a string of format YYYY-MM-DD.
    * @param Date chunkEnd - Date object containing the starting date of the scheduled time. This is converted
    *   converted into a string of format YYYY-MM-DD.
    * @param Integer weekCount - Number of weeks that the chunk spans
    * @param String scheduleIds - List of all Schedule record Ids in the chunk, separated by semicolons
    **/
    public class ScheduleChunkWrapper {
        public String chunkStart {get; set;}
        public String chunkEnd {get; set;}
        public Integer weekCount {get; set;}
        public String scheduleIds {get; set;}

        public ScheduleChunkWrapper(Date chunkStart, Date chunkEnd, Integer weekCount, String scheduleIds) {
            this.chunkStart = chunkStart.year() + '-' + padIntegerWithLeadingZero(chunkStart.month()) + '-' + padIntegerWithLeadingZero(chunkStart.day());
            this.chunkEnd = chunkEnd.year() + '-' + padIntegerWithLeadingZero(chunkEnd.month()) + '-' + padIntegerWithLeadingZero(chunkEnd.day());
            this.weekCount = weekCount;
            this.scheduleIds = scheduleIds;
        }
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Simple utility function that adds a leading zero to an integer to make it 2 digits.
    *   Used in this class for converting single digit month and day integers to 2 digits.
    * @param Integer i - Any integer value
    * @return String - String value of input integer with at least 2 digits. 8 -> '08'
    **/
    public static String padIntegerWithLeadingZero(Integer i) {
        if(i > 9) {
            return String.valueOf(i);
        } else {
            return '0' + String.valueOf(i);
        }
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Queries for Schedules attached to the Deal and collects them into a list of continously scheduled weeks.
    * @param Id dealId - The Record Id of the selected Deal. Used for finding all related Schedule records.
    * @return List<ScheduleChunkWrapper> - List of wrapper objects containing continuously scheduled weeks.
    **/
    public static List<ScheduleChunkWrapper> buildScheduleList(Id dealId, Date bundleStartWeek) {
        // Query for ORDERED list of Schedules on the Deal
        List<Schedules__c> schedules = [SELECT Id, Week__c FROM Schedules__c WHERE Deal_Parent__c = :dealId AND Week__c >= :bundleStartWeek AND XML_Sent__c = FALSE ORDER BY Week__c];
        if(schedules.size() == 0) {
            throw new ApplicationException('No current or future Schedules were found on the Deal. Please make sure there is at least one Schedule, make sure it\'s Week field matches the Deal\'s Bundle Start Week field, and make sure the XML Sent checkbox is not checked.');
        } else if(schedules[0].Week__c != bundleStartWeek) {
            throw new ApplicationException('There is no Schedule that matches the Deal\'s Bundle Start Week field. Please make sure there is a corresponding Schedule that matches the value of that field.');
        }

        List<ScheduleChunkWrapper> scheduleChunks = new List<ScheduleChunkWrapper>();

        // Only one schedule, put it in a wrapper and return it
        if(schedules.size() == 1) {
            scheduleChunks.add(new ScheduleChunkWrapper(schedules[0].Week__c, schedules[0].Week__c.addDays(6), 1, schedules[0].Id));
            return scheduleChunks;
        }

        // Start loop with first schedule record, end of chunk is end of that week (6 days after the start)
        Date currentChunkStart = schedules[0].Week__c;
        Date currentChunkEnd = currentChunkStart.addDays(6);
        Integer currentChunkWeekCount = 1;
        String scheduleIds = schedules[0].Id;

        Integer i = 1;
        do {
            // At each iteration, determine if this schedule is continuous to the previous one.
            //  If it is continuous, simply add 7 to the current chunk's end date and move on.
            //  If not continous, add previous chunk to the list of chunks and start a new one.
            if(schedules[i].Week__c != currentChunkEnd.addDays(1)) {
                scheduleChunks.add(new ScheduleChunkWrapper(currentChunkStart, currentChunkEnd, currentChunkWeekCount, scheduleIds));
                currentChunkStart = schedules[i].Week__c;
                currentChunkEnd = currentChunkStart.addDays(6);
                currentChunkWeekCount = 1;
                scheduleIds = schedules[i].Id;
            } else {
                currentChunkEnd = currentChunkEnd.addDays(7);
                currentChunkWeekCount += 1;
                scheduleIds += ';' + schedules[i].Id;
            }

            i += 1;
        } while(i < schedules.size());

        // Add the final chunk to the list and return
        scheduleChunks.add(new ScheduleChunkWrapper(currentChunkStart, currentChunkEnd, currentChunkWeekCount, scheduleIds));

        return scheduleChunks;
    }

    /**
    * @author Ryan Scott
    * @date 12/02/2015
    * @description Builds a list of one schedule. This is an adapted version of buildScheduleList for creating XML
    *   files using only one specific Schedule record.
    * @param Schedules__c schedule - The Schedule record
    * @return List<ScheduleChunkWrapper> - List of one wrapper object containing the selected Schedule.
    **/
    public static List<ScheduleChunkWrapper> buildSingleScheduleList(Schedules__c schedule) {
        List<ScheduleChunkWrapper> scheduleChunks = new List<ScheduleChunkWrapper>();
        scheduleChunks.add(new ScheduleChunkWrapper(schedule.Week__c, schedule.Week__c.addDays(6), 1, schedule.Id));
        return scheduleChunks;
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Wrapper object for holding a Station's list of Bundle Pricing objects
    * @param String callLetter - The call letters of the Station (example: WMUR)
    * @param String marketName - The market name of the Station (example: Rochester)
    **/
    public class StationWrapper {
        public String callLetters {get; set;}
        public String marketName {get; set;}
        public List<Bundle_Pricing__c> pricingList {get; set;}

        public StationWrapper(String callLetters, String marketName) {
            this.callLetters = callLetters;
            this.marketName = marketName;
            this.pricingList = new List<Bundle_Pricing__c>();
        }
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Groups a list of Bundle Pricing records by Station into a list of StationWrappers.
    * @param List<Bundle_Pricing__c> bundlePricingList - List of Bundle Pricing records
    * @return Map<String, StationWrapper> - A map containing the StationWrapper list
    *   Key: Call letters of the Station
    *   Value: StationWrapper object containing a Station's list of Bundle Pricing records
    **/
    public static Map<String, StationWrapper> buildStationList(List<Bundle_Pricing__c> bundlePricingList) {
        Map<String, StationWrapper> stations = new Map<String, StationWrapper>();

        for(Bundle_Pricing__c bp : bundlePricingList) {
            if(stations.containsKey(bp.Call_Letters__c)) {
                stations.get(bp.Call_Letters__c).pricingList.add(bp);
            } else {
                StationWrapper station = new StationWrapper(bp.Call_Letters__c, bp.Station__r.Market__r.Name);
                station.pricingList.add(bp);
                stations.put(bp.Call_Letters__c, station);
            }
        }

        return stations;
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Generates XML data for a Deal's Station using Schedule and Station data that has previously been collected into wrapper objects.
    * @param Deal__c deal - Record selected for XML generating
    * @param List<ScheduleChunkWrapper> scheduleChunks - List of continuously scheduled chunks
    * @param StationWrapper station - StationWrapper object containing the Station's list of Bundle Pricing records
    * @param String orderId - String to be used for the Order Id attribute. Example: Deal Name or Schedule Name
    * @return String - Body content of XML document in plaintext
    **/
    public static String generateXml(Deal__c deal, List<ScheduleChunkWrapper> scheduleChunks, StationWrapper station, String orderId) {
        // Formulate specific timestamp format for document
        // If running a unit test, must set a specific timestamp for validation
        String timestamp = Datetime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        if(Test.isRunningTest()) {
            timestamp = Datetime.newInstanceGmt(2000, 1, 1).formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        }

        // Begin forming the body of the XML document, using variables where necessary
        String body = '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<tvo:CreateOrderRequest serviceName="CreateOrder" originatingTradingPartner="00000000-0000-0000-0000-000000000000" messageExpiration="' + timestamp + '" timestamp="' + timestamp + '" messageVersion="3.2" destinationTradingPartner="00000000-0000-0000-0000-000000000000" serviceInstanceId="00000000-0000-0000-0000-000000000000" mediaType="SpotTV" messageId="00000000-0000-0000-0000-000000000000" serviceVersion="3.2" targetEnvironment="PRODUCTION" isRetransmission="False" d1p1:schemaLocation="http://www.tvb.org/schema/TVB_OrderCommon TVB_CreateOrderRequest_3.2.xsd" xmlns:tvo="http://www.tvb.org/schema/TVB_OrderCommon" xmlns:tvc="http://www.tvb.org/schema/TVB_Common" xmlns:tvm="http://www.tvb.org/schema/TVB_MediaCommon" xmlns:d1p1="http://www.w3.org/2001/XMLSchema-instance">\n\n';

        body += '<tvo:Order orderVersion="1" orderStatus="New" orderId="' + orderId + '">\n' +
            '<tvo:OrderIdReferences>\n' +
            '<tvc:SourceCode source="Agency">National</tvc:SourceCode>\n' +
            '<tvc:SourceCode source="Rep"></tvc:SourceCode>\n' +
            '</tvo:OrderIdReferences>\n\n';

        body += '<tvo:AltOrderIdReferences>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvo:AltOrderIdReferences>\n\n';

        body += '<tvo:OrderType>Normal</tvo:OrderType>\n' +
            '<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>\n\n';

        body += '<tvm:Advertiser>\n' +
            '<tvc:CompanyName>' + stringFormatter(deal.Advertiser__c) + '</tvc:CompanyName>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvm:Advertiser>\n\n';

        body += '<tvm:Product>\n' +
            '<tvm:ProductName>' + stringFormatter(deal.Brands__r.Name) + '</tvm:ProductName>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvm:Product>\n\n';

        body += '<tvm:Agency>\n' +
            '<tvc:CompanyName>' + deal.ContactAccount__c + ' c/o Marathon</tvc:CompanyName>\n' +
            '<tvc:Address addressRole="Billing">\n' +
            '<tvc:Street1>675 Third Avenue, 11th Floor</tvc:Street1>\n' +
            '<tvc:City>New York</tvc:City>\n' +
            '<tvc:RegionCode>NY</tvc:RegionCode>\n' +
            '<tvc:PostalCode>10017</tvc:PostalCode>\n' +
            '<tvc:CountryCode></tvc:CountryCode>\n' +
            '</tvc:Address>\n\n';

        body += '<tvc:Contact contactRole="Buyer">\n' +
            '<tvc:PersonFirstName>Tania</tvc:PersonFirstName>\n' +
            '<tvc:PersonLastName>Bonetti</tvc:PersonLastName>\n' +
            '<tvc:Email></tvc:Email>\n' +
            '<tvc:Phone></tvc:Phone>\n' +
            '</tvc:Contact>\n\n';

        body += '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '<tvc:Office>\n' +
            '<tvc:OfficeName>' + deal.ContactAccount__c + ' c/o Marathon</tvc:OfficeName>\n' +
            '<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvc:Office>\n' +
            '</tvm:Agency>\n\n';

        body += '<tvm:Estimate>\n' +
            '<tvc:SourceCode source="Agency">National</tvc:SourceCode>\n' +
            '</tvm:Estimate>\n\n';

        body += '<tvm:Seller>\n' +
            '<tvm:StationSeller>\n' +
            '<tvc:CompanyName>' + station.callLetters + ' - ' + station.marketName + ' - ' + deal.Program__r.Bundle_Name__c + '</tvc:CompanyName>\n' +
            '<tvc:Contact contactRole="AccountExec">\n' +
            '<tvc:PersonFirstName>' + deal.Program__r.Logs_Contact__r.FirstName + '</tvc:PersonFirstName>\n' +
            '<tvc:PersonLastName>' + deal.Program__r.Logs_Contact__r.LastName + '</tvc:PersonLastName>\n' +
            '<tvc:Email></tvc:Email>\n' +
            '<tvc:Phone></tvc:Phone>\n' +
            '</tvc:Contact>\n' +
            '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '<tvc:Office>\n' +
            '<tvc:OfficeName>Marathon</tvc:OfficeName>\n' +
            '<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvc:Office>\n' +
            '</tvm:StationSeller>\n' +
            '</tvm:Seller>\n\n';

        body += '<tvo:LocalNational>National</tvo:LocalNational>\n' +
            '<tvm:station>\n' +
            '<tvm:FCCCallLetters>' + station.callLetters + '</tvm:FCCCallLetters>\n' +
            '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvm:station>\n\n';

        // Generate buyline content and calculate Order Total
        List<String> buylineResponse = generateBuylineXml(deal, scheduleChunks, station);
        Decimal orderTotal = Decimal.valueOf(buylineResponse[0]).setScale(2);

        // Start date here is determined by the start date of the first schedule chunk
        // End date is the end date of the last schedule chunk in the list
        body += '<tvc:StartDate>' + scheduleChunks[0].chunkStart + '</tvc:StartDate>\n' +
            '<tvc:EndDate>' + scheduleChunks[scheduleChunks.size()-1].chunkEnd + '</tvc:EndDate>\n' +
            '<tvo:OrderGrossAmount>' + orderTotal + '</tvo:OrderGrossAmount>\n' +
            '<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>\n' +
            '<tvo:BillingCycle>Monthly</tvo:BillingCycle>\n' +
            '<tvm:PrimaryDemoCategory demoId="DM0" />\n' +
            '<tvm:DemoCategory demoId="DM0">\n' +
            '<tvm:DemoGroup>Adults</tvm:DemoGroup>\n' +
            '<tvm:DemoLowerAge>18</tvm:DemoLowerAge>\n' +
            '<tvm:DemoUpperAge>99</tvm:DemoUpperAge>\n' +
            '</tvm:DemoCategory>\n' +
            '<tvc:Comment source="Agency"></tvc:Comment>\n\n';

        // Add the buyline content that was retrieved above
        body += buylineResponse[1];

        // Close the XML document and return
        body += '</tvo:Order>\n' +
            '</tvo:CreateOrderRequest>\n';

        return body;
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Generates the Buyline section of the XML document. This is called by the generateXml function and returns the Buyline
    *   section to be inserted into the rest of the XML body.
    * @param Deal__c deal - Record selected for XML generating
    * @param List<ScheduleChunkWrapper> scheduleChunks - List of continuously scheduled chunks
    * @param StationWrapper station - StationWrapper object containing the Station's list of Bundle Pricing records
    * @return List<String> - Contains 2 items: Order Total and Buyline content of XML document in plaintext
    **/
    public static List<String> generateBuylineXml(Deal__c deal, List<ScheduleChunkWrapper> scheduleChunks, StationWrapper station) {
        Decimal orderTotal = 0;
        List<Schedules__c> schhh = [SELECT Units_Available__c, Week__c FROM Schedules__c WHERE Deal_Parent__r.Id = :deal.Id];
        Schedules__c cscs = schhh[0];
        Integer totalUnits = 0;

        for(Schedules__c sche : schhh) {
            totalUnits += Integer.valueOf(sche.Units_Available__c);
        }
            
        // Open Buyline section
        String body = '<tvo:Buylines>\n\n';

        // A Buyline item must be generated for each Bundle Pricing record in each chunk of continous schedule
        Integer count = 1;
        for(ScheduleChunkWrapper scheduleChunk : scheduleChunks) {
            for(Bundle_Pricing__c bp : station.pricingList) {
                Integer units = Integer.valueOf(bp.Units__c) * totalUnits;
                Decimal rate = (bp.Rate_per_30__c * Integer.valueOf(deal.Length__c) / 30).setScale(2);
                Decimal total = (units * rate).setScale(2);

                orderTotal += total;

                body += '<tvo:SpotBuyline buylineNumber="' + count + '" buylineVersion="1" buylineStatus="New">\n' +
                '<tvo:BuylineIdReferences>\n' +
                '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
                '</tvo:BuylineIdReferences>\n\n';

                body += '<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n' +
                '<tvo:BuylineDescription>Sign-On/Sign-Off</tvo:BuylineDescription>\n' +
                '<tvc:StartDate>' + scheduleChunk.chunkStart + '</tvc:StartDate>\n' +
                '<tvc:EndDate>' + scheduleChunk.chunkEnd + '</tvc:EndDate>\n' +
                '<tvo:BuylineQuantity unitType="Spot">' + units + '</tvo:BuylineQuantity>\n' +
                '<tvo:BuylineUnitRate costModel="Unit">' + rate + '</tvo:BuylineUnitRate>\n' +
                '<tvo:BuylineGrossAmount>' + total + '</tvo:BuylineGrossAmount>\n' +
                '<tvc:Comment source="Agency"></tvc:Comment>\n' +
                '<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n' +
                '<tvo:SpotLength>' + deal.Length__c + '</tvo:SpotLength>\n' +
                '<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n\n';

                body += '<tvo:ContractInterval>\n';

                // List of valid days is determined using the picklist field Days__c on the Bundle Pricing record
                // Loop through each day of the week and print Valid/Invalid based on the picklist values
                List<String> days = new List<String> {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'};
                for(String day : days) {
                    if(bp.Days__c.contains(day)) {
                        body += '<tvm:' + day + 'Valid>True</tvm:' + day + 'Valid>\n';
                    } else {
                        body += '<tvm:' + day + 'Valid>False</tvm:' + day + 'Valid>\n';
                    }
                }

                body += '<tvc:StartTime>' + civilianToMilitaryTime(bp.Start_Time__c) + '</tvc:StartTime>\n' +
                '<tvc:EndTime>' + civilianToMilitaryTime(bp.End_Time__c) + '</tvc:EndTime>\n' +
                '</tvo:ContractInterval>\n\n';

                body += generateWeeklyBuy(scheduleChunk, bp, schhh);

                count += 1;
            }
        }

        // Close the buyline section, pack it up with the Order Total and return
        body += '</tvo:Buylines>\n';
        
        return new List<String> {String.valueOf(orderTotal), body};
    }

    /**
    * @author Adrian Pichardo
    * @date 09/13/2018
    * @description Formats string to replace symbols with spaces (!@#&..etc.)
    * @param String fieldtext - represents the field taken from salesforce
    * @return String - new string that had all symbols removed
    **/
    public static String stringFormatter(String fieldtext) {
        String target = '&';
        String replacement = 'and';
        String goal = fieldtext.replace(target, replacement);

        return goal;
    }
    
    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Converts a specifically formatted timestring to military time. Expects the format outlined below,
    *   any other format will receive an error response.
    * @param String timeStr - String containing a time, examples: '11:00A' or '2:30P'
    * @return String - Time string in miliary format, examples: '11:00' or '14:30P'. An error is returned if the input
    *   could not be converted.
    **/
    public static String civilianToMilitaryTime(String timeStr) {
        try {
            if(timeStr == '12:00A') {
                return '00:00';
            } else if(timeStr.startsWith('12') && timeStr.endsWith('A')) {
                timeStr = timeStr.removeEnd('A');
                List<String> timePieces = timeStr.split(':');
                timeStr = '00:' + timePieces[1];
                return timeStr;
            } else if(timeStr == '12:00P') {
                return '12:00';
            } else if(timeStr.startsWith('12') && timeStr.endsWith('P')) {
                timeStr = timeStr.removeEnd('P');
                List<String> timePieces = timeStr.split(':');
                timeStr = '12:' + timePieces[1];
                return timeStr;
            } else if(timeStr.endsWith('A')) {
                return timeStr.removeEnd('A');
            } else {
                timeStr = timeStr.removeEnd('P');
                List<String> timePieces = timeStr.split(':');
                timeStr = String.valueOf(Integer.valueOf(timePieces[0]) + 12) + ':' + timePieces[1];
                return timeStr;
            }
        } catch(Exception e) {
            return 'Error: Invalid time string';
        }
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * @description Saves data as an attachment on a record. Used specifically for saving a zip file generated on HearstXMLBundle.page
    *   to a selected Deal record.
    * @param String recordId - Record Id to attach the data to
    * @param String filename - Filename of the attachment
    * @param String data - Base64-encoded data, will be decoded and saved
    * @return String - 'SUCCESS' if attachment was saved, or the error message if failed
    **/
    @RemoteAction
    public static String saveData(String recordId, String filename, String data) {
        try {
            Attachment att = new Attachment();
            att.Name = filename;
            att.Body = EncodingUtil.base64Decode(data);
            att.ParentId = recordId;

            insert att;

            return 'SUCCESS';
        } catch(Exception e) {
            return e.getMessage();
        }
    }

    /**
    * @author Ryan Scott
    * @date 12/18/2015
    * @description Set the XML Sent checkbox field on the list of Schedules to true
    * @param String scheduleIds - List of Schedule Ids separated by semicolons
    * @return String - 'SUCCESS' if records were updated successfully, or the error message if failed
    **/
    @RemoteAction
    public static String markXMLSent(String scheduleIds) {
        try {
            List<Id> scheduleIdList = scheduleIds.split(';');

            List<Schedules__c> schedules = [SELECT Id, XML_Sent__c FROM Schedules__c WHERE Id IN :scheduleIdList];
            for(Schedules__c schedule : schedules) {
                schedule.XML_Sent__c = true;
            }
            update schedules;

            return 'SUCCESS';
        } catch(Exception e) {
            return e.getMessage();
        }
    }

    /**
    * @author Adrian Pichardo
    * @date 10/4/2018
    * @description Generates the weekly Buyline section of the XML document. 
    * @param ScheduleChunkWrapper item - List of continuously scheduled chunks
    * @param Bundle_Pricing__c bpunits - Units listed on the bundlepricing unit (For list)
    * @return List<Schedules__c> - List of Schedules being processed.
    **/
    public static String generateWeeklyBuy(ScheduleChunkWrapper item, Bundle_Pricing__c bpunits, List<Schedules__c> schlist) {
        String weekBody = '';        
        /**
          * Take duolicate units aired list and adds it to a set so that every index is unique. 
          * Every new integer will be a new repition of the weekly buy.
          **/
        Set<Integer> uniqueUnits = new Set<Integer>();
        //List<Integer> duplicates = new List<Integer>();
        for(Integer i = 0; i < schlist.size(); i++){
            Integer aired = Integer.valueOf(schlist[i].Units_Available__c);
            uniqueUnits.add(aired);
        }

        for(Integer u : uniqueUnits){
            List<Schedules__c> uniqueList = new List<Schedules__c>();
            for(Integer w = 0; w < schlist.size(); w++){
                Integer unitCheck = Integer.valueOf(schlist[w].Units_Available__c);
                if(u == unitCheck){
                    uniqueList.add(schlist[w]);
                }
            }
			
            uniqueList.sort();
            Integer listLength = uniqueList.size();
            
            String startWeek = uniqueList[0].Week__c.year() + '-' + padIntegerWithLeadingZero(uniqueList[0].Week__c.month()) + '-' + padIntegerWithLeadingZero(uniqueList[0].Week__c.day());
			String finalWeek = uniqueList[listLength - 1].Week__c.addDays(6).year() + '-' + padIntegerWithLeadingZero(uniqueList[listLength - 1].Week__c.addDays(6).month()) + '-' + padIntegerWithLeadingZero(uniqueList[listLength - 1].Week__c.addDays(6).day());
                
            weekBody += '<tvo:WeeklySpotDistribution>\n' +
                '<tvc:StartDate>' + startWeek + '</tvc:StartDate>\n' +
                '<tvc:EndDate>' + finalWeek + '</tvc:EndDate>\n' +
                '<tvo:SpotPerWeekQuantity>' + Integer.valueOf(bpunits.Units__c) * u + '</tvo:SpotPerWeekQuantity>\n';

                // List of valid days is determined using the picklist field Days__c on the Bundle Pricing record
                // Loop through each day of the week and print Valid/Invalid based on the picklist values
                List<String> days = new List<String> {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'};
                for(String day : days) {
                    if(bpunits.Days__c.contains(day)) {
                        weekBody += '<tvm:' + day + 'Valid>True</tvm:' + day + 'Valid>\n';
                    } else {
                        weekBody += '<tvm:' + day + 'Valid>False</tvm:' + day + 'Valid>\n';
                    }
                }

                weekBody += '</tvo:WeeklySpotDistribution>\n' +
                '</tvo:SpotBuyline>\n\n';

        }

        return weekBody;
    }

}