global class PrelogDataScheduleBatch implements Database.Batchable <SObject>
{
	private static PrelogDataSelector prelogDataSelector = new PrelogDataSelector();

	public void setPrelogDataSelector(PrelogDataSelector pDSelector){
		prelogDataSelector = pDSelector;
	}
	global List<Id> PrelogDataMirrorIdList;
	global PrelogDataScheduleBatch(List<Id> pPrelogDataMirrorIdList)
	{
		PrelogDataMirrorIdList = pPrelogDataMirrorIdList;
	}
	global PrelogDataScheduleBatch()
	{
		
	}
	global database.QueryLocator start(Database.BatchableContext BC)
	{
		System.debug('PrelogDataMirrorIdList - ' + PrelogDataMirrorIdList);
		if (PrelogDataMirrorIdList == null)
		{
			//string TodayDate = Date.Today().year() + '-' + (Date.Today().month()< 10? '0' + Date.Today().month() : Date.Today().month()) + '-' + (Date.Today().day()< 10? '0' + Date.Today().day() : Date.Today().day());
			return Database.getQueryLocator('select ' + SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c') + ' from PrelogDataMirror__c where PrelogData__c = null AND Schedule__c != null AND CreatedDate >= LAST_WEEK');
		}
		else
		{
			if (PrelogDataMirrorIdList.size() > 0)
			{
				return Database.getQueryLocator('select ' + SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c') + ' from PrelogDataMirror__c where Id in ' + SaberGF.ReturnDynamicQueryList(PrelogDataMirrorIdList));
			}
			else
			{
				return Database.getQueryLocator('select ' + SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c') + ' from PrelogDataMirror__c where PrelogData__c = null AND Schedule__c != null AND CreatedDate >= LAST_WEEK');
			}
		}
	}
	global void execute(Database.BatchableContext BC, List<PrelogDataMirror__c> scope)
	{
		PrelogDataScheduleBatch.ProcessPrelogDataRecords(scope);
	}
	global static void ProcessPrelogDataRecords(List<PrelogDataMirror__c> scope)
	{
		List<PrelogData__c> PrelogDataList = new List<PrelogData__c>();
		Integer Increment = 0;
		Map<String, PrelogDataMirror__c> UniqueIdPrelogDataMirrorMap = new Map<String, PrelogDataMirror__c>();
		for (PrelogDataMirror__c SDM : scope)
		{
			PrelogData__c PrelogDataRec = new PrelogData__c();
	        PrelogDataRec.AdvertiserProduct__c = SDM.AdvertiserProduct__c;
	        PrelogDataRec.Agency__c = SDM.Agency__c;
	        PrelogDataRec.AirDate__c = SDM.AirDate__c;
	        PrelogDataRec.BreakCode__c = SDM.BreakCode__c;
	        PrelogDataRec.Field1__c = SDM.Field1__c;
	        PrelogDataRec.MaterialDescription__c = SDM.MaterialDescription__c;
	        PrelogDataRec.OrderProductDescription__c = SDM.OrderProductDescription__c;
	        PrelogDataRec.PrelogDataMirror__c = SDM.Id;
	        PrelogDataRec.Rate__c = SDM.Rate__c;
	        PrelogDataRec.Schedule__c = SDM.Schedule__c;
	        PrelogDataRec.ScheduleAdID__c = SDM.ScheduleAdID__c;
	        PrelogDataRec.ScheduleLength__c = SDM.ScheduleLength__c;
	        PrelogDataRec.ScheduleTime__c = SDM.ScheduleTime__c;
	        PrelogDataRec.TimePeriod__c = SDM.TimePeriod__c;
	        PrelogDataRec.Version__c = SDM.Version__c;
	        PrelogDataRec.PrelogDataMirrorReference__c=SDM.Schedule__c+String.valueOf(SDM.Id)+Increment;
	        UniqueIdPrelogDataMirrorMap.put(SDM.Schedule__c+String.valueOf(SDM.Id)+Increment,SDM);
	        System.debug('map value - ' + (SDM.Schedule__c+String.valueOf(SDM.Id)+Increment) + ' - ' + SDM.Id);
	        Increment++;
	        PrelogDataList.add(PrelogDataRec);
		}
		if (PrelogDataList.size() > 0)
		{
			Database.insert(PrelogDataList, false);
			List<PrelogDataMirror__c> SDMList = new List<PrelogDataMirror__c>();
			for (PrelogData__c SP : prelogDataSelector.getProcessPrelogDataRecords(UniqueIdPrelogDataMirrorMap))
			{
				if (UniqueIdPrelogDataMirrorMap.containsKey(SP.PrelogDataMirrorReference__c))
				{
					System.debug('SP values - ' + SP.PrelogDataMirrorReference__c + ' - ' + UniqueIdPrelogDataMirrorMap.get(SP.PrelogDataMirrorReference__c).Id);
					SDMList.add(new PrelogDataMirror__c(Id = UniqueIdPrelogDataMirrorMap.get(SP.PrelogDataMirrorReference__c).Id, PrelogData__c = SP.Id, ErrorReason__c = null,Schedule__c = SP.Schedule__c, Problem__c = false));
				}
			}
			Database.update(SDMList, false);
		}
	}
	global void finish(Database.BatchableContext BC)
	{
		
	}
}