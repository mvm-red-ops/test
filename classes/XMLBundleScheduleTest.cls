@isTest
private class XMLBundleScheduleTest {
    
    @isTest static void test_controller() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        Schedules__c schedule = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
        insert schedule;
        schedule = [SELECT Id, Name From Schedules__c WHERE Id = :schedule.Id];

        Deal__c deal = [SELECT Id, Brands__r.Name, ContactAccount__c, Name FROM Deal__c WHERE Id = :td.deal.Id];

        PageReference pageRef = Page.XMLBundleSchedule;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', schedule.Id);

        XMLBundleSchedule controller = new XMLBundleSchedule();

        System.assertEquals(schedule.Id, controller.scheduleId);

        String expectedFileName = 'Hearst-' + schedule.Name + '-' + deal.ContactAccount__c + '-' + deal.Brands__r.Name + '-NEW BUY-';
        System.assert(controller.zipFileName.startsWith(expectedFileName));
    }

    @isTest static void test_saveData() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        Schedules__c schedule = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
        insert schedule;

        // Send bad Schedule Id, insert should fail
        String result = XMLBundleSchedule.saveData('12345', 'filename', 'samplefiledata');
        System.assertNotEquals('SUCCESS', result);

        List<Attachment> att = [SELECT Id, Name, ParentId FROM Attachment];
        System.assertEquals(0, att.size());

        // Send valid Schedule Id, everything works as expected
        result = XMLBundleSchedule.saveData(schedule.Id, 'HearstBundle.zip', 'samplefiledata');
        System.assertEquals('SUCCESS', result);

        att = [SELECT Id, Name, ParentId FROM Attachment];
        System.assertEquals(1, att.size());
        System.assertEquals(schedule.Id, att[0].ParentId);
        System.assertEquals('HearstBundle.zip', att[0].Name);
    }

    @isTest static void test_markXMLSent() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        // Insert single schedule and verify
        List<Schedules__c> schedules = new List<Schedules__c>();
        Schedules__c s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
        schedules.add(s);
        insert schedules;

        String result = XMLBundleSchedule.markXMLSent(schedules[0].Id);
        System.assertEquals('SUCCESS', result);
        s = [SELECT XML_Sent__c FROM Schedules__c WHERE Id = :schedules[0].Id];
        System.assertEquals(true, s.XML_Sent__c);

        // Insert 3 more schedules and verify
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 12));
        schedules.add(s);
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 19));
        schedules.add(s);
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 11, 9));
        schedules.add(s);
        upsert schedules;

        List<String> scheduleIds = new List<String>();
        for(Schedules__c schedule : schedules) {
            scheduleIds.add(schedule.Id);
        }

        result = XMLBundleSchedule.markXMLSent(String.join(scheduleIds, ';'));
        System.assertEquals('SUCCESS', result);

        schedules = [SELECT XML_Sent__c FROM Schedules__c WHERE Id IN :scheduleIds];
        for(Schedules__c schedule : schedules) {
            System.assertEquals(true, schedule.XML_Sent__c);
        }

        // Test with an invalid Id
        result = XMLBundleSchedule.markXMLSent('12345');
        System.assertNotEquals('SUCCESS', result);
    }

    // Run through the whole XML generating process
    @isTest static void test_getXMLFiles() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        Schedules__c schedule = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
        insert schedule;
        schedule = [SELECT Id, Name FROM Schedules__c WHERE Id = :schedule.Id];

        td.createNewStation('Manchester', 'WMUR');

        Bundle_Pricing__c bp = new Bundle_Pricing__c(
            Program__c = td.program.Id,
            Station__c = td.station.Id,
            Days__c = 'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday',
            End_Time__c = '6:00A',
            Rate_per_30__c = 15,
            Start_Time__c = '1:00A',
            Units__c = 2,
            Active__c = true
        );
        insert bp;

        // Check result
        Map<String, String> result = XMLBundleSchedule.getXMLFiles(td.deal.Id, schedule.Id);
        System.assertEquals(2, result.keySet().size());

        // Generate correct filenames and assert
        String baseFileName = '-' + td.deal.Name + '-Test Account-Test Brand-NEW BUY-';
        Date d = Date.today();
        baseFileName += d.year();
        if(d.month() > 9) {
            baseFileName += '-' + d.month();
        } else {
            baseFileName += '-0' + d.month();
        }

        if(d.day() > 9) {
            baseFileName += '-' + d.day();
        } else {
            baseFileName += '-0' + d.day();
        }
        baseFileName += '.xml';

        String filename = 'WMUR' + baseFileName;

        System.assert(result.containsKey(filename));

        Map<String, String> expectedResult = getXMLFilesResults(schedule.Name);
        //System.debug(callLetters + ': ' + result.get(callLetters));
        System.assertEquals(expectedResult.get(filename.substring(0, 4)), EncodingUtil.base64Decode(result.get(filename)).toString());
        System.assertEquals(schedule.Id, result.get('scheduleIds'));
    }

    // Example response bodies for the XML files
    static Map<String, String> getXMLFilesResults(String orderId) {
        Map<String, String> results = new Map<String, String>();

        String body = '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<tvo:CreateOrderRequest serviceName="CreateOrder" originatingTradingPartner="00000000-0000-0000-0000-000000000000" messageExpiration="2000-01-01T00:00:00.000Z" timestamp="2000-01-01T00:00:00.000Z" messageVersion="3.2" destinationTradingPartner="00000000-0000-0000-0000-000000000000" serviceInstanceId="00000000-0000-0000-0000-000000000000" mediaType="SpotTV" messageId="00000000-0000-0000-0000-000000000000" serviceVersion="3.2" targetEnvironment="PRODUCTION" isRetransmission="False" d1p1:schemaLocation="http://www.tvb.org/schema/TVB_OrderCommon TVB_CreateOrderRequest_3.2.xsd" xmlns:tvo="http://www.tvb.org/schema/TVB_OrderCommon" xmlns:tvc="http://www.tvb.org/schema/TVB_Common" xmlns:tvm="http://www.tvb.org/schema/TVB_MediaCommon" xmlns:d1p1="http://www.w3.org/2001/XMLSchema-instance">\n' +
            '\n' +
            '<tvo:Order orderVersion="1" orderStatus="New" orderId="' + orderId + '">\n' +
            '<tvo:OrderIdReferences>\n' +
            '<tvc:SourceCode source="Agency">National</tvc:SourceCode>\n' +
            '<tvc:SourceCode source="Rep"></tvc:SourceCode>\n' +
            '</tvo:OrderIdReferences>\n' +
            '\n' +
            '<tvo:AltOrderIdReferences>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvo:AltOrderIdReferences>\n' +
            '\n' +
            '<tvo:OrderType>Normal</tvo:OrderType>\n' +
            '<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>\n' +
            '\n' +
            '<tvm:Advertiser>\n' +
            '<tvc:CompanyName>TestAdvertiser(M)</tvc:CompanyName>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvm:Advertiser>\n' +
            '\n' +
            '<tvm:Product>\n' +
            '<tvm:ProductName>Test Brand</tvm:ProductName>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvm:Product>\n' +
            '\n' +
            '<tvm:Agency>\n' +
            '<tvc:CompanyName>Marathon Ventures (Comm)</tvc:CompanyName>\n' +
            '<tvc:Address addressRole="Billing">\n' +
            '<tvc:Street1>675 Third Avenue, 11th Floor</tvc:Street1>\n' +
            '<tvc:City>New York</tvc:City>\n' +
            '<tvc:RegionCode>NY</tvc:RegionCode>\n' +
            '<tvc:PostalCode>10017</tvc:PostalCode>\n' +
            '<tvc:CountryCode></tvc:CountryCode>\n' +
            '</tvc:Address>\n' +
            '\n' +
            '<tvc:Contact contactRole="Buyer">\n' +
            '<tvc:PersonFirstName>Tania</tvc:PersonFirstName>\n' +
            '<tvc:PersonLastName>Bonetti</tvc:PersonLastName>\n' +
            '<tvc:Email></tvc:Email>\n' +
            '<tvc:Phone></tvc:Phone>\n' +
            '</tvc:Contact>\n' +
            '\n' +
            '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '<tvc:Office>\n' +
            '<tvc:OfficeName>Test Account c/o Marathon</tvc:OfficeName>\n' +
            '<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvc:Office>\n' +
            '</tvm:Agency>\n' +
            '\n' +
            '<tvm:Estimate>\n' +
            '<tvc:SourceCode source="Agency">Test Account EST:'+ orderId +'</tvc:SourceCode>\n' +
            '</tvm:Estimate>\n' +
            '\n' +
            '<tvm:Seller>\n' +
            '<tvm:StationSeller>\n' +
            '<tvc:CompanyName>WMUR - Manchester - Hearst</tvc:CompanyName>\n' +
            '<tvc:Contact contactRole="AccountExec">\n' +
            '<tvc:PersonFirstName>Joe</tvc:PersonFirstName>\n' +
            '<tvc:PersonLastName>Smith</tvc:PersonLastName>\n' +
            '<tvc:Email></tvc:Email>\n' +
            '<tvc:Phone></tvc:Phone>\n' +
            '</tvc:Contact>\n' +
            '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '<tvc:Office>\n' +
            '<tvc:OfficeName>Marathon</tvc:OfficeName>\n' +
            '<tvc:SourceCode source="Agency">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvc:Office>\n' +
            '</tvm:StationSeller>\n' +
            '</tvm:Seller>\n' +
            '\n' +
            '<tvo:LocalNational>National</tvo:LocalNational>\n' +
            '<tvm:Station>\n' +
            '<tvm:FCCCallLetters>WMUR</tvm:FCCCallLetters>\n' +
            '<tvc:SourceCode source="Station">00000000-0000-0000-0000-000000000000</tvc:SourceCode>\n' +
            '</tvm:Station>\n' +
            '\n' +
            '<tvc:StartDate>2015-09-28</tvc:StartDate>\n' +
            '<tvc:EndDate>2015-10-04</tvc:EndDate>\n' +
            '<tvo:OrderGrossAmount>60.00</tvo:OrderGrossAmount>\n' +
            '<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>\n' +
            '<tvo:BillingCycle>Monthly</tvo:BillingCycle>\n' +
            '<tvm:PrimaryDemoCategory demoId="DM0" />\n' +
            '<tvm:DemoCategory demoId="DM0">\n' +
            '<tvm:DemoGroup>Adults</tvm:DemoGroup>\n' +
            '<tvm:DemoLowerAge>18</tvm:DemoLowerAge>\n' +
            '<tvm:DemoUpperAge>99</tvm:DemoUpperAge>\n' +
            '</tvm:DemoCategory>\n' +
            '<tvc:Comment source="Agency"></tvc:Comment>\n' +
            '\n' +
            '<tvo:Buylines>\n' +
            '\n' +
            '<tvo:SpotBuyline buylineNumber="1" buylineVersion="1" buylineStatus="New">\n' +
            '<tvo:BuylineIdReferences>\n' +
            '<tvc:SourceCode source="Agency"></tvc:SourceCode>\n' +
            '</tvo:BuylineIdReferences>\n' +
            '\n' +
            '<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n' +
            '<tvo:BuylineDescription>Sign-On/Sign-Off</tvo:BuylineDescription>\n' +
            '<tvc:StartDate>2015-09-28</tvc:StartDate>\n' +
            '<tvc:EndDate>2015-10-04</tvc:EndDate>\n' +
            '<tvo:BuylineQuantity unitType="Spot">2</tvo:BuylineQuantity>\n' +
            '<tvo:BuylineUnitRate costModel="Unit">30.00</tvo:BuylineUnitRate>\n' +
            '<tvo:BuylineGrossAmount>60.00</tvo:BuylineGrossAmount>\n' +
            '<tvc:Comment source="Agency"></tvc:Comment>\n' +
            '<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n' +
            '<tvo:SpotLength>60</tvo:SpotLength>\n' +
            '<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n' +
            '\n' +
            '<tvo:ContractInterval>\n' +
            '<tvm:MondayValid>True</tvm:MondayValid>\n' +
            '<tvm:TuesdayValid>True</tvm:TuesdayValid>\n' +
            '<tvm:WednesdayValid>True</tvm:WednesdayValid>\n' +
            '<tvm:ThursdayValid>True</tvm:ThursdayValid>\n' +
            '<tvm:FridayValid>True</tvm:FridayValid>\n' +
            '<tvm:SaturdayValid>True</tvm:SaturdayValid>\n' +
            '<tvm:SundayValid>True</tvm:SundayValid>\n' +
            '<tvc:StartTime>1:00</tvc:StartTime>\n' +
            '<tvc:EndTime>6:00</tvc:EndTime>\n' +
            '</tvo:ContractInterval>\n' +
            '\n' +
            '<tvo:WeeklySpotDistribution>\n' +
            '<tvc:StartDate>2015-09-28</tvc:StartDate>\n' +
            '<tvc:EndDate>2015-10-04</tvc:EndDate>\n' +
            '<tvo:SpotPerWeekQuantity>2</tvo:SpotPerWeekQuantity>\n' +
            '<tvm:MondayValid>True</tvm:MondayValid>\n' +
            '<tvm:TuesdayValid>True</tvm:TuesdayValid>\n' +
            '<tvm:WednesdayValid>True</tvm:WednesdayValid>\n' +
            '<tvm:ThursdayValid>True</tvm:ThursdayValid>\n' +
            '<tvm:FridayValid>True</tvm:FridayValid>\n' +
            '<tvm:SaturdayValid>True</tvm:SaturdayValid>\n' +
            '<tvm:SundayValid>True</tvm:SundayValid>\n' +
            '</tvo:WeeklySpotDistribution>\n' +
            '</tvo:SpotBuyline>\n' +
            '\n' +
            '</tvo:Buylines>\n' +
            '</tvo:Order>\n' +
            '</tvo:CreateOrderRequest>\n';
        results.put('WMUR', body);

        return results;
    }
    
}