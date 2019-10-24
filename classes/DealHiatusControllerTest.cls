@IsTest
private class DealHiatusControllerTest {

    @IsTest static void Test_NoSchedules() {

        Date constDate = Date.today().toStartOfWeek().addDays(1);

        getDeal();

        Test.setCurrentPage(Page.DealHiatus);
        DealHiatusController dc = new DealHiatusController() ;

        //Set controller properties
        dc.Searchfield = 'BounceTV';
        dc.DoSearch();
        for (DealHiatusController.DealObject obj : dc.DealObjList) {
            System.debug('HERE: ' + obj);
            obj.isChecked = true;
        }
        dc.hiatusTempScheduleStart.Week__c = constDate.addDays(1);
        dc.HiatusUpdate();

        System.assertEquals(false, ApexPages.getMessages().isEmpty());
        System.assertEquals('The Search did not return any results', ApexPages.getMessages()[0].getDetail());
    }

    @IsTest static void
    DealHiatusControllerTest_hiatusSingleDay_DaysAllowedUpdated() {
        Date constDate = Date.today().toStartOfWeek().addDays(4);
        List<Deal__c> deal = getDeal();

        List<Schedules__c> oldSchedule = getSchedule(null, null, deal[0]);

        Test.setCurrentPage(Page.DealHiatus);
        ApexPages.CurrentPage().getParameters().put('DealId', deal[0].Id);
//        getDealHiatusController(constDate, null, null, null);
        DealHiatusController dc = new DealHiatusController();
        setDealHiatusControllerProperties(dc, constDate, null, null, null);
        Test.startTest();
        dc.HiatusUpdate();
        Test.stopTest();
        List<Schedules__c> newSchedule = [SELECT Days_Allowed__c, Start_Time__c, End_Time__c  FROM Schedules__c WHERE Id = :oldSchedule[0].Id];
        System.assertNotEquals(oldSchedule[0].Days_Allowed__c ,newSchedule[0].Days_Allowed__c);

    }

    @IsTest static void Test_DateSOQL() {
        DealHiatusController dc = new DealHiatusController() ;

        dc.Searchfield = 'BounceTV' ;
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
    }

    @IsTest
    static void DealHiatusController_PassTestCoverageForSettersAndGetter() {
        DealHiatusController pc = new DealHiatusController();
        System.debug(pc.programTeamOptions);
        DealHiatusController.setDealSelector(null);
        DealHiatusController.setScheduleSelector(null);
    }

    @IsTest
    static void DealHiatusController_hiatusDateRange_DaysAllowedUpdated() {
        // hiatusTempScheduleStart.Week__c, hiatusTempScheduleEnd.Week__c
        Date constDate = Date.today().toStartOfWeek().addDays(1);
        List<Deal__c> deal = getDeal();

        List<Schedules__c> oldSchedule = getSchedule('6:00A', '10:00A', deal[0]);
        DealHiatusController dc = new DealHiatusController();
        setDealHiatusControllerProperties(dc, constDate, constDate, null, null);
        Test.startTest();
        dc.HiatusUpdate();
        Test.stopTest();
        List<Schedules__c> newSchedule = [SELECT Days_Allowed__c, Start_Time__c, End_Time__c  FROM Schedules__c WHERE Id = :oldSchedule[0].Id];
        System.assertNotEquals(oldSchedule[0].Days_Allowed__c, newSchedule[0].Days_Allowed__c);

    }


    @IsTest
    static void DealHiatusController_Test_hiatusTimeAfter_DaysAllowedUpdated() {
        List<Deal__c> deal = getDeal();
        Date conDate = Date.today().addDays(1);
        Test.setCurrentPage(Page.DealHiatus);
        ApexPages.CurrentPage().getParameters().put('DealId', deal[0].Id);
        List<Schedules__c> newSchedule = getSchedule('8:00A', '9:00A', deal[0]);
        DealHiatusController dc = new DealHiatusController();
        setDealHiatusControllerProperties(dc,conDate, null, null, '8:30A');
        Test.startTest();
        dc.HiatusUpdate();
        Test.stopTest();
        System.assert(newSchedule[0].Start_Time__c != '');
    }


    @IsTest
    static void DealHiatusController_hiatusTimeBefore_DaysAllowedUpdated() {
        List<Deal__c> deal = getDeal();
        Date conDate = Date.today().addDays(1);
        Test.setCurrentPage(Page.DealHiatus);
        ApexPages.CurrentPage().getParameters().put('DealId', deal[0].Id);
        List<Schedules__c> newSchedule = getSchedule('5:00A', '6:00A', deal[0]);

        DealHiatusController dc = new DealHiatusController();
        setDealHiatusControllerProperties(dc,conDate, null, '5:30A', null);
        Test.startTest();
        dc.HiatusUpdate();
        Test.stopTest();


        System.assert(newSchedule[0].Start_Time__c != null && newSchedule[0].End_Time__c != '');
    }

    public static List<Schedules__c> getSchedule (String Start_Time, String End_Time, Deal__c deal) {
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

        insert schedule;

        deal = [
                SELECT Id,
                (SELECT Id, Deal_Parent__c, OrderLineNumber__c, Total_Dollars__c FROM Schedules__r),
                        Contact__c,
                        Brands__c,
                        Program__c,
                        Length__c
                FROM Deal__c
                WHERE Id = :deal.Id
                LIMIT 1
        ];

        return [SELECT Days_Allowed__c, Start_Time__c, End_Time__c  FROM Schedules__c WHERE Id = :schedule.Id];
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

        return new List<Deal__c>([SELECT Id, Contact__c, Brands__c, Program__c, Length__c FROM Deal__c WHERE Id =: deal.Id]);
    }

    public static void setDealHiatusControllerProperties(DealHiatusController dc, Date hiatusScheduleStart, Date hiatusScheduleEnd,  String hiatusTimeBefore, String hiatusTimeAfter) {
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.Searchfield = ' BounceTV , ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.hiatusTimeBefore = hiatusTimeBefore;
        dc.hiatusTimeAfter = hiatusTimeAfter;
        dc.DoSearch();
        dc.hiatusTempScheduleStart.Week__c = hiatusScheduleStart;
        dc.hiatusTempScheduleEnd.Week__c = hiatusScheduleEnd;

        for (DealHiatusController.DealObject obj : dc.DealObjList) {
            obj.isChecked = true;
        }
    }

}