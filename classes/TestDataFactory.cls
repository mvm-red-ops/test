@IsTest
public with sharing class TestDataFactory {

    public static Account account(Boolean insertAccount) {
        Account account = new Account(Name = 'Test');

        if (insertAccount) insert account;

        return account;
    }

    public static Contact contact(Boolean insertContact) {
        return contact(account(true).Id, insertContact);
    }

    public static Contact contact(Id accountId, Boolean insertContact) {
        Contact contact = new Contact(AccountId = accountId, LastName = 'Test', Email = 'test@test.com', Phone = '5555555555');

        if (insertContact) insert contact;

        return contact;
    }

    public static Deal__c deal(Boolean insertDeal) {
        return deal(contact(true).Id, insertDeal);
    }

    public static Deal__c deal(Id contactId, Boolean insertDeal) {
        Deal__c deal = new Deal__c(Contact__c = contactId);

        if (insertDeal) insert deal;

        return deal;
    }

    public static Schedules__c schedule(Boolean insertSchedule) {
        return schedule(deal(true).Id, insertSchedule);
    }

    public static Schedules__c schedule(Id dealId, Boolean insertSchedule) {
        return schedule(
            dealId,
            Date.today().toStartOfWeek().addDays(1),
            0,
            0,
            insertSchedule
        );
    }

    public static Schedules__c schedule(Id dealId, Date week, Decimal unitsAvailable, Decimal rate, Boolean insertSchedule) {
        Schedules__c schedule = new Schedules__c(
            Deal_Parent__c = dealId,
            Week__c = week,
            Units_Available__c = unitsAvailable,
            Rate__c = rate
        );

        if (insertSchedule) insert (SObject) schedule;

        return schedule;
    }
}