@IsTest
public with sharing class BundleSpotsBatchTest {

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


    private static Programs__c createProgram(String dealNumber) {
        Programs__c program = new Programs__c();
        program.Name = 'testNetwork';
        program.Cable_Synd__c = 'Cable';
        program.Station_Call_Letter__c = Utils.generateRandomCallsign();
        program.ClientCode__c = dealNumber;
        program.Clock_Start_Time__c = '';
        program.Reconciled_Week__c = Date.newInstance(2019, 1, 7);
        return program;
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

    private static Station__c createStation() {
        Station__c testStation = new Station__c();
        testStation.Call_Letters__c = Utils.generateRandomCallsign();
        return testStation;

    }

    private static Bundle_Pricing__c createBundlePricing(Programs__c testProgram, Station__c testStation, Stationn__c testStationn) {
        Bundle_Pricing__c testBundlePricing = new Bundle_Pricing__c();
        testBundlePricing.Program__c = testProgram.Id;
        testBundlePricing.Rate_per_30__c = 35;
        testBundlePricing.Station__c = testStation.Id;
        testBundlePricing.Active__c = true;
        testBundlePricing.Units__c = 35;
        testBundlePricing.Stationn__c = testStationn.Id;
        testBundlePricing.Start_Time__c = '6:00A';
        return testBundlePricing;
    }

    private static Markett__c makeMarkett() {
        return new Markett__c();
    }

    private static Stationn__c createStationn(Markett__c testMarkett) {
        Stationn__c testStationn = new Stationn__c();
        testStationn.Markett__c = testMarkett.id;
        testStationn.Call_Letters__c = Utils.generateRandomCallsign();
        return testStationn;
    }



    private static void prepExecuteTest(Integer totalPrograms) {
        List<Schedules__c> scheduleList = new List<Schedules__c>();
        List<Deal__c> dealList = new List<Deal__c>();
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Programs__c> programList = new List<Programs__c>();
        List<Bundle_Pricing__c> bundlePricingList = new List<Bundle_Pricing__c>();
        List<Station__c> stationList = new List<Station__c>();
        List<Markett__c> markettList = new List<Markett__c>();
        List<Stationn__c> stationnList = new List<Stationn__c>();
        Integer i = 0;
        for (i = 0; i < totalPrograms; i++) {
            accountList.add(createAccount());
            contactList.add(createContact(accountList[i]));
            markettList.add(makeMarkett());
        }

        insert accountList;
        insert contactList;
        insert markettList;

        for (i = 0; i < totalPrograms; i++){
            programList.add(createProgram(String.valueOf(i)));
            stationList.add(createStation());
            stationnList.add(createStationn(markettList[i]));
        }

        insert stationList;
        insert stationnList;
        insert programList;


        i = 0;
        Deal__c tempDeal;
        for (Contact contact : contactList) {
            tempDeal = createDeal(contact, String.valueOf(i));
            tempDeal.Program__c = programList[i].id;
            dealList.add(tempDeal);
            i++;
        }

        insert dealList;
        for (Deal__c deal : dealList) {
            scheduleList.add(createSchedule(deal));
        }

        insert scheduleList;


        for (i = 0; i < totalPrograms; i++) {
            bundlePricingList.add(createBundlePricing(programList[i], stationList[i], stationnList[i]));
        }



        insert bundlePricingList;
    }

    @IsTest
    private static void BundleSpotsBatch_execute_correctAmountOfSpotsFound() {
        Integer totalPrograms = 5;
        prepExecuteTest(totalPrograms);

        Test.startTest();
        BundleSpotsBatch testBatch = new BundleSpotsBatch('testNetwork');
        testBatch.setBundleSelector(new BundleTestSelector());
        testBatch.setScheduleSelector(new ScheduleTestSelector());
        testBatch.setProgramSelector(new ProgramTestSelector());
        testBatch.setSpotDataSelector(new SpotDataTestSelector());
        Database.executeBatch(testBatch);
        Test.stopTest();

        List<Spot_Data__c> returnedSpotData = [SELECT Id FROM Spot_Data__c];
        System.assert(returnedSpotData.size() == totalPrograms);

    }
}