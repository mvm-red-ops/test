/**
 * ContactSelector
 * @description Database selector for Contact objects
 */

public with sharing virtual class ContactSelector {
    public virtual List<Contact> GetContactsByName(String name) {
        return [
                SELECT Id,
                        Name,
                        Bounce_Prelog_Week__c,
                        Bounce_Post_Week__c,
                        Pre_Log_Week__c,
                        Post_Log_Week__c,
                        BuzzrTVPostLogWeek__c
                FROM Contact
                WHERE Name = :name
        ];
    }
}