public with sharing class ReprocessPreLogMirrorRecords 
{
	private static PrelogDataSelector prelogDataSelector = new PrelogDataSelector();
	public void setPrelogDataSelector(PrelogDataSelector pDSelector){
		prelogDataSelector = pDSelector;
	}

	ApexPages.StandardSetController SDMssc {get;set;}
	public String FilterId {get;set;}
	public String ObjectPrefix {get;set;}
	public ReprocessPreLogMirrorRecords(ApexPages.StandardSetController ssc)
	{
		if (ssc != null)
		{
			SDMssc = ssc;
			System.debug('Filter Id - ' + ssc.getFilterId());
			FilterId = ssc.getFilterId();
			if (FilterId.length() > 15)
			{
				FilterId = FilterId.substring(0,15);
			}
			ObjectPrefix = Schema.getGlobalDescribe().get('PrelogDataMirror__c').getDescribe().getKeyPrefix();
			
		}
	}
	public PageReference ReprocessPrelogDataMirrorRecordsAction()
	{
		List<AsyncApexJob> AAJList = prelogDataSelector.getJobsForMirrors();
		if (AAJList.size() == 0)
		{
			if (SDMssc != null)
			{
				List<PrelogDataMirror__c> NewSDMList = SDMssc.getSelected();
				List<Id> PrelogDataMIrrorIdList = new List<Id>();
				for(PrelogDataMirror__c SDM : NewSDMList)
				{
					PrelogDataMIrrorIdList.add(SDM.Id);
				}
				
				List<PrelogDataMirror__c> SDMList = prelogDataSelector.getMirrorsFromIds(PrelogDataMIrrorIdList);
				
				List<Id> PrelogDataMirrorWithNoScheduleList = new List<Id>();
				List<Id> PrelogDataMirrorWithScheduleList = new List<Id>();
				
				for (PrelogDataMirror__c SDM : SDMList)
				{
					if (SDM.Schedule__c == null )
					{
						PrelogDataMirrorWithNoScheduleList.add(SDM.Id);
					}
					else if (SDM.PrelogData__c == null)
					{
						PrelogDataMirrorWithScheduleList.add(SDM.Id);
					}
				}
				
				if (PrelogDataMirrorWithNoScheduleList.size() > 0)
				{
					List<PrelogDataMirror__c> PrelogDataMirrorList = Database.query('select '
							+ SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c')
							+ ' from PrelogDataMirror__c where Id in '
							+ SaberGF.ReturnDynamicQueryList(PrelogDataMirrorWithNoScheduleList));
					//PrelogDataScheduleBatch.ProcessPrelogDataRecords(PrelogDataMirrorList);
					PrelogDataBatchService.createSpotDataFromMirrors(PrelogDataMirrorList, null);
				}
				
				if (PrelogDataMirrorWithScheduleList.size() > 0)
				{
					List<PrelogDataMirror__c> PrelogDataMirrorList = Database.query('select '
							+ SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c')
							+ ' from PrelogDataMirror__c where Id in '
							+ SaberGF.ReturnDynamicQueryList(PrelogDataMirrorWithScheduleList));
					//PrelogDataScheduleBatch.ProcessPrelogDataRecords(PrelogDataMirrorList);
					PrelogDataBatchService.createSpotDataFromMirrors(PrelogDataMirrorList, null);
				}
				
				
			}
			if (FilterId != null)
			{
				return new PageReference('/' + ObjectPrefix + '?fcf=' + FilterId);
			}
			else
			{
				return new PageReference('/' + ObjectPrefix + '?fcf=00BC0000008xk4Q');
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(
					ApexPages.Severity.INFO,'A Pre log Data Mirror Batch is already running or is preparing to run. '
							+ 'Please reprocess the records after the previous batch finishes running.'));
		}
		return null;
	}
	public PageReference GoBackButton()
	{
		if (FilterId != null)
		{
			return new PageReference('/' + ObjectPrefix + '?fcf=' + FilterId);
		}
		else
		{
			return new PageReference('/' + ObjectPrefix + '?fcf=00BC0000008vccx');
		}
	}
}