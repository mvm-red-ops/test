/**
 * @date 1/15/2019
 * @description Database Selector for Spot_Data__c objects
 */
public with sharing virtual class SpotDataSelector {

    public virtual List<Spot_Data__c> GetSpotDataWithScheduleIds(List<String> Ids) {
        return [
                SELECT Day_of_Week__c,
                       Spot_Equiv_30__c,
                       Spot_Rate__c
                  FROM Spot_Data__c
                 WHERE Schedule__c IN :Ids
        ];
    }

    public virtual Spot_Data__c[] getSpotsForSpotsExist(Id sch) {
        return [SELECT Schedule__c, Availability__c
                  FROM Spot_Data__c
                 WHERE Availability__c = true
                   AND Schedule__c = :sch];
    }


    private List<String> FieldsToStrings(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
  
    /**
     * @description Retrieve a list of Spot_Data__c objects from a provided mirror reference map
     * @param refMap The map being used to reference the SpotData
     * @return The resulting list of SpotData from the database
     */
    public virtual List<Spot_Data__c> getSpotDataFromReferenceMap(Map<String, SpotDataMirror__c> refMap) {
        return [
                SELECT Id,
                       Schedule__c,
                       Name,
                       SpotDataMirror_Reference__c
                  FROM Spot_Data__c
                 WHERE SpotDataMirror_Reference__c IN :refMap.keySet()
        ];
    }

    public virtual List<SpotDataMirror__c> getMirrorsFromIds(List<Id> ids) {
        return [
                SELECT Id,
                       Name,
                       Spot_Data__c,
                       Schedule__c
                  FROM SpotDataMirror__c
                 WHERE Id IN : ids
        ];
    }

    public virtual List<AsyncApexJob> getJobsForSpotData() {
        return [
                SELECT Id,
                       ApexClassId,
                       Status
                  FROM AsyncApexJob
                 WHERE ((Status = 'Processing' OR Status = 'Queued' OR Status = 'Preparing')
                   AND (ApexClass.Name='SpotDataScheduleBatch' OR ApexClass.Name='SpotDataBatch')
                   AND JobType='BatchApex' )
        ];
    }

}