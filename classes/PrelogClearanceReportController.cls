/** 
*  Purpose         :   Controller class for PrelogClearanceReport
*  
*  Created By      :   Sanjay Ramchandani
*  
*  Created Date    :   --
*  
*  Revision Logs   :   V_1.0 - Created
*                      V_1.1 - Modified for new changes 1/31/2016
* 
* MG cloned this CTRLR as a 'version2' from the orig May 16 2016
* MG Reload into refreshed Sandbox 8-15-16
* 
**/
public class PrelogClearanceReportController {

    // Mocking Selectors
    private static DateSelector dates = new DateSelector();
    public static void setDateSelector(DateSelector da) {
        dates = da;
    }
    private static PrelogDataSelector prelogDataSelector = new PrelogDataSelector();
    public static void setPrelogDataSelector(PrelogDataSelector plSelector) {
        prelogDataSelector = plSelector;
    }
    private static DealSelector dealSelector = new DealSelector();
    public static void setDealSelector(DealSelector dSelector) {
        dealSelector = dSelector;
    }
    private static ScheduleSelector scheduleSelector = new ScheduleSelector();
    public static void setScheduleSelector(ScheduleSelector scSelector) {
        scheduleSelector = scSelector;
    }
    private static PeriodSelector periodSelector = new PeriodSelector();
    public static void setPeriodSelector(PeriodSelector pSelector) {
        periodSelector = pSelector;
    }
    private static FiscalYearSettingsSelector fysSelector = new FiscalYearSettingsSelector();
    public static void setFYSSelector(FiscalYearSettingsSelector fSelector) {
        fysSelector = fSelector;
    }

    public List<String> testlist;
    public Set<String> testset;
    public List<DoubleCheckReadOnlyHelper.WeekModel> quarterweek { get; set; }
    public List<DoubleCheckReadOnlyHelper.HeadingModel> headingModels { get; set; }
    public List<Date> quarterdates { get; set; }
    private List<Deal__c> DealResultList { get; set; }

    //MG created to track Deal string IDs, and associated data in the class
    public Map<String, DoubleCheckReadOnlyHelper.DealWrapper> DealWrapperMap { get; set; }
    public transient List<DoubleCheckReadOnlyHelper.DealWrapper> DealWrapperList { get; set; }
    public Set<Id> DealWrapperIdSet { get; set; }
    public List<String> SearchList;
    public String Searchfield { get; set; }
    public String DealId { get; set; }
    public String cellrate { get; set; }
    public String cellUnits { get; set; }
    public String CellId { get; set; }
    public String DealName { get; set; }
    public Decimal RateforCell { get; set; }
    public String SaveDescision { get; set; }
    public Boolean selectAll { get; set; }
    public Date anchordate;
    public Date startdate;
    public Date enddate;
    public Boolean schedulemessage { get; set; }
    public Boolean showtable { get; set; }
    public Deal__c SelectedDeal { get; set; }
    public Map<String, Deal__c> SelectedDealMap { get; set; }
    public Date LowestDate { get; set; }
    public Date HighestDate { get; set; }
    public Date QuarterEndDate { get; set; }
    public String SelectedExtensionDate { get; set; }
    public String SelectedOrderLineNumber { get; set; }
    public String RemoveDealId { get; set; }
    public String SelectedDealSet { get; set; }
    public Boolean BarterCheckbox { get; set; }
    public String SelectedCableSynd { get; set; }
    public List<SelectOption> CableSyndSOList { get; set; }
    public String currentVersion { get; set; }
    public Schedules__c WeekStartDate { get; set; }
    public Schedules__c WeekEndDate { get; set; }
    public List<SelectOption> DateLiteralSOList { get; set; }
    public String SelectedDateLiteral { get; set; }
    public String SOQLDateString { get; set; }
    public Boolean dealSelectionOperation { get; set; }
    public Map<String, String> VersionMap { get; set; }

    //Map to hold day of month with month name
    public Map<Integer, String> mapDayOfMonthWithName;

    //Added by Sanjay on 2/15/2016
    public Brands__c brand { get; set; }

    //Added by Sanjay on 2/18/2016
    public String prelogVersion { get; set; }

    //Added by Sanjay on 2/1/2016
    public Schedules__c tempSchedule { get; set; }

    public Period CurrentFP;
    public transient Map<String, Map<Integer, Period>> QuarterPeriodMapTemp;

    //Maps each selected deal Id to a map that maps each order line number to the prelog data.
    public Map<String, Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>> dealMap { get; set; }

    //Maps each selected deal Id to a list of grand totals.
    public Map<String, Map<String, Decimal>> grandTotalMap { get; set; }

    // MG for vForce Page rendering Weeks being Searched Monday-compiled
    public String weekEntries { get; set; }

    // MG for CTRLR preparing the Set of Weeks being passed
    public Set<String> weekSet { get; set; }

    public Date thisMonday {
        get {
            if (thisMonday == null) {
                thisMonday = this.getMonday() ;
            }
            return thisMonday ;
        }
        set;
    }

    public Date thisSunday {
        get {
            if (thisSunday == null) {
                thisSunday = this.getSunday() ;
            }
            return thisSunday ;
        }
        set;
    }

    public Map<String, Map<Integer, Period>> QuarterPeriodMap {
        get {
            if (QuarterPeriodMapTemp == null) {
                QuarterPeriodMapTemp = new Map<String, Map<Integer, Period>>();
                List<Period> qpm = periodSelector.getQuarterPeriods();
                for (Period PR : qpm) {
                    if (PR.StartDate <= dates.today() && PR.EndDate >= dates.today()) {
                        CurrentFP = PR;
                        System.debug('CurrentFP - ' + CurrentFP.StartDate + ' - ' + CurrentFP.EndDate);
                    }
                    if (QuarterPeriodMapTemp.containsKey(PR.FiscalYearSettings.Name)) {
                        Map<Integer, Period> TempQuarterPeriodMap =
                                QuarterPeriodMapTemp.get(PR.FiscalYearSettings.Name);
                        TempQuarterPeriodMap.put(PR.Number, PR);
                        QuarterPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                    } else {
                        Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                        TempQuarterPeriodMap.put(PR.Number, PR);
                        QuarterPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                    }
                }
            }
            return QuarterPeriodMapTemp;
        }
    }

    public PrelogClearanceReportController() {
        setupLists();

        // MG  initialize variables on Page Load  108-109
        weekSet = new Set<String>();
        currentVersion = '';
        VersionMap = new Map<String, String>();
        weekEntries = '';
        SaveDescision = '';
        selectAll = false;
        if (DealWrapperList == null) DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();

        // MG  for Initialization
        DealWrapperMap = new Map<String, DoubleCheckReadOnlyHelper.DealWrapper>();
        DealWrapperIdSet = new Set<Id>();
        SelectedDealSet = '';
        SelectedDealMap = new Map<String, Deal__c>() ;
        SelectedCableSynd = '';
        WeekStartDate = new Schedules__c();
        WeekEndDate = new Schedules__c();
        DateLiteralSOList = DealUtils.ReturnDateLiteralSOList();

        //Initialization (By Sanjay)
        tempSchedule = new Schedules__c();
        brand = new Brands__c();
        prelogVersion = '';

        //Set current week in the week
        tempSchedule.Week__c = dates.today().toStartOfWeek().addDays(1);
    }

    private void setupLists() {
        // Cable dropdown
        CableSyndSOList = DealUtils.ReturnCableSyndSOList();

        //Populate the map
        mapDayOfMonthWithName = new Map<Integer, String>();
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
    }

    public void DoSearch() {
        try {
            DealResultList = new List<Deal__c>();
            SearchList = new List<String>();
            ReturnSOQLDateString();

            if (Searchfield == null || Searchfield == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Search field can not be empty'));
                return;
            }

            SearchList = Searchfield.split(',');
            DealResultList = dealSelector.getDealsFromSearchQuery(
                    SOQLDateString, SearchList, getPeriod(), BarterCheckbox, SelectedCableSynd, '200');

            FilterDealsForPrelog();

            if (DealResultList.size() == 0 && Searchfield != null && Searchfield != '') {
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 'The Search did not return any results'));
            }

            DealId = '';
            DealName = '';
            cellrate = '';
            CellId = '';
            showtable = false;
            schedulemessage = false;
            SortDealResultList();
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    private Period getPeriod() {
        if (tempSchedule.Week__c == null) {
            tempSchedule.Week__c = Date.today();
        }
        return getCurrentQuarter(tempSchedule.Week__c);
    }

    public void FilterDealsForPrelog() {
        // Prelog-specific
        currentVersion = '';
        VersionMap = new Map<String, String>();
        SelectedDealSet = '';
        dealSelectionOperation = false;

        System.debug('######### this monday' + this.getMonday() + ' %%%%% this sunday' + this.getSunday());

        Map<Id, List<PrelogData__c>> scheduleMap = new Map<Id, List<PrelogData__c>>();

        for (Deal__c Deal : DealResultList) {
            if (prelogVersion != null && prelogVersion != '') {
                VersionMap.put(Deal.Id, prelogVersion);
            } else {
                VersionMap.put(Deal.Id, '');
            }

        }

        List<PrelogData__c> plogList = prelogDataSelector.getPrelogDataWithDeals(
                DealResultList, tempSchedule.Week__c, prelogVersion);
        for (PrelogData__c p : plogList) {

            if (scheduleMap.containsKey(p.Schedule__r.Deal_Parent__c)) {
                scheduleMap.get(p.Schedule__r.Deal_Parent__c).add(p) ;
            } else {
                List<PrelogData__c> tmpPrelogList = new List<PrelogData__c>() ;
                tmpPrelogList.add(p) ;
                scheduleMap.put(p.Schedule__r.Deal_Parent__c, tmpPrelogList) ;
            }

            if ((!String.isNotBlank(prelogVersion)) && p.Current_Version__c == true && p.Version__c != null) {
                currentVersion = String.valueOf(p.Version__c);
            }

            if (prelogVersion != null && prelogVersion != '') {
                if (VersionMap.containsKey(p.Schedule__r.Deal_Parent__c)
                        && VersionMap.get(p.Schedule__r.Deal_Parent__c) != '') {
                    VersionMap.put(p.Schedule__r.Deal_Parent__c, prelogVersion);
                }
            } else if (p.Current_Version__c == true && p.Version__c != null) {
                VersionMap.put(p.Schedule__r.Deal_Parent__c, String.valueOf(p.Version__c));
            }
            System.debug('%%%% ' + p.Schedule__r.Deal_Parent__r.Name + ' %%%%% '
                    + VersionMap.get(p.Schedule__r.Deal_Parent__c));
        }

        System.debug('***scheduleMap: after ' + scheduleMap) ;
        Integer i = 0;

        System.debug('***DealResultList: after ' + DealResultList) ;


        //Map to hold deal id as a key and list of schedules as a value
        Map<Id, List<Schedules__c>> mapDealIdWithSchedules = new Map<Id, List<Schedules__c>>();

        System.debug('####tempSchedule.Week__c' + tempSchedule.Week__c);

        //Logic for include the deals records where schedule exists with the entered week
        List<Schedules__c> schList = scheduleSelector.getSchedulesForWeek(tempSchedule.Week__c);

        for (Schedules__c sch : schList) {

            //Check for map key
            if (!mapDealIdWithSchedules.containsKey(sch.Deal_Parent__c)) {
                mapDealIdWithSchedules.put(sch.Deal_Parent__c, new List<Schedules__c>{
                        sch
                });
            } else {
                mapDealIdWithSchedules.get(sch.Deal_Parent__c).add(sch);
            }
        }

        System.debug('####DealResultList size before' + DealResultList.size());
        System.debug('####mapDealIdWithSchedules' + mapDealIdWithSchedules.size());

        //List to hold deal records
        List<Deal__c> tempDeal = new List<Deal__c>();

        //Check for map size
        if (mapDealIdWithSchedules.size() > 0) {
            for (Deal__c dl : DealResultList) {
                if (mapDealIdWithSchedules.containsKey(dl.Id)) {
                    tempDeal.add(dl);
                }
            }
            DealResultList = tempDeal;
        }

        System.debug('####DealResultList size after' + DealResultList.size());
    }

    public void SortDealResultList() {
        try {
            Map<Date, List<Deal__c>> DealDateList = new Map<Date, List<Deal__c>>();
            Set<Date> DateList = new Set<Date>();
            List<Deal__c> NoDateList = new List<Deal__c>();
            for (Deal__c DR : DealResultList) {
                if (DR.Week_MIN_Field__c != null) {
                    DateList.add(DR.Week_MIN_Field__c);
                    if (DealDateList.containsKey(DR.Week_MIN_Field__c)) {
                        List<Deal__c> DealL = DealDateList.get(DR.Week_MIN_Field__c);
                        DealL.add(DR);
                        DealDateList.put(DR.Week_MIN_Field__c, DealL);
                    } else {
                        List<Deal__c> DealL = new List<Deal__c>();
                        DealL.add(DR);
                        DealDateList.put(DR.Week_MIN_Field__c, DealL);
                    }
                } else {
                    NoDateList.add(DR);
                }
            }
            List<Date> DateSortList = new List<Date>();
            for (Date DS : DateList) {
                DateSortList.add(DS);
            }
            DateSortList.sort();
            DealResultList.clear();
            for (Integer i = DateSortList.size() - 1; i >= 0; i--) {
                if (DealDateList.containsKey(DateSortList[i])) {
                    DealResultList.addAll(DealDateList.get(DateSortList[i]));
                }
            }
            DealResultList.addAll(NoDateList);
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void RemoveDealButton() {
        try {
            if (RemoveDealId != null) {
                List<DoubleCheckReadOnlyHelper.DealWrapper> TempDealWrapper =
                        new List<DoubleCheckReadOnlyHelper.DealWrapper>();
                if (DealWrapperList != null) {
                    TempDealWrapper.addAll(DealWrapperList);
                }
                DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
                DealWrapperIdSet = new Set<Id>();
                SelectedDealSet = '';

                SelectedDealMap.remove(DealId) ;

                if (DealWrapperMap.containsKey(RemoveDealId)) DealWrapperMap.remove(RemoveDealId);
                for (String key : DealWrapperMap.keySet()) {
                    DoubleCheckReadOnlyHelper.DealWrapper DW = DealWrapperMap.get(key);
                    weekEntries += ',' + DW.getKey();
                    DW.isPreviousWeekData = true;
                    DealWrapperIdSet.add(DW.DealRecord.Id);
                    SelectedDealSet += DW.DealRecord.Id;
                }

            }
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void AddMoreToDeal() {
        try {
            testlist = new List<String>();
            testset = new Set<String>();
            List<DoubleCheckReadOnlyHelper.LineItemModel> ratelist =
                    new List<DoubleCheckReadOnlyHelper.LineItemModel>();
            Map<String, List<Schedules__c>> schgroup = new Map<String, List<Schedules__c>>();
            Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();
            LowestDate = Date.newInstance(3000, 1, 1);
            HighestDate = Date.newInstance(1000, 1, 1);

            List<Schedules__c> scheds = scheduleSelector.getSchedulesFromQuery(
                    'Select ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c')
                            + ', Deal_Parent__r.Week_MIN_Field__c from Schedules__c where Deal_Parent__c = \''
                            + DealId + '\' ORDER BY MilitaryTime__c, Rate__c');
            for (Schedules__c schlist : scheds) {
                if (LowestDate > schlist.Week__c) {
                    LowestDate = schlist.Week__c;
                }
                if (HighestDate < schlist.Week__c) {
                    HighestDate = schlist.Week__c;
                }
                if (schlist.OrderNumber__c != null) {
                    if (!testset.contains(schlist.OrderNumber__c)) {
                        testlist.add(schlist.OrderNumber__c);
                        testset.add(schlist.OrderNumber__c);
                    }
                    if (schgroup.containsKey(schlist.OrderNumber__c)) {
                        List<Schedules__c> temp = schgroup.get(schlist.OrderNumber__c);
                        temp.add(schlist);
                        schgroup.put(schlist.OrderNumber__c, temp);
                    } else {
                        List<Schedules__c> temp = new List<Schedules__c>();
                        temp.add(schlist);
                        schgroup.put(schlist.OrderNumber__c, temp);
                    }
                }

            }


            //Modified the query by Sanjay 2/3/2016 //

            //Check for null
            if (tempSchedule.Week__c == null) {
                tempSchedule.Week__c = dates.today().toStartOfWeek().addDays(1);
            }

            List<Deal__c> DealList = dealSelector.getDealsForAdd(DealId, tempSchedule.Week__c);

            if (DealList.size() > 0) {
                ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c);
                SelectedDeal = DealList[0];
            }
            System.debug('Final Lowest Date - ' + LowestDate);
            Decimal TotalUnitsAired = 0;
            Decimal TotalUnitsAvailable = 0;
            Decimal TotalDollars = 0;
            Decimal TotalDollarsBooked = 0;
            for (String mapkeylist : testlist) {
                List<Schedules__c> tempwraplist = schgroup.get(mapkeylist);
                DoubleCheckReadOnlyHelper.LineItemModel Lm = new DoubleCheckReadOnlyHelper.LineItemModel();
                Lm.OrderLineNumber = mapkeylist;
                if (tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null) {
                    Lm.rate = tempwraplist[0].Rate__c;
                } else {
                    Lm.rate = 0;
                }
                Lm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                Lm.SETime = tempwraplist[0].Start_End_Time__c;
                Lm.UnitLength = tempwraplist[0].UnitLength__c;
                Date RMLowestDate = Date.newInstance(3000, 1, 1);
                Date RMHighestDate = Date.newInstance(1000, 1, 1);
                for (Schedules__c sch : tempwraplist) {
                    if (RMLowestDate > sch.Week__c) {
                        RMLowestDate = sch.Week__c;
                    }
                    if (RMHighestDate < sch.Week__c) {
                        RMHighestDate = sch.Week__c;
                    }
                    if (sch.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                        if (sch.Filler__c == true) {
                            Lm.Filler = true;
                        }
                    }
                    if (sch.Reconciled__c == 'Y') {
                        if (sch.Status__c != 'Canceled') {
                            TotalUnitsAired += (sch.Units_Aired__c == null ? 0 : sch.Units_Aired__c);
                            TotalUnitsAvailable += (sch.Units_Available__c == null ? 0 : sch.Units_Available__c);
                        }

                        TotalDollars += (sch.Total_Dollars__c == null ? 0 : sch.Total_Dollars__c);
                        TotalDollarsBooked += (sch.Dollars_Booked__c == null ? 0 : sch.Dollars_Booked__c);
                    }
                }
                Lm.LowestDate = RMLowestDate;
                Lm.HighestDate = RMHighestDate;
                Map<Date, Schedules__c> weekMap = new Map<Date, Schedules__c>();
                Map<Date, Boolean> DuplicateWeekMap = new Map<Date, Boolean>();
                for (Schedules__c schtemp : tempwraplist) {
                    if (weekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekMap.put(schtemp.Week__c, schtemp);
                    if (WeekDollarsMap.containsKey(schtemp.Week__c)) {
                        Decimal WeekDollars = WeekDollarsMap.get(schtemp.Week__c);
                        WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                        WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                    } else {
                        Decimal WeekDollars = 0;
                        WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                        WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                    }
                }
                for (Date sow : quarterdates) {
                    if (sow != null) {
                        if (sow >= LowestDate) {
                            if (weekMap.containsKey(sow)) {
                                if (DuplicateWeekMap.containsKey(sow)) {
                                    Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekModel(
                                            sow, weekMap.get(sow), true));
                                } else {
                                    Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekModel(
                                            sow, weekMap.get(sow), false));
                                }
                            } else {
                                Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekmodel(
                                        sow, tempwraplist[0].OrderNumber__c));
                            }
                        }
                    }
                }
                ratelist.add(Lm);
                //Display();
            }
            DoubleCheckReadOnlyHelper.DealWrapper DW = new DoubleCheckReadOnlyHelper.DealWrapper();
            DW.DealRecord = SelectedDeal;
            DW.HeadingList = ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c);
            List<String> TempWeekDollarsList = new List<String>();
            for (DoubleCheckReadOnlyHelper.HeadingModel HM : DW.HeadingList) {
                if (WeekDollarsMap.containsKey(HM.startOfWeek)) {
                    Decimal DollarAmount = WeekDollarsMap.get(HM.startOfWeek);
                    String StringAmount;
                    if (DollarAmount < 1000) {
                        StringAmount = '$' + String.valueOf(DollarAmount);
                        StringAmount = StringAmount.replace('.00', '');
                    } else {
                        DollarAmount = DollarAmount.setScale(0);
                        DollarAmount = DollarAmount / 1000.0;
                        DollarAmount = DollarAmount.setScale(1);
                        StringAmount = '$' + String.valueOf(DollarAmount);
                        StringAmount = StringAmount.replace('.0', '') + 'K';
                    }
                    TempWeekDollarsList.add(StringAmount);
                } else {
                    TempWeekDollarsList.add('$0');
                }
            }
            DW.WeekDollarsList = TempWeekDollarsList;
            DW.LineItemModelList = ratelist;
            DW.UnitsAired = TotalUnitsAired;
            DW.UnitsAvailable = TotalUnitsAvailable;
            DW.WeekDollarsMap = WeekDollarsMap;
            DW.ClearancePercentage = (
                    DW.UnitsAvailable == 0
                            ? 0
                            : (DW.UnitsAired / DW.UnitsAvailable * 100.0).intValue());
            DW.TotalDollars = TotalDollars;
            DW.TotalDollarsBooked = TotalDollarsBooked;
            DW.DollarClearancePercentage = (
                    DW.TotalDollarsBooked == 0
                            ? 0
                            : (DW.TotalDollars / DW.TotalDollarsBooked * 100.0).intValue());

            //Logic for format the prelog date time in local time zone
            String weekDay = null;
            if (DW.DealRecord.Program__r.Prelog_Date_Time__c != null) {
                weekDay = DW.DealRecord.Program__r.Prelog_Date_Time__c.format('EEEE').left(3);
            }

            String monthOfYear = null;
            if (DW.DealRecord.Program__r.Prelog_Date_Time__c != null) {
                monthOfYear = mapDayOfMonthWithName.get(DW.DealRecord.Program__r.Prelog_Date_Time__c.month());
            }

            String dayString = null;
            if (DW.DealRecord.Program__r.Prelog_Date_Time__c != null) {
                dayString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.day());
            }

            String hourString = null;
            if (DW.DealRecord.Program__r.Prelog_Date_Time__c != null) {
                hourString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.hour());
            }

            String minuteString = null;
            if (DW.DealRecord.Program__r.Prelog_Date_Time__c != null) {
                minuteString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.minute());
            }

            //Prepare final string
            DW.prelogDateTime = '';
            if (weekDay != null && monthOfYear != null && dayString != null
                    && hourString != null && minuteString != null) {
                DW.prelogDateTime = weekDay + ' ' + monthOfYear + ' ' + dayString + ' '
                        + hourString + ':' + minuteString + ' EST';
            }

            DW.Week = getWeek();
            DW.prelogversion = VersionMap.get(DW.DealRecord.Id);
            System.debug('1.Inserting prelogversion#' + DW.prelogversion + '#Original'
                    + VersionMap.get(DW.DealRecord.Id));
            // MG added for adding IDs to sets, maps "DW.DealRecord.Id + getWeek(),DW"
            if (!DealWrapperMap.containsKey(DW.getKey())) {
                System.debug('2.Inserting prelogversion#' + DW.prelogversion + '#Original'
                        + VersionMap.get(DW.DealRecord.Id));
                weekEntries += ',' + DW.getKey();
                DealWrapperList.add(DW);

                DealWrapperMap.put(DW.getKey(), DW);
                DealWrapperIdSet.add(SelectedDeal.Id);
                SelectedDealSet += SelectedDeal.Id;
                SelectedDealMap.put(SelectedDeal.Id + getWeek() + DW.prelogversion, SelectedDeal) ;

            }
            // Logic For Sort the Wrapper list so that newly searched
            // record coming at the very first row in the table
            List<DoubleCheckReadOnlyHelper.DealWrapper> tempDealWrapper =
                    new List<DoubleCheckReadOnlyHelper.DealWrapper>();

            //Loop through the wrapper
            for (Integer j = DealWrapperList.size() - 1; j >= 0; j--) {
                tempDealWrapper.add(DealWrapperList[j]);
            }

            System.debug('#########' + tempDealWrapper);

            //Re-populate the wrapper
            DealWrapperList = tempDealWrapper;
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    public List<DoubleCheckReadOnlyHelper.HeadingModel> ListOfDates(Date pAnchorDate, Date pReconciledDate) {
        try {
            //Red Argyle - #2791:Controller issues with atypical fiscal quarters
            Date AnchorDate = pAnchorDate;

            Period period = periodSelector.getQuarterPeriodFromDate(AnchorDate);
            Date StartOfQuarter = period.StartDate;
            Date EndOfQuarter = period.EndDate;
            QuarterEndDate = period.EndDate;

            if (HighestDate > EndOfQuarter) {
                EndOfQuarter = HighestDate;
            }
            if (AnchorDate > EndOfQuarter) {
                ListOfDates(AnchorDate.addDays(7), pReconciledDate);
            }
            quarterdates = new List<Date>();
            while (StartOfQuarter <= EndOfQuarter) {
                quarterdates.add(StartOfQuarter);
                enddate = StartOfQuarter;
                StartOfQuarter = StartOfQuarter.addDays(7);
            }
            //quarterdates.add(enddate); 
            headingModels = new List<DoubleCheckReadOnlyHelper.HeadingModel>();
            quarterweek = new List<DoubleCheckReadOnlyHelper.WeekModel>();
            for (Date sow : quarterdates) {
                if (sow != null) {
                    DoubleCheckReadOnlyHelper.HeadingModel hm = new DoubleCheckReadOnlyHelper.HeadingModel();
                    hm.startOfWeek = sow;
                    if (pReconciledDate >= sow) {
                        hm.bgcolor = '#848484';
                    } else {
                        hm.bgcolor = '#86BCFF';
                    }
                    System.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (sow >= LowestDate));
                    if (sow >= LowestDate) {
                        headingModels.add(hm);
                    }
                }
            }
            return headingModels;
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
        return null;
    }

    //Add the selected deal and rerun the prelog clearance report.
    public void updatePrelogClearanceReport() {
        DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
        this.AddMoreToDeal();
        this.setPrelogClearanceReport();
        weekSet.add(getWeek());
        DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
    }

    //Get the prelog clearance report for the specified DealId
    public void setPrelogClearanceReport() {
        System.debug('Monday ==> ' + this.getMonday());
        System.debug('Sunday ==> ' + this.getSunday());
        Set<Id> scheduleIdSet = new Set<Id>() ;

        System.debug('dealWrapperIdSet ' + DealWrapperIdSet);

        // Instantiate the deal map and add all of the selected deal Id keys.
        // Adding the deal Ids will prevent any key errors on the
        // Visualforce side in case there is no prelog data for a given deal.
        if (this.dealMap == null) {
            this.dealMap = new Map<String, Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>>();
        }
        this.grandTotalMap = new Map<String, Map<String, Decimal>>();

        for (DoubleCheckReadOnlyHelper.DealWrapper DW : this.DealWrapperList) {
            if (DW.DealRecord.Id == DealId && DW.prelogversion == VersionMap.get(DealId) && DW.Week == getWeek()) {
                this.dealMap.put(DW.getKey(), new Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>());
                this.grandTotalMap.put(DW.getKey(), new Map<String, Decimal>{
                        'Total Dollars' => 0.0, 'Total Rate' => 0.0, 'Total Clearance' => 0.0
                });
            }
        }

        //Add records in the query
        //Modified the query by Sanjay on 2/18/2016
        List<PrelogData__c> prelogData = prelogDataSelector.getPrelogDataForWeek(
                DealWrapperIdSet, tempSchedule.Week__c, prelogVersion);
        for (PrelogData__c d : prelogData) {
            //if(d.Schedule__r.Deal_Parent__c!=dealid) continue;
            if (d.Schedule__r.Deal_Parent__c == DealId) {
                scheduleIdSet.add(d.Schedule__c) ;
                //This maps each order line number to the prelog data for a given deal.
                Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper> prelogMap =
                        new Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>();
                if (this.dealMap.containsKey(d.Schedule__r.Deal_Parent__c + getWeek() + d.Version__c)) {
                    prelogMap = this.dealMap.get(d.Schedule__r.Deal_Parent__c + getWeek() + d.Version__c);
                }

                //This holds all of the information about the prelog data for a given day of the week.
                DoubleCheckReadOnlyHelper.PrelogDataWrapper w = new DoubleCheckReadOnlyHelper.PrelogDataWrapper(d);
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
                System.debug('$$$$' + d.Schedule__r.Deal_Parent__c + getWeek() + d.Version__c);
                System.debug('$$$$' + d.Day_of_Week__c + '$$$$' + totalRate);
                w.rateMap.put(d.Day_of_Week__c, totalRate);

                Decimal totalDollars = d.Schedule__r.Total_Dollars__c;
                Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;
                w.clearanceMap.put(d.Day_of_Week__c, clearance);
                w.unitClearanceMap.put(d.Day_of_Week__c, w.unitClearanceMap.get(d.Day_of_Week__c) + 1);
                w.unitsAvailableMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Available__c) ;
                w.unitsAiredMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Aired__c) ;

                //Update the inner, prelog map, and then the deal map.
                prelogMap.put(d.Schedule__r.OrderLineNumber__c, w);
                this.dealMap.put(d.Schedule__r.Deal_Parent__c + getWeek() + d.Version__c, prelogMap);
            }
        }


        for (DoubleCheckReadOnlyHelper.DealWrapper DW : this.DealWrapperList) {

            //if(DW.DealRecord.id!=dealId) continue ;
            if (!SelectedDealMap.containsKey(DW.DealRecord.Id)) continue ;
            for (Schedules__c s : SelectedDealMap.get(DW.DealRecord.Id).Schedules__r) {
                if (scheduleIdSet.contains(s.Id)) continue ;
                //This maps each order line number to the prelog data for a given deal.
                Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper> prelogMap =
                        new Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>();
                if (this.dealMap.containsKey(s.Deal_Parent__c + getWeek() + DW.prelogversion)) {
                    prelogMap = this.dealMap.get(s.Deal_Parent__c + getWeek() + DW.prelogversion);
                }
                //This holds all of the information about the prelog data for a given day of the week.
                DoubleCheckReadOnlyHelper.PrelogDataWrapper w =
                        new DoubleCheckReadOnlyHelper.PrelogDataWrapper(new PrelogData__c(Schedule__r = s));
                if (prelogMap.containsKey(s.OrderLineNumber__c)) {
                    w = prelogMap.get(s.OrderLineNumber__c);
                }

                Decimal totalRate = 0;
                Decimal totalDollars = s.Total_Dollars__c;
                Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;

                //Update the inner, prelog map, and then the deal map.
                prelogMap.put(s.OrderLineNumber__c, w);
                this.dealMap.put(s.Deal_Parent__c + getWeek() + DW.prelogversion, prelogMap);
            }
        }
        System.debug('####DealWrapperMap' + DealWrapperMap.keySet());
        //Calculate the totals for each prelog wrapper. 
        //Also, calculate the grand totals for each selected deal.
        for (String dealId1 : this.dealMap.keySet()) {
            //if(DealWrapperMap.containsKey(dealid1 ) && DealWrapperMap.get(dealid1 ).DealRecord.id==dealId){

            Decimal dealTotalDollars = 0.0;
            Decimal dealTotalRate = 0.0;
            Decimal dealTotalClearance = 0.0;

            System.debug('1####' + DealId);
            System.debug('1####prelogversion ' + prelogVersion);


            if (DealWrapperMap.containsKey(dealId1)) {
                System.debug('1####prelogversion ' + DealWrapperMap.get(dealId1).prelogversion);
                DealWrapperMap.get(dealId1).prelogversion = null;
                DealWrapperMap.get(dealId1).prelogversionMap.put(getWeek() + VersionMap.get(dealId1), null);
            }


            //if(dealid!=null && this.dealMap.containsKey(dealId+getWeek() + preLogVersion))
            for (DoubleCheckReadOnlyHelper.PrelogDataWrapper w : this.dealMap.get(dealId1).values()) {
                System.debug('1####w.prelogData.Version__c ' + w.prelogData.Version__c);
                w.calculateTotals();
                // MG added for setting the current PreLog Version
                if (DealWrapperMap.containsKey(dealId1) && w.prelogData.Version__c != null) {
                    DealWrapperMap.get(dealId1).prelogversion = String.valueOf(w.prelogData.Version__c);
                    DealWrapperMap.get(dealId1).prelogversionMap.put(
                            getWeek() + VersionMap.get(dealId1), String.valueOf(w.prelogData.Version__c));
                }

                dealTotalDollars += w.totalDollars;
                dealTotalRate += w.rate;
                dealTotalClearance = dealTotalDollars != 0.0 ? ((dealTotalRate / dealTotalDollars)).setScale(2) : 0.0;
            }

            if (DealWrapperMap.containsKey(dealId1)) {
                //DealWrapperMap.get(dealid ).DealRecord.Id + getWeek()+ DealWrapperMap.get(dealid ).preLogVersion;
                weekEntries += ',' + dealId1 ;
            }
            this.grandTotalMap.put(dealId1, new Map<String, Decimal>{
                    'Total Dollars' => dealTotalDollars,
                    'Total Rate' => dealTotalRate,
                    'Total Clearance' => dealTotalClearance
            });
        }

        //}
    }

    public void FillDealResultList() {
        DealResultList = new List<Deal__c>();

        // MG added for purpose of making Week/Dates unSelected when subsequent Week/Date is Selected
        SearchList = new List<String>();
        Map<Id, Deal__c> MapofFinalDeals = new Map<Id, Deal__c>();
        Map<Integer, Set<Id>> Accurancy = new Map<Integer, Set<Id>>();

        ReturnSOQLDateString();
        if (Searchfield != null && Searchfield != '') {
            SearchList = Searchfield.split(',');
            Period pr = getCurrentQuarter(tempSchedule.Week__c);
            DealResultList = dealSelector.getDealsFromSearchQuery(
                    SOQLDateString, SearchList, pr, BarterCheckbox, SelectedCableSynd, '200');
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Search field can not be null'));
        }
    }

    public List<Deal__c> getDealResult() {
        if (Searchfield != null && Searchfield != '') {
            //FillDealResultList();
            //DoSearch();
        }
        return DealResultList ;
    }

    public Period getCurrentQuarter(Date inputDate) {
        Integer no = (inputDate.month() / 4) + 1;
        Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueOf(inputDate.year()));
        return TempQuarterPeriodMap.get(no);
    }

    public void ClearAllButton() {
        try {
            DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
            DealWrapperIdSet = new Set<Id>();
            SelectedDealSet = '';
            SelectedDealMap.clear() ;
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    public List<String> getKeys() {
        List<String> ls = new List<String>();
        for (String str : DealWrapperMap.keySet()) {
            ls.add(str);
        }
        List<String> ls1 = new List<String>();
        Integer count = ls.size();

        for (Integer index = count - 1; index >= 0; index--) {
            ls1.add(ls[index]);
        }

        return ls1;
    }

    public void Display() {
        showtable = true;
        schedulemessage = false;
    }

    // MG added to get 1st Day of Week in specific format MM/DD/YYYY
    public String getWeek() {
        return String.valueOf(tempSchedule.Week__c.toStartOfWeek().month() + '/'
                + (tempSchedule.Week__c.toStartOfWeek().day() + 1) + '/' + tempSchedule.Week__c.toStartOfWeek().year());
    }

    // MG added for making section sort, last table selection derives at top
    public List<String> getWeekData() {
        List<String> fList = new List<String>(weekSet);
        List<String> finalList = new List<String>();
        for (Integer i = fList.size() - 1; i >= 0; i--) {

            finalList.add(fList[i]);

        }

        return finalList;

    }

    public void ReturnSOQLDateString() {
        try {
            if (SelectedDateLiteral != null && SelectedDateLiteral != '') {
                if (SelectedDateLiteral == 'Custom') {
                    if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null) {
                        SOQLDateString = ' AND ( Week_MIN_Field__c >= '
                                + DealUtils.ReturnStringDate(WeekStartDate.Day__c)
                                + ' AND Week_MIN_Field__c <= '
                                + DealUtils.ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
                    } else {
                        SOQLDateString = '';
                    }
                } else {
                    Map<String, CalendarPeriod> sel = DealUtils.getCustomCalendarPeriods(dates);
                    CalendarPeriod val = sel.get(SelectedDateLiteral);
                    if (val != null) {
                        if (val.setDates()) {
                            WeekStartDate.Day__c = val.weekStart;
                            WeekEndDate.Day__c = val.weekEnd;
                        }
                    }
                }

            }
            if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null) {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + DealUtils.ReturnStringDate(WeekStartDate.Day__c)
                        + ' AND Week_MIN_Field__c <= ' + DealUtils.ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
            } else {
                SOQLDateString = '';
            }
            System.debug('SOQLDateString  ' + SOQLDateString);
            System.debug('Start And End Dates - ' + WeekStartDate.Day__c + ' - ' + WeekEndDate.Day__c);
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    // Returns the Monday of this week for use in a soql query.
    public Date getMonday() {
        Date t = dates.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getMonday: daysBetween: ' + daysBetween);
        if ((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(1);
    }

    // Returns the Sunday of this week for use in a soql query.
    public Date getSunday() {
        Date t = dates.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getSunday: daysBetween: ' + daysBetween);
        if ((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(7);
    }
}