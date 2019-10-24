global class SpotDataBatch implements Database.batchable <sobject>
{
    global static integer Increment = 0;
    global static Map<String, SPotDataMirror__c> UniqueIdSpotDataMirrorMap = new Map<String, SpotDataMirror__c>();
    global String network ;
    global List<Id> SpotDataMirrorIdList;
    global SpotDataBatch(List<Id> pSpotDataMirrorIdList)
    {
        SpotDataMirrorIdList = pSpotDataMirrorIdList;
    }
    global SpotDataBatch(String n)
    {
        System.debug('***SpotDataBatch Constructor: n ' + n);
        if(n == 'All') {
            this.network = '' ;
        } else {
            this.network = n ;
        }
        System.debug('***SpotDataBatch Constructor: network ' + network);
    }

    global database.QueryLocator Start(Database.BatchableContext BC)
    {
        system.debug('SpotDataMirrorIdList - ' + SpotDataMirrorIdList);
        String query ;
        if (SpotDataMirrorIdList == null)
        {
            //string TodayDate = Date.Today().year() + '-' + (Date.Today().month()< 10? '0' + Date.Today().month() : Date.Today().month()) + '-' + (Date.Today().day()< 10? '0' + Date.Today().day() : Date.Today().day());
            query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Spot_Data__c = null AND CreatedDate >= LAST_WEEK AND Network__c LIKE \'%' + this.network + '%\'';
        }
        else
        {
            if (SpotDataMIrrorIdList.size() > 0)
            {
                query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Id in ' + SaberGF.ReturnDynamicQueryList(SpotDataMirrorIdList);
            }
            else
            {
                query = 'select ' + SaberGF.GetObjectsFieldsForQueries('SpotDataMirror__c') + ' from SpotDataMirror__c where Spot_Data__c = null AND CreatedDate >= LAST_WEEK';
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
        SpotDataBatch.ProcessSpotDataRecords(Scope);
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
        mail.setSubject('MV: Apex Spot Data Batch Job Completion');
        mail.setPlainTextBody(
            'NOTE: The Spot Data Batch Process has finished. Please check the Spot Data.\n\n'
        );
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch(Exception e) {
        }
    }
    global static void ProcessSpotDataRecords(List<SpotDataMirror__c> SpotDataMirrorList)
    {
        Savepoint SavePointLine = Database.setSavepoint();
        try
        {
            Set<String> OrderNumberSet = new Set<String>();
            List<Spot_Data__c> SpotDataList = new List<Spot_Data__c>();
            for (SpotDataMirror__c SDM : SpotDataMirrorList)
            {
                if (SDM.Network_Deal_Number__c != null && SDM.Network_Deal_Number__c != '')
                {
                    OrderNumberSet.add(SDM.Network_Deal_Number__c);
                }
            }
            List<Deal__c> DealList = [SELECT Id,Program__r.Name, Program__r.Clock_Start_Time__c , Name, Network_Deal_Number__c, (SELECT Id, Name, RecordTypeId, Week__c, Day__c, Units_Available__c, NFL_Daypart__c, Rate__c, ISCI_CODE__c, MGM_HD_Daypart__c, X30_Rate__c, COUNTMENOT__c, Week_Number__c, Status__c, Comments__c, Total_Time__c, Total_Dollars__c, X800_Number__c, Equiv_30__c, Spot_Count__c, Clearance__c, Day_of_Week__c, Intg_Week__c, Affidavit__c, Deal_Parent__c, DealProgram__c, DealAccount__c, DealContact__c, DealBrand__c, SS9_Titles__c, Units_Preempted__c, Units_Aired__c, TEST__c, COOL_TV_Daypart__c, UnitLength__c, Spot_Total__c, PI_Payout__c, Spot_Data_Dollars_CHECK__c, Spot_Data_Unit_CHECK__c, Long_Form__c, LF_Week__c, Time_Period__c, Barter_Package__c, DealClientCode__c, LF_Brand__c, X2Calculated_Time_Period__c, CIA__c, Intg_Date__c, Net_Total__c, Dollars_Booked__c, CALC_EQUIV_30__c, Total_Schedules__c, GM__c, Networks__c, Filler__c, Day_Restrictions__c, SS10_Titles__c, End_Time__c, Start_Time__c, Ghost_Order__c, Raycom_Make_Good__c, Product__c, Reviewed_for_Invoicing__c, SI_Number_if_Billed__c, PI__c, Equiv_30_Booked__c, Test_Impact_Event__c, SS10_Titles_Value__c, SS9_Titles_Value__c, Auto_Credited__c, LF_Daypart__c, Send_as_NEW__c, Incumbency__c, Recommended__c, Churn__c, Previous_Incumbent__c, LF_Rate_Needed__c, LF_Results__c, LF_Next_Month_Status__c, Integrates_This_Week__c, Month__c, Quarter__c, Total_Historical_Dollars__c, Year__c, PP_Revision_Comment__c, PP_Revision__c, PI_Payout_TEST__c, Integrated__c, Due_Date__c, Program_Week__c, X120s__c, X30s__c, X15s__c, Priority__c, Days_Allowed__c, Max_Per_Day__c FROM Schedules__r WHERE Status__c =:'Sold') FROM Deal__c WHERE Network_Deal_Number__c IN :OrderNumberSet];
            //List<Deal__c> DealList = Database.query('select ' + SaberGF.GetObjectsFieldsForQueries('Deal__c') + ', (select ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c') + ' from  from Deal__c
            List<SpotDataMirror__c> SDMList = new List<SpotDataMirror__c>();
            Map<String, List<Deal__c>> DealMap = new Map<String, List<Deal__c>>();
            for (Deal__c DealRecord : DealList)
            {
                if (DealMap.containsKey(DealRecord.NetWork_Deal_NUmber__c))
                {
                    DealMap.get(DealRecord.NetWork_Deal_Number__c).add(DealRecord);
                }
                else
                {
                    DealMap.put(DealRecord.Network_Deal_Number__c, new List<Deal__c>{DealRecord});
                }

            }
            for (SpotDataMirror__c SDM : SpotDataMirrorList)
            {
                string ErrorReasonList;
                Boolean NoNetworkDealNumber = true;
                Boolean NetworkDealNumberNotFound = true;
                Boolean UnitLengthNotFound = true;
                Boolean AirDateNotFound = true;
                Boolean AirTimeNotFound = true;
                Boolean RateNotFound = true;
                Boolean UnitLengthFound = false;
                Boolean AirDateFound = false;
                Boolean AirTimeFound = false;
                Boolean RateFound = false;
                Boolean ContinueSDM = false;
                if (SDM.Network_Deal_Number__c != null && SDM.Network_Deal_Number__c != '')
                {
                    NoNetworkDealNumber = false;
                    if (DealMap.containsKey(SDM.Network_Deal_Number__c))
                    {
                        for (Deal__c DealRecord : DealMap.get(SDM.Network_Deal_Number__c))
                        {
                            integer StartNumber = 6;
                            if (DealRecord.Program__r.Clock_Start_Time__c != null)
                            {
                                StartNumber = Integer.valueOf(DealREcord.Program__r.Clock_Start_Time__c.replace('AM',''));
                            }
                            if (DealREcord.Program__r.Name == SDM.Network__c)
                            {
                                NetworkDealNumberNotFound = false;
                                List<Schedules__c> SchedulesList = DealRecord.Schedules__r;
                                if (SchedulesList != null)
                                {
                                    if (SchedulesList.size() > 0)
                                    {
                                        for (Schedules__c ScheduleRecord : SchedulesList)
                                        {
                                            Boolean MatchFound = true;
                                            if (ScheduleRecord.UnitLength__c == null || SDM.Length__c == null )
                                            {
                                                MatchFound = false;
                                            }
                                            else
                                            {
                                                //decimal DecLength = decimal.valueof(ScheduleRecord.UnitLength__c);
                                                //if (ScheduleRecord.UnitLength__c != string.ValueOf(SDM.Length__c))
                                                if (ScheduleRecord.UnitLength__c != decimal.valueOf(SDM.Length__c))
                                                {
                                                    MatchFound = false;
                                                }
                                                else
                                                {
                                                    UnitLengthNotFound = false;
                                                    UnitLengthFound = true;
                                                }
                                            }
                                            System.debug('UnitLength - ' + ScheduleRecord.Id + ' - ' + ScheduleRecord.UnitLength__c + ' - ' + SDM.Length__c + ' - ' + UnitLengthNotFound);
                                            if (SDM.Air_Date__c != null && ScheduleRecord.Days_Allowed__c != null)
                                            {
                                                Datetime dt = DateTime.newInstance(SDM.Air_Date__c.year(), SDM.Air_Date__c.month(), SDM.Air_Date__c.day());
                                                if (!ScheduleRecord.Days_Allowed__c.ToLowerCase().contains( (dt.format('EEEE')).subString(0,3).toLowerCase()))
                                                {
                                                    MatchFound = false;
                                                }
                                                else
                                                {
                                                    AirDateNotFound = false;
                                                    AirDateFound = true;
                                                }
                                            }
                                            else
                                            {
                                                MatchFound = false;
                                            }
                                            System.debug('AirDate - ' + ScheduleRecord.Id + ' - ' + ScheduleRecord.Days_Allowed__c + ' - ' + SDM.Air_Date__c + ' - ' + AirDateNotFound);
                                            DateTime AirDateTime;
                                            if (SDM.Air_Date__c != null && SDM.Air_Time__c != null && SDM.Air_Time__c != '')
                                            {
                                                List<String> AirTimeStringList = SDM.Air_Time__c.replace(' ','').replace('PM','').replace('AM','').split(':');
                                                if (AirTimeStringList.size() == 3)
                                                {
                                                    system.debug('AirDateTime Compose - ' + SDM.Air_Date__c.year() + ' - ' + SDM.Air_Date__c.month() + ' - ' + SDM.Air_Date__c.day() + ' - ' + (Integer.valueOf(AirTimeStringList[0]) + ((SDM.Air_Time__c.contains('PM') && AirTimeStringList[0] != '12')?12 : 0) - ((SDM.Air_Time__c.contains('AM') && AirTimeStringList[0] == '12')?12 : 0)) + ' - ' + Integer.valueOf(AirTimeStringList[1]) + ' - ' + Integer.valueOf(AirTimeStringList[2]));
                                                    AirDateTime = DateTime.newInstanceGMT(SDM.Air_Date__c.year(), SDM.Air_Date__c.month(), SDM.Air_Date__c.day(), Integer.valueOf(AirTimeStringList[0]) + ((SDM.Air_Time__c.contains('PM') && AirTimeStringList[0] != '12')?12 : 0) - ((SDM.Air_Time__c.contains('AM') && AirTimeStringList[0] == '12')?12 : 0) , Integer.valueOf(AirTimeStringList[1]), Integer.valueOf(AirTimeStringList[2]));
                                                    //New Code to add a day to the time to make it find the correct schedule matches
                                                    system.debug('AirDateTime hour value - ' + AirDateTime.yeargmt() + ' - ' + AirDateTime.monthgmt() + ' - ' + AirDateTime.daygmt() + ' - ' + AirDateTime.hourgmt() + ' - ' + AirDateTime.minutegmt() + ' - ' + AirDateTime.secondgmt());
                                                    if (AirDateTime.hourgmt() < StartNumber)
                                                    {
                                                        AirDateTime = AirDateTime.addDays(1);
                                                    }
                                                    //////////////////////////////////////
                                                    if (ScheduleRecord.Days_Allowed__c != null && ScheduleRecord.Start_Time__c != null && ScheduleRecord.End_Time__c != null && ScheduleRecord.Week__c != null)
                                                    {
                                                        List<String> DaysList = ScheduleRecord.Days_Allowed__c.replace(' ','').split(';');
                                                        Boolean ValidDateRange = false;
                                                        for (String DayString : DaysList)
                                                        {
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
                                                            //If EndTime is 12:00A, add 1 day to the EndTimeDate
                                                            if (ScheduleRecord.End_Time__c == '12:00A')
                                                            {
                                                                EndTimeDate = EndTimeDate.addDays(1);
                                                            }
                                                            /*if (ScheduleRecord.Start_Time__c == ScheduleREcord.End_Time__c)
                                                            {
                                                                EndTimeDate = EndTimeDate.addDays(1);
                                                            }*/
                                                            if (StartHourNumber < StartNumber)
                                                            {
                                                                StartTimeDate = StartTimeDate.addDays(1);
                                                                EndTimeDate = EndTimeDate.addDays(1);
                                                            }
                                                            if (EndHourNumber <= StartHourNumber && EndMinuteNumber <= StartMinuteNumber && ScheduleRecord.End_Time__c != '12:00A')
                                                            {
                                                                EndTimeDate = EndTimeDate.addDays(1);
                                                            }
                                                            system.debug('AIrDateTime values - ' + ScheduleREcord.Id + ' - ' + AirDateTime + ' - ' + StartTimeDate + ' - ' + EndTimeDate + ' - ' + (AirDateTime > StartTimeDate && AirDateTime < EndTimeDate));
                                                            if (AirDateTime > StartTimeDate && AirDateTime < EndTimeDate)
                                                            {
                                                                ValidDateRange = true;
                                                            }
                                                        }
                                                        if (!ValidDateRange)
                                                        {
                                                            MatchFound = false;
                                                        }
                                                        else
                                                        {
                                                            AirTimeNotFound = false;
                                                            AIrTimeFound = true;
                                                        }
                                                    }
                                                    else
                                                    {
                                                        MatchFound = false;
                                                    }
                                                }
                                                else
                                                {
                                                    MatchFound = false;
                                                }
                                            }
                                            else
                                            {
                                                MatchFound = false;
                                            }
                                            system.debug('AIrDateTime Final - ' + AirTimeNotFound);
                                            if (ScheduleRecord.Rate__c != null && SDM.Spot_Rate__c != null)
                                            {
                                                if (ScheduleRecord.Rate__c != SDM.Spot_Rate__c)
                                                {
                                                    MatchFound = false;
                                                }
                                                else
                                                {
                                                    RateNotFound = false;
                                                    RateFound = true;
                                                }
                                            }
                                            else
                                            {
                                                MatchFound = false;
                                            }
                                            system.debug('Rate values - ' + ScheduleRecord.Id + ' - ' + ScheduleRecord.Rate__c + ' - ' + SDM.Spot_Rate__c + ' - ' + RateNotFound + ' - ' + MatchFound);
                                            system.debug('Final values - ' + UnitLengthNotFound + ' - ' + AirDateNotFound + ' - ' + AirTimeNotFound + ' - ' + RateNotFound);
                                            system.debug('Final values 2 - ' + UnitLengthFound + ' - ' + AirDateFound + ' - ' + AirTimeFound + ' - ' + RateFound);
                                            if (MatchFound == true)
                                            {
                                                Spot_Data__c SpotDataRecord = getSpotDataRecord(ScheduleRecord.Id, SDM);
                                                SpotDataList.add(SpotDataRecord);
                                                ContinueSDM = true;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                            if (ContinueSDM)
                            {
                                break;
                            }
                        }
                    }
                    /*if (ContinueSDM)
                    {
                        break;
                    }*/
                }
                if (NoNetworkDealNumber)
                {
                    ErrorReasonList = 'No Network Deal number';
                }
                else
                {
                    if (NetworkDealNumberNotFound)
                    {
                        ErrorReasonList = 'Network Deal number not found';
                    }
                    else
                    {
                        system.debug('Error Values - ' + UnitLengthNotFound + ' - ' + AirDateNotFound + ' - ' + AirTimeNotFound + ' - ' + RateNotFound + ' - ' + ErrorReasonList);
                        system.debug('Error Values 2 - ' + UnitLengthFound + ' - ' + AirDateFound + ' - ' + AirTimeFound + ' - ' + RateFound);
                        ErrorReasonList = '';

                        if (UnitLengthNotFound)
                        {
                            ErrorReasonList += 'Unit Length not found;';
                        }
                        if (RateNotFound)
                        {
                            ErrorReasonList += 'Rate not found;';
                        }
                        if (AirDateNotFound)
                        {
                            ErrorReasonList += 'Air Date does not match;';
                        }
                        if (AirTimeNotFound)
                        {
                            ErrorReasonList += 'Air Time does not match;';
                        }
                        if (AirTimeFound && !AirTimeNotFound)
                        {
                            ErrorReasonList += 'Air Time does not match;';
                        }
                        if (AirDateFound && !AirDateNotFound)
                        {
                            ErrorReasonList += 'Air Date does not match;';
                        }
                        if (RateFound && !RateNotFound)
                        {
                            ErrorReasonList += 'Rate not Found;';
                        }
                        if (UnitLengthFound && !UnitLengthNotFound)
                        {
                            ErrorReasonList += 'Unit Length not Found;';
                        }
                    }
                }
                system.debug('Error Values - ' + UnitLengthNotFound + ' - ' + AirDateNotFound + ' - ' + AirTimeNotFound + ' - ' + RateNotFound + ' - ' + ErrorReasonList);
                system.debug('Error Values 2 - ' + UnitLengthFound + ' - ' + AirDateFound + ' - ' + AirTimeFound + ' - ' + RateFound);
                SDM.ErrorReason__c = ErrorReasonList;
                SDM.ProcessRequired__c = false;
                SDM.Problem__c = false;
            }
            //database.insert(SpotDataList, false);
            //database.update(SpotDataMirrorList, false);
            insert SpotDataList;
            update SpotDataMirrorList;
            Set<Id> IdSet = new Set<Id>();
            for (Spot_Data__c SP : [select Id,Schedule__c, Name, SpotDataMirror_Reference__c from Spot_data__c where SpotDataMirror_Reference__c in: UniqueIdSpotDataMirrorMap.keySet()])
            {
                if (UniqueIdSpotDataMirrorMap.containsKey(SP.SpotDataMirror_Reference__c) && !IdSet.contains(UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id))
                {
                    system.debug('SP values - ' + SP.SpotDataMirror_Reference__c + ' - ' + UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id);
                    SDMlist.add(new SpotDataMirror__c(Id = UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id, Spot_Data__c = SP.Id, ErrorReason__c = null,Schedule__c = SP.Schedule__c, Problem__c = false));
                    IdSet.add(UniqueIdSpotDataMirrorMap.get(SP.SpotDataMirror_Reference__c).Id);
                }
            }
            database.update(SDMList, false);
        }
        catch(Exception ex)
        {
            Database.rollback(SavePointLine);
            //we should send an email to support with the error.
            system.debug('BATCHJOB: ' + ex.getMessage());
            system.debug('Except: ' + ex);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'matt.allen@redargyle.com', 'adrianpichardo@mvmediasales.com','faronerasheed@mvmediasales.com'};
            mail.setToAddresses(toAddresses);
            mail.setSubject('MV: Apex Spot Data Batch Job');
            mail.setPlainTextBody(
                'NOTE: The Spot Data Batch Process failed with an exception.\n\n' +
                'Message: ' + ex.getMessage() + '\n\n' +
                'Line Number: ' + ex.getLineNumber() + '\n' +
                'Stack Trace: ' + ex.getStackTraceString()
            );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }

    }
    global static Spot_Data__c getSpotDataRecord(Id scheduleId, SpotDataMirror__c rec)
    {
        Spot_Data__c spotDataRec = new Spot_Data__c();
        spotDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        spotDataRec.Schedule__c = scheduleId;
        spotDataRec.X800__c = rec.X800__c ;
        spotDataRec.Air_Date__c = rec.Air_Date__c ;
        spotDataRec.Air_Time__c = rec.Air_Time__c ;
        spotDataRec.Break_Code__c = rec.Break_Code__c ;
        spotDataRec.Commercial_Title__c = rec.Commercial_Title__c ;
        spotDataRec.House_Number__c = rec.House_Number__c ;
        spotDataRec.ISCI__c = rec.ISCI__c ;
        spotDataRec.Length__c = rec.Length__c ;
        spotDataRec.Line_Number__c = rec.Line_Number__c ;
        spotDataRec.Line_Type__c = rec.Line_Type__c ;
        spotDataRec.Market__c = rec.Market__c ;
        spotDataRec.Plot_End__c = rec.Plot_End__c ;
        spotDataRec.Plot_Start__c = rec.Plot_Start__c ;
        spotDataRec.Program_ID__c = rec.Program_ID__c ;
        spotDataRec.Raycom_Invoice_Number__c = rec.Raycom_Invoice_Number__c ;
        spotDataRec.Raycom_Order_Number__c = rec.Network_Deal_Number__c ;
        spotDataRec.Spot_Rate__c = rec.Spot_Rate__c ;
        spotDataRec.Spot_Status__c = rec.Spot_Status__c ;
        spotDataRec.Spot_Type__c = rec.Spot_Type__c ;
        spotDataRec.Status__c = rec.Status__c ;
        spotDataRec.Time_Period__c = rec.Time_Period__c ;
        SpotDataRec.SpotDataMirror__c = rec.Id;
        SpotDataRec.Error__c = rec.Error__c;
        spotDataRec.SpotDataMirror_Reference__c=scheduleId+string.valueOf(rec.Id)+Increment;
        UniqueIdSpotDataMirrorMap.put(scheduleId+string.valueOf(rec.Id)+Increment,rec);
        system.debug('map value - ' + (scheduleId+string.valueOf(rec.Id)+Increment) + ' - ' + rec.Id);
        Increment++;
        return spotDataRec;
    }
    global static integer ReturnDayNumber(String DayString)
    {
        if (DayString != null)
        {
            if (DayString == 'Mon')
            {
                return 0;
            }
            else if (DayString == 'Tue')
            {
                return 1;
            }
            else if (DayString == 'Wed')
            {
                return 2;
            }
            else if (DayString == 'Thu')
            {
                return 3;
            }
            else if (DayString == 'Fri')
            {
                return 4;
            }
            else if (DayString == 'Sat')
            {
                return 5;
            }
            else if (DayString == 'Sun')
            {
                return 6;
            }
        }
        return 0;

    }
}