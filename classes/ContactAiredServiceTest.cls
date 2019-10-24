@IsTest
private class ContactAiredServiceTest {
    private static Date thisMonday = Date.today().toStartOfWeek().addDays(1);
    private static Date lastMonday = Date.today().toStartOfWeek().addDays(-6);

    @IsTest
    public static void test_getAiredContacts_stampBouncePrelogWeekOnContact() {
        Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'a@b.com', Phone = '18001234567');
        List<Contact> contacts = new List<Contact>{contact};
        createSchedule('123','BounceTV','mon', contacts, 1, true);

        ContactAiredBatch batch = new ContactAiredBatch('PreLogButton');
        System.assertEquals(null, contact.Bounce_Prelog_Week__c);
        Test.startTest();
        Database.executeBatch(batch, 100);
        Test.stopTest();
        Contact updatedContact = getUpdatedContact(contact);
        System.assertEquals(thisMonday, updatedContact.Bounce_Prelog_Week__c);
    }

    @IsTest
    public static void test_getAiredContacts_stampBouncePostlogWeekOnContact() {

        Contact contact = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'a@b.com', Phone = '18001234567');
        List<Contact> contacts = new List<Contact>{contact};

        createSchedule('123','BounceTV','mon', contacts, -6, false);
        ContactAiredBatch batch = new ContactAiredBatch('PostLogButton');
        System.assertEquals(null, contact.Post_Log_Week__c);
        Test.startTest();
        Database.executeBatch(batch, 100);
        Test.stopTest();
        Contact updatedContact = getUpdatedContact(contact);
        System.assertEquals(lastMonday, updatedContact.Post_Log_Week__c);
    }


    private static Contact getUpdatedContact(Contact contact) {
        return [SELECT Name, Bounce_Prelog_Week__c, Post_Log_Week__c FROM Contact WHERE Id =: contact.Id LIMIT 1];
    }


    private static Schedules__c createSchedule(String dealNumber, String programName, String airDate, List<Contact> contact, Integer addDay, boolean setCableSynd) {
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        testAcct.Billingcity = 'Wakarusa';
        insert testAcct;

        contact[0].Account = testAcct;
        insert contact;

        Programs__c program = new Programs__c();
        program.Name = programName;
        program.Cable_Synd__c = 'Cable';
        program.Station_Call_Letter__c = 'AWED';
        program.ClientCode__c = dealNumber;
        program.Clock_Start_Time__c = '7AM';
        program.Cable_Synd__c = setCableSynd ? 'Cable' : 'Syndication';
        insert program;

        Deal__c testDeal = new Deal__c();
        testDeal.Program__c = program.id;
        testDeal.Contact__c = contact[0].id;
        testDeal.Network_Deal_Number__c = dealNumber;
        testDeal.Length__c = '60';
        testDeal.Product_Code__c = 'NA';
        testDeal.Access_Code__c = 'NA';
        testDeal.Client_Code__c = 'NA';
        insert testDeal;

        Deal__c testDeal1 = new Deal__c();
        testDeal1.Program__c = program.Id;
        testDeal1.Contact__c = contact[0].Id;
        testDeal1.Network_Deal_Number__c = dealNumber;
        testDeal1.Length__c = '1';
        testDeal1.Product_Code__c = 'NA';
        testDeal1.Access_Code__c = 'NA';
        testDeal1.Client_Code__c = 'NA';
        insert testDeal1;

        Schedules__c schedule = new Schedules__c();
        schedule.Units_Available__c = 5;
        schedule.Deal_Parent__c = testDeal.id;
        schedule.Days_Allowed__c = airDate;
        schedule.Start_Time__c = '09:00A';
        schedule.End_Time__c = '09:30A';
        schedule.Rate__c = 200;
        schedule.Units_Preempted__c = 1;
        schedule.Units_Available__c = 5;
        schedule.Status__c = 'Sold';
        schedule.Week__c = Date.today().toStartOfWeek().addDays(addDay);
        insert schedule;

        PrelogDataMirror__c premirror1 = new PrelogDataMirror__c();
        premirror1.Schedule__c = schedule.Id;
        premirror1.Network__c = 'Bounce Two';
        premirror1.ScheduleLength__c = '60';
        premirror1.Version__c = 3;
        premirror1.Rate__c = 1200;
        premirror1.NetworkDealNumber__c = '5566';
        premirror1.AirDate__c = schedule.Week__c;
        premirror1.ScheduleTime__c = '12:45 AM';
        insert premirror1;

        PrelogData__c prelog1 = new PrelogData__c();
        prelog1.Schedule__c = schedule.Id;
        prelog1.PrelogDataMirror__c = premirror1.id;
        prelog1.ScheduleLength__c = '60';
        prelog1.Version__c = 3;
        prelog1.Rate__c = 1200;
        prelog1.AirDate__c = schedule.Week__c;
        prelog1.ScheduleTime__c = '12:45 AM';
        insert prelog1;

        Spot_Data__c spot1 = new Spot_Data__c();
        spot1.Schedule__c = schedule.Id;
        spot1.Length__c = '30';
        spot1.Spot_Rate__c = 200;
        spot1.Air_Date__c = schedule.Week__c;
        spot1.Air_Time__c = '12:25 AM';
        insert spot1;

        Schedules__c schedule2 = new Schedules__c();
        schedule2.Units_Available__c = 5;
        schedule2.Deal_Parent__c = testDeal.id;
        schedule2.Days_Allowed__c = airDate;
        schedule2.Start_Time__c = '09:00A';
        schedule2.End_Time__c = '09:30A';
        schedule2.Rate__c = 1200;
        schedule2.Units_Available__c = 5;
        schedule2.Status__c = 'Sold';
        schedule2.Week__c = Date.today().toStartOfWeek().addDays(addDay);
        insert schedule2;

        PrelogDataMirror__c premirror2 = new PrelogDataMirror__c();
        premirror2.Schedule__c = schedule2.Id;
        premirror2.Network__c = 'Bounce Two';
        premirror2.ScheduleLength__c = '60';
        premirror2.Version__c = 3;
        premirror2.Rate__c = 1200;
        premirror2.NetworkDealNumber__c = '5566';
        premirror2.AirDate__c = schedule2.Week__c;
        premirror2.ScheduleTime__c = '12:45 AM';
        insert premirror2;

        PrelogData__c prelog2 = new PrelogData__c();
        prelog2.Schedule__c = schedule2.Id;
        prelog2.PrelogDataMirror__c = premirror1.id;
        prelog2.ScheduleLength__c = '60';
        prelog2.Version__c = 3;
        prelog2.Rate__c = 1200;
        prelog2.AirDate__c = schedule2.Week__c;
        prelog2.ScheduleTime__c = '12:45 AM';
        insert prelog2;

        Spot_Data__c spot2 = new Spot_Data__c();
        spot2.Schedule__c = schedule2.Id;
        spot2.Length__c = '30';
        spot2.Spot_Rate__c = 1200;
        spot2.Air_Date__c = schedule.Week__c;
        spot2.Air_Time__c = '12:25 AM';
        insert spot2;

        return [SELECT Id, Week__c, Deal_Parent__c, Deal_Parent__r.Network_Deal_Number__c, Days_Allowed__c, Start_Time__c, End_Time__c, Rate__c, Units_Available__c
        FROM Schedules__c WHERE Id =: schedule.Id];
    }

}