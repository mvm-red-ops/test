/**

 *
 * RatingsSelector
 * Testing Selector for Ratings_compiled__c objects
 */

public with sharing class RatingTestSelector extends RatingSelector {
    private static String OBJ = 'Ratings_compiled__c';

    public override List<Ratings_compiled__c> GetRatings(List<SObjectField> fields) {
        String query = 'SELECT ' + String.join(FieldsToStrings(fields), ', ') + ' FROM ' + OBJ;
        return Database.query(query);
    }

    public override List<Ratings_compiled__c> GetRatingsForProgram(Programs__c program) {
        return new List<Ratings_compiled__c> { (Ratings_compiled__c)
                new sfab_FabricatedSObject(Ratings_compiled__c.class)
                .setField(Ratings_compiled__c.Program__c, program.Id)
                .setField(Ratings_compiled__c.Week__c, program.RCreconciled_Week__c)
                .setField(Ratings_compiled__c.Type__c, 'actual')
                .toSObject()
        };
    }


    private List<String> FieldsToStrings(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}