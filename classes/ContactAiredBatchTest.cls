@IsTest
private class ContactAiredBatchTest {

	private static ContactSelector contactSelector = new ContactSelector();
	
	public static void setContactSelector(ContactSelector cSelector) {
		contactSelector = cSelector;
	}

	public static void insertContactWithSchedule(Date lastMonday, String cabledSynd, String programName) {

        Account testAcct = new Account();
		testAcct.Name = 'Test Account';
		testAcct.BillingCity = 'Wakarusa';
		insert testAcct;

		Contact contact = new Contact();
		contact.FirstName = 'Test';
		contact.LastName = 'Name';
		contact.Email = 'test@testemail.com';
		contact.Phone = '(758) 771-0091';
		contact.Account = testAcct;
		insert contact;

		Programs__c program = new Programs__c();
		program.Name = programName;
		program.Cable_Synd__c = cabledSynd;
		program.Station_Call_Letter__c = 'AWED';
		program.ClientCode__c = '123';
		insert program;

		Deal__c testDeal = new Deal__c();
		testDeal.Contact__c = contact.Id;
		testDeal.Program__c = program.Id;
		insert testDeal;

		Schedules__c schedule = new Schedules__c();
		schedule.Week__c = lastMonday;
		schedule.Units_Available__c = 5;
		schedule.Deal_Parent__c = testDeal.Id;
		schedule.Days_Allowed__c = 'Mon';
		schedule.Start_Time__c = '01:00A';
		schedule.End_Time__c = '01:30A';
		schedule.Rate__c = 12;
		insert schedule;

		Spot_Data__c spot = new Spot_Data__c();
		spot.Schedule__c = schedule.Id;
		insert spot;

		PrelogData__c prelog = new PrelogData__c();
		prelog.Schedule__c = schedule.Id;
		insert prelog;
	}

	@IsTest
	public static void testContactAiredBatch_contactAiredPostWeekWithCable_ContactPostWeekUpdated() {
		Date lastMonday =  Date.today().toStartOfWeek().addDays(-6);

		insertContactWithSchedule(lastMonday, 'Cable', 'BounceTV');

		Test.startTest();
		ContactAiredBatch batch = new ContactAiredBatch('PostLogButton');
		Database.executeBatch(batch);
		Test.stopTest();

		Contact testContact = GetContact('Test Name');
		System.assertEquals(lastMonday,testContact.Bounce_Post_Week__c);

	}

	@IsTest
	public static void testContactAiredBatch_contactAiredPostWeekWithCable_UniqueName() {
		Date lastMonday =  Date.today().toStartOfWeek().addDays(-6);

		insertContactWithSchedule(lastMonday, 'Cable', 'BuzzrTV');

		Test.startTest();
		ContactAiredBatch batch = new ContactAiredBatch('PostLogButton');
		Database.executeBatch(batch);
		Test.stopTest();

		Contact testContact = GetContact('Test Name');
		System.assertEquals(lastMonday,testContact.BuzzrTVPostLogWeek__c);

	}

	@IsTest
	public static void testContactAiredBatch_contactAiredPreWeekWithCable_ContactPreWeekUpdated() {

		Date thisMonday =  Date.today().toStartOfWeek().addDays(1);

		insertContactWithSchedule(thisMonday, 'Cable', 'BounceTV');
		Contact testContact = GetContact('Test Name');
		System.debug('before Test: ' + testContact.Bounce_Prelog_Week__c);

		Test.startTest();
		ContactAiredBatch batch = new ContactAiredBatch('PreLogButton');
		Database.executeBatch(batch);
		Test.stopTest();

		testContact = GetContact('Test Name');
		System.debug('after Test: ' + testContact.Bounce_Prelog_Week__c);


		System.assertEquals(thisMonday, testContact.Bounce_Prelog_Week__c);
	}

	@IsTest
	public static void testContactAiredBatch_contactAiredPostWeekWithSyndication_ContactPostWeekUpdated() {
		Date lastMonday =  Date.today().toStartOfWeek().addDays(-6);

		insertContactWithSchedule(lastMonday, 'Syndication', 'BounceTV');

		Test.startTest();
		ContactAiredBatch batch = new ContactAiredBatch('PostLogButton');
		Database.executeBatch(batch);
		Test.stopTest();

		Contact testContact = GetContact('Test Name');
		System.assertEquals(lastMonday,testContact.Post_Log_Week__c);
	}

	@IsTest
	public static void testContactAiredBatch_contactAiredPreNextWeekWithSyndication_ContactPreNextWeekUpdated() {
		Date thisMonday =  Date.today().toStartOfWeek().addDays(8);

		insertContactWithSchedule(thisMonday, 'Syndication', 'BounceTV');

		Test.startTest();
		ContactAiredBatch batch = new ContactAiredBatch('NextWeekPreLogButton');
		Database.executeBatch(batch);
		Test.stopTest();

		Contact testContact = GetContact('Test Name');
		System.assertEquals(thisMonday,testContact.Pre_Log_Week__c);
	}
	
	private static Contact GetContact(String name) {
		return contactSelector.GetContactsByName(name)[0];
	}
}