@isTest
public class TestDoubleCheckReportController{

    private static Deal__c createDeal(Brands__c brand) {
        Contact con = new Contact(LastName = 'Test', Email = Utils.randomString(12).toLowerCase() + '@test.com', Phone = '8001234567') ;
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
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        return brand;
    }

    private static Programs__c createProgram() {

        Programs__c program = new Programs__c();
        program.Name='testProgram';
        program.ClientCode__c='123';
        insert program;

        return program;
    }

    public static Schedules__c createSchedules(String dealId){

        Schedules__c sch = new Schedules__c();
        sch.Deal_Parent__c = dealId;
        sch.Rate__c = 100;
        sch.Comments__c = 'test';
        sch.week__c = system.today().toStartOfWeek().addDays(1);
        sch.Units_Available__c = 1;
        insert sch;

        Schedules__c sch2 = new Schedules__c();
        sch2.Deal_Parent__c = dealId;
        sch2.Rate__c = 100;
        sch2.Comments__c = 'test';
        sch2.week__c = system.today().toStartOfWeek().addDays(-6);
        sch2.Units_Available__c = 1;
        insert sch2;

        return sch;
    }

    @isTest
    public static void testDoubleCheckReportController_showDetail() {

        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        DoubleCheckReportController dc = new DoubleCheckReportController();

        Test.startTest();
        dc.showDetail();

        dc.deal.Program__c=program.id;
        dc.deal.Client_Account__c=acc.id;
        dc.deal.Brands__c = brand.id;
        dc.showDetail();

        dc.did = deal.id;
        dc.searchByDeal();

        dc.schedule.Deal_Parent__c = deal.id;
        dc.showDetail();
        Test.stopTest();
    }

    @isTest
    public static void testDoubleCheckReportController_searchAndSearchByDetail() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        DoubleCheckReportController dc2 = new DoubleCheckReportController();
        Test.startTest();
        dc2.schedule.Deal_Parent__c = deal.id;
        dc2.showDetail();
        dc2.search();
        dc2.searchByDeal();
        dc2.save();
        Test.stopTest();
    }

    @isTest
    public static void testDoubleCheckReportController_testUpdates() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        Test.setCurrentPage(Page.DoubleCheckReportV7);
        ApexPages.CurrentPage().getParameters().put('DealId', deal.id) ;
        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        String dateString = v7.ReturnStringDate(date.today());
        v7.searchField = 'Test Brand';
        Test.startTest();
        v7.DoSearch();
        v7.DealId = deal.Id;
        v7.SearchForSchedules();
        v7.ScheduleChange();
        v7.RateUpdate();
        v7.UnitsAvailableUpdate();
        v7.ExtensionUpdate();
        v7.testTabUpdate();
        v7.capTabUpdate();
        v7.dayPartTabUpdate();
        v7.maxTabUpdate();
        v7.cellsave();
        v7.getDayOptions();
        v7.getProgramTeamOptions();
        v7.updateSchedule();
        Test.stopTest();
    }

    @isTest
    public static void testDoubleCheckReportController_testSave() {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();
        Schedules__c sch = createSchedules(deal.Id);


        Test.setCurrentPage(Page.DoubleCheckReportV7);
        ApexPages.CurrentPage().getParameters().put('DealId', deal.id) ;
        DoubleCheckReportControllerV7 v7 = new DoubleCheckReportControllerV7();
        String dateString = v7.ReturnStringDate(date.today());
        v7.searchField = 'Test Brand';
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
        v7.dayPartTabList[0] = new DoubleCheckReportControllerV7.RateModel();
        v7.dayPartTabList[0].weeks.add(new DoubleCheckReportControllerV7.WeekModel(Date.today(), sch, false));

        v7.updateWeeks();
        v7.cellcancel();
        v7.ExtensionSave();

        v7.cellId = sch.Id;
        sch.Status__c = 'Canceled';
        update sch;
        v7.LTCsave();
        sch.Status__c = 'Sold';
        update sch;
        v7.LTCsave();

        v7.UnitsAvailableSave();
        v7.GhostChecksave();
        v7.TestChecksave();

        new DoubleCheckReportControllerV7.WeekModel(Date.today(), sch, false);
        sch.Status__c = 'Canceled';
        new DoubleCheckReportControllerV7.WeekModel(Date.today(), sch, false);
        sch.Status__c = 'Sold';
        sch.TEST__c = true;
        sch.Ghost_Order__c = true;
        (new DoubleCheckReportControllerV7.WeekModel(Date.today(), sch, false)).changerate = 1;
        test.stopTest();

    }

    @isTest public static void test_pageNavigation() {
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
}