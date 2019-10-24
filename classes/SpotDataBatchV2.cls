global class SpotDataBatchV2 implements Database.Batchable <SObject>
{
    global static Integer Increment = 0;
    global static Map<String, SpotDataMirror__c> UniqueIdSpotDataMirrorMap = new Map<String, SpotDataMirror__c>();
    global String network ;
    global List<Id> SpotDataMirrorIdList;

    global SpotDataBatchV2(List<Id> pSpotDataMirrorIdList)
    {
        SpotDataMirrorIdList = pSpotDataMirrorIdList;
    }
    global SpotDataBatchV2(String network)
    {
        this.network = network;
    }

    global database.QueryLocator start(Database.BatchableContext BC)
    {
        updateBatchNetworkCustomSetting();
        return Database.getQueryLocator(SpotDataMirrorService.buildQueryForSpotDataBatch(network));
    }

    global void execute(Database.BatchableContext BC, List<SpotDataMirror__c> scope)
    {
        System.debug('Scope: '+ scope);
        SpotDataMirrorService.createSpotDataFromMirrors(scope);
    }
    global void finish(Database.BatchableContext BC)
    {
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(this.network);
        current.isProcessingSpot__c = false ;
        update current ;
        
        //we should send an email to support with the error. 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()}; 
        mail.setToAddresses(toAddresses); 
        mail.setSubject('MV: Apex Spot Data Batch Job Completion');
        mail.setPlainTextBody(
            'NOTE: The Spot Data Batch Process has finished. Please check the Spot Data.\n\n'
        );
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {
        }
    }
    

    private void updateBatchNetworkCustomSetting() {
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(this.network);
        current.isProcessingSpot__c = true ;
        update current ;
    }
}