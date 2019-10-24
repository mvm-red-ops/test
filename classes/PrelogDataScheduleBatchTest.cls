@IsTest
public with sharing class PrelogDataScheduleBatchTest {

    private static PrelogDataMirror__c createPrelogDataMirror(String dealNumber, Schedules__c mirrorSchedule) {
        PrelogDataMirror__c mirror = new PrelogDataMirror__c();
        mirror.NetworkDealNumber__c = dealNumber;
        mirror.Network__c = 'test';
        mirror.ScheduleLength__c = '1';
        mirror.AirDate__c = Date.today().toStartOfWeek().addDays(-6);
        mirror.ScheduleTime__c = '6:01:00AM';
        mirror.Rate__c = 100;
        mirror.Version__c = 1;
        mirror.Schedule__c = mirrorSchedule.Id;

        return mirror;
    }

    private static PrelogData__c createPrelogDataRecord(Id scheduleId, PrelogDataMirror__c rec) {
        PrelogData__c PrelogDataRec = new PrelogData__c();
        PrelogDataRec.AdvertiserProduct__c = rec.AdvertiserProduct__c;
        PrelogDataRec.Agency__c = rec.Agency__c;
        PrelogDataRec.AirDate__c = rec.AirDate__c;
        PrelogDataRec.BreakCode__c = rec.BreakCode__c;
        PrelogDataRec.MaterialDescription__c = rec.MaterialDescription__c;
        PrelogDataRec.OrderProductDescription__c = rec.OrderProductDescription__c;
        PrelogDataRec.PrelogDataMirror__c = rec.Id;
        PrelogDataRec.Rate__c = rec.Rate__c;
        PrelogDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        PrelogDataRec.Schedule__c = scheduleId;
        PrelogDataRec.ScheduleAdID__c = rec.ScheduleAdID__c;
        PrelogDataRec.ScheduleLength__c = rec.ScheduleLength__c;
        PrelogDataRec.ScheduleTime__c = rec.ScheduleTime__c;
        PrelogDataRec.TimePeriod__c = rec.TimePeriod__c;
        PrelogDataRec.Version__c = rec.Version__c;
        return PrelogDataRec;
    }

    private static Account createAccount() {
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        return testAcct;
    }

    private static Contact createContact(Account testAcct){
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Name';
        contact.Email = 'test@testemail.com';
        contact.Phone = '(758) 771-0091';
        contact.Account = testAcct;
        return contact;
    }

    static Deal__c createDeal(Contact testContact, String dealNumber) {
        Deal__c testDeal = new Deal__c();
        testDeal.Contact__c = testContact.Id;
        System.debug(testDeal.Contact__c);
        testDeal.Network_Deal_Number__c = dealNumber;
        return testDeal;
    }

    private static Schedules__c createSchedule(Deal__c testDeal) {

        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = testDeal.Id;
        schedule.Week__c = Date.newInstance(2019, 1, 7);
        schedule.Days_Allowed__c = 'Mon';
        schedule.Start_Time__c = '06:00A';
        schedule.End_Time__c = '06:30A';
        schedule.Rate__c = 100;
        schedule.Units_Available__c = 5;
        return schedule;
    }

    public class PrepReturn{
        List<PrelogData__c> prelogDataList;
        PrelogDataMirror__c prelogDataMirror;
    }

    private static PrepReturn prepForBatchTest() {
        List<PrelogData__c> preLogDataList = new List<PrelogData__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Deal__c> dealList = new List<Deal__c>();
        List<Schedules__c> scheduleList = new List<Schedules__c>();


        Integer dataAmount = 1;
        Integer i = 0;
        for (i = 0; i < dataAmount; i++) {
            accountList.add(createAccount());
        }

        insert accountList;


        for (i = 0; i < dataAmount; i++) {
            contactList.add(createContact(accountList[i]));
        }

        insert contactList;

        for (i = 0; i < dataAmount; i++) {
            dealList.add(createDeal(contactList[i], String.valueOf(i)));
        }

        insert dealList;

        for (i = 0; i < dataAmount; i++) {
            scheduleList.add(createSchedule(dealList[i]));
        }

        insert scheduleList;

        PrelogDataMirror__c prelogDataMirror = createPrelogDataMirror('10', scheduleList[0]);
        insert prelogDataMirror;

        for (i = 0; i < dataAmount; i++) {
            preLogDataList.add(createPrelogDataRecord(scheduleList[i].Id, prelogDataMirror));
        }

        insert preLogDataList;

        PrepReturn funcReturn = new PrepReturn();

        funcReturn.prelogDataMirror = prelogDataMirror;
        funcReturn.prelogDataList = preLogDataList;
        return funcReturn;
    }

    private static List<PrelogDataMirror__c> selectDataMirrors() {
        return [
                SELECT PrelogData__c
                  FROM PrelogDataMirror__c
        ];
    }

    @IsTest
    private static void prelogDataScheduleBatch_executePrelogBatch_prelogDataBatchedCorrectly() {
        PrepReturn prepReturn = prepForBatchTest();
        PrelogDataMirror__c prelogDataMirror = prepReturn.prelogDataMirror;
        List<PrelogData__c> prelogDataList = prepReturn.prelogDataList;



        List<Id> prelogDataMirrorIdList = new List<Id>();
        prelogDataMirrorIdList.add(prelogDataMirror.Id);

        Test.startTest();
        PrelogDataScheduleBatch testBatch = new PrelogDataScheduleBatch(prelogDataMirrorIdList);
        testBatch.setPrelogDataSelector(new PrelogDataSelector());
        Database.executeBatch(testBatch);
        Test.stopTest();
        List<PrelogDataMirror__c> dataMirrorReturn = selectDataMirrors();
        System.assertNotEquals(dataMirrorReturn[0].PrelogData__c, prelogDataList[0].Id);
    }
}