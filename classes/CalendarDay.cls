/**
 *
 */

public with sharing class CalendarDay extends CalendarPeriod {

    public CalendarDay(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    public override Boolean setDates() {

        super.weekStart = dates.today().addDays(min);
        super.weekEnd = dates.today().addDays(max);

        return true;
    }
}