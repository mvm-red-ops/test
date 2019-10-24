public with sharing class ReprocessSpotDataMirrorRecords 
{
	private static SpotDataSelector spotDataSelector = new SpotDataSelector();
	public void setSpotDataSelector(SpotDataSelector sSelector){
		spotDataSelector = sSelector;
	}

	ApexPages.StandardSetController SDMssc {get;set;}
	public String FilterId {get;set;}
	public String ObjectPrefix {get;set;}
	public ReprocessSpotDataMirrorRecords(ApexPages.StandardSetController ssc)
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
			ObjectPrefix = Schema.getGlobalDescribe().get('SpotDataMirror__c').getDescribe().getKeyPrefix();
			
		}
	}
	public PageReference ReprocessSpotDataMirrorRecordsAction()
	{
		List<AsyncApexJob> AAJList = spotDataSelector.getJobsForSpotData();
		if (AAJList.size() == 0)
		{
			if (SDMssc != null)
			{
				List<SpotDataMirror__c> NewSDMList = SDMssc.getSelected();
				List<Id> SpotDataMIrrorIdList = new List<Id>();
				for(SpotDataMirror__c SDM : NewSDMList)
				{
					SpotDataMIrrorIdList.add(SDM.Id);
				}
				
				List<SpotDataMirror__c> SDMList = spotDataSelector.getMirrorsFromIds(SpotDataMIrrorIdList);
				
				List<Id> SpotDataMirrorWithNoScheduleList = new List<Id>();
				List<Id> SpotDataMirrorWithScheduleList = new List<Id>();
				
				for (SpotDataMirror__c SDM : SDMList)
				{
					if (SDM.Schedule__c == null )
					{
						SpotDataMirrorWithNoScheduleList.add(SDM.Id);
					}
					else if (SDM.Spot_Data__c == null)
					{
						SpotDataMirrorWithScheduleList.add(SDM.Id);
					}
				}
				
				if (SpotDataMirrorWithNoScheduleList.size() > 0)
				{
					List<SpotDataMirror__c> SpotDataMirrorList = Database.query('select '
							+ SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c')
							+ ' from SpotDataMirror__c where Id in '
							+ SaberGF.ReturnDynamicQueryList(SpotDataMirrorWithNoScheduleList));
					//SpotDataScheduleService.processSpotDataRecords(SpotDataMirrorList);
					SpotDataMirrorService.createSpotDataFromMirrors(SpotDataMirrorList);
				}
				
				if (SpotDataMirrorWithScheduleList.size() > 0)
				{
					List<SpotDataMirror__c> SpotDataMirrorList = Database.query('SELECT '
							+ SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ','
							+ 'Schedule__r.Rate__c,Schedule__r.Deal_Parent__c,'
							+ 'Schedule__r.Deal_Parent__r.Length__c,'
							+ 'Schedule__r.Network_Deal_Number__c '
							+ 'FROM SpotDataMirror__c WHERE Id IN '
							+ SaberGF.ReturnDynamicQueryList(SpotDataMirrorWithScheduleList));
					SpotDataScheduleService.processSpotDataRecords(SpotDataMirrorList);
					//SpotDataMirrorService.createSpotDataFromMirrors(SpotDataMirrorList);
				}
				
				
			}
			if (FilterId != null)
			{
				return new PageReference('/' + ObjectPrefix + '?fcf=' + FilterId);
			}
			else
			{
				return new PageReference('/' + ObjectPrefix + '?fcf=00BC0000008vccx');
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(
					ApexPages.Severity.INFO,'A Spot Data Mirror Batch is already running or is preparing to run. '
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