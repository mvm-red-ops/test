/**
 * @date 1/14/2019
 * @description Query Deal__c objects from Database
 */
public with sharing virtual class DealSelector {

    /**
     * @description Retrieve deal info from a deal Id
     * @param dealId The dealId being retrieved from
     * @return The resulting list of Deal__c objects with their specified fields
     */
    public virtual List<Deal__c> getDealsFromId(Id dealId) {
        return [
                SELECT Id,
                       Name,
                       Advertiser__c,
                       Campaign__c,
                       Week_MIN_Field__c,
                       Brands__r.Name,
                       Bundle_Start_Week__c,
                       ContactAccount__c,
                       Length__c,
                       Program__c,
                       Program__r.Name,
                       CreatedDate,
                       Program__r.Bundle_Name__c,
                       Program__r.Logs_Contact__c,
                       Program__r.Logs_Contact__r.FirstName,
                       Program__r.Logs_Contact__r.LastName,
                       Network_Deal_Number__c,
                       Agency_Deal_Number__c,
                       Sum_of_Units_Available__c,
                       Sum_of_Total_Dollars__c
                  FROM Deal__c
                 WHERE Id = :dealId
        ];
    }

    public virtual List<Deal__c> getDealsFromQueryForRevision(
            String SOQLDateString,
            String tempstringListLoop,
            String programTeam,
            Boolean BarterCheckbox,
            String SelectedCableSynd,
            String limitAmt)
    {
        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,'
                + 'Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,'
                + 'Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,'
                + 'Program__r.Name, Advertiser__c '
                + ' From Deal__c '
                + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null '
                + SOQLDateString;
        if (BarterCheckbox) {
            DealQuery += ' AND Program__r.Barter__c = True ';
        }
        if (SelectedCableSynd != '' && SelectedCableSynd != null) {
            DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
        }
        if (programTeam != '' && programTeam != null) {
            DealQuery += ' AND Program_Team_del__c = \'' + programTeam + '\'';
        }
        DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit ' + limitAmt;

        return Database.query(DealQuery);
    }

    public virtual List<Deal__c> getDealsFromSearchQuery(
            String SOQLDateString,
            List<String> stringList,
            Period pr,
            Boolean BarterCheckbox,
            String SelectedCableSynd,
            String limitAmt)
    {
        return getDealsFromSearchQuery(SOQLDateString, stringList, pr, BarterCheckbox, SelectedCableSynd, null, limitAmt);
    }

    public virtual List<Deal__c> getDealsFromSearchQuery(
            String SOQLDateString,
            List<String> stringList,
            Period pr,
            Boolean BarterCheckbox,
            String SelectedCableSynd,
            String programTeam,
            String limitAmt)
    {
        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,'
                + 'Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name, Network_Deal_Number__c,'
                + 'Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, '
                + 'Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                + ' Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, '
                + '(SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') '
                + ' From Deal__c '
                + ' Where ';

        List<String> actualStrings = new List<String>();
        for (Integer i = 0; i < stringList.size(); i++) {
            if (stringList[i].trim() != '') {
                actualStrings.add('\'%' + stringList[i].trim() + '%\'');
            }
        }

        for (Integer i = 0; i < actualStrings.size(); i++) {
            String temp = actualStrings[i];
            DealQuery += ' (Program__r.Name Like ' + temp
            + ' OR Contact__r.Name Like ' + temp
            + ' OR Client_Account__r.Name Like ' + temp
            + ' OR Contact__r.Account.Name Like ' + temp
            + ' OR Brands__r.Name Like ' + temp
            + ' OR Network_Deal_Number__c Like ' + temp
            + ' OR Brands__r.Advertiser__r.Name Like ' + temp
            + ' OR Name Like ' + temp + ' )';
            if (i != actualStrings.size() - 1) {
                DealQuery += ' AND';
            }
        }

        DealQuery += ' AND Week_MIN_Field__c != null';

        if (pr != null) {
            Date start_date = pr.StartDate;
            Date end_date = pr.EndDate;
            DealQuery += ' AND Week_MIN_Field__c <= :end_date AND Week_MIN_Field__c >= :start_date';
        }

        DealQuery += SOQLDateString;

        if (BarterCheckbox != null && BarterCheckbox)
        {
            DealQuery += ' AND Program__r.Barter__c = True';
        }
        if (SelectedCableSynd != '' && SelectedCableSynd != null)
        {
            DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
        }
        if (programTeam != null && programTeam != '')
        {
            DealQuery += ' AND Program_Team__c = \'' + programTeam + '\'';
        }

        DealQuery += ' ORDER BY Week_MIN_Field__c DESC LIMIT ' + limitAmt;
        System.debug(DealQuery);
        return Database.query(DealQuery);
    }

    public virtual List<Deal__c> getDealsForAddReadOnly(Id dealId) {
        return [
                SELECT Id,
                       Contact__c,
                       ContactAccount__c,
                       Contact__r.Name,
                       Contact__r.AccountId,
                       Contact__r.Account.Name,
                       Sum_of_Total_Dollars__c,
                       Sum_of_Units_Available__c,
                       Program__r.Name,
                       Program__r.Reconciled_Week__c,
                       Brands__c,
                       Brands__r.Name,
                       Name,
                       Week_MIN_Field__c,
                       Length__c,
                       SF_Deal_ID__c
                  FROM Deal__c
                 WHERE Id = :dealId
        ];

    }

    public virtual List<Deal__c> getDealsForAdd(Id dealId, Date week) {
        return [
                SELECT Id,
                       Name,
                       Contact__c,
                       ContactAccount__c,
                       Campaign__c,
                       Contact__r.Name,
                       Contact__r.AccountId,
                       Contact__r.Account.Name,
                       Sum_of_Total_Dollars__c,
                       Sum_of_Units_Available__c,
                       Program__c,
                       Program__r.Prelog_Date_Time__c,
                       Program__r.Name,
                       Program__r.Reconciled_Week__c,
                       Brands__c, Brands__r.Name,
                       Week_MIN_Field__c,
                       Length__c,
                       SF_Deal_ID__c,
                       Advertiser_ID__c,
                       Advertiser__c, (
                           SELECT Name,
                                  Deal_Parent__r.Brands__r.Name,
                                  OrderLineNumber__c,
                                  Days_Allowed_Formula__c,
                                  Start_Time__c,
                                  Days_Allowed__c,
                                  End_Time__c,
                                  Rate__c,
                                  MGM_HD_Daypart__c,
                                  Total_Dollars__c,
                                  Units_Available__c,
                                  Units_Aired__c,
                                  Cap__c,
                                  LastModifiedDate
                             FROM Schedules__r
                            WHERE Status__c = 'Sold'
                              AND Week__c =: week
                       )
                  FROM Deal__c
                 WHERE Id =: dealId
        ];
    }

    public virtual List<Deal__c> getDealsFromQuery(String query) {
        return Database.query(query);
    }
}