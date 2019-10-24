public with sharing class FiscalPeriodService {
	
	
    public FiscalYearSettings CurrentFY;
    public Period CurrentFP;
    public Period CurrentFW;
    public Period CurrentFM;

	private Map<String, FiscalYearSettings> pFiscalMap;
	private Map<String, Map<Integer,Period>> pQuarterPeriodMap;
	private Map<String, Map<Integer,Period>> pWeekPeriodMap; 
	private Map<String, Map<Integer,Period>> pMonthPeriodMap;  
	
	public Map<String, FiscalYearSettings> FiscalMap {
		get{ 
    		if (pFiscalMap != null) {
    			return pFiscalMap;
    		} 
    		
    		pFiscalMap = new Map<String, FiscalYearSettings>();
			createFiscalMap();
    		return pFiscalMap;
		}
	}

	public Map<String, Map<Integer,Period>> QuarterPeriodMap {
		get {
			if (pQuarterPeriodMap != null) {
				return pQuarterPeriodMap;
			}

			pQuarterPeriodMap = new Map<String, Map<Integer, Period>>();
			createQuarterFiscalPeriodMap();
			return pQuarterPeriodMap;

		}
	}

	public Map<String, Map<Integer, Period>> WeekPeriodMap {
		get{
			if (pWeekPeriodMap != null) {
				return pWeekPeriodMap;
			}

			pWeekPeriodMap = new Map<String, Map<Integer, Period>>();
			createWeekFiscalPeriodMap();
			return pWeekPeriodMap;
		}

	}

	public Map<String, Map<Integer, Period>> MonthPeriodMap {
		get{
			if (pMonthPeriodMap != null) {
				return pMonthPeriodMap;
			} 

			pMonthPeriodMap = new Map<String, Map<Integer, Period>>();
			createMonthFiscalPeriodMap();
			return pMonthPeriodMap;
		}
	}

	private void createFiscalMap() {
 		for (FiscalYearSettings FYS: getFiscalYearSettings()) {
            pFiscalMap.put(FYS.Name, FYS);
            if (FYS.StartDate <= Date.Today() && FYS.EndDate >= Date.Today()) {
                CurrentFY = FYS;
            }
        }
	}
 
    private void createQuarterFiscalPeriodMap() {
        for (Period period : getPeriodByType('Quarter')) {
            if (period.StartDate <= Date.Today() && period.EndDate >= Date.Today()) {
                CurrentFP = period;
            }

			Map<Integer, Period> tempQuarterPeriodMap;
            if (pQuarterPeriodMap.containsKey(period.FiscalYearSEttings.Name)) {
                tempQuarterPeriodMap = QuarterPeriodMap.get(period.FiscalYearSettings.Name);
            } else {
            	tempQuarterPeriodMap = new Map<Integer, Period>();
            }

			tempQuarterPeriodMap.put(period.Number, period);
            pQuarterPeriodMap.put(period.FiscalYearSettings.Name, tempQuarterPeriodMap);
        }
    }

    private void createWeekFiscalPeriodMap() {
        for (Period period : getPeriodByType('Week')) {
            if (period.StartDate <= Date.Today() && period.EndDate >= Date.Today()) {
                CurrentFW = period;
            }

			Map<Integer, Period> tempQuarterPeriodMap;
            if (pWeekPeriodMap.containsKey(period.FiscalYearSEttings.Name)) {
                tempQuarterPeriodMap = WeekPeriodMap.get(period.FiscalYearSettings.Name);
            } else {
                tempQuarterPeriodMap = new Map<Integer, Period>();
            }

            tempQuarterPeriodMap.put(period.Number, period);
            pWeekPeriodMap.put(period.FiscalYearSettings.Name, tempQuarterPeriodMap);
        }
    }

    private void createMonthFiscalPeriodMap() {
        for (Period period : getPeriodByType('Month')) {
            if (period.StartDate <= Date.Today() && period.EndDate >= Date.Today()) {
                CurrentFM = period;
            }

			Map<Integer, Period> tempQuarterPeriodMap;
            if (MonthPeriodMap.containsKey(period.FiscalYearSEttings.Name)) {
                tempQuarterPeriodMap = MonthPeriodMap.get(period.FiscalYearSettings.Name);
            } else {
                tempQuarterPeriodMap = new Map<Integer, Period>();
            }

            if (period.Number == null) {
                tempQuarterPeriodMap.put(monthToNumber(period.PeriodLabel), period);
            } else {
                tempQuarterPeriodMap.put(period.Number, period);
            }

            MonthPeriodMap.put(period.FiscalYearSettings.Name, tempQuarterPeriodMap);
        }
    }

	public static Integer monthToNumber(String pMonth) {
        if (pMonth.toLowerCase() == 'jan') {
            return 1;
        } else if (pMonth.ToLowerCase() == 'feb') {
            return 2;
        } else if (pMonth.ToLowerCase() == 'mar') {
            return 3;
        } else if (pMonth.ToLowerCase() == 'apr') {
            return 4;
        } else if (pMonth.ToLowerCase() == 'may') {
            return 5;
        } else if (pMonth.ToLowerCase() == 'jun') {
            return 6;
        } else if (pMonth.ToLowerCase() == 'jul') {
            return 7;
        } else if (pMonth.ToLowerCase() == 'aug') {
            return 8;
        } else if (pMonth.ToLowerCase() == 'sep') {
            return 9;
        } else if (pMonth.ToLowerCase() == 'oct') {
            return 10;
        } else if (pMonth.ToLowerCase() == 'nov') {
            return 11;
        } else {
            return 12;
        }
    }

	private List<FiscalYearSettings> getFiscalYearSettings() {
        return [SELECT Id,
                       Name,
                       StartDate,
                       EndDate
                  FROM FiscalYearSettings];
    }

    private List<Period> getPeriodByType(String type) {
        return [SELECT Id, 
                       FiscalYearSettings.Name, 
                       StartDate, 
                       EndDate, 
                       Number,
					   PeriodLabel 
                  FROM Period 
                 WHERE Type = :type];
    }
}