@IsTest
private class FiscalPeriodTests {

    private static Date dec31 = Date.newInstance(2014, 12, 31);
    private static Date jan1 = Date.newInstance(2015, 1, 1);
    private static Date jun15 = Date.newInstance(2015, 6, 15);

    @IsTest private static void Fiscal_Year_Behind() {
        FiscalYear period = new FiscalYear(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2013, period.weekStart.year());
        System.assertEquals(2015, period.weekEnd.year());
    }

    @IsTest private static void Fiscal_Year_Current() {
        FiscalYear period = new FiscalYear(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(2015, period.weekEnd.year());
    }

    @IsTest private static void Fiscal_Year_Ahead() {
        FiscalYear period = new FiscalYear(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(2016, period.weekEnd.year());
    }

    @IsTest private static void Fiscal_Quarter_Behind() {
        FiscalQuarter period = new FiscalQuarter(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(9, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(3, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Quarter_Current() {
        FiscalQuarter period = new FiscalQuarter(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(3, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Quarter_Ahead() {
        FiscalQuarter period = new FiscalQuarter(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Month_Behind() {
        FiscalMonth period = new FiscalMonth(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Month_Current() {
        FiscalMonth period = new FiscalMonth(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(6, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Month_Ahead() {
        FiscalMonth period = new FiscalMonth(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(2, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Week_Behind() {
        FiscalWeek period = new FiscalWeek(-1, -1, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2014, period.weekEnd.year());
        System.assertEquals(12, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Week_Current() {
        FiscalWeek period = new FiscalWeek(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(6, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Fiscal_Week_Ahead() {
        FiscalWeek period = new FiscalWeek(1, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(1, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }
}