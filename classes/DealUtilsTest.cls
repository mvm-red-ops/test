@IsTest
private class DealUtilsTest {

    @IsTest
    static void DealUtils_ReturnNumber() {
        System.assertEquals(1, DealUtils.ReturnNumber('Jan'));
        System.assertEquals(2, DealUtils.ReturnNumber('Feb'));
        System.assertEquals(3, DealUtils.ReturnNumber('Mar'));
        System.assertEquals(4, DealUtils.ReturnNumber('Apr'));
        System.assertEquals(5, DealUtils.ReturnNumber('May'));
        System.assertEquals(6, DealUtils.ReturnNumber('Jun'));
        System.assertEquals(7, DealUtils.ReturnNumber('Jul'));
        System.assertEquals(8, DealUtils.ReturnNumber('Aug'));
        System.assertEquals(9, DealUtils.ReturnNumber('Sep'));
        System.assertEquals(10, DealUtils.ReturnNumber('Oct'));
        System.assertEquals(11, DealUtils.ReturnNumber('Nov'));
        System.assertEquals(12, DealUtils.ReturnNumber('Dec'));
    }

    @IsTest
    static void DealUtils_ReturnStringDate() {
        Date d = Date.newInstance(2000, 1, 12);
        System.assertEquals('2000-01-12', DealUtils.ReturnStringDate(d));
    }

    @IsTest
    static void DealUtils_FormatDateTime() {
        Datetime d = Datetime.newInstance(2000, 1, 12);
        System.assertEquals('2000-01-12T00:00:00-05:00', DealUtils.formatDatetime(d));
    }

    @IsTest
    static void DealUtils_CustomCalendarPeriods() {
        DealUtils.getCustomCalendarPeriods(new DateSelector());
    }

    @IsTest
    static void DealUtils_CreateHiatus() {
        DealUtils.createHiatusTimeSelectList();
    }

    @IsTest
    static void DealUtils_coverage() {
        DealUtils.ReturnCableSyndSOList();
        DealUtils.ReturnDateLiteralSOList();
        DealUtils.ReturnTeamOptions();
        DealUtils.handleException(new FakeException('Test'));
    }

    private class FakeException extends Exception {}
}