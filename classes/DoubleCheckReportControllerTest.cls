@IsTest
private class DoubleCheckReportControllerTest {

	@IsTest
	public static void testDoubleCheckReportController_doSearch_dealFound() {
		Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();
		createSchedules(deal.Id);

        Test.setCurrentPage(Page.DoubleCheckReportV7);
        //ApexPages.CurrentPage().getParameters().put('DealId', deal.id) ;
        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        String dateString = DealUtils.ReturnStringDate(Date.today());
        
        Test.startTest();
		v7.Searchfield = 'Availability';
		v7.SelectedDateLiteral = '';
		v7.BarterCheckbox = false;
    	v7.SelectedCableSynd = '';
        v7.SelectedDateLiteral = '';
        v7.DoSearch();
		System.assert(v7.DealResultList.size() > 0);
		System.assertEquals(v7.DealResultList[0].Id, deal.Id);
		Test.stopTest();
	}

    @IsTest
    public static void testDoubleCheckReportController_showDetail() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        DoubleCheckReportController dc = new DoubleCheckReportController();

        Test.startTest();
        dc.showDetail();
        
        dc.deal.Program__c=program.Id;
        dc.deal.Client_Account__c=acc.Id;
        dc.deal.Brands__c = brand.Id;
        dc.showDetail();
        
        dc.did = deal.Id;
        dc.searchByDeal();
        
        dc.schedule.Deal_Parent__c = deal.Id;
        dc.showDetail();
        Test.stopTest();
    }
        
    @IsTest
    public static void testDoubleCheckReportController_searchAndSearchByDetail() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();
        
        DoubleCheckReportController dc2 = new DoubleCheckReportController();
        Test.startTest();
        dc2.schedule.Deal_Parent__c = deal.Id;
        dc2.showDetail();
        dc2.search();
        dc2.searchByDeal();
        dc2.save();
        Test.stopTest();
    }
        
    @IsTest
    public static void testDoubleCheckReportController_testUpdates() {  
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        Test.setCurrentPage(Page.DoubleCheckReportV7);
        ApexPages.currentPage().getParameters().put('DealId', deal.Id) ;
        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        String dateString = DealUtils.ReturnStringDate(Date.today());
        v7.dealSelector = new DealTestSelector();
        v7.scheduleSelector = new ScheduleTestSelector();
        v7.Searchfield = ' Test Brand,Test Brand ';
        Test.startTest();
        v7.DoSearch();
        v7.DealId = deal.Id;
        v7.SearchforSchedules();
        v7.ScheduleChange();
        v7.RateUpdate();
        v7.UnitsAvailableUpdate();
        v7.ExtensionUpdate();
        v7.testTabUpdate();
        v7.capTabUpdate();
        v7.dayPartTabUpdate();
        v7.maxTabUpdate();
        v7.cellsave();
        DoubleCheckReportControllerV7.getDayOptions();
        DoubleCheckReportControllerV7.getProgramTeamOptions();
        v7.updateSchedule();
        Test.stopTest();
    }

    @IsTest
    public static void testDoubleCheckReportController_testSave() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();
        Schedules__c sch = createSchedules(deal.Id);


        Test.setCurrentPage(Page.DoubleCheckReportV7);
        ApexPages.currentPage().getParameters().put('DealId', deal.Id) ;
        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        String dateString = DealUtils.ReturnStringDate(Date.today());
        v7.Searchfield = ' Test Brand, Test Brand ';
        Test.startTest();
        v7.DoSearch();
        v7.DealId = deal.Id;
        v7.SelectedOrderLineNumber = '0';
        Date extensionDate = Date.today().toStartOfWeek().addDays(15);
        v7.SelectedExtensionDate = extensionDate.year() + '-' + extensionDate.month() + '-' + extensionDate.day();
		sch.OrderNumber__c = '0';
        sch.Week__c = Date.today().toStartOfWeek().addDays(8);
        update sch;
        v7.currentRateModelIndex = 0;
        v7.currentScheduleId = sch.Id;
        v7.dayPartTabList[0] = new DoubleCheckReportControllerV7.rateModel();
        v7.dayPartTabList[0].weeks.add(new DoubleCheckReportControllerV7.weekModel(Date.today(), sch, false, new DateSelector()));
        
        v7.updateWeeks();
        v7.cellcancel();
        v7.ExtensionSave();
        
        v7.CellId = sch.Id;
        sch.Status__c = 'Canceled';
        update sch;
        v7.LTCsave();
        sch.Status__c = 'Sold';
        update sch;
        v7.LTCsave();
        
        v7.UnitsAvailableSave();
        v7.GhostChecksave();
        v7.TestChecksave();
        
        new DoubleCheckReportControllerV7.weekModel(Date.today(), sch, false, new DateSelector());
        sch.Status__c = 'Canceled';
        new DoubleCheckReportControllerV7.weekModel(Date.today(), sch, false, new DateSelector());
        sch.Status__c = 'Sold';
        sch.TEST__c = true;
        sch.Ghost_Order__c = true;
        (new DoubleCheckReportControllerV7.weekModel(Date.today(), sch, false, new DateSelector())).changerate = 1;
        Test.stopTest();
        
    }
    
    @IsTest public static void test_pageNavigation() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();
        Schedules__c sch = createSchedules(deal.Id);

        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        Test.startTest();
        v7.currentPage = 1;
        v7.loadNextPage();
        v7.loadPrevPage();
        v7.goToPage();
        
        v7.currentPageCap = 1;
        v7.loadNextPageCap();
        v7.loadPrevPageCap();
        v7.goToPageCap();
        
        v7.currentPageMax = 1;
        v7.loadNextPageMax();
        v7.loadPrevPageMax();
        v7.goToPageMax();
        Test.stopTest();
    }
    
    @IsTest public static void DoubleCheck_ReturnSOQL_Empty() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = '';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_Custom() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Custom';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_FiscalYear() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_FiscalQuarter() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString();

        dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 12, 1)));
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_FiscalMonth() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_FiscalWeek() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString();

        dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 12, 30)));
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_CalYear() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_CalQuarter() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString();

        dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 12, 1)));
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_CalMonth() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString();

        dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 12, 10)));
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_CalWeek() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void DoubleCheck_ReturnSOQL_CalDay() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7(new DateSelector(Date.newInstance(2016, 1, 1)));
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString();
    }

    @IsTest public static void test_DoubleCheck_DoSearch() {
        DoubleCheckReportControllerV7 dc = new DoubleCheckReportControllerV7();
        dc.Searchfield = '1,2,3,4,5';
        dc.DoSearch();
    }

    private static Deal__c createDeal(Brands__c brand) {
        Contact con = new Contact(LastName = 'Test', Email = 'test@test.com', Phone = '8001234567') ;
        insert con ;

        Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Length__c = '30');
        insert deal;

        return deal;
    }

    private static Account createAccount() {
        Account acc = new Account();
        acc.Name='test';
        insert acc;
        return acc;
    }

    private static Brands__c createBrand() {
        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
        insert advertiser;

        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.Id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        return brand;
    }

    private static Programs__c createProgram() {
        Programs__c program = new Programs__c();
        program.Name='Availability';
        program.ClientCode__c='123';
        insert program;

        return program;
    }

    private static Schedules__c createSchedules(String dealId){

        Schedules__c sch = new Schedules__c();
        sch.Deal_Parent__c = dealId;
        sch.Rate__c = 100;
        sch.Comments__c = 'test';
        sch.Week__c = System.today().toStartOfWeek().addDays(1);
        sch.Units_Available__c = 1;
        insert sch;

        Schedules__c sch2 = new Schedules__c();
        sch2.Deal_Parent__c = dealId;
        sch2.Rate__c = 100;
        sch2.Comments__c = 'test';
        sch2.Week__c = System.today().toStartOfWeek().addDays(-6);
        sch2.Units_Available__c = 1;
        insert sch2;

        return sch;
    }
}