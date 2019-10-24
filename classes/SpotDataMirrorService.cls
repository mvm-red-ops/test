public class SpotDataMirrorService
{

	private static final Integer START_NUMBER_DEFAULT = 6;

	public static String buildQueryForSpotDataBatch(String network) {
		String query = '';
        String fields = String.join(SaberGF.getObjectsFieldsForQueriesFromFieldSet('SpotDataMirror__c', 'SpotDataBatch'), ',');
        query = 'select ' + fields + ' from SpotDataMirror__c where Spot_Data__c = null AND CreatedDate >= LAST_WEEK AND Network__c LIKE \'%' + network + '%\'';
        return query;
	}

	private static Set<String> createOrderNumberSet(List<SpotDataMirror__c> mirrors) {
		Set<String> orderNumbers = new Set<String>();
		for (SpotDataMirror__c SDM : mirrors)
        {
            if (SDM.Network_Deal_Number__c != null && SDM.Network_Deal_Number__c != '') {
                orderNumbers.add(SDM.Network_Deal_Number__c);
            }
        }
		return orderNumbers;
	}

	private static List<Deal__c> getDealsWithSchedulesByOrderNumbers(Set<String> orderNumbers) {
		return [SELECT Id,
                       Program__r.Name, 
                       Program__r.Clock_Start_Time__c , 
                       Name, 
                       Network_Deal_Number__c, 
                       (SELECT Id, 
                               Name, 
                               UnitLength__c,
                               Days_Allowed__c,
                               Start_Time__c,
                               End_Time__c,
                               Week__c,
                               Rate__c
                          FROM Schedules__r 
                         WHERE Status__c =:'Sold') 
                    FROM Deal__c 
                   WHERE Network_Deal_Number__c IN :orderNumbers];
	}

	private static Map<String, List<Deal__c>> createDealsMapWithSchedulesByOrderNumbers(Set<String> orderNumbers) {
        Map<String, List<Deal__c>> dealMap = new Map<String, List<Deal__c>>();
		for (Deal__c dealRecord : getDealsWithSchedulesByOrderNumbers(orderNumbers)) {
            if (dealMap.containsKey(dealRecord.NetWork_Deal_NUmber__c)) {
                dealMap.get(dealRecord.NetWork_Deal_Number__c).add(dealRecord);
            } else { 
                dealMap.put(dealRecord.Network_Deal_Number__c, new List<Deal__c>{dealRecord});
            }
        } 
		return dealMap;
    }

	private static Boolean isValidateDate(Schedules__c ScheduleRecord, Integer StartNumber, DateTime AirDateTime) {
		List<String> DaysList = ScheduleRecord.Days_Allowed__c.replace(' ','').split(';');
        Boolean ValidDateRange = false;
		for (String DayString : DaysList) {
            DateTime StartTimeDate, EndTimeDate;
            integer StartHourNumber, StartMinuteNUmber, EndHourNUmber, EndMInuteNumber;
            String StartHourNumberSplit = ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[0];
            String StartMinuteNUmberSPlit = ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[1];
            String EndHourNumberSPlit = ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[0];
            String EndMinuteNumberSplit = ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[1];
            StartHourNumber = Integer.valueOf(StartHourNumberSplit) + (ScheduleRecord.Start_Time__c.contains('P') && StartHourNumberSplit != '12' ? 12 : 0) - (ScheduleRecord.Start_Time__c.contains('A') && StartHourNumberSplit == '12' ? 12 : 0);
            StartMinuteNumber = Integer.valueOf(ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[1]);
            EndHourNUmber = Integer.valueOf(EndHourNumberSPlit) + (ScheduleRecord.End_Time__c.contains('P') && EndHourNumberSplit != '12'  ? 12 : 0) - (ScheduleRecord.End_Time__c.contains('A') && EndHourNUmberSplit == '12' ? 12 : 0);
            EndMInuteNumber = Integer.valueOf(ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[1]);
            StartTimeDate = DateTime.newInstanceGMT(ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).year(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).month(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).day(), StartHourNumber, StartMinuteNumber, 0);
            EndTimeDate = DateTime.newInstanceGMT(ScheduleREcord.Week__c.addDays(ReturnDayNumber(DayString)).year(), ScheduleREcord.Week__c.addDays(ReturnDayNumber(DayString)).month(), ScheduleREcord.Week__c.addDays(ReturnDayNumber(DayString)).day() , EndHourNumber, EndMinuteNUmber, 0);
            if (ScheduleRecord.End_Time__c == '12:00A') {
                EndTimeDate = EndTimeDate.addDays(1);
            }
		    if (StartHourNumber < StartNumber) {
                StartTimeDate = StartTimeDate.addDays(1);
            	EndTimeDate = EndTimeDate.addDays(1);
            }
            if (EndHourNumber <= StartHourNumber && EndMinuteNumber <= StartMinuteNumber && ScheduleRecord.End_Time__c != '12:00A') {
                EndTimeDate = EndTimeDate.addDays(1);
            }
            if (AirDateTime > StartTimeDate && AirDateTime < EndTimeDate) {
                ValidDateRange = true;
            }
		}
		return ValidDateRange;
	}

	private static Boolean hasValidNetworkDealNumber(SpotDataMirror__C SDM, ErrorReport report) {
		if (SDM.Network_Deal_Number__c == null && SDM.Network_Deal_Number__c == '') {
			report.InvalidNetworkDealNumber = true;
			return false;
		}
		System.debug('hasValidNetworkDealNumber');
		return true;
	}

	private static Integer getStartNumber(Deal__c dealRecord) {
		if (dealRecord.Program__r.Clock_Start_Time__c != null) {
            return Integer.valueOf(dealRecord.Program__r.Clock_Start_Time__c.replace('AM',''));
		}
		return START_NUMBER_DEFAULT;
	}

	private static Boolean hasNetworkDealNumberMatch(SpotDataMirror__C SDM, Deal__c dealRecord, ErrorReport report) {
		if (DealRecord.Program__r.Name != SDM.Network__c) {
			report.NetworkDealNumberNotFound = true;
			return false;
		}
		System.debug('hasNetworkDealNumberMatch');
		return true;
	}

	private static Boolean hasValidUnitLength(SpotDataMirror__c SDM, Schedules__c schedule, ErrorReport report) {
		if (schedule.UnitLength__c == null || SDM.Length__c == null || (schedule.UnitLength__c != decimal.valueOf(SDM.Length__c)) ) {
			report.UnitLengthNotFound = true;
			return false;
		}
		return true;
	}

	private static Boolean hasValidAirDate(SpotDataMirror__c SDM, Schedules__c schedule, ErrorReport report, Integer StartNumber) {
        if (SDM.Schedule__c != null) return true;

        if (SDM.Air_Date__c == null && schedule.Days_Allowed__c == null) {
			report.AirDateNotFound = true;
			return false;
		}
    	
		Datetime dt = DateTime.newInstance(SDM.Air_Date__c.year(), SDM.Air_Date__c.month(), SDM.Air_Date__c.day());
        if (!schedule.Days_Allowed__c.ToLowerCase().contains( (dt.format('EEEE')).subString(0,3).toLowerCase())) {
            report.AirDateNotValid = true;
			return false;
		}
		
		if (SDM.Air_Time__c == null && SDM.Air_Time__c == '') {
			report.AirTimeNotFound = true;
			return false;
		}

		List<String> AirTimeStringList = SDM.Air_Time__c.replace(' ','').replace('PM','').replace('AM','').split(':');
		if (AirTimeStringList.size() != 3) {
			return false;
		}

		DateTime AirDateTime = DateTime.newInstanceGMT(SDM.Air_Date__c.year(), SDM.Air_Date__c.month(), SDM.Air_Date__c.day(), Integer.valueOf(AirTimeStringList[0]) + ((SDM.Air_Time__c.contains('PM') && AirTimeStringList[0] != '12')?12 : 0) - ((SDM.Air_Time__c.contains('AM') && AirTimeStringList[0] == '12')?12 : 0) , Integer.valueOf(AirTimeStringList[1]), Integer.valueOf(AirTimeStringList[2]));
        if (AirDateTime.hourgmt() < StartNumber) {
            AirDateTime = AirDateTime.addDays(1);
        }
                                                    
    	if (schedule.Days_Allowed__c == null && schedule.Start_Time__c == null && schedule.End_Time__c == null && schedule.Week__c == null) {
			report.AirTimeNotFound = true;
			return false;
		}

		if (!isValidateDate(schedule, StartNumber, AirDateTime)) {
			report.AirTimeNotFound = true;
            return false;
        }
        
		return true;
	}

	private static Boolean hasValidRate(SpotDataMirror__c SDM, Schedules__c schedule, ErrorReport report) {
		System.debug('Schedule rate: '+schedule.Rate__c +' '+ 'SDM Rate: '+SDM.Spot_Rate__c);
		if ((schedule.Rate__c != null && SDM.Spot_Rate__c != null) && (schedule.Rate__c == SDM.Spot_Rate__c)) {
			return true;
		}
		report.RateNotFound = true;
		System.debug('RateNotFound');
		return false;
	}

	private static Id getDealScheduleMatchWithSpotDataMirror(SpotDataMirror__c SDM, List<Schedules__c> SchedulesList, ErrorReport report, Integer StartNumber) {
		if (SchedulesList == null && SchedulesList.isEmpty()) {
			return null;
		} 

		for (Schedules__c ScheduleRecord : SchedulesList) {
			if (!hasValidUnitLength(SDM, ScheduleRecord, report)) {
				continue;
			}

			if (!hasValidAirDate(SDM, ScheduleRecord, report, StartNumber)) {
				continue;
			}

			if (!hasValidRate(SDM, ScheduleRecord, report)) {
				continue;
			}

			System.debug('hasScheduleMatch');
			return ScheduleRecord.Id;

		}
		
		return null;
	}

	private static List<Spot_Data__c> parseMirrorsIntoSpotData(List<SpotDataMirror__c> SpotDataMirrorList, Map<String, List<Deal__c>> DealMap) {
		List<Spot_Data__c> SpotDataList = new List<Spot_Data__c>();
		for (SpotDataMirror__c SDM : SpotDataMirrorList) {

			ErrorReport report = new ErrorReport();

			if (hasValidNetworkDealNumber(SDM, report) && DealMap.containsKey(SDM.Network_Deal_Number__c)) {
				for (Deal__c DealRecord : DealMap.get(SDM.Network_Deal_Number__c)) {
					Integer StartNumber = getStartNumber(DealRecord); 
					if (hasNetworkDealNumberMatch(SDM, DealRecord, report)) {
						Id scheduleId = getDealScheduleMatchWithSpotDataMirror(SDM, DealRecord.Schedules__r, report, StartNumber);

						if (scheduleId != null) {
                            SpotDataList.add(createSpotDataRecord(scheduleId, SDM));
							
                            break;
						}
					}
				}
			}
			if (report.wasErrorFound()) {
                System.debug('errorReason: ' + report.getErrorString());
				SDM.ErrorReason__c = report.getErrorString();
			}

        }
		return SpotDataList;
	}

	private static Spot_Data__c createSpotDataRecord(Id scheduleId, SpotDataMirror__c rec) {
        Spot_Data__c spotDataRec = new Spot_Data__c();
        spotDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        spotDataRec.Schedule__c = scheduleId;
        spotDataRec.X800__c = rec.X800__c ;
        spotDataRec.Air_Date__c = rec.Air_Date__c ;
        spotDataRec.Air_Time__c = rec.Air_Time__c ;
        spotDataRec.Commercial_Title__c = rec.Commercial_Title__c ;
        spotDataRec.ISCI__c = rec.ISCI__c ;
        spotDataRec.Length__c = rec.Length__c ;
        spotDataRec.Line_Number__c = rec.Line_Number__c ;
        spotDataRec.Plot_End__c = rec.Plot_End__c ;
        spotDataRec.Plot_Start__c = rec.Plot_Start__c ;
        spotDataRec.Program_ID__c = rec.Program_ID__c ;
        spotDataRec.Raycom_Order_Number__c = rec.Network_Deal_Number__c ;
        spotDataRec.Spot_Rate__c = rec.Spot_Rate__c ;
        spotDataRec.Status__c = rec.Status__c ;
        spotDataRec.Time_Period__c = rec.Time_Period__c ;
        SpotDataRec.SpotDataMirror__c = rec.Id;
        return spotDataRec;
    }

	private static List<Spot_Data__c> getSpotDataByMirrorId(Set<Id> mirrorIds) {
		return [Select Id,
					   SpotDataMirror__r.Id
				FROM Spot_Data__c
				WHERE SpotDataMirror__r.Id IN :mirrorIds];
	}

	public static void updateLookupOnMirrorFromSpotDataList(List<SpotDataMirror__c> mirrors) {
		Map<Id, Spot_Data__c> spotDataByMirrorId = new Map<Id, Spot_Data__c>();
		Map<Id, SpotDataMirror__c> mirrorsByMirrorId = new Map<Id, SpotDataMirror__c>();

		for (SpotDataMirror__c mirror: mirrors) {
			if (mirror.ErrorReason__c == null) {
				mirrorsByMirrorId.put(mirror.Id, mirror);
			}
		}
		List<Spot_Data__c> spotData = getSpotDataByMirrorId(mirrorsByMirrorId.keySet());

		for (Spot_Data__c spot: spotData) {
			spotDataByMirrorId.put(spot.SpotDataMirror__c, spot);
		}

		for (SpotDataMirror__c mirror: mirrors) {
			mirror.Spot_Data__c = spotDataByMirrorId.get(mirror.Id).Id;
			System.debug('Spot Data Updated: ' +mirror.Spot_Data__c);
		}

		update mirrors;
	}

	public static void createSpotDataFromMirrors(List<SpotDataMirror__c> SpotDataMirrorList) {
		Map<String, List<Deal__c>> DealMap = createDealsMapWithSchedulesByOrderNumbers(createOrderNumberSet(SpotDataMirrorList));
		List<Spot_Data__c> SpotDataList = parseMirrorsIntoSpotData(SpotDataMirrorList, DealMap);
        System.debug('spots: ' + SpotDataList);
		upsert SpotDataList;

		Map<Id, SpotDataMirror__c> mirrorsByMirrorId = new Map<Id, SpotDataMirror__c>();
		for(SpotDataMirror__c mirror: SpotDataMirrorList) {
			mirrorsByMirrorId.put(mirror.Id, mirror);
		}
		for (Spot_Data__c spotData: SpotDataList) {
			mirrorsByMirrorId.get(spotData.SpotDataMirror__c).Spot_Data__c = spotData.Id;
			mirrorsByMirrorId.get(spotData.SpotDataMirror__c).Schedule__c = spotData.Schedule__c;
		}

		List<SpotDataMirror__c> toUpdate = mirrorsByMirrorId.values();
		List<Database.SaveResult> results = Database.update(toUpdate, false);

		Integer index = 0;
		List<Spot_Data__c> toDelete = new List<Spot_Data__c>();
		for (Database.SaveResult result : results) {
			if (!result.isSuccess()) {
				System.debug('Error: ' + result.getErrors()[0].getMessage());
				toDelete.add(new Spot_Data__c(Id = toUpdate[index].Spot_Data__c));
			}
			index++;
		}

		delete toDelete;
	}

	private static integer ReturnDayNumber(String dayString) {
		switch on dayString {
			when 'Mon' {
				return 0;
			} when 'Tue' {
				return 1;
			} when 'Wed'{
				return 2;	
			} when 'Thu' {
				return 3;
			} when 'Fri' {
				return 4;
			} when 'Sat' {
				return 5;
			} when 'Sun' {
				return 6;
			} when else {
				return 0;
			}
		}
    }

	private class ErrorReport {
		string ErrorReasonList;
        Boolean InvalidNetworkDealNumber = false;
        Boolean NetworkDealNumberNotFound = false;
        Boolean UnitLengthNotFound = false;
        Boolean AirDateNotFound = false;
		Boolean AirDateNotValid = false;
        Boolean AirTimeNotFound = false;
        Boolean RateNotFound = false;

		public Boolean wasErrorFound() {
			return InvalidNetworkDealNumber || NetworkDealNumberNotFound || UnitLengthNotFound || AirDateNotFound || AirTimeNotFound || RateNotFound;
		} 

		public String getErrorString() {
			String errorString = '';
			if (InvalidNetworkDealNumber) {
				errorString = 'Invalid Network Deal Number';
			}

			if (NetworkDealNumberNotFound) {
				errorString ='Network Deal Number Not Found';
			}

			if (UnitLengthNotFound) {
				errorString = 'Unit Length Not Found';
			}

			if (AirDateNotFound) {
				errorString = 'Air Date Not Found';
			}

			if (AirDateNotValid) {
				errorString = 'Air Date Not Valid';
			}

			if (AirTimeNotFound) {
				errorString = 'Air Time Not Found';
			}

			if (RateNotFound) {
				errorString = 'Rate Not Found';
			}
			return errorString;
		}
	}
}