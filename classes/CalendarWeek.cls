public with sharing class CalendarWeek extends CalendarPeriod {

    public CalendarWeek(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    public override Boolean setDates() {
        super.weekStart = dates.today().toStartOfWeek().addDays(7 * min);
        super.weekEnd = dates.today().toStartOfWeek().addDays(7 * (max + 1)).addDays(-1);

        return true;
    }
}