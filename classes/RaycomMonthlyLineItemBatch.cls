global class RaycomMonthlyLineItemBatch implements Database.Batchable<sObject> {

    global static Boolean forceExceptionError {
        get {
            if(forceExceptionError == null) forceExceptionError = false;
            return forceExceptionError;
        }
        set;
    }
    
    webservice static void init() {
        Database.executeBatch(new RaycomMonthlyLineItemBatch(), 1);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([select 
                                         Id, 
                                         Key__c, 
                                         Invoice__c,
                                         Spot_Data_Failure_Count__c 
                                         from RaycomMonthlyLineItem__c
                                         where Spot_Data_Failure_Count__c < 3
                                        ]);
    }
    
    // expectation is this job is run with a batch size of 1 due to previously-indentified locking issues.
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        RaycomMonthlyLineItem__c lineItem = (RaycomMonthlyLineItem__c)scope[0];
        
        // limit at 9990 to save a few DML rows for delete or update process below.
        List<Spot_Data__c> spotDatas = [select 
                                    Id, 
                                    Raycom_Invoice_Number__c, 
                                    RaycomKeyIndexed__c 
                                    from Spot_Data__c 
                                    where RaycomKeyIndexed__c = :lineItem.Key__c 
                                    and Raycom_Invoice_Number__c = null 
                                    limit 9990
                                   ];
        
        List<Spot_Data__c> updatedSpotDatas = new List<Spot_Data__c>();
    
        for(Spot_Data__c sd : spotDatas) {
            sd.Raycom_Invoice_Number__c = lineItem.Invoice__c;
            updatedSpotDatas.add(sd);
        }    
    
        try {
            if(forceExceptionError == true) throw new TestException();
            if(!updatedSpotDatas.isEmpty()) update updatedSpotDatas;
        	delete lineItem;
        }
        catch(Exception ex) {
            // if it fails, increment the failure counter
            if(lineItem.Spot_Data_Failure_Count__c == null) lineItem.Spot_Data_Failure_Count__c = 0;
            lineItem.Spot_Data_Failure_Count__c = lineItem.Spot_Data_Failure_Count__c + 1;
            lineItem.Spot_Data_Failure_Message__c = ex.getMessage().left(4000);
            update lineItem;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
        List<RaycomMonthlyLineItem__c> retryLineItems = [select 
                                                         Id 
                                                         from RaycomMonthlyLineItem__c 
                                                         where Spot_Data_Failure_Count__c < 3
                                                         limit 1
                                                        ];
        
        if(!retryLineItems.isEmpty() && !Test.isRunningTest()) {
            Database.executeBatch(new RaycomMonthlyLineItemBatch(), 1);
        }
        
    }
    
    public class TestException extends Exception {}
    
}