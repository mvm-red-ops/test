public with sharing class FindPrelogDuplicateButton 
{
	public string PrelogDataMirrorRecordId {Get;set;}
	
	public FindPrelogDuplicateButton(ApexPages.StandardController sc)
	{
		try
		{
			if (ApexPages.CurrentPage().getParameters().containsKey('Id'))
			{
				PrelogDataMirrorRecordId = ApexPages.CurrentPage().getParameters().get('Id');
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
			List<AsyncApexJob> AAJList = [select Id, ApexClassId, Status from AsyncApexJob where ((Status = 'Processing' OR Status = 'Queued' OR Status = 'Preparing') AND (ApexClass.Name='PrelogDataScheduleBatch' OR ApexClass.Name='PrelogDataBatch') AND JobType='BatchApex' )];
			if (AAJList.size() == 0)
			{
				if (PrelogDataMirrorRecordId != null)
				{
					PrelogDataMirror__c SDM =  database.query('select ' + SaberGF.GetObjectsFieldsForQueries('PrelogDataMirror__c') + ' from PrelogDataMirror__c where Id =: PrelogDataMirrorRecordId');
					if (SDM.Schedule__c == null )
					{
						PrelogDataScheduleBatch.ProcessPrelogDataRecords(new List<PrelogDataMirror__c>{SDM});
					}
					else if (SDM.PreLogData__c == null)
					{
						PrelogDataScheduleBatch.ProcessPrelogDataRecords(new List<PrelogDataMirror__c>{SDM});
					}
					return new PageREference('/' + PrelogDataMirrorRecordId);
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
			if (PrelogDataMirrorRecordId != null)
			{
				return new PageREference('/' + PrelogDataMirrorRecordId);
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