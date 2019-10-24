public with sharing class OSIxml {

    private static ScheduleSelector scheduleSelector = new ScheduleSelector();

    public static void setScheduleSelector(ScheduleSelector sSelector){
        scheduleSelector = sSelector;
    }

    /**
    * @author Adrian Pichardo
    * @date 11/03/2017
    * @description Used for manually throwing errors back to the Visualforce page.
    *   Usage: throw new ApplicationException('This is the error message');
    **/
    public class ApplicationException extends Exception {}

    /**
    * @author Adrian Pichardo
    * @date 12/02/2017
    * @description Primary function that initiates XML document generation for a Deal record which can be processed through OSI.
    *   The Deal must have a Program and Schedule(s) linked to it.
    * @param String dealId - Record Id of the selected Deal
    * @param String scheduleId - Record Id of a specific Schedule. This is optional and if included then the XML files will be generated
    *   using only that one specific Schedule.
    * @return Map<String, String> - A map containing the XML body of each file that was generated.
    *   Key: Filename
    *   Value: Base64-encoded XML body content
    *   The map also includes a list of Schedules that were used, with the key 'scheduleIds'. The list contained record Ids separated by semicolons.
    **/
    @RemoteAction
    public static Map<String, String> getXMLFiles(String dealId, String scheduleId) {
        // Setup map to contain all results from this method. Will contain the generated XML files and a list of Schedules that were used in the process.
        Map<String, String> resultsData = new Map<String, String>();

        // Get the deal and fields using the passed variable
        Deal__c deal = scheduleSelector.getSchedulesForGetXMLFiles(dealId);
        System.debug(deal);
        if(deal.Advertiser__c == null) {
            throw new ApplicationException('The Advertiser lookup is missing from the Deal. Please add an Advertiser and try again.');
        }
        if(deal.Brands__r.Name == null) {
            throw new ApplicationException('The Brand Name value is empty. Please make sure that the Deal has a Brand connected to it and try again.');
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
            System.debug('FIND ME: ' + orderId );
        }

        // Generate the XML data for the deal
        String body = generateXML(deal, orderId);

        String contactAccount = deal.ContactAccount__c.replaceAll('/', '');
        String brand = deal.Brands__r.Name.replaceAll('/', '');

        String filename = '-';
        Date d = Date.today();
        filename += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '-' + orderId + '.xml';

        resultsData.put(filename, EncodingUtil.base64Encode(Blob.valueOf(body)));

        return resultsData;
    }

    /**
    * @author Ryan Scott
    * @date 11/02/2015
    * DO NOT USE for this class
    **/
    public class ScheduleChunkWrapper {
        public String chunkStart {get; set;}
        public String chunkEnd {get; set;}
        public Integer weekCount {get; set;}
        public String scheduleIds {get; set;}

        public ScheduleChunkWrapper(Date chunkStart, Date chunkEnd, Integer weekCount, String scheduleIds) {
            this.chunkStart = chunkStart.year() + '-' + Utils.padIntegerWithLeadingZero(chunkStart.month()) + '-' + Utils.padIntegerWithLeadingZero(chunkStart.day());
            this.chunkEnd = chunkEnd.year() + '-' + Utils.padIntegerWithLeadingZero(chunkEnd.month()) + '-' + Utils.padIntegerWithLeadingZero(chunkEnd.day());
            this.weekCount = weekCount;
            this.scheduleIds = scheduleIds;
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
        List<Schedules__c> schedules = scheduleSelector.getSchedulesForbuildScheduleList(dealId, bundleStartWeek);
        if(schedules.size() == 0) {
            throw new ApplicationException('No current or future Schedules were found on the Deal. Please make sure there is at least one Schedule, make sure it\'s Week field matches the Deal\'s Bundle Start Week field, and make sure the XML Sent checkbox is not checked.');
        } //else if(schedules[0].Week__c != bundleStartWeek) {
        //  throw new ApplicationException('There is no Schedule that matches the Deal\'s Bundle Start Week field. Please make sure there is a corresponding Schedule that matches the value of that field.');
        //}

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
    * @author Adrian Pichardo
    * @date 11/02/2017
    * @description Generates XML data for a Deal
    * @param Deal__c deal - Record selected for XML generating
    * @param String orderId - String to be used for the Order Id attribute. Example: Deal Name or Schedule Name
    * @return String - Body content of XML document in plaintext
    **/
    public static String generateXML(Deal__c deal, String orderId) {

        String timestamp = DateTime.now().formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        Datetime weekmin = deal.Week_MIN_Field__c.addDays(1);
        Datetime weekmax = deal.Week_Max__c.addDays(7);
        String wkmin = weekmin.format('yyyy-MM-dd');
        String wkmax = weekmax.format('yyyy-MM-dd');

        String log = '<?xml version="1.0" encoding="UTF-8"?>\n' +
                '<tvo:CreateOrderRequest serviceName="CreateOrder" originatingTradingPartner="00000000-0000-0000-0000-000000000000" messageExpiration="' + timestamp + '" timestamp="' + timestamp + '" messageVersion="3.2" destinationTradingPartner="00000000-0000-0000-0000-000000000000" serviceInstanceId="00000000-0000-0000-0000-000000000000" mediaType="SpotTV" messageId="00000000-0000-0000-0000-000000000000" serviceVersion="3.2" targetEnvironment="PRODUCTION" xmlns:tvc="http://www.tvb.org/schema/TVB_Common" xmlns:tvm="http://www.tvb.org/schema/TVB_MediaCommon" xmlns:ord="http://www.tvb.org/schema/TVB_OrderCommon" xmlns:tvo="http://www.tvb.org/schema/TVB_OrderCommon">\n';

        log += '<tvo:Order orderVersion="1" orderStatus="New" orderId="' + orderId + '">\n' +
                '<tvo:OrderIdReferences>\n' +
                '<tvc:SourceCode source="Agency">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n' +
                '</tvo:OrderIdReferences>\n';

        log += '<tvo:OrderType>Normal</tvo:OrderType>\n' +
                '<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>\n';

        log += '<tvm:Advertiser>\n' +
                '<tvc:CompanyName>'+ stringFormatter(deal.Advertiser__c) + '</tvc:CompanyName>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvm:Advertiser>\n';

        log += '<tvm:Product>\n' +
                '<tvm:ProductName>' + stringFormatter(deal.Brands__r.Name) + '</tvm:ProductName>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvm:Product>\n';

        log += '<tvm:Agency>\n' +
                '<tvc:CompanyName>' + stringFormatter(deal.ContactAccount__c) + '</tvc:CompanyName>\n' +
                '<tvc:Contact>\n' +
                '<tvc:PersonFirstName> Tania </tvc:PersonFirstName>\n' +
                '<tvc:PersonLastName> Bonetti </tvc:PersonLastName>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvc:Contact>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '<tvc:Office>\n' +
                '<tvc:OfficeName>' + stringFormatter(deal.ContactAccount__c) + ' c/o Marathon</tvc:OfficeName>\n' +
                '<tvc:Phone>\n' +
                '<tvc:AreaCityCode>646</tvc:AreaCityCode>\n' +
                '<tvc:PhoneNumber>4487080</tvc:PhoneNumber>\n' +
                '</tvc:Phone>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvc:Office>\n' +
                '</tvm:Agency>\n';

        log += '<tvm:Estimate>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvm:Estimate>\n' +
                '<tvm:Seller>\n' +
                '<tvm:StationSeller>\n' +
                '<tvc:CompanyName>the Stadium Network</tvc:CompanyName>\n' +
                '<tvc:Contact contactRole="AccountExec">\n' +
                '<tvc:PersonFirstName>Stadium-Marathon</tvc:PersonFirstName>\n' +
                '<tvc:PersonLastName>Stadium-Marathon</tvc:PersonLastName>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvc:Contact>\n' +
                '<tvc:SourceCode source="Other">None</tvc:SourceCode>\n' +
                '</tvm:StationSeller>\n' +
                '</tvm:Seller>\n' +
                '<tvo:LocalNational>Local</tvo:LocalNational>\n' +
                '<tvm:Station stationId="ST1" tradingPartnerId="00000000-0000-0000-0000-000000000000">\n' +
                '<tvm:FCCCallLetters>SOTA</tvm:FCCCallLetters>\n' +
                '<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n' +
                '<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n' +
                '</tvm:Station>\n' +
                '<tvc:StartDate>' + wkmin + '</tvc:StartDate>\n' +
                '<tvc:EndDate>' + wkmax + '</tvc:EndDate>\n' +
                '<tvo:OrderGrossAmount>' + deal.Sum_of_Total_Dollars__c + '</tvo:OrderGrossAmount>\n' +
                '<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>\n' +
                '<tvo:BillingCycle>Monthly</tvo:BillingCycle>\n' +
                '<tvm:DemoCategory demoId="DM1">\n' +
                '<tvm:DemoGroup>Adults</tvm:DemoGroup>\n' +
                '<tvm:DemoLowerAge>18</tvm:DemoLowerAge>\n' +
                '<tvm:DemoUpperAge>99</tvm:DemoUpperAge>\n' +
                '</tvm:DemoCategory>\n\n';

        log += '<tvo:Buylines>\n';
        log += generateBuylines(deal);
        log += '</tvo:Buylines>\n' +
                '</tvo:Order>\n' +
                '</tvo:CreateOrderRequest>';

        return log;
    }

    /**
    * @author Adrian Pichardo
    * @date 11/02/2017
    * @description Generates buylines for the XML data for a Deal
    * @param Deal__c deal - Record selected for XML generating
    * @return String - Body content of XML document in plaintext
    **/
    public static String generateBuylines(Deal__c deal){
        List<Schedules__c> dsescheds = new List<Schedules__c>();
        List<Schedules__c> schedList = scheduleSelector.getSchedulesForgenerateBuylines(deal);
        Integer pt = schedList.size();

        //for schedules - concatenate Days allowed, start time, end time
        //based on the concatenation created; build lists based off of them

        dsescheds.add(schedList[0]);
        for(Integer i = 0; i < pt; i++){
            Integer wall = 0;
            Integer size = dsescheds.size();
            for(Integer j = 0; j < size; j++){
                if(schedList[i].OrderLineNumber__c == dsescheds[j].OrderLineNumber__c){
                    wall++;
                }
            }
            if(wall == 0){
                dsescheds.add(schedList[i]);
            }
        }

        if(dsescheds.isEmpty()) {
            throw new ApplicationException('Empty');
        }

        String buylines = '';
        Integer cont = 1;
        for(Schedules__c dsesched : dsescheds) {
            if(dsesched.Days_Allowed__c == null){
                throw new ApplicationException('Missing Days Allowed dse');
            }
            if(dsesched.Start_Time__c == null){
                throw new ApplicationException('Missing Start Time');
            }
            if(dsesched.End_Time__c == null){
                throw new ApplicationException('Missing End Time');
            }
            buylines += generateWeeklyBuy(dsesched, deal, cont);
            cont += 1;
        }

        return buylines;
    }


    /**
    * @author Adrian Pichardo
    * @date 11/02/2017
    * @description Generates XML data for a Deal
    * @param Deal__c deal - Record selected for XML generating
    * @param String orderId - String to be used for the Order Id attribute. Example: Deal Name or Schedule Name
    * @return String - Body content of XML document in plaintext
    **/
    public static String generateWeeklyBuy(Schedules__c ddd, Deal__c deal, Integer count){
        Date minWeek = deal.Week_MIN_Field__c;

        List<Schedules__c> schedules = scheduleSelector.GetSchedulesForGenerateWeeklyBuy(deal, minWeek);
        List<Schedules__c> success = new List<Schedules__c>();

        if(schedules.isEmpty()) {
            throw new ApplicationException('Empty schedule list');
        }

        for(Schedules__c schedule : schedules){
            Boolean weekMissing = schedule.Week__c == null;
            if(schedule.Week__c == null){
                throw new ApplicationException('Empty Week');
            }
            if(schedule.Rate__c == null){
                throw new ApplicationException('Rate is null');
            }
            if(schedule.UnitLength__c == null){
                throw new ApplicationException('Length is null');
            }
            if(schedule.Units_Available__c == null){
                throw new ApplicationException('UA is null');
            }
            if(schedule.Days_Allowed__c == null){
                throw new ApplicationException('Days Allowed is null');
            }
            if(schedule.Start_Time__c == null){
                throw new ApplicationException('Start Time is null');
            }
            if(schedule.End_Time__c == null){
                throw new ApplicationException('End Time is null');
            }

        }

        for(Schedules__c schedule : schedules){
            if((schedule.Rate__c == ddd.Rate__c) && (schedule.Days_Allowed__c == ddd.Days_Allowed__c) && (schedule.Start_Time__c == ddd.Start_Time__c) && (schedule.End_Time__c == ddd.End_Time__c)){
                success.add(schedule);
                //first entity is first week, last entity is last week.
            }
        }

        if(success.isEmpty()) {
            throw new ApplicationException('Empty successful schedules');
        }

        for(Schedules__c scs : success){
            if(scs.Week__c == null){
                throw new ApplicationException('Empty Week');
            }
            if(scs.Rate__c == null){
                throw new ApplicationException('Rate is null');
            }
            if(scs.UnitLength__c == null){
                throw new ApplicationException('Length is null');
            }
            if(scs.Units_Available__c == null){
                throw new ApplicationException('UA is null');
            }
            if(scs.Days_Allowed__c == null){
                throw new ApplicationException('Days Allowed is null');
            }
            if(scs.Start_Time__c == null){
                throw new ApplicationException('Start Time is null');
            }
            if(scs.End_Time__c == null){
                throw new ApplicationException('End Time is null');
            }
        }

        Integer i = success.size();
        Datetime wn = success[0].Week__c.addDays(1);
        Datetime wx = success[i-1].Week__c.addDays(7);
        String wk = wn.format('yyyy-MM-dd');
        String wkend = wx.format('yyyy-MM-dd');

        Decimal ratetotal = 0.0;
        Decimal unitstotal = 0.0;
        Decimal t = 0.0;

        for(Schedules__c s : success){
            ratetotal = s.Rate__c;
            unitstotal += s.WO_Units__c;
        }

        t = ratetotal*unitstotal;
        Decimal total = t.setScale(0);

        String bl = '<tvo:SpotBuyline buylineNumber="'+ count +' " buylineVersion="1" buylineStatus="New">\n' +
                '<tvo:BuylineIdReferences>\n' +
                '<tvc:SourceCode source="Agency">1</tvc:SourceCode>\n' +
                '</tvo:BuylineIdReferences>\n' +
                '<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n' +
                '<tvo:BuylineDescription>FL1</tvo:BuylineDescription>\n';
        bl += '<tvc:StartDate>' + wk + '</tvc:StartDate>\n';
        bl += '<tvc:EndDate>' + wkend + '</tvc:EndDate>\n' +
                '<tvo:BuylineQuantity unitType="Spot">' + unitstotal.intValue() + '</tvo:BuylineQuantity>\n' +
                '<tvo:BuylineUnitRate costModel="Fixed">' + ratetotal + '</tvo:BuylineUnitRate>\n' +
                '<tvo:BuylineGrossAmount>' + total + '</tvo:BuylineGrossAmount>\n' +
                '<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n' +
                '<tvo:SpotLength>' + deal.Length__c + '</tvo:SpotLength>\n' +
                '<tvo:BuyerDaypart>' + ddd.Daypart__c + '</tvo:BuyerDaypart>\n' +
                '<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n' +
                '<tvo:ContractInterval>\n';

        List<String> days = new List<String> {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};

        for(String day : days){
            if(ddd.Days_Allowed__c.contains(day)){
                bl += '<tvm:' + weekday(day) + 'Valid>true</tvm:' + weekday(day) + 'Valid>\n';
            } else {
                bl += '<tvm:' + weekday(day) + 'Valid>false</tvm:' + weekday(day) + 'Valid>\n';
            }
        }

        bl += '<tvc:StartTime>' + Utils.civilianToMilitaryTime(ddd.Start_Time__c) + '</tvc:StartTime>\n';
        bl += '<tvc:EndTime>' + Utils.civilianToMilitaryTime(ddd.End_Time__c) + '</tvc:EndTime>\n';
        bl += '</tvo:ContractInterval>\n';

        for(Schedules__c sch : success){
            if(sch.Week__c == null){
                throw new ApplicationException('Missing sch Week');
            }
            if(sch.Units_Available__c == null){
                throw new ApplicationException('Missing sch Units Available');
            }

            Datetime sWkst = sch.Week__c.addDays(1);
            Datetime sWkend = sch.Week__c.addDays(7);
            String sW = sWkst.format('yyyy-MM-dd');
            String sWe = sWkend.format('yyyy-MM-dd');

            bl += '<tvo:WeeklySpotDistribution>\n' +
                    '<tvc:StartDate>' + sW + '</tvc:StartDate>\n' +
                    '<tvc:EndDate>' + sWe + '</tvc:EndDate>\n' +
                    '<tvo:SpotPerWeekQuantity>' + sch.WO_Units__c.intValue() + '</tvo:SpotPerWeekQuantity>\n';

            List<String> dias = new List<String> {'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'};
            for(String dia : dias){
                if(sch.Days_Allowed__c.contains(dia)){
                    bl += '<tvm:' + weekday(dia) + 'Valid>true</tvm:' + weekday(dia) + 'Valid>\n';
                } else {
                    bl += '<tvm:' + weekday(dia) + 'Valid>false</tvm:' + weekday(dia) + 'Valid>\n';
                }
            }
            bl += '</tvo:WeeklySpotDistribution>\n';

        }

        bl+= '<tvo:TargetDemoValue demoId="DM1">\n' +
                '<tvm:RatingPointValue>2.9</tvm:RatingPointValue>\n' +
                '</tvo:TargetDemoValue>\n' +
                '</tvo:SpotBuyline>\n';

        return bl;

    }

    /**
    * @author Adrian Pichardo
    * @date 11/16/2017
    * @description Converts name to thet full name of the abbreviated day
    * @param String name - String containing an abbreviated day in Days_Allowed 
    * @return String - Name of day
    **/
    public static String weekday(String name) {
        if(name.equals('Sun') || name.equals('Mon') || name.equals('Fri')){
            name = name+'day';
        }else if(name.equals('Tue')){
            name = name+'sday';
        }else if(name.equals('Wed')){
            name = name+'nesday';
        }else if(name.equals('Thu')){
            name = name+'rsday';
        }else if(name.equals('Sat')){
            name = name+'urday';
        }
        return name;
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
    * @author Adrian Pichardo
    * @date 11/02/2017
    * @description Saves data as an attachment on a record. Used specifically for saving a zip file generated on OSIXMLDeal.page
    *   to a selected Deal record.
    * @param String recordId - Record Id to attach the data to
    * @param String filename - Filename of the attachment
    * @param String data - Base64-encoded data, will be decoded and saved
    * @return String - 'SUCCESS' if attachment was saved, or the error message if failed
    **/
    @RemoteAction
    public static String markXMLSent(String scheduleIds) {
        try {
            List<Id> scheduleIdList = scheduleIds.split(';');

            List<Schedules__c> schedules = [SELECT Id, XML_Sent__c FROM Schedules__c WHERE Id IN :scheduleIdList];
            for(Schedules__c schedule : schedules) {
                schedule.XML_Sent__c = false;
            }
            update schedules;

            return 'SUCCESS';
        } catch(Exception e) {
            return e.getMessage();
        }
    }

}