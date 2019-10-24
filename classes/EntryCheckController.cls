public class EntryCheckController {
    public List<Schedules__c> scheduleList { get; set; }
    public List<EntryCheckHelper.FBEntryModel> fbEntryModelList { get; set; }
    public List<EntryCheckHelper.FBModels> fbModel { get; set; }    //All data, one row represented by one List element
    public Map<String, List<EntryCheckHelper.FBEntryModel>> fbEntryModelMap { get; set; }
    public Integer count;
    public String range { get; set; }
    public List<EntryCheckHelper.HeadingModel> headingModels { get; set; }
    public Map<Integer, String> daysMap;
    public Map<Integer, String> daysMapFull;
    public String dealProgram { get; set; }
    public Decimal sumGrandTotal { get; set; }
    public Integer totalCount { get; set; }
    List <String> keys;
    List <Date> dKeys;
    public Schedules__c sDate { set; get; }
    public Schedules__c eDate { set; get; }
    public Contact con { get; set; } //
    public Deal__c deal { get; set; }
    public List<String> lstDayOfWeek { set; get; }

    public Date fromDate { get; set; }
    public Date toDate { get; set; }

    public String sch { get; set; }
    public String sid { get; set; }
    public String slf { get; set; }
    public String sWeek { get; set; }
    public Schedules__c oldScheduleObj;
    public Schedules__c scheduleObj { get; set; }
    public List<Deal__c> lstDealAccount { set; get; }

    public Integer fYear { set; get; }
    public Integer fMonth { set; get; }

    public Integer activeFilter { set; get; } //0-None, 1-Month, 2-Dates

    public List <EntryCheckHelper.ModelTotals> totals { set; get; }
    public List<SelectOption> items { get; set; }
    public String months { get; set; }

    public Boolean checks { set; get; }
    public Boolean hasRecords { set; get; } //used to display Table or not
    public Boolean missingProgram { set; get; }

    public String AccountName { set; get; }
    //They will be passed as argument to DOCFilterByDealAccount page
    public String dealFMonth { set; get; }
    public String dealFYear { set; get; }

    public EntryCheckController() {
        //Fetching the Previously applied Filter
        sumGrandTotal = 0;
        totalCount = 0;

        missingProgram = false;
        hasRecords = false;
        con = new Contact();
        deal = new Deal__c();
        AccountName = '';

        sDate = new Schedules__c();
        eDate = new Schedules__c();
        sDate.Week__c = Date.today().toStartOfWeek().addDays(1);
        eDate.Week__c = Date.today().toStartOfWeek().addDays(7);

    }

    public PageReference search() {
        if (deal.Program__c == null) {
            missingProgram = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Deal Program is Required.'));
            return null;
        } else {
            if (sDate.Week__c == null) {
                sDate.Week__c = Date.today().toStartOfWeek().addDays(1);
            }
            eDate.Week__c = sDate.Week__c.addDays(6);
            showReport();
            PageReference pg = new PageReference('/apex/EntryCheckReport');
            return pg;
        }
    }

    public PageReference showReport() {
        sumGrandTotal = 0;
        totalCount = 0;
        String dealKeyword;
        if (deal.Program__c == null) {
            missingProgram = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Deal Program is Required.'));
            return null;
        } else {
            String programID = deal.Program__c;
            List<Programs__c> progList = [SELECT Id, Name FROM Programs__c WHERE Id = :programID];
            if (progList.size() > 0) {
                Programs__c prog = progList.get(0);
                dealProgram = prog.Name;
            }
        }
        if (sDate.Week__c != null) {
            fromDate = sDate.Week__c;
        } else {
            fromDate = Date.today().toStartOfWeek().addDays(1);
            sDate.Week__c = fromDate;
        }
        if (eDate.Week__c != null) {
            toDate = eDate.Week__c;
        } else {
            toDate = fromDate.addDays(6);
            eDate.Week__c = toDate;
        }

        if (con.AccountId != null) {
            String accountId = con.AccountId;

            List<Account> accList = [SELECT Id,Name FROM Account WHERE Id = :accountId];

            if (accList.size() > 0) {
                Account acc = accList.get(0);
                dealKeyword = acc.Name;
            }
        }

        System.debug('******' + fromDate + '***' + toDate);
        count = 0;
        loadDaysMap();
        loadDaysMapFull();
        headingModels = new List<EntryCheckHelper.HeadingModel>();

        scheduleList = new List<Schedules__c>();
        fbEntryModelList = new List<EntryCheckHelper.FBEntryModel>();
        fbEntryModelMap = new Map<String, List<EntryCheckHelper.FBEntryModel>>();
        fbModel = new List<EntryCheckHelper.FBModels>();

        Date weekStart = fromDate.toStartOfWeek().addDays(1);

        dealFMonth = String.valueOf(toDate.month());
        dealFYear = String.valueOf(toDate.year());

        Integer startDate = weekStart.daysBetween(fromDate);
        System.debug('### FD == ' + fromDate);
        System.debug('### TD == ' + toDate);
        if (dealKeyword == null) {
            scheduleList = [
                    SELECT Id,Name,X2Calculated_Time_Period__c,LF_Daypart__c,Rate__c,LF_Week__c,
                            Long_Form__c,LF_Brand__c,X800_Number__c,Day_of_Week__c,Week__c, DealBrand__c,
                            DealAccount__c,Deal_Parent__r.Contact__r.AccountId
                    FROM Schedules__c
                    WHERE DealProgram__c LIKE :dealProgram
                    AND Week__c >= :fromDate
                    AND Week__c <= :toDate
                    AND COUNTMENOT__c = 'y'
                    AND Status__c != 'Canceled'
                    ORDER BY LF_Daypart__c, Long_Form__c, Week__c, Day_of_Week__c ASC
            ];
        } else {
            scheduleList = [
                    SELECT Id,Name,X2Calculated_Time_Period__c,LF_Daypart__c,Rate__c,LF_Week__c,
                            Long_Form__c,LF_Brand__c,X800_Number__c,Day_of_Week__c,Week__c, DealBrand__c,
                            DealAccount__c,Deal_Parent__r.Contact__r.AccountId
                    FROM Schedules__c
                    WHERE DealProgram__c LIKE :dealProgram
                    AND Week__c >= :fromDate
                    AND Week__c <= :toDate AND COUNTMENOT__c = 'y' AND Status__c != 'Canceled'
                    AND DealAccount__c LIKE :dealKeyword
                    ORDER BY LF_Daypart__c, Long_Form__c, Week__c, Day_of_Week__c ASC
            ];
        }//AND Deal_Parent__r.Brands__r.name != 'Availability'
        System.debug('@@@@ Schedule List Size ==> ' + scheduleList.size());
        if (scheduleList.size() > 0) {
            hasRecords = true;
            Integer days = fromDate.daysBetween(toDate);
            lstDayOfWeek = new List<String>();

            Integer dd = Integer.valueOf(scheduleList.get(0).Day_of_Week__c.substring(0, 1));
            --dd;

            Date tempDate = fromDate;

            Integer counter = startDate;

            dKeys = new List<Date>();
            Map<Date, Integer> headings = new Map<Date, Integer>();
            Date lastSOW;

            for (Date fDate = fromDate; fDate <= toDate; fDate = fDate.addDays(1)) {

                String dayOfWeekString = getDayOfWeekFull(Math.mod(counter, 7) + 1) + '<br />' + fDate.format();

                lstDayOfWeek.add(dayOfWeekString);
                Date startOfWeek = fDate.toStartOfWeek().addDays(1); //Fetching the first date of the week--First Monday
                Integer cols = headings.get(startOfWeek);
                lastSOW = startOfWeek;

                if (Math.mod(counter, 7) + 1 == 7) {    //Sunday
                    Date sOW = fDate.addDays(-1).toStartOfWeek().addDays(1);
                    cols = headings.get(sOW);

                    if (cols != null) {
                        cols++;
                        headings.put(sOW, cols);
                    } else {
                        dKeys.add(sOW);
                        headings.put(sOW, 1);
                    }
                    cols++;
                    headings.put(sOW, cols);

                    dd = 0;
                } else {
                    if (cols != null) {
                        cols++;
                        headings.put(startOfWeek, cols);
                    } else {
                        dKeys.add(startOfWeek);
                        headings.put(startOfWeek, 1);
                    }
                    dd++;
                }
                counter++;
            }

            //Last Column
            if (dd != 0) {
                Integer cols = headings.get(lastSOW);
                cols++;
                headings.put(lastSOW, cols);
            }

            counter = startDate;

            for (Date fDate : dKeys) {

                EntryCheckHelper.HeadingModel hm = new EntryCheckHelper.HeadingModel();
                hm.startOfWeek = fDate;
                Integer cols = headings.get(fDate);
                hm.cols = String.valueOf(cols);
                headingModels.add(hm);
            }

            Map<String, List<Schedules__c>> schedulesMap = new Map<String, List<Schedules__c>>();

            keys = new List<String>();

            Map<String, Map<String, EntryCheckHelper.FBEntryModel>> docEntryMap = new Map<String, Map<String, EntryCheckHelper.FBEntryModel>>();

            for (Schedules__c sc : scheduleList) {
                System.debug('====' + sc.X2Calculated_Time_Period__c + '====');
                EntryCheckHelper.FBEntryModel fb = new EntryCheckHelper.FBEntryModel();
                fb.schedule = sc;
                fb.recordCount = 1;
                fb.showEditable = true;
                fbEntryModelList.add(fb);
                Map<String, EntryCheckHelper.FBEntryModel> docEntries = docEntryMap.get(sc.Long_Form__c);

                if (docEntries != null) {
                    EntryCheckHelper.FBEntryModel tempFb = docEntries.get(sc.Week__c + '-' + sc.Day_of_Week__c);
                    if (tempFb != null) {
                        //Changed
                        System.debug('@@@@Program is ' + fb.schedule.DealBrand__c);
                        // Availability
                        if (fb.schedule.DealBrand__c != 'Availability') {
                            fb.rCount = (tempFb.rCount != null ? tempFb.rCount : 0) + 1;
                        }
                        System.debug('####################### RecordCount===>' + fb.rCount);
                    } else {
                        fb.rCount = 1;
                        System.debug('####################### RecordCount===>' + fb.rCount);
                    }

                    docEntries.put(sc.Week__c + '-' + sc.Day_of_Week__c, fb);
                    System.debug('kkkk' + sc.Week__c + '-' + sc.Day_of_Week__c);
                } else {
                    fb.rCount = 1;
                    docEntries = new Map<String, EntryCheckHelper.FBEntryModel>{
                            sc.Week__c + '-' + sc.Day_of_Week__c => fb
                    };
                    docEntryMap.put(sc.Long_Form__c, docEntries);
                    keys.add(sc.Long_Form__c);
                }
            }

            totals = new List<EntryCheckHelper.ModelTotals>();
            Integer sizeOfColumns = 0;
            for (EntryCheckHelper.HeadingModel hm : headingModels) {
                sizeOfColumns += Integer.valueOf(hm.cols);
            }

            for (Integer c = 0; c <= sizeOfColumns; c++) {
                totals.add(new EntryCheckHelper.ModelTotals());
            }

            fbModel = new List<EntryCheckHelper.FBModels>();
            for (String key : keys) {
                System.debug('## == ' + key);
                Map<String, EntryCheckHelper.FBEntryModel> docEntries = docEntryMap.get(key);
                List<EntryCheckHelper.FBEntryModel> fbEntries = new List<EntryCheckHelper.FBEntryModel>();
                EntryCheckHelper.FBModels fbm = new EntryCheckHelper.FBModels();
                counter = startDate;
                Decimal sumOfRate = 0;
                Integer recordCount = 0;
                Decimal grandSumOfRate = 0;
                Integer grandRecordCount = 0;

                Integer tCounter = 0;

                for (Date fDate = fromDate; fDate <= toDate; fDate = fDate.addDays(1)) {
                    String dowKey = fDate + '-' + getDayOfWeek(Math.mod(counter, 7) + 1);
                    System.debug('$$ == ' + dowKey);
                    EntryCheckHelper.FBEntryModel fbEM = docEntries.get(dowKey);
                    if (fbEM != null) {
                        System.debug('$$Found == ' + dowKey);
                        fbm.key = fbEM.schedule.Long_Form__c;
                        fbm.lfDayPart = fbEM.schedule.LF_Daypart__c;
                        fbEM.color = 'white';
                        fbEM.setWeek(fDate);
                        fbEM.isSubTotal = false;
                        fbEM.showEditable = true;
                        sumOfRate += fbEM.schedule.Rate__c;
                        //Changed
                        if (fbEM.schedule.DealBrand__c != 'Availability') {
                            recordCount += fbEM.recordCount;
                        }
                        grandSumOfRate += fbEM.schedule.Rate__c;
                        if (fbEM.schedule.DealBrand__c != 'Availability') {
                            grandRecordCount += fbEM.recordCount;
                        }
                        totals[tCounter].sumOfRate += fbEM.schedule.Rate__c;
                        if (fbEM.schedule.DealBrand__c != 'Availability') {
                            totals[tCounter].recordCount += fbEM.recordCount;
                        }
                    } else {
                        System.debug('$$Not Found == ' + dowKey);
                        fbEM = new EntryCheckHelper.FBEntryModel();
                        fbEM.schedule = new Schedules__c(Rate__c = 0, Week__c = fDate, Long_Form__c = key);
                        fbEM.setWeek(fDate);
                        fbEM.sumOfRate = 0;
                        fbEM.isSubTotal = false;
                        fbEM.recordCount = 0;
                    }
                    fbEntries.add(fbEM);

                    //Get the sub total
                    if (Math.mod(counter, 7) + 1 == 7) {
                        EntryCheckHelper.FBEntryModel fbEM1 = new EntryCheckHelper.FBEntryModel();
                        fbEM1.schedule = new Schedules__c(Rate__c = sumOfRate);

                        fbEM1.color = 'white';
                        fbEM1.sumOfRate = sumOfRate;
                        fbEM1.recordCount = recordCount;
                        fbEM1.isSubTotal = true;
                        dd = 0;
                        sumOfRate = 0;
                        recordCount = 0;
                        tCounter++;
                        totals[tCounter].sumOfRate += fbEM1.schedule.Rate__c;
                        if (fbEM1.schedule.DealBrand__c != 'Availability') {
                            totals[tCounter].recordCount += fbEM1.recordCount;
                        }
                        totals[tCounter].isSubTotal = true;
                    } else {
                        dd++;
                    }
                    counter++;
                    tCounter++;
                }

                //If last day of week is not sunday, then set the sub total
                if (dd != 0) {
                    EntryCheckHelper.FBEntryModel fbEM1 = new EntryCheckHelper.FBEntryModel();
                    fbEM1.schedule = new Schedules__c(Rate__c = sumOfRate);
                    if (recordCount > 0) {
                        fbEM1.color = 'white';
                    }
                    fbEM1.isSubTotal = true;
                    fbEM1.sumOfRate = sumOfRate;
                    fbEM1.recordCount = recordCount;
                    //fbEntries.add(fbEM1);


                    totals[tCounter].sumOfRate += fbEM1.schedule.Rate__c;
                    if (fbEM1.schedule.DealBrand__c != 'Availability') {
                        totals[tCounter].recordCount += fbEM1.recordCount;
                    }
                    totals[tCounter].isSubTotal = true;
                    tCounter++;
                }

                //Set Grand Total
                EntryCheckHelper.FBEntryModel fbGrandTotal = new EntryCheckHelper.FBEntryModel();
                fbGrandTotal.schedule = new Schedules__c();
                fbGrandTotal.sumOfRate = grandSumOfRate;
                fbGrandTotal.recordCount = grandRecordCount;

                fbm.fbEntryModels = fbEntries;
                fbm.grandTotal = fbGrandTotal;
                fbModel.add(fbm);
                //tCounter++;
                totals[tCounter].sumOfRate += fbGrandTotal.sumOfRate;
                totals[tCounter].recordCount += fbGrandTotal.recordCount;
                totals[tCounter].isSubTotal = true;
                sumGrandTotal += fbGrandTotal.sumOfRate;
                totalCount += fbGrandTotal.recordCount;

            }
        } else {
            hasRecords = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'List has no Rows'));
            headingModels = new List<EntryCheckHelper.HeadingModel>();
            lstDayOfWeek = new List<String>();
            fbModel = new List<EntryCheckHelper.FBModels>();
            totals = new List <EntryCheckHelper.ModelTotals>();
        }
        sid = '';
        slf = '';
        sWeek = '';
        return null;
    }

    // Cancel Method is used to cancel the Schedule, it will cancels the selected Record(from which Cancel button is clicked)
    public void cancel() {
        System.debug('Schedule id=======' + sid);
        System.debug('Long Form=======' + slf);
        System.debug('Schedule week=======' + sWeek);
        if (sid != null && sid.trim().length() > 0) {
            List<Schedules__c> schedules = [SELECT Status__c FROM Schedules__c WHERE Id = :sid];
            if (schedules.size() > 0) {
                schedules.get(0).Status__c = 'Canceled';
                update schedules.get(0);
            }
        }
        createSchedule();
        showReport();
    }

    // Method creates new schedule when hitting cancel. Cancels status if schedule exists
    private void createSchedule() {
        Date schWeek = Date.valueOf(sWeek);
        System.debug('Schedule date=======' + schWeek);
        if (slf != null && slf.trim().length() > 0 && schWeek != null) {
            List<Deal__c> newDealList = [
                    SELECT Id, Name, Brands__r.Name, Program__c
                    FROM Deal__c
                    WHERE Program__c = :deal.Program__c AND Brands__r.Name = 'Availability'
                    ORDER BY CreatedDate DESC
            ];
            System.debug('@@@@@ New Deal List =======>' + newDealList.size());
            if (newDealList.size() > 0) {
                Schedules__c newSch = new Schedules__c();
                newSch.Deal_Parent__c = newDealList.get(0).Id;
                newSch.Week__c = schWeek;
                newSch.Long_Form__c = slf;
                newSch.Rate__c = 0;
                newSch.Status__c = 'Sold';
                newSch.Units_Available__c = -1;
                insert newSch;
                System.debug('@@@ New Brand =======' + newDealList.get(0).Brands__r.Name);
                System.debug('@@@ New schedule =======' + newSch.Id);
            }
        }
    }

    // Method navigates to replace shedule page.
    public PageReference replaceSchedule() {
        oldScheduleObj = null;
        scheduleObj = new Schedules__c();

        System.debug('@@@@@@@ Schedule id: ' + sch);

        if (sch != null && sch.trim().equals('') == false) {
            oldScheduleObj = [
                    SELECT DealProgram__c,Deal_Parent__c,Units_Available__c,Rate__c,Week__c,Long_Form__c,Status__c
                    FROM Schedules__c
                    WHERE Id = :sch
            ];
            scheduleObj = oldScheduleObj.clone(false, true);
        } else {
            scheduleObj.Week__c = Date.valueOf(sWeek);
            scheduleObj.Long_Form__c = slf;
            scheduleObj.Units_Available__c = 1;
            scheduleObj.Status__c = 'Sold';
            scheduleObj.Rate__c = 0;
        }
        createList();
        PageReference pg = new PageReference('/apex/EntryCheckReplaceSchedule');
        return pg;
    }

    private void createList() {
        String progId = deal.Program__c;
        System.debug('@@@@ DEAL PROGRAM: ' + deal.Program__c);
        System.debug('@@@@DATE ARE: ' + fromDate + ' TO ' + toDate);

        lstDealAccount = [
                SELECT Id,ContactAccount__c, Name,Program__c,Program__r.Name,CreatedDate
                FROM Deal__c
                WHERE Program__c = :progId
                AND Week_MIN_Field__c >= :fromDate.toStartOfMonth().addMonths(-3).toStartOfWeek().addDays(1)
                AND Week_MIN_Field__c < :toDate.toStartOfMonth().addMonths(1).toStartOfWeek().addDays(1)
                LIMIT 1000
        ];
        System.debug('@@@@@ Deals found =' + lstDealAccount.size());
        System.debug('@@@@@ Program =' + progId);
        System.debug('@@@@@ from date=' + Date.newInstance(fromDate.year(), fromDate.month() - 1, 1).toStartOfWeek().addDays(1));
        System.debug('@@@@@ to date=' + Date.newInstance(toDate.year(), toDate.month() + 1, 1).toStartOfWeek().addDays(1));

    }

    public PageReference replace() {
        if (oldScheduleObj != null) {
            oldScheduleObj.Status__c = 'Canceled';
            oldScheduleObj.RecordTypeId = getRecordType(oldScheduleObj);
            update oldScheduleObj;
        }
        scheduleObj.RecordTypeId = getRecordType(scheduleObj);
        insert scheduleObj;
        showReport();
        return new PageReference('/apex/EntryCheckReport');
    }

    public PageReference back() {
        PageReference pg = new PageReference('/apex/EntryCheckReport');
        return pg;
    }

    public void setDealAccount() {
        String dealAcc = ApexPages.currentPage().getParameters().get('accName');
        scheduleObj.Deal_Parent__c = dealAcc;
    }

    private Id getRecordTypeId(String recordTypeName) {
        String rtName;
        System.debug('############ rtName: ' + recordTypeName);
        if (recordTypeName == 'Deal Paid Programming') {
            rtName = 'Paid Programming';
        } else if (recordTypeName == 'Deal Short Form') {
            rtName = 'Short Form';
        }
        System.debug('############ rtName: ' + rtName);
        List<RecordType> schRecType = [SELECT Id FROM RecordType WHERE Name = :recordTypeName AND SobjectType = 'Schedules__c'];
        if (schRecType.size() > 0) {
            System.debug('######Record type Id: ' + schRecType.get(0).Id);
            return schRecType.get(0).Id;
        }
        System.debug('###### schRecType is empty ######');
        return null;
    }

    // Method adds new Schedule
    public Id getRecordType(Schedules__c schObj) {
        try {
            List<Deal__c> deals = [SELECT RecordTypeId, RecordType.Name FROM Deal__c WHERE Id = :schObj.Deal_Parent__c];
            return getRecordTypeId(deals.get(0).RecordType.Name);
        } catch (Exception exp) {

        }
        return null;
    }

    public void oneWeekLater() {
        sDate.Week__c = sDate.Week__c.addDays(7);
        eDate.Week__c = eDate.Week__c.addDays(7);
        showReport();
    }

    public void oneWeekBack() {
        sDate.Week__c = sDate.Week__c.addDays(-7);
        eDate.Week__c = eDate.Week__c.addDays(-7);
        showReport();
    }

    public PageReference save() {
        List <Schedules__c> lstUpdateSchedule = new List <Schedules__c>();

        for (EntryCheckHelper.FBModels fbmdl : fbModel) {
            if (fbmdl.chkbox == true) {
                for (EntryCheckHelper.FBEntryModel fbemdl : fbmdl.fbEntryModels) {
                    if (fbemdl.schedule.DealAccount__c != null) {
                        lstUpdateSchedule.add(fbemdl.schedule);
                    }
                }
                fbmdl.chkbox = false;
                System.debug('#################Editable:' + fbmdl.chkbox);
            }
        }
        update lstUpdateSchedule;
        PageReference pr = new PageReference('/apex/DOCEntryCheck');
        pr.setRedirect(false);
        return showReport();
    }

    public void checkAll() {
        for (EntryCheckHelper.FBModels fbmdl : fbModel) {
            if (checks == true) {
                fbmdl.chkbox = true;
            } else {
                fbmdl.chkbox = false;
            }
        }
    }
//    public void createChangeLog() {
//        Boolean isNextMonth = false;
//        Date nDate = toDate.toStartOfWeek().addDays(7);
//        String prevDoc;
//        if (nDate.month() < 10) {
//            prevDoc = 'MVMS_DOC_0' + nDate.month() + '_' + nDate.year();
//        } else {
//            prevDoc = 'MVMS_DOC_' + nDate.month() + '_' + nDate.year();
//        }
//
//        List <Document> lstDocument = [SELECT Id,Name FROM Document WHERE Name LIKE :prevDoc];
//    }

    //method for month pickList in Page.
    public List<SelectOption> getOptions() {
        Map<Integer, String> monthMap = getMonth();
        List<SelectOption> options = new List<SelectOption>();
        for (Integer i = 2010; i <= 2020; i++) {
            for (Integer j = 1; j <= 12; j++) {
                options.add(new SelectOption(j + '-' + i, monthMap.get(j) + ' ' + i));
            }
        }
        Integer mon = Date.today().month();
        Integer yer = Date.today().year();
        if (activeFilter != 1) {
            months = mon + '-' + yer;
        }
        return options;
    }

    public Map<Integer, String> getMonth() {
        Map<Integer, String> monthMap = new Map<Integer, String>();
        monthMap.put(1, 'Jan');
        monthMap.put(2, 'Feb');
        monthMap.put(3, 'Mar');
        monthMap.put(4, 'Apr');
        monthMap.put(5, 'May');
        monthMap.put(6, 'Jun');
        monthMap.put(7, 'Jul');
        monthMap.put(8, 'Aug');
        monthMap.put(9, 'Sep');
        monthMap.put(10, 'Oct');
        monthMap.put(11, 'Nov');
        monthMap.put(12, 'Dec');
        return monthMap;
    }

    private void loadDaysMap() {
        daysMap = new Map<Integer, String>();
        daysMap.put(1, '1Mon');
        daysMap.put(2, '2Tues');
        daysMap.put(3, '3Wed');
        daysMap.put(4, '4Th');
        daysMap.put(5, '5Fri');
        daysMap.put(6, '6Sat');
        daysMap.put(7, '7Sun');
    }
    private void loadDaysMapFull() {
        daysMapFull = new Map<Integer, String>();
        daysMapFull.put(1, 'Monday');
        daysMapFull.put(2, 'Tuesday');
        daysMapFull.put(3, 'Wednesday');
        daysMapFull.put(4, 'Thursday');
        daysMapFull.put(5, 'Friday');
        daysMapFull.put(6, 'Saturday');
        daysMapFull.put(7, 'Sunday');
    }

    private String getDayOfWeek(Integer day) {
        return daysMap.get(day);
    }
    private String getDayOfWeekFull(Integer day) {
        return daysMapFull.get(day);
    }

}