trigger updateScheduleStatus on Deal__c (after update) {
    List<Deal__c> dealList = new List<Deal__c>();
    List<Schedules__c> scheduleList = new List<Schedules__c>();
    Map<String, List<Schedules__c>> dealScheduleMap = new Map<String,List<Schedules__c>>();
    List<Schedules__c> updateScheduleList = new List<Schedules__c>();
    boolean isAdded = false;
    Integer i =0,listSize=0;
    List<Schedules__c> sList = new List<Schedules__c>();
    dealList =[select id,LTC_Date__c from Deal__c where id in: Trigger.NewMap.keySet()];
    
    scheduleList = [select id,  Deal_Parent__c, Week__c, Status__c 
                        from Schedules__c 
                        where Deal_Parent__c in: Trigger.NewMap.keySet()
                        order by Deal_Parent__c];
                        
    for(Schedules__c sch: scheduleList){
        //dealScheduleMap.get(sch.Deal_Parent__c);
        listSize++;
        if(i==0){
        	   sList.add(sch);
        	   isAdded = true;         	         	   
        }else if(sList.get(i-1).Deal_Parent__c == sch.Deal_Parent__c){
        	sList.add(sch);        	
        }else{        		
        		i=0;
        		isAdded  = false;        	
        }
        if((i==0 && isAdded  == false ) || listSize == scheduleList.size() ){
        	dealScheduleMap.put(sList.get(0).Deal_Parent__c,sList);
        	sList = new List<Schedules__c>();        	
	        sList.add(sch);
	        isAdded  = false;
        }
        i++;
        /*if(sList == null){
        	dealScheduleMap.put(sch.Deal_Parent__c,new List<Schedules__c>{sch});
        }*/
        
    }
    
    for(Deal__c dl:dealList){
        if(dl.LTC_Date__c != null && dl.LTC_Date__c != Trigger.OldMap.get(dl.Id).LTC_Date__c){
            if(dealScheduleMap.containsKey(dl.Id)){
                List<Schedules__c> scList = dealScheduleMap.get(dl.Id);
                for(Schedules__c sc: scList){
	                if(dl.LTC_Date__c < sc.Week__c){
	                    sc.Status__c = 'Canceled';
	                    updateScheduleList.add(sc);
	                }
                }
            }
            
        }   
    }
    update updateScheduleList;
}