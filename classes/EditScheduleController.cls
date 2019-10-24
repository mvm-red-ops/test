public class EditScheduleController{
    Public List<Schedules__c> sechList;
    Public Account acc = new Account();
    Public String dealKeyword;
    Public Schedules__c schedule{get;set;}
    Public Boolean closeWindow{get;set;}
    
    public EditScheduleController(){
        closeWindow = false;
        schedule = new Schedules__c();
        sechList = new List<Schedules__c>();
        integer mon;
        integer yer;
        Boolean whereFlag = true; 
        Date weekFrom;
        Date weekTo;
        /*String accId = apexPages.currentPage().getParameters().get('accid');
        String months = apexPages.currentPage().getParameters().get('months');
        String dtFrom = apexPages.currentPage().getParameters().get('from');
        String dtTo = apexPages.currentPage().getParameters().get('to');
        String searchFlag = apexPages.currentPage().getParameters().get('flag');
        
        system.debug('### accId : '+accId);
        system.debug('### months : '+months);
        system.debug('### dateFrom : '+dtFrom);
        system.debug('### dateTo : '+dtTo);
        Date dateFrom;
        Date dateTo;
        
        if(dtFrom != null){
            dateFrom = getStringToDate(dtFrom);
        }
        if(dtTo != null){
            dateTo = getStringToDate(dtTo);
        }
        
        if(accid !=null && accid.trim().length() > 0){
            List<account> accList = [SELECT id,name from Account where id =: accId];
       
            if(accList.size() > 0){
                acc = accList.get(0);
                dealKeyword = acc.Name;
            }
        }*/
        
        Set<Id> ids = new Set<Id>();
        for(integer i=0; i<apexpages.currentpage().getParameters().keySet().size(); i++){
            string value = apexpages.currentpage().getParameters().get('id_' + i);
            if(value != null){
                ids.add(value);
            }
        }
       
       system.debug('$$$ Ids = ' + ids); 
        
        /*if(dealKeyword != null && dealKeyword.trim().length() > 0){
            query += ' AND DealAccount__c like \'%' + dealKeyword + '%\' ';
        }
        
        if(searchFlag == 'true'){
            if(dateFrom != null){

                weekFrom = dateFrom;
                weekTo = dateTo;
                whereFlag = true;
                
                query += ' AND Week__c >=: weekFrom ';
                        
                if(weekTo != null){
                    query += ' AND Week__c <=: weekTo';
                }            
                
            }
        }else{
            if(months != null && months.trim().length() > 0){
             
                 List<string> splits = months.Split('-');            
                 mon  = integer.valueof(splits.get(0));
                 yer = integer.valueof(splits.get(1)); 
                          
            }
        }

        system.debug('### mon == '+mon);
        system.debug('### yer == '+yer);
        query += ' AND CALENDAR_MONTH(Week__c) =: mon ';
        query += ' AND CALENDAR_YEAR(Week__c) =: yer ';
        */
        

        
        //system.debug('### query From and To = '+query);
        
        sechList = getSchedules(ids);
        
        system.debug('### sechList Size : '+sechList.size());
        system.debug('### sechList : '+sechList);
    }
    
    
    private List<Schedules__c> getSchedules(Set<Id> ids){
         List<Schedules__c> schedules = [Select 
                                             id, Week__c, Long_Form__c, Units_Preempted__c,
                                             Rate__c, LF_Brand__c, X800_Number__c, Name 
                                        FROM Schedules__c
                                        Where id in:ids 
                                        ORDER BY  Week__c, Day_of_Week__c, Long_Form__c]; 
        return schedules;
    }
    Public Date getStringToDate(String stringDate){
        //String Format is : Mon Aug 01 00:00:00 GMT 2011 
        
        String strDate = stringDate.subString(8,10);
        String strMonth = stringDate.subString(4,8);
        String strYear = stringDate.subString(24,28);
        
        system.debug('### Date : '+strDate);
        system.debug('### Month : '+strMonth);
        system.debug('### Year : '+strYear);
        
        Integer intMonth = getMonth(strMonth);
        Date dt = date.newInstance(Integer.valueOf(strYear), intMonth ,Integer.valueOf(strDate));
        
        return dt;
    }
    
    public Integer getMonth(String mnth){
        mnth = mnth.trim();
        Integer mn;
        if(mnth.EqualsIgnoreCase('Jan')){
            mn = 01;
        }else if(mnth.EqualsIgnoreCase('Feb')){
            mn = 02;
        }else if(mnth.EqualsIgnoreCase('Mar')){
            mn = 03;
        }else if(mnth.EqualsIgnoreCase('Apr')){
            mn = 04;
        }else if(mnth.EqualsIgnoreCase('May')){
            mn = 05;
        }else if(mnth.EqualsIgnoreCase('Jun')){
            mn = 06;
        }else if(mnth.EqualsIgnoreCase('Jul')){
            mn = 07;
        }else if(mnth.EqualsIgnoreCase('Aug')){
            mn = 08;
        }else if(mnth.EqualsIgnoreCase('Sep')){
            mn = 09;
        }else if(mnth.EqualsIgnoreCase('Oct')){
            mn = 10;
        }else if(mnth.EqualsIgnoreCase('Nov')){
            mn = 11;
        }else if(mnth.EqualsIgnoreCase('Dec')){
            mn = 12;
        }else if(mnth == 'Feb'){
        
        }
        return mn;
    }
    
    public void save(){
        //if(schedule.Rate__c != null){
            if(sechList != null && sechList.size() > 0){
                for(Schedules__c sech : sechList){
                    if(schedule.Week__c != null)
                        sech.Week__c = schedule.Week__c;
                        
                    if(schedule.Long_Form__c != null)
                        sech.Long_Form__c = schedule.Long_Form__c;

                    if(schedule.Rate__c != null)
                        sech.Rate__c = schedule.Rate__c;
                    
                    if(schedule.LF_Brand__c != null)
                        sech.LF_Brand__c = schedule.LF_Brand__c;
                    
                    if(schedule.X800_Number__c != null)
                        sech.X800_Number__c = schedule.X800_Number__c;
                    
                    if(schedule.Units_Preempted__c != null)
                        sech.Units_Preempted__c = schedule.Units_Preempted__c;
                }
                
                update sechList;
                
                closeWindow = true;                
            }
        //}
    }
    
    public PageReference cancel(){
        PageReference pg = new PageReference('/apex/TennisChannelTrafficGrid');
        return pg;
    }
}