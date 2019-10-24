public with sharing class FiscalMonth extends FiscalPeriod {

    public FiscalMonth(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da, 12);
    }

    private Integer pNumber;
    public override Integer currentNum() {
        return pNumber;
    }

    private void init() {
        List<Period> periodsM = periodSelector.getMonthPeriods();
        for (Period PR : periodsM) {
            if (PR.StartDate <= dates.today() && PR.EndDate >= dates.today()) {
                currentPeriod = PR;
            }

            if (periods.containsKey(PR.FiscalYearSettings.Name)) {
                Map<Integer, Period> TempMonthPeriodMap = periods.get(PR.FiscalYearSettings.Name);
                if (PR.Number == null) {
                    TempMonthPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                } else {
                    TempMonthPeriodMap.put(PR.Number, PR);
                }
                periods.put(PR.FiscalYearSettings.Name, TempMonthPeriodMap);
            } else {
                Map<Integer, Period> TempMonthPeriodMap = new Map<Integer, Period>();
                if (PR.Number == null) {
                    TempMonthPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                } else
                {
                    TempMonthPeriodMap.put(PR.Number, PR);
                }
                periods.put(PR.FiscalYearSettings.Name, TempMonthPeriodMap);
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

        pNumber = currentPeriod.Number;
        if (pNumber == null) pNumber = ReturnNumber(currentPeriod.PeriodLabel);

        return calculate(thisYearPeriods, lastYearPeriods, nextYearPeriods);
    }

    public enum MonthNames {
        JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV
    }

    private Integer ReturnNumber(String pMonth) {
        for (MonthNames name : MonthNames.values()) {
            if (pMonth == name.name().toLowerCase() ) {
                return name.ordinal() + 1;
            }
        }
        return 12;
    }
}