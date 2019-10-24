public with sharing class CalendarQuarter extends CalendarPeriod {

    public CalendarQuarter(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    public override Boolean setDates() {
        if (getQuarter() + min < 1) {
            super.weekStart = getQuarterStart(dates.today().year() - 1, 4 + getQuarter() + min);
            super.weekEnd =
                    (getQuarter() + max >= 1)
                            ? getQuarterEnd(dates.today().year(), getQuarter())
                            : getQuarterEnd(dates.today().year() - 1, 4 + getQuarter() + max);
        } else if (getQuarter() + max > 4) {
            super.weekStart =
                    (getQuarter() + min <= 4)
                            ? getQuarterStart(dates.today().year(), getQuarter())
                            : getQuarterStart(dates.today().year() + 1, Math.mod(getQuarter() + min, 4));
            super.weekEnd = getQuarterEnd(dates.today().year() + 1, Math.mod(getQuarter() + max, 4));
        } else {
            super.weekStart = getQuarterStart(dates.today().year(), getQuarter() + min);
            super.weekEnd = getQuarterEnd(dates.today().year(), getQuarter() + max);
        }
        return true;
    }

    private Integer getQuarter() {
        if (thisMonth <= 3) {
            return 1;
        } else if (thisMonth <= 6) {
            return 2;
        } else if (thisMonth <= 9) {
            return 3;
        } else {
            return 4;
        }
    }

    private Date getQuarterStart(Integer year, Integer quarter) {
        Integer month;
        if (quarter == 1) {
            month = 1;
        } else if (quarter == 2) {
            month = 4;
        } else if (quarter == 3) {
            month = 7;
        } else {
            month = 10;
        }
        return Date.newInstance(year, month, 1);
    }

    private Date getQuarterEnd(Integer year, Integer quarter) {
        Integer month;
        Integer day = 31;
        if (quarter == 1) {
            month = 3;
        } else if (quarter == 2) {
            month = 6;
            day = 30;
        } else if (quarter == 3) {
            month = 9;
            day = 30;
        } else {
            month = 12;
        }
        return Date.newInstance(year, month, day);
    }
}