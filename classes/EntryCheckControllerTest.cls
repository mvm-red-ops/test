@IsTest
private class EntryCheckControllerTest {
    @TestSetup
    static void createData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(LastName = 'Test', Email = 'test@test.com', Phone = '8001234567', AccountId = acc.Id) ;
        insert con ;

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
        insert advertiser;

        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;

        //Program
        Programs__c program = new Programs__c();
        program.Name = 'BounceTV';
        program.Cable_Synd__c = 'Cable';
        program.ClientCode__c = 'h1';
        program.Barter__c = true;
        program.Station_Call_Letter__c = 'a';
        program.Reconciled_Week__c = Date.today().addDays(-7).toStartOfWeek().addDays(1);
        program.Post_Log__c = [SELECT Id FROM User LIMIT 1].Id;
        insert program;

        Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Program__c = program.Id, Status__c = 'Sold');
        insert deal;

        //Schedule
        Schedules__c schedule = new Schedules__c();
        schedule.Units_Available__c = 3.0;
        schedule.Units_Preempted__c = 0;
        schedule.Week__c = Date.today().addDays(-14).toStartOfWeek().addDays(1);
        schedule.Deal_Parent__c = deal.Id;
        schedule.Status__c = 'Sold';
        schedule.Rate__c = 300;
        insert schedule;
    }

    @IsTest
    static void EC_Search_Invalid() {
        EntryCheckController ec = new EntryCheckController();
        PageReference ref = Page.EntryCheck;
        Test.setCurrentPage(ref);

        Test.startTest();
        PageReference newPage = ec.search();
        Test.stopTest();

        System.assertEquals(null, newPage);
        System.assertEquals('/apex/entrycheck', ApexPages.currentPage().getUrl());
    }

    @IsTest
    static void EC_Search_Valid() {
        EntryCheckController ec = new EntryCheckController();
        PageReference ref = Page.EntryCheck;
        Test.setCurrentPage(ref);
        ec.deal.Program__c = [SELECT Id FROM Programs__c LIMIT 1].Id;

        PageReference newPage = ec.search();
        System.assertNotEquals(null, newPage);
        System.assertEquals('/apex/EntryCheckReport', newPage.getUrl());

        ec.sDate.Week__c = Date.today().addDays(-14).toStartOfWeek().addDays(1);
        ec.con.AccountId = [SELECT Id FROM Account LIMIT 1].Id;
        newPage = ec.search();
        System.assertNotEquals(null, newPage);
        System.assertEquals('/apex/EntryCheckReport', newPage.getUrl());
    }

    @IsTest
    static void entryCheckController_getOptions_correctOptio() {
        EntryCheckController entryCheck = new EntryCheckController();
        List<SelectOption> selectedOptions = entryCheck.getOptions();
        System.assertNotEquals(null, selectedOptions[0]);
    }

    @IsTest
    static void entryCheckController_getMonths_correctMonthReturned() {
        EntryCheckController entryCheck = new EntryCheckController();
        Map<Integer, String> months = entryCheck.getMonth();
        System.assertEquals('Apr', months.get(4));
    }

    @IsTest
    static void entryCheckController_oneWeekLater_fromDateIsSetToStartDateWeek() {
        EntryCheckController entryCheck = new EntryCheckController();
        setEntryCheckControllerProperties(entryCheck);
        Test.startTest();
        entryCheck.oneWeekLater();
        Test.stopTest();
        System.assertEquals(entryCheck.fromDate, entryCheck.sDate.Week__c);
    }

    @IsTest
    static void entryCheckController_oneWeekBack_toDateIsSetToStartDateWeek() {
        EntryCheckController entryCheck = new EntryCheckController();
        setEntryCheckControllerProperties(entryCheck);
        entryCheck.deal = new List<Deal__c>(getDeal())[0];
        Test.startTest();
        entryCheck.oneWeekBack();
        Test.stopTest();
        System.assertEquals(entryCheck.toDate, entryCheck.eDate.Week__c);
    }

    @IsTest
    static void EntryCheckController_cancel_SetSchedulestatusToCancel() {
        EntryCheckController ec = new EntryCheckController();

        Deal__c deal = getDeal()[0];
        Schedules__c sch = getSchedules(null, null, deal)[0];
        ec.showReport();
        ec.sid = sch.Id;
        ec.slf = String.valueOf(sch.Id).substring(0, 15);
        ec.scheduleList = new List<Schedules__c>{sch};
        setEntryCheckControllerProperties(ec);
        ec.cancel();
        Schedules__c schedule = queryForASchedule(sch.Id);
        System.assertEquals('Canceled', schedule.Status__c);
    }

    @IsTest
    static void entryCheckController_save_lastUpdateScheduleSuccessful() {
        EntryCheckController entryCheck = new EntryCheckController();
        entryCheck.deal = getDeal()[0];
        setEntryCheckControllerProperties(entryCheck);
        entryCheck.showReport();
        EntryCheckHelper.FBModels EHT = new EntryCheckHelper.FBModels();
        EntryCheckHelper.FBEntryModel FB = new EntryCheckHelper.FBEntryModel();
        FB.schedule = getSchedules(null, null, getDeal()[0])[0];
        entryCheck.fbModel.add(EHT);
        EHT.fbEntryModels = new List<EntryCheckHelper.FBEntryModel>{FB};
        EHT.chkbox = true;
        Test.startTest();

        PageReference pg = entryCheck.save();
        entryCheck.showReport();
        Test.stopTest();
        System.assertEquals(false, EHT.chkbox);
        System.assert(pg == null);
    }

    @IsTest
     static void entryCheckController_getRecordType_ScheduleIsNotEmpty() {
        EntryCheckController entryCheck = new EntryCheckController();
        Deal__c deal = getDeal()[0];
        deal.RecordType.Name = 'Deal Paid Programming';
        upsert deal;
        Deal__c dealWithRecordTypeName = getDeal()[0];
        Schedules__c schedule = getSchedules(null,  null, dealWithRecordTypeName)[0];


        Id scheduleId = entryCheck.getRecordType(schedule);
        System.assertNotEquals(null, scheduleId);

        Id actual = entryCheck.getRecordType(new Schedules__c());
        System.assertEquals(null, actual);
    }

    @IsTest
    static void entryCheckController_checkAll_togglechkbox() {
        EntryCheckController entryCheck = new EntryCheckController();
        setEntryCheckControllerProperties(entryCheck);

        EntryCheckHelper.FBModels EThelper = new EntryCheckHelper.FBModels();
        System.assertEquals(false, EThelper.chkbox);
        entryCheck.fbModel = new List<EntryCheckHelper.FBModels>{EThelper};
        entryCheck.checkAll();
        System.assertEquals(false, EThelper.chkbox);

        entryCheck.checks = true;
        entryCheck.checkAll();
        System.assertEquals(true, EThelper.chkbox);
    }

    @IsTest
    static void EntryCheckController_back_SuccessfullyReturnedPage() {
        EntryCheckController entryCheck = new EntryCheckController();
        PageReference pg = entryCheck.back();
        System.assertNotEquals(null, pg);
    }

    @IsTest
    static void EntryCheckController_back_showReport() {
        EntryCheckController ec = new EntryCheckController();
        Deal__c deal = getDeal()[0];
        ec.deal = deal;
        Schedules__c sch = getSchedules(null, null, deal)[0];
        ec.showReport();
    }

    @IsTest
    static void EntryCheckController_setDealAccount_setDealOnSchedule() {
        ApexPages.currentPage().getParameters().put('Dealacc','accName');
        EntryCheckController entryCheck = new EntryCheckController();
        setEntryCheckControllerProperties(entryCheck);
        entryCheck.scheduleObj = new Schedules__c();
        Test.startTest();
        entryCheck.setDealAccount();
        Test.stopTest();
        String DealAccount = ApexPages.currentPage().getParameters().get('Dealacc');
        System.assertEquals('accName', DealAccount);
    }

    @IsTest
    static void EntryCheckController_replaceSchedule_replaceOldScheduleWithNewSchedule() {
        EntryCheckController ec = new EntryCheckController();
        setEntryCheckControllerProperties(ec);
        ec.fromDate = Date.today().toStartOfMonth().addMonths(-3).toStartOfWeek().addDays(1);
        ec.toDate = Date.today().toStartOfMonth().addMonths(1).toStartOfWeek().addDays(4);
        Deal__c dl = getDeal()[0];
        upsert dl;
        Schedules__c schedule = getSchedules(null, null, dl)[0];
        ec.sch = schedule.Id;
        PageReference pg = ec.replaceSchedule();
        System.assertEquals('/apex/EntryCheckReplaceSchedule', pg.getUrl());
        ec.sch = '';
        ec.replaceSchedule();
        System.assertEquals('Sold', ec.scheduleObj.Status__c);
    }

    @IsTest
    static void EntryCheckController_replace_StatusSetToCancel() {
        EntryCheckController ec = new EntryCheckController();
        setEntryCheckControllerProperties(ec);
        Deal__c dl = getDeal()[0];

        ec.oldScheduleObj = getSchedules(null, null, dl)[0];
        ec.scheduleObj = creatSchedules(null, null, dl)[0];
        PageReference pg =  ec.replace();
        System.assertEquals('/apex/EntryCheckReport', pg.getUrl());
    }

    public static List<Deal__c> getDeal() {
        Contact con = new Contact(
                LastName = 'Test',
                Email = 'test@test.com',
                Phone = '8001234567'
        );
        insert con;

        Advertiser__c advertiser = new Advertiser__c(
                Duplicate_Approval__c = 'Approved',
                Advertiser_Approved_to_Book__c = true
        );
        insert advertiser;

        Brands__c brand = new Brands__c(
                Name = 'Availability',
                Category__c = 'Other',
                Advertiser__c = advertiser.Id,
                Approved_Duplicate__c = 'Approved'
        );
        insert brand;

        //Program
        Programs__c program = new Programs__c(
                Name = 'BounceTV',
                Cable_Synd__c = 'Cable',
                ClientCode__c = 'h1',
                Barter__c = true,
                Station_Call_Letter__c = 'a',
                Prelog_Version__c = 5
        );
        insert program;
        //Deal
        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Program__c = program.Id,
                Length__c = '5'
        );
        insert deal;
        return new List<Deal__c>([SELECT Id, Contact__c, Brands__c, Program__c, Length__c, RecordType.Name FROM Deal__c WHERE Id =: deal.Id]);
    }

    public static List<Schedules__c> getSchedules (String Start_Time, String End_Time, Deal__c deal) {
        Date constDate = Date.today().toStartOfWeek().addDays(1);
        Schedules__c schedule = new Schedules__c(
                Units_Available__c = 1.0,
                Units_Preempted__c = 0,
                Week__c = constDate,
                Deal_Parent__c = deal.Id,
                Start_Time__c = Start_Time,
                End_Time__c = End_Time,
                Status__c = 'Sold',
                Rate__c = 300,
                Long_Form__c = 'Deal Short Form',
                Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun'
        );

        insert schedule;

        deal = [
                SELECT Id,
                (SELECT Id, Deal_Parent__c, OrderLineNumber__c, Total_Dollars__c FROM Schedules__r),
                        Contact__c,
                        Brands__c,
                        Program__c,
                        Length__c,
                        RecordType.Name
                FROM Deal__c
                WHERE Id = :deal.Id
                LIMIT 1
        ];

        return [SELECT Days_Allowed__c, Start_Time__c, End_Time__c, Deal_Parent__c, DealAccount__c  FROM Schedules__c WHERE Id = :schedule.Id];
    }

    public static List<Schedules__c> creatSchedules (String Start_Time, String End_Time, Deal__c deal) {
        Date constDate = Date.today().toStartOfWeek().addDays(1);
        Schedules__c schedule = new Schedules__c(
                Units_Available__c = 1.0,
                Units_Preempted__c = 0,
                Week__c = constDate,
                Deal_Parent__c = deal.Id,
                Start_Time__c = Start_Time,
                End_Time__c = End_Time,
                Status__c = 'Sold',
                Rate__c = 300,
                Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun'
        );

        deal = [
                SELECT Id,
                (SELECT Id, Deal_Parent__c, OrderLineNumber__c, Total_Dollars__c FROM Schedules__r),
                        Contact__c,
                        Brands__c,
                        Program__c,
                        Length__c,
                        RecordType.Name
                FROM Deal__c
                WHERE Id = :deal.Id
                LIMIT 1
        ];

        return new List<Schedules__c>{schedule};
    }

    public static void setEntryCheckControllerProperties(EntryCheckController ec) {
        Account acc = new Account(Name = 'Test Account');
        ec.con = new Contact();
        ec.con.AccountId = acc.Id;
        ec.deal= new List<Deal__c>( getDeal())[0];
        ec.sDate = new Schedules__c();
        ec.eDate = new Schedules__c();
        ec.sWeek = '2019-3-4';

        ec.sDate.Week__c = Date.today().toStartOfWeek().addDays(1);
        ec.eDate.Week__c = Date.today().toStartOfWeek().addDays(7);
    }

    public static Schedules__c queryForASchedule(Id SchedulesId ) {
        return [SELECT Id, Status__c FROM Schedules__c WHERE Id  =: SchedulesId LIMIT 1];
    }
}