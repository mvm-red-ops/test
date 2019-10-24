public with sharing virtual class PrelogDataSelector {

    public PrelogDataSelector() {}

    public virtual List<PrelogData__c> getProcessPrelogDataRecords(
            Map<String, PrelogDataMirror__c> UniqueIdPrelogDataMirrorMap) {
        return [
                SELECT Id,
                       Schedule__c,
                       Name,
                       PrelogDataMirrorReference__c
                  FROM PrelogData__c
                 WHERE PrelogDataMirrorReference__c IN :UniqueIdPrelogDataMirrorMap.keySet()
        ];
    }

    public virtual List<PrelogData__c> getPrelogDataForWeekReadOnly(Set<Id> dealWrapperIds, Date monday, Date sunday) {
        System.debug('DEAL WRAPPER IDs: ' + dealWrapperIds);
        return [
                SELECT Schedule__r.Deal_Parent__r.Brands__r.Name,
                       Schedule__r.OrderLineNumber__c,
                       Schedule__r.Days_Allowed_Formula__c,
                       Schedule__r.Start_Time__c,
                       Schedule__r.End_Time__c,
                       Schedule__r.Rate__c,
                       Schedule__r.MGM_HD_Daypart__c,
                       Day_of_Week__c,
                       Rate__c,
                       Schedule__r.Total_Dollars__c
                  FROM PrelogData__c
                 WHERE Schedule__r.Deal_Parent__c IN :dealWrapperIds
                   AND Current_Version__c = TRUE
                   AND AirDate__c >= :monday
                   AND AirDate__c <= :sunday
        ];
    }

    public virtual List<PrelogData__c> getPrelogDataForWeek(Set<Id> dealWrapperIds, Date week, String prelogVersion) {
        //** Modified the Query by Sanjay *//
        Date currentMonday = week;
        Date currentSunday = week.addDays(6);

        //String to hold the query
        String queryString = 'SELECT Schedule__r.Deal_Parent__r.Brands__r.Name, Schedule__r.OrderLineNumber__c,'
                + 'Schedule__r.Days_Allowed_Formula__c, Schedule__r.Start_Time__c, Schedule__r.Days_Allowed__c,'
                + 'Schedule__r.End_Time__c, Schedule__r.Rate__c, Schedule__c,'
                + 'Schedule__r.MGM_HD_Daypart__c, Day_of_Week__c,'
                + 'Rate__c, Schedule__r.Total_Dollars__c, Schedule__r.Units_Available__c,'
                + 'Schedule__r.Units_Aired__c, Schedule__r.Name, Schedule__r.Id,'
                + 'Schedule__r.Cap__c, Schedule__r.LastModifiedDate, Version__c '
                + 'FROM PrelogData__c '
                + 'WHERE Schedule__r.Deal_Parent__c IN: dealWrapperIds '
                + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday';

        //Check for version
        if(String.isNotBlank(prelogVersion)) {
            Integer tempInt = Integer.valueOf(prelogVersion);
            queryString += ' AND Version__c =: tempInt';
        }
        else {
            queryString += ' AND Current_Version__c = true';
        }

        return Database.query(queryString);
    }

    public virtual List<PrelogData__c> getPrelogDataWithDeals(List<Deal__c> deals, Date week, String prelogVersion) {
        //** Modified the Query by Sanjay *//
        Date currentMonday = week;
        Date currentSunday = week.addDays(6);

        // String to hold soql string
        // MG  APR20.2016    added  Version__c, Current_Version__c   with respect to
        // "sOQLString += ' AND Current_Version__c = true';"
        String sOQLString = 'SELECT Id, Version__c, Current_Version__c, Schedule__r.Deal_Parent__c,'
                + 'Schedule__r.Deal_Parent__r.name, Schedule__c, Schedule__r.Id, Schedule__r.Name,'
                + 'Schedule__r.Cap__c FROM PrelogData__c WHERE Schedule__r.Deal_Parent__c IN: deals '
                + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday ';

        //Check for version
        if(String.isNotBlank(prelogVersion)) {
            Integer tempInt = Integer.valueOf(prelogVersion);
            sOQLString += ' AND Version__c =: tempInt';
        }
        else {
            sOQLString += ' AND Current_Version__c = true';
        }

        System.debug('#### Query::  ' + sOQLString);

        return Database.query(sOQLString);
    }

    public virtual List<PrelogDataMirror__c> getMirrorsFromIds(List<Id> ids) {
        return [
                SELECT Id,
                        Name,
                        PrelogData__c,
                        Schedule__c
                FROM PrelogDataMirror__c
                WHERE Id IN :ids
        ];
    }

    public virtual List<AsyncApexJob> getJobsForMirrors() {
        return [
                SELECT Id,
                        ApexClassId,
                        Status FROM AsyncApexJob
                WHERE ((Status = 'Processing' OR Status = 'Queued' OR Status = 'Preparing')
                AND (ApexClass.Name='PrelogDataScheduleBatch' OR ApexClass.Name='PrelogDataBatch')
                AND JobType='BatchApex')
        ];
    }
}