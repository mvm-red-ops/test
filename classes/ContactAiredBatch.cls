// cleaned out Tennis, DOC, and COZI fields
global class ContactAiredBatch implements Database.Batchable<SObject>
{
    global String BatchType;

    global ContactAiredBatch(String pBatchType)
    {
        this.BatchType = pBatchType;
    }

    global ContactAiredBatch()
    {
        //database.executebatch(new ContactAiredBatch(),50);
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([
                SELECT Id,
                       Name,
                       Pre_Log_Week__c,
                       Post_Log_Week__c,
                       Bounce_Post_Week__c,
                       MLB_Post_Log_Week__c,
                       AntennaTV_Post_Week__c,
                       ThisTV_Post_Week__c
                  FROM Contact
              ORDER BY Name
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope)
    {
            ContactAiredService contactAiredService = new ContactAiredService(BatchType);
            update contactAiredService.getAiredContacts(scope);
    }    

    global void finish(Database.BatchableContext BC)
    { 
    
    }
}