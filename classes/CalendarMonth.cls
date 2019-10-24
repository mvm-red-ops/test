public with sharing class CalendarMonth extends CalendarPeriod {

    public CalendarMonth(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    public override Boolean setDates() {
        if (thisMonth + min < 1) {
            lookBehind();
        } else if (thisMonth + max > 12) {
            lookAhead();
        } else {
            current();
        }
        return true;
    }

    private void lookBehind() {
        super.weekStart = Date.newInstance(thisYear - 1, 12 + thisMonth + min, 1);
        super.weekEnd =
                (thisMonth + max >= 1)
                        ? toEndOfMonth(Date.newInstance(thisYear, thisMonth + max, 1))
                        : toEndOfMonth(Date.newInstance(thisYear - 1, 12 + thisMonth + max, 1));
    }

    private void lookAhead() {
        super.weekStart =
                (thisMonth + min <= 12)
                        ? Date.newInstance(thisYear, thisMonth + min, 1)
                        : Date.newInstance(thisYear + 1, 12 + thisMonth + min, 1);
        super.weekEnd = toEndOfMonth(Date.newInstance(thisYear + 1, Math.mod(thisMonth + max, 12), 1));
    }

    private void current() {
        super.weekStart = Date.newInstance(thisYear, thisMonth + min, 1);
        super.weekEnd = toEndOfMonth(Date.newInstance(thisYear, thisMonth + max, 1));
    }

    private Date toEndOfMonth(Date d) {
        return d.addMonths(1).toStartOfMonth().addDays(-1);
    }
}