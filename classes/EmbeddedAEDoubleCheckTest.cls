@isTest
private class EmbeddedAEDoubleCheckTest {
	
	@isTest static void testEmbeddedDoubleCheck_withFourSchedules_fourSchedulesPresentedInWeeks() {
		Deal__c testDeal = createDeal();
		List<Schedules__c> schedules = createSchedules(testDeal);

		Decimal totalDollars =  getTotalDollars(schedules);

		Test.startTest();
		System.debug('Test');
		Test.setCurrentPage(Page.EmbeddedAEDoubleCheck);
		EmbeddedAEDoubleCheck controller = new EmbeddedAEDoubleCheck(new ApexPages.StandardController(testDeal));
		Test.stopTest();
		System.assertEquals(testDeal.id, controller.SelectedDeal.id);
		System.assertEquals(totalDollars, controller.SelectedDealWrapper.DealRecord.Sum_Of_Total_Dollars__c);
		for (Schedules__c schedule: schedules) {
			System.assertEquals(schedule.Rate__c, controller.SelectedDealWrapper.WeekDollarsMap.get(schedule.Week__c));
		}
	}

	private static Deal__c createDeal() {
		Account testAcct = new Account();
		testAcct.Name = 'Test Account';
		testAcct.Billingcity = 'Wakarusa';
		insert testAcct;

		Contact contact = new Contact();
		contact.FirstName = 'Test';
		contact.LastName = 'Name';
		contact.Email = 'test@testemail.com';
		contact.Phone = '(758) 771-0091';
		contact.Account = testAcct;
		insert contact;

		Programs__c program = new Programs__c();
		program.Name = 'test';
		program.Cable_Synd__c = 'Cable';
		program.Station_Call_Letter__c = 'AWED';
		program.ClientCode__c = '123';
		program.Clock_Start_Time__c = '';
		insert program;

		Deal__c testDeal = new Deal__c();
		testDeal.Program__c = program.id;
		testDeal.Contact__c = contact.id;
		testDeal.Network_Deal_Number__c = '123';
		testDeal.Length__c = '1';
		insert testDeal;

		return testDeal;
	}

	private static List<Schedules__c> createSchedules(Deal__c testDeal) {
		List<Schedules__c> schedules = new List<Schedules__c>();

		for (Integer i = 1; i < 28; i+=7 ) {
			Schedules__c schedule = new Schedules__c();
			schedule.Week__c = date.today().toStartofWeek().addDays(i);
			schedule.OrderNumber__c = '1';
			schedule.Units_Available__c = 5;
			schedule.Deal_Parent__c = testDeal.id;
			schedule.Days_Allowed__c = 'Mon';
			schedule.Start_Time__c = '06:00A';
			schedule.End_Time__c = '06:30A';
			schedule.Rate__c = 100 * i;
			schedules.add(schedule);
		}
			
		insert schedules;

		return schedules;

	}

	private static Decimal getTotalDollars(List<Schedules__c> schedules) {
		Decimal totalDollars = 0;
		for (Schedules__c schedule: schedules) {
			totalDollars += schedule.Rate__c;
		}
		return totalDollars;
	} 

	
}