public class TargetOverallController {
    public list<selectoption> team{get;set;}    
    public string selectedTeam {get;set;}
    public List<SelectOption> targetStatus{get;set;}
    public String SelectedStatus{get;set;}
    public List<SelectOption> statusDetail{get;set;}
    public String SelectedStatusDetail{get;set;}
    public boolean todo{get;set;}
    public Schedules__c schedule {get;set;}
    public Deal__c deal {get;set;}
    public List<Schedules__c> schedules {get;set;}
    //public List<ProgramModel> progModelList {get;set;}
    public List<String> monthHeading {get;set;}
    //public List<GrandTotalModel> grandTotalList{get;set;}
    //public GrandTotalModel superGrandTotal{get;set;}
    public List<String> monthNo;
    public boolean hasRecords{get;set;}
    Date fromDate;
    Date toDate;    
    String programId;
    String agencyId;
    String conId;
    String brandId;
    String ownerId;
    //Constructor Definition
    public TargetOverallController(){
    	todo = false;
        team = new list<selectoption>();
        targetStatus = new List<SelectOption>();
        targetStatus.add(new selectoption('None','None'));               
        targetStatus.add(new selectoption('Active','Active')); 
        targetStatus.add(new selectoption('Test','Test')); 
        targetStatus.add(new selectoption('Negative','Negative')); 
        targetStatus.add(new selectoption('Target','Target'));
        
        /*targetStatus.add(new selectoption('None','None'));               
        targetStatus.add(new selectoption('To Do','To Do')); 
        targetStatus.add(new selectoption('Target','Target'));
        targetStatus.add(new selectoption('Pitching','Pitching'));  
        targetStatus.add(new selectoption('Test','Test')); 
        targetStatus.add(new selectoption('Active','Active')); 
        targetStatus.add(new selectoption('Fail Test','Fail Test')); 
        targetStatus.add(new selectoption('No Interest','No Interest')); 
        targetStatus.add(new selectoption('Wrong Demo','Wrong Demo')); 
        targetStatus.add(new selectoption('S&P','S&P')); 
        targetStatus.add(new selectoption('Length','Length')); 
        targetStatus.add(new selectoption('Call Hours','Call Hours')); 
        targetStatus.add(new selectoption('Dormant','Dormant')); 
        targetStatus.add(new selectoption('Update','Update')); 
        targetStatus.add(new selectoption('Declining Results','Declining Results')); 
        targetStatus.add(new selectoption('Filter','Filter')); 
        */
        statusDetail = new List<SelectOption>();
        statusDetail.add(new selectoption('None','None'));
        statusDetail.add(new selectoption('Consistent','Consistent'));
        statusDetail.add(new selectoption('Black Swan','Black Swan'));
        statusDetail.add(new selectoption('Filler','Filler'));
        statusDetail.add(new selectoption('Rate Increase','Rate Increase'));
        statusDetail.add(new selectoption('Rate Decrease','Rate Decrease'));
        statusDetail.add(new selectoption('Fail Test','Fail Test'));
        statusDetail.add(new selectoption('No Interest','No Interest'));
        statusDetail.add(new selectoption('Wrong Demo','Wrong Demo'));
        statusDetail.add(new selectoption('Copy Length','Copy Length'));
        statusDetail.add(new selectoption('Call Hours','Call Hours'));
        statusDetail.add(new selectoption('Pitching','No '));
        statusDetail.add(new selectoption('To Do','To Do'));
        statusDetail.add(new selectoption('Dormant','Dormant'));
        
        team.add(new selectoption('None','None'));
        team.add(new selectoption('Red','Red'));
        team.add(new selectoption('Blue','Blue'));
        team.add(new selectoption('Green','Green'));
        team.add(new selectoption('Orange','Orange'));
        deal = new Deal__c();
        schedule = new Schedules__c();
        schedules = new List<Schedules__c>();
        //progModelList = new List<ProgramModel>();
        //grandTotalList = new List<GrandTotalModel>();
        hasRecords = true;
        schedule.Day__c = system.today();
        schedule.Week__c = schedule.Day__c.addDays(-7);
        //search();
    }
    //Method to create headings
    /**private void getMonthHeadings(Integer sMonth,Integer eMonth,Integer sYear,Integer eYear){
        monthHeading = new List<String>();
        monthNo = new List<String>();
        if(sYear == eYear){
	        for(integer i = sMonth ; i <= eMonth ; i++){
	            if(i==1)
	                monthHeading.add('Jan FY '+sYear);
	            if(i==2)
	                monthHeading.add('Feb FY '+sYear);
	            if(i==3)
	                monthHeading.add('Mar FY '+sYear);
	            if(i==4)
	                monthHeading.add('Apr FY '+sYear);
	            if(i==5)
	                monthHeading.add('May FY '+sYear);
	            if(i==6)
	                monthHeading.add('Jun FY '+sYear);
	            if(i==7)
	                monthHeading.add('Jul FY '+sYear);
	            if(i==8)
	                monthHeading.add('Aug FY '+sYear);
	            if(i==9)
	                monthHeading.add('Sep FY '+sYear);
	            if(i==10)
	                monthHeading.add('Oct FY '+sYear);
	            if(i==11)
	                monthHeading.add('Nov FY '+sYear);
	            if(i==12)
	                monthHeading.add('Dec FY '+sYear);
	            monthNo.add(i + '-' + sYear);
	        }
        }else if(sYear < eYear){
        	for(integer i = sMonth ; i <= 12 ; i++){
	            if(i==1)
	                monthHeading.add('Jan FY '+sYear);
	            if(i==2)
	                monthHeading.add('Feb FY '+sYear);
	            if(i==3)
	                monthHeading.add('Mar FY '+sYear);
	            if(i==4)
	                monthHeading.add('Apr FY '+sYear);
	            if(i==5)
	                monthHeading.add('May FY '+sYear);
	            if(i==6)
	                monthHeading.add('Jun FY '+sYear);
	            if(i==7)
	                monthHeading.add('Jul FY '+sYear);
	            if(i==8)
	                monthHeading.add('Aug FY '+sYear);
	            if(i==9)
	                monthHeading.add('Sep FY '+sYear);
	            if(i==10)
	                monthHeading.add('Oct FY '+sYear);
	            if(i==11)
	                monthHeading.add('Nov FY '+sYear);
	            if(i==12)
	                monthHeading.add('Dec FY '+sYear);
	            monthNo.add(i + '-' + sYear);
        	}
        	
        	for(integer i = 1 ; i <= eMonth ; i++){
	            if(i==1)
	                monthHeading.add('Jan FY '+eYear);
	            if(i==2)
	                monthHeading.add('Feb FY '+eYear);
	            if(i==3)
	                monthHeading.add('Mar FY '+eYear);
	            if(i==4)
	                monthHeading.add('Apr FY '+eYear);
	            if(i==5)
	                monthHeading.add('May FY '+eYear);
	            if(i==6)
	                monthHeading.add('Jun FY '+eYear);
	            if(i==7)
	                monthHeading.add('Jul FY '+eYear);
	            if(i==8)
	                monthHeading.add('Aug FY '+eYear);
	            if(i==9)
	                monthHeading.add('Sep FY '+eYear);
	            if(i==10)
	                monthHeading.add('Oct FY '+eYear);
	            if(i==11)
	                monthHeading.add('Nov FY '+eYear);
	            if(i==12)
	                monthHeading.add('Dec FY '+eYear);
	            monthNo.add(i + '-' + eYear);
	        }
        }
        system.debug('@@@@ Month Numbers: '+monthNo);
    }
    //Method for searching records
    public PageReference search(){
        progModelList.clear();
        grandTotalList.clear();
        if(schedule.Week__c == null || schedule.Day__c == null){
            System.debug('#### Date filter not Specified');
            return null;
        }
        if(schedule.Week__c != null){
            fromDate = schedule.Week__c;
        }
        if(schedule.Day__c != null){
            toDate = schedule.Day__c;
        }
        integer sMonth = fromDate.month();        
        integer eMonth = toDate.month();
        integer sYear = fromDate.year();
        integer eYear = toDate.year();
        getMonthHeadings(sMonth,eMonth,sYear,eYear);
        String query ='SELECT id, Name, Week__c, X30_Rate__c, Rate__c, Total_Dollars__c, Equiv_30__c, ';
        query += 'Deal_Parent__r.id, Deal_Parent__r.Name, Deal_Parent__r.Status__c, ';
        query += 'Deal_Parent__r.Program__c, Deal_Parent__r.Program__r.Name, Deal_Parent__r.Brands__r.Name, ';
        query += 'Deal_Parent__r.Contact__c, Deal_Parent__r.ContactAccount__c, Deal_Parent__r.CreatedDate, ';
        query += 'Deal_Parent__r.Target__r.Comments__c, Deal_Parent__r.Target__r.AE_Status__c, ';
        query += 'Deal_Parent__r.Target__r.To_Do__c, Deal_Parent__r.Target__r.AE_LC__c, ';
        query += 'Deal_Parent__r.Target__r.Status__c, Deal_Parent__r.Target__r.Status_Detail__c ';
        query += 'FROM Schedules__c WHERE (CALENDAR_YEAR(Week__c) =: sYear Or CALENDAR_YEAR(Week__c) =: eYear) ';
        query += 'AND Deal_Parent__r.Target__c != null ';
        query += 'AND Week__c >: fromDate AND Week__c <: toDate ';
        if(selectedTeam != 'None' && selectedTeam != null){
            query += 'AND Deal_Parent__r.Program__r.Team__c like \'%' + selectedTeam + '%\' ';
        }
        System.debug('####From date = '+fromDate);
        System.debug('####To date = '+toDate);
        System.debug('####To Do = '+todo);
        //Program Filter
        if(deal.Program__c != null){
            programId = deal.Program__c;
            query += 'AND Deal_Parent__r.Program__c =: programId ';
        }
        //Agency Filter
        if(deal.Client_Account__c != null){
            agencyId = deal.Client_Account__c;
            query += 'AND Deal_Parent__r.Client_Account__c =: agencyId ';
        }
        //Contat Filter
        if(deal.Contact__c != null){
            conId = deal.Contact__c;
            query += 'AND Deal_Parent__r.Contact__c =: conId ';
        }
        //Brand Filter
        if(deal.Brands__c != null){
            brandId = deal.Brands__c;
            query += 'AND Deal_Parent__r.Brands__c =: brandId ';
        }
        //Deal Owner Filter
        if(deal.OwnerId != null){
            ownerId = deal.OwnerId; 
            query += 'AND Deal_Parent__r.OwnerId =: ownerId ';
        }
        //Test Filter
        if(schedule.TEST__c == true){
            query += 'AND Deal_Parent__r.Target__r.Status__c = \'Test\' ';
        }
        //Target Status Filter
        if(SelectedStatus!= null && SelectedStatus != 'None'){
            query += ' AND Deal_Parent__r.Target__r.Status__c =: SelectedStatus ';
        }
        //Status Detail Filter
        if(SelectedStatusDetail!= null && SelectedStatusDetail != 'None'){
            query += ' AND Deal_Parent__r.Target__r.Status_Detail__c =: SelectedStatusDetail ';
        }
        //Target To Do Filter
        if(todo != null && todo != false){
            query += 'AND Deal_Parent__r.Target__r.To_Do__c =: todo ';
        }
        query += 'LIMIT 1000 ';
        System.debug('#### Query created: '+query);
        schedules = Database.Query(query);
        System.debug('#### Records Found: '+schedules.size());
        
        if(schedules.size()<=0){
            hasRecords = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found.'));
            return null;
        }
        hasRecords = true;
        //Grouping by Program Name then Brand then Month
        Map<String, Map<String,Map<String,List<Schedules__c>>>> progMap = new Map<String, Map<String,Map<String,List<Schedules__c>>>>();
        
        for(Schedules__c sch: schedules){
            if(sch.Deal_Parent__r.Program__r.Name != null){
                Map<String,Map<String,List<Schedules__c>>> brandMap = progMap.get(sch.Deal_Parent__r.Program__r.Name);
                if(brandMap != null){
                    Map<String,List<Schedules__c>> monthMap = brandMap.get(sch.Deal_Parent__r.Brands__r.Name);
                    if(monthMap != null){
                        List<Schedules__c> scheds = monthMap.get(sch.week__c.month() + '-' + sch.week__c.year());
                        if(scheds != null){
                            scheds.add(sch);
                        }else{
                            monthMap.put(sch.week__c.month() + '-' + sch.week__c.year(), new List<Schedules__c>{sch});
                        }
                    }else{
                        monthMap = new Map<String, List<Schedules__c>>();
                        monthMap.put(sch.Week__c.month() + '-' + sch.Week__c.year(), new List<Schedules__c>{sch});
                    }
                    brandMap.put(sch.Deal_Parent__r.Brands__r.Name, monthMap);
                }else{
                    Map<String,List<Schedules__c>> mm = new Map<String,List<Schedules__c>>();
                    mm.put(sch.Week__c.month() + '-' + sch.Week__c.year(), new List<Schedules__c>{sch});
                    brandMap = new Map<String,Map<String,List<Schedules__c>>>();
                    brandMap.put(sch.Deal_Parent__r.Brands__r.Name, mm);
                }
                progMap.put(sch.Deal_Parent__r.Program__r.Name, brandMap);
            }
        }
        Map<String,GrandTotalModel> grandTotalMap = new Map<String,GrandTotalModel>();
        for(String prog : progMap.keySet()){
            Map<String,MonthModel> subTotalMap = new Map<String,MonthModel>();
            programModel progModel = new programModel();
            progModel.program = prog;
            Map<String,Map<String,List<Schedules__c>>> bMap = progMap.get(prog);
            List<BrandModel> bModelList = new List<brandModel>();
            for(String br : bMap.keySet()){
                brandModel bm = new brandModel();
                bm.brand = br;
                Map<String,List<Schedules__c>> mMap = bMap.get(br);
                List<MonthModel> mModelList = new List<MonthModel>();
                for(String mno : monthNo){
                    MonthModel mm = new MonthModel();
                    List<Schedules__c> sList = mMap.get(mno);
                    if(sList != null){
                        for(Schedules__c schd : sList){
                            if(schd.Deal_Parent__r.Target__r != null){
                                bm.target = schd.Deal_Parent__r.Target__r;
                            }
                            if(schd.Total_Dollars__c != null){
                                mm.sumTotalDollar += schd.Total_Dollars__c;
                                //Mapping for Sub Totals: Sum of Total Dollar
                                MonthModel sTotalModel = subTotalMap.get(mno);
                                if(sTotalModel != null){
                                    sTotalModel.sumTotalDollar += schd.Total_Dollars__c;
                                    subTotalMap.put(mno,sTotalModel);
                                }else{
                                    sTotalModel = new MonthModel();
                                    sTotalModel.sumTotalDollar = schd.Total_Dollars__c;
                                    subTotalMap.put(mno,sTotalModel);
                                }
                                //Mapping for Grand Totals: Sum of Total Dollar
                                GrandTotalModel gTotal = grandTotalMap.get(mno);
                                if(gTotal != null){
                                    gTotal.sumTotalDollar += schd.Total_Dollars__c;
                                    grandTotalMap.put(mno,gTotal);
                                }else{
                                    gTotal = new grandTotalModel();
                                    gTotal.sumTotalDollar = schd.Total_Dollars__c;
                                    grandTotalMap.put(mno,gTotal);
                                }
                            }
                            if(schd.X30_Rate__c != null){
                                mm.avg30 += schd.X30_Rate__c;
                                mm.count++;
                                //Mapping for Sub Total: :30 Rate Average
                                MonthModel sTotalModel = subTotalMap.get(mno);
                                if(sTotalModel != null){
                                    sTotalModel.avg30 += schd.X30_Rate__c;
                                    sTotalModel.count++;
                                    subTotalMap.put(mno,sTotalModel);
                                }else{
                                    sTotalModel = new MonthModel();
                                    sTotalModel.avg30 = schd.X30_Rate__c;
                                    sTotalModel.count++;
                                    subTotalMap.put(mno,sTotalModel);
                                }
                                //Mapping for Grand Total: :30 Rate Average
                                grandTotalModel gTotal = grandTotalMap.get(mno);
                                if(gTotal != null){
                                    gTotal.avg30 += schd.X30_Rate__c;
                                    gTotal.count++;
                                    grandTotalMap.put(mno,gTotal);
                                }else{
                                    gTotal = new grandTotalModel();
                                    gTotal.avg30 = schd.X30_Rate__c;
                                    gTotal.count++;
                                    grandTotalMap.put(mno,gTotal);
                                }
                            }
                        }
                        if(mm.count > 0){
                            mm.avg30 = mm.avg30 / mm.count;
                        }
                    }else{
                        mm.sumTotalDollar = 0;
                        mm.avg30 = 0;
                    }
                    mModelList.add(mm); 
                }
                system.debug('#### Month Model List Size: '+mModelList.size());
                bm.monthSum = mModelList;
                for(MonthModel m : mModelList){
                    bm.total.sumTotalDollar += m.sumTotalDollar;
                    if(m.avg30 > 0){
                        bm.total.avg30 += m.avg30;
                        bm.total.count++;
                    }
                }
                if(bm.total.count > 0){
                    bm.total.avg30 = bm.total.avg30 / bm.total.count;
                }
                bModelList.add(bm);
            }
            system.debug('#### Brand Model List size: '+bModelList.size());
            progModel.brands = bModelList;
            //Getting Sub Totals
            for(String mno: monthNo){
                MonthModel sTotal = subTotalMap.get(mno);
                if(sTotal != null){
                    if(sTotal.count > 0){
                        sTotal.avg30 = sTotal.avg30 / sTotal.count;
                    }
                }else{
                    sTotal = new MonthModel();
                    sTotal.sumTotalDollar = 0;
                    sTotal.avg30 = 0;
                }
                progModel.subTotals.add(sTotal);
            }
            for(MonthModel m:progModel.subTotals){
                progModel.total.sumTotalDollar += m.sumTotalDollar;
                if(m.avg30 > 0){
                    progModel.total.avg30 += m.avg30;
                    progModel.total.count++;
                }
            }
            if(progModel.total.count > 0){
                progModel.total.avg30 = progModel.total.avg30 / progModel.total.count;
            }
            progModelList.add(progModel);
            
        }
        //Getting Grand Totals
        superGrandTotal = new GrandTotalModel();
        for(String mno : monthNo){
            GrandTotalModel gtm = grandTotalMap.get(mno);
            if(gtm != null){
                if(gtm.count > 0){
                    gtm.avg30 = gtm.avg30 / gtm.count;
                }
            }else{
                gtm = new GrandTotalModel();
                gtm.sumTotalDollar = 0;
                gtm.avg30 = 0;
            }
            grandTotalList.add(gtm);
            superGrandTotal.sumTotalDollar += gtm.sumTotalDollar;
            if(gtm.avg30 > 0){
                superGrandTotal.avg30 += gtm.avg30 ;
                superGrandTotal.count++;
            }
        }
        if(superGrandTotal.count > 0){
            superGrandTotal.avg30 = superGrandTotal.avg30 / superGrandTotal.count;
        }
        system.debug('#### program Model List size: '+progModelList.size());
        sortData();
        return null;
    }
    private void sortData(){
        for(ProgramModel pm : progModelList){
            for(integer i = 0 ; i < pm.brands.size() ; i++){
                for(integer j = i+1 ; j< pm.brands.size() ; j++){
                    if(pm.brands.get(i).total.sumTotalDollar < pm.brands.get(j).total.sumTotalDollar){
                        BrandModel temp = pm.brands.get(i);
                        pm.brands[i] = pm.brands.get(j);
                        pm.brands[j] = temp;
                    }
                }
            }
        }
    }
    
    //Method to Save updations
    public PageReference save(){
        List<Targets__c> targets = new List<Targets__c>();
        for(ProgramModel p : progModelList){
            for(BrandModel b: p.brands){
                if(b.target != null){
                    targets.add(b.target);
                }
            }
        }
        if(targets.size() > 0){
            upsert targets;
        }
        search();
        return null;
    }
    public class ProgramModel{
        public String program {get;set;}
        public List<brandModel> brands {get;set;}
        public List<MonthModel> subTotals {get;set;}
        public MonthModel total{get;set;}
        public programModel(){
            brands = new List<brandModel>();
            subTotals = new List<MonthModel>();
            total = new MonthModel();
        }
    }
    public class BrandModel{
        public String brand{get;set;}
        public Targets__c target{get;set;}
        //public List<Schedules__c> schList{get;set;}
        public List<MonthModel> monthSum{get;set;}
        public MonthModel total{get;set;}
        public BrandModel(){
            target = new Targets__c();
            //schList = new List<Schedules__c>();
            monthSum = new List<MonthModel>();
            total = new MonthModel();
        }
    }
    public class MonthModel{
        public String month;
        public List<Schedules__c> schList{get;set;}
        public Decimal sumTotalDollar{get;set;}
        public Decimal avg30{get;set;}
        public integer count;
        public MonthModel(){
            schList = new List<Schedules__c>();
            sumTotalDollar = 0;
            avg30 = 0;
            count = 0;
        }
    }
    public class GrandTotalModel{
        public Decimal sumTotalDollar{get;set;}
        public Decimal avg30{get;set;}
        public integer count;
        public GrandTotalModel(){
            sumTotalDollar = 0;
            avg30 = 0;
            count = 0;
        }
    }**/
}