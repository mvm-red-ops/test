public virtual class DoubleCheckReadOnly {

    // Mocking Selectors
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

    public DateSelector dates = new DateSelector();

    public List<String> testlist;
    public Set<String> testset;
    public List<List<SObject>> DealSearchList;
    public List<DoubleCheckReadOnlyHelper.WeekModel> quarterweek { get; set; }
    public List<DoubleCheckReadOnlyHelper.HeadingModel> headingModels { get; set; }
    public List<Date> quarterdates { get; set; }
    public List<Deal__c> DealResultList { get; set; }
    public List<DoubleCheckReadOnlyHelper.DealWrapper> DealWrapperList { get; set; }
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
    public Date LowestDate { get; set; }
    public Date HighestDate { get; set; }
    public Date QuarterEndDate { get; set; }
    public String RemoveDealId { get; set; }
    public String SelectedDealSet { get; set; }
    public Boolean BarterCheckbox { get; set; }
    public String SelectedCableSynd { get; set; }
    public List<SelectOption> CableSyndSOList { get; set; }

    public Schedules__c WeekStartDate { get; set; }
    public Schedules__c WeekEndDate { get; set; }
    public List<SelectOption> DateLiteralSOList { get; set; }
    public String SelectedDateLiteral { get; set; }
    public String SOQLDateString { get; set; }

    //Maps each selected deal Id to a map that maps each order line number to the prelog data.
    public Map<String, Map<String, DoubleCheckReadOnlyHelper.PrelogDataWrapper>> dealMap { get; set; }

    //Maps each selected deal Id to a list of grand totals.
    public Map<String, Map<String, Decimal>> grandTotalMap { get; set; }

    public DoubleCheckReadOnly() {
        CableSyndSOList = DealUtils.ReturnCableSyndSOList();
        DateLiteralSOList = DealUtils.ReturnDateLiteralSOList();

        DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
        DealWrapperIdSet = new Set<Id>();
        WeekStartDate = new Schedules__c();
        WeekEndDate = new Schedules__c();
        selectAll = false;
        SaveDescision = '';
        SelectedDealSet = '';
        SelectedDateLiteral = '';
        SelectedCableSynd = '';
    }

    public virtual void DoSearch()
    {
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
                    SOQLDateString, SearchList, null, BarterCheckbox, SelectedCableSynd, null, '200');

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

    public virtual void SortDealResultList()
    {
        try
        {
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
            for (Integer i = DateSortList.size()-1 ; i >=0 ; i-- ) {
                if (DealDateList.containsKey(DateSortList[i])) {
                    DealResultList.addAll(DealDateList.get(DateSortList[i]));
                }
            }
            DealResultList.addAll(NoDateList);
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public virtual void AddMoreToDeal()
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
                List<DoubleCheckReadOnlyHelper.LineItemModel> ratelist = new List<DoubleCheckReadOnlyHelper.LineItemModel>();
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
                }
                List<Deal__c> DealList = [SELECT Id,Contact__c,ContactAccount__c, Contact__r.Name, Contact__r.AccountId, Contact__r.Account.Name,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c, Program__r.Name, Program__r.Reconciled_Week__c, Brands__c, Brands__r.Name, Name, Week_MIN_Field__c, Length__c,SF_Deal_ID__c FROM Deal__c WHERE Id =: DealId];
                if (DealList.size() > 0)
                {
                    ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c);
                    SelectedDeal = DealList[0];
                }
                Decimal TotalUnitsAired = 0;
                Decimal TotalUnitsAvailable = 0;
                Decimal TotalDollars = 0;
                Decimal TotalDollarsBooked = 0;
                for(String mapkeylist : testlist )
                {
                    List<Schedules__c> tempwraplist = schgroup.get(mapkeylist);
                    DoubleCheckReadOnlyHelper.LineItemModel Lm = new DoubleCheckReadOnlyHelper.LineItemModel();
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
                                        Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekModel(sow,weekMap.get(sow), true));
                                    }
                                    else
                                    {
                                        Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekModel(sow,weekMap.get(sow), false));
                                    }
                                }
                                else
                                {
                                    Lm.weeks.add(new DoubleCheckReadOnlyHelper.weekmodel(sow,tempwraplist[0].OrderNumber__c));
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
                for (DoubleCheckReadOnlyHelper.HeadingModel HM : DW.HeadingList)
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
                DealWrapperList.add(DW);
                DealWrapperIdSet.add(SelectedDeal.Id);
                SelectedDealSet += SelectedDeal.Id;
            }
        }
        catch(Exception e)
        {
            DealUtils.handleException(e);
        }
    }

    public virtual void RemoveDealButton()
    {
        try
        {
            if (RemoveDealId != null)
            {
                List<DoubleCheckReadOnlyHelper.DealWrapper> TempDealWrapper = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
                TempDealWrapper.addAll(DealWrapperList);
                DealWrapperList = new List<DoubleCheckReadOnlyHelper.DealWrapper>();
                DealWrapperIdSet = new Set<Id>();
                SelectedDealSet = '';
                for (DoubleCheckReadOnlyHelper.DealWrapper DW : TempDealWrapper)
                {
                    if (DW.DealRecord.Id != Id.valueOf(RemoveDealId))
                    {
                        DealWrapperList.add(DW);
                        DealWrapperIdSet.add(DW.DealRecord.Id);
                        SelectedDealSet += DW.DealRecord.Id;
                    }
                }
            }
        }
        catch(Exception e)
        {
            DealUtils.handleException(e);
        }
    }

    public virtual void ReturnSOQLDateString()
    {
        try {
            SOQLDateString = '';
            if (SelectedDateLiteral == 'Custom') {
                if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                    SOQLDateString =
                            ' AND ( Week_MIN_Field__c >= ' + DealUtils.ReturnStringDate(WeekStartDate.Week__c)
                                    + ' AND Week_MIN_Field__c <= ' + DealUtils.ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
                }
            }
            else {
                Map<String, CalendarPeriod> sel = DealUtils.getCustomCalendarPeriods(dates);
                CalendarPeriod val = sel.get(SelectedDateLiteral);
                if (val != null) {
                    if (val.setDates()) {
                        WeekStartDate.Week__c = val.weekStart;
                        WeekEndDate.Week__c = val.weekEnd;
                    }
                }
            }

            if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + DealUtils.ReturnStringDate(WeekStartDate.Week__c)
                        + ' AND Week_MIN_Field__c <= ' + DealUtils.ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
            }
        } catch (Exception e) {
            DealUtils.handleException(e);
        }
    }

    public virtual void Display()
    {
        showtable = true;
        schedulemessage = false;
    }

    public virtual List<DoubleCheckReadOnlyHelper.HeadingModel> ListOfDates(Date pAnchorDate, Date pReconciledDate)
    {
        try
        {
            //Red Argyle - #2791:Controller issues with atypical fiscal quarters
            Date AnchorDate = pAnchorDate;

            Period period = periodSelector.getQuarterPeriodFromDate(AnchorDate);
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
            headingModels  = new List<DoubleCheckReadOnlyHelper.HeadingModel>();
            quarterweek = new List<DoubleCheckReadOnlyHelper.WeekModel>();
            for(Date sow: quarterdates)
            {
                if (sow != null)
                {
                    DoubleCheckReadOnlyHelper.HeadingModel hm = new DoubleCheckReadOnlyHelper.HeadingModel();
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
            DealUtils.handleException(e);
        }
        return null;
    }
}