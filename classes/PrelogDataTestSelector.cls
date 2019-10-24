public with sharing class PrelogDataTestSelector extends PrelogDataSelector {
    public override List<PrelogData__c> getProcessPrelogDataRecords(Map<String, PrelogDataMirror__c> UniqueIdPrelogDataMirrorMap) {
        return [
                SELECT Id,
                       Schedule__c,
                       Name,
                       PrelogDataMirrorReference__c
                  FROM PrelogData__c
                 WHERE PrelogDataMirrorReference__c IN :UniqueIdPrelogDataMirrorMap.keySet()
        ];
    }
}