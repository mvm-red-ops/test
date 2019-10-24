global class InvokeContactBatch implements Schedulable{
    
    global void execute(SchedulableContext SC){   
        Database.executeBatch(new ContactAiredBatch('PreLogButton'),10);
        Database.executeBatch(new ContactAiredBatch('PostLogButton'),10);
        Database.executeBatch(new ContactAiredBatch('NextWeekPreLogButton'),10);
        
    }

}