/**
 * DealUpdateExtension
 * @description Extension for handling updating selected Deal
 */

public class DealUpdateExtension {

    private DealRevisionController controller;

    // Mocking Selectors
    public DateSelector dates {get;set;}
    public DealSelector dealSelector {get;set;}
    public ScheduleSelector scheduleSelector {get;set;}
    public PeriodSelector periodSelector {get;set;}

    public Deal__c selectedDeal {get;set;}

    public DealUpdateExtension(DealRevisionController con) {
        this.controller = con;
        this.dates = new DateSelector();
        this.dealSelector = new DealSelector();
        this.scheduleSelector = new ScheduleSelector();
        this.periodSelector = new PeriodSelector();

        selectedDeal = null;
        SaveDescision = '';
        selectAll = false;

        // Setup Hiatus Data
        hiatusTimeOptions = DealUtils.createHiatusTimeSelectList();
        hiatusTempScheduleStart = new Schedules__c();
        hiatusTempScheduleEnd = new Schedules__c();
    }

//    public void updateDeal() {
//        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Updated deal!'));
//    }

    // Old Code

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

    public String cellrate {get; set;}
    public String cellUnits {get; set;}
    public String CellId {get; set;}

    public Decimal RateforCell {get; set;}
    public String SaveDescision {get; set;}
    public Boolean selectAll {get; set;}
    public Boolean schedulemessage {get; set;}
    public Boolean showtable {get; set;}
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
    public Map<Date, Schedules__c> weekMap { get; set;}
    public Map<Date, Boolean> DuplicateWeekMap { get; set;}
    public Date enddate;
    public Schedules__c WeekStartDate {get; set;}
    public Schedules__c WeekEndDate {get; set;}
    public String SelectedDateLiteral {get; set;}

    public List<String> WeekDollarsList {get; set;}
    public List<HeadingModel> HeadingList {get; set;}

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

    public String hiatusTimeBefore {get; set;}
    public String hiatusTimeAfter {get; set;}
    public List<SelectOption> hiatusTimeOptions {get; set;}
    public Schedules__c hiatusTempScheduleStart {get; set;}
    public Schedules__c hiatusTempScheduleEnd {get; set;}

    public Decimal currentRateModelIndex {get; set;}
    public String currentScheduleId {get; set;}

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

            List<Schedules__c> schlist = scheduleSelector.getSchedulesFromDeal(
                    selectedDeal.Id, controller.reconciledCheckbox);
            for (Schedules__c sch : schlist) {
                if(sch.OrderNumber__c != null) {
                    if(!tempRateSet.contains(sch.OrderNumber__c)) {
                        tempRateSet.add(sch.OrderNumber__c);
                    }
                    if(schgroup.containsKey(sch.OrderNumber__c)) {
                        List<Schedules__c> temp = schgroup.get(sch.OrderNumber__c);
                        temp.add(sch);
                        schgroup.put(sch.OrderNumber__c,temp);
                    } else {
                        List<Schedules__c> temp = new List<Schedules__c>();
                        temp.add(sch);
                        schgroup.put(sch.OrderNumber__c,temp);
                    }

                    if(sch.Cap__c != null) {
                        if(!tempCapSet.contains(sch.OrderNumber__c + sch.Cap__c)) {
                            tempCapSet.add(sch.OrderNumber__c + sch.Cap__c);
                        }
                        if(schCapGroup.containsKey(sch.OrderNumber__c + sch.Cap__c)) {
                            List<Schedules__c> temp = schCapGroup.get(sch.OrderNumber__c + sch.Cap__c);
                            temp.add(sch);
                            schCapGroup.put(sch.OrderNumber__c + sch.Cap__c, temp);
                        } else {
                            List<Schedules__c> temp = new List<Schedules__c>();
                            temp.add(sch);
                            schCapGroup.put(sch.OrderNumber__c + sch.Cap__c, temp);
                        }
                    }
                    if (!tempMaxSet.contains(sch.OrderNumber__c + sch.Max_Per_Day__c)) {
                        tempMaxSet.add(sch.OrderNumber__c + sch.Max_Per_Day__c);
                    }
                    if (schMaxGroup.containsKey(sch.OrderNumber__c + sch.Max_Per_Day__c)) {
                        List<Schedules__c> temp = schMaxGroup.get(sch.OrderNumber__c + sch.Max_Per_Day__c);
                        temp.add(sch);
                        schMaxGroup.put(sch.OrderNumber__c + sch.Max_Per_Day__c, temp);
                    } else {
                        List<Schedules__c> temp = new List<Schedules__c>();
                        temp.add(sch);
                        schMaxGroup.put(sch.OrderNumber__c + sch.Max_Per_Day__c, temp);
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

            List<Deal__c> DealList = dealSelector.getDealsFromId(selectedDeal.Id);
            if (DealList.size() > 0) {
                ListOfDates(DealList[0].Week_MIN_Field__c);
                selectedDeal = DealList[0];
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
                    if (weekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekMap.put(schtemp.Week__c, schtemp);
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
                    if (weekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekMap.put(schtemp.Week__c, schtemp);
                }

                capTabList.add(BuildRateModel(tempwraplist, mapkeylist));
            }

            for(String mapkeylist : maxSet)  {
                List<Schedules__c> tempwraplist = schMaxGroup.get(mapkeylist);

                weekMap = new Map<Date,Schedules__c>();
                DuplicateWeekMap = new Map<Date, Boolean>();
                for(Schedules__c schtemp : tempwraplist) {
                    if (weekMap.containsKey(schtemp.Week__c)) {
                        DuplicateWeekMap.put(schtemp.Week__c, true);
                    }
                    weekMap.put(schtemp.Week__c, schtemp);
                }

                maxTabList.add(BuildRateModel(tempwraplist, mapkeylist));
            }

            Display();

            for (HeadingModel HM : headingModels) {
                if (WeekDollarsMap.containsKey(HM.startOfWeek)) {
                    Decimal DollarAmount = WeekDollarsMap.get(HM.startOfWeek);
                    String StringAmount;
                    if (DollarAmount < 1000) {
                        StringAmount =  '$' + String.valueOf(DollarAmount);
                        StringAmount = StringAmount.replace('.00','');
                    } else {
                        DollarAmount = DollarAmount.setScale(0);
                        DollarAmount = DollarAmount/1000.0;
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
            DealUtils.handleException(e);
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
        if(rateList.size() == 0 ) {
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

            Period period = periodSelector.getQuarterPeriodFromDate(AnchorDate);
            Date StartOfQuarter = period.StartDate;
            Date EndOfQuarter = period.EndDate;
            QuarterEndDate = period.EndDate;

            if (HighestDate > EndOfQuarter) {
                EndOfQuarter = HighestDate;
            }
            if (AnchorDate > EndOfQuarter) {
                ListOfDates(AnchorDate.addDays(7));
            }
            quarterdates = new List<Date>();
            while (StartOfQuarter <= EndOfQuarter) {
                quarterdates.add(StartOfQuarter);
                enddate = StartOfQuarter;
                StartOfQuarter = StartOfQuarter.addDays(7);
            }
            //quarterdates.add(enddate);
            headingModels  = new List<HeadingModel>();
            quarterweek = new List<WeekModel>();
            for(Date sow: quarterdates) {
                if (sow != null) {
                    HeadingModel hm = new HeadingModel();
                    hm.startOfWeek = sow;
                    System.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (sow >= LowestDate));
                    if (sow >= LowestDate) {
                        headingModels.add(hm);
                    }
                }
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void ScheduleChange() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : LTClist ) {
                if(rate.isChecked) {
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Past weeks cannot be cancelled'));
                        } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                            + 'beyond the last week of the quarter'));
                        } else {
                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                    Deal__c = selectedDeal.Id,
                                    Tab__c = 'LTC'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    if(weekobj.schObj.Week__c == rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1)) {
                                        schtoupdate.add(ScheduleHiatus.hiatusDateRange(
                                                new List<Schedules__c>{weekobj.schObj},
                                                rate.Scheduleobj.Week__c.addDays(1),
                                                weekobj.schObj.Week__c.addDays(6))[0]);
                                    } else if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                            && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1) ) {
                                        weekobj.schObj.Status__c  = 'Canceled';
                                        schtoupdate.add(weekobj.schObj);

                                        scheduleNames.add(weekobj.schObj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
                                            change.Original_Rate__c = weekobj.schObj.Rate__c;
                                            change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                            change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                            change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                            change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                            change.Original_Cap__c = weekobj.schObj.Cap__c;
                                            change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                        } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
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
            DealUtils.handleException(e);
        }
    }

    public void RateUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : rateList) {
                System.debug('rate 501 - ' + rate.OrderLineNumber);
                if(rate.isChecked) {
                    System.debug('rate 504 checked - ' + rate.OrderLineNumber + ' - '
                            + rate.rate + ' - ' + rate.Scheduleobj.Week__c);
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    Apexpages.Severity.ERROR, 'The rate cannot be updated for past weeks'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(
                                rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                        } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend'
                                            + ' beyond the last week of the quarter'));
                        } else {
                            System.debug('rate 508 Day not null - ' + rate.OrderLineNumber);

                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                    Deal__c = selectedDeal.Id,
                                    Tab__c = 'Rate'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    System.debug('rate 514 schobj not null - ' + rate.OrderLineNumber
                                            + ' - ' + weekobj.schObj.Id);
                                    if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                            && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                        if(change.Original_Rate__c == null) {
                                            change.Original_Rate__c = weekobj.schObj.Rate__c;
                                            change.Changed_Rate__c = Decimal.valueOf(rate.rate);

                                            change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                            change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                            change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                            change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                            change.Original_Cap__c = weekobj.schObj.Cap__c;
                                            change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                        }

                                        weekobj.schObj.Rate__c = Decimal.valueOf(rate.rate);
                                        System.debug('Rate updated - ' + weekobj.schObj.Id
                                                + ' - ' + weekobj.schObj.Rate__c);
                                        schtoupdate.add(weekobj.schObj);

                                        scheduleNames.add(weekobj.schObj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
                                        } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
                                        }

                                        if(change.Week_End__c == null) {
                                            change.Week_End__c = weekobj.schObj.Week__c;
                                        } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                            change.Week_End__c = weekobj.schObj.Week__c;
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
            System.debug('schtoupdate size - ' + schtoupdate.size());

            if(changes.size() > 0) {
                insert changes;
            }

            SearchforSchedules();
            SaveDescision  = '';
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void UnitsAvailableUpdate() {
        try {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : UnitsAvailableList) {
                if(rate.isChecked) {
                    if(rate.Scheduleobj.Week__c != null ) {
                        if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    Apexpages.Severity.ERROR, 'Units Available cannot be updated for past weeks'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(
                                rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                        } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                            + 'beyond the last week of the quarter'));
                        } else {
                            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                    Deal__c = selectedDeal.Id,
                                    Tab__c = 'Frequency'
                            );
                            List<String> scheduleNames = new List<String>();

                            for(WeekModel weekobj :rate.weeks) {
                                if(weekobj.schObj != null) {
                                    if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                            && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
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

                                        weekobj.schObj.Units_Available__c = Decimal.valueOf(rate.UnitsAvailable);
                                        schtoupdate.add(weekobj.schObj);

                                        scheduleNames.add(weekobj.schObj.Name);
                                        if(change.Week_Start__c == null) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
                                        } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                            change.Week_Start__c = weekobj.schObj.Week__c;
                                        }

                                        if(change.Week_End__c == null) {
                                            change.Week_End__c = weekobj.schObj.Week__c;
                                        } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                            change.Week_End__c = weekobj.schObj.Week__c;
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
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void ExtensionUpdate() {
        try {
            List<Schedules__c> NewSchedulesToInsert = new List<Schedules__c>();
            List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
            for(RateModel rate : ExtensionList ) {
                if(rate.isChecked) {
                    System.debug('rate.Scheduleobj.Week__c - ' + rate.Scheduleobj.Week__c);
                    if(rate.Scheduleobj.Week__c != null ) {
                        System.debug('date values - ' + rate.Scheduleobj.Week__c + ' - ' + rate.HighestDate);
                        if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Extensions cannot be created for past weeks'));
                        } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'Extensions cannot be created for weeks that extend '
                                            + 'beyond the last week of the quarter'));
                        } else if (!rate.Scheduleobj.Week__c.isSameDay(
                                rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                            ApexPages.addMessage(new ApexPages.Message(
                                    ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                        } else {
                            if (rate.Scheduleobj.Week__c > rate.HighestDate ) {
                                Boolean ScheduleFound = false;
                                Integer WeekSize = rate.weeks.size() - 1;
                                Schedules__c CloneSchedule;
                                while (!ScheduleFound) {
                                    if (rate.weeks[WeekSize].schObj != null) {
                                        ScheduleFound = true;
                                        CloneSchedule = rate.weeks[WeekSize].schObj;
                                    } else {
                                        WeekSize = WeekSize - 1;
                                    }
                                }
                                System.debug('comes inside end date - ' + enddate + ' - ' + QuarterEndDate);
                                if (CloneSchedule != null) {
                                    if (CloneSchedule.Week__c.addDays(7) <= rate.Scheduleobj.Week__c) {
                                        //Change the Date.TOday().ToStartOfWeek().addDays(1) to HighestDate

                                        Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                                                Deal__c = selectedDeal.Id,
                                                Tab__c = 'Extend',
                                                Week_Start__c = CloneSchedule.Week__c.addDays(7),
                                                Original_Rate__c = CloneSchedule.Rate__c,
                                                Original_Daypart__c = CloneSchedule.MGM_HD_Daypart__c,
                                                Original_Days_Allowed__c = CloneSchedule.Days_Allowed__c,
                                                Original_Start_End_Time__c = CloneSchedule.Start_End_Time__c,
                                                Original_Units_Available__c = CloneSchedule.Units_Available__c,
                                                Original_Cap__c = CloneSchedule.Cap__c,
                                                Original_Max_Per_Day__c = CloneSchedule.Max_Per_Day__c
                                        );
                                        List<String> scheduleNames = new List<String>();

                                        for (Date StartDate = CloneSchedule.Week__c.addDays(7);
                                                StartDate <= rate.Scheduleobj.Week__c && StartDate <= QuarterEndDate;
                                                StartDate = StartDate.addDays(7)) {
                                            System.debug('Schedule Created - ' + StartDate);
                                            System.debug('CloneSchedule values - ' + CloneSchedule.Name
                                                    + ' - ' + CloneSchedule.Week__c);
                                            SObject NewScheduleObj = (SObject)(CloneSchedule).clone(
                                                    false, false, false);
                                            Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);
                                            NewSCHRecord.Total_Schedules__c  = '0';
                                            NewSCHRecord.SI_Number_if_Billed__c = null;
                                            NewSCHRecord.Reviewed_for_Invoicing__c = false;
                                            NewSCHRecord.Intacct_SI_Number__c = null;
                                            NewSCHRecord.Units_Preempted__c = null;
                                            NewSCHRecord.Status__c = 'Sold';
                                            NewSCHRecord.ISCI_CODE__c = null;
                                            NewSCHRecord.X800_Number__c = null;
                                            NewSCHRecord.Days_of_Air__c = null;
                                            NewSCHRecord.Pod__c = null;
                                            NewSCHRecord.LF_traffic__c = null;
                                            NewSCHRecord.Comments__c = null;
                                            NewSCHRecord.Error_Cost__c = null;
                                            NewSCHRecord.Error_Logged_To__c = null;
                                            NewSCHRecord.Error_Reason__c = null;
                                            NewSCHRecord.Discrepancy_Comment__c = null;
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
            DealUtils.handleException(e);
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
                if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(
                            Apexpages.Severity.ERROR, 'The Test checkbox cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                    + 'beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                            Deal__c = selectedDeal.Id,
                            Tab__c = 'Test'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.Week__c == rate.Scheduleobj.Week__c
                                    && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                weekobj.schObj.TEST__c = true;

                                // For some reason, the Days_Allowed__c field is not binding to the page.
                                // This current workaround writes the days allowed value to an property
                                // when the weekobj is instantiated. Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schObj);

                                scheduleNames.add(weekobj.schObj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
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
        } catch(Exception e) {
            DealUtils.handleException(e);
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
                if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(
                            Apexpages.Severity.ERROR, 'The Ghost Order checkbox cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                    + 'beyond the last week of the quarter'));
                } else {
                    for(WeekModel weekobj :rate.weeks) {
                        System.debug(weekobj);
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                    && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                weekobj.schObj.Ghost_Order__c = true;

                                // For some reason, the Days_Allowed__c field is not binding to the page.
                                // This current workaround writes the days allowed value to a property
                                // when the weekobj is instantiated. Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schObj);
                            }
                        }
                    }
                }
            }

            update schtoupdate;
            SearchforSchedules();
            SaveDescision = '';
        } catch(Exception e) {
            DealUtils.handleException(e);
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
                if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(
                            Apexpages.Severity.ERROR, 'The Cap__c picklist cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                    + 'beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                            Deal__c = selectedDeal.Id,
                            Tab__c = 'Cap'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        System.debug('*** capTabUpdate: weekobj:' + weekobj) ;
                        System.debug(weekobj);
                        if(weekobj.schObj != null) {
                            System.debug('*** capTabUpdate: weekobj SchObj !null:' + weekobj.schObj) ;
                            if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                    && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                System.debug('*** capTabUpdate: weekobj correct week:') ;

                                if(change.Original_Cap__c == null) {
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Changed_Cap__c = rate.Scheduleobj.Cap__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                }

                                weekobj.schObj.Cap__c = rate.Scheduleobj.Cap__c;

                                // For some reason, the Days_Allowed__c field is not binding to the page.
                                // This current workaround writes the days allowed value to a property
                                // when the weekobj is instantiated. Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schObj);

                                scheduleNames.add(weekobj.schObj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
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
        } catch(Exception e) {
            DealUtils.handleException(e);
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

                if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(
                            Apexpages.Severity.ERROR, 'Cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                    + 'beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                            Deal__c = selectedDeal.Id,
                            Tab__c = 'Daypart'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        if(weekobj.schObj != null) {
                            if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                    && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                System.debug(LoggingLevel.ERROR, weekobj.schObj.Id + ' ==> ' + weekobj.schObj.Week__c);

                                schtoupdate.add(new Schedules__c(
                                        Id=weekobj.schObj.Id,
                                        Networks__c=rate.Scheduleobj.Networks__c,
                                        MGM_HD_Daypart__c=rate.Scheduleobj.MGM_HD_Daypart__c,
                                        Start_Time__c=rate.Scheduleobj.Start_Time__c,
                                        End_Time__c=rate.Scheduleobj.End_Time__c,
                                        Days_Allowed__c=rate.Scheduleobj.Days_Allowed__c
                                ));
                                System.debug(schtoupdate);

                                if(change.Original_Daypart__c == null) {
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Changed_Daypart__c = rate.Scheduleobj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Changed_Days_Allowed__c = rate.Scheduleobj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Changed_Start_End_Time__c = rate.Scheduleobj.Start_Time__c + '-'
                                            + rate.Scheduleobj.End_Time__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                }

                                scheduleNames.add(weekobj.schObj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
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
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void HiatusUpdate() {
        try {
            if(hiatusTempScheduleStart.Week__c == null) {
                ApexPages.addMessage(new ApexPages.Message(
                        Apexpages.Severity.ERROR, 'Must at least fill in a Start Date for the Hiatus'));
            } else if(hiatusTempScheduleStart.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                ApexPages.addMessage(new ApexPages.Message(
                        Apexpages.Severity.ERROR, 'Cannot be updated for past weeks'));
            } else if(hiatusTempScheduleEnd.Week__c != null
                    && hiatusTempScheduleEnd.Week__c < hiatusTempScheduleStart.Week__c) {
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 'Hiatus End Date must come after Hiatus Start Date'));
            } else {
                List<Schedules__c> schedulesToUpdate;
                List<Schedules__c> schlist = scheduleSelector.getSchedulesFromDeal(
                        selectedDeal.Id, controller.reconciledCheckbox);
                if(hiatusTempScheduleEnd.Week__c != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusDateRange(
                            schlist, hiatusTempScheduleStart.Week__c, hiatusTempScheduleEnd.Week__c);
                } else if(hiatusTimeAfter != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusTimeAfter(
                            schlist, hiatusTempScheduleStart.Week__c, hiatusTimeAfter);
                } else if(hiatusTimeBefore != null) {
                    schedulesToUpdate = ScheduleHiatus.hiatusTimeBefore(
                            schlist, hiatusTempScheduleStart.Week__c, hiatusTimeBefore);
                } else {
                    schedulesToUpdate = ScheduleHiatus.hiatusSingleDay(
                            schlist, hiatusTempScheduleStart.Week__c);
                }

                if(schedulesToUpdate != null && schedulesToUpdate.size() > 0) {
                    upsert schedulesToUpdate;
                }

                SearchforSchedules();
                SaveDescision  = '';
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
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
                if (rate.Scheduleobj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                    ApexPages.addMessage(new ApexPages.Message(
                            Apexpages.Severity.ERROR, 'The Max_Per_Day__c picklist cannot be updated for past weeks'));
                } else if (!rate.Scheduleobj.Week__c.isSameDay(rate.Scheduleobj.Week__c.toStartOfWeek().addDays(1))) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'The selected date must be a Monday.'));
                } else if (rate.Scheduleobj.Week__c > QuarterEndDate) {
                    ApexPages.addMessage(new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Cannot select dates for weeks that extend '
                                    + 'beyond the last week of the quarter'));
                } else {
                    Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                            Deal__c = selectedDeal.Id,
                            Tab__c = 'Max'
                    );
                    List<String> scheduleNames = new List<String>();

                    for(WeekModel weekobj :rate.weeks) {
                        System.debug('*** maxTabUpdate: weekobj:' + weekobj) ;
                        System.debug(weekobj);
                        if(weekobj.schObj != null) {
                            System.debug('*** maxTabUpdate: weekobj SchObj !null:' + weekobj.schObj) ;
                            if(weekobj.schObj.Week__c >= rate.Scheduleobj.Week__c
                                    && weekobj.schObj.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
                                System.debug('*** maxTabUpdate: weekobj correct week:') ;

                                if(change.Original_Max_Per_Day__c == null) {
                                    change.Original_Max_Per_Day__c = weekobj.schObj.Max_Per_Day__c;
                                    change.Changed_Max_Per_Day__c = rate.Scheduleobj.Max_Per_Day__c;

                                    change.Original_Rate__c = weekobj.schObj.Rate__c;
                                    change.Original_Daypart__c = weekobj.schObj.MGM_HD_Daypart__c;
                                    change.Original_Days_Allowed__c = weekobj.schObj.Days_Allowed__c;
                                    change.Original_Start_End_Time__c = weekobj.schObj.Start_End_Time__c;
                                    change.Original_Units_Available__c = weekobj.schObj.Units_Available__c;
                                    change.Original_Cap__c = weekobj.schObj.Cap__c;
                                }

                                weekobj.schObj.Max_Per_Day__c = rate.Scheduleobj.Max_Per_Day__c;
                                System.debug('Max per day ' + weekobj.schObj.Max_Per_Day__c);

                                // For some reason, the Days_Allowed__c field is not binding to the page.
                                // This current workaround writes the days allowed value to a property
                                // when the weekobj is instantiated. Now, we just copy it back into the sObject.
                                weekobj.schObj.Days_Allowed__c = weekobj.daysAllowed;

                                schtoupdate.add(weekobj.schObj);

                                scheduleNames.add(weekobj.schObj.Name);
                                if(change.Week_Start__c == null) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c < change.Week_Start__c) {
                                    change.Week_Start__c = weekobj.schObj.Week__c;
                                }

                                if(change.Week_End__c == null) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
                                } else if (weekobj.schObj.Week__c > change.Week_End__c) {
                                    change.Week_End__c = weekobj.schObj.Week__c;
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
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void cellsave() {
        try {
            if( (CellId != null && CellId != '') && (cellrate != null && cellrate != '') ) {
                Schedules__c schtoupdate = new Schedules__c(Id = CellId);
                schtoupdate.Rate__c = Decimal.valueOf(cellrate);
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void TestChecksave() {
        try {
            if( (CellId != null && CellId != '') && (selectedTest != null && selectedTest != '') ) {
                Schedules__c schtoupdate = new Schedules__c(Id = CellId);
                schtoupdate.TEST__c = Boolean.valueOf(selectedTest);
                upsert schtoupdate;
                SearchforSchedules();
                selectedTest ='';
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void GhostChecksave() {
        try {
            if( (CellId != null && CellId != '') && (selectedGhost != null && selectedGhost != '') ) {
                Schedules__c schtoupdate = new Schedules__c(Id = CellId);
                schtoupdate.Ghost_Order__c = Boolean.valueOf(selectedGhost);
                upsert schtoupdate;
                SearchforSchedules();
                selectedGhost ='';
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void UnitsAvailableSave() {
        try {
            if( (CellId != null && CellId != '') && (cellUnits != null && cellUnits != '') ) {
                Schedules__c schtoupdate = new Schedules__c(Id = CellId);
                schtoupdate.Units_Available__c = Decimal.valueOf(cellUnits);
                upsert schtoupdate;
                SearchforSchedules();
                cellUnits ='';

            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void LTCsave() {
        try {
            if( (CellId != null && CellId != '') ) {
                Schedules__c schtoupdate = scheduleSelector.getScheduleFromId(CellId);
                if (schtoupdate.Status__c == 'Canceled') {
                    schtoupdate.Status__c = 'Sold';
                } else {
                    schtoupdate.Status__c = 'Canceled';
                }
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void ExtensionSave() {
        try {
            if (SelectedExtensionDate != null && SelectedOrderLineNumber != null && SelectedOrderLineNumber != '') {
                List<String> StrList = SelectedExtensionDate.split('-');
                Date WeekDate = Date.newInstance(
                        Integer.valueOf(StrList[0]), Integer.valueof(StrList[1]), Integer.valueOf(StrList[2]));
                String ScheduleQuery = 'select ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c')
                        + ' from Schedules__c where OrderNumber__c = \'' + SelectedOrderLineNumber
                        + '\' AND Week__c < ' + SaberGF.formatDate(WeekDate, 'FQD') + ' ORDER BY Week__c DESC Limit 1';
                System.debug('ScheduleQuery - ' + ScheduleQuery);
                List<Schedules__c> SchedulesList = Database.query(ScheduleQuery);
                if (SchedulesList.size() > 0) {
                    if (StrList.size() == 3) {
                        SObject NewScheduleObj = (SObject)(SchedulesList[0]).clone(false, false, false);
                        Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);

                        System.debug('Duplicate Check 1 - ' + NewSCHRecord.Duplicate_Check_1a__c
                                + ' - ' + NewSCHRecord.Duplicate_Check__c);
                        NewSCHRecord.Total_Schedules__c  = '0';
                        NewSCHRecord.SI_Number_if_Billed__c = null;
                        NewSCHRecord.Reviewed_for_Invoicing__c = false;
                        NewSCHRecord.Intacct_SI_Number__c = null;
                        NewSCHRecord.Units_Preempted__c = null;
                        NewSCHRecord.Status__c = 'Sold';
                        NewSCHRecord.ISCI_CODE__c = null;
                        NewSCHRecord.X800_Number__c = null;
                        NewSCHRecord.Days_of_Air__c = null;
                        NewSCHRecord.Pod__c = null;
                        NewSCHRecord.LF_traffic__c = null;
                        NewSCHRecord.Comments__c = null;
                        NewSCHRecord.Error_Cost__c = null;
                        NewSCHRecord.Error_Logged_To__c = null;
                        NewSCHRecord.Error_Reason__c = null;
                        NewSCHRecord.Discrepancy_Comment__c = null;
                        NewSCHRecord.Week__c = WeekDate;
                        NewSCHRecord.Duplicate_Check__c= null;
                        System.debug('Duplicate Check 2 - ' + NewSCHRecord.Duplicate_Check_1a__c
                                + ' - ' + NewSCHRecord.Duplicate_Check__c);
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
            DealUtils.handleException(e);
        }
    }

    public void cellcancel() {
        SearchforSchedules();
    }

    public class HeadingModel {
        public String cols{get; set;}
        public Date startOfWeek {get; set;}
    }

    //Copy the RateModel schedules's dependent fields into each associated WeekModel schedule.
    public void updateWeeks() {
        List<Schedules__c> schedulesToUpdate = new List<Schedules__c>();
        Schedules__c mainSch = this.dayPartTabList[Integer.valueOf(this.currentRateModelIndex)].Scheduleobj;
        System.debug(LoggingLevel.ERROR, 'Main Schedule ==> ' + mainSch);
        System.debug(LoggingLevel.ERROR, 'Current Index ==> ' + this.currentRateModelIndex);
        System.debug(LoggingLevel.ERROR, 'Day Part Tab List ==> ' + this.dayPartTabList);
        for (WeekModel week : this.dayPartTabList[Integer.valueOf(this.currentRateModelIndex)].weeks) {
            System.debug(LoggingLevel.ERROR, 'Week ==> ' + week.schObj);
            Schedules__c sch = week.schObj;
            if (sch != null) {
                if (sch.Week__c >= dates.today().toStartOfWeek().addDays(1)) {
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
            DealUtils.handleException(e);
        }
    }

    public void updateSchedule() {
        Id test;
        try {
            for (RateModel rate : this.dayPartTabList) {
                for (WeekModel week : rate.weeks) {
                    if (week.schObj != null && this.currentScheduleId != null) {
                        if (String.valueOf(week.schObj.Id) == this.currentScheduleId) {
                            if (week.schObj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                                ApexPages.addMessage(new ApexPages.Message(
                                        Apexpages.Severity.ERROR, 'Past week\'s schedules cannot be updated.'));
                            } else {
                                //DML is okay inside of this loop.
                                //Since we are checking for a specific ID, we can only get here once.
                                //week.schobj.Days_Allowed__c = this.getDaysAllowedString(week.schobj.Days_Allowed__c);
                                update week.schObj;
                            }
                        }
                    }
                }
            }
            SearchforSchedules();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR,'Loop schedule Id ==> ' + test));
            ApexPages.addMessage(new ApexPages.Message(
                    ApexPages.Severity.ERROR,'Schedule Id ==> ' + this.currentScheduleId));
            DealUtils.handleException(e);
        }
    }

    public RateModel BuildRateModel(List<Schedules__c> tempwraplist, String mapkeylist) {
        RateModel rm = new rateModel() ;

        rm.OrderLineNumber = mapkeylist;

        Schedules__c obj = new Schedules__c();
        List<String> fieldList = SaberGF.getObjectsFieldsForQueriesFromFieldSet('Schedules__c', 'Deal_Revision');
        List<String> uneditable = new List<String>{'Name', 'BGColor__c', 'Reconciled__c', 'Dollars_Booked__c',
                'Days_Allowed_Formula__c', 'DaysAllowedFormula__c', 'Start_End_Time__c', 'UnitLength__c',
                'Total_Dollars__c', 'Units_Aired__c'};
        for (String field : fieldList) {
            if ( !uneditable.contains(field)) {
                obj.put(field, tempwraplist[0].get(field));
            }
        }
        obj.Week__c = null;
        rm.Scheduleobj = obj;

        if(tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null) {
            rm.rate = String.valueOf(tempwraplist[0].Rate__c);
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
                RMHighestDate = sch.Week__c;
            }
            if(sch.Week__c >= dates.today().toStartOfWeek().addDays(1) ) {
                if (sch.TEST__c == true)  {
                    rm.Test = true;
                }
                if (sch.Ghost_Order__c == true)  {
                    rm.Ghost = true;
                }
                if (sch.Cap__c != null)  {
                    rm.Scheduleobj.Cap__c = sch.Cap__c;
                }
                if (sch.Max_Per_Day__c != null) {
                    rm.Scheduleobj.Max_Per_Day__c = sch.Max_Per_Day__c;
                }
            }
        }
        rm.LowestDate = RMLowestDate;
        rm.HighestDate = RMHighestDate;
        rm.HighestDate = RMHighestDate;

        for(Date sow: quarterdates) {
            if (sow != null) {
                if (sow >= LowestDate) {
                    if(weekMap.containsKey(sow)) {
                        if (DuplicateWeekMap.containsKey(sow)) {
                            rm.weeks.add(new weekModel(sow,weekMap.get(sow), true, dates));
                        } else {
                            rm.weeks.add(new weekModel(sow,weekMap.get(sow), false, dates));
                        }
                    } else {
                        rm.weeks.add(new weekmodel(sow,tempwraplist[0].OrderNumber__c, dates));
                    }
                }
            }
        }
        return rm ;
    }

    public class RateModel  {
        public Boolean isChecked {get; set;}
        public String rate {get; set;}
        public String OrderLineNumber {get; set;}
        public String DaysAllowed {get; set;}
        public String SETime {get; set;}
        public Decimal UnitLength  {get; set;}
        public List<WeekModel> weeks {get; set;}
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
            weeks = new List<WeekModel>();
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
        public weekModel(Date pstartOfWeek , Schedules__c pschObj, Boolean pMultipleSchedules, DateSelector dates) {
            MultipleSchedules = pMultipleSchedules;
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-' + String.valueOf(pstartOfWeek.month())
                    + '-' + String.valueOf(pstartOfWeek.day());
            ExtensionAvailable = false;
            CellAvailable = true;
            startOfWeek = pstartOfWeek;
            schObj = pschObj;
            daysAllowed = pschObj.Days_Allowed__c;
            if(schObj.Status__c == 'Canceled') {
                color ='red';
            } else if(schObj.TEST__c == true) {
                color='blue';
            } else {
                color='black';
            }

            if (schObj.Ghost_Order__c == true) {
                ghostColor = 'grey';
            } else {
                ghostColor = 'black';
            }

            if (pschObj.Week__c < dates.today().toStartOfWeek().addDays(1)) {
                CellAvailable = false;
            }
        }

        public weekmodel(Date pstartOfWeek, String pOrderLineNumber, DateSelector dates) {
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-' + String.valueOf(pstartOfWeek.month())
                    + '-' + String.valueOf(pstartOfWeek.day());
            startOfWeek = pstartOfWeek;
            CellAvailable = false;
            if (pstartOfWeek >= dates.today().toStartOfWeek().addDays(1)) {
                ExtensionAvailable = true;
            } else {
                ExtensionAvailable = false;
            }
            OrderLineNumber = pOrderLineNumber;
        }
    }
}