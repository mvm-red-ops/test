global class OrderNumberBatch implements Database.Batchable<sObject> 
{    

    global OrderNumberBatch()
    {
        //database.executebatch(new OrderNumberBatch(),50);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT id, OrderNumber__c, Days_Allowed__c, Start_Time__c, End_Time__c, Rate__c 
                                         FROM Schedules__c 
                                         WHERE Days_Allowed__c!= NULL AND Start_Time__c!=NULL AND End_Time__c!=NULL ]);
    }

    global void execute(Database.BatchableContext BC, List<Schedules__c > scope)
    {
        List<Schedules__c> ScheduleToUpdate = new List<Schedules__c>();
        
        for(Schedules__c sch : scope)
        {
            try
            {
                if(sch.rate__c == null)
                {
                    sch.rate__c = 0;    
                }
                ScheduleToUpdate.add(sch);    
            }
            catch(exception e)
            {
                system.debug(sch.id);          
            }   
        }    
        update ScheduleToUpdate;         
    }           
    global void finish(Database.BatchableContext BC)
    { 
    
    }
}