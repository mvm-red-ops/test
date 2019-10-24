public with sharing virtual class FiscalQuarter extends FiscalPeriod {

    public FiscalQuarter(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da, 4);
    }

    private void init() {
        List<Period> periodsQ = periodSelector.getQuarterPeriods();
        for (Period PR : periodsQ) {
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
}