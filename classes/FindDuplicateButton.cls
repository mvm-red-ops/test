public with sharing class FindDuplicateButton 
{
	public string SpotDataMirrorRecordId {Get;set;}
	
	public FindDuplicateButton(ApexPages.StandardController sc)
	{
		try
		{
			if (ApexPages.CurrentPage().getParameters().containsKey('Id'))
			{
				SpotDataMirrorRecordId = ApexPages.CurrentPage().getParameters().get('Id');
			}
		}
		catch (Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERror, 'Error - ' + Ex.getMessage()));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Line Number - ' + ex.getLineNumber()));
		}
	}
	public PageReference RedirectButton()
	{
		try
		{
			List<AsyncApexJob> AAJList = [select Id, ApexClassId, Status from AsyncApexJob where ((Status = 'Processing' OR Status = 'Queued' OR Status = 'Preparing') AND (ApexClass.Name='SpotDataScheduleBatch' OR ApexClass.Name='SpotDataBatch') AND JobType='BatchApex' )];
			if (AAJList.size() == 0)
			{
				if (SpotDataMirrorRecordId != null)
				{
					SpotDataMirror__c SDM =  database.query('select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Id =: SpotDataMirrorRecordId');
					if (SDM.Schedule__c == null )
					{
						SpotDataScheduleService.ProcessSpotDataRecords(new List<SpotDataMirror__c>{SDM});
					}
					else if (SDM.Spot_Data__c == null)
					{
                        SpotDataScheduleService.processSpotDataRecords(new List<SpotDataMirror__c>{
                                SDM
                        });
					}
					return new PageREference('/' + SpotDataMirrorRecordId);
				}
			}
			else
			{
				ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info,'A Spot Data Mirror Batch is already running or is preparing to run. Please click the Find Schedule button after the previous batch finishes running.'));
			}
			return null;
		}
		catch (Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERror, 'Error - ' + Ex.getMessage()));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Line Number - ' + ex.getLineNumber()));
			return null;
		}
	}
	public PageReference GoBackButton()
	{
		try
		{
			if (SpotDataMirrorRecordId != null)
			{
				return new PageREference('/' + SpotDataMirrorRecordId);
			}
			return null;
		}
		catch (Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERror, 'Error - ' + Ex.getMessage()));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Line Number - ' + ex.getLineNumber()));
			return null;
		}
	}
}