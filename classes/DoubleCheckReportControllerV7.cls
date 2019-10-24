public class DoubleCheckReportControllerV7 {

    public List<List<SObject>> DealSearchList;
    public List<WeekModel> quarterweek {get; set;}
    public List<HeadingModel> headingModels {get; set;}
    public List<Date> quarterdates {get; set;}
    public List<Deal__c> DealResultList {get; set;}
    public List<RateModel> rateList {get; set;}
    public List<RateModel> LTClist {get; set;}
    public List<RateModel> ExtensionList {get; set;}
    public List<RateModel> UnitsAvailableList {get; set;}
    public List<RateModel> testTabList {get; set;}
    public List<RateModel> ghostTabList {get; set;}
    public List<RateModel> capTabList {get; set;}
    public List<RateModel> dayPartTabList {get; set;}
    public List<RateModel> hiatusList {get; set;}
    public List<RateModel> maxTabList {get; set;}
    public List<String> SearchList;
    public String Searchfield {get; set;}
    public String DealId {get; set;}
    public String cellrate {get; set;}
    public String cellUnits {get; set;}
    public String CellId {get; set;}
    public String DealName {get; set;}
    public Decimal RateforCell {get; set;}
    public String SaveDescision {get; set;}
    public Boolean selectAll {get; set;}
    public Date anchordate;
    public Date startdate;
    public Date enddate;
    public Boolean schedulemessage {get; set;}
    public Boolean showtable {get; set;}
    public Deal__c SelectedDeal {get; set;}
    public Date LowestDate {get; set;}
    public Date HighestDate {get; set;}
    public Date QuarterEndDate {get; set;}
    public Schedules__c DummySchedule1 {get; set;}
    public Schedules__c DummySchedule2 {get; set;}
    public Schedules__c DummySchedule3 {get; set;}
    public Schedules__c DummySchedule4 {get; set;}
    public Schedules__c DummySchedule5 {get; set;}
    public String SelectedExtensionDate {get; set;}
    public String SelectedOrderLineNumber {get; set;}
    public String selectedTest {get; set;}
    public String selectedGhost {get; set;}
    public Boolean BarterCheckbox {get; set;}
    public String SelectedCableSynd {get; set;}
    public String programTeam {get; set;}
    public List<SelectOption> CableSyndSOList {get; set;}
    public Map<Date, Schedules__c> weekMap { get; set;}
    public Map<Date, Boolean> DuplicateWeekMap { get; set;}

    public Schedules__c WeekStartDate {get; set;}
    public Schedules__c WeekEndDate {get; set;}
    public List<SelectOption> DateLiteralSOList {get; set;}
    public String SelectedDateLiteral {get; set;}
    public String SOQLDateString {get; set;}

    public Map<String, FiscalYearSettings> FiscalMap = new Map<String, FiscalYearSettings>();
    public FiscalYearSettings CurrentFY;
    public Period CurrentFP;
    public Period CurrentFW;
    public Period CurrentFM;
    public Map<String, Map<Integer, Period>> QuarterPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> WeekPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> MonthPeriodMap = new Map<String, Map<Integer, Period>>();

    public String PreselectedDealId {get; set;}
    public List<String> WeekDollarsList {get; set;}
    public List<HeadingModel> HeadingList {get; set;}
    
    public Schedules__c testSch {get; set;}
    
    public Boolean nextPage {get; set;}
    public Boolean prevPage {get; set;}
    public Integer currentPage {get; set;}
    public Integer pageCount {get; set;}
    
    public Boolean nextPageCap {get; set;}
    public Boolean prevPageCap {get; set;}
    public Integer currentPageCap {get; set;}
    public Integer pageCountCap {get; set;}
    
    public Boolean nextPageMax {get; set;}
    public Boolean prevPageMax {get; set;}
    public Integer currentPageMax {get; set;}
    public Integer pageCountMax {get; set;}

    public Boolean filterReconciledWeeks {get; set;}

    public String hiatusTimeBefore {get; set;}
    public String hiatusTimeAfter {get; set;}
    public List<SelectOption> hiatusTimeOptions {get; set;}
    public Schedules__c hiatusTempScheduleStart {get; set;}
    public Schedules__c hiatusTempScheduleEnd {get; set;}

    //public Date selectedStartDate { get; set; }
    //public Date selectedEndDate { get; set; }
	
    public void testUpdate() {
        update this.testSch;
    }
    
    public DoubleCheckReportControllerV7 () {
        this.testSch = [SELECT Networks__c, MGM_HD_Daypart__c, Start_Time__c, End_Time__c, Days_Allowed__c FROM Schedules__c WHERE Id = 'a08C000000VvVp4IAF'];
        
        SaveDescision   ='';
        selectAll = false;
        CableSyndSOList = new List<SelectOption>();
        CableSyndSOList.add(new SelectOption('','Please Select'));
        CableSyndSOList.add(new SelectOption('Cable','Cable'));
        CableSyndSOList.add(new SelectOption('Syndication','Syndication'));
        CableSyndSOList.add(new SelectOption('PP','PP'));
        SelectedCableSynd = '';

        WeekStartDate = new Schedules__c();
        WeekEndDate = new Schedules__c();
        DateLiteralSOList = new List<SelectOption>();
        DateLiteralSOList.add(new SelectOption('','Please Select'));
        DateLiteralSOList.add(new SelectOption('Custom','Custom'));
        DateLiteralSOList.add(new SelectOption('Fiscal Year', 'Fiscal Year', true));
        DateLiteralSOList.add(new SelectOption('Current FY', 'Current FY'));
        DateLiteralSOList.add(new SelectOption('Previous FY', 'Previous FY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 FY', 'Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('2 FY Ago', '2 FY Ago'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FY', 'Current And Previous FY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 FY', 'Current And Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('Fiscal Quarter', 'Fiscal Quarter', true));
        DateLiteralSOList.add(new SelectOption('Current FQ','Current FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next FQ','Current And Next FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FQ','Current And Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Next FQ','Next FQ'));
        DateLiteralSOList.add(new SelectOption('Previous FQ', 'Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 FQ', 'Current And Next 3 FQ'));
        DateLiteralSOList.add(new SelectOption('Fiscal Period', 'Fiscal Period', true));
        DateLiteralSOList.add(new SelectOption('Last FP', 'Last FP'));
        DateLiteralSOList.add(new SelectOption('This FP', 'This FP'));
        DateLiteralSOList.add(new SelectOption('Next FP', 'Next FP'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FP', 'Current And Previous FP'));
        DateLiteralSOList.add(new SelectOption('Current And Next FP', 'Current And Next FP'));
        DateLiteralSOList.add(new SelectOption('Fiscal Week', 'Fiscal Week', true));
        DateLiteralSOList.add(new SelectOption('Last FW', 'Last FW'));
        DateLiteralSOList.add(new SelectOption('This FW', 'This FW'));
        DateLiteralSOList.add(new SelectOption('Next FW', 'Next FW'));
        DateLiteralSOList.add(new SelectOption('Calendar Year', 'Calendar Year', true));
        DateLiteralSOList.add(new SelectOption('Current CY', 'Current CY'));
        DateLiteralSOList.add(new SelectOption('Previous CY', 'Previous CY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 CY', 'Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('2 CY Ago', '2 CY Ago'));
        DateLiteralSOList.add(new SelectOption('Next CY', 'Next CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CY', 'Current And Previous CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 CY', 'Current And Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('Current And Next CY', 'Current And Next CY'));
        DateLiteralSOList.add(new SelectOption('Current Quarter', 'Current Quarter', true));
        DateLiteralSOList.add(new SelectOption('Current CQ', 'Current CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next CQ', 'Current And Next CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CQ', 'Current And Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Next CQ', 'Next CQ'));
        DateLiteralSOList.add(new SelectOption('Previous CQ', 'Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 CQ', 'Current And Next 3 CQ'));
        DateLiteralSOList.add(new SelectOption('Calendar Month', 'Calendar Month', true));
        DateLiteralSOList.add(new SelectOption('Last Month','Last Month'));
        DateLiteralSOList.add(new SelectOption('This Month','This Month'));
        DateLiteralSOList.add(new SelectOption('Next Month','Next Month'));
        DateLiteralSOList.add(new SelectOption('Current And Last Month', 'Current And Last Month'));
        DateLiteralSOList.add(new SelectOption('Current And Next Month', 'Current And Next Month'));
        DateLiteralSOList.add(new SelectOption('Calendar Week', 'Calendar Week', true));
        DateLiteralSOList.add(new SelectOption('Last Week','Last Week'));
        DateLiteralSOList.add(new SelectOption('This Week','This Week'));
        DateLiteralSOList.add(new SelectOption('Next Week','Next Week'));
        DateLiteralSOList.add(new SelectOption('Day', 'Day', true));
        DateLiteralSOList.add(new SelectOption('Yesterday','Yesterday'));
        DateLiteralSOList.add(new SelectOption('Today','Today'));
        DateLiteralSOList.add(new SelectOption('Tomorrow','Tomorrow'));
        DateLiteralSOList.add(new SelectOption('Last 7 Days','Last 7 Days'));
        DateLiteralSOList.add(new SelectOption('Last 30 Days','Last 30 Days'));
        DateLiteralSOList.add(new SelectOption('Last 60 Days','Last 60 Days'));
        DateLiteralSOList.add(new SelectOption('Last 90 Days','Last 90 Days'));
        DateLiteralSOList.add(new SelectOption('Last 120 Days','Last 120 Days'));
        DateLiteralSOList.add(new SelectOption('Next 7 Days','Next 7 Days'));
        DateLiteralSOList.add(new SelectOption('Next 30 Days','Next 30 Days'));
        DateLiteralSOList.add(new SelectOption('Next 60 Days','Next 60 Days'));
        DateLiteralSOList.add(new SelectOption('Next 90 Days','Next 90 Days'));
        DateLiteralSOList.add(new SelectOption('Next 120 Days','Next 120 Days'));

        for (FiscalYearSettings FYS : [select Id, Name, StartDate, EndDate from FiscalYearSettings]) {
            FiscalMap.put(FYS.Name, FYS);
            System.debug('CurrentFY Compare - ' + FYS.StartDate + ' - ' + FYS.EndDate + ' - ' + Date.Today() + ' - ' + (FYS.StartDate <= Date.Today() && FYS.EndDate >= Date.Today()));
            if (FYS.StartDate <= Date.Today() && FYS.EndDate >= Date.Today()) {
                CurrentFY = FYS;
                System.debug('CurrentFY - ' + CurrentFY.StartDate + ' - ' + CurrentFY.EndDate);
            }
        }

        for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Quarter']) {
            if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today()) {
                CurrentFP = PR;
                System.debug('CurrentFP - ' + CurrentFP.StartDate + ' - ' + CurrentFP.EndDate);
            }

            if (QuarterPeriodMap.containsKey(PR.FiscalYearSEttings.Name)) {
                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(PR.FiscalYearSettings.Name);
                TempQuarterPeriodMap.put(PR.Number, PR);
                QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            } else {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                TempQuarterPeriodMap.put(PR.Number, PR);
                QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }

        for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Week']) {
            if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today()) {
                CurrentFW = PR;
                System.debug('CurrentFW - ' + CurrentFW.StartDate + ' - ' + CurrentFW.EndDate);
            }

            if (WeekPeriodMap.containsKey(PR.FiscalYearSEttings.Name)) {
                Map<Integer, Period> TempQuarterPeriodMap = WeekPeriodMap.get(PR.FiscalYearSettings.Name);
                TempQuarterPeriodMap.put(PR.Number, PR);
                WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            } else {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                TempQuarterPeriodMap.put(PR.Number, PR);
                WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }

        for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month']) {
            if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today()) {
                CurrentFM = PR;
                System.debug('CurrentFM - ' + CurrentFM.StartDate + ' - ' + CurrentFM.EndDate);
            }

            if (MonthPeriodMap.containsKey(PR.FiscalYearSEttings.Name)) {
                Map<Integer, Period> TempQuarterPeriodMap = MonthPeriodMap.get(PR.FiscalYearSettings.Name);

                if (PR.Number == null) {
                    TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                } else {
                    TempQuarterPeriodMap.put(PR.Number, PR);
                }

                MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            } else {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();

                if (PR.Number == null) {
                    TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                } else
                {
                    TempQuarterPeriodMap.put(PR.Number, PR);
                }

                MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }

        // Default this checkbox to true
        filterReconciledWeeks = true;

        // Setup Hiatus Data
        hiatusTimeOptions = createHiatusTimeSelectList();
        hiatusTempScheduleStart = new Schedules__c();
        hiatusTempScheduleEnd = new Schedules__c();

        if (ApexPages.CurrentPage().getParameters().containsKey('DealId')) {
            PreselectedDealId = ApexPages.CurrentPage().getParameters().get('DealId');
            Deal__c PreselectedDeal = [select Id, Name from Deal__c where Id =: PreselectedDealId];
            SearchField = PreselectedDeal.Name;
            BarterCheckbox = false;
            SelectedCableSynd = '';
            SelectedDateLiteral = '';
            DoSearch();
            DealId = PreselectedDealId;
            SearchforSchedules();
        }
    }

    public String ReturnStringDate(Date pDate) {
        String pString = String.valueOf(pDate.Year()) + '-';

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

    public Integer ReturnNumber(String pMonth) {
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

    public void ReturnSOQLDateString() {
        try {
            if (SelectedDateLiteral == null || SelectedDateLiteral == '') {
                SOQLDateString = '';
            } else {
                if (SelectedDateLiteral == 'Custom') {
                    if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                        SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
                    } else {
                        SOQLDateString = '';
                    }
                } else if (SelectedDateLiteral == 'Previous FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_YEAR ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1))) {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            WeekStartDate.Week__c = FYS.StartDate;
                            WeekEndDate.Week__c = FYS.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == 'Previous 2 FY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = LAST_FISCAL_YEAR ) ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2))) {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.Week__c = FYS2.StartDate;
                            WeekEndDate.Week__c = FYS1.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == '2 FY Ago') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2))) {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.Week__c = FYS.StartDate;
                            WeekEndDate.Week__c = FYS.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == 'Current FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Week__c = FYS.StartDate;
                            WeekEndDate.Week__c = FYS.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Previous FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Week__c = FYS1.StartDate;
                            WeekEndDate.Week__c = FYS2.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Previous 2 FY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null) {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name)))) {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Week__c = FYS1.StartDate;
                            WeekEndDate.Week__c = FYS2.EndDate;
                        }
                    }
                } else if (SelectedDateLiteral == 'Current FQ') {
                    if (CurrentFP != null) {
                        WeekStartDate.Week__c = CurrentFP.StartDate;
                        WeekEndDate.Week__c = CurrentFP.EndDate;
                    }
                } else if (SelectedDateLiteral == 'Current And Next FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 4) {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Week__c = CurrentFP.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Week__c = CurrentFP.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Previous FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = CurrentFP.EndDate;
                                }
                            }
                        } else {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = CurrentFP.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Next FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 4) {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Previous FQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_QUARTER ';
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Next 3 FQ') {
                    if (CurrentFP != null) {
                        if (CurrentFP.Number == 1) {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))));
                                if (TempQuarterPeriodMap.containsKey(4)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Week__c = CurrentFP.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)))) {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1)) {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number - 1);
                                    WeekStartDate.Week__c = CurrentFP.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Last FP') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_PERIOD ';
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 1) {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12)) {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'This FP') {
                    if (CurrentFM != null) {
                        WeekStartDate.Week__c = CurrentFM.StartDate;
                        WeekEndDate.Week__c = CurrentFM.EndDate;
                    }
                } else if (SelectedDateLiteral == 'Next FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 12) {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Previous FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 1) {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12)) {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = CurrentFM.EndDate;
                                }
                            }
                        } else {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = CurrentFM.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Current And Next FP') {
                    if (CurrentFM != null) {
                        Integer NumberMonth;
                        if (CurrentFM.number != null) {
                            NumberMonth = CurrentFM.Number;
                        } else {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }

                        if (NumberMonth == 12) {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Week__c = CurrentFM.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Week__c = CurrentFM.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Last FW') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    if (CurrentFW != null) {
                        if (CurrentFW.Number == 1) {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1))) {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(53)) {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                } else if (TempPeriodMap.containsKey(52)) {
                                    Period TempPeriod = TempPeriodMap.get(52);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(CurrentFW.Number - 1)) {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number - 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'This FW') {
                    if (CurrentFW != null) {
                        WeekStartDate.Week__c = CurrentFW.StartDate;
                        WeekEndDate.Week__c = CurrentFW.EndDate;
                    }
                } else if (SelectedDateLiteral == 'Next FW') {
                    if (CurrentFW != null) {
                        if (CurrentFW.Number == 53) {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1))) {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1)) {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        } else if (CurrentFW.Number == 52) {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name)) {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(53)) {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                } else {
                                    if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1))) {
                                        Map<Integer, Period> TempPeriodMap1 = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                        if (TempPeriodMap1.containsKey(1)) {
                                            Period TempPeriod = TempPeriodMap1.get(1);
                                            WeekStartDate.Week__c = TempPeriod.StartDate;
                                            WeekEndDate.Week__c = TempPeriod.EndDate;
                                        }
                                    }
                                }
                            }
                        } else {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)))) {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)));
                                if (TempPeriodMap.containsKey(CurrentFW.Number + 1)) {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number + 1);
                                    WeekStartDate.Week__c = TempPeriod.StartDate;
                                    WeekEndDate.Week__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                } else if (SelectedDateLiteral == 'Current CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_YEAR ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year(), 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12,31);
                } else if (SelectedDateLiteral == 'Previous CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_YEAR ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() - 1, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year() - 1, 12,31);
                } else if (SelectedDateLiteral == 'Previous 2 CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 ) ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() - 2, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year() -1, 12,31);
                } else if (SelectedDateLiteral == '2 CY Ago') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() - 2, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year() -2, 12,31);
                } else if (SelectedDateLiteral == 'Next CY') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_YEAR ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() +1, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year() +1, 12,31);
                } else if (SelectedDateLiteral == 'Current And Previous CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() -1, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12,31);
                } else if (SelectedDateLiteral == 'Current And Previous 2 CY') {
                    SOQLDateString = ' AND  ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() -2, 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12,31);
                } else if (SelectedDateLiteral == 'Current And Next CY') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = NEXT_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                    WeekEndDate.Week__c = Date.newInstance(Date.Today().year() + 1, 12,31);
                } else if (SelectedDateLiteral == 'Current CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 3, 31);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 6, 30);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 9, 30);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12, 31);
                    }
                } else if (SelectedDateLiteral == 'Current And Next CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_QUARTER ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 6, 30);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 9, 30);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12, 31);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() + 1, 3, 31);
                    }
                } else if (SelectedDateLiteral == 'Current And Previous CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = LAST_QUARTER ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 3, 31);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 6, 31);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 9, 30);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() , 12, 31);
                    }
                } else if (SelectedDateLiteral == 'Next CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 6, 30);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 9, 30);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 12, 31);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() + 1 , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() , 3, 31);
                    }
                } else if (SelectedDateLiteral == 'Previous CQ') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() -1, 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() - 1, 12, 31);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 3, 31);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year(), 6, 30);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year()  , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() , 9, 30);
                    }
                } else if (SelectedDateLiteral == 'Current And Next 3 CQ') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_N_QUARTERS:3 ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 1, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() , 12, 31);
                    } else if (Date.Today().month() >=4 && Date.Today().month() <= 6) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 4, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year()+ 1, 3, 31);
                    } else if (Date.Today().month() >=7 && Date.Today().month() <= 9) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year() , 7, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() + 1, 6, 30);
                    } else if (Date.Today().month() >=10 && Date.Today().month() <= 12) {
                        WeekStartDate.Week__c = Date.newInstance(Date.Today().year()  , 10, 1);
                        WeekEndDate.Week__c = Date.newInstance(Date.Today().year() + 1 , 9, 30);
                    }
                } else if (SelectedDateLiteral == 'Last Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_MONTH ';
                    WeekStartDate.Week__c = Date.Today().addmonths(-1).ToStartOfMOnth();
                    WeekEndDate.Week__c = Date.Today().ToStartOfMonth().addDays(-1);
                } else if (SelectedDateLiteral == 'This Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_MONTH ';
                    WeekStartDate.Week__c = Date.Today().ToStartOfMOnth();
                    WeekEndDate.Week__c = Date.Today().addmonths(1).ToStartOfMonth().addDays(-1);
                } else if (SelectedDateLiteral == 'Next Month') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_MONTH ';
                    WeekStartDate.Week__c = Date.Today().addmonths(1).ToStartOfMOnth();
                    WeekEndDate.Week__c = Date.Today().addmonths(2).ToStartOfMonth().addDays(-1);
                } else if (SelectedDateLiteral == 'Current And Last Month') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = LAST_MONTH ) ';
                    WeekStartDate.Week__c = Date.Today().addmonths(-1).ToStartOfMOnth();
                    WeekEndDate.Week__c = Date.Today().addmonths(1).ToStartOfMonth().addDays(-1);
                } else if (SelectedDateLiteral == 'Current And Next Month') {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = NEXT_MONTH ) ';
                    WeekStartDate.Week__c = Date.Today().ToStartOfMOnth();
                    WeekEndDate.Week__c = Date.Today().addmonths(2).ToStartOfMonth().addDays(-1);
                } else if (SelectedDateLiteral == 'Last Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    WeekStartDate.Week__c = Date.Today().toStartOfWeek().addDays(-7);
                    WeekEndDate.Week__c = Date.Today().toStartOfWeek().addDays(-1);
                } else if (SelectedDateLiteral == 'This Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_WEEK ';
                    WeekStartDate.Week__c = Date.Today().toStartOfWeek();
                    WeekEndDate.Week__c = Date.Today().toStartOfWeek().addDays(6);
                } else if (SelectedDateLiteral == 'Next Week') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_WEEK ';
                    WeekStartDate.Week__c = Date.Today().addDays(7).ToStartOfWeek();
                    WeekEndDate.Week__c = Date.Today().addDays(7).ToStartOfWeek().addDays(6);
                } else if (SelectedDateLiteral == 'Yesterday') {
                    SOQLDateString = ' AND Week_MIN_Field__c = YESTERDAY ';
                    WeekStartDate.Week__c = Date.Today().addDays(-1);
                    WeekEndDate.Week__c = Date.Today().addDays(-1);
                } else if (SelectedDateLiteral == 'Today') {
                    SOQLDateString = ' AND Week_MIN_Field__c = TODAY ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Tomorrow') {
                    SOQLDateString = ' AND Week_MIN_Field__c = TOMORROW ';
                    WeekStartDate.Week__c = Date.Today().addDays(1);
                    WeekEndDate.Week__c = Date.Today().addDays(1);
                } else if (SelectedDateLiteral == 'Last 7 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:7 ';
                    WeekStartDate.Week__c = Date.Today().addDays(-7);
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Last 30 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:30 ';
                    WeekStartDate.Week__c = Date.Today().addDays(-30);
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Last 60 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:60 ';
                    WeekStartDate.Week__c = Date.Today().addDays(-60);
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Last 90 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:90 ';
                    WeekStartDate.Week__c = Date.Today().addDays(-90);
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Last 120 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:120 ';
                    WeekStartDate.Week__c = Date.Today().addDays(-120);
                    WeekEndDate.Week__c = Date.Today();
                } else if (SelectedDateLiteral == 'Next 7 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:7 ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today().addDays(7);
                } else if (SelectedDateLiteral == 'Next 30 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:30 ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today().addDays(30);
                } else if (SelectedDateLiteral == 'Next 60 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:60 ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today().addDays(60);
                } else if (SelectedDateLiteral == 'Next 90 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:90 ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today().addDays(90);
                } else if (SelectedDateLiteral == 'Next 120 Days') {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:120 ';
                    WeekStartDate.Week__c = Date.Today();
                    WeekEndDate.Week__c = Date.Today().addDays(120);
                }
            }

            if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
            } else {
                SOQLDateString = '';
            }

            System.debug('Start And End Dates - ' + WeekStartDate.Week__c + ' - ' + WeekEndDate.Week__c);
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void DoSearch() {
        try {
            DealResultList = new List<Deal__c>();
            SearchList = new List<string>();
            Map<Id,Deal__c> MapofFinalDeals = new Map<Id,Deal__c>();
            Map<Integer,set<id>> Accurancy = new Map<Integer, set<id>>();
            ReturnSOQLDateString();
            if(Searchfield != null && Searchfield  !='') {
                searchField = SearchField.replace(' , ',',').replace(' ,',',').replace(', ',',');
                String tempSearch = '%'+Searchfield +'%';
                SearchList = Searchfield.split(',');
                Accurancy.put(1, new Set<Id>{});
                if (SearchList.size() > 1) {
                    for(String stringListLoop : SearchList) {
                        while(stringListLoop.startsWith(' ') || stringListLoop.endsWith(' ')) {
                            if (StringListLoop.startsWith(' ')) {
                                StringListLoop = StringListLoop.substringAfter(' ');
                            }
                            if (StringListLoop.endsWith(' ')) {
                                StringListLoop = StringListLoop.substringBeforeLast(' ');
                            }
                        }
                        String tempstringListLoop = '%'+stringListLoop+'%';
                        Set<Deal__c> tempDealList = new Set<Deal__c>();

                        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                                                + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,'
                                                + 'Program__r.Name, Advertiser__c '
                                                + ' From Deal__c '
                                                + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                                                + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null '
                                                + SOQLDateString;
                        if (BarterCheckbox) {
                            DealQuery += ' AND Program__r.Barter__c = True ';
                        }
                        if (SelectedCableSynd != '' && SelectedCableSynd != null) {
                            DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                        }
                        if (programTeam != '' && programTeam != null) {
                            DealQuery += ' AND Program_Team__c = \'' + programTeam + '\'';
                        }
                        DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 1000';

                        List<Deal__c> DealList = Database.query(DealQuery);
                        System.debug(dealQuery);
                        for(Deal__c dlist : DealList ) {
                            System.debug('tempStringListLoop - ' + tempStringListLoop + ' - ' + dlist.Name + ' - ' + dlist.Program__r.Name + ' - ' + dlist.Contact__r.Name + ' - ' + dlist.Client_Account__r.Name + ' - ' + dlist.Brands__r.Name);
                            Boolean NotInList = false;
                            MapofFinalDeals.put(dlist.Id, dlist);
                            for(Integer i = Accurancy.size(); i>0; i--) {
                                if(Accurancy.get(i).contains(dlist.Id)) {
                                    NotInList = true;
                                    if(Accurancy.containskey(i+1)) {
                                        Set<Id> dealset1 = accurancy.get(i+1);
                                        dealset1.add(dlist.Id);
                                        Accurancy.put(i+1, dealset1);
                                    } else {
                                        Set<Id> dealset1 = new Set<Id>();
                                        dealset1.add(dlist.Id);
                                        Accurancy.put(i+1, dealset1);
                                    }
                                    Accurancy.get(i).remove(dlist.Id);
                                }
                            }

                            if(NotinList == false) {
                                Set<Id> dealset1 = accurancy.get(1);
                                dealset1.add(dlist.Id);
                                Accurancy.put(1, dealset1);
                            }
                        }
                    }
                    Integer count=0;
                    if (Accurancy.containsKey(SearchList.size())) {
                        for(Id MapofDeals : Accurancy.get(SearchList.size())) {
                            if (Count < 200) {
                                DealResultList.add(MapofFinalDeals.get(mapofdeals));
                                count++;
                            }
                        }
                    }
                } else {
                    String tempstringListLoop = '%'+SearchList[0] +'%';

                    String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                                            + ' Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,'
                                            + ' Program__r.Name, Advertiser__c '
                                            + ' From Deal__c '
                                            + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                                            + ' OR Name Like \'' + tempstringListLoop + '\' )  AND Week_MIN_Field__c != null '
                                            + SOQLDateString;

                    if (BarterCheckbox) {
                        DealQuery += ' AND Program__r.Barter__c = True ';
                    }
                    if (SelectedCableSynd != '' && SelectedCableSynd != null) {
                        DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                    }
                    if (programTeam != '' && programTeam != null) {
                        DealQuery += ' AND Program_Team__c = \'' + programTeam + '\'';
                    }
                    DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 200';
                    System.debug('DealQuery - ' + DealQuery);
                    List<Deal__c> DealList = Database.query(DealQuery);
                    for(Deal__c dlist : DealList) {
                        DealResultList.add(dlist);
                    }
                }
            } else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Search field can not be null'));
            }

            if (DealResultList.size() == 0 && Searchfield != null && Searchfield  !='' ) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'The Search did not return any results'));
            }
            DealId ='';
            DealName='';
            cellrate ='';
            CellId ='';
            showtable = false;
            schedulemessage = false;
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    //Returns a list of createable field names for the given sobject.
    public Set<String> getCreatableFields(String objectName) {
        //Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        Set<String> selectFields = new Set<String>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()) { // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCreateable()) { // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        return selectFields;
    }

    public RateModel BuildRateModel(List<Schedules__c> tempwraplist, String mapkeylist) {
        RateModel rm = new RateModel() ;

        rm.OrderLineNumber = mapKeyList;

        Schedules__c obj = new Schedules__c();
        Set<String> fieldList = this.getCreatableFields('Schedules__c');
        //Set<String> fieldList = new Set<String>{'Week__c'};
        for (String field : fieldList) {
            obj.put(field, tempwrapList[0].get(field));
        }
        obj.Week__c = null;
        rm.scheduleObj = obj;

        if(tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null) {
            rm.rate = string.valueof(tempwraplist[0].Rate__c);
        } else {
            rm.rate = '0';
        }

        rm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
        rm.SETime = tempwraplist[0].Start_End_Time__c;
        rm.UnitLength = tempwraplist[0].UnitLength__c;
        Date RMLowestDate = Date.newInstance(3000,1,1);
        Date RMHighestDate = Date.newInstance(1000,1,1);
        for(Schedules__c sch :tempwraplist) {
            if (RMLowestDate > sch.Week__c) {
                RMLowestDate = sch.Week__c;
            }
            if (RMHighestDate < sch.Week__c) {
                RMHighestdate = sch.Week__c;
            }
            if(sch.week__c >= Date.today().toStartofWeek().addDays(1) ) {
                if (sch.Test__c == true)  {
                    rm.Test = true;
                }
                if (sch.Ghost_Order__c == true)  {
                    rm.Ghost = true;
                }
                if (sch.Cap__c != null)  {
                    rm.ScheduleObj.Cap__c = sch.Cap__c;
                }
                if (sch.Max_Per_Day__c != null) {
                    rm.ScheduleObj.Max_Per_Day__c = sch.Max_Per_Day__c;
                }
            }
        }
        rm.LowestDate = RMLowestDate;
        rm.HighestDate = RMHighestDate;
        rm.HighestDate = RMHighestDate;

        for(Date sow: quarterdates) {
            if (sow != null) {
                if (sow >= LowestDate) {
                    if(weekmap.containskey(sow)) {
                        if (DuplicateWeekMap.containsKey(sow)) {
                            rm.weeks.add(new weekModel(sow,weekmap.get(sow), true));
                        } else {
                            rm.weeks.add(new weekModel(sow,weekmap.get(sow), false));
                        }
                    } else {
                        rm.weeks.add(new weekModel(sow,tempwraplist[0].OrderNumber__c));
                    }
                }
            }
        }
        return rm ;
    }

    public void SearchforSchedules() {
        try {
            List<String> testlist = new List<String>();
            Set<String> tempRateSet = new Set<String>();
            Set<String> rateSet = new Set<String>();
            Set<String> tempCapSet = new Set<String>();
            Set<String> capSet = new Set<String>();
            Set<String> tempMaxSet = new Set<String>();
            Set<String> maxSet = new Set<String>();
            rateList = new List<RateModel>();
            UnitsAvailableList = new List<RateModel>();
            LTClist = new List<RateModel>();
            testTabList = new List<RateModel>();
            ghostTabList = new List<RateModel>();
            capTabList = new List<RateModel>();
            dayPartTabList = new List<RateModel>();
            ExtensionList = new List<RateModel>();
            hiatusList = new List<RateModel>();
            maxTabList = new List<RateModel>();
            DummySchedule1 = new Schedules__c();
            DummySchedule2 = new Schedules__c();
            DummySchedule3 = new Schedules__c();
            DummySchedule4 = new Schedules__c();
            DummySchedule5 = new Schedules__c();
            Map<String, List<Schedules__c>> schgroup = new Map<String, List<Schedules__c>>();
            Map<String, List<Schedules__c>> schCapGroup = new Map<String, List<Schedules__c>>();
            Map<String, List<Schedules__c>> schMaxGroup = new Map<String, List<Schedules__c>>();
            LowestDate = Date.newInstance(3000,1,1);
            HighestDate = Date.newInstance(1000,1,1);

            String fullQuery = 'SELECT ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' FROM Schedules__c WHERE Deal_Parent__c = \'' + DealId + '\'';
            //String fullQuery = 'SELECT OrderNumber__c, Cap__c, Total_Dollars__c, DaysAllowedFormula__c, Start_End_Time__c, UnitLength__c, Days_Allowed__c, Name, RecordTypeId, Week__c, Day__c, Units_Available__c, NFL_Daypart__c, Rate__c, ISCI_CODE__c, MGM_HD_Daypart__c, Status__c, Comments__c, X800_Number__c, Deal_Parent__c, SS9_Titles__c, Units_Preempted__c, TEST__c, PI_Payout__c, Long_Form__c, LF_Brand__c, Total_Schedules__c, GM__c, Networks__c, Filler__c, SS10_Titles__c, End_Time__c, Start_Time__c, Ghost_Order__c, Product__c, Reviewed_for_Invoicing__c, Send_as_NEW__c, Recommended__c, Previous_Incumbent__c, LF_Rate_Needed__c, LF_Results__c, LF_Next_Month_Status__c, PP_Revision_Comment__c, PP_Revision__c, Priority__c, Days_Allowed__c, Max_Per_Day__c, Error_Cost__c, Rating__c, Error_Logged_To__c, Days_of_Air__c, Pod__c, OrderNumber__c, OrderLineNumber__c, Intacct_SI_Number__c, Error_Reason__c, Bundle_Ghost__c, Discrepancy_Comment__c, LF_traffic__c, LFOrderLineNumber__c, Conga_Workflow_Trigger__c, Intacct_CM_Number__c, Unconfirmed_Historical__c, Kids_Block__c, HH_000__c, CIA_Status__c, ISCI2__c, ISCI3__c, Rotation__c, Traffic__c, Duplicate_Check__c, Previous_Units_Available__c, Error_Logged_Date__c, Cancel_Date__c, Performance__c, In_game__c, Bundle_Order_Number__c, Intacct_SI_Number_Payment_Status__c, Intacct_SI_Number_Date_Fully_Paid__c, Rating_Estimate__c, Cap__c, Bonus_Bundle_Units__c, Discrepancy_Bundle__c, XML_Sent__c, Archived_Prelog_Count__c, Archived_Prelog_Booked_Dollars__c, Litton_Program_Shows__c FROM Schedules__c WHERE Deal_Parent__c = \'' + DealId + '\'';
            if(filterReconciledWeeks == true) {
                fullQuery += ' AND Reconciled__c = \'N\'';
            }
            fullQuery += ' ORDER BY MilitaryTime__c, Rate__c';

            for (Schedules__c schlist : Database.query(fullQuery)) {
                if(schlist.OrderNumber__c != null) {
                    if(!tempRateSet.contains(schlist.OrderNumber__c)) {
                        tempRateSet.add(schlist.OrderNumber__c);
                    }
                    if(schgroup.containskey(schlist.OrderNumber__c)) {
                        List<Schedules__c> temp = schgroup.get(schlist.OrderNumber__c);
                        temp.add(schlist);
                        schgroup.put(schlist.OrderNumber__c,temp);
                    } else {
                        List<Schedules__c> temp = new List<Schedules__c>();
                        temp.add(schlist);
                        schgroup.put(schlist.OrderNumber__c,temp);
                    }

                    if(schlist.Cap__c != null) {
                        if(!tempCapSet.contains(schlist.OrderNumber__c + schlist.Cap__c)) {
                            tempCapSet.add(schlist.OrderNumber__c + schlist.Cap__c);
                        }
                        if(schCapGroup.containsKey(schlist.OrderNumber__c + schlist.Cap__c)) {
                            List<Schedules__c> temp = schCapGroup.get(schlist.OrderNumber__c + schlist.Cap__c);
                            temp.add(schlist);
                            schCapGroup.put(schlist.OrderNumber__c + schlist.Cap__c, temp);
                        } else {
                            List<Schedules__c> temp = new List<Schedules__c>();
                            temp.add(schlist);
                            schCapGroup.put(schlist.OrderNumber__c + schlist.Cap__c, temp);
                        }
                    }
                    if (!tempMaxSet.contains(schlist.OrderNumber__c + schlist.Max_Per_Day__c)) {
                        tempMaxSet.add(schlist.OrderNumber__c + schlist.Max_Per_Day__c);
                    }
                    if (schMaxGroup.containsKey(schlist.OrderNumber__c + schlist.Max_Per_Day__c)) {
                        List<Schedules__c> temp = schMaxGroup.get(schlist.OrderNumber__c + schlist.Max_Per_Day__c);
                        temp.add(schlist);
                        schMaxGroup.put(schlist.OrderNumber__c + schlist.Max_Per_Day__c, temp);
                    } else {
                        List<Schedules__c> temp = new List<Schedules__c>();
                        temp.add(schlist);
                        schMaxGroup.put(schlist.OrderNumber__c + schlist.Max_Per_Day__c, temp);
                    }
                }
            }

            List<String> tempRateList = new List<String>(tempRateSet);
            pageCount = Integer.valueOf(Math.ceil(Double.valueOf(tempRateList.size()) / 10));

            if(currentPage == null) {
                currentPage = 1;
            }

            if (currentPage == 1) {
                prevPage = false;
            } else {
                prevPage = true;
            }

            if(currentPage >= pageCount) {
                nextPage = false;
            } else {
                nextPage = true;
            }

            Integer offset = (currentPage - 1) * 10;
            Integer offsetEnd = (offset + 10 < tempRateList.size()) ? (offset + 10) : tempRateList.size();

            for(Integer i = offset; i < offsetEnd; i++) {
                rateSet.add(tempRateList[i]);

                for(Schedules__c sch : schgroup.get(tempRateList[i])) {
                    if (LowestDate > sch.Week__c) {
                        LowestDate = sch.Week__c;
                    }
                    if (HighestDate < sch.Week__c) {
                        HighestDate = sch.Week__c;
                    }
                }
            }

            List<String> tempCapList = new List<String>(tempCapSet);
            pageCountCap = Integer.valueOf(Math.ceil(Double.valueOf(tempCapList.size()) / 10));

            if(currentPageCap == null) {
                currentPageCap = 1;
            }

            if (currentPageCap == 1) {
                prevPageCap = false;
            } else {
                prevPageCap = true;
            }

            if(currentPageCap >= pageCountCap) {
                nextPageCap = false;
            } else {
                nextPageCap = true;
            }
            
            Integer offsetCap = (currentPageCap - 1) * 10;
            Integer offsetEndCap = (offsetCap + 10 < tempCapList.size()) ? (offsetCap + 10) : tempCapList.size();

            for(Integer i = offsetCap; i < offsetEndCap; i++) {
                capSet.add(tempCapList[i]);
            }
            
            List<String> tempMaxList = new List<String>(tempMaxSet);
            pageCountMax = Integer.valueOf(Math.ceil(Double.valueOf(tempMaxList.size()) / 10));

            if(currentPageMax == null) {
                currentPageMax = 1;
            }

            if (currentPageMax == 1) {
                prevPageMax = false;
            } else {
                prevPageMax = true;
            }

            if(currentPageMax >= pageCountMax) {
                nextPageMax = false;
            } else {
                nextPageMax = true;
            }
            
            Integer offsetMax = (currentPageMax - 1) * 10;
            Integer offsetEndMax = (offsetMax + 10 < tempMaxList.size()) ? (offsetMax + 10) : tempMaxList.size();

            for(Integer i = offsetMax; i < offsetEndMax; i++) {
                maxSet.add(tempMaxList[i]);
            }

            List<Deal__c> DealList = [select Id,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c, Program__r.Name, Brands__r.Name, Name, Week_MIN_Field__c, Length__c, Advertiser__c, Campaign__c, Network_Deal_Number__c, Agency_Deal_Number__c from Deal__c where Id =: DealId];
            if (DealList.size() > 0) {
                ListOfDates(DealList[0].Week_MIN_Field__c);
                SelectedDeal = DealList[0];
            }

            System.debug('***SearchforSchedules: rateSet ' + rateSet);
            System.debug('***SearchforSchedules: schgroup ' + schgroup);
            List<String> TempWeekDollarsList = new List<String>();
            Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();
            for(String mapkeylist : rateSet )  {
                //System.debug('***SearchforSchedules: mapkeylist ' + mapkeylist);
                List<Schedules__c> tempwraplist = schgroup.get(mapkeylist);
                //System.debug('***SearchforSchedules: tempwraplist ' + tempwraplist);
                weekMap = new Map<Date,Schedules__c>();
                DuplicateWeekMap = new Map<Date, Boolean>();
                //buildWeekMap(tempwraplist) ;
                for(Schedules__c schtemp:tempwraplist ) {
                    //System.debug('***buildWeekMap: schtemp.Week__c: ' + schtemp.Week__c);
                    if (WeekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekmap.put(schtemp.Week__c, schtemp);
                    if (WeekDollarsMap.containsKey(schtemp.Week__c)) {
                        Decimal WeekDollars = WeekDollarsMap.get(schtemp.Week__c);
                        WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                        WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        //System.debug('***buildWeekMap: WeekDollars: ' + WeekDollars);
                    }
                    else {
                        Decimal WeekDollars = 0;
                        WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                        WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        //System.debug('***buildWeekMap: WeekDollars: ' + WeekDollars);
                    }
                }

                rateList.add(BuildRateModel(tempwraplist, mapkeylist));
                LTClist.add(BuildRateModel(tempwraplist, mapkeylist));
                ExtensionList.add(BuildRateModel(tempwraplist, mapkeylist));
                UnitsAvailableList.add(BuildRateModel(tempwraplist, mapkeylist));
                testTabList.add(BuildRateModel(tempwraplist, mapkeylist));
                ghostTabList.add(BuildRateModel(tempwraplist, mapkeylist));
                dayPartTabList.add(BuildRateModel(tempwraplist, mapkeylist));
                hiatusList.add(BuildRateModel(tempwraplist, mapkeylist));
            }

            for(String mapkeylist : capSet)  {
                List<Schedules__c> tempwraplist = schCapGroup.get(mapkeylist);

                weekMap = new Map<Date,Schedules__c>();
                DuplicateWeekMap = new Map<Date, Boolean>();
                for(Schedules__c schtemp : tempwraplist) {
                    if (WeekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekmap.put(schtemp.Week__c, schtemp);
                }

                capTabList.add(BuildRateModel(tempwraplist, mapkeylist));
            }
            
            for(String mapkeylist : maxSet)  {
                List<Schedules__c> tempwraplist = schMaxGroup.get(mapkeylist);

                weekMap = new Map<Date,Schedules__c>();
                DuplicateWeekMap = new Map<Date, Boolean>();
                for(Schedules__c schtemp : tempwraplist) {
                    if (WeekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekmap.put(schtemp.Week__c, schtemp);
                }

                maxTabList.add(BuildRateModel(tempwraplist, mapkeylist));
            }

            Display();

            for (headingModel HM : headingModels) {
                if (WeekDollarsMap.containsKey(HM.StartOfWeek)) {
                    Decimal DollarAmount = WeekDollarsMap.get(HM.StartOfWeek);
                    String StringAmount;
                    if (DollarAmount < 1000) {
                        StringAmount =  '$' + String.valueOf(DollarAmount);
                        StringAMount = StringAmount.replace('.00','');
                    } else {
                        DOllarAmount = DollarAMount.setScale(0);
                        DollarAmount = DollarAmOunt/1000.0;
                        DollarAmount = DollarAmount.setScale(1);
                        StringAmount =  '$' + String.valueOf(DollarAmount);
                        StringAmount = StringAmount.replace('.0','') + 'K';
                    }
                    TempWeekDollarsList.add(StringAmount);
                    //System.debug('***SearchforSchedules: StringAmount: ' + StringAmount) ;
                } else {
                    TempWeekDollarsList.add('$0');
                    //System.debug('***SearchforSchedules: StringAmount: $0') ;
                }
            }
            WeekDollarsList = TempWeekDollarsList;

        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void loadNextPage() {
        if(currentPage == null) {
            currentPage = 2;
        } else {
            currentPage = currentPage + 1;
        }
        SearchforSchedules();
    }

    public void loadPrevPage() {
        if(currentPage == null || currentPage == 1) {
            currentPage = 1;
        } else {
            currentPage = currentPage - 1;
        }
        SearchforSchedules();
    }

    public void goToPage() {
        try {
            String temp = ApexPages.currentPage().getParameters().get('selectedPage');
            Integer selectedPage = Integer.valueOf(temp);
            if(selectedPage > pageCount) {
                currentPage = pageCount;
            } else if(selectedPage < 1) {
                currentPage = 1;
            } else {
                currentPage = selectedPage;
            }
            SearchforSchedules();
        } catch(Exception e) {}
    }

    public void loadNextPageCap() {
        if(currentPageCap == null) {
            currentPageCap = 2;
        } else {
            currentPageCap = currentPageCap + 1;
        }
        SearchforSchedules();
    }

    public void loadPrevPageCap() {
        if(currentPageCap == null || currentPageCap == 1) {
            currentPageCap = 1;
        } else {
            currentPageCap = currentPageCap - 1;
        }
        SearchforSchedules();
    }

    public void goToPageCap() {
        try {
            String temp = ApexPages.currentPage().getParameters().get('selectedPageCap');
            Integer selectedPageCap = Integer.valueOf(temp);
            if(selectedPageCap > pageCountCap) {
                currentPageCap = pageCountCap;
            } else if(selectedPageCap < 1) {
                currentPageCap = 1;
            } else {
                currentPageCap = selectedPageCap;
            }
            SearchforSchedules();
        } catch(Exception e) {}
    }
    
    public void loadNextPageMax() {
        if(currentPageMax == null) {
            currentPageMax = 2;
        } else {
            currentPageMax = currentPageMax + 1;
        }
        SearchforSchedules();
    }

    public void loadPrevPageMax() {
        if(currentPageMax == null || currentPageMax == 1) {
            currentPageMax = 1;
        } else {
            currentPageMax = currentPageMax - 1;
        }
        SearchforSchedules();
    }

    public void goToPageMax() {
        try {
            String temp = ApexPages.currentPage().getParameters().get('selectedPageMax');
            Integer selectedPageMax = Integer.valueOf(temp);
            if(selectedPageMax > pageCountMax) {
                currentPageMax = pageCountMax;
            } else if(selectedPageMax < 1) {
                currentPageMax = 1;
            } else {
                currentPageMax = selectedPageMax;
            }
            SearchforSchedules();
        } catch(Exception e) {}
    }

    public void Display() {
        if(ratelist.size() == 0 ) {
            schedulemessage = true;
            showtable = false;
        } else {
            showtable = true;
            schedulemessage = false;
        }
    }

    public void ListOfDates(Date pAnchorDate) {
        try {
            //Red Argyle - #2791:Controller issues with atypical fiscal quarters
            Date AnchorDate = pAnchorDate;
            
            Period period = [SELECT Id, EndDate, StartDate, Type 
                        FROM Period 
                        WHERE Type = 'Quarter' 
                        AND StartDate <= :AnchorDate 
                        AND EndDate >= :AnchorDate 
                        LIMIT 1];
            Date StartOfQuarter = period.StartDate;
            Date EndOfQuarter = period.EndDate;
            QuarterEndDate = period.EndDate;
            
            if (HighestDate > EndOfQuarter) {
                EndOfQuarter = HighestDate;
            }
            if (AnchorDate > EndOfQuarter) {
                ListOfDates(AnchorDate.addDays(7));
            }
            quarterDates = new List<Date>();
            while (StartOfQuarter <= EndOfQuarter) {
                quarterdates.add(StartOfQuarter);
                endDate = StartOfQuarter;
                StartOfQuarter = StartOfQuarter.addDays(7);
            }
            //quarterdates.add(enddate);
            headingModels  = new List<headingModel>();
            quarterweek = new List<WeekModel>();
            for(Date sow: quarterdates) {
                if (sow != null) {
                    HeadingModel hm = new Headingmodel();
                    hm.startOfWeek = sow;
                    System.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (SOW >= LowestDate));
                    if (sow >= LowestDate) {
                        headingModels.add(hm);
                    }
                }
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void ScheduleChange() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : LTClist ) {
                if(rate.ischecked) {
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERror, 'Past weeks cannot be cancelled'));
                        } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                        } else {
                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                Deal__c = DealId,
                                Tab__c = 'LTC'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    if(weekObj.schObj.Week__c == rate.Scheduleobj.Week__c.toStartofWeek().addDays(1)) {
                                        schtoupdate.add(ScheduleHiatus.hiatusDateRange(new List<Schedules__c>{weekobj.schObj}, rate.Scheduleobj.Week__c.addDays(1), weekObj.schObj.Week__c.addDays(6))[0]);
                                    } else if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1) ) {
                                        weekobj.schObj.Status__c  = 'Canceled';
                                        schtoupdate.add(weekobj.schobj);

                                        scheduleNames.add(weekObj.schobj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                            change.Original_Rate__c = weekobj.schObj.Rate__c;
                                            change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                            change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                            change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                            change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                            change.Original_Cap__c = weekobj.schObj.Cap__c;
                                            change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                        } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                        }
                                    }
                                }
                            }

                            if(scheduleNames.size() >= 1) {
                                String names = String.join(scheduleNames, ';');
                                change.Schedules__c = names;
                                change.LTC_Date__c = change.Week_Start__c;
                                changes.add(change);
                            }
                        }
                    }
                }
            }
            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision  = '';
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void RateUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : rateList) {
                System.debug('rate 501 - ' + rate.OrderLineNumber);
                if(rate.ischecked) {
                    System.debug('rate 504 checked - ' + rate.OrderLineNumber + ' - ' + rate.rate + ' - ' + rate.Scheduleobj.Week__c);
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.ScheduleObj.Week__c < Date.Today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The rate cannot be updated for past weeks'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                        } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                        } else {
                            System.debug('rate 508 Day not null - ' + rate.OrderLineNumber);

                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                Deal__c = DealId,
                                Tab__c = 'Rate'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    System.debug('rate 514 schobj not null - ' + rate.OrderLineNumber + ' - ' + weekobj.schObj.Id);
                                    if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.SchObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                        if(change.Original_Rate__c == null) {
                                            change.Original_Rate__c = weekobj.schObj.Rate__c;
                                            change.Changed_Rate__c = Decimal.valueof(rate.rate);

                                            change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                            change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                            change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                            change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                            change.Original_Cap__c = weekobj.schObj.Cap__c;
                                            change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                        }

                                        weekobj.schObj.Rate__c = Decimal.valueof(rate.rate);
                                        System.debug('Rate updated - ' + weekobj.schObj.Id + ' - ' + weekobj.schObj.Rate__c);
                                        schtoupdate.add(weekobj.schobj);

                                        scheduleNames.add(weekObj.schobj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                        } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                        }

                                        if(change.Week_End__c == null) {
                                            change.Week_End__c = weekobj.schObj.week__c;
                                        } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                            change.Week_End__c = weekobj.schObj.week__c;
                                        }
                                    }
                                }
                            }

                            if(scheduleNames.size() >= 1) {
                                String names = String.join(scheduleNames, ';');
                                change.Schedules__c = names;
                                changes.add(change);
                            }
                        }
                    }
                }
            }
            update schtoupdate;
            system.debug('schtoupdate size - ' + schtoupdate.size());

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision  = '';
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void UnitsAvailableUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : UnitsAvailableList) {
                if(rate.ischecked) {
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.ScheduleObj.Week__c < Date.Today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Units Available cannot be updated for past weeks'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                        } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                        } else {
                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                Deal__c = DealId,
                                Tab__c = 'Frequency'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.SchObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                        if(change.Original_Units_Available__c == null) {
                                            change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                            change.Changed_Units_Available__c = Decimal.valueOf(rate.UnitsAvailable);

                                            change.Original_Rate__c = weekobj.schObj.Rate__c;
                                            change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                            change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                            change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                            change.Original_Cap__c = weekobj.schObj.Cap__c;
                                            change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                        }

                                        weekobj.schObj.units_Available__c = decimal.valueOf(rate.UnitsAvailable);
                                        schtoupdate.add(weekobj.schobj);

                                        scheduleNames.add(weekObj.schobj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                        } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.week__c;
                                        }

                                        if(change.Week_End__c == null) {
                                            change.Week_End__c = weekobj.schObj.week__c;
                                        } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                            change.Week_End__c = weekobj.schObj.week__c;
                                        }
                                    }
                                }
                            }

                            if(scheduleNames.size() >= 1) {
                                String names = String.join(scheduleNames, ';');
                                change.Schedules__c = names;
                                changes.add(change);
                            }
                        }
                    }
                }
            }
            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision  = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void ExtensionUpdate() {
        try {
            List<Schedules__c> NewSchedulesToInsert = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : ExtensionList ) {
                if(rate.isChecked) {
                    System.debug('rate.Scheduleobj.Week__c - ' + rate.ScheduleObj.Week__c);
                    if(rate.Scheduleobj.Week__c != null ) {
                        System.debug('date values - ' + rate.ScheduleObj.Week__c + ' - ' + rate.HighestDate);
                        if (rate.ScheduleObj.Week__c < Date.Today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Extensions cannot be created for past weeks'));
                        } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Extensions cannot be created for weeks that extend beyond the last week of the quarter'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                        } else {
                            if (rate.ScheduleObj.Week__c > rate.HighestDate ) {
                                Boolean ScheduleFound = false;
                                Integer WeekSize = rate.Weeks.size() - 1;
                                Schedules__c CloneSchedule;
                                while (!ScheduleFound) {
                                    if (rate.weeks[WeekSize].schObj != null) {
                                        ScheduleFound = true;
                                        CloneSchedule = rate.Weeks[weekSize].schObj;
                                    } else {
                                        WeekSize = WeekSize - 1;
                                    }
                                }
                                System.debug('comes inside end date - ' + endDate + ' - ' + QuarterEndDate);
                                if (CloneSchedule != null) {
                                    if (CloneSchedule.week__c.addDays(7) <= rate.ScheduleObj.Week__c) {
                                        //Change the Date.TOday().ToStartOfWeek().addDays(1) to HighestDate

                                        Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                            Deal__c = DealId,
                                            Tab__c = 'Extend',
                                            Week_Start__c = CloneSchedule.week__c.addDays(7),
                                            Original_Rate__c = CloneSchedule.Rate__c,
                                            Original_Daypart__c = CloneSchedule.MGM_HD_Daypart__c,
                                            Original_Days_Allowed__c = CloneSchedule.Days_Allowed__c,
                                            Original_Start_End_Time__c = CloneSchedule.Start_End_Time__c,
                                            Original_Units_Available__c = CloneSchedule.Units_Available__c,
                                            Original_Cap__c = CloneSchedule.Cap__c,
                                            Original_Max_Per_Day__c = CloneSchedule.Max_Per_Day__c
                                        );
                                        List<String> scheduleNames = new List<String>();

                                        for (Date StartDate = CloneSchedule.week__c.addDays(7); StartDate <= rate.ScheduleObj.Week__c && StartDate <= QuarterEndDate; StartDate = StartDate.addDays(7)) {
                                            System.debug('Schedule Created - ' + StartDate);
                                            System.debug('CloneSchedule values - ' + CloneSchedule.Name + ' - ' + CloneSchedule.Week__c);
                                            sObject NewScheduleObj = (sObject)(CloneSchedule).clone(false, false, false);
                                            Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);
                                            NewSCHRecord.Total_Schedules__c  = '0';
                                            NewSCHRecord.SI_Number_if_Billed__c = null;
                                            NewSCHRecord.Reviewed_for_Invoicing__c = false;
                                            NewSCHREcord.Intacct_SI_Number__c = null;
                                            NewSCHRecord.Units_Preempted__c = null;
                                            NewSCHRecord.Status__c = 'Sold';
                                            NewSCHRecord.ISCI_CODE__c = null;
                                            NewSCHRecord.X800_Number__c = null;
                                            NewSCHrecord.Days_of_Air__c = null;
                                            newSCHRecord.Pod__c = null;
                                            NewSCHRecord.LF_traffic__c = null;
                                            NewSCHRecord.Comments__c = null;
                                            NewSCHRecord.Error_Cost__c = null;
                                            NewSCHrecord.Error_Logged_To__c = null;
                                            NewSCHRecord.Error_Reason__c = null;
                                            newSCHRecord.Discrepancy_Comment__c = null;
                                            NewSCHRecord.Week__c = StartDate;
                                            NewSCHRecord.Duplicate_Check__c= null;
                                            NewSCHRecord.TEST__c = false;
                                            NewSchedulesToInsert.add(NewSCHRecord);

                                            change.Week_End__c = StartDate;
                                        }

                                        if(change.Week_End__c != null) {
                                            scheduleNames.add(CloneSchedule.Name);
                                            String names = String.join(scheduleNames, ';');
                                            change.Schedules__c = names;
                                            changes.add(change);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            if (NewSchedulesToInsert.size() > 0) {
                insert NewSchedulesToInsert;
            }

            if(changes.size() > 0) {
                insert changes;
            }
            SearchforSchedules();
            SaveDescision  = '';
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    //Update method for the Test Tab.
    //Sets Test__c to true and updates the schedule for each of the selected schedules.
    public void testTabUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : testTabList ) {
                //Don't do anything if this schedule was not selected for an update or if the day field is blank.
                if(rate.isChecked == false || rate.Scheduleobj.Week__c == null) {
                    continue;
                }
                if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The Test checkbox cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                        Deal__c = DealId,
                        Tab__c = 'Test'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.week__c == rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                weekobj.schObj.Test__c = true;

                                //For some reason, the Days_Allowed__c field is not binding to the page.
                                //This current workaround writes the days allowed value to an property when the weekobj is instantiated.
                                //Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schobj);

                                scheduleNames.add(weekObj.schobj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.week__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                }
                            }
                        }
                    }

                    if(scheduleNames.size() >= 1) {
                        String names = String.join(scheduleNames, ';');
                        change.Schedules__c = names;
                        changes.add(change);
                    }
                }
            }

            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    //Update method for the Ghost Tab.
    //Sets Ghost_Order__c to true and updates the schedule for each of the selected schedules.
    public void ghostTabUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            for(RateModel rate : ghostTabList ) {
                //Don't do anything if this schedule was not selected for an update or if the day field is blank.
                if(rate.isChecked == false || rate.Scheduleobj.Week__c == null) {
                    continue;
                }
                if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The Ghost Order checkbox cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                } else {
                    for(WeekModel weekobj :rate.weeks) {
                        system.debug(weekobj);
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                weekobj.schObj.Ghost_Order__c = true;

                                //For some reason, the Days_Allowed__c field is not binding to the page.
                                //This current workaround writes the days allowed value to a property when the weekobj is instantiated.
                                //Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schobj);
                            }
                        }
                    }
                }
            }

            update schtoupdate;
            SearchforSchedules();
            SaveDescision = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    //Update method for the Ghost Tab.
    //Sets Ghost_Order__c to true and updates the schedule for each of the selected schedules.
    public void capTabUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : capTabList ) {
                System.debug('*** capTabUpdate: rateModel: ' + rate) ;
                //Don't do anything if this schedule was not selected for an update or if the day field is blank.
                if(rate.isChecked == false || rate.Scheduleobj.Week__c == null) {
                    System.debug('*** capTabUpdate: isCheckedFalse or Week__c null') ;
                    continue;
                }
                if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The Cap__c picklist cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                        Deal__c = DealId,
                        Tab__c = 'Cap'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        System.debug('*** capTabUpdate: weekobj:' + weekobj) ;
                        system.debug(weekobj);
                        if(weekobj.schObj != null) {
                            System.debug('*** capTabUpdate: weekobj SchObj !null:' + weekobj.schObj) ;
                            if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                System.debug('*** capTabUpdate: weekobj correct week:') ;

                                if(change.Original_Cap__c == null) {
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Changed_Cap__c = rate.ScheduleObj.Cap__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                }

                                weekobj.schObj.Cap__c = rate.ScheduleObj.Cap__c;

                                //For some reason, the Days_Allowed__c field is not binding to the page.
                                //This current workaround writes the days allowed value to a property when the weekobj is instantiated.
                                //Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schobj);

                                scheduleNames.add(weekObj.schobj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                }
                            }
                        }
                    }

                    if(scheduleNames.size() >= 1) {
                        String names = String.join(scheduleNames, ';');
                        change.Schedules__c = names;
                        changes.add(change);
                    }
                }
            }

            System.debug('*** capTabUpdate: schtoupdate:' + schtoupdate) ;
            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void dayPartTabUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : dayPartTabList) {
                //Don't do anything if this schedule was not selected for an update or if the day field is blank.
                if(rate.isChecked == false || rate.Scheduleobj.Week__c == null) {
                    continue;
                }

                if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                        Deal__c = DealId,
                        Tab__c = 'Daypart'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                system.debug(logginglevel.error, weekobj.schobj.Id + ' ==> ' + weekobj.schobj.week__c);

                                schtoupdate.add(new Schedules__c(
                                    Id=weekobj.schObj.Id,
                                    Networks__c=rate.scheduleObj.Networks__c,
                                    MGM_HD_Daypart__c=rate.scheduleObj.MGM_Hd_Daypart__c,
                                    Start_Time__c=rate.scheduleObj.Start_Time__c,
                                    End_Time__c=rate.scheduleObj.End_Time__c,
                                    Days_Allowed__c=rate.scheduleObj.Days_Allowed__c
                                ));
                                system.debug(schtoupdate);

                                if(change.Original_Daypart__c == null) {
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Changed_Daypart__c = rate.ScheduleObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Changed_Days_Allowed__c = rate.ScheduleObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Changed_Start_End_Time__c = rate.ScheduleObj.Start_Time__c + '-' + rate.Scheduleobj.End_Time__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                }

                                scheduleNames.add(weekObj.schobj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                }
                            }
                        }
                    }

                    if(scheduleNames.size() >= 1) {
                        String names = String.join(scheduleNames, ';');
                        change.Schedules__c = names;
                        changes.add(change);
                    }
                }
            }
            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void HiatusUpdate() {
        try {
            if(hiatusTempScheduleStart.Week__c == null) {
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Must at least fill in a Start Date for the Hiatus'));
            } else if(hiatusTempScheduleStart.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Cannot be updated for past weeks'));
            } else if(hiatusTempScheduleEnd.Week__c != null && hiatusTempScheduleEnd.Week__c < hiatusTempScheduleStart.Week__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Hiatus End Date must come after Hiatus Start Date'));
            } else {
                List<Schedules__c> schedulesToUpdate;

                // Query for all schedules on the deal, using the reconciled flag
                String query = 'SELECT ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' FROM Schedules__c WHERE Deal_Parent__c = \'' + DealId + '\'';
                if(filterReconciledWeeks == true) {
                    query += ' AND Reconciled__c = \'N\'';
                }

                if(hiatusTempScheduleEnd.Week__c != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusDateRange(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTempScheduleEnd.Week__c);
                } else if(hiatusTimeAfter != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusTimeAfter(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTimeAfter);
                } else if(hiatusTimeBefore != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusTimeBefore(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTimeBefore);
                } else {
                    schedulesToUpdate = ScheduleHiatus.hiatusSingleDay(Database.query(query), hiatusTempScheduleStart.Week__c);
                }

                if(schedulesToUpdate != null && schedulesToUpdate.size() > 0) {
                    upsert schedulesToUpdate;
                }

                SearchforSchedules();
                SaveDescision  = '';
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }
    
    //Update method for the Max Per Day Tab.
    public void maxTabUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : maxTabList ) {
                System.debug('*** maxTabUpdate: rateModel: ' + rate) ;
                //Don't do anything if this schedule was not selected for an update or if the day field is blank.
                if(rate.isChecked == false || rate.Scheduleobj.Week__c == null) {
                    System.debug('*** maxTabUpdate: isCheckedFalse or Week__c null') ;
                    continue;
                }
                if (rate.ScheduleObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The Max_Per_Day__c picklist cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartofWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The selected date must be a Monday.'));
                } else if (rate.ScheduleObj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Cannot select dates for weeks that extend beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                        Deal__c = DealId,
                        Tab__c = 'Max'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        System.debug('*** maxTabUpdate: weekobj:' + weekobj) ;
                        system.debug(weekobj);
                        if(weekobj.schObj != null) {
                            System.debug('*** maxTabUpdate: weekobj SchObj !null:' + weekobj.schObj) ;
                            if(weekobj.schObj.week__c >= rate.Scheduleobj.Week__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                                System.debug('*** maxTabUpdate: weekobj correct week:') ;

                                if(change.Original_Max_Per_Day__c == null) {
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                    change.Changed_Max_Per_Day__c = rate.ScheduleObj.Max_Per_Day__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                }

                                weekobj.schObj.Max_Per_Day__c = rate.ScheduleObj.Max_Per_Day__c;
                                System.debug('Max per day ' + weekobj.schObj.Max_Per_Day__c);

                                //For some reason, the Days_Allowed__c field is not binding to the page.
                                //This current workaround writes the days allowed value to a property when the weekobj is instantiated.
                                //Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schobj);

                                scheduleNames.add(weekObj.schobj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                } else if (weekobj.schObj.week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.week__c;
                                }
                            }
                        }
                    }

                    if(scheduleNames.size() >= 1) {
                        String names = String.join(scheduleNames, ';');
                        change.Schedules__c = names;
                        changes.add(change);
                    }
                }
            }

            System.debug('*** maxTabUpdate: schtoupdate:' + schtoupdate) ;
            update schtoupdate;

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision = '';
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void cellsave() {
        try {
            if( (CellId != null && CellId != '') && (cellrate != null && cellrate != '') ) {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schtoupdate.rate__c = Decimal.valueof(cellrate);
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void TestChecksave() {
        try {
            if( (CellId != null && CellId != '') && (SelectedTest != null && SelectedTest != '') ) {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schToUpdate.Test__c = Boolean.valueOf(selectedTest);
                upsert schtoupdate;
                SearchforSchedules();
                SelectedTest ='';
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void GhostChecksave() {
        try {
            if( (CellId != null && CellId != '') && (SelectedGhost != null && SelectedGhost != '') ) {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schtoupdate.Ghost_Order__c = Boolean.valueOf(SelectedGhost);
                upsert schtoupdate;
                SearchforSchedules();
                SelectedGhost ='';
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void UnitsAvailableSave() {
        try {
            if( (CellId != null && CellId != '') && (cellUnits != null && cellUnits != '') ) {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schtoupdate.Units_Available__c = Decimal.valueof(cellUnits);
                upsert schtoupdate;
                SearchforSchedules();
                cellUnits ='';

            }
        } catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void LTCsave() {
        try {
            if( (CellId != null && CellId != '') ) {
                Schedules__c schtoupdate = [select Id, Status__c from Schedules__c where Id =: CellId];
                if (schtoUpdate.status__c == 'Canceled') {
                    schtoUpdate.status__c = 'Sold';
                } else {
                    schtoUpdate.Status__c = 'Canceled';
                }
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void ExtensionSave() {
        try {
            if (SelectedExtensionDate != null && SelectedOrderLineNumber != null && SelectedOrderLineNumber != '') {
                List<String> StrList = SelectedExtensionDate.split('-');
                Date WeekDate = Date.NewInstance(integer.valueOf(StrList[0]), Integer.valueof(StrList[1]), Integer.valueOf(StrList[2]));
                String ScheduleQuery = 'select ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' from Schedules__c where OrderNumber__c = \'' + SelectedOrderLineNumber + '\' AND Week__c < ' + SaberGF.FormatDate(WeekDate, 'FQD') + ' ORDER BY Week__c DESC Limit 1';
                System.debug('ScheduleQuery - ' + ScheduleQUery);
                List<Schedules__c> SchedulesList = Database.query(ScheduleQuery);
                if (SchedulesList.size() > 0) {
                    if (StrList.size() == 3) {
                        sObject NewScheduleObj = (sObject)(SchedulesList[0]).clone(false, false, false);
                        Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);

                        System.debug('Duplicate Check 1 - ' + NewSCHRecord.Duplicate_Check_1a__c + ' - ' + NewSCHRecord.Duplicate_Check__c);
                        NewSCHRecord.Total_Schedules__c  = '0';
                        NewSCHRecord.SI_Number_if_Billed__c = null;
                        NewSCHRecord.Reviewed_for_Invoicing__c = false;
                        NewSCHREcord.Intacct_SI_Number__c = null;
                        NewSCHRecord.Units_Preempted__c = null;
                        NewSCHRecord.Status__c = 'Sold';
                        NewSCHRecord.ISCI_CODE__c = null;
                        NewSCHRecord.X800_Number__c = null;
                        NewSCHrecord.Days_of_Air__c = null;
                        newSCHRecord.Pod__c = null;
                        NewSCHRecord.LF_traffic__c = null;
                        NewSCHRecord.Comments__c = null;
                        NewSCHRecord.Error_Cost__c = null;
                        NewSCHrecord.Error_Logged_To__c = null;
                        NewSCHRecord.Error_Reason__c = null;
                        newSCHRecord.Discrepancy_Comment__c = null;
                        NewSCHRecord.Week__c = WeekDate;
                        NewSCHRecord.Duplicate_Check__c= null;
                        System.debug('Duplicate Check 2 - ' + NewSCHRecord.Duplicate_Check_1a__c + ' - ' + NewSCHRecord.Duplicate_Check__c);
                        System.debug('DealParentId Before - ' + NewSCHRecord.Deal_Parent__c);
                        insert NewSCHRecord;
                        System.debug('DealParentId After - ' + NewSCHRecord.Deal_Parent__c);
                        SearchforSchedules();
                        cellrate ='';
                        SelectedExtensionDate = null;
                        SelectedOrderLineNumber = '';
                    }
                }
            }
        } catch(Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public void cellcancel() {
        SearchforSchedules();
    }

    public class HeadingModel {
        public String cols{get; set;}
        public Date startOfWeek {get; set;}
    }

    public Decimal currentRateModelIndex {get; set;}

    //Copy the RateModel schedules's dependent fields into each associated WeekModel schedule.
    public void updateWeeks() {
        List<Schedules__c> schedulesToUpdate = new List<Schedules__c>();
        Schedules__c mainSch = this.dayPartTabList[Integer.valueOf(this.currentRateModelIndex)].scheduleObj;
        System.debug(LoggingLevel.ERROR, 'Main Schedule ==> ' + mainSch);
        System.debug(LoggingLevel.ERROR, 'Current Index ==> ' + this.currentRateModelIndex);
        System.debug(LoggingLevel.ERROR, 'Day Part Tab List ==> ' + this.dayPartTabList);
        for (WeekModel week : this.dayPartTabList[Integer.valueOf(this.currentRateModelIndex)].weeks) {
            System.debug(LoggingLevel.ERROR, 'Week ==> ' + week.schObj);
            Schedules__c sch = week.schObj;
            if (sch != null) {
                if (sch.Week__c >= Date.Today().toStartOfWeek().addDays(1)) {
                    sch.Networks__c = mainSch.Networks__c;
                    sch.MGM_HD_Daypart__c = mainSch.MGM_HD_Daypart__c;
                    sch.End_Time__c = mainSch.End_Time__c;
                    sch.Start_Time__c = mainSch.Start_Time__c;
                    sch.Days_Allowed__c = mainSch.Days_Allowed__c;
                    schedulesToUpdate.add(sch);
                }
            }
        }
        try {
            update schedulesToUpdate;
            SearchforSchedules();
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    public String currentScheduleId {get; set;}
    public void updateSchedule() {
        Id test;
        try {
            for (RateModel rate : this.dayPartTabList) {
                for (WeekModel week : rate.weeks) {
                    if (week.schobj != null && this.currentScheduleId != null) {
                        if (String.valueOf(week.schobj.Id) == this.currentScheduleId) {
                            if (week.schobj.Week__c < Date.Today().toStartOfWeek().addDays(1)) {
                                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Past week\'s schedules cannot be updated.'));
                            } else {
                                //DML is okay inside of this loop.
                                //Since we are checking for a specific ID, we can only get here once.
                                //week.schobj.Days_Allowed__c = this.getDaysAllowedString(week.schobj.Days_Allowed__c);
                                update week.schobj;
                            }
                        }
                    }
                }
            }
            SearchforSchedules();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'Loop schedule Id ==> ' + test));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'Schedule Id ==> ' + this.currentScheduleId));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));
        }
    }

    /*private String getDaysAllowedString(String daysAllowed) {
        daysAllowed = daysAllowed.replace('[', '');
        daysAllowed = daysAllowed.replace(']', '');
        List<String> daysList = daysAllowed.split(', ');
        return String.join(daysList, ';');
    }*/

    public class RateModel  {
        public Boolean isChecked {get; set;}
        public String rate {get; set;}
        public String OrderLineNumber {get; set;}
        public String DaysAllowed {get; set;}
        public String SETime {get; set;}
        public Decimal UnitLength  {get; set;}
        public List<weekModel> weeks {get; set;}
        public Boolean Test {get; set;}
        public Boolean Ghost {get; set;}
        public Decimal changerate {get; set;}
        public Schedules__c Scheduleobj {get; set;}
        public Date DayValue {get; set;}
        public Date LowestDate {get; set;}
        public Date HighestDate {get; set;}
        public String UnitsAvailable {get; set;}
        public String network {get; set;}
        public String endTime {get; set;}
        public String startTime {get; set;}
        public String cableDayParts {get; set;}

        public rateModel() {
            isChecked = false;
            weeks = new List<weekModel>();
            Scheduleobj = new Schedules__c();
            UnitsAvailable = '0';

        }
    }

    public class WeekModel  {
        public Date startOfWeek {get; set;}
        public Schedules__c schObj{get; set;}
        public String color {get; set;}
        public String ghostColor {get;  set;}
        public Decimal changerate {get; set;}
        public Boolean CellAvailable {get; set;}
        public Boolean ExtensionAvailable {get; set;}
        public String OrderLineNumber {get; set;}
        public String ExtensionDate {get; set;}
        public Boolean MultipleSchedules {get; set;}
        public String daysAllowed {get; set;}
        public weekModel(Date pstartOfWeek , Schedules__c pschObj, Boolean pMultipleSchedules) {
            MultipleSchedules = pMultipleSchedules;
            ExtensionDate = string.valueOf(pStartOfWeek.Year()) + '-' + String.valueOf(pStartOfWeek.month()) + '-' + String.valueOf(pStartOfWeek.day());
            ExtensionAvailable = false;
            CellAvailable = true;
            startOfWeek = pstartOfWeek;
            schObj = pschObj;
            daysAllowed = pschObj.Days_Allowed__c;
            if(schObj.Status__c == 'Canceled') {
                color ='red';
            } else if(schObj.Test__c == true) {
                color='blue';
            } else {
                color='black';
            }

            if (schObj.Ghost_Order__c == true) {
                ghostColor = 'grey';
            } else {
                ghostColor = 'black';
            }

            if (pschObj.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                CellAvailable = false;
            }
        }

        public weekmodel(Date pstartOfWeek, string pOrderLineNumber) {
            ExtensionDate = string.valueOf(pStartOfWeek.Year()) + '-' + String.valueOf(pStartOfWeek.month()) + '-' + String.valueOf(pStartOfWeek.day());
            startOfWeek = pstartOfWeek;
            CellAvailable = false;
            if (pStartOfWeek >= Date.Today().ToStartOfWeek().addDays(1)) {
                ExtensionAvailable = true;
            } else {
                ExtensionAvailable = false;
            }
            OrderLineNumber = pOrderLineNUmber;
        }
    }

    //Defines the available picklist options for the program team search field.
    public List<SelectOption> getProgramTeamOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', 'Select a Team'));
        options.add(new SelectOption('Blue', 'Blue'));
        options.add(new SelectOption('Red', 'Red'));
        options.add(new SelectOption('Yellow', 'Yellow'));
        options.add(new SelectOption('Onyx', 'Onyx'));
        return options;
    }

    public List<SelectOption> getDayOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Mon', 'Mon'));
        options.add(new SelectOption('Tue', 'Tue'));
        options.add(new SelectOption('Wed', 'Wed'));
        options.add(new SelectOption('Thu', 'Thu'));
        options.add(new SelectOption('Fri', 'Fri'));
        options.add(new SelectOption('Sat', 'Sat'));
        options.add(new SelectOption('Sun', 'Sun'));
        return options;
    }

    public List<SelectOption> createHiatusTimeSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        options.add(new SelectOption('01:00A', '01:00A'));
        options.add(new SelectOption('01:30A', '01:30A'));
        options.add(new SelectOption('02:00A', '02:00A'));
        options.add(new SelectOption('02:30A', '02:30A'));
        options.add(new SelectOption('03:00A', '03:00A'));
        options.add(new SelectOption('03:30A', '03:30A'));
        options.add(new SelectOption('04:00A', '04:00A'));
        options.add(new SelectOption('04:30A', '04:30A'));
        options.add(new SelectOption('05:00A', '05:00A'));
        options.add(new SelectOption('05:30A', '05:30A'));
        options.add(new SelectOption('06:00A', '06:00A'));
        options.add(new SelectOption('06:30A', '06:30A'));
        options.add(new SelectOption('07:00A', '07:00A'));
        options.add(new SelectOption('07:30A', '07:30A'));
        options.add(new SelectOption('08:00A', '08:00A'));
        options.add(new SelectOption('08:30A', '08:30A'));
        options.add(new SelectOption('09:00A', '09:00A'));
        options.add(new SelectOption('09:30A', '09:30A'));
        options.add(new SelectOption('10:00A', '10:00A'));
        options.add(new SelectOption('10:30A', '10:30A'));
        options.add(new SelectOption('11:00A', '11:00A'));
        options.add(new SelectOption('11:30A', '11:30A'));
        options.add(new SelectOption('12:00P', '12:00P'));
        options.add(new SelectOption('12:30P', '12:30P'));
        options.add(new SelectOption('01:00P', '01:00P'));
        options.add(new SelectOption('01:30P', '01:30P'));
        options.add(new SelectOption('02:00P', '02:00P'));
        options.add(new SelectOption('02:30P', '02:30P'));
        options.add(new SelectOption('03:00P', '03:00P'));
        options.add(new SelectOption('03:30P', '03:30P'));
        options.add(new SelectOption('04:00P', '04:00P'));
        options.add(new SelectOption('04:30P', '04:30P'));
        options.add(new SelectOption('05:00P', '05:00P'));
        options.add(new SelectOption('05:30P', '05:30P'));
        options.add(new SelectOption('06:00P', '06:00P'));
        options.add(new SelectOption('06:30P', '06:30P'));
        options.add(new SelectOption('07:00P', '07:00P'));
        options.add(new SelectOption('07:30P', '07:30P'));
        options.add(new SelectOption('08:00P', '08:00P'));
        options.add(new SelectOption('08:30P', '08:30P'));
        options.add(new SelectOption('09:00P', '09:00P'));
        options.add(new SelectOption('09:30P', '09:30P'));
        options.add(new SelectOption('10:00P', '10:00P'));
        options.add(new SelectOption('10:30P', '10:30P'));
        options.add(new SelectOption('11:00P', '11:00P'));
        options.add(new SelectOption('11:30P', '11:30P'));
        options.add(new SelectOption('12:00A', '12:00A'));
        options.add(new SelectOption('12:30A', '12:30A'));
        return options;
    }
}