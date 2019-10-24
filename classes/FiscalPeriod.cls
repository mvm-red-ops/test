public with sharing virtual class FiscalPeriod extends CalendarPeriod {

    public static PeriodSelector periodSelector = new PeriodSelector();

    public Map<String, Map<Integer, Period>> periods = new Map<String, Map<Integer, Period>>();
    public Period currentPeriod = null;
    public Integer maximumAmt;

    public virtual Integer currentNum() {
        return currentPeriod.Number;
    }

    public FiscalPeriod(Integer mi, Integer ma, DateSelector da, Integer maxAmt) {
        super(mi, ma, da);
        this.maximumAmt = maxAmt;
    }

    public virtual override Boolean setDates() {
        return true;
    }

    public virtual Boolean calculate(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> lastYearPeriods, Map<Integer,Period> nextYearPeriods) {
        if (currentNum() + min < 1) {
            if (lastYearPeriods == null) {
                return false;
            }
            lookBehind(thisYearPeriods, lastYearPeriods);
        }
        else if (currentNum() + max > maximumAmt) {
            if (nextYearPeriods == null) {
                return false;
            }
            lookAhead(thisYearPeriods, nextYearPeriods);
        }
        else {
            if (thisYearPeriods == null) {
                return false;
            }
            current(thisYearPeriods);
        }

        return true;
    }

    public virtual void lookBehind(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> lastYearPeriods) {
        super.weekStart = lastYearPeriods.get(maximumAmt + currentNum() + min).StartDate;
        super.weekEnd =
                (currentNum() + max >= 1)
                        ? thisYearPeriods.get(currentNum() + max).EndDate
                        : lastYearPeriods.get(maximumAmt + currentNum() + max).EndDate;
    }

    public virtual void lookAhead(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> nextYearPeriods) {
        super.weekStart =
                (currentNum() + min <= maximumAmt)
                        ? thisYearPeriods.get(currentNum() + min).StartDate
                        : nextYearPeriods.get(Math.mod(currentNum() + min, maximumAmt)).StartDate;
        super.weekEnd = nextYearPeriods.get(Math.mod(currentNum() + max, maximumAmt)).EndDate;
    }

    public virtual void current(Map<Integer,Period> thisYearPeriods) {
        super.weekStart = thisYearPeriods.get(currentNum() + min).StartDate;
        super.weekEnd = thisYearPeriods.get(currentNum() + max).EndDate;
    }
}