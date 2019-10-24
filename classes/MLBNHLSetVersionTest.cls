@isTest
private class MLBNHLSetVersionTest {
	
	private static void createProgram() {
		Programs__c program = new Programs__c();
		program.Name = 'MLB';
		program.Cable_Synd__c = 'Cable';
		program.Station_Call_Letter__c = 'AWED';
		program.ClientCode__c = '1';
		program.Clock_Start_Time__c = '';
		program.Prelog_Version__c = 1.0;
		insert program;
	}

	private static void createPreLogMirror(Integer version) {
		PrelogDataMirror__c mirror = new PrelogDataMirror__c();
		mirror.Network__c = 'MLB';
		mirror.ScheduleLength__c = '1';
		mirror.AirDate__c = date.today().toStartofWeek().addDays(-6);
		mirror.ScheduleTime__c = '6:01:00AM';
		mirror.Rate__c = 100.0;
		mirror.NetworkDealNumber__c = '100';
		mirror.Version__c = version;
		insert mirror;
	}

	@isTest static void testMLBSetVersion_preLogMirrorWithCorrectVersion_preLogVersionSetCorrectly() {
		createProgram();
		createPreLogMirror(99);

		Test.startTest();
		MLBNHLSetVersion setVersionBatch = new MLBNHLSetVersion('MLB');
		Database.executeBatch(setVersionBatch);
		Test.stopTest();

		List<PreLogDataMirror__c> mirrors = getPreLogMirrors();
		for (PreLogDataMirror__c mirror: mirrors) {
			System.assert(mirror.Version__c == 1.0);
		}
	}

	@isTest static void testMLBSetVersion_preLogMirrorWithIncorrectVersion_preLogVersionNotSet() {
		createProgram();
		createPreLogMirror(2);
		
		Test.startTest();
		MLBNHLSetVersion setVersionBatch = new MLBNHLSetVersion('MLB');
		Database.executeBatch(setVersionBatch);
		Test.stopTest();

		List<PreLogDataMirror__c> mirrors = getPreLogMirrors();
		for (PreLogDataMirror__c mirror: mirrors) {
			System.assert(mirror.Version__c != 1.0);
		}

	}

	private static List<PreLogDataMirror__c> getPreLogMirrors() {
		return [SELECT id,
					   Version__c
				  FROM PrelogDataMirror__c
				 WHERE Network__c = 'MLB'];
	}
	
}