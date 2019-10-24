public class PrelogDataBatchService
{

    private static final Integer START_NUMBER_DEFAULT = 6;

    public static void createSpotDataFromMirrors(List<PrelogDataMirror__c> prelogMirrors, Id batchJobId) {
        List<PrelogData__c> prelogData = new List<PrelogData__c>();
        Map<String, List<Deal__c>> dealMap = createDealsMapWithSchedulesByOrderNumbers(createOrderNumberSet(prelogMirrors));
        prelogData = parseMirrorsIntoPrelogData(prelogMirrors, dealMap);
        Database.insert(prelogData, false);

        Map<Id, PrelogDataMirror__c> mirrorsByMirrorId = new Map<Id, PrelogDataMirror__c>();
        for(PrelogDataMirror__c mirror: prelogMirrors) {
            mirrorsByMirrorId.put(mirror.Id, mirror);
        }

        List<PrelogData__c> deletePrelogData = new List<PrelogData__c>();
        for (PrelogData__c data: prelogData) {
            mirrorsByMirrorId.get(data.PrelogDataMirror__c).Batch_Id__c = batchJobId;
            if(data.Id != null && (mirrorsByMirrorId.get(data.PrelogDataMirror__c).ErrorReason__c == null || mirrorsByMirrorId.get(data.PrelogDataMirror__c).ErrorReason__c == '')) {
                mirrorsByMirrorId.get(data.PrelogDataMirror__c).Schedule__c = data.Schedule__c;
                mirrorsByMirrorId.get(data.PrelogDataMirror__c).PrelogData__c = data.Id;
            } else {
                mirrorsByMirrorId.get(data.PrelogDataMirror__c).Schedule__c = null;
                mirrorsByMirrorId.get(data.PrelogDataMirror__c).PrelogData__c = null;
                deletePrelogData.add(data);
            }
        }

        Database.update(mirrorsByMirrorId.values(), false);
        Database.delete(deletePrelogData, false);
    }

    private static List<PrelogData__c> parseMirrorsIntoPrelogData(List<PrelogDataMirror__c> prelogMirrors, Map<String, List<Deal__c>> dealMap) {
        List<PrelogData__c> prelogData = new List<PrelogData__c>();
        for (PrelogDataMirror__c mirror: prelogMirrors) {

            ScheduleResult sResult = null;
            ErrorReport report = new ErrorReport();
            if (hasValidNetworkDealNumber(mirror, report) && dealMap.containsKey(mirror.NetworkDealNumber__c)) {
                for (Deal__c DealRecord : dealMap.get(mirror.NetworkDealNumber__c)) {
                    Integer StartNumber = getStartNumber(DealRecord);
                    if (hasNetworkDealNumberMatch(mirror, DealRecord, report)) {
                        mirror.Deal__c = DealRecord.Id;
                        sResult = getDealScheduleMatchWithPrelogDataMirror(mirror, DealRecord.Schedules__r, report, StartNumber);
                        if (sResult.success) {
                            PrelogData__c prelogRecord = createPrelogDataRecord(sResult.scheduleId, mirror);
                            prelogData.add(prelogRecord);
                            mirror.Schedule__c = sResult.scheduleId;
                            break;
                        }
                    }
                }
            }
            if (report.wasErrorFound()) {
                mirror.ErrorReason__c = report.getErrorString();
            }
        }
        return prelogData;
    }

    private static PrelogData__c createPrelogDataRecord(Id scheduleId, PrelogDataMirror__c rec)
    {
        PrelogData__c PrelogDataRec = new PrelogData__c();
        PrelogDataRec.AdvertiserProduct__c = rec.AdvertiserProduct__c;
        PrelogDataRec.Agency__c = rec.Agency__c;
        PrelogDataRec.AirDate__c = rec.AirDate__c;
        PrelogDataRec.BreakCode__c = rec.BreakCode__c;
        PrelogDataRec.MaterialDescription__c = rec.MaterialDescription__c;
        PrelogDataRec.OrderProductDescription__c = rec.OrderProductDescription__c;
        PrelogDataRec.PrelogDataMirror__c = rec.Id;
        PrelogDataRec.Rate__c = rec.Rate__c;
        PrelogDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        PrelogDataRec.Schedule__c = scheduleId;
        PrelogDataRec.ScheduleAdID__c = rec.ScheduleAdID__c;
        PrelogDataRec.ScheduleLength__c = rec.ScheduleLength__c;
        PrelogDataRec.ScheduleTime__c = rec.ScheduleTime__c;
        PrelogDataRec.TimePeriod__c = rec.TimePeriod__c;
        PrelogDataRec.Version__c = rec.Version__c;
        return PrelogDataRec;
    }

    private class ScheduleResult {
        String scheduleId;
        Boolean success;
        public ScheduleResult(String sId, Boolean s) {
            this.scheduleId = sId;
            this.success = s;
        }
    }

    private static ScheduleResult getDealScheduleMatchWithPrelogDataMirror(PrelogDataMirror__c mirror, List<Schedules__c> schedules, ErrorReport report, Integer StartNumber) {
        if (schedules == null || schedules.isEmpty()) {
            return new ScheduleResult(null, false);
        }
        ScheduleResult result = new ScheduleResult(null, false);
        for (Schedules__c schedule : schedules) {
            if (!hasValidUnitLength(mirror, schedule, report)) {
                result.scheduleId = schedule.Id;
                continue;
            }

            if (!hasValidAirDate(mirror, schedule, report, StartNumber)) {
                result.scheduleId = schedule.Id;
                continue;
            }

            if (!hasValidRate(mirror, schedule, report)) {
                result.scheduleId = schedule.Id;
                continue;
            }

            return new ScheduleResult(schedule.Id, true);

        }

        return result;
    }

    private static Boolean hasValidRate(PrelogDataMirror__c mirror, Schedules__c schedule, ErrorReport report) {
        if ((schedule.Rate__c != null && mirror.Rate__c != null) && (schedule.Rate__c == mirror.Rate__c)) {
            return true;
        }
        report.RateNotFound = true;
        return false;
    }

    private static Boolean hasValidAirDate(PrelogDataMirror__c mirror, Schedules__c schedule, ErrorReport report, Integer StartNumber) {
        if (mirror.AirDate__c == null && schedule.Days_Allowed__c == null) {
            report.AirDateNotFound = true;
            return false;
        }

        Datetime dt = Datetime.newInstance(mirror.AirDate__c.year(), mirror.AirDate__c.month(), mirror.AirDate__c.day());
        if (!schedule.Days_Allowed__c.toLowerCase().contains((dt.format('EEEE')).substring(0,3).toLowerCase())) {
            report.AirDateNotValid = true;
            return false;
        }


        if (mirror.ScheduleTime__c == null && mirror.ScheduleTime__c == '') {
            report.AirTimeNotFound = true;
            return false;
        }

        List<String> AirTimeStringList = mirror.ScheduleTime__c.replace(' ','').replace('PM','').replace('AM','').split(':');
        if (AirTimeStringList.size() != 3) {
            return false;
        }

        Datetime AirDateTime = Datetime.newInstanceGmt(mirror.AirDate__c.year(), mirror.AirDate__c.month(), mirror.AirDate__c.day(), Integer.valueOf(AirTimeStringList[0]) + ((mirror.ScheduleTime__c.contains('PM') && AirTimeStringList[0] != '12')?12 : 0) - ((mirror.ScheduleTime__c.contains('AM') && AirTimeStringList[0] == '12')?12 : 0) , Integer.valueOf(AirTimeStringList[1]), Integer.valueOf(AirTimeStringList[2]));
        if (AirDateTime.hourGmt() < StartNumber) {
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

    private static Boolean hasValidUnitLength(PrelogDataMirror__c mirror, Schedules__c schedule, ErrorReport report) {
        if (schedule.UnitLength__c == null || mirror.ScheduleLength__c == null || (schedule.UnitLength__c != Decimal.valueOf(mirror.ScheduleLength__c)) ) {
            report.UnitLengthNotFound = true;
            return false;
        }
        return true;
    }

    private static Boolean hasValidNetworkDealNumber(PrelogDataMirror__c mirror, ErrorReport report) {
        if (mirror.NetworkDealNumber__c == null || mirror.NetworkDealNumber__c == '') {
            report.InvalidNetworkDealNumber = true;
            return false;
        }
        return true;
    }

    private static Boolean hasNetworkDealNumberMatch(PrelogDataMirror__c mirror, Deal__c dealRecord, ErrorReport report) {
        if (dealRecord.Program__r.Name != mirror.Network__c) {
            report.NetworkDealNumberNotFound = true;
            return false;
        }
        return true;
    }

    private static Boolean isValidateDate(Schedules__c ScheduleRecord, Integer StartNumber, Datetime AirDateTime) {
        List<String> DaysList = ScheduleRecord.Days_Allowed__c.replace(' ','').split(';');
        Boolean ValidDateRange = false;
        for (String DayString : DaysList) {
            Datetime StartTimeDate, EndTimeDate;
            Integer StartHourNumber, StartMinuteNUmber, EndHourNUmber, EndMInuteNumber;
            String StartHourNumberSplit = ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[0];
            String StartMinuteNUmberSPlit = ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[1];
            String EndHourNumberSPlit = ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[0];
            String EndMinuteNumberSplit = ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[1];
            StartHourNumber = Integer.valueOf(StartHourNumberSplit) + (ScheduleRecord.Start_Time__c.contains('P') && StartHourNumberSplit != '12' ? 12 : 0) - (ScheduleRecord.Start_Time__c.contains('A') && StartHourNumberSplit == '12' ? 12 : 0);
            StartMinuteNUmber = Integer.valueOf(ScheduleRecord.Start_Time__c.replace('P','').replace('A','').split(':')[1]);
            EndHourNUmber = Integer.valueOf(EndHourNumberSPlit) + (ScheduleRecord.End_Time__c.contains('P') && EndHourNumberSPlit != '12'  ? 12 : 0) - (ScheduleRecord.End_Time__c.contains('A') && EndHourNumberSPlit == '12' ? 12 : 0);
            EndMInuteNumber = Integer.valueOf(ScheduleRecord.End_Time__c.replace('P','').replace('A','').split(':')[1]);
            StartTimeDate = Datetime.newInstanceGmt(ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).year(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).month(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).day(), StartHourNumber, StartMinuteNUmber, 0);
            EndTimeDate = Datetime.newInstanceGmt(ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).year(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).month(), ScheduleRecord.Week__c.addDays(ReturnDayNumber(DayString)).day() , EndHourNUmber, EndMInuteNumber, 0);

            if (ScheduleRecord.End_Time__c == '12:00A') {
                EndTimeDate = EndTimeDate.addDays(1);
            }

            if (StartHourNumber < StartNumber) {
                StartTimeDate = StartTimeDate.addDays(1);
                EndTimeDate = EndTimeDate.addDays(1);
            }

            if (EndHourNUmber <= StartHourNumber && EndMInuteNumber <= StartMinuteNUmber && ScheduleRecord.End_Time__c != '12:00A') {
                EndTimeDate = EndTimeDate.addDays(1);
            }

            if (AirDateTime > StartTimeDate && AirDateTime < EndTimeDate) {
                ValidDateRange = true;
            }
        }

        return ValidDateRange;
    }

    private static Set<String> createOrderNumberSet(List<PrelogDataMirror__c> mirrors) {
        Set<String> orderNumbers = new Set<String>();
        for (PrelogDataMirror__c PLDM : mirrors) {
            if (PLDM.NetworkDealNumber__c != null && PLDM.NetworkDealNumber__c != '') {
                orderNumbers.add(PLDM.NetworkDealNumber__c);
            }
        }
        return orderNumbers;
    }

    private static Integer getStartNumber(Deal__c dealRecord) {
        if (dealRecord.Program__r.Clock_Start_Time__c != null) {
            return Integer.valueOf(dealRecord.Program__r.Clock_Start_Time__c.replace('AM',''));
        }
        return START_NUMBER_DEFAULT;
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
        WHERE Status__c = 'Sold')
        FROM Deal__c
        WHERE Network_Deal_Number__c  =: orderNumbers];
    }

    private static Map<String, List<Deal__c>> createDealsMapWithSchedulesByOrderNumbers(Set<String> orderNumbers) {
        Map<String, List<Deal__c>> dealMap = new Map<String, List<Deal__c>>();
        for (Deal__c dealRecord : getDealsWithSchedulesByOrderNumbers(orderNumbers)) {
            if (dealMap.containsKey(dealRecord.Network_Deal_Number__c)) {
                dealMap.get(dealRecord.Network_Deal_Number__c).add(dealRecord);
            } else {
                dealMap.put(dealRecord.Network_Deal_Number__c, new List<Deal__c>{dealRecord});
            }
        }

        return dealMap;
    }

    private class ErrorReport {
        String ErrorReasonList;
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

    private static Integer ReturnDayNumber(String dayString) {
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
}