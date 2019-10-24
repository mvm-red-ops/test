public with sharing class FiscalYear extends CalendarPeriod {

    public static FiscalYearSettingsSelector fysSelector = new FiscalYearSettingsSelector();

    private Map<String, FiscalYearSettings> years = new Map<String, FiscalYearSettings>();
    private FiscalYearSettings CurrentFY = null;

    public FiscalYear(Integer mi, Integer ma, DateSelector da) {
        super(mi, ma, da);
    }

    private void init() {
        List<FiscalYearSettings> fiscalYearSettings = fysSelector.getFiscalYearSettings();
        System.debug(fiscalYearSettings);
        for (FiscalYearSettings FYS : fiscalYearSettings) {
            years.put(FYS.Name, FYS);
            if (FYS.StartDate <= dates.today() && FYS.EndDate >= dates.today()) {
                CurrentFY = FYS;
            }
        }
    }

    public override Boolean setDates() {
        init();

        if (CurrentFY == null) return false;

        for (Integer i = min; i <= max; i++) {
            if (years.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) + i))) {
                FiscalYearSettings FYS = years.get(String.valueOf(Integer.valueOf(CurrentFY.Name) + i));
                if (i == min) {
                    if (FYS == null) return false;
                    super.weekStart = FYS.StartDate;
                }
                if (i == max) {
                    if (FYS == null) return false;
                    super.weekEnd = FYS.EndDate;
                }
            }
        }
        return true;
    }
}