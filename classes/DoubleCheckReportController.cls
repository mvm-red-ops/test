public class DoubleCheckReportController {
    public Id did {get;set;}
    public boolean filler{get;set;}
    public List<Deal__c> dealList {get;set;}
    public schedules__c schedule{get;set;}
    public Deal__c deal {get;set;}
    public List<Schedules__c> schCommentList{get;set;}
    public integer size3 {get;set;}
    public List<rateModel> rateModelList {get;set;}
    public List<HeadingModel> headingModels {get;set;}
    public List<grandTotals> grandTotalList {get;set;}
    public List<Schedules__c> scheduleList;
    public RateModel grandTotal {get;set;}
    public GrandTotals superTotal {get;set;}
    
    public boolean showDealList{get;set;}
    public boolean missingReq{get;set;}
    public boolean showErr{get;set;}
    public boolean hasDeals{get;set;}
    public boolean hasRecord{get;set;}
    public boolean hasScheduleRecord{get;set;}
    public boolean filter{get;set;}
    public String dealId{get;set;}
    String dealName;
    String brand;
    String agency;
    String program;
    
    public Date fromDate{get;set;}
    public DateTime toDate{get;set;}
    
    public List<Date> lstDayOfWeek{set;get;}
    public Deal__c dealObj{get;set;}
    
    //Constructor definition
    public DoubleCheckReportController(){
        grandTotal = new RateModel();
        schedule = new schedules__c();
        deal = new Deal__c();
        missingReq = false;
        hasRecord = false;
        showDealList = false;
        hasScheduleRecord = false;
        hasDeals = false;
    }
    //Method checks criteria
    public pageReference showDetail(){
        missingReq = false;
        showDealList = false;
        if(schedule.Deal_Parent__c == null){
            if(deal.Client_Account__c == null || deal.Program__c == null){
                missingreq = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter either the DEAL NAME or AGENCY and PROGRAM.'));
                return null;
            }
            else{
                showDealList = true;
                getDealList();
                return null;
            }
        }
        else if(deal.Client_Account__c != null || deal.Program__c != null){
            missingreq = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter either the DEAL NAME or AGENCY and PROGRAM.'));
            return null;
        }
        search();
        PageReference pg = new PageReference('/apex/DoubleCheckReport');
        return pg;
    }
    
    //Method getting List of Deals
    private void getDealList(){
        showErr = false;
        String program = deal.Program__c;
        String agency = deal.Client_Account__c;
        String query = 'SELECT id, Name, Brands__c, program__c, Client_Account__c from Deal__c ';
               query +='WHERE Program__c =: program ';
               query +='AND Client_Account__c =: agency ';
        
        if(deal.Brands__c != null){
            String brand = deal.Brands__c;
            query +='AND Brands__c =: brand ';
        }
        query += 'ORDER BY Week_MIN_Field__c ';
        query += 'LIMIT 500';
        system.debug('@@@@ Deal Query===> '+query);
        dealList = Database.Query(query);
        if(dealList.size()==0){
            showErr = true;
            showDealList = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Deals Found...!'));            
        }
        system.debug('@@@@ Deal records found==> '+dealList.size());
        
    }
    public pageReference searchByDeal(){
        if(did != null){
            schedule.Deal_Parent__c = did;
            system.debug('@@@@@@ Deal selected===>'+schedule.Deal_Parent__c);
            search();
            PageReference pg = new PageReference('/apex/DoubleCheckReport');
            return pg;
        }
        system.debug('@@@@@@ deal null @@@@');
        return null;
    }
    
    //Method to Getting records
    public pageReference search(){
        showErr =false;
        missingReq = false;
        hasRecord = true;
        hasDeals = true;
        hasScheduleRecord = true;
        headingModels = new List<HeadingModel>();
        superTotal = new GrandTotals();

        String query = 'Select Name, Week__c, Units_Preempted__c, Units_Available__c, Units_Aired__c, UnitLength__c, Test__c, ';
               query += 'Rate__c, Id, Deal_Parent__c, DealProgram__c, DealBrand__c, DealAccount__c, Comments__c, ';
               query += 'Equiv_30__c, Total_Dollars__c, Filler__c ';
               query += 'From Schedules__c ';
               query += 'WHERE Rate__c > 0  ';
        
        //Filler Filter
        if(filler == true){
           query +=' AND Filler__c =: filler';
        }
        //Deal filter
        if(schedule.Deal_Parent__c != null){
            filter = true;
            dealId = schedule.Deal_Parent__c;
            query += ' AND Deal_Parent__c =: dealId ';
            
            getDealSection();
            getCommentSection(query);
            getScheduleSection(query);
        }else{
            filter = false;
        }
        return null;
        
    }
    //Method getting records for Deal Section
    private void getDealSection(){
        List<Deal__c> deals = [SELECT id,
                               Name,
                               Program__c,
                               Brands__c,
                               Contact__c,
                               Length__c,
                               Campaign__c,
                               Client_Account__c,
                               ContactAccount__c,
                               Week_MIN_Field__c,
                               Agency_Deal_Number__c,
                               Network_Deal_Number__c,
                               Sum_of_Total_Dollars__c,
                               Sum_of_Units_Available__c
                               FROM Deal__c 
                               WHERE id=:dealId];
        if(deals.size()>0){
            dealObj = deals.get(0);
            hasDeals =true;
        }
    }
    
    //Method getting records for Comment: Test section
    private void getCommentSection(String query){
        query += ' LIMIT 500';
        schCommentList = Database.Query(query);
        if(schCommentList.size() == 0){
            hasRecord = false;
        }
        else {
            System.debug('######Records of Commets section found: '+schCommentList.size());
            size3 = schCommentList.size();
            hasRecord = true;
        }
    }
    //Method To save Updations
    public PageReference save(){
        if(dealObj != null){
            system.debug('@@@@@ DEAL section saved');
            update dealObj;
        }
        if(schCommentList.size() > 0){
            system.debug('@@@@@ COMMENT section saved');
            update schCommentList;
        }
        List<Schedules__c> updSchList = new List<Schedules__c>();
        for(RateModel rm : rateModelList){
            for(WeekModel wk : rm.weeks){
                if(wk.schObj != null){
                    updSchList.add(wk.schObj);
                }
            }
        }
        if(updSchList.size() > 0){
            system.debug('@@@@@ SCHEDULE section saved');
            update updSchList;
        }
        
        search();
        return null;
    }
    //Method Getting records for Schedule section
    private pageReference getScheduleSection(String query) {
        rateModelList = new List<rateModel>();
        grandTotalList = new List<grandTotals>();
        hasSchedulerecord = true;
        scheduleList = database.query(query);
        system.debug('####### In Schedule section: Size of scheduleList: '+scheduleList.size());
        if(scheduleList.isEmpty()){
            hasSchedulerecord = false;
            return null;
        }
        
        //Getting heading weeks
        Set<DateTime> dates = new Set<DateTime>();
        for(Schedules__c s : scheduleList){
            dates.add(s.Week__C);
        }
        List<DateTime> dateList = new List<DateTime>();
        dateList.addAll(dates);
        dateList.sort();
        fromDate = dealObj.Week_MIN_Field__c;
        toDate = dateList.get(dateList.size()-1);
        System.debug('$$$$$$ From Date===>'+fromDate+' To Date '+todate);
        
        Map<Date, Integer> headMap = new Map<Date, Integer>();
        headingModels  = new List<headingModel>();
        List<Date> headings = new List<Date>();
        for(Date fDate=fromDate; fDate <= toDate; fDate = fDate.addDays(1)){
            Date startOfWeek = fDate.toStartofWeek().addDays(1); //Fetching the first date of the week-- Monday
            integer counter = headMap.get(startOfWeek);
            if(counter == null){
                headings.add(startOfWeek);
                headMap.put(startOfWeek,1);
                system.debug('@@@@@Start of week==> '+startOfWeek);
            }
        }
        for(Date sow:headings){
            HeadingModel hm = new Headingmodel();
            hm.startOfWeek = sow;
            headingModels.add(hm);
        }

        Map<Decimal, Map<Date, List<Schedules__c>>> rateMap = new Map<Decimal, Map<Date, List<Schedules__c>>>();
        for(Schedules__c sch: scheduleList){
            if(sch.Rate__c != null){
                Map<Date, List<Schedules__c>> weekMap = rateMap.get(sch.Rate__c);
                if(weekMap != null){
                    List<Schedules__c> scheds = weekMap.get(sch.Week__c);
                    if(scheds != null){
                        scheds.add(sch);
                    }else{
                        weekMap.put(sch.Week__c, new List<Schedules__c>{sch});
                    }
                }
                else{
                    weekMap = new Map<Date, List<Schedules__c>>();
                    weekMap.put(sch.Week__c, new List<Schedules__c>{sch});
                    rateMap.put(sch.Rate__c, weekMap);
                }
            }
        }
        
        for(Decimal r : rateMap.keySet()){
            rateModel rm = new rateModel();
            
            rm.rate= r;
            integer i = 0;
            Map<Date, List<Schedules__c>> wMap = rateMap.get(r);
            List<weekModel> wModelList = new List<weekModel>();
            for(headingModel hm:headingModels){
                weekModel wModel = new weekModel();
                wModel.srNo = ++i;
                for(Date d : wMap.keySet()){
                    Date sd = d.toStartofWeek().addDays(1);
                    if(hm.startOfweek == sd){
                        List<Schedules__c> sList = wMap.get(d);
                        if(sList.size() > 0){
                            wModel.schObj=sList.get(0);
                        }
                        for(Schedules__c sch : sList){
                            if(sch.Units_Aired__c != null){
                                wModel.sumUnitAired += sch.Units_Aired__c;
                            }
                            if(sch.Units_Available__c != null){
                                wModel.sumUnitAvail += sch.Units_Available__c;
                            }
                            if(sch.Units_Preempted__c != null){
                                wModel.sumUnitPreEmp += sch.Units_Preempted__c;
                            }
                            if(sch.Total_Dollars__c != null){
                                wModel.sumTotalDollar += sch.Total_Dollars__c;
                            }
                            if(sch.Equiv_30__c != null){
                                wModel.sumEquiv += sch.Equiv_30__c;
                            }
                        }
                    }
                }
                wModel.week = hm.startOfweek;
                wModelList.add(wModel);
            }
            rm.weeks = wModelList;
            
            //Getting grand sums
            grandSums gs = new grandSums();
            for(weekModel w:wModelList){
                if(w.schObj != null){
                    if(w.schObj.Units_Aired__c != null){
                        gs.AiredGrandSum += w.schObj.Units_Aired__c;
                    }
                    if(w.schObj.Units_Available__c != null){
                        gs.AvailGrandSum += w.schObj.Units_Available__c;
                    }
                    if(w.schObj.Units_Preempted__c != null){
                        gs.PreEmptGrandsum += w.schObj.Units_Preempted__c;
                    }
                    if(w.schObj.Total_Dollars__c != null){
                        gs.tDollarGrandsum += w.schObj.Total_Dollars__c;
                    }
                    if(w.schObj.Equiv_30__c != null){
                        gs.EquivGrandSum += w.schObj.Equiv_30__c;
                    }
                }
                /*
                gs.AiredGrandSum += w.sumUnitAired;
                gs.AvailGrandSum += w.sumUnitavail;
                gs.PreEmptGrandsum += w.sumUnitPreEmp;
                gs.tDollarGrandsum += w.sumTotalDollar;
                gs.EquivGrandSum += w.sumEquiv;
                */
            }
            rm.gSum = gs;
            rateModelList.add(rm);
        }
        
        Set<Date> weeks = new Set<Date>();
        Map<Date, WeekModel> grandWeekMap = new Map<Date, WeekModel>();
        for(RateModel rm : rateModelList){
            for(WeekModel wm: rm.weeks){
                weeks.add(wm.week);
                WeekModel wm1 = grandWeekMap.get(wm.week);
                
                if(wm1 == null)
                    wm1 = new WeekModel();
                    
                wm1.week = wm.week;
                wm1.sumUnitAired+= wm.sumUnitAired;
                wm1.sumUnitavail+= wm.sumUnitavail;
                wm1.sumUnitPreEmp+= wm.sumUnitPreEmp;
                wm1.sumTotalDollar+= wm.sumTotalDollar;
                wm1.sumEquiv+= wm.sumEquiv;
                grandWeekMap.put(wm.week,wm1);
            }
        }
        if(grandWeekMap.size() > 0 ){
            List<Date> weekList = new List<Date>();
            List<WeekModel> weekModels = new List<WeekModel>();
            for(Date weekDate : weeks){
                weekList.add(weekDate);
            }
            weekList.sort();
            for(Date dt : weekList){
                weekModels.add(grandWeekMap.get(dt));
            }
            grandTotal.weeks = weekModels;
        }
        for(WeekModel wm:grandTotal.weeks){
            superTotal.airedGrandTotal += wm.sumUnitAired;
            superTotal.availGrandTotal += wm.sumUnitAvail;
            superTotal.preEmptGrandTotal += wm.sumUnitPreEmp;
            superTotal.tDollarGrandTotal += wm.sumTotalDollar;
            superTotal.equivGrandTotal += wm.sumEquiv;
        }
        system.debug('####### Size of Schedule section: '+rateModelList.size());
        return null;
    }
    
    class WeekModel {
        public integer srNo {get;set;}
        public Date week {get;set;}
        public Schedules__c schObj{get;set;}
        public Decimal sumUnitAired {get;set;}
        public Decimal sumUnitAvail {get;set;}
        public Decimal sumUnitPreEmp {get;set;}
        public Decimal sumTotalDollar {get;set;}
        public Decimal sumEquiv {get;set;}
        public weekModel(){
            //schObj = new Schedules__c();
            sumUnitAired  = 0;
            sumUnitAvail = 0;
            sumUnitPreEmp = 0;
            sumTotalDollar = 0;
            sumEquiv = 0;
        }
    }
    class RateModel {
        public boolean isChecked {get;set;}
        public Decimal rate {set;get;}
        public List<weekModel> weeks {get;set;}
        public grandSums gSum{get;set;}
        public rateModel(){
            weeks = new List<weekModel>();
            gSum = new grandSums();
        }
    }
    public class HeadingModel{
        public String cols{get;set;}
        public Date startOfWeek {get;set;} 
    }
    public class grandSums{
        public Decimal AiredGrandSum {get;set;}
        public Decimal AvailGrandSum {get;set;}
        public Decimal PreEmptGrandsum {get;set;}
        public Decimal tDollarGrandsum {get;set;}
        public Decimal EquivGrandSum {get;set;}
        public grandSums(){
            AiredGrandSum = 0;
            AvailGrandSum = 0;
            PreEmptGrandsum = 0;
            tDollarGrandsum = 0;
            EquivGrandSum = 0;
        }
    }
    public class GrandTotals{
        public Decimal AiredGrandTotal {get;set;}
        public Decimal AvailGrandTotal {get;set;}
        public Decimal PreEmptGrandTotal {get;set;}
        public Decimal tDollarGrandTotal {get;set;}
        public Decimal EquivGrandTotal {get;set;}
        public grandTotals(){
            AiredGrandTotal = 0;
            AvailGrandTotal = 0;
            PreEmptGrandTotal = 0;
            tDollarGrandTotal = 0;
            EquivGrandTotal = 0;
        }
    }
}