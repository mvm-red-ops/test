@IsTest
private class PrelogDataBatchTest {
	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_prelogDataCreated() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'Mon');
		List<PrelogDataMirror__c> mirrors = createPrelogDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, false);
		List<Id> mirrorIds = new List<Id>();
		for (PrelogDataMirror__c mirror: mirrors) {
			mirrorIds.add(mirror.id);
		}

		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();
		Map<Id, PrelogData__c> prelogs = getPrelogDataFromMirrorIds(mirrorIds);
		System.assertNotEquals(prelogs, null);

	}

	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_prelogDataLookupPopulated() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'Mon');
		List<PrelogDataMirror__c> mirrors = createPrelogDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, true);
		List<Id> mirrorIds = new List<Id>();
		for (PrelogDataMirror__c mirror: mirrors) {
			mirrorIds.add(mirror.id);
		}
		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();

		Map<Id, PrelogData__c> prelogs = getPrelogDataFromMirrorIds(mirrorIds);
		Map<Id, PrelogDataMirror__c> updatedMirrors = getPrelogDataMirrors(prelogs.keySet());
		System.assertNotEquals(null, updatedMirrors);
		System.assert(updatedMirrors.size() > 0);
		for (PrelogDataMirror__c mirror: updatedMirrors.values()) {

			System.assertNotEquals(null, mirror.PrelogData__c);
			System.assertNotEquals(null, mirror.Schedule__c );

		}
	}

	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_PrelogDataMirrorSuccessfullyCreated() {
		Schedules__c testSchedule = createSchedule('123','test','Mon');
		List<PrelogDataMirror__c> mirrors = createPrelogDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, false);
		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();
		PrelogDataMirror__c m = [SELECT Id, ErrorReason__c, Schedule__c,  Batch_Id__c FROM PrelogDataMirror__c WHERE Id =: mirrors[0].Id];
		System.assertEquals(null, m.Batch_Id__c);
	}


	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_InvalidNetworkDealNumber() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'Mon');
		createPrelogDataMirrors(false, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, false);
		insert new Prelog_Batch_Networks__c(Name = 'test1');
		runBatchJob();
		List<PrelogDataMirror__c> failedMirrors = getFailedPrelogDataMirrors();
		System.assert(failedMirrors.size() == 0, 'Network deal number does not match or invalid');
	}

	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_RateNotFound() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'mon');
		createPrelogDataMirrors(false, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, true);
		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();
		List<PrelogData__c> prelogs = getPrelogDataFromScheduleId(testSchedule.Id);
		System.assert(prelogs.size() == 0);

		List<PrelogDataMirror__c> failedMirrors = getFailedPrelogDataMirrors();
		AssetsCorrectErrorMessage(failedMirrors);
		System.assertEquals(failedMirrors[0].ErrorReason__c, 'Rate not found');
	}

	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_AirTimeNotFound() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'mon');
		createPrelogDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), true, -6, false, false);
		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();
		List<PrelogDataMirror__c> failedMirrors = getFailedPrelogDataMirrors();
		String error = failedMirrors[0].ErrorReason__c;
		System.assertEquals('Air Time Not Found', error);
		AssetsCorrectErrorMessage(failedMirrors);

	}

	@IsTest
	private static void prelogDataBatch_createPrelogDataFromMirror_UnitLengthNotFound() {
		Schedules__c testSchedule = createSchedule('123', 'test', 'mon');
		createPrelogDataMirrors(true, Integer.valueOf(testSchedule.Units_Available__c), true, -6, true, false);
		insert new Prelog_Batch_Networks__c(Name = 'test');
		runBatchJob();
		List<PrelogData__c> prelogs = getPrelogDataFromScheduleId(testSchedule.Id);
		System.assert(prelogs.size() == 0);

		List<PrelogDataMirror__c> failedMirrors = getFailedPrelogDataMirrors();
		AssetsCorrectErrorMessage(failedMirrors);
		String error = failedMirrors[0].ErrorReason__c;
		System.assertEquals(error, 'Unit Length not found');

	}

	private static Schedules__c createSchedule(String dealNumber, String programName, String airDate ) {
		Account testAcct = new Account();
		testAcct.Name = 'PrelogDataMirror Test';
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
		program.Name = programName;
		program.Cable_Synd__c = 'Cable';
		program.Station_Call_Letter__c = 'AWED';
		program.ClientCode__c = dealNumber;
		program.Clock_Start_Time__c = '7AM';
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
		schedule.Days_Allowed__c = airDate;
		schedule.Start_Time__c = '09:00A';
		schedule.End_Time__c = '09:30A';
		schedule.Rate__c = 100;
		schedule.Units_Available__c = 5;
		insert schedule;
		return [SELECT Id, Week__c, Deal_Parent__c, Deal_Parent__r.Network_Deal_Number__c, Days_Allowed__c, Start_Time__c, End_Time__c, Rate__c, Units_Available__c
		FROM Schedules__c WHERE Id =: schedule.Id];
	}

	private static List<PrelogDataMirror__c> createPrelogDataMirrors(Boolean isRate, Integer unitsAvailable,
			Boolean dealNumber, Integer airDateAddDay, Boolean scheduleLen,
			Boolean AirTimeNotFound) {


		List<PrelogDataMirror__c> mirrors = new List<PrelogDataMirror__c>();

		for (Integer i = 0; i < unitsAvailable; i++) {
			Deal__c deal = new Deal__c();
			PrelogDataMirror__c mirror = new PrelogDataMirror__c();
			mirror.NetworkDealNumber__c = dealNumber ? '123' : '321';
			mirror.Network__c = 'test';
			mirror.ScheduleLength__c = scheduleLen ? '100' : '1';
			mirror.AirDate__c = Date.today().toStartOfWeek().addDays(airDateAddDay);
			mirror.ScheduleTime__c = AirTimeNotFound ? '9:10:00AM' : '3:10:00PM';
			mirror.Rate__c = isRate ? 100 : null;
			mirror.Deal__c = deal.Id;
			mirror.Version__c = 1;
			mirrors.add(mirror);
		}

		insert mirrors;
		return mirrors;
	}

	private static List<PrelogData__c> getPrelogDataFromScheduleId(Id scheduleId) {
		return [SELECT Id,
				ScheduleTime__c,
				Schedule__c,
				AirDate__c,
				PrelogDataMirror__c,
				Batch_Id__c
		FROM PrelogData__c
		WHERE Schedule__c = :scheduleId];
	}

	private static Map<Id, PrelogData__c> getPrelogDataFromMirrorIds(List<Id> mirrorIds) {
		return new Map<Id, PrelogData__c> ([SELECT Id,
				ScheduleTime__c,
				Schedule__c,
				AirDate__c
		FROM PrelogData__c
		WHERE PrelogDataMirror__c = :mirrorIds]);
	}

	private static Map<Id, PrelogDataMirror__c> getPrelogDataMirrors(Set<Id> prelogIds) {
		return new Map<Id, PrelogDataMirror__c>([
				SELECT id,
						PrelogData__c,
						Schedule__c,
						ErrorReason__c
				FROM PrelogDataMirror__c
				WHERE PrelogData__c in :prelogIds
		]);
	}

	private static List<PrelogDataMirror__c> getFailedPrelogDataMirrors() {

		return [SELECT Id,
				ScheduleTime__c,
				Schedule__c,
				AirDate__c,
				Schedule__r.Days_Allowed__c,
				ErrorReason__c,
				Deal__c,
				PrelogData__c,
				Batch_Id__c
		FROM PrelogDataMirror__c
		WHERE ErrorReason__c != NULL];
	}

	private static void AssetsCorrectErrorMessage(List<PrelogDataMirror__c> mirror) {
		for(PrelogDataMirror__c failedMirrors : mirror) {
			System.assert(failedMirrors.Deal__c != null);
			System.assert(mirror.size() > 0);
		}
	}

	private static void runBatchJob() {
		Test.startTest();
		PrelogDataBatch batch = new PrelogDataBatch('test');
		Database.executeBatch(batch);
		Test.stopTest();
	}
}