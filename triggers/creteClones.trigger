trigger creteClones on Schedules__c (after Insert) {
    List<Schedules__c> cloneList=new List<Schedules__c>(); 
    List<Schedules__c> newClones=new List<Schedules__c>(); 
    Integer totalSchedules;
    
    //Creating list for records to be cloned 
    For(Schedules__c schedule: Trigger.new)
    {
        
         if(schedule.Total_Schedules__c!=null && Integer.valueOf(schedule.Total_Schedules__c)>0)
         {
             cloneList.add(schedule);
         }
    }

    //Loop for Creating clones
    For(Schedules__c baseClone:cloneList)
    {
        integer days=7;
        For(integer i=0;i<Integer.valueOf(baseClone.Total_Schedules__c);i++)
        {
             Schedules__c newRecord = baseClone.clone(false,true);
             newRecord.Total_Schedules__c='0';
             if(baseClone.Week__c!=null)
             newRecord.week__c=baseClone.Week__c.addDays(days);
             newClones.add(newRecord);
             if(newClones.size()==200)
             {
                 insert newClones;
                 newClones=new List<Schedules__c>(); 
             }
             days=days+7;   
        }
    }

    if(newClones.size()!=0) insert newClones;
}