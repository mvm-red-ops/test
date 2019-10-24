/**
 * @date 1/9/2019
 * @description Schedule Selector used for querying Schedule's via DML
 */
public with sharing virtual class ScheduleSelector {

    /**
     * @description The SObject being selected from
     */
    private final String OBJ = 'Schedules__c';

    /**
     * @description Retrieve a list of Schedule's with the specified fields
     *
     * @param fields The fields being specified to be retrieved from the list of schedules
     *
     * @return The retrieved list of schedules from the database
     */
    public virtual List<Schedules__c> getSchedules(List<SObjectField> fields) {
        return Database.query('SELECT ' + String.join(getFieldNames(fields), ', ') + ' FROM ' + OBJ);
    }

    public virtual Schedules__c getScheduleFromId(Id schId) {
        return [
                SELECT Id,
                       Status__c
                  FROM Schedules__c
                 WHERE Id = :schId
        ];
    }

    /**
     * @description Retrieve a list of Schedules from a list of provided selected ones
     *
     * @param selected The selected Schedules used to retrieve the list
     *
     * @return The retrieved list of Schedules
     */
    public virtual List<Schedules__c> getSchedulesFromSelected(List<Schedules__c> selected) {
        return [
                SELECT Id,
                       Name,
                       Deal_Parent__r.Program__c,
                       Deal_Parent__c,
                       Deal_Parent__r.Brands__c,
                       Deal_Parent__r.Contact__r.AccountId,
                       Week__c,
                       ISCI_CODE__c,
                       ISCI2__c,
                       ISCI3__c,
                       Rotation__c,
                       X800_Number__c,
                       UnitLength__c
                  FROM Schedules__c
                 WHERE Id IN:selected
                   AND Week__c != NULL
                   AND Deal_Parent__r.Program__c != NULL
                   AND Deal_Parent__r.Brands__c != NULL
                   AND Deal_Parent__r.Contact__r.AccountId != NULL
        ];
    }

    /**
     * @description Retrieve a list of schedules that contain the requested Tape__c
     *
     * @param TapeRecord The Tape__c being checked against
     *
     * @return The list of resulting Schedules
     */
    public virtual List<Schedules__c> getSchedulesFromTape(Tape__c TapeRecord) {
        return [
                SELECT Id,
                       Name,
                       Deal_Parent__r.Program__c,
                       Deal_Parent__c,
                       Deal_Parent__r.Brands__c,
                       Deal_Parent__r.Contact__r.AccountId,
                       Week__c,
                       ISCI_CODE__c,
                       ISCI2__c,
                       ISCI3__c,
                       Rotation__c,
                       X800_Number__c,
                       UnitLength__c
                  FROM Schedules__c
                 WHERE Week__c >= :TapeRecord.Flight_Start__c
                   AND Week__c <= :TapeRecord.Flight_End__c
                   AND Deal_Parent__r.Program__c = :TapeRecord.Program__c
                   AND Deal_Parent__r.Brands__c = :TapeRecord.Brand__c
                   AND Deal_Parent__r.Contact__r.AccountId = :TapeRecord.Account__c
                   AND UnitLength__c = :Decimal.valueOf(TapeRecord.Length__c)
        ];
    }

    public virtual List<Schedules__c> getSchedulesInWeek(Programs__c network) {
        return [
                SELECT Id,
                       PI_Payout_TEST__c,
                       CALC_EQUIV_30__c,
                       Total_Dollars__c,
                       Sum_Spot_Equiv_30__c,
                       Spot_Total__c,
                       Week__c,
                       Deal_Parent__r.Program__c,
                       Deal_Parent__r.Program__r.Id,
                       Daypart__c
                  FROM Schedules__c
                 WHERE Week__c = :network.RCreconciled_Week__c
                   AND Deal_Parent__r.Brands__r.Name != 'Availability'
                   AND COUNTMENOT__c != 'N'
                   AND Reconciled__c = 'Y'
                   AND Deal_Parent__r.Program__r.Id = :network.Id
        ];
    }

    public virtual List<Schedules__c> getSchedulesByContacts(List<Id> contactIds, Date lastMonday, Date thisMonday) {
        return [
                SELECT Id,
                       Deal_Parent__r.Contact__c,
                       Deal_Parent__c,Week__c,
                       Networks__c,
                       Units_Aired__c,
                       Deal_Parent__r.Program__r.Cable_Synd__c,
                       Deal_Parent__r.Program__r.Name,
                       Units_Preempted__c,
                       Prelog_Count__c,
                       Spot_Count__c
                  FROM Schedules__c
                 WHERE Week__c >= :lastMonday
                   AND Week__c <= :thisMonday
                   AND Deal_Parent__r.Contact__c IN :contactIds
                   AND Deal_Parent__c != NULL
                   AND (Spot_Count__c > 0
                    OR Prelog_Count__c > 0
                    OR Units_Preempted__c > 0
                    OR Units_Aired__c > 0)
        ];
    }

    public virtual List<Schedules__c> GetSchedulesForGenerateWeeklyBuy(Deal__c deal, Date minWeek) {
        return [
            SELECT Week__c,
                   Rate__c,
                   UnitLength__c,
                   Daypart__c,
                   Units_Available__c,
                   WO_Units__c,
                   Days_Allowed__c,
                   Start_Time__c,
                   End_Time__c
              FROM Schedules__c
             WHERE Deal_Parent__c = :deal.Id
               AND Week__c >= :minWeek
          ORDER BY Week__c
        ];
    }

    public virtual Deal__c getSchedulesForGetXMLFiles(Id dealId) {
        return [
            SELECT Name,
                   Id,
                   Advertiser__c,
                   Brands__r.Name,
                   Bundle_Start_Week__c,
                   Week_MIN_Field__c,
                   Week_Max__c,
                   ContactAccount__c,
                   Length__c,
                   Sum_of_Total_Dollars__c ,
                   Program__c,
                   CreatedDate,
                   Program__r.Bundle_Name__c,
                   Program__r.Logs_Contact__c,
                   Program__r.Logs_Contact__r.FirstName,
                   Program__r.Logs_Contact__r.LastName
              FROM Deal__c
             WHERE Id = :dealId];
    }
    public virtual List<Schedules__c> getSchedulesForgenerateBuylines(Deal__c deal) {
        return [
            SELECT Rate__c,
                   Days_Allowed__c,
                   Start_Time__c,
                   End_Time__c,
                   OrderLineNumber__c,
                   Daypart__c
              FROM Schedules__c
             WHERE Deal_Parent__c = :deal.Id
          ORDER BY Week__c
        ];
    }

    public virtual List<Schedules__c> getSchedulesForbuildScheduleList(Id dealId, Date bundleStartWeek) {
        return [
            SELECT Id,
                   Week__c
              FROM Schedules__c
             WHERE Deal_Parent__c = :dealId
               AND Week__c >= :bundleStartWeek
               AND XML_Sent__c = FALSE
          ORDER BY Week__c
        ];
    }

    public virtual List<Schedules__c> getSchedulesForBuildSpots(Id sch) {
        return [
                SELECT Id,
                       Units_Aired__c,
                       Sum_Spot_Equiv_30__c,
                       PI_Payout_TEST__c,
                       Spot_Total__c,
                       Rate__c,
                       Week__c,
                       Deal_Parent__r.Program__c,
                       DealBrand__c,
                       Deal_Parent__r.Program__r.Id,
                       UnitLength__c
                  FROM Schedules__c
                 WHERE Id = :sch
        ];
    }

    public virtual List<Schedules__c> getSchedulesFromDeal(Id dealId, Boolean filter) {
        // Query for all schedules on the deal, using the reconciled flag
        String query = 'SELECT ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c') + ' FROM Schedules__c WHERE Deal_Parent__c = \'' + dealId + '\'';
        if (filter) {
            query += ' AND Reconciled__c = \'N\'';
        }

        return Database.query(query);
    }

    public virtual List<Schedules__c> getSchedulesFromDealMGM(Id dealId, Boolean filter) {
        List<String> fieldsForQuery = SaberGF.getObjectsFieldsForQueriesFromFieldSet('Schedules__c', 'Deal_Revision');
        String queryString = '';
        for (String field: fieldsForQuery) {
            queryString += field + ', ';
        }
        queryString += 'SELECT ' + queryString + ' MGM_Hd_Daypart__c FROM Schedules__c WHERE Deal_Parent__c = \'' + dealId + '\'';
        if (filter) {
            queryString += ' AND Reconciled__c = \'N\'';
        }
        queryString += ' ORDER BY MilitaryTime__c, Rate__c';

        return Database.query(queryString);
    }

    public virtual List<Schedules__c> getSchedulesForWeek(Date week) {
        return [
                SELECT Id,
                       Deal_Parent__c
                  FROM Schedules__c
                 WHERE Status__c = 'Sold'
                   AND Week__c >=: week
                   AND Week__c <=: week.addDays(6)
        ];
    }

    public virtual List<Schedules__c> getSchedulesFromQuery(String query) {
        return Database.query(query);
    }

    /**
     * @description Helper method to retrieve  a list of field names (string) from a list of fields (SObjectFields)
     *
     * @param fields The fields being requested from
     *
     * @return The list of names from the requested fields
     */
    private List<String> getFieldNames(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}