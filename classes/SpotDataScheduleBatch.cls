global class SpotDataScheduleBatch implements Database.batchable <sobject>
{
	global List<Id> SpotDataMirrorIdList;
	global String network ;
	global SpotDataScheduleBatch(List<Id> pSpotDataMirrorIdList)
	{
		SpotDataMirrorIdList = pSpotDataMirrorIdList;
	}
	global SpotDataScheduleBatch(String n)
	{
		System.debug('***SpotDataScheduleBatch Constructor: n ' + n);
		if(n == 'All') {
			this.network = '' ;
		} else {
			this.network = n ;
		}
		System.debug('***SpotDataScheduleBatch Constructor: network ' + network);
	}

	global database.QueryLocator Start(Database.BatchableContext BC)
	{
		system.debug('SpotDataMirrorIdList - ' + SpotDataMirrorIdList);
		String query ;
		if (SpotDataMirrorIdList == null)
		{
			//string TodayDate = Date.Today().year() + '-' + (Date.Today().month()< 10? '0' + Date.Today().month() : Date.Today().month()) + '-' + (Date.Today().day()< 10? '0' + Date.Today().day() : Date.Today().day());
			query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Spot_Data__c = null AND Schedule__c != null AND CreatedDate >= LAST_WEEK AND Network__c LIKE \'%' + this.network + '%\'';
		}
		else
		{
			if (SpotDataMIrrorIdList.size() > 0)
			{
				query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Id in ' + SaberGF.ReturnDynamicQueryList(SpotDataMirrorIdList);
			}
			else
			{
				query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Spot_Data__c = null AND Schedule__c != null AND CreatedDate >= LAST_WEEK';
			}
		}
		System.debug('Start: query locator SOQL' + query) ;
		Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(this.network);
		current.isProcessingSpot__c = true ;
		update current ;
		return database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<SpotDataMirror__c> scope)
	{
		SpotDataScheduleBatch.ProcessSpotDataRecords(scope);
	}
	global static void ProcessSpotDataRecords(List<SpotDataMirror__c> scope)
	{
		List<Spot_Data__c> SpotDataList = new List<Spot_Data__c>();
		integer Increment = 0;
		Map<String, SPotDataMirror__c> UniqueIdSpotDataMirrorMap = new Map<String, SpotDataMirror__c>();
		for (SpotDataMirror__c SDM : scope)
		{
			Spot_Data__c spotDataRec = new Spot_Data__c();
	        spotDataRec.Schedule__c = SDM.Schedule__c;
	        spotDataRec.X800__c = SDM.X800__c ;
	        spotDataRec.Air_Date__c = SDM.Air_Date__c ;
	        spotDataRec.Air_Time__c = SDM.Air_Time__c ;
	        spotDataRec.Break_Code__c = SDM.Break_Code__c ;
	        spotDataRec.Commercial_Title__c = SDM.Commercial_Title__c ;
	        spotDataRec.House_Number__c = SDM.House_Number__c ;
	        spotDataRec.ISCI__c = SDM.ISCI__c ;
	        spotDataRec.Length__c = SDM.Length__c ;
	        spotDataRec.Line_Number__c = SDM.Line_Number__c ;
	        spotDataRec.Line_Type__c = SDM.Line_Type__c ;
	        spotDataRec.Market__c = SDM.Market__c ;
	        spotDataRec.Plot_End__c = SDM.Plot_End__c ;
	        spotDataRec.Plot_Start__c = SDM.Plot_Start__c ;
	        spotDataRec.Program_ID__c = SDM.Program_ID__c ;
	        spotDataRec.Raycom_Invoice_Number__c = SDM.Raycom_Invoice_Number__c ;
	        spotDataRec.Raycom_Order_Number__c = SDM.Network_Deal_Number__c ;
	        spotDataRec.Spot_Rate__c = SDM.Spot_Rate__c ;
	        spotDataRec.Spot_Status__c = SDM.Spot_Status__c ;
	        spotDataRec.Spot_Type__c = SDM.Spot_Type__c ;
	        spotDataRec.Status__c = SDM.Status__c ;
	        spotDataRec.Time_Period__c = SDM.Time_Period__c ;
	        SpotDataRec.SpotDataMirror__c = SDM.Id;
	        SpotDataRec.Error__c = SDM.Error__c;
	        spotDataRec.SpotDataMirror_Reference__c=SDM.Schedule__c+string.valueOf(SDM.Id)+Increment;
	        UniqueIdSpotDataMirrorMap.put(SDM.Schedule__c+string.valueOf(SDM.Id)+Increment,SDM);
	        system.debug('map value - ' + (SDM.Schedule__c+string.valueOf(SDM.Id)+Increment) + ' - ' + SDM.Id);
	        Increment++;
	        SpotDataList.add(SpotDataRec);
		}
		if (SpotDataList.size() > 0)
		{
			database.insert(SpotDataList);
			List<SpotDataMirror__c> SDMList = new List<SpotDataMirror__c>();
			for (Spot_Data__c SP : [select Id,Schedule__c, Name, SpotDataMirror_Reference__c from Spot_data__c where SpotDataMirror_Reference__c in: UniqueIdSpotDataMirrorMap.keySet()])
			{
				if (UniqueIdSpotDataMirrorMap.containsKey(SP.SpotDataMirror_Reference__c))
				{
					system.debug('SP values - ' + SP.SpotDataMirror_Reference__c + ' - ' + UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id);
					SDMlist.add(new SpotDataMirror__c(Id = UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id, Spot_Data__c = SP.Id, ErrorReason__c = null,Schedule__c = SP.Schedule__c, Problem__c = false));
				}
			}
			database.update(SDMList, false);
		}
	}

	global void finish(Database.BatchableContext BC)
	{
		Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(this.network);
		current.isProcessingSpot__c = false ;
		update current ;

		//we should send an email to support with the error.
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        mail.setToAddresses(toAddresses);
        mail.setSubject('MV: Apex Spot Data Schedule Batch Job Completion');
        mail.setPlainTextBody(
        	'NOTE: The Spot Data Schedule Batch Process has finished. Please check the Spot Data.\n\n'
        );
        try {
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    	} catch(Exception e) {
    	}
	}

}