public with sharing class FiscalWeek extends FiscalPeriod {

    public FiscalWeek(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da, 52);
    }

    private void init() {
        List<Period> periodsW = periodSelector.getWeekPeriods();
        for (Period PR : periodsW) {
            if (PR.StartDate <= dates.today() && PR.EndDate >= dates.today()) {
                currentPeriod = PR;
            }

            if (periods.containsKey(PR.FiscalYearSettings.Name)) {
                Map<Integer, Period> TempQuarterPeriodMap = periods.get(PR.FiscalYearSettings.Name);
                TempQuarterPeriodMap.put(PR.Number, PR);
                periods.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            } else {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                TempQuarterPeriodMap.put(PR.Number, PR);
                periods.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }
    }

    public override Boolean setDates() {
        init();

        if (currentPeriod == null) return false;

        Map<Integer,Period> lastYearPeriods = periods.get(
                String.valueOf((Integer.valueOf(currentPeriod.FiscalYearSettings.Name) - 1))
        );
        Map<Integer,Period> thisYearPeriods = periods.get(
                currentPeriod.FiscalYearSettings.Name
        );
        Map<Integer,Period> nextYearPeriods = periods.get(
                String.valueOf((Integer.valueOf(currentPeriod.FiscalYearSettings.Name) + 1))
        );
        
        return calculate(thisYearPeriods, lastYearPeriods, nextYearPeriods);
    }

    public override Boolean calculate(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> lastYearPeriods, Map<Integer,Period> nextYearPeriods) {
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

    public override void lookBehind(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> lastYearPeriods) {
        Integer numWeeks = maximumAmt;
        if (lastYearPeriods.get(maximumAmt + 1) != null) {
            numWeeks++;
        }
        super.weekStart = lastYearPeriods.get(numWeeks + currentNum() + min).StartDate;
        super.weekEnd = lastYearPeriods.get(numWeeks + currentNum() + max).EndDate;
    }

    public override void lookAhead(Map<Integer,Period> thisYearPeriods, Map<Integer,Period> nextYearPeriods) {
        if (thisYearPeriods.get(maximumAmt + 1) != null) {
            super.weekStart = thisYearPeriods.get(currentNum() + min).StartDate;
            super.weekEnd = thisYearPeriods.get(currentNum() + max).EndDate;
        } else {
            super.weekStart = nextYearPeriods.get(Math.mod(currentNum() + min, maximumAmt)).StartDate;
            super.weekEnd = nextYearPeriods.get(Math.mod(currentNum() + max, maximumAmt)).EndDate;
        }
    }

    public override void current(Map<Integer,Period> thisYearPeriods) {
        super.weekStart = thisYearPeriods.get(currentNum() + min).StartDate;
        super.weekEnd = thisYearPeriods.get(currentNum() + max).EndDate;
    }
}