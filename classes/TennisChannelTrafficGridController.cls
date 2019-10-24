/**
@ name          :    TennisChannelTrafficGridController    
@ author        :
@ date          :    9 Augest, 2011
@ descripton    :
*/

public class TennisChannelTrafficGridController{
    public List<Schedules__c> sechList{get;set;}
    public List<ScheduleModel> scheduleModelList{get;set;}
    MAP<String, Schedules__c> ScheduleModelMap = new MAP<String, Schedules__c>();
    public string summarize{get;set;}
    public integer total{get;set;}
    public decimal totalRate {get;set;}   
    //public decimal totalDol {get;set;}
    public string dealKeyword{get;set;} 
    public Schedules__c schedulesFrm{get;set;}
    public Schedules__c schedulesTo{get;set;}
    public list<totalModel> modelList{get;set;}
    public Boolean SearchFlag{get;set;}
    public boolean hasRecords {get;set;}
    public boolean missingTraffic{get;set;}
    public boolean unitsPreEmpted {get;set;}
    public Integer count;
    public totalModel tm{get;set;}
    public Contact con{get;set;}
    public string months{get;set;}
    public string month2{get;set;}        
    public List<SelectOption> items{get;set;}
    public string filterType{get;set;}
    public boolean flag{get;set;}
    public Map <String,ID> mpRecordType ;
    public Map <String,RecordType> recordTypeMap ;
    //Constructor
    public TennisChannelTrafficGridController(){
        mpRecordType = new Map <String,ID>();
        setRecordTypeMap();
        
        filterType = 'Month';        
        schedulesFrm = new Schedules__c ();
        schedulesTo = new Schedules__c ();   
        con = new Contact();        
        modelList = new List<totalModel>();
        count = 0;
        total = 0;
        totalRate = 0; 
        month2 = '';
        SearchFlag = true;
        missingTraffic = false;
        unitsPreEmpted = false;
        items = getOptions();
        String key = apexPages.currentPage().getParameters().get('dealKeyword');
        system.debug('%%%% key : '+key);
        //totalDol = 0;
        
        //search();
        //onloadSearch();
        //searchMonth();
        setCurrentWeek();
        search();
    }
    
    private void setCurrentWeek() {
        schedulesFrm.Week__c = Date.today().toStartOfWeek().addDays(1);
        schedulesTo.Week__c = schedulesFrm.Week__c.addDays(6);
    }
    
    //method for month pickList in Page.
     public List<SelectOption> getOptions() {         
         Map<integer,string> monthMap = getMonth();
         List<SelectOption> options = new List<SelectOption>();        
            //options.add(new SelectOption('None','-None-'));
            for(integer i=2010; i<= 2020; i++){
               for(integer j=1; j<=12; j++){
                   options.add(new SelectOption(j + '-' + i,monthMap.get(j) + ' ' + i));
               }
            }
            integer mon = date.today().month();
            integer yer = date.today().year();
            months = mon + '-' + yer;
            return options;
       }
    public Map<integer,string> getMonth(){
        Map<integer,string> monthMap = new Map<integer,string>();
        monthMap.put(1,'Jan');
        monthMap.put(2,'Feb');
        monthMap.put(3,'Mar');
        monthMap.put(4,'Apr');
        monthMap.put(5,'May');
        monthMap.put(6,'Jun');
        monthMap.put(7,'Jul');
        monthMap.put(8,'Aug');
        monthMap.put(9,'Sep');
        monthMap.put(10,'Oct');
        monthMap.put(11,'Nov');
        monthMap.put(12,'Dec');
        return monthMap;
    }
    
    //Method for saving record 
    public PageReference Save(){      
        for(Schedules__c schObj : sechList){
            schObj.recordTypeID = getRecodType(schObj); 
        }      
        upsert sechList;
        //search();
        Return Null;
    }
    
    //Method for showing current month record onLoad of page. 
    public PageReference filterCheck(){    
        if(filterType == 'Month'){
            //searchMonth();
            flag = true;
        }else{        
            search();
        }
    return null;
    }
    
    //Method for searching by month.
    /*
    public PageReference searchMonth(){    
        system.debug('@@@@@@@ searchMonth is calling : ');
        scheduleModelList = new List<ScheduleModel>();
        SearchFlag = false;
        total = 0;
        totalRate = 0;
        count = 0;
        integer mon;
        integer yer;
        String no = 'N';
         String query = 'Select id,DealProgram__c,Week__c,Intg_Week__c,Day_of_Week__c,Long_Form__c,DealAccount__c, Units_Preempted__c, Deal_Parent__r.RecordType.Name, ';
         query += 'Units_Aired__c,Rate__c,Total_Dollars__c,LF_Brand__c,X800_Number__c,';
         query += 'Deal_Parent__c,Name, DealContact__c, Deal_Parent__r.Contact__c,Deal_Parent__r.Contact__r.Logs_CC__c, Deal_Parent__r.Contact__r.AccountId, Deal_Parent__r.Contact__r.Email from Schedules__c';
         query += ' Where DealProgram__c like \'Tennis PP\' AND Units_Preempted__c != 1 ';    
         
         if(missingTraffic){
            query += ' AND LF_Brand__c = NULL ';
         }
         if(unitsPreEmpted) {
             query += ' AND Units_Preempted__c = 1.0 AND COUNTMENOT__c =: no ';
         }
         List<string> splits = months.Split('-');            
         mon  = integer.valueof(splits.get(0));
         yer = integer.valueof(splits.get(1)); 
         system.debug('### mon == '+mon);
         system.debug('### yer == '+yer);
         if(con.AccountID != null){
             string accountId = con.AccountID;
           
             list<account> accList = [SELECT id,name from Account where id =: accountId];
             modelList = new list<totalModel>();        
             if(accList.size() > 0){
                Account acc = accList.get(0);
                dealKeyword = acc.name;
             }
         }
          
         query += ' AND CALENDAR_MONTH(Week__c) =: mon ';
         query += ' AND CALENDAR_YEAR(Week__c) =: yer ';
         if(dealKeyword != null && dealKeyword.trim().length() > 0){
             query += ' AND DealAccount__c like \'%' + dealKeyword + '%\' ';
         }
         //whereFlag = true;
         System.debug('$$ Query ==== ' + query);
         query += ' ORDER BY  Week__c, Day_of_Week__c, Long_Form__c LIMIT 1000';
         sechList = Database.Query(query);
//check size
        if( sechList.size()>0) {
             hasRecords = true;    
             Integer Sr = 1;
             for(schedules__C sc : sechList){
                integer i=0;
                count++;            
                totalModel tm  = new totalModel();
                i=i+count;
                tm.Count= integer.Valueof(i);            
                tm.rateTotal=  tm.rateTotal + sc.rate__c;
                //tm.dolTotal = tm.dolTotal + sc.Total_Dollars__c;
               
                modelList.add(tm);
                
                ScheduleModel sm = new ScheduleModel();
                sm.sech = sc;
                sm.SrNo = Sr;
                scheduleModelList.add(sm);
                Sr++; 
            }
            
            getScheduleModelMap();
            
            for(totalModel tc :  modelList){
                total = tc.count;
                totalRate  += tc.rateTotal;            
            }
        }
        else {
            showError () ;
        }
        return null;    
    }
    */
    public void oneWeekLater(){
        schedulesFrm.Week__c = schedulesFrm.Week__c.addDays(7);
        schedulesTo.Week__c = schedulesTo.Week__c.addDays(7);
        search();
    }
    
    public void oneWeekBack(){
        schedulesFrm.Week__c = schedulesFrm.Week__c.addDays(-7);
        schedulesTo.Week__c = schedulesTo.Week__c.addDays(-7);
        search();
    }
    
    
    //Method for searching by date
    public PageReference search(){        
        filterType = 'Date';
        system.debug('@@@@@@@ search is calling : ');
        scheduleModelList = new List<ScheduleModel>();
        SearchFlag = true;
        Date startDate;
        Date endDate;
        Date weekFrom;
        Date weekTo;
        total = 0;
        totalRate = 0;
        dealKeyword='';
        //totalDol = 0;
        count = 0;
        //integer mon;
        //integer yer;
        //startDate = system.today().toStartOfMonth();        
        //endDate= startDate.AddMonths(1).AddDays(-1);
        
        string accountId = con.AccountID;
        list<account> accList = [SELECT id,name from Account where id =: accountId];
        modelList = new list<totalModel>();        
        if(accList.size() > 0){
            Account acc = accList.get(0);
            dealKeyword = acc.name;
        }        
        Boolean whereFlag = true;        
        String query = 'Select id,DealProgram__c,Week__c,Intg_Week__c,Day_of_Week__c,Long_Form__c,DealAccount__c, Units_Preempted__c, ';
               query += 'Units_Aired__c,Rate__c,Total_Dollars__c,LF_Brand__c,X800_Number__c,Deal_Parent__r.RecordType.Name,';
               query += 'Deal_Parent__c,Name, DealContact__c, Deal_Parent__r.Contact__c, Deal_Parent__r.Contact__r.Logs_CC__c, Deal_Parent__r.Contact__r.AccountId, Deal_Parent__r.Contact__r.Email from Schedules__c';
               query += ' Where DealProgram__c like \'Tennis PP\' AND Status__c != \'Canceled\' '; 
               system.debug('@@@@@@@@@ query on Load = '+query);
        if(dealKeyword != null && dealKeyword.trim().length() > 0){           
            query += ' AND DealAccount__c like \'%' + dealKeyword + '%\' ';
        }
        
        if(schedulesFrm.week__c != null){
            //query = '';
            weekFrom = schedulesFrm.week__c;
            weekTo = schedulesTo.week__c;
            whereFlag = true;
            /*query = 'Select id,DealProgram__c,Week__c,Intg_Week__c,Day_of_Week__c,Long_Form__c,DealAccount__c, Units_Preempted__c, ';
            query += ' Units_Aired__c,Rate__c,Total_Dollars__c,LF_Brand__c,X800_Number__c, ';
            query += ' Deal_Parent__c,Name from Schedules__c ';
            query += ' Where DealProgram__c like \'Tennis PP\' AND Units_Preempted__c != 1 ';*/
            
            
            query += ' AND Week__c >=: weekFrom ';
            /*if(dealKeyword != null && dealKeyword.trim().length() > 0){           
                query += ' AND DealAccount__c like \'%' + dealKeyword + '%\' ';            
            }*/
            
            if(schedulesTo.week__c != null){
                query += ' AND Week__c <=: weekTo';
            }            
            //query += ' ORDER BY Week__c asc Limit 7';
            //whereFlag = true;
            system.debug('@@@@@@@@@ query From and To = '+query);
        }
        if(missingTraffic){
            query += ' AND LF_Brand__c = NULL ';
        }
        String no = 'N';
        if(unitsPreEmpted) {
            query += ' AND Units_Preempted__c = 1 AND COUNTMENOT__c =: no ';
        }
        query += ' ORDER BY  Week__c, Day_of_Week__c, Long_Form__c LIMIT 1000';
        sechList = Database.Query(query);  
        system.debug('@@@@@@@@@ query on Execute = '+query);
        system.debug('@@@@@@@@@ query of SearchList = '+sechList);
//check size    
    if(sechList.size()>0) {
        hasRecords = true;    
        Integer Sr = 1;
        for(schedules__C sc : sechList){
            integer i=0;
            count++;            
            totalModel tm  = new totalModel();
            i=i+count;
            tm.Count= integer.Valueof(i);            
            tm.rateTotal=  tm.rateTotal + sc.rate__c;
            //tm.dolTotal = tm.dolTotal + sc.Total_Dollars__c;
            modelList.add(tm);
            
        }
        
        for(schedules__C sc : sechList){
            ScheduleModel sm = new ScheduleModel();
            sm.sech = sc;
            sm.SrNo = Sr;
            scheduleModelList.add(sm);
            Sr++;
        }
        
        getScheduleModelMap();
        
        for(totalModel tc :  modelList){
            total = tc.count;
            totalRate  += tc.rateTotal;            
        }
        month2 = months;
      }
      else {
          showError();
      }
      return null;          
    }
    private void showError() {
        hasRecords = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found..!'));
    }
    
    public PageReference requestTraffic() {
        sendEmail('Traffic Request');
        return null;
    }
    public PageReference requestTrafficWeek() {
        sendEmail('Traffic Request_Week');
        return null;
    }
    
    //Method for sending email
    public void SendEmail(String trafficName){
        
        /*Contact con = new Contact();
        con.LastName = 'Amit';
        con.Email = 'test@test.com';
        insert con;*/
        
        List<Schedules__c> emailListedSchedules = new List<Schedules__c>();
        List<String> sendIds = new List<String>();
        
        for(Integer i = 1; i < apexPages.CurrentPage().getParameters().keyset().size(); i++){
        String id = apexPages.CurrentPage().getParameters().get('chk_'+String.valueOf(i));
            if(id != null){
                sendIds.add(id);
            }
        }
        
        system.debug('### Selected Schedule For Email : '+sendIds);
        
        for(String si : sendIds){
            Schedules__c emailSche = ScheduleModelMap.get(si);
            emailListedSchedules.add(emailSche);
        }
        
        system.debug('### emailListedSchedules : '+emailListedSchedules);
        //String tf = '%'+trafficName +'%';
        EmailTemplate emailtemp = [select id from EmailTemplate where Name= :trafficName  AND IsActive = true];
        List<Messaging.SingleEmailMessage> emails = new list<Messaging.SingleEmailMessage>();
        
        if(emailListedSchedules.size() > 0){
            for(Schedules__c schedule : emailListedSchedules ){
                Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
                List<String> addresses = new List<String>();
                List<String> ccAddresses = new List<String> ();
                List<String> bccAddresses = new List<String>();
                if(schedule.Deal_Parent__r.Contact__r.Email != null && schedule.DealContact__c.trim().length() > 0)
                    addresses.add(schedule.Deal_Parent__r.Contact__r.Email);
                if(schedule.Deal_Parent__r.Contact__r.Logs_CC__c != null) {
                    ccAddresses.add(schedule.Deal_Parent__r.Contact__r.Logs_CC__c);
                }
   system.debug('########################## CC Address: '+schedule.Deal_Parent__r.Contact__r.Logs_CC__c);
                //email.setToAddresses(addresses);
                
                email.setSaveAsActivity(false);
                email.setTargetObjectId(schedule.Deal_Parent__r.Contact__c);
                email.setTemplateId(emailtemp.id);
                email.setWhatId(schedule.id);
                if(ccAddresses.size()>0){
                    email.setCcAddresses(ccAddresses);
                }
                String uid = UserInfo.getUserId();
                User u = [select id, name, email from User where id =:uid];
                system.debug('@@@ User info: '+u);
                if(u != null){
                    bccAddresses.add(u.email);
                }
                if(bccAddresses.size()>0){
                    email.setBccAddresses(bccAddresses);
                }
                emails.add(email);
            }
            
            if(emails.size() > 0){
                Messaging.sendEmail(emails);
            }
        }
        
        //delete con;        
    }
    //1 :Functions to operate with Record Type
    
    private void setRecordTypeMap(){
        
        List<RecordType> schRecType = [select id,name from RecordType where SObjectType = 'Schedules__c'];
        for(RecordType rt : schRecType){
            mpRecordType.put(rt.name,rt.id);
        }
    }

    public ID getRecodType(Schedules__c schObj) {
        try {
            //List<Deal__c> deals = [select RecordTypeId, RecordType.Name from Deal__c where id =: schObj.Deal_Parent__c ];
            //System.debug('-RecID-');
            
            return mpRecordType.get(schObj.Deal_Parent__r.RecordType.Name);
            //schObj.Deal_Parent__c = schObj.Deal_Parent__c;
        }
        catch (Exception exp) {
            
        }
        return null;
    }
    
    /*private void getRecordTypes () {
        List<RecordType> recordTypes = [Select 
                                            r.SobjectType, r.NamespacePrefix, r.Name, 
                                            r.LastModifiedDate, r.LastModifiedById, r.IsActive, 
                                            r.Id, r.DeveloperName, r.Description, 
                                            r.CreatedDate, r.CreatedById, r.BusinessProcessId 
                                        From RecordType r
                                        WHERE SobjectType = 'Schedules__c'];
        if(recordTypes.size()>0){
            recordTypeMap = new Map <String,RecordType> ();
            for(RecordType rt : recordTypes) {
                recordTypeMap.put(rt.id,rt);
            }
        } 
    }*/
    //1
    
    public void getScheduleModelMap(){
        for(ScheduleModel sm : ScheduleModelList){
            ScheduleModelMap.put(sm.sech.Id, sm.sech);
        }
    }
    
    Public class ScheduleModel{
        public Integer SrNo{get;set;}
        public Schedules__c sech{get;set;}
    }
    
    public class totalModel{
        public integer count{get;set;}
        //public decimal dolTotal{get;set;}
        public decimal rateTotal{get;set;}
        
        public totalModel(){
            count = 0;            
            rateTotal = 0;
            
        }
    }
}