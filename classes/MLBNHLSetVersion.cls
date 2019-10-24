/**
* @author Adrian Pichardo
* @date 08/22/2018
* @description Set version on prelog data mirrors to the version number listed on the Program.
**/

global class MLBNHLSetVersion implements Database.batchable <sobject>
{
    global String network;
    global class ApplicationException extends Exception {}

    global MLBNHLSetVersion(String n)
    {
            this.network = n;
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
        Integer versionNumber = 99;

        return Database.getQueryLocator('SELECT Id, Version__c ' +
                        'FROM PrelogDataMirror__c ' + 
                        'WHERE Network__c = :network ' +
                        'AND Version__c = :versionNumber ' +
                        'AND CreatedDate = TODAY');
    }

    global void execute(Database.BatchableContext bc, List<PrelogDataMirror__c> records){
               
       Integer i;
        
       Programs__c[] prog = [SELECT Id, Name, Prelog_Version__c
                        FROM Programs__c 
                        WHERE Name = :network];

       Decimal prelogVersion = prog[0].Prelog_Version__c;

       for(i = 0; i < records.size(); i++){
       		records[i].Version__c = prelogVersion;
       }
        
       database.update(records);
    }    

    global void finish(Database.BatchableContext bc){
        //Necessary for Batch code
    }

}