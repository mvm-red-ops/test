@IsTest
public with sharing class XMLOSIDealTest {

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
        testDeal.Contact__c = testContact.id;
        testDeal.Network_Deal_Number__c = dealNumber;
        return testDeal;
    }

    private static Schedules__c createSchedule(Deal__c testDeal) {

        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = testDeal.id;
        schedule.Week__c = Date.newInstance(2019, 1, 7);
        schedule.Days_Allowed__c = 'Mon';
        schedule.Start_Time__c = '06:00A';
        schedule.End_Time__c = '06:30A';
        schedule.Rate__c = 100;
        schedule.Units_Available__c = 5;
        return schedule;
    }

    private static PrelogData__c createPrelogDataRecord(Id scheduleId, PrelogDataMirror__c rec)
    {
        PrelogData__c PrelogDataRec = new PrelogData__c();
        PrelogDataRec.AdvertiserProduct__c = rec.AdvertiserProduct__c;
        PrelogDataRec.Agency__c = rec.Agency__c;
        PrelogDataRec.AirDate__c = rec.AirDate__c;
        PrelogDataRec.BreakCode__c = rec.BreakCode__c;
        PrelogDataRec.MaterialDescription__c = rec.MaterialDescription__c;
        PrelogDataRec.OrderProductDescription__c = rec.OrderProductDescription__c;
        PrelogDataRec.PrelogDataMirror__c = rec.id;
        PrelogDataRec.Rate__c = rec.Rate__c;
        PrelogDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        PrelogDataRec.Schedule__c = ScheduleId;
        PrelogDataRec.ScheduleAdID__c = rec.ScheduleAdID__c;
        PrelogDataRec.ScheduleLength__c = rec.ScheduleLength__c;
        PrelogDataRec.ScheduleTime__c = rec.ScheduleTime__c;
        PrelogDataRec.TimePeriod__c = rec.TimePeriod__c;
        PrelogDataRec.Version__c = rec.Version__c;
        insert PrelogDataRec;
        return PrelogDataRec;
    }

    private static PrelogDataMirror__c createPrelogDataMirror(String dealNumber) {
        PrelogDataMirror__c mirror = new PrelogDataMirror__c();
        mirror.NetworkDealNumber__c = dealNumber;
        mirror.Network__c = 'test';
        mirror.ScheduleLength__c = '1';
        mirror.AirDate__c = date.today().toStartofWeek().addDays(-6);
        mirror.ScheduleTime__c = '6:01:00AM';
        mirror.Rate__c = 100;
        mirror.Version__c = 1;

        return mirror;
    }

    @IsTest
    private static void XMLOSIDeal_XMLOSIDeal_test() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '5');
        insert testDeal;
        //testDeal.ContactAccount__c = 'testAccount';
        //Account dealAccount = createAccount();
        //testDeal.ContactAccount__r = dealAccount;
        OSIxml.setScheduleSelector(new ScheduleTestSelector());
        Test.setCurrentPageReference(new PageReference('Page.XMLOSIDeal'));
        System.currentPageReference().getParameters().put('id', testDeal.Id);
        XMLOSIDeal.setDealSelector(new DealTestSelector());
        XMLOSIDeal XMLOSIDealTest = new XMLOSIDeal();
        XMLOSIDealTest.programId = 'test';
        XMLOSIDealTest.bundleName = 'test';
        XMLOSIDeal.getXMLFiles(testDeal.id);
    }

    private static List<Schedules__c> setupMarkXMLSent(Integer totalSchedules) {
        List<Schedules__c> scheduleList = new List<Schedules__c>();
        List<Deal__c> dealList = new List<Deal__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<String> scheduleIdList = new List<String>();

        Integer i = 0;

        for (i = 0; i < totalSchedules; i++) {
            accountList.add(createAccount());
        }
        insert accountList;

        for (i = 0; i < totalSchedules; i++) {
            contactList.add(createContact(accountList[i]));
        }
        insert contactList;

        Deal__c testDeal;
        for (i = 0; i < totalSchedules; i++) {
            dealList.add(createDeal(contactList[i], String.valueOf(i)));
        }
        insert dealList;

        Schedules__c testSchedule;
        for (i = 0; i < totalSchedules; i++) {
            testSchedule = createSchedule(dealList[i]);
            testSchedule.XML_Sent__c = true;
            scheduleList.add(createSchedule(dealList[i]));
        }
        insert scheduleList;
        return scheduleList;
    }

    private static List<Schedules__c> getSchedulesForMarkXMLSent(List<Id> scheduleIdList) {
        return [SELECT Id,
                       XML_Sent__c
                  FROM Schedules__c
                 WHERE Id IN :scheduleIdList];
    }

    @IsTest
    private static void XMLOSIDeal_markXMLSent_XMLMarkedAsSent() {
        Integer totalSchedules = 5;
        List<Schedules__c> scheduleList = setupMarkXMLSent(totalSchedules);
        List<Id> scheduleIdList = new List<Id>();


        for (Schedules__c schedule : scheduleList) {
            scheduleIdList.add(schedule.Id);
        }

        String scheduleIdsString = String.join(scheduleIdList, ';');

        System.assert(XMLOSIDeal.markXMLSent(scheduleIdsString).equals('SUCCESS'));
        scheduleList = getSchedulesForMarkXMLSent(scheduleIdList);
        System.assert(scheduleList.size() == totalSchedules);
        Integer i = 0;
        for (i = 0; i < scheduleList.size(); i++){
            System.assert(scheduleList[i].XML_Sent__c == False);
        }
        System.assert(OSIxml.markXMLSent(Null).equals('Attempt to de-reference a null object'));
    }

    private static List<Schedules__C> findTestSchedules(Schedules__c testSchedule){
        return [SELECT Id,
                       XML_Sent__c
                  FROM Schedules__c
                 WHERE Id = :testSchedule.Id];
    }

    private static List<Attachment> findAttachemnts(PrelogData__c testRecord) {
        return [SELECT Name,
                       Body,
                       ParentId
                  FROM Attachment
                 WHERE ParentId = :testRecord.Id];
    }

    @isTest static void XMLOSIDeal_SaveData_test() {
        Account testAccount = createAccount();
        insert testAccount;
        Contact testContact = createContact(testAccount);
        insert testContact;
        Deal__c testDeal = createDeal(testContact, '5');
        insert testDeal;
        Schedules__c testSchedule = createSchedule(testDeal);
        insert testSchedule;
        PrelogDataMirror__c testPrelogDataMirror = createPrelogDataMirror(testDeal.Network_Deal_Number__c);
        insert testPrelogDataMirror;
        PrelogData__c testRecord = createPrelogDataRecord(testSchedule.Id, testPrelogDataMirror);

        System.assert(XMLOSIDeal.saveData(testRecord.Id, 'fileNametest', 'SEVMTE8gVEhFUkUh').equals('SUCCESS'));
        List<PrelogData__c> testRecordList = new List<PrelogData__c>();
        List<Schedules__C> testScheduleList = findTestSchedules(testSchedule);
        System.assert(testScheduleList.size() == 1);
        List<Attachment> attachmentList = findAttachemnts(testRecord);
        System.assert(attachmentList.size() == 1);
        System.assert(attachmentList[0].Name == 'fileNameTest');
        System.assert(EncodingUtil.base64Encode(attachmentList[0].Body).equals('SEVMTE8gVEhFUkUh'));
    }
}