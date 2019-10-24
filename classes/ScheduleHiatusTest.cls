@isTest
private class ScheduleHiatusTest {
	
	@isTest
	static void hiatusDateRange_test() {
		// Setup test data
		XMLBundleTest.TestData td = new XMLBundleTest.TestData();
		td.createNewDeal();

		Schedules__c s = new Schedules__c(
			Deal_Parent__c = td.deal.Id,
			Units_Available__c = 1,
			Rate__c = 10,
			Week__c = Date.newInstance(2016, 5, 2),
			Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun',
			Status__c = 'Sold'
		);
		insert s;

		List<Schedules__c> schedules = ScheduleHiatus.hiatusDateRange(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), s.Week__c.addDays(6));
		System.assertEquals('Mon;Tue;Wed', schedules[0].Days_Allowed__c);

		schedules[0].Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
		schedules = ScheduleHiatus.hiatusDateRange(schedules, Date.newInstance(2016, 5, 1), s.Week__c.addDays(8));
		System.assertEquals('Mon;Tue;Wed;Thu;Fri;Sat;Sun', schedules[0].Days_Allowed__c);
		System.assertEquals('Canceled', schedules[0].Status__c);

		schedules[0].Days_Allowed__c = 'Mon;Thu';
		schedules = ScheduleHiatus.hiatusDateRange(schedules, Date.newInstance(2016, 5, 2), s.Week__c.addDays(5));
		System.assertEquals('Mon;Thu', schedules[0].Days_Allowed__c);
		System.assertEquals('Canceled', schedules[0].Status__c);

		schedules[0].Days_Allowed__c = 'Mon;Tue';
		schedules = ScheduleHiatus.hiatusDateRange(schedules, Date.newInstance(2016, 5, 10), s.Week__c.addDays(6));
		System.assertEquals('Mon;Tue', schedules[0].Days_Allowed__c);

		schedules[0].Days_Allowed__c = 'Mon;Tue';
		schedules = ScheduleHiatus.hiatusDateRange(schedules, Date.newInstance(2016, 4, 10), s.Week__c.addDays(-5));
		System.assertEquals('Mon;Tue', schedules[0].Days_Allowed__c);

		schedules = new List<Schedules__c>{
			new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2016, 5, 2), Days_Allowed__c = 'Mon;Tue;Thu;Fri'),
			new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2016, 5, 2), Days_Allowed__c = 'Mon;Tue;Wed;Sat;Sun')
		};
		schedules = ScheduleHiatus.hiatusDateRange(schedules, Date.newInstance(2016, 5, 5), s.Week__c.addDays(6));
		System.assertEquals('Mon;Tue', schedules[0].Days_Allowed__c);
		System.assertEquals('Mon;Tue;Wed', schedules[1].Days_Allowed__c);
	}

	@isTest
	static void hiatusSingleDay_test() {
		// Setup test data
		XMLBundleTest.TestData td = new XMLBundleTest.TestData();
		td.createNewDeal();

		Schedules__c s = new Schedules__c(
			Deal_Parent__c = td.deal.Id,
			Units_Available__c = 1,
			Rate__c = 10,
			Week__c = Date.newInstance(2016, 5, 2),
			Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun',
			Status__c = 'Sold'
		);
		insert s;

		List<Schedules__c> schedules = ScheduleHiatus.hiatusSingleDay(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5));
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		schedules = ScheduleHiatus.hiatusSingleDay(schedules, Date.newInstance(2016, 4, 5));
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		schedules[0].Days_Allowed__c = '';
		schedules = ScheduleHiatus.hiatusSingleDay(schedules, Date.newInstance(2016, 4, 5));
		System.assertEquals('', schedules[0].Days_Allowed__c);

		schedules[0].Days_Allowed__c = 'Mon';
		schedules = ScheduleHiatus.hiatusSingleDay(schedules, Date.newInstance(2016, 5, 2));
		System.assertEquals('Mon', schedules[0].Days_Allowed__c);
		System.assertEquals('Canceled', schedules[0].Status__c);

		schedules = new List<Schedules__c>{
			new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2016, 5, 2), Days_Allowed__c = 'Mon;Tue;Thu;Fri'),
			new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2016, 5, 2), Days_Allowed__c = 'Mon;Tue;Wed;Sat;Sun')
		};
		schedules = ScheduleHiatus.hiatusSingleDay(schedules, Date.newInstance(2016, 5, 5));
		System.assertEquals('Mon;Tue;Fri', schedules[0].Days_Allowed__c);
		System.assertEquals('Mon;Tue;Wed;Sat;Sun', schedules[1].Days_Allowed__c);
	}

	@isTest
	static void hiatusTimeAfter_test() {
		// Setup test data
		XMLBundleTest.TestData td = new XMLBundleTest.TestData();
		td.createNewDeal();

		Schedules__c s = new Schedules__c(
			Deal_Parent__c = td.deal.Id,
			Units_Available__c = 1,
			Rate__c = 10,
			Week__c = Date.newInstance(2016, 5, 2),
			Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun',
			Start_Time__c = '6:00P',
			End_Time__c = '10:00P',
			Status__c = 'Sold'
		);
		insert s;

		List<Schedules__c> schedules = ScheduleHiatus.hiatusTimeAfter(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '11:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Thu;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		schedules = ScheduleHiatus.hiatusTimeAfter(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '5:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		s.Days_Allowed__c = 'Mon';
		schedules = ScheduleHiatus.hiatusTimeAfter(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 2), '5:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon', schedules[0].Days_Allowed__c);
		System.assertEquals('Canceled', schedules[0].Status__c);

		s.Status__c = 'Sold';
		s.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
		schedules = ScheduleHiatus.hiatusTimeAfter(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '7:00P');
		System.assertEquals(2, schedules.size());

		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		System.assertEquals('6:00P', schedules[1].Start_Time__c);
		System.assertEquals('7:00P', schedules[1].End_Time__c);
		System.assertEquals('Thu', schedules[1].Days_Allowed__c);
	}

	@isTest
	static void hiatusTimeBefore_test() {
		// Setup test data
		XMLBundleTest.TestData td = new XMLBundleTest.TestData();
		td.createNewDeal();

		Schedules__c s = new Schedules__c(
			Deal_Parent__c = td.deal.Id,
			Units_Available__c = 1,
			Rate__c = 10,
			Week__c = Date.newInstance(2016, 5, 2),
			Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun',
			Start_Time__c = '6:00P',
			End_Time__c = '10:00P',
			Status__c = 'Sold'
		);
		insert s;

		List<Schedules__c> schedules = ScheduleHiatus.hiatusTimeBefore(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '5:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Thu;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		schedules = ScheduleHiatus.hiatusTimeBefore(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '11:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		schedules = ScheduleHiatus.hiatusTimeBefore(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 4), '10:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		s.Days_Allowed__c = 'Mon';
		schedules = ScheduleHiatus.hiatusTimeBefore(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 2), '10:00P');
		System.assertEquals(1, schedules.size());
		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon', schedules[0].Days_Allowed__c);
		System.assertEquals('Canceled', schedules[0].Status__c);

		s.Status__c = 'Sold';
		s.Days_Allowed__c = 'Mon;Tue;Wed;Thu;Fri;Sat;Sun';
		schedules = ScheduleHiatus.hiatusTimeBefore(new List<Schedules__c>{s}, Date.newInstance(2016, 5, 5), '7:00P');
		System.assertEquals(2, schedules.size());

		System.assertEquals('6:00P', schedules[0].Start_Time__c);
		System.assertEquals('10:00P', schedules[0].End_Time__c);
		System.assertEquals('Mon;Tue;Wed;Fri;Sat;Sun', schedules[0].Days_Allowed__c);

		System.assertEquals('7:00P', schedules[1].Start_Time__c);
		System.assertEquals('10:00P', schedules[1].End_Time__c);
		System.assertEquals('Thu', schedules[1].Days_Allowed__c);
	}

	@isTest
	static void isTimeBefore_test() {
		System.assert(ScheduleHiatus.isTimeBefore('07:30', '11:30'));
		System.assert(ScheduleHiatus.isTimeBefore('07:30', '13:30'));
		System.assert(ScheduleHiatus.isTimeBefore('13:30', '24:00'));
		System.assert(ScheduleHiatus.isTimeBefore('13:30', '00:05'));
		System.assert(ScheduleHiatus.isTimeBefore('13:30', '02:05'));
		System.assert(ScheduleHiatus.isTimeBefore('13:30', '06:00'));
		System.assert(ScheduleHiatus.isTimeBefore('01:01', '06:00'));
		System.assert(ScheduleHiatus.isTimeBefore('06:01', '06:00'));
	}
	
}