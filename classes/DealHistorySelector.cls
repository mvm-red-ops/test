/**
 * DealHistorySelector
 * @description
 */

public with sharing virtual class DealHistorySelector {

    public virtual List<Deal__History> getDealHistoriesByParent(String dealId) {
        return [
            SELECT ParentId,
                   OldValue,
                   NewValue,
                   Field,
                   CreatedDate
              FROM Deal__History
             WHERE ParentId = :dealId
               AND Field = 'Bundle_Start_Week__c'
               AND CreatedDate = TODAY
        ];
    }
}