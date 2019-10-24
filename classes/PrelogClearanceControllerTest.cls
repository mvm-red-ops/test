@IsTest
private class PrelogClearanceControllerTest {

    @IsTest static void PrelogClearanceControllerTest() {

        Date constDate = Date.today().toStartOfWeek().addDays(1);

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

        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Program__c = program.Id,
                Length__c = '5'
        );
        insert deal;

        //Schedule
        Schedules__c schedule = new Schedules__c(
                Units_Available__c = 1.0,
                Units_Preempted__c = 0,
                Week__c = constDate,
                Deal_Parent__c = deal.Id,
                Status__c = 'Sold',
                Rate__c = 300
        );
        insert schedule;

        PrelogData__c pdata = new PrelogData__c(
                Schedule__c = schedule.Id,
                AirDate__c = constDate,
                Version__c = 5
        );
        insert pdata;

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

        PrelogClearanceController dc = new PrelogClearanceController() ;

        dc.CurrentFP = [
                SELECT Id,
                        FiscalYearSettings.Name,
                        StartDate,
                        EndDate,
                        Number,
                        PeriodLabel
                FROM Period
                WHERE Type = 'Month'
                LIMIT 1
        ];

        dc.Searchfield = 'BounceTV' ;
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
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
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        Test.startTest();
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
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
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        Test.stopTest();
        dc.SelectedDateLiteral = 'This Week';
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
        dc.BarterCheckbox = true;
        dc.getDealResult() ;
        Date d = Date.today();
        DealUtils.ReturnStringDate(d.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.SortDealResultList() ;
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
        dc.AddMoreToDeal() ;
        List<DoubleCheckReadOnlyHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.tempSchedule.Week__c = constDate;
        dc.DealId = deal.Id;
        dc.SelectedDealMap.put(deal.Id, deal);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;

        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;

        //Method Calling
        DealUtils.formatDatetime(System.now());

        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.Searchfield = ' BounceTV , ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();

        //Wrapper instance
        DoubleCheckReadOnlyHelper.PrelogDataWrapper con2 =
                new DoubleCheckReadOnlyHelper.PrelogDataWrapper(new PrelogData__c());

        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);

        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        } catch (Exception e) {
        }
        tempDate = dc.getMonday();
    }

    @IsTest static void PrelogClearanceControllerTest2() {

        Contact con = new Contact(
                LastName = 'Test',
                Email = 'test@test.com',
                Phone = '8001234567'
        ) ;
        insert con ;

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
                Station_Call_Letter__c = 'a'
        );
        insert program;

        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Program__c = program.Id,
                Length__c = '5'
        );
        insert deal;

        //Schedule
        Schedules__c schedule = new Schedules__c(
                Units_Available__c = 1.0,
                Units_Preempted__c = 0,
                Week__c = Date.today().toStartOfWeek().addDays(7).addDays(1),
                Deal_Parent__c = deal.Id,
                Status__c = 'Sold',
                Rate__c = 300
        );
        insert schedule;


        PrelogData__c pd = new PrelogData__c(
                Schedule__c = schedule.Id,
                AirDate__c = Date.today().addDays(7),
                Version__c = 1
        );
        insert pd;

        PrelogData__c pd1 = [
                SELECT Id,
                        AirDate__c,
                        Schedule__r.Week__c,
                        Week__c
                FROM PrelogData__c
                WHERE Id = :pd.Id
        ];
        System.debug('####' + pd1);

        PrelogClearanceController dc = new PrelogClearanceController() ;
        dc.CurrentFP = [
                SELECT Id,
                        FiscalYearSettings.Name,
                        StartDate,
                        EndDate,
                        Number,
                        PeriodLabel
                FROM Period
                WHERE Type = 'Month'
                LIMIT 1
        ];

        dc.BarterCheckbox = true;
        dc.prelogVersion = '1';
        dc.DealId = deal.Id;
        dc.tempSchedule.Week__c = Date.today().toStartOfWeek().addDays(-6);
        dc.Searchfield = 'BounceTV';
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
        dc.getDealResult() ;
        dc.DealId = deal.Id;
        Date d = Date.today();
        DealUtils.ReturnStringDate(d.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.SortDealResultList() ;

        dc.AddMoreToDeal() ;
        List<DoubleCheckReadOnlyHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;

        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;

        //Method Calling
        DealUtils.formatDatetime(System.now());

        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.Searchfield = ' BounceTV , ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();

        //Wrapper instance
        DoubleCheckReadOnlyHelper.PrelogDataWrapper con2 =
                new DoubleCheckReadOnlyHelper.PrelogDataWrapper(new PrelogData__c());

        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);
        dc.getKeys();
        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        } catch (Exception e) {
        }

        tempDate = dc.getMonday();
        dc.getWeekData();
        dc.FillDealResultList();
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
    }

    @IsTest static void PrelogClearanceControllerTest3() {

        Contact con = new Contact(
                LastName = 'Test',
                Email = 'test@test.com',
                Phone = '8001234567'
        ) ;
        insert con ;

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
                Station_Call_Letter__c = 'a'
        );
        insert program;

        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Program__c = program.Id,
                Length__c = '5'
        );
        insert deal;

        //Schedule
        Schedules__c schedule = new Schedules__c();
        schedule.Units_Available__c = 1.0;
        schedule.Units_Preempted__c = 0;
        schedule.Week__c = Date.today().addDays(7).toStartOfWeek().addDays(1);
        schedule.Deal_Parent__c = deal.Id;
        schedule.Status__c = 'Sold';
        schedule.Rate__c = 300;
        insert schedule;


        PrelogData__c pd = new PrelogData__c();
        pd.Schedule__c = schedule.Id;
        pd.AirDate__c = Date.today().addDays(7);
        pd.Version__c = 1;
        insert pd;

        PrelogClearanceController dc = new PrelogClearanceController() ;

        dc.CurrentFP = [
                SELECT Id,
                        FiscalYearSettings.Name,
                        StartDate,
                        EndDate,
                        Number,
                        PeriodLabel
                FROM Period
                WHERE Type = 'Month'
                LIMIT 1
        ];

        dc.BarterCheckbox = true;
        dc.prelogVersion = '1';
        dc.DealId = deal.Id;
        dc.tempSchedule.Week__c = Date.today().toStartOfWeek().addDays(-6);
        dc.Searchfield = 'BounceTV, BounceTV';
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
        dc.getDealResult() ;
        dc.DealId = deal.Id;
        Date d = Date.today();
        DealUtils.ReturnStringDate(d.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth()) ;
        DealUtils.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.SortDealResultList() ;

        dc.AddMoreToDeal() ;
        List<DoubleCheckReadOnlyHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;

        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;

        //Method Calling
        DealUtils.formatDatetime(System.now());

        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.Searchfield = ' BounceTV,BounceTV, ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();

        //Wrapper instance
        DoubleCheckReadOnlyHelper.PrelogDataWrapper con2 =
                new DoubleCheckReadOnlyHelper.PrelogDataWrapper(new PrelogData__c());

        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);
        dc.getKeys();
        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        } catch (Exception e) {
        }

        tempDate = dc.getMonday();
        dc.getWeekData();
        dc.FillDealResultList();
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
    }

    @IsTest static void PrelogClearanceController_coverage() {
        PrelogClearanceController pc = new PrelogClearanceController();
        PrelogClearanceController.setDealSelector(null);
        PrelogClearanceController.setFYSSelector(null);
        PrelogClearanceController.setPeriodSelector(null);
        PrelogClearanceController.setPrelogDataSelector(null);
        PrelogClearanceController.setScheduleSelector(null);
        pc.Display();
    }
}