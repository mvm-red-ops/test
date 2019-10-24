/**
 * DealRevisionControllerTest
 * @description
 */

@IsTest
private class DealRevisionControllerTest {
    @IsTest
    static void DealRevisionController_UpdateDateField() {
        DealRevisionController drc = new DealRevisionController();

        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();

        System.assertNotEquals(null,drc.WeekStartDate.Week__c);
        System.assertNotEquals(null,drc.WeekEndDate.Week__c);
        System.assertEquals(
                ' AND ( Week_MIN_Field__c >= ' + DealUtils.ReturnStringDate(drc.WeekStartDate.Week__c)
                + ' AND Week_MIN_Field__c <= ' + DealUtils.ReturnStringDate(drc.WeekEndDate.Week__c) + ' ) ',
                drc.dateSOQLString);
    }

    @IsTest
    static void DealRevisionController_SearchDeals_Success() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        System.assertEquals(false, drc.dealQueryExt.deals.isEmpty());
    }

    @IsTest
    static void DealRevisionController_SearchDeals_NoDate() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();

        drc.searchString = 'a';
        drc.SearchDeals();

        System.assertEquals(false, drc.dealQueryExt.deals.isEmpty());
    }

    @IsTest
    static void DealRevisionController_SearchDeals_NoResults() {
        DealRevisionController drc = new DealRevisionController();

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        System.assertEquals(true, drc.dealQueryExt.deals.isEmpty());
    }

    @IsTest
    static void DealRevisionController_SearchDeals_NoSearchString() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();

        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        System.assertEquals(true, drc.dealQueryExt.deals.isEmpty());
        System.assertEquals(false, ApexPages.getMessages().isEmpty());
    }

    @IsTest
    static void DealRevisionController_coverage() {
        DealRevisionController drc = new DealRevisionController();
        System.assertNotEquals(null, drc.cableSyndDropList);
        System.assertNotEquals(null, drc.teamDropList);
        System.assertNotEquals(null, drc.dateRangeDropList);
    }

    @IsTest
    static void DealQueryExt_SelectDeal_Success() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();
        DealQueryExtension dqe = drc.dealQueryExt;
        DealUpdateExtension due = drc.dealUpdateExt;

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        Deal__c deal = dqe.deals.get(0);
        dqe.selectedDealId = deal.Id;
        dqe.selectDeal();

        System.assertEquals(deal.Id,due.selectedDeal.Id);
        System.assertEquals(false, ApexPages.getMessages().isEmpty());
    }

    @IsTest
    static void DealQueryExt_SelectDeal_Null() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();
        DealQueryExtension dqe = drc.dealQueryExt;
        DealUpdateExtension due = drc.dealUpdateExt;

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        dqe.selectedDealId = 'a0AC0000031P3mrMAA';
        dqe.selectDeal();

        System.assertEquals(null,due.selectedDeal);
        System.assertEquals(false, ApexPages.getMessages().isEmpty());
    }

    @IsTest
    static void DealUpdateExt_SearchForSchedules_Success() {
        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealSelectorTest();
        DealQueryExtension dqe = drc.dealQueryExt;
        DealUpdateExtension due = drc.dealUpdateExt;

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        Deal__c deal = dqe.deals.get(0);
        dqe.selectedDealId = deal.Id;
        dqe.selectDeal();

        due.SearchforSchedules();

        System.assertEquals(false, due.showtable);
    }

    @IsTest
    static void DealUpdateExt_coverage() {
        DealRevisionController drc = new DealRevisionController();
        DealQueryExtension dqe = drc.dealQueryExt;
        DealUpdateExtension due = drc.dealUpdateExt;

        try {
            due.loadNextPage();
            due.loadNextPageCap();
            due.loadNextPageMax();

            due.loadPrevPage();
            due.loadPrevPageCap();
            due.loadPrevPageMax();

            due.goToPage();
            due.goToPageCap();
            due.goToPageMax();

            due.cellcancel();
            System.assert(true);
        } catch (Exception e) {
            System.assert(false);
        }
    }
}