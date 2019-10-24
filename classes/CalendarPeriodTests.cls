@IsTest
private class CalendarPeriodTests {

    private static Date dec31 = Date.newInstance(2014, 12, 31);
    private static Date jan1 = Date.newInstance(2015, 1, 1);
    private static Date jun15 = Date.newInstance(2015, 6, 15);

    @IsTest private static void Calendar_Year_Behind() {
        CalendarYear period = new CalendarYear(-2, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2013, period.weekStart.year());
        System.assertEquals(2015, period.weekEnd.year());
    }

    @IsTest private static void Calendar_Year_Current() {
        CalendarYear period = new CalendarYear(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(2015, period.weekEnd.year());
    }

    @IsTest private static void Calendar_Year_Ahead() {
        CalendarYear period = new CalendarYear(0, 2, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(2016, period.weekEnd.year());
    }

    @IsTest private static void Calendar_Quarter_Behind() {
        CalendarQuarter period = new CalendarQuarter(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(10, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(3, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Quarter_Current() {
        CalendarQuarter period = new CalendarQuarter(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(4, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Quarter_Ahead() {
        CalendarQuarter period = new CalendarQuarter(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(10, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(3, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Month_Behind() {
        CalendarMonth period = new CalendarMonth(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Month_Current() {
        CalendarMonth period = new CalendarMonth(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(6, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Month_Ahead() {
        CalendarMonth period = new CalendarMonth(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Week_Behind() {
        CalendarWeek period = new CalendarWeek(-1, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Week_Current() {
        CalendarWeek period = new CalendarWeek(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(6, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Week_Ahead() {
        CalendarWeek period = new CalendarWeek(0, 1, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
    }

    @IsTest private static void Calendar_Day_Behind() {
        CalendarDay period = new CalendarDay(-31, 0, new DateSelector(jan1));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(1, period.weekStart.day());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
        System.assertEquals(1, period.weekEnd.day());
    }

    @IsTest private static void Calendar_Day_Current() {
        CalendarDay period = new CalendarDay(0, 0, new DateSelector(jun15));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2015, period.weekStart.year());
        System.assertEquals(6, period.weekStart.month());
        System.assertEquals(15, period.weekStart.day());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(6, period.weekEnd.month());
        System.assertEquals(15, period.weekEnd.day());
    }

    @IsTest private static void Calendar_Day_Ahead() {
        CalendarDay period = new CalendarDay(0, 31, new DateSelector(dec31));
        System.assertEquals(true, period.setDates(), 'Dates were not set properly');
        System.assertEquals(2014, period.weekStart.year());
        System.assertEquals(12, period.weekStart.month());
        System.assertEquals(31, period.weekStart.day());
        System.assertEquals(2015, period.weekEnd.year());
        System.assertEquals(1, period.weekEnd.month());
        System.assertEquals(31, period.weekEnd.day());
    }
}