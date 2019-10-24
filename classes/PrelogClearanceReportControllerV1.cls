/** 
 *  Purpose         :   Controller class for PrelogClearanceReport
 *  
 *  Created By      :   Sanjay Ramchandani
 *  
 *  Created Date    :   --
 *  
 *  Revision Logs   :   V_1.0 - Created
 						V_1.1 - Modified for new changes 1/31/2016
 *  
 **/
public class PrelogClearanceReportControllerV1 {
	
    public List<String> testlist;
    public Set<String> testset;
    public List<List<SObject>> DealSearchList;
    public List<WeekModel> quarterweek {get;set;}
    public List<HeadingModel> headingModels {get;set;}
    public List<Date> quarterdates {get;set;}
    public List<Deal__c> DealResultList {get;set;}
    public List<DealWrapper> DealWrapperList {get;set;}
    public Set<Id> DealWrapperIdSet {get;set;}
    public List<String> SearchList;
    public String Searchfield {get;set;}
    public String DealId {get;set;}
    public String cellrate {get;set;}
    public String cellUnits {get;set;}
    public String CellId {get;set;}
    public String DealName {get;set;}
    public Decimal RateforCell {get;set;}
    public String SaveDescision {get;set;}
    public Boolean selectAll {get;set;}
    public Date anchordate;
    public Date startdate;
    public Date enddate;
    public Boolean schedulemessage {get;set;}
    public Boolean showtable {get;set;}
    public Deal__c SelectedDeal {get;set;}
    public Map<Id, Deal__c> SelectedDealMap {get;set;}
    public Date LowestDate {get;set;}
    public Date HighestDate {get;set;}
    public Date QuarterEndDate {get;set;}
    public String SelectedExtensionDate {get;set;}
    public String SelectedOrderLineNumber {get;set;}
    public String SelectedFiller {get;set;}
    public String RemoveDealId {get;set;}
    public String SelectedDealSet {get;set;}
    public Boolean BarterCheckbox {get;set;}
    public String SelectedCableSynd {get;set;}
    public List<SelectOption> CableSyndSOList {get;set;}
    
    public Schedules__c WeekStartDate {get;set;}
    public Schedules__c WeekEndDate {get;set;}
    public List<SelectOption> DateLiteralSOList {get;set;}
    public String SelectedDateLiteral {get;set;}
    public String SOQLDateString {get;set;}
    
    //Map to hold day of month with month name
    public Map<Integer, String> mapDayOfMonthWithName;
    
    //Added by Sanjay on 2/15/2016
    public Brands__c brand {get; set;}
    
    //Added by Sanjay on 2/18/2016
    public String prelogVersion {get; set;}
    
    //Added by Sanjay on 2/1/2016
    public Schedules__c tempSchedule {get; set;}
    
    public Map<String, FiscalYearSettings> FiscalMap = new Map<String, FiscalYearSettings>();
    public FiscalYearSettings CurrentFY;
    public Period CurrentFP;
    public Period CurrentFW;
    public Period CurrentFM;
    public Map<String, Map<Integer, Period>> QuarterPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> WeekPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> MonthPeriodMap = new Map<String, Map<Integer, Period>>();

    //Maps each selected deal Id to a map that maps each order line number to the prelog data.
    public Map<Id, Map<String, PrelogDataWrapper>> dealMap {get; set;}

    //Maps each selected deal Id to a list of grand totals.
    public Map<Id, Map<String, Decimal>> grandTotalMap {get; set;}
            
    public PrelogClearanceReportControllerV1()
    { 
        SaveDescision   ='';
        selectAll = false;
        DealWrapperList = new List<DealWrapper>();
        DealWrapperIdSet = new Set<Id>();
        SelectedDealSet = '';
        SelectedDealMap = new Map<Id, Deal__c>() ;
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
        
        //Initialization (By Sanjay)
        tempSchedule = new Schedules__c();
        mapDayOfMonthWithName = new Map<Integer, String>();
        brand = new Brands__c();
        prelogVersion = '';
        
        //Populate the map
        mapDayOfMonthWithName.put(1, 'Jan');
        mapDayOfMonthWithName.put(2, 'Feb');
        mapDayOfMonthWithName.put(3, 'Mar');
        mapDayOfMonthWithName.put(4, 'Apr');
        mapDayOfMonthWithName.put(5, 'May');
        mapDayOfMonthWithName.put(6, 'Jun');
        mapDayOfMonthWithName.put(7, 'Jul');
        mapDayOfMonthWithName.put(8, 'Aug');
        mapDayOfMonthWithName.put(9, 'Sep');
        mapDayOfMonthWithName.put(10, 'Oct');
        mapDayOfMonthWithName.put(11, 'Nov');
        mapDayOfMonthWithName.put(12, 'Dec');
        
        //Set current week in the week
        tempSchedule.Week__c = Date.today().toStartOfWeek().addDays(1);

        List<FiscalYearSettings> fysList = [
                SELECT Id,
                       Name,
                       StartDate,
                       EndDate
                  FROM FiscalYearSettings
        ];
        for (FiscalYearSettings FYS : fysList)
        {
            FiscalMap.put(FYS.Name, FYS);
            System.debug('CurrentFY Compare - ' + FYS.StartDate + ' - ' + FYS.EndDate + ' - ' + Date.today() + ' - ' + (FYS.StartDate <= Date.today() && FYS.EndDate >= Date.today()));
            if (FYS.StartDate <= Date.today() && FYS.EndDate >= Date.today())
            {
                CurrentFY = FYS;
                System.debug('CurrentFY - ' + CurrentFY.StartDate + ' - ' + CurrentFY.EndDate);
            }
        }

        List<Period> qpm = [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number
                  FROM Period
                 WHERE Type = 'Quarter'
        ];
        for (Period PR : qpm)
        {
            if (PR.StartDate <= Date.today() && PR.EndDate >= Date.today())
            {
                CurrentFP = PR;
                System.debug('CurrentFP - ' + CurrentFP.StartDate + ' - ' + CurrentFP.EndDate);
            }
            if (QuarterPeriodMap.containsKey(PR.FiscalYearSettings.Name))
            {
                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(PR.FiscalYearSettings.Name);
                TempQuarterPeriodMap.put(PR.Number, PR);
                QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
            else
            {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                TempQuarterPeriodMap.put(PR.Number, PR);
                QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }

        List<Period> wpm = [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number
                  FROM Period
                 WHERE Type = 'Week'
        ];
        for (Period PR : wpm)
        {
            if (PR.StartDate <= Date.today() && PR.EndDate >= Date.today())
            {
                CurrentFW = PR;
                System.debug('CurrentFW - ' + CurrentFW.StartDate + ' - ' + CurrentFW.EndDate);
            }
            if (WeekPeriodMap.containsKey(PR.FiscalYearSettings.Name))
            {
                Map<Integer, Period> TempQuarterPeriodMap = WeekPeriodMap.get(PR.FiscalYearSettings.Name);
                TempQuarterPeriodMap.put(PR.Number, PR);
                WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
            else
            {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                TempQuarterPeriodMap.put(PR.Number, PR);
                WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }

        List<Period> mpm = [
                SELECT Id,
                       FiscalYearSettings.Name,
                       StartDate,
                       EndDate,
                       Number,
                       PeriodLabel
                  FROM Period
                 WHERE Type = 'Month'
        ];
        for (Period PR : mpm)
        {
            if (PR.StartDate <= Date.today() && PR.EndDate >= Date.today())
            {
                CurrentFM = PR;
                System.debug('CurrentFM - ' + CurrentFM.StartDate + ' - ' + CurrentFM.EndDate);
            }
            if (MonthPeriodMap.containsKey(PR.FiscalYearSettings.Name))
            {
                Map<Integer, Period> TempQuarterPeriodMap = MonthPeriodMap.get(PR.FiscalYearSettings.Name);
                if (PR.Number == null)
                {
                    TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                }
                else
                {
                    TempQuarterPeriodMap.put(PR.Number, PR);
                }
                MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
            else
            {
                Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                if (PR.Number == null)
                {
                    TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
                }
                else
                {
                    TempQuarterPeriodMap.put(PR.Number, PR);
                }
                MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
            }
        }
        
    }

    public void ReturnSOQLDateString()
    {
        try
        {
            if (SelectedDateLiteral == null || SelectedDateLiteral == '')
            {
                SOQLDateString = '';
            }
            else
            {
                if (SelectedDateLiteral == 'Custom')
                {
                    if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null)
                    {
                        SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
                    }
                    else
                    {
                        SOQLDateString = '';
                    }
                }
                else if (SelectedDateLiteral == 'Previous FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_YEAR ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Previous 2 FY')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = LAST_FISCAL_YEAR ) ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.Day__c = FYS2.StartDate;
                            WeekEndDate.Day__c = FYS1.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == '2 FY Ago')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Day__c = FYS1.StartDate;
                            WeekEndDate.Day__c = FYS2.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous 2 FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Day__c = FYS1.StartDate;
                            WeekEndDate.Day__c = FYS2.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current FQ')
                {
                    if (CurrentFP != null)
                    {
                        WeekStartDate.Day__c = CurrentFP.StartDate;
                        WeekEndDate.Day__c = CurrentFP.EndDate;
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 4)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFP.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFP.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Next FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 4)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Previous FQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_QUARTER ';
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next 3 FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name)))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number - 1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Last FP')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_PERIOD ';
                    if (CurrentFM != null)
                    {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 1)
                        {
                            if (MonthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12))
                                {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MonthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'This FP')
                {
                    if (CurrentFM != null)
                    {
                        WeekStartDate.Day__c = CurrentFM.StartDate;
                        WeekEndDate.Day__c = CurrentFM.EndDate;
                    }   
                }
                else if (SelectedDateLiteral == 'Next FP')
                {
                    if (CurrentFM != null)
                    {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 12)
                        {
                            if (MonthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MonthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Current And Previous FP')
                {
                    if (CurrentFM != null)
                    {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 1)
                        {
                            if (MonthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12))
                                {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFM.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MonthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFM.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Current And Next FP')
                {
                    if (CurrentFM != null)
                    {
                        Integer NumberMonth;
                        if (CurrentFM.Number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 12)
                        {
                            if (MonthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = CurrentFM.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MonthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Day__c = CurrentFM.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Last FW')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    if (CurrentFW != null)
                    {
                        if (CurrentFW.Number == 1)
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(53))
                                {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                                else if (TempPeriodMap.containsKey(52))
                                {
                                    Period TempPeriod = TempPeriodMap.get(52);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(CurrentFW.Number - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'This FW')
                {
                    if (CurrentFW != null)
                    {
                        WeekStartDate.Day__c = CurrentFW.StartDate;
                        WeekEndDate.Day__c = CurrentFW.EndDate;
                    }
                }
                else if (SelectedDateLiteral == 'Next FW')
                {
                    if (CurrentFW != null)
                    {
                        if (CurrentFW.Number == 53)
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else if (CurrentFW.Number == 52)
                        {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(53))
                                {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                                else
                                {
                                    if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1)))
                                    {
                                        Map<Integer, Period> TempPeriodMap1 = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                        if (TempPeriodMap1.containsKey(1))
                                        {
                                            Period TempPeriod = TempPeriodMap1.get(1);
                                            WeekStartDate.Day__c = TempPeriod.StartDate;
                                            WeekEndDate.Day__c = TempPeriod.EndDate;
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name))))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)));
                                if (TempPeriodMap.containsKey(CurrentFW.Number + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current CY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_YEAR ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year(), 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12,31);
                }
                else if (SelectedDateLiteral == 'Previous CY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_YEAR ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() - 1, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year() - 1, 12,31);
                }
                else if (SelectedDateLiteral == 'Previous 2 CY')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 ) ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() - 2, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year() -1, 12,31);
                }
                else if (SelectedDateLiteral == '2 CY Ago')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() - 2, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year() -2, 12,31);
                }
                else if (SelectedDateLiteral == 'Next CY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_YEAR ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() +1, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year() +1, 12,31);
                }
                else if (SelectedDateLiteral == 'Current And Previous CY')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() -1, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12,31);
                }
                else if (SelectedDateLiteral == 'Current And Previous 2 CY')
                {
                    SOQLDateString = ' AND  ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() -2, 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12,31);
                }
                else if (SelectedDateLiteral == 'Current And Next CY')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = NEXT_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
                    WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                    WeekEndDate.Day__c = Date.newInstance(Date.today().year() + 1, 12,31);
                }
                else if (SelectedDateLiteral == 'Current CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 3, 31);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 6, 30);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 9, 30);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12, 31);
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_QUARTER ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 6, 30);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 9, 30);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12, 31);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() + 1, 3, 31);
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = LAST_QUARTER ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 3, 31);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 6, 31);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 9, 30);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() , 12, 31);
                    }
                }
                else if (SelectedDateLiteral == 'Next CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 6, 30);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 9, 30);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 12, 31);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() + 1 , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() , 3, 31);
                    }
                }
                else if (SelectedDateLiteral == 'Previous CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_QUARTER ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() -1, 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() - 1, 12, 31);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 3, 31);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year(), 6, 30);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year()  , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() , 9, 30);
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next 3 CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_N_QUARTERS:3 ) ';
                    if (Date.today().month() >=1 && Date.today().month() <= 3)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 1, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() , 12, 31);
                    }
                    else if (Date.today().month() >=4 && Date.today().month() <= 6)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 4, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year()+ 1, 3, 31);
                    }
                    else if (Date.today().month() >=7 && Date.today().month() <= 9)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year() , 7, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() + 1, 6, 30);
                    }
                    else if (Date.today().month() >=10 && Date.today().month() <= 12)
                    {
                        WeekStartDate.Day__c = Date.newInstance(Date.today().year()  , 10, 1);
                        WeekEndDate.Day__c = Date.newInstance(Date.today().year() + 1 , 9, 30);
                    }
                }
                else if (SelectedDateLiteral == 'Last Month')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_MONTH ';
                    WeekStartDate.Day__c = Date.today().addMonths(-1).toStartOfMonth();
                    WeekEndDate.Day__c = Date.today().toStartOfMonth().addDays(-1);
                }
                else if (SelectedDateLiteral == 'This Month')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_MONTH ';
                    WeekStartDate.Day__c = Date.today().toStartOfMonth();
                    WeekEndDate.Day__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1);
                }
                else if (SelectedDateLiteral == 'Next Month')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_MONTH ';
                    WeekStartDate.Day__c = Date.today().addMonths(1).toStartOfMonth();
                    WeekEndDate.Day__c = Date.today().addMonths(2).toStartOfMonth().addDays(-1);
                }
                else if (SelectedDateLiteral == 'Current And Last Month')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = LAST_MONTH ) ';
                    WeekStartDate.Day__c = Date.today().addMonths(-1).toStartOfMonth();
                    WeekEndDate.Day__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1);
                }
                else if (SelectedDateLiteral == 'Current And Next Month')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = NEXT_MONTH ) ';
                    WeekStartDate.Day__c = Date.today().toStartOfMonth();
                    WeekEndDate.Day__c = Date.today().addMonths(2).toStartOfMonth().addDays(-1);
                }
                else if (SelectedDateLiteral == 'Last Week')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    WeekStartDate.Day__c = Date.today().toStartOfWeek().addDays(-7);
                    WeekEndDate.Day__c = Date.today().toStartOfWeek().addDays(-1);
                }
                else if (SelectedDateLiteral == 'This Week')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_WEEK ';
                    WeekStartDate.Day__c = Date.today().toStartOfWeek();
                    WeekEndDate.Day__c = Date.today().toStartOfWeek().addDays(6);
                }
                else if (SelectedDateLiteral == 'Next Week')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_WEEK ';
                    WeekStartDate.Day__c = Date.today().addDays(7).toStartOfWeek();
                    WeekEndDate.Day__c = Date.today().addDays(7).toStartOfWeek().addDays(6);
                }
                else if (SelectedDateLiteral == 'Yesterday')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = YESTERDAY ';
                    WeekStartDate.Day__c = Date.today().addDays(-1);
                    WeekEndDate.Day__c = Date.today().addDays(-1);
                }
                else if (SelectedDateLiteral == 'Today')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = TODAY ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Tomorrow')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = TOMORROW ';
                    WeekStartDate.Day__c = Date.today().addDays(1);
                    WeekEndDate.Day__c = Date.today().addDays(1);
                }
                else if (SelectedDateLiteral == 'Last 7 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:7 ';
                    WeekStartDate.Day__c = Date.today().addDays(-7);
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Last 30 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:30 ';
                    WeekStartDate.Day__c = Date.today().addDays(-30);
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Last 60 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:60 ';
                    WeekStartDate.Day__c = Date.today().addDays(-60);
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Last 90 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:90 ';
                    WeekStartDate.Day__c = Date.today().addDays(-90);
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Last 120 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:120 ';
                    WeekStartDate.Day__c = Date.today().addDays(-120);
                    WeekEndDate.Day__c = Date.today();
                }
                else if (SelectedDateLiteral == 'Next 7 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:7 ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today().addDays(7);
                }
                else if (SelectedDateLiteral == 'Next 30 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:30 ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today().addDays(30);
                }
                else if (SelectedDateLiteral == 'Next 60 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:60 ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today().addDays(60);
                }
                else if (SelectedDateLiteral == 'Next 90 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:90 ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today().addDays(90);
                }
                else if (SelectedDateLiteral == 'Next 120 Days')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:120 ';
                    WeekStartDate.Day__c = Date.today();
                    WeekEndDate.Day__c = Date.today().addDays(120);
                }
            }
            if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null)
            {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
            }
            else
            {
                SOQLDateString = '';
            }
            System.debug('Start And End Dates - ' + WeekStartDate.Day__c + ' - ' + WeekEndDate.Day__c);
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }  
    }

    public void DoSearch()
    {
        try
        {
            DealResultList = new List<Deal__c>();
            	
            SearchList = new List<String>();
            Map<Id,Deal__c> MapofFinalDeals = new Map<Id,Deal__c>();
            Map<Integer,Set<Id>> Accurancy = new Map<Integer, Set<Id>>();
            ReturnSOQLDateString();
            if(Searchfield != null && Searchfield  !='')
            {
                //searchField = SearchField.replace(' , ',',').replace(' ,',',').replace(', ',',');
                while (Searchfield.contains(' , '))
                {
                    Searchfield = Searchfield.replace(' , ',',');
                }
                while (Searchfield.contains(' ,'))
                {
                    Searchfield = Searchfield.replace(' ,',',');
                }
                while (Searchfield.contains(', '))
                {
                    Searchfield = Searchfield.replace(', ',',');
                }
                String tempSearch = '%'+Searchfield +'%';
                SearchList = Searchfield.split(',');
                Accurancy.put( 1 ,new Set<Id>{} );
                if (SearchList.size() > 1)
                {
                    for(String stringListLoop : SearchList)
                    {
                        while(stringListLoop.startsWith(' ') || stringListLoop.endsWith(' '))
                        {
                            if (stringListLoop.startsWith(' '))
                            {
                                stringListLoop = stringListLoop.substringAfter(' ');
                            }
                            if (stringListLoop.endsWith(' '))
                            {
                                stringListLoop = stringListLoop.substringBeforeLast(' ');
                            }
                        }
                        String tempstringListLoop = '%'+stringListLoop+'%';
                        Set<Deal__c> tempDealList = new Set<Deal__c>();
                        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,' 
                                                + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                                                + 'Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') '
                                                + ' From Deal__c '
                                                + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                                                + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null '
                                                + SOQLDateString;
                        if (BarterCheckbox)
                        {
                            DealQuery += ' AND Program__r.Barter__c = True ';
                        }                       
                        if (SelectedCableSynd != '' && SelectedCableSynd != null)
                        {
                            DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                        }
                        
                        //Added by Sanjay 2/15/2016
                        if (brand.Advertiser__c != null) {
                            DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                        }
                        
                        //Add Order by clause
                        DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 1000';
                                            
                        System.debug('***DealQuery - ' + DealQuery);
                        List<Deal__c> DealList = Database.query(DealQuery);
                        for(Deal__c dlist : DealList )
                        {
                            System.debug('tempStringListLoop - ' + tempstringListLoop + ' - ' + dlist.Name + ' - ' + dlist.Program__r.Name + ' - ' + dlist.Contact__r.Name + ' - ' + dlist.Client_Account__r.Name + ' - ' + dlist.Brands__r.Name);
                            Boolean NotInList = false;
                            MapofFinalDeals.put( dlist.Id , dlist);
                            for(Integer i = Accurancy.size(); i>0; i--)
                            {
                                if(Accurancy.get(i).contains(dlist.Id))
                                {
                                    NotInList = true;
                                    if(Accurancy.containsKey(i+1))
                                    {
                                        Set<Id> dealset1 = Accurancy.get(i+1);
                                        dealset1.add(dlist.Id);
                                        Accurancy.put(i+1, dealset1); 
                                    }
                                    else
                                    {
                                        Set<Id> dealset1 = new Set<Id>();
                                        dealset1.add(dlist.Id);
                                        Accurancy.put(i+1, dealset1);     
                                    }
                                    Accurancy.get(i).remove(dlist.Id);
                                }
                            } 
                            if(NotInList == false)
                            {
                                Set<Id> dealset1 = Accurancy.get(1);
                                dealset1.add(dlist.Id);
                                Accurancy.put(1, dealset1);     
                            }
                        } 
                    }
                    for (Integer Count : Accurancy.keySet())
                    {
                        System.debug('Accurancy Count - ' + Count + ' - ' + Accurancy.get(Count));
                    }   
                    Integer count=0;

                    if (Accurancy.containsKey(SearchList.size()))
                    {
                        for(Id MapofDeals : Accurancy.get(SearchList.size()))
                        {
                            if (count < 200)
                            {
                                DealResultList.add(MapofFinalDeals.get(MapofDeals));
                                count++;
                            }       
                        }  
                    }   
                }
                else
                {
                    String tempstringListLoop = '%'+SearchList[0] +'%';
                    String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                                            + ' Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                                            + ' Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') ' 
                                            + ' From Deal__c '
                                            + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\'' 
                                            + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\'' 
                                            + ' OR Name Like \'' + tempstringListLoop + '\' )  AND Week_MIN_Field__c != null '
                                            + SOQLDateString;
                    if (BarterCheckbox)
                    {
                        DealQuery += ' AND Program__r.Barter__c = True ';
                    }                       
                    if (SelectedCableSynd != '' && SelectedCableSynd != null)
                    {
                        DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                    }
                    
                    //Added by Sanjay 2/15/2016
                    if (brand.Advertiser__c != null) {
                        DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                    }
                    
                    DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 200';                        
                    System.debug('***DealQuery - ' + DealQuery);
                    List<Deal__c> DealList = Database.query(DealQuery);
                    for(Deal__c dlist : DealList)
                    {
                        DealResultList.add(dlist);
                    }   
                }
            }	
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Search field can not be null'  ));
            }
            
            System.debug('######### this monday' + this.getMonday() + ' %%%%% this sunday' + this.getSunday());
            
            Map<Id, List<PrelogData__c>> scheduleMap = new Map<Id, List<PrelogData__c>>();
            
            //** Modified the Query by Sanjay *//
            Date currentMonday = tempSchedule.Week__c;
            Date currentSunday = tempSchedule.Week__c.addDays(6);
            
            //String to hold soql string
            String sOQLString = 'SELECT Id, Schedule__r.Deal_Parent__c, Schedule__c, Schedule__r.Id, Schedule__r.Name,'
            					 + 'Schedule__r.Cap__c FROM PrelogData__c WHERE Schedule__r.Deal_Parent__c IN: DealResultList '
            					 + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday';
            
            //Check for version
            if(String.isNotBlank(prelogVersion)) {
            	Integer tempInt = Integer.valueOf(prelogVersion);
            	sOQLString += ' AND Version__c =: tempInt';
            }
            else {
            	sOQLString += ' AND Current_Version__c = true';
            }
            
            System.debug('#### Query::  ' + sOQLString);
            
            for(PrelogData__c p: Database.query(sOQLString)) {
                if(scheduleMap.containsKey(p.Schedule__r.Deal_Parent__c)) {
                    scheduleMap.get(p.Schedule__r.Deal_Parent__c).add(p) ;
                } else {
                    List<PrelogData__c> tmpPrelogList = new List<PrelogData__c>() ;
                    tmpPrelogList.add(p) ;
                    scheduleMap.put(p.Schedule__r.Deal_Parent__c, tmpPrelogList) ;
                }
            }
            System.debug('***scheduleMap: after ' + scheduleMap) ;
            Integer i = 0;

            System.debug('***DealResultList: after ' + DealResultList) ;

            if (DealResultList.size() == 0 && Searchfield != null && Searchfield  !='' )
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'The Search did not return any results'));
            } 
            DealId =''; 
            DealName=''; 
            cellrate =''; 
            CellId =''; 
            showtable = false; 
            schedulemessage = false;
            SortDealResultList();
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }     
    }

    public void ClearAllButton()
    {
        try
        {
            DealWrapperList = new List<DealWrapper>();
            DealWrapperIdSet = new Set<Id>();
            SelectedDealSet = '';
            SelectedDealMap.clear() ;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }   
    }

    public void SortDealResultList()
    {
        try
        {
            Map<Date, List<Deal__c>> DealDateList = new Map<Date, List<Deal__c>>();
            Set<Date> DateList = new Set<Date>();
            List<Deal__c> NoDateList = new List<Deal__c>();
            for (Deal__c DR : DealResultList)
            {
                if (DR.Week_MIN_Field__c != null)
                {
                    DateList.add(DR.Week_MIN_Field__c);
                    if (DealDateList.containsKey(DR.Week_MIN_Field__c))
                    {
                        List<Deal__c> DealL = DealDateList.get(DR.Week_MIN_Field__c);
                        DealL.add(DR);
                        DealDateList.put(DR.Week_MIN_Field__c, DealL);
                    }
                    else
                    {
                        List<Deal__c> DealL = new List<Deal__c>();
                        DealL.add(DR);
                        DealDateList.put(DR.Week_MIN_Field__c, DealL);
                    }
                }
                else
                {
                    NoDateList.add(DR);
                }
            }
            List<Date> DateSortList = new List<Date>();
            for (Date DS : DateList)
            {
                DateSortList.add(DS);
            }
            DateSortList.sort();
            DealResultList.clear();
            for (Integer i = DateSortList.size()-1 ; i >=0 ; i-- )
            {
                if (DealDateList.containsKey(DateSortList[i]))
                {
                    DealResultList.addAll(DealDateList.get(DateSortList[i]));
                }
            }
            DealResultList.addAll(NoDateList);
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        } 
    }

    public void RemoveDealButton()
    {
        try
        {
            if (RemoveDealId != null)
            {
                List<DealWrapper> TempDealWrapper = new List<DealWrapper>();
                TempDealWrapper.addAll(DealWrapperList);
                DealWrapperList = new List<DealWrapper>();
                DealWrapperIdSet = new Set<Id>();
                SelectedDealSet = '';
                SelectedDealMap.remove(RemoveDealId) ;
                for (DealWrapper DW : TempDealWrapper)
                {
                    if (DW.DealRecord.Id != Id.valueOf(RemoveDealId))
                    {
                    	//Logic for format the prelog date time in local time zone
                    	String weekDay = DW.DealRecord.Program__r.Prelog_Date_Time__c.format('EEEE').left(3);
                    	String monthOfYear = mapDayOfMonthWithName.get(DW.DealRecord.Program__r.Prelog_Date_Time__c.month());
                    	String dayString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.day());
                    	String hourString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.hour());
                    	String minuteString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.minute());
                    	
                    	//Prepare final string
                    	DW.prelogDateTime = weekDay + ' ' + monthOfYear + ' ' + dayString + ' ' + hourString + ':' + minuteString + ' EST';
                    	
                        DealWrapperList.add(DW);
                        DealWrapperIdSet.add(DW.DealRecord.Id);
                        SelectedDealSet += DW.DealRecord.Id;
                    }
                }
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }  
    }

    public void AddMoreToDeal()
    {
        try
        {
            if (DealWrapperList.size() > 3)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'More than 4 Deals cannot be viewed at the same time'));
            }
            else if (!DealWrapperIdSet.contains(DealId))
            {
                testlist= new List<String>();
                testset = new Set<String>();
                List<LineItemModel> ratelist = new List<LineItemModel>();
                Map<String,List<Schedules__c>> schgroup = new Map<String,List<Schedules__c>>();
                Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();
                LowestDate = Date.newInstance(3000,1,1);
                HighestDate = Date.newInstance(1000,1,1);
                
                for (Schedules__c schlist : Database.query('Select ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c') + ', Deal_Parent__r.Week_MIN_Field__c from Schedules__c where Deal_Parent__c = \'' + DealId + '\' ORDER BY MilitaryTime__c, Rate__c' ))
                {
                    if (LowestDate > schlist.Week__c)
                    {
                        LowestDate = schlist.Week__c;
                    }
                    if (HighestDate < schlist.Week__c)
                    {
                        HighestDate = schlist.Week__c;
                    }
                    if(schlist.OrderNumber__c != null)
                    {
                        if(!testset.contains(schlist.OrderNumber__c))
                        {
                            testlist.add(schlist.OrderNumber__c);
                            testset.add(schlist.OrderNumber__c);
                        }
                        if(schgroup.containsKey(schlist.OrderNumber__c))
                        {
                            List<Schedules__c> temp = schgroup.get(schlist.OrderNumber__c); 
                            temp.add(schlist); 
                            schgroup.put(schlist.OrderNumber__c,temp);      
                        }
                        else
                        {
                            List<Schedules__c> temp = new List<Schedules__c>(); 
                            temp.add(schlist); 
                            schgroup.put(schlist.OrderNumber__c,temp);      
                        }
                    }
                    System.debug('***AddMoreToDeal: schlist: ' + schlist) ;
                }
                System.debug('***AddMoreToDeal: testlist: ' + testlist) ;
                System.debug('***AddMoreToDeal: testset: ' + testset) ;
                System.debug('***AddMoreToDeal: schgroup: ' + schgroup) ;
                
                //Modified the query by Sanjay 2/3/2016 //
                
                //Check for null
                if (tempSchedule.Week__c == null) {
                    tempSchedule.Week__c = Date.today().toStartOfWeek().addDays(1);
                }
                
                List<Deal__c> DealList = [
                        SELECT Id,
                               Name,
                               Contact__c,
                               ContactAccount__c,
                               Campaign__c,
                               Contact__r.Name,
                               Contact__r.AccountId,
                               Contact__r.Account.Name,
                               Sum_of_Total_Dollars__c,
                               Sum_of_Units_Available__c,
                               Program__c,
                               Program__r.Prelog_Date_Time__c,
                               Program__r.Name,
                               Program__r.Reconciled_Week__c,
                               Brands__c,
                               Brands__r.Name,
                               Week_MIN_Field__c,
                               Length__c,
                               SF_Deal_ID__c,
                               Advertiser_ID__c,
                               Advertiser__c, (
                                   SELECT Name,
                                          Deal_Parent__r.Brands__r.Name,
                                          OrderLineNumber__c,
                                          Days_Allowed_Formula__c,
                                          Start_Time__c,
                                          Days_Allowed__c,
                                          End_Time__c,
                                          Rate__c,
                                          MGM_HD_Daypart__c,
                                          Total_Dollars__c,
                                          Units_Available__c,
                                          Units_Aired__c,
                                          Cap__c,
                                          LastModifiedDate
                                     FROM Schedules__r
                                    WHERE Status__c = 'Sold'
                                      AND Week__c =: tempSchedule.Week__c
                               )
                          FROM Deal__c
                         WHERE Id =: DealId
                ];

                if (DealList.size() > 0)
                {
                    ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c);
                    SelectedDeal = DealList[0];
                }
                System.debug('Final Lowest Date - ' + LowestDate);

                Decimal TotalUnitsAired = 0;
                Decimal TotalUnitsAvailable = 0;
                Decimal TotalDollars = 0;
                Decimal TotalDollarsBooked = 0;
                for(String mapkeylist : testlist )
                {
                    List<Schedules__c> tempwraplist = schgroup.get(mapkeylist); 
                    LineItemModel Lm = new LineItemModel();
                    Lm.OrderLineNumber = mapkeylist;
                    if(tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null)
                    {
                        Lm.rate = tempwraplist[0].Rate__c;
                    }
                    else
                    {
                        Lm.rate = 0;  
                    }
                    Lm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                    Lm.SETime = tempwraplist[0].Start_End_Time__c;
                    Lm.UnitLength = tempwraplist[0].UnitLength__c;
                    Date RMLowestDate = Date.newInstance(3000,1,1);
                    Date RMHighestDate = Date.newInstance(1000,1,1);
                    for(Schedules__c sch :tempwraplist)
                    {
                        if (RMLowestDate > sch.Week__c)
                        {
                            RMLowestDate = sch.Week__c;
                        }
                        if (RMHighestDate < sch.Week__c)
                        {
                            RMHighestDate = sch.Week__c;
                        }
                        if(sch.Week__c >= Date.today().toStartOfWeek().addDays(1) )
                        {
                            if(sch.Filler__c == true)
                            {
                                Lm.Filler = true;
                            }   
                        } 
                        if (sch.Reconciled__c == 'Y')
                        {
                            if (sch.Status__c != 'Canceled')
                            {
                                TotalUnitsAired += (sch.Units_Aired__c == null ? 0 : sch.Units_Aired__c );
                                TotalUnitsAvailable += (sch.Units_Available__c == null ? 0 : sch.Units_Available__c );
                            }
                        
                            TotalDollars += (sch.Total_Dollars__c == null ? 0 : sch.Total_Dollars__c);
                            TotalDollarsBooked += (sch.Dollars_Booked__c == null ? 0 : sch.Dollars_Booked__c);
                        }
                    }
                    Lm.LowestDate = RMLowestDate;
                    Lm.HighestDate = RMHighestDate;
                    Map<Date,Schedules__c> weekMap = new Map<Date,Schedules__c>(); 
                    Map<Date, Boolean> DuplicateWeekMap = new Map<Date, Boolean>();
                    for(Schedules__c schtemp : tempwraplist )
                    {
                        if (weekMap.containsKey(schtemp.Week__c))
                        {
                            DuplicateWeekMap.put(schtemp.Week__c, true);
                        }   
                        weekMap.put(schtemp.Week__c, schtemp);
                        if (WeekDollarsMap.containsKey(schtemp.Week__c))
                        {
                            Decimal WeekDollars = WeekDollarsMap.get(schtemp.Week__c);
                            WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                            WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        }
                        else
                        {
                            Decimal WeekDollars = 0;
                            WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                            WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        }
                    } 
                    for(Date sow: quarterdates)
                    {
                        if (sow != null)
                        {
                            if (sow >= LowestDate)
                            {
                                if(weekMap.containsKey(sow))
                                {
                                    if (DuplicateWeekMap.containsKey(sow))
                                    {
                                        Lm.weeks.add(new weekModel(sow,weekMap.get(sow), true));
                                    }
                                    else
                                    {
                                        Lm.weeks.add(new weekModel(sow,weekMap.get(sow), false));
                                    }
                                }
                                else
                                {
                                    Lm.weeks.add(new weekmodel(sow,tempwraplist[0].OrderNumber__c));
                                }
                            }
                        }
                    }
                    ratelist.add(Lm);
                    //Display();
                }
                DealWrapper DW = new DealWrapper();
                DW.DealRecord = SelectedDeal;
                DW.HeadingList = ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c); 
                List<String> TempWeekDollarsList = new List<String>();
                for (HeadingModel HM : DW.HeadingList)
                {
                    if (WeekDollarsMap.containsKey(HM.startOfWeek))
                    {
                        Decimal DollarAmount = WeekDollarsMap.get(HM.startOfWeek);
                        String StringAmount;
                        if (DollarAmount < 1000)
                        {
                            StringAmount =  '$' + String.valueOf(DollarAmount);
                            StringAmount = StringAmount.replace('.00','');
                        }
                        else
                        {
                            DollarAmount = DollarAmount.setScale(0);
                            DollarAmount = DollarAmount/1000.0;
                            DollarAmount = DollarAmount.setScale(1);
                            StringAmount =  '$' + String.valueOf(DollarAmount);
                            StringAmount = StringAmount.replace('.0','') + 'K';
                        }
                        TempWeekDollarsList.add(StringAmount);
                    }
                    else
                    {
                        TempWeekDollarsList.add('$0');
                    }
                }
                DW.WeekDollarsList = TempWeekDollarsList;
                DW.LineItemModelList = ratelist;
                DW.UnitsAired = TotalUnitsAired;
                DW.UnitsAvailable = TotalUnitsAvailable;
                DW.WeekDollarsMap = WeekDollarsMap;
                DW.ClearancePercentage = (DW.UnitsAvailable == 0 ? 0 : ( DW.UnitsAired / DW.UnitsAvailable * 100.0).intValue());
                DW.TotalDollars = TotalDollars;
                DW.TotalDollarsBooked = TotalDollarsBooked;
                DW.DollarClearancePercentage = (DW.TotalDollarsBooked == 0 ? 0 : (DW.TotalDollars / DW.TotalDollarsBooked * 100.0).intValue());
                
                //Logic for format the prelog date time in local time zone
            	String weekDay = DW
                        .DealRecord
                        .Program__r
                        .Prelog_Date_Time__c.format('EEEE').left(3);
            	String monthOfYear = mapDayOfMonthWithName.get(DW.DealRecord.Program__r.Prelog_Date_Time__c.month());
            	String dayString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.day());
            	String hourString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.hour());
            	String minuteString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.minute());
            	
            	//Prepare final string
            	DW.prelogDateTime = weekDay + ' ' + monthOfYear + ' ' + dayString + ' ' + hourString + ':' + minuteString + ' EST';
                    	
                DealWrapperList.add(DW);
                DealWrapperIdSet.add(SelectedDeal.Id);
                SelectedDealSet += SelectedDeal.Id;
                SelectedDealMap.put(SelectedDeal.Id, SelectedDeal) ;
                
                //Logic For Sort the Wrapper list so that newly searched record coming at the very first row in the table
                List<DealWrapper> tempDealWrapper = new List<DealWrapper>();
                
                //Loop through the wrapper
                for (Integer j = DealWrapperList.size() - 1; j >= 0; j--) {
                    tempDealWrapper.add(DealWrapperList[j]);
                }
                
                System.debug('#########' + tempDealWrapper);
                
                //Re-populate the wrapper
                DealWrapperList = tempDealWrapper;
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }  
    }

    public void Display()
    {
        showtable = true;
        schedulemessage = false;
    }

    public List<HeadingModel> ListOfDates(Date pAnchorDate, Date pReconciledDate)
    {
        try
        {
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
            
            if (HighestDate > EndOfQuarter)
            {
                EndOfQuarter = HighestDate;
            }
            if (AnchorDate > EndOfQuarter)
            {
                ListOfDates(AnchorDate.addDays(7),pReconciledDate);
            }
            quarterdates = new List<Date>();
            while (StartOfQuarter <= EndOfQuarter)
            {
                quarterdates.add(StartOfQuarter);
                enddate = StartOfQuarter;
                StartOfQuarter = StartOfQuarter.addDays(7);
            }
            //quarterdates.add(enddate); 
            headingModels  = new List<HeadingModel>();
            quarterweek = new List<WeekModel>();
            for(Date sow: quarterdates)
            {
                if (sow != null)
                {
                    HeadingModel hm = new HeadingModel();
                    hm.startOfWeek = sow;
                    if (pReconciledDate >= sow)
                    {
                        hm.bgcolor = '#848484';
                    }
                    else
                    {
                        hm.bgcolor = '#86BCFF';
                    }
                    System.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (sow >= LowestDate));
                    if (sow >= LowestDate)
                    {
                        headingModels.add(hm);
                    }
                }
            }
            return headingModels;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Message: ' + e.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'TypeName: ' + e.getTypeName()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Stack Trace: ' + e.getStackTraceString()));
        }
        return null;
    }
   
    public class DealWrapper
    {
        public Deal__c DealRecord {get;set;}
        public List<HeadingModel> HeadingList {get;set;}
        public List<LineItemModel> LineItemModelList {get;set;}
        public Decimal UnitsAired {get;set;}
        public Decimal UnitsAvailable {get;set;}
        public Integer ClearancePercentage {get;set;}
        public Decimal TotalDollars {get;set;}
        public Decimal TotalDollarsBooked {get;set;}
        public Integer DollarClearancePercentage {get;set;}
        public Map<Date, Decimal> WeekDollarsMap {get;set;}
        public List<String> WeekDollarsList {get;set;}
        
        //String to hold prelog date time
        public String prelogDateTime {get; set;}
    }

    public class HeadingModel
    {
        public String cols{get;set;}
        public String bgcolor {get;set;}
        public Date startOfWeek {get;set;} 
    }

    public class LineItemModel 
    {
        public Boolean isChecked {get;set;}
        public Decimal rate {set;get;}
        public String OrderLineNumber {get;set;}
        public String DaysAllowed {get;set;}
        public String SETime {get;set;}
        public Decimal UnitLength  {get;set;}
        public List<WeekModel> weeks {get;set;}
        public Boolean Filler {get;set;}
        public Decimal changerate {get;set;}
        public Schedules__c Scheduleobj {get;set;}
        public Date DayValue {get;set;}
        public Date LowestDate {get;set;}
        public Date HighestDate {get;set;}
        public String UnitsAvailable {get;set;}
        public LineItemModel()
        {
            isChecked = false;
            weeks = new List<WeekModel>();
            Scheduleobj = new Schedules__c();
            UnitsAvailable = '0'; 
            
        }
    }

    public class WeekModel 
    {
        public Date startOfWeek {get;set;}
        public Schedules__c schObj{get;set;}
        public String color {get;set;}
        public Decimal changerate {get;set;}
        public Boolean CellAvailable {get;set;}
        public Boolean ExtensionAvailable {get;set;}
        public String OrderLineNumber {get;set;}
        public String ExtensionDate {get;set;}
        public Boolean MultipleSchedules {get;set;}
        public weekModel(Date pstartOfWeek , Schedules__c pschObj, Boolean pMultipleSchedules)
        {
            MultipleSchedules = pMultipleSchedules;
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-' + String.valueOf(pstartOfWeek.month()) + '-' + String.valueOf(pstartOfWeek.day());
            ExtensionAvailable = false;
            CellAvailable = true;
            startOfWeek = pstartOfWeek; 
            schObj = pschObj;
            if(schObj.Status__c == 'Canceled')
            {
                color ='red';
            }       
            else if(schObj.TEST__c == true)
            {
                color='blue';
            }
            else
            {
                color='black';    
            }
            if (pschObj.Week__c < Date.today().toStartOfWeek().addDays(1))
            {
              CellAvailable = false;
            }
        }
        public weekmodel(Date pstartOfWeek, String pOrderLineNumber)
        {
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-' + String.valueOf(pstartOfWeek.month()) + '-' + String.valueOf(pstartOfWeek.day());
            startOfWeek = pstartOfWeek;  
            CellAvailable = false;   
            if (pstartOfWeek >= Date.today().toStartOfWeek().addDays(1))
            {
                ExtensionAvailable = true;
            }
            else
            {
                ExtensionAvailable = false;
            }
            OrderLineNumber = pOrderLineNumber;
        }
    }

    //Contains prelog data for a single OrderLineNumber for a single week.
    public class PrelogDataWrapper
    {
        public PrelogData__c prelogData {get; set;}

        //Map each day of the week to the correct value.
        public Map<String, Decimal> rateMap {get; set;}
        public Map<String, Decimal> clearanceMap {get; set;}
        public Map<String, Decimal> unitClearanceMap {get; set;}
        public Map<String, Decimal> unitsAvailableMap {get; set;}
        public Map<String, Decimal> unitsAiredMap {get; set;}

        //Grand totals
        public Decimal totalDollars {get; set;}
        public Decimal rate {get; set;}
        public Decimal clearance {get; set;}
        public Decimal unitClearance {get; set;}
        public Decimal unitAired {get; set;}
        public Decimal unitPlaced {get; set;}

        public PrelogDataWrapper(PrelogData__c prelogData) {
            this.prelogData = prelogData;
            this.rateMap = new Map<String, Decimal>{
                    '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0, '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0};
            this.clearanceMap = new Map<String, Decimal>{
                    '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0, '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0};
            this.unitClearanceMap = new Map<String, Decimal>{
                    '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0, '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0};
            this.unitsAvailableMap = new Map<String, Decimal>{
                    '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0, '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0};
            this.unitsAiredMap = new Map<String, Decimal>{
                    '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0, '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0};
            this.totalDollars = 0.0;
            this.rate = 0.0;
            this.clearance = 0.0;
            this.unitClearance = 0.0;
            this.unitAired = 0.0;
            this.unitPlaced = 0.0;
        }

        //Loops through maps and calculates the total rates for the week.
        public void calculateTotals() {
            for (Decimal amt : this.rateMap.values()) {
                this.rate += amt;
            }
            for (Decimal amt : this.unitClearanceMap.values()) {
                this.unitClearance += amt;
                System.debug('***calculateTotals: amt ' + amt) ;
            }
            System.debug('***calculateTotals: unitClearance ' + this.unitClearance) ;
            this.totalDollars = this.prelogData.Schedule__r.Total_Dollars__c;
            System.debug('***calculateTotals: Total_Dollars__c ' + this.totalDollars) ;
            this.unitAired = this.prelogData.Schedule__r.Units_Aired__c ;
            System.debug('***calculateTotals: Units_Aired__c ' + this.unitAired) ;

            this.clearance = this.totalDollars != 0.0 ? ((this.rate / this.totalDollars)).setScale(2) : 0.0;
            this.unitPlaced = this.unitAired != 0.0 ? ((this.unitClearance / this.unitAired)).setScale(2) : 0.0;
        }
    }
    
    //Add the selected deal and rerun the prelog clearance report.
    public void updatePrelogClearanceReport() {
        this.AddMoreToDeal();
        this.setPrelogClearanceReport();
    }
    
    //Get the prelog clearance report for the specified DealId
    public void setPrelogClearanceReport() {
        System.debug('Monday ==> ' + this.getMonday());
        System.debug('Sunday ==> ' + this.getSunday());
        Set<Id> scheduleIdSet = new Set<Id>() ;
        
        //** Modified the Query by Sanjay *//
        Date currentMonday = tempSchedule.Week__c;
        Date currentSunday = tempSchedule.Week__c.addDays(6);
        
        //Modified the query by Sanjay on 2/18/2016    
        List<PrelogData__c> prelogData = new List<PrelogData__c>();
        
        //String to hold the query
        String queryString = 'SELECT Schedule__r.Deal_Parent__r.Brands__r.Name, Schedule__r.OrderLineNumber__c,'
            				 + 'Schedule__r.Days_Allowed_Formula__c, Schedule__r.Start_Time__c, Schedule__r.Days_Allowed__c,'
            				 + 'Schedule__r.End_Time__c, Schedule__r.Rate__c, Schedule__c,'
            				 + 'Schedule__r.MGM_HD_Daypart__c, Day_of_Week__c,' 
            				 + 'Rate__c, Schedule__r.Total_Dollars__c, Schedule__r.Units_Available__c,'
            				 + 'Schedule__r.Units_Aired__c, Schedule__r.Name, Schedule__r.Id,'
            				 + 'Schedule__r.Cap__c, Schedule__r.LastModifiedDate '
            				 + 'FROM PrelogData__c '
            				 + 'WHERE Schedule__r.Deal_Parent__c IN: DealWrapperIdSet '
            				 + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday';
            				 
		//Check for version
        if(String.isNotBlank(prelogVersion)) {
        	Integer tempInt = Integer.valueOf(prelogVersion);
        	queryString += ' AND Version__c =: tempInt';
        }
        else {
        	queryString += ' AND Current_Version__c = true';
		}
		
        //Add records in the query
        prelogData = Database.query(queryString);
        
        //Instantiate the deal map and add all of the selected deal Id keys.
        //Adding the deal Ids will prevent any key errors on the Visualforce side in case there is no prelog data for a given deal.
        this.dealMap = new Map<Id, Map<String, PrelogDataWrapper>>();
        this.grandTotalMap = new Map<Id, Map<String, Decimal>>();
        for (Id dealId : this.DealWrapperIdSet) {
            this.dealMap.put(dealId, new Map<String, PrelogDataWrapper>());
            this.grandTotalMap.put(dealId, new Map<String, Decimal>{'Total Dollars' => 0.0, 'Total Rate' => 0.0, 'Total Clearance' => 0.0});
        }
        
        for (PrelogData__c d : prelogData) {
            scheduleIdSet.add(d.Schedule__c) ;
            //This maps each order line number to the prelog data for a given deal.
            Map<String, PrelogDataWrapper> prelogMap = new Map<String, PrelogDataWrapper>();
            if (this.dealMap.containsKey(d.Schedule__r.Deal_Parent__c)) {
                prelogMap = this.dealMap.get(d.Schedule__r.Deal_Parent__c);
            }
            
            //This holds all of the information about the prelog data for a given day of the week.
            PrelogDataWrapper w = new PrelogDataWrapper(d);
            if (prelogMap.containsKey(d.Schedule__r.OrderLineNumber__c)) {
                w = prelogMap.get(d.Schedule__r.OrderLineNumber__c);
            }
            
            Decimal totalRate = 0;
            
            //Check for null
            if (d.Rate__c != null) {
                totalRate = d.Rate__c;
            }
            
            if (w.rateMap.containsKey(d.Day_of_Week__c)) {
                totalRate += w.rateMap.get(d.Day_of_Week__c);
            }
            w.rateMap.put(d.Day_of_Week__c, totalRate);
            
            Decimal totalDollars = d.Schedule__r.Total_Dollars__c;
            Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;
            w.clearanceMap.put(d.Day_of_Week__c, clearance);
            w.unitClearanceMap.put(d.Day_of_Week__c, w.unitClearanceMap.get(d.Day_of_Week__c)+1);
            w.unitsAvailableMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Available__c) ;
            w.unitsAiredMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Aired__c) ;
            
            //Update the inner, prelog map, and then the deal map.
            prelogMap.put(d.Schedule__r.OrderLineNumber__c, w);
            this.dealMap.put(d.Schedule__r.Deal_Parent__c, prelogMap);
        }

        for (Id dealId : this.DealWrapperIdSet) {
            if(!SelectedDealMap.containsKey(dealId)) continue ;
            for(Schedules__c s: SelectedDealMap.get(dealId).Schedules__r) {
                if(scheduleIdSet.contains(s.Id)) continue ;
                //This maps each order line number to the prelog data for a given deal.
                Map<String, PrelogDataWrapper> prelogMap = new Map<String, PrelogDataWrapper>();
                if (this.dealMap.containsKey(s.Deal_Parent__c)) {
                    prelogMap = this.dealMap.get(s.Deal_Parent__c);
                }
                //This holds all of the information about the prelog data for a given day of the week.
                PrelogDataWrapper w = new PrelogDataWrapper(new PrelogData__c(Schedule__r = s));
                if (prelogMap.containsKey(s.OrderLineNumber__c)) {
                    w = prelogMap.get(s.OrderLineNumber__c);
                }

                Decimal totalRate = 0;
                Decimal totalDollars = s.Total_Dollars__c;
                Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;
                
                //Update the inner, prelog map, and then the deal map.
                prelogMap.put(s.OrderLineNumber__c, w);
                this.dealMap.put(s.Deal_Parent__c, prelogMap);
            }
        }
        
        //Calculate the totals for each prelog wrapper. 
        //Also, calculate the grand totals for each selected deal.
        for (Id dealId : this.dealMap.keySet()) {
            Decimal dealTotalDollars = 0.0;
            Decimal dealTotalRate = 0.0;
            Decimal dealTotalClearance = 0.0;
            for (PrelogDataWrapper w : this.dealMap.get(dealId).values()) {
                w.calculateTotals();
                dealTotalDollars += w.totalDollars;
                dealTotalRate += w.rate;
                dealTotalClearance = dealTotalDollars != 0.0 ? ((dealTotalRate / dealTotalDollars)).setScale(2) : 0.0;
            }
            this.grandTotalMap.put(dealId, new Map<String, Decimal>{
                'Total Dollars' => dealTotalDollars, 
                'Total Rate' => dealTotalRate,
                'Total Clearance' => dealTotalClearance
            });
        }
    }

    //Returns the Monday of this week for use in a soql query.
    public Date getMonday() {
        Date t = Date.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getMonday: daysBetween: ' + daysBetween);
        if((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(1);
    }

    //Returns the Sunday of this week for use in a soql query.
    public Date getSunday() {
        Date t = Date.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getSunday: daysBetween: ' + daysBetween);
        if((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(7);
    }

    public Date thisMonday {
        get {
            if(thisMonday == null) {
                thisMonday = this.getMonday() ;
            }
            return thisMonday ;
        }
        set;
    }

    public Date thisSunday {
        get {
            if(thisSunday == null) {
                thisSunday = this.getSunday() ;
            }
            return thisSunday ;
        }
        set;
    }

    public Integer ReturnNumber(String pMonth)
    {
        if (pMonth.toLowerCase() == 'jan')
        {
            return 1;
        }
        else if (pMonth.toLowerCase() == 'feb')
        {
            return 2;
        }
        else if (pMonth.toLowerCase() == 'mar')
        {
            return 3;
        }
        else if (pMonth.toLowerCase() == 'apr')
        {
            return 4;
        }
        else if (pMonth.toLowerCase() == 'may')
        {
            return 5;
        }
        else if (pMonth.toLowerCase() == 'jun')
        {
            return 6;
        }
        else if (pMonth.toLowerCase() == 'jul')
        {
            return 7;
        }
        else if (pMonth.toLowerCase() == 'aug')
        {
            return 8;
        }
        else if (pMonth.toLowerCase() == 'sep')
        {
            return 9;
        }
        else if (pMonth.toLowerCase() == 'oct')
        {
            return 10;
        }
        else if (pMonth.toLowerCase() == 'nov')
        {
            return 11;
        }
        else
        {
            return 12;
        }
    }

    public String ReturnStringDate(Date pDate)
    {
        String pString = String.valueOf(pDate.year()) + '-';
        if (pDate.month() < 10)
        {
            pString += '0' + String.valueOf(pDate.month()) + '-';
        }
        else
        {
            pString += String.valueOf(pDate.month()) + '-';
        }
        if (pDate.day() < 10)
        {
            pString += '0' + String.valueOf(pDate.day());
        }
        else
        {
            pString += String.valueOf(pDate.day());
        }
        return pString;
    }

    public String formatDatetime(Datetime d){
        return d.format('yyyy-MM-dd')+'T'+d.format('HH:mm:ssXXX');
    }
}