@isTest
private class OSIxmlTest {

    private static Account createAccount() {
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        return testAcct;
    }

    private static Contact createContact(Account testAcct){
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Name';
        contact.Email = 'test@testemail.com';
        contact.Phone = '(758) 771-0091';
        contact.Account = testAcct;
        return contact;
    }

    static Deal__c createDeal(Contact testContact, String dealNumber) {
        Deal__c testDeal = new Deal__c();
        testDeal.Contact__c = testContact.id;
        testDeal.Network_Deal_Number__c = dealNumber;
        return testDeal;
    }

    private static Schedules__c createSchedule(Deal__c testDeal) {

        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = testDeal.id;
        schedule.Week__c = Date.newInstance(2019, 1, 7);
        schedule.Days_Allowed__c = 'Mon';
        schedule.Start_Time__c = '06:00A';
        schedule.End_Time__c = '06:30A';
        schedule.Rate__c = 100;
        schedule.Units_Available__c = 5;
        return schedule;
    }

    static String join(List<String> values, String sep) {
        List<String> valueCopy = new List<String>(values);
        if(valueCopy.isEmpty())
            return null;
        String result = valueCopy[0];
        valueCopy.remove(0);
        while(!valueCopy.isEmpty()) {
            result += sep + valueCopy[0];
            valueCopy.remove(0);
        }
        return result;
    }

    static String join(List<String> values) {
        return join(values, '');
    }

    private static List<Schedules__c> createSchedules(Integer totalSchedules) {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '5');
        insert testDeal;
        List<Schedules__c> schedules = new List<Schedules__c>();
        Integer i = 0;
        for (i = 0; i < totalSchedules; i++){
            schedules.add(createSchedule(testDeal));
        }

        return schedules;
    }


    @isTest static void OSIxml_markXMLSent_tagScheduleWithXMLSent() {
        Integer totalSchedules = 5;
        List<Schedules__c> schedules = createSchedules(totalSchedules);
        insert schedules;
        List<String> scheduleIdList = new List<String>();
        Integer i = 0;
        for (Schedules__c schedule : schedules){
            scheduleIdList.add(schedule.Id);
            schedules[i].XML_Sent__c = True;
            i++;
        }
        String scheduleIdsString = join(scheduleIdList, ';');

        OSIxml.markXMLSent(scheduleIdsString).equals('SUCCESS');
        schedules = findMarkXMLSentSchedules(scheduleIdList);
        System.assert(schedules.size() == totalSchedules);
        for (i = 0; i < schedules.size(); i++){
            System.assert(schedules[i].XML_Sent__c == False);
        }
        System.assert(OSIxml.markXMLSent(Null).equals('Attempt to de-reference a null object'));
    }

    private static PrelogData__c createPrelogDataRecord(Id scheduleId, PrelogDataMirror__c rec)
    {
        PrelogData__c PrelogDataRec = new PrelogData__c();
        PrelogDataRec.AdvertiserProduct__c = rec.AdvertiserProduct__c;
        PrelogDataRec.Agency__c = rec.Agency__c;
        PrelogDataRec.AirDate__c = rec.AirDate__c;
        PrelogDataRec.BreakCode__c = rec.BreakCode__c;
        PrelogDataRec.MaterialDescription__c = rec.MaterialDescription__c;
        PrelogDataRec.OrderProductDescription__c = rec.OrderProductDescription__c;
        PrelogDataRec.PrelogDataMirror__c = rec.id;
        PrelogDataRec.Rate__c = rec.Rate__c;
        PrelogDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        PrelogDataRec.Schedule__c = ScheduleId;
        PrelogDataRec.ScheduleAdID__c = rec.ScheduleAdID__c;
        PrelogDataRec.ScheduleLength__c = rec.ScheduleLength__c;
        PrelogDataRec.ScheduleTime__c = rec.ScheduleTime__c;
        PrelogDataRec.TimePeriod__c = rec.TimePeriod__c;
        PrelogDataRec.Version__c = rec.Version__c;
        insert PrelogDataRec;
        return PrelogDataRec;
    }

    private static List<PrelogDataMirror__c> createPrelogDataMirrors(Boolean positiveTestCase, Integer unitsAvailable, String dealNumber) {
        Integer rate = 0;
        if (positiveTestCase) {
            rate = 100;
        }

        List<PrelogDataMirror__c> mirrors = new List<PrelogDataMirror__C>();
        for (Integer i = 0; i < unitsAvailable; i++) {
            PrelogDataMirror__c mirror = new PrelogDataMirror__c();
            mirror.NetworkDealNumber__c = dealNumber;
            mirror.Network__c = 'test';
            mirror.ScheduleLength__c = '1';
            mirror.AirDate__c = Date.newInstance(2019, 1, 7);
            mirror.ScheduleTime__c = '6:0'+i+':00AM';
            mirror.Rate__c = rate;
            mirror.Version__c = 1;
            mirrors.add(mirror);
        }

        insert mirrors;
        return mirrors;
    }

    private static List<Schedules__c> findMarkXMLSentSchedules(List<Id> scheduleIdList) {
        return [SELECT Id,
                       XML_Sent__c FROM Schedules__c
                 WHERE Id IN :scheduleIdList];
    }

    private static List<Schedules__C> findTestSchedules(Schedules__c testSchedule){
        return [SELECT Id,
                       XML_Sent__c
                  FROM Schedules__c
                 WHERE Id = :testSchedule.Id];
    }

    private static List<Attachment> findAttachemnts(PrelogData__c testRecord) {
        return [SELECT Name,
                       Body,
                       ParentId
                  FROM Attachment
                 WHERE ParentId = :testRecord.Id];
    }

    private static List<Schedules__c> getStartingSchedulues(Schedules__c testSchedule) {
        return [SELECT Id,
                       XML_Sent__c
                  FROM Schedules__c
                 WHERE Id = :testSchedule.Id];
    }

    private static Schedules__c createAndInsertSchedule() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '1');
        insert testDeal;
        Schedules__c testSchedule = createSchedule(testDeal);
        insert testSchedule;
        return testSchedule;
    }

    @isTest static void OSIxml_saveData_attachmentSavedToRecord() {
        PrelogDataMirror__c dataMirrorTest = createPrelogDataMirrors(true, 1, '1')[0];
        Schedules__c testSchedule = createSchedules(1)[0];
        insert testSchedule;
        PrelogData__c testRecord = createPrelogDataRecord(testSchedule.id, dataMirrorTest);
        OSIxml.saveData(testRecord.Id, 'fileNametest', 'SEVMTE8gVEhFUkUh');
        List<PrelogData__c> testRecordList = new List<PrelogData__c>();
        List<Schedules__C> testScheduleList = getStartingSchedulues(testSchedule);
        System.assert(testScheduleList.size() == 1);
        testSchedule = testScheduleList[0];


        testRecordList = new List<PrelogData__c>();
        testScheduleList = findTestSchedules(testSchedule);
        System.assert(testScheduleList.size() == 1);
        List<Attachment> attachmentList = findAttachemnts(testRecord);
        System.assert(attachmentList.size() == 1);
        System.assert(attachmentList[0].Name == 'fileNameTest');
        System.assert(EncodingUtil.base64Encode(attachmentList[0].Body).equals('SEVMTE8gVEhFUkUh'));

    }

    @isTest static void OSIxml_stringFormater_stringCorrectlyFormatted() {
        System.assert(OSIxml.stringFormatter('&').equals('and'));
        System.assert(OSIxml.stringFormatter('1&2').equals('1and2'));
        System.assert(OSIxml.stringFormatter('1&2&3&4').equals('1and2and3and4'));
        System.assert(OSIxml.stringFormatter('1234').equals('1234'));
    }

    @isTest static void OSIxml_weekday_stringCOnvertedToFullLengthDay() {
        System.assert(OSIxml.weekday('Sun').equals('Sunday'));
        System.assert(OSIxml.weekday('Mon').equals('Monday'));
        System.assert(OSIxml.weekday('Tue').equals('Tuesday'));
        System.assert(OSIxml.weekday('Wed').equals('Wednesday'));
        System.assert(OSIxml.weekday('Thu').equals('Thursday'));
        System.assert(OSIxml.weekday('Fri').equals('Friday'));
        System.assert(OSIxml.weekday('Sat').equals('Saturday'));
        System.assert(OSIxml.weekday('asdfasdf').equals('asdfasdf'));
    }

    @isTest static void OSIxml_generateWeeklyBuy_weeklyBuyGenerated() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '1');
        insert testDeal;
        Schedules__c testSchedule = createSchedule(testDeal);
        insert testSchedule;

        String weeklyBuy = OSIxml.generateWeeklyBuy(testSchedule, testDeal, 5);
        System.assert(weeklyBuy.contains('<tvo:SpotBuyline buylineNumber="5 " buylineVersion="1" buylineStatus="New">\n<tvo:BuylineIdReferences>\n<tvc:SourceCode source="Agency">1</tvc:SourceCode>\n</tvo:BuylineIdReferences>\n<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n<tvo:BuylineDescription>FL1</tvo:BuylineDescription>'));
        System.assert(weeklyBuy.contains('<tvo:BuylineQuantity unitType="Spot">1</tvo:BuylineQuantity>\n<tvo:BuylineUnitRate costModel="Fixed">100.00</tvo:BuylineUnitRate>\n<tvo:BuylineGrossAmount>100</tvo:BuylineGrossAmount>\n<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n<tvo:SpotLength>null</tvo:SpotLength>\n<tvo:BuyerDaypart>null</tvo:BuyerDaypart>\n<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n<tvo:ContractInterval>\n<tvm:MondayValid>true</tvm:MondayValid>\n<tvm:TuesdayValid>false</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n<tvc:StartTime>06:00</tvc:StartTime>\n<tvc:EndTime>06:30</tvc:EndTime>\n</tvo:ContractInterval>\n<tvo:WeeklySpotDistribution>'));
        System.assert(weeklyBuy.contains('<tvo:SpotPerWeekQuantity>1</tvo:SpotPerWeekQuantity>\n<tvm:MondayValid>true</tvm:MondayValid>\n<tvm:TuesdayValid>false</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n</tvo:WeeklySpotDistribution>\n<tvo:TargetDemoValue demoId="DM1">\n<tvm:RatingPointValue>2.9</tvm:RatingPointValue>\n</tvo:TargetDemoValue>\n</tvo:SpotBuyline>\n'));
    }

    @isTest static void OSIxml_generateBuyLines_buyLinesGeneratedFromSchedule() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '1');
        insert testDeal;
        Schedules__c testSchedule = createSchedule(testDeal);
        insert testSchedule;

        String buyLines = OSIxml.generateBuylines(testDeal);
        System.assert(buyLines.contains('<tvo:SpotBuyline buylineNumber="1 " buylineVersion="1" buylineStatus="New">\n<tvo:BuylineIdReferences>\n<tvc:SourceCode source="Agency">1</tvc:SourceCode>\n</tvo:BuylineIdReferences>\n<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n<tvo:BuylineDescription>FL1</tvo:BuylineDescription>\n<tvc:StartDate>2019-01-07</tvc:StartDate>\n'));
        System.assert(buyLines.contains('<tvo:BuylineQuantity unitType="Spot">1</tvo:BuylineQuantity>\n<tvo:BuylineUnitRate costModel="Fixed">100.00</tvo:BuylineUnitRate>\n<tvo:BuylineGrossAmount>100</tvo:BuylineGrossAmount>\n<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n<tvo:SpotLength>null</tvo:SpotLength>\n<tvo:BuyerDaypart>null</tvo:BuyerDaypart>\n<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n<tvo:ContractInterval>\n<tvm:MondayValid>true</tvm:MondayValid>\n<tvm:TuesdayValid>false</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n<tvc:StartTime>06:00</tvc:StartTime>\n<tvc:EndTime>06:30</tvc:EndTime>\n</tvo:ContractInterval>\n<tvo:WeeklySpotDistribution>'));
        System.assert(buyLines.contains('<tvo:SpotPerWeekQuantity>1</tvo:SpotPerWeekQuantity>\n<tvm:MondayValid>true</tvm:MondayValid>\n<tvm:TuesdayValid>false</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n</tvo:WeeklySpotDistribution>\n<tvo:TargetDemoValue demoId="DM1">\n<tvm:RatingPointValue>2.9</tvm:RatingPointValue>\n</tvo:TargetDemoValue>\n</tvo:SpotBuyline>'));
    }

    @isTest static void OSIxml_buildStationList_generateStationList() {
        List<Bundle_Pricing__c> bundlePriceListTest = new List<Bundle_Pricing__c>();
        Integer i = 0;
        Bundle_Pricing__c testBundle;
        for (i = 0; i < 4; i++) {
            bundlePriceListTest.add(new Bundle_Pricing__c());
        }
        Map<String, OSIxml.StationWrapper> stationMap = OSIxml.buildStationList(bundlePriceListTest);
        List<OSIxml.StationWrapper> stationList = stationMap.values();
        List<Bundle_Pricing__c> pricingList = stationList[0].pricingList;
        System.assertEquals(4, pricingList.size());
    }

    private static Schedules__c findScheduleForGetXMLFiles(Id scheduleId) {
        return [SELECT name
                  FROM Schedules__c
                 WHERE Id = :scheduleId][0];
    }


    @isTest static void OSIxml_getXMLFiles_generateXMLFilesForSchedule() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '1');
        insert testDeal;
        Schedules__c testSchedule = createSchedule(testDeal);
        insert testSchedule;
        testSchedule = findScheduleForGetXMLFiles(testSchedule.Id);
        OSIxml.setScheduleSelector(new ScheduleTestSelector());
        Map<String, String> resultsMap = OSIxml.getXMLFiles(testDeal.id, testSchedule.id);
        XmlStreamReader xsr = new XmlStreamReader('test');
        Date d = Date.today();
        String filename = '-' + d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '-' + testSchedule.name + '.xml';
        String encodedString = resultsMap.get(filename);
        Blob xmlBlob = EncodingUtil.base64Decode(encodedString);
        String XMLString = xmlBlob.toString();
        System.assert(XMLString.contains('\n<tvo:OrderIdReferences>\n<tvc:SourceCode source="Agency">VIEW32_ePort_v3.2</tvc:SourceCode>\n<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n</tvo:OrderIdReferences>\n<tvo:OrderType>Normal</tvo:OrderType>\n<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>\n<tvm:Advertiser>\n<tvc:CompanyName>Clipro</tvc:CompanyName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Advertiser>\n<tvm:Product>\n<tvm:ProductName>testName</tvm:ProductName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Product>\n<tvm:Agency>\n<tvc:CompanyName>my contact</tvc:CompanyName>\n<tvc:Contact>\n<tvc:PersonFirstName> Tania </tvc:PersonFirstName>\n<tvc:PersonLastName> Bonetti </tvc:PersonLastName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Contact>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n<tvc:Office>\n<tvc:OfficeName>my contact c/o Marathon</tvc:OfficeName>\n<tvc:Phone>\n<tvc:AreaCityCode>646</tvc:AreaCityCode>\n<tvc:PhoneNumber>4487080</tvc:PhoneNumber>\n</tvc:Phone>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Office>\n</tvm:Agency>\n<tvm:Estimate>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Estimate>\n<tvm:Seller>\n<tvm:StationSeller>\n<tvc:CompanyName>the Stadium Network</tvc:CompanyName>\n<tvc:Contact contactRole="AccountExec">\n<tvc:PersonFirstName>Stadium-Marathon</tvc:PersonFirstName>\n<tvc:PersonLastName>Stadium-Marathon</tvc:PersonLastName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Contact>\n<tvc:SourceCode source="Other">None</tvc:SourceCode>\n</tvm:StationSeller>\n</tvm:Seller>\n<tvo:LocalNational>Local</tvo:LocalNational>\n<tvm:Station stationId="ST1" tradingPartnerId="00000000-0000-0000-0000-000000000000">\n<tvm:FCCCallLetters>SOTA</tvm:FCCCallLetters>\n<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Station>'));
        System.assert(XMLString.contains('</tvc:EndDate>\n<tvo:OrderGrossAmount>20.0</tvo:OrderGrossAmount>\n<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>\n<tvo:BillingCycle>Monthly</tvo:BillingCycle>\n<tvm:DemoCategory demoId="DM1">\n<tvm:DemoGroup>Adults</tvm:DemoGroup>\n<tvm:DemoLowerAge>18</tvm:DemoLowerAge>\n<tvm:DemoUpperAge>99</tvm:DemoUpperAge>\n</tvm:DemoCategory>\n\n<tvo:Buylines>\n<tvo:SpotBuyline buylineNumber="1 " buylineVersion="1" buylineStatus="New">\n<tvo:BuylineIdReferences>\n<tvc:SourceCode source="Agency">1</tvc:SourceCode>\n</tvo:BuylineIdReferences>\n<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n<tvo:BuylineDescription>FL1</tvo:BuylineDescription>'));
        System.assert(XMLString.contains(('<tvo:BuylineQuantity unitType="Spot">8</tvo:BuylineQuantity>\n<tvo:BuylineUnitRate costModel="Fixed">5.0</tvo:BuylineUnitRate>\n<tvo:BuylineGrossAmount>40</tvo:BuylineGrossAmount>\n<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n<tvo:SpotLength>120</tvo:SpotLength>\n<tvo:BuyerDaypart>9A-6P – Day</tvo:BuyerDaypart>\n<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n<tvo:ContractInterval>\n<tvm:MondayValid>false</tvm:MondayValid>\n<tvm:TuesdayValid>true</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n<tvc:StartTime>16:00</tvc:StartTime>\n<tvc:EndTime>4:30</tvc:EndTime>\n</tvo:ContractInterval>\n<tvo:WeeklySpotDistribution>')));
        System.assert(XMLString.contains('<tvo:SpotPerWeekQuantity>8</tvo:SpotPerWeekQuantity>\n<tvm:MondayValid>false</tvm:MondayValid>\n<tvm:TuesdayValid>true</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n</tvo:WeeklySpotDistribution>\n<tvo:TargetDemoValue demoId="DM1">\n<tvm:RatingPointValue>2.9</tvm:RatingPointValue>\n</tvo:TargetDemoValue>\n</tvo:SpotBuyline>\n</tvo:Buylines>\n</tvo:Order>\n</tvo:CreateOrderRequest>'));

        resultsMap = (OSIxml.getXMLFiles(testDeal.id, ''));
        filename = '-' + d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '-' + 'my name'+ '.xml';
        encodedString = resultsMap.get(filename);
        xmlBlob = EncodingUtil.base64Decode(encodedString);
        XMLString = xmlBlob.toString();
        System.assert(XMLString.contains('<tvo:OrderIdReferences>\n<tvc:SourceCode source="Agency">VIEW32_ePort_v3.2</tvc:SourceCode>\n<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n</tvo:OrderIdReferences>\n<tvo:OrderType>Normal</tvo:OrderType>\n<tvo:OrderCashTrade>Cash</tvo:OrderCashTrade>\n<tvm:Advertiser>\n<tvc:CompanyName>Clipro</tvc:CompanyName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Advertiser>\n<tvm:Product>\n<tvm:ProductName>testName</tvm:ProductName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Product>\n<tvm:Agency>\n<tvc:CompanyName>my contact</tvc:CompanyName>\n<tvc:Contact>\n<tvc:PersonFirstName> Tania </tvc:PersonFirstName>\n<tvc:PersonLastName> Bonetti </tvc:PersonLastName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Contact>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n<tvc:Office>\n<tvc:OfficeName>my contact c/o Marathon</tvc:OfficeName>\n<tvc:Phone>\n<tvc:AreaCityCode>646</tvc:AreaCityCode>\n<tvc:PhoneNumber>4487080</tvc:PhoneNumber>\n</tvc:Phone>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Office>\n</tvm:Agency>\n<tvm:Estimate>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Estimate>\n<tvm:Seller>\n<tvm:StationSeller>\n<tvc:CompanyName>the Stadium Network</tvc:CompanyName>\n<tvc:Contact contactRole="AccountExec">\n<tvc:PersonFirstName>Stadium-Marathon</tvc:PersonFirstName>\n<tvc:PersonLastName>Stadium-Marathon</tvc:PersonLastName>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvc:Contact>\n<tvc:SourceCode source="Other">None</tvc:SourceCode>\n</tvm:StationSeller>\n</tvm:Seller>\n<tvo:LocalNational>Local</tvo:LocalNational>\n<tvm:Station stationId="ST1" tradingPartnerId="00000000-0000-0000-0000-000000000000">\n<tvm:FCCCallLetters>SOTA</tvm:FCCCallLetters>\n<tvc:SourceCode source="Rep">TV</tvc:SourceCode>\n<tvc:SourceCode source="Other">VIEW32_ePort_v3.2</tvc:SourceCode>\n</tvm:Station>'));
        System.assert(XMLString.contains('<tvo:OrderGrossAmount>20.0</tvo:OrderGrossAmount>\n<tvo:BillingCalendar>Broadcast</tvo:BillingCalendar>\n<tvo:BillingCycle>Monthly</tvo:BillingCycle>\n<tvm:DemoCategory demoId="DM1">\n<tvm:DemoGroup>Adults</tvm:DemoGroup>\n<tvm:DemoLowerAge>18</tvm:DemoLowerAge>\n<tvm:DemoUpperAge>99</tvm:DemoUpperAge>\n</tvm:DemoCategory>\n\n<tvo:Buylines>\n<tvo:SpotBuyline buylineNumber="1 " buylineVersion="1" buylineStatus="New">\n<tvo:BuylineIdReferences>\n<tvc:SourceCode source="Agency">1</tvc:SourceCode>\n</tvo:BuylineIdReferences>\n<tvo:BuylineCashTrade>Cash</tvo:BuylineCashTrade>\n<tvo:BuylineDescription>FL1</tvo:BuylineDescription>\n'));
        System.assert(XMLString.contains('<tvo:BuylineQuantity unitType="Spot">8</tvo:BuylineQuantity>\n<tvo:BuylineUnitRate costModel="Fixed">5.0</tvo:BuylineUnitRate>\n<tvo:BuylineGrossAmount>40</tvo:BuylineGrossAmount>\n<tvo:SpotBuylineType>Normal</tvo:SpotBuylineType>\n<tvo:SpotLength>120</tvo:SpotLength>\n<tvo:BuyerDaypart>9A-6P – Day</tvo:BuyerDaypart>\n<tvm:StartDayOfWeek>Mo</tvm:StartDayOfWeek>\n<tvo:ContractInterval>\n<tvm:MondayValid>false</tvm:MondayValid>\n<tvm:TuesdayValid>true</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n<tvc:StartTime>16:00</tvc:StartTime>\n<tvc:EndTime>4:30</tvc:EndTime>\n</tvo:ContractInterval>\n<tvo:WeeklySpotDistribution>'));
        System.assert(XMLString.contains('<tvo:SpotPerWeekQuantity>8</tvo:SpotPerWeekQuantity>\n<tvm:MondayValid>false</tvm:MondayValid>\n<tvm:TuesdayValid>true</tvm:TuesdayValid>\n<tvm:WednesdayValid>false</tvm:WednesdayValid>\n<tvm:ThursdayValid>false</tvm:ThursdayValid>\n<tvm:FridayValid>false</tvm:FridayValid>\n<tvm:SaturdayValid>false</tvm:SaturdayValid>\n<tvm:SundayValid>false</tvm:SundayValid>\n</tvo:WeeklySpotDistribution>\n<tvo:TargetDemoValue demoId="DM1">\n<tvm:RatingPointValue>2.9</tvm:RatingPointValue>\n</tvo:TargetDemoValue>\n</tvo:SpotBuyline>\n</tvo:Buylines>\n</tvo:Order>\n</tvo:CreateOrderRequest>'));
    }

    @isTest static void OSIxml_buildSingleScheduleList_buildScheduleList() {
        Schedules__c testSchedule = createAndInsertSchedule();
        List<OSIxml.ScheduleChunkWrapper> scheduleList = OSIxml.buildSingleScheduleList(testSchedule);
        System.assertEquals(String.valueOf(testSchedule.Week__c), scheduleList[0].chunkStart);
        System.assertEquals(String.valueOf(testSchedule.Week__c.addDays(6)), scheduleList[0].chunkEnd);
        System.assertEquals(String.valueOf(testSchedule.Id), scheduleList[0].scheduleIds);
        System.assertEquals(1, scheduleList[0].weekCount);
    }

}