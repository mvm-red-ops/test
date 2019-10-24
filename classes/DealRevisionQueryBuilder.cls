public with sharing class DealRevisionQueryBuilder {

	private String selectedDateLiteral;
	private FiscalYearSettings CurrentFY;
    private Period CurrentFP;
    private Period CurrentFW;
    public Period CurrentFM;

	private Map<String, FiscalYearSettings> fiscalMap;
	private Map<String, Map<Integer,Period>> quarterPeriodMap;
	private Map<String, Map<Integer,Period>> weekPeriodMap; 
	private Map<String, Map<Integer,Period>> monthPeriodMap;

	public Schedules__c WeekStartDate = new Schedules__c();
	public Schedules__c WeekEndDate = new Schedules__c();

	public DealRevisionQueryBuilder(String selectedDateLiteral) {
		this.selectedDateLiteral = selectedDateLiteral;

		FiscalPeriodService service = new FiscalPeriodService();
		fiscalMap = service.FiscalMap;
	}

    public String ReturnStringDate(Date pDate) {
        String pString = String.valueOf(pDate.year()) + '-';

        if (pDate.month() < 10) {
            pString += '0' + String.valueOf(pDate.month()) + '-';
        } else {
            pString += String.valueOf(pDate.month()) + '-';
        }

        if (pDate.day() < 10) {
            pString += '0' + String.valueOf(pDate.day());
        } else {
            pString += String.valueOf(pDate.day());
        }

        return pString;
    }

	private void setWeekDates(Date startDate, Date endDate) {
		WeekStartDate.Week__c = startDate;
        WeekEndDate.Week__c = endDate;
	} 


	public String ReturnSOQLDateString() {
		String SOQLDateString;
		
            if (selectedDateLiteral == null || selectedDateLiteral == '') {
                SOQLDateString = '';
            } else {
				

                if (selectedDateLiteral == 'Custom') {
                    if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                        SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
                    } else {
                        SOQLDateString = '';
                    }
                } else if (selectedDateLiteral == 'Previous FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_YEAR ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1))) {
                            FiscalYearSettings FYS = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            setWeekDates(FYS.StartDate, FYS.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == 'Previous 2 FY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = LAST_FISCAL_YEAR ) ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2))) {
                            FiscalYearSettings FYS1 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            setWeekDates(FYS2.StartDate, FYS1.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == '2 FY Ago') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2))) {
                            FiscalYearSettings FYS = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            setWeekDates(FYS.StartDate, FYS.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == 'Current FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            setWeekDates(FYS.StartDate, FYS.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Previous FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS1 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            setWeekDates(FYS1.StartDate, FYS2.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Previous 2 FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)) && fiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS1 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            FiscalYearSettings FYS2 = fiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                             setWeekDates(FYS1.StartDate, FYS2.EndDate);
                        }
                    }
                } else if (selectedDateLiteral == 'Current FQ') {
                    if (CurrentFP != null) {
                        setWeekDates(CurrentFP.StartDate, CurrentFP.EndDate);
                    }
                } else if (selectedDateLiteral == 'Current And Next FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 4) {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    setWeekDates(CurrentFP.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (quarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    setWeekDates(CurrentFP.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Previous FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    setWeekDates(TempPeriod.StartDate, CurrentFP.EndDate);
                                }
                            }
                        } else {
                            if (quarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    setWeekDates(TempPeriod.StartDate, CurrentFP.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Next FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 4) {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                        else {
                            if (quarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Previous FQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_QUARTER ';
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (quarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Next 3 FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    setWeekDates(CurrentFP.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (quarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = quarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number - 1);
                                    setWeekDates(CurrentFP.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Last FP') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_PERIOD ';
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = FiscalPeriodService.monthToNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 1) {
                            if (monthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12)) {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (monthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
									setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'This FP') {
                    if (CurrentFM != null) {
						setWeekDates(CurrentFM.StartDate, CurrentFM.EndDate);
                    }
                } else if (selectedDateLiteral == 'Next FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = FiscalPeriodService.monthToNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 12) {
                            if (monthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (monthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Previous FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = FiscalPeriodService.monthToNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 1) {
                            if (monthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12)) {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    setWeekDates(TempPeriod.StartDate, CurrentFM.EndDate);
                                }
                            }
                        } else {
                            if (monthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    setWeekDates(TempPeriod.StartDate, CurrentFM.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Current And Next FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = FiscalPeriodService.monthToNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 12) {
                            if (monthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    setWeekDates(CurrentFM.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (monthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = monthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    setWeekDates(CurrentFM.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Last FW') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    if (CurrentFW != null) {
                        if (CurrentFW.Number == 1) {
                            if (weekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = weekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(53)) {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                } else if (TempPeriodMap.containsKey(52)) {
                                    Period TempPeriod = TempPeriodMap.get(52);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else {
                            if (weekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = weekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(CurrentFW.Number - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number - 1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'This FW') {
                    if (CurrentFW != null) {
                        setWeekDates(CurrentFW.StartDate, CurrentFW.EndDate);
                    }
                } else if (selectedDateLiteral == 'Next FW') {
                    if (CurrentFW != null) {
                        if (CurrentFW.Number == 53) {
                            if (weekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = weekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        } else if (CurrentFW.Number == 52) {
                            if (weekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = weekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(53)) {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                } else {
                                    if (weekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1))) {
                                        Map<Integer, Period> TempPeriodMap1 = weekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                        if (TempPeriodMap1.containsKey(1)) {
                                            Period TempPeriod = TempPeriodMap1.get(1);
                                            setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                        }
                                    }
                                }
                            }
                        } else {
                            if (weekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)))) {
                                Map<Integer, Period> TempPeriodMap = weekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)));
                                if (TempPeriodMap.containsKey(CurrentFW.Number + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number + 1);
                                    setWeekDates(TempPeriod.StartDate, TempPeriod.EndDate);
                                }
                            }
                        }
                    }
                } else if (selectedDateLiteral == 'Current CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_YEAR ';
                    setWeekDates(Date.newInstance(Date.today().year(), 1, 1), Date.newInstance(Date.today().year(), 12,31));
                } else if (selectedDateLiteral == 'Previous CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_YEAR ';
                    setWeekDates(Date.newInstance(Date.today().year() - 1, 1, 1), Date.newInstance(Date.today().year() - 1, 12,31));
                } else if (selectedDateLiteral == 'Previous 2 CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 ) ';
                    setWeekDates(Date.newInstance(Date.today().year() - 2, 1, 1), Date.newInstance(Date.today().year() -1, 12,31));
                } else if (selectedDateLiteral == '2 CY Ago') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    setWeekDates(Date.newInstance(Date.today().year() - 2, 1, 1), Date.newInstance(Date.today().year() -2, 12,31));
                } else if (selectedDateLiteral == 'Next CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_YEAR ';
                    setWeekDates(Date.newInstance(Date.today().year() +1, 1, 1), Date.newInstance(Date.today().year() +1, 12,31));
                } else if (selectedDateLiteral == 'Current And Previous CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    setWeekDates(Date.newInstance(Date.today().year() -1, 1, 1), Date.newInstance(Date.today().year(), 12,31));
                } else if (selectedDateLiteral == 'Current And Previous 2 CY') {
                    SOQLDateString = ' AND  ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = THIS_YEAR ) ';
                    setWeekDates(Date.newInstance(Date.today().year() -2, 1, 1), Date.newInstance(Date.today().year(), 12,31));
                } else if (selectedDateLiteral == 'Current And Next CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = NEXT_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year() + 1, 12,31));
                } else if (selectedDateLiteral == 'Current CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year(), 3, 31));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year(), 6, 30));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 7, 1), Date.newInstance(Date.today().year(), 9, 30));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year() , 10, 1), Date.newInstance(Date.today().year(), 12, 31));
                    }
                } else if (selectedDateLiteral == 'Current And Next CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_QUARTER ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year(), 6, 30));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year(), 9, 30));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 7, 1), Date.newInstance(Date.today().year(), 12, 31));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year() , 10, 1), Date.newInstance(Date.today().year() + 1, 3, 31));
                    }
                } else if (selectedDateLiteral == 'Current And Previous CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = LAST_QUARTER ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() , 10, 1), Date.newInstance(Date.today().year(), 3, 31));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year(), 6, 31));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year(), 9, 30));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year() , 7, 1), Date.newInstance(Date.today().year() , 12, 31));
                    }
                } else if (selectedDateLiteral == 'Next CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year(), 6, 30));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 7, 1), Date.newInstance(Date.today().year(), 9, 30));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 10, 1), Date.newInstance(Date.today().year(), 12, 31));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year() + 1 , 1, 1), Date.newInstance(Date.today().year() , 3, 31));
                    }
                } else if (selectedDateLiteral == 'Previous CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() -1, 10, 1), Date.newInstance(Date.today().year() - 1, 12, 31));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year(), 3, 31));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year(), 6, 30));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year()  , 7, 1), Date.newInstance(Date.today().year() , 9, 30));
                    }
                } else if (selectedDateLiteral == 'Current And Next 3 CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_N_QUARTERS:3 ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3) {
                        setWeekDates(Date.newInstance(Date.today().year() , 1, 1), Date.newInstance(Date.today().year() , 12, 31));
                    } else if (Date.today().month() >=4 && Date.today().month() <= 6) {
                        setWeekDates(Date.newInstance(Date.today().year() , 4, 1), Date.newInstance(Date.today().year()+ 1, 3, 31));
                    } else if (Date.today().month() >=7 && Date.today().month() <= 9) {
                        setWeekDates(Date.newInstance(Date.today().year() , 7, 1), Date.newInstance(Date.today().year() + 1, 6, 30));
                    } else if (Date.today().month() >=10 && Date.today().month() <= 12) {
                        setWeekDates(Date.newInstance(Date.today().year()  , 10, 1), Date.newInstance(Date.today().year() + 1 , 9, 30));
                    }
                } else if (selectedDateLiteral == 'Last Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_MONTH ';
                    setWeekDates(Date.today().addMonths(-1).toStartOfMonth(), Date.today().toStartOfMonth().addDays(-1));
                } else if (selectedDateLiteral == 'This Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_MONTH ';
                    setWeekDates(Date.today().toStartOfMonth(), Date.today().addMonths(1).toStartOfMonth().addDays(-1));
                } else if (selectedDateLiteral == 'Next Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_MONTH ';
                    setWeekDates(Date.today().addMonths(1).toStartOfMonth(), Date.today().addMonths(2).toStartOfMonth().addDays(-1));
                } else if (selectedDateLiteral == 'Current And Last Month') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = LAST_MONTH ) ';
                    setWeekDates(Date.today().addMonths(-1).toStartOfMonth(), Date.today().addMonths(1).toStartOfMonth().addDays(-1));
                } else if (selectedDateLiteral == 'Current And Next Month') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = NEXT_MONTH ) ';
                    setWeekDates(Date.today().toStartOfMonth(), Date.today().addMonths(2).toStartOfMonth().addDays(-1));
                } else if (selectedDateLiteral == 'Last Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    setWeekDates(Date.today().toStartOfWeek().addDays(-7), Date.today().toStartOfWeek().addDays(-1));
                } else if (selectedDateLiteral == 'This Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_WEEK ';
                    setWeekDates(Date.today().toStartOfWeek(), Date.today().toStartOfWeek().addDays(6));
                } else if (selectedDateLiteral == 'Next Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_WEEK ';
                    setWeekDates(Date.today().addDays(7).toStartOfWeek(), Date.today().addDays(7).toStartOfWeek().addDays(6));
                } else if (selectedDateLiteral == 'Yesterday') {
                    SOQLDateString = ' AND Week_MIN_Field__c = YESTERDAY ';
                    setWeekDates(Date.today().addDays(-1), Date.today().addDays(-1));
                } else if (selectedDateLiteral == 'Today') {
                    SOQLDateString = ' AND Week_MIN_Field__c = TODAY ';
                    setWeekDates(Date.today(), Date.today());
                } else if (selectedDateLiteral == 'Tomorrow') {
                    SOQLDateString = ' AND Week_MIN_Field__c = TOMORROW ';
                    setWeekDates(Date.today().addDays(1), Date.today().addDays(1));
                } else if (selectedDateLiteral == 'Last 7 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:7 ';
                    setWeekDates(Date.today().addDays(-7), Date.today());
                } else if (selectedDateLiteral == 'Last 30 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:30 ';
                    setWeekDates(Date.today().addDays(-30), Date.today());
                } else if (selectedDateLiteral == 'Last 60 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:60 ';
                    setWeekDates(Date.today().addDays(-60), Date.today());
                } else if (selectedDateLiteral == 'Last 90 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:90 ';
                    setWeekDates(Date.today().addDays(-90), Date.today());
                } else if (selectedDateLiteral == 'Last 120 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:120 ';
                    setWeekDates(Date.today().addDays(-120), Date.today());
                } else if (selectedDateLiteral == 'Next 7 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:7 ';
                    setWeekDates(Date.today(), Date.today().addDays(7));
                } else if (selectedDateLiteral == 'Next 30 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:30 ';
                    setWeekDates(Date.today(), Date.today().addDays(30));
                } else if (selectedDateLiteral == 'Next 60 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:60 ';
                    setWeekDates(Date.today(), Date.today().addDays(60));
                } else if (selectedDateLiteral == 'Next 90 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:90 ';
                    setWeekDates(Date.today(), Date.today().addDays(90));
                } else if (selectedDateLiteral == 'Next 120 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:120 ';
                    setWeekDates(Date.today(), Date.today().addDays(120));
                }
            }

            if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
            } else {
                SOQLDateString = '';
            }

			return SOQLDateString;
    }


}