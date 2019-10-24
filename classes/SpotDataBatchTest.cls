@isTest
private class SpotDataBatchTest {
	@isTest
	private static void spotDataBatch_createSpotDataFromMirror_spotDataCreated() {

		Schedules__c testSchedule = createSchedule('123');
		List<SpotDataMirror__c> mirrors = createSpotDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), '123');
		insert new Prelog_Batch_Networks__c(Name = 'test');

		Test.startTest();
		SpotDataBatch batch = new SpotDataBatch('test');
		Database.executeBatch(batch);
		Test.stopTest();

		List<Spot_Data__c> spots = getSpotDataFromScheduleId(testSchedule.Id);

		System.debug('Size: '+spots.size());
		System.assert(spots.size() == 4);
		System.assertEquals(spots[0].Schedule__c, testSchedule.Id);
		System.assertEquals(spots[0].Air_Date__c, date.today().toStartofWeek().addDays(-6));
		for (Spot_Data__c spot: spots) {
			System.assertEquals(null, spot.Error__c);
		}
	}

	@isTest
	private static void spotDataBatch_createSpotDataFromMirror_SpotDataMirrorLookupPopulated() {
		Schedules__c testSchedule = createSchedule('123');
		List<SpotDataMirror__c> mirrors = createSpotDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), '123');
		List<Id> mirrorIds = new List<Id>();
		for (SpotDataMirror__c mirror: mirrors) {
			mirrorIds.add(mirror.id);
		}

		insert new Prelog_Batch_Networks__c(Name = 'test');

		Test.startTest();
		SpotDataBatch batch = new SpotDataBatch('test');
		Database.executeBatch(batch);
		Test.stopTest();

		List<Spot_Data__c> spots = getSpotDataFromMirrorIds(mirrorIds);
		List<Id> spotIds = new List<Id>();
		for(Spot_Data__c spot: spots) {
			spotIds.add(spot.Id);
		}

		System.debug('Spot Id size: '+spotIds.size());

		Map<Id, SpotDataMirror__c> updatedMirrors = getSpotDataMirrorsFromSpotData(spotIds);
		System.debug('Updated mirrors: '+updatedMirrors);
		for (SpotDataMirror__c mirror: updatedMirrors.values()) {
			System.assert(mirror.Spot_Data__c != null);
			System.assert(mirror.ErrorReason__c == null);
		}
	}

	@isTest
	private static void spotDataBatch_createErrorSpotDataMirrors_spotDataMirrorErrorFieldMessageFound() {
		Schedules__c testSchedule = createSchedule('123');
		List<SpotDataMirror__c> mirrors = createSpotDataMirrors(false, Integer.valueOf(testSchedule.Units_Available__c), '123');
		insert new Prelog_Batch_Networks__c(Name = 'test');

		Test.startTest();
		SpotDataBatch batch = new SpotDataBatch('test');
		Database.executeBatch(batch);
		Test.stopTest();

		List<Spot_Data__c> spots = getSpotDataFromScheduleId(testSchedule.Id);
		System.assert(spots.size() == 0);

		List<SpotDataMirror__c> failedMirrors = getFailedSpotDataMirrors();
		System.assert(failedMirrors.size() > 0);

		for(SpotDataMirror__c mirror: failedMirrors) {
			System.assert(mirror.ErrorReason__c != null);
		}

	}

	// Create network's SpotDataMirrors
	private static Schedules__c createSchedule(String dealNumber) {
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
		program.ClientCode__c = dealNumber;
		program.Clock_Start_Time__c = '';
		insert program;

		Deal__c testDeal = new Deal__c();
		testDeal.Program__c = program.id;
		testDeal.Contact__c = contact.id;
		testDeal.Network_Deal_Number__c = dealNumber;
		testDeal.Length__c = '1';
		insert testDeal;


		Schedules__c schedule = new Schedules__c();
		schedule.Week__c = date.today().toStartofWeek().addDays(-6);
		schedule.Units_Available__c = 5;
		schedule.Deal_Parent__c = testDeal.id;
		schedule.Days_Allowed__c = 'Mon';
		schedule.Start_Time__c = '06:00A';
		schedule.End_Time__c = '06:30A';
		schedule.Rate__c = 100;
		schedule.Units_Available__c = 5;
		insert schedule;

		return schedule;
	}

	private static List<SpotDataMirror__c> createSpotDataMirrors(Boolean positiveTestCase, Integer unitsAvailable, String dealNumber) {
		Integer rate = 0;
		if (positiveTestCase) {
			rate = 100;
		}

		List<SpotDataMirror__c> mirrors = new List<SpotDataMirror__c>();
		for (Integer i = 0; i < unitsAvailable; i++) {
			SpotDataMirror__c mirror = new SpotDataMirror__c();
			mirror.Network_Deal_Number__c = dealNumber;
			mirror.Network__c = 'test';
			mirror.Length__c = '1';
			mirror.Air_Date__c = date.today().toStartofWeek().addDays(-6);
			mirror.Air_Time__c = '6:0'+i+':00AM';
			mirror.Spot_Rate__c = rate;
			mirrors.add(mirror);
		}
		
		insert mirrors;
		return mirrors;
	}

	private static List<Spot_Data__c> getSpotDataFromScheduleId(Id scheduleId) {
		return [SELECT Id, 
					   Air_Time__c,
					   Schedule__c,
					   Air_Date__c,
					   Error__c
				  FROM Spot_Data__c 
				 WHERE Schedule__c = :scheduleId];
	}

	private static List<Spot_Data__c> getSpotDataFromMirrorIds(List<Id> mirrorIds) {
		return [SELECT Id, 
					   Air_Time__c,
					   Schedule__c,
					   Air_Date__c,
					   SpotDataMirror__c
				  FROM Spot_Data__c 
				 WHERE SpotDataMirror__c IN :mirrorIds];
	}

	private static List<SpotDataMirror__c> getFailedSpotDataMirrors() {
		return [SELECT Id,
			   		   Network_Deal_Number__c,
			   		   Network__c,
			   		   Air_Date__c,
			   		   ErrorReason__c
				  FROM SpotDataMirror__c
				 WHERE ErrorReason__c != null];
	}

	private static Map<Id, SpotDataMirror__c> getSpotDataMirrorsFromSpotData(List<Id> spotIds) {
		return new Map<Id, SpotDataMirror__c>([SELECT Id,
			   		   Network_Deal_Number__c,
			   		   Network__c,
			   		   Air_Date__c,
			   		   ErrorReason__c,
					   Spot_Data__c
				  FROM SpotDataMirror__c
				 WHERE Spot_Data__c in :spotIds]);
	}

}