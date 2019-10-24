/**

 *
 * SpotDataTestSelector
 * Selector for Spot_Data__c objects
 */

public with sharing class SpotDataTestSelector extends SpotDataSelector {

//    public override List<Spot_Data__c> GetSpotData(List<SObjectField> fields) {
//        String query = 'SELECT ' + String.join(FieldsToStrings(fields), ', ') + ' FROM ' + OBJ;
//        return Database.query(query);
//    }

    public override List<Spot_Data__c> GetSpotDataWithScheduleIds(List<String> Ids) {
        return new List<Spot_Data__c> {
                (Spot_Data__c) new sfab_FabricatedSObject(Spot_Data__c.class)
                    .setField(Spot_Data__c.Day_of_Week__c, 'Mon,Sat')
                    .setField(Spot_Data__c.Spot_Equiv_30__c, 1.0)
                    .setField(Spot_Data__c.Spot_Rate__c, 1.0)
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