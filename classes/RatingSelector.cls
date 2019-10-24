/**

 *
 * RatingsSelector
 * Selector for Rating_compiled__c objects
 */

public with sharing virtual class RatingSelector {
    private static String OBJ = 'Ratings_compiled__c';

    public virtual List<Ratings_compiled__c> GetRatings(List<SObjectField> fields) {
        String query = 'SELECT ' + String.join(FieldsToStrings(fields), ', ') + ' FROM ' + OBJ;
        return Database.query(query);
    }

    public virtual List<Ratings_compiled__c> GetRatingsForProgram(Programs__c program) {
        return [SELECT Program__c, Week__c, Type__c FROM Ratings_compiled__c
            WHERE Program__c = :program.Id
            AND Week__c = :program.RCreconciled_Week__c
            AND Type__c = 'actual'];
    }


    private List<String> FieldsToStrings(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}