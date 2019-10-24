public with sharing class CalendarYear extends CalendarPeriod {

    public CalendarYear(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    public override Boolean setDates() {
        super.weekStart = Date.newInstance(dates.today().year() + min,1,1);
        super.weekEnd = Date.newInstance(dates.today().year() + max,12,31);

        return true;
    }
}