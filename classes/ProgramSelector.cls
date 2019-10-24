/**

 *
 * ProgramSelector
 * Selector for Programs__c objects
 */

public with sharing virtual class ProgramSelector {
    private static String OBJ = 'Programs__c';

    public virtual List<Programs__c> GetPrograms(List<SObjectField> fields) {
        String query = 'SELECT ' + String.join(FieldsToStrings(fields), ', ') + ' FROM ' + OBJ;
        return Database.query(query);
    }

    public virtual List<Programs__c> GetProgramsWithIds(List<String> Ids) {
        return [
                SELECT Id,
                       Name,
                       RCreconciled_Week__c,
                       Team__c
                  FROM Programs__c
                 WHERE Id IN :Ids
        ];
    }

    public virtual List<Programs__c> getProgramsForBundleSpotsBatchStart(String network) {
        return [SELECT Id,
                       Reconciled_Week__c,
                       Name
                  FROM Programs__c
                 WHERE Name = :network];
    }


    private List<String> FieldsToStrings(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}