public with sharing class SpotDataServices
{
    /*
    private static final String CLASSNAME = '\n\nSpotDataServices.METHODNAME()';
    
    // This is used to refer respective  SpotDataMirror__c  
    // key schedule id + SpotDataMirror name + index in trigger.new
    // value SpotDataMirror__c record
    static map<string,SpotDataMirror__c>   UniqIdWithSpDataMirror=new map<string,SpotDataMirror__c>();
    
    //Loaded ids
    static set<id> spotDataRecIds=new set<id>();
    
    static list<Id> DealIds;
    static integer Increment=0;
    //Added By Abhijeet Baneka (Cloud Sherpas) : 18/2/2013
    private static list<Id> getDealId(list<Deal__c> dealslist,SpotDataMirror__c rec){
        list<Id> validDeal = new list<Id>();
        system.debug('Testing ABHI'+dealslist);
        for(Deal__c dl: dealslist){
            if(dl.Program__r.Name != null){
                if(dl.Program__r.Name.equals(rec.Network__c)){
                    validDeal.add(dl.id);
                    
                }
            }
        }
        return validDeal;
    }
    
    public static void SpotDataMirrorOnAfterInsert(list<SpotDataMirror__c> records)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'SpotDataMirrorOnAfterInsert');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + ' with '+ records.size() +' SpotDataMirror__c records in the collection.\n\n');
        
        map<String, Id> OrderNumberToDealIdMap = new map<String, Id>();
        
        //Added By Abhijeet Baneka (Cloud Sherpas) : 18/2/2013
        map<String, list<Deal__c>> OrderNumberToDeallistMap = new map<String, list<Deal__c>>();
        set<String> OrderNumberSetNew=new set<String>();
        Set<String> OrderNumberSet = new Set<String>();
        list<Deal__c> DealsWithSchedulesList;
        map<Id, Deal__c> DealsWithSchedulesMap;
        list<Schedules__c> schedules;
        
        
        // get a Set of unique Order Numbers to use for searching for Deals
        for(SpotDataMirror__c rec:records){
            if(rec.Network_Deal_Number__c != null && rec.Network_Deal_Number__c != '')
                OrderNumberSet.add(rec.Network_Deal_Number__c);
        }
        
        
        if(!Util.ValidateSet(OrderNumberSet)){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: PROBLEM : Could not find any Orders - OrderNumberSet is NOT valid.\n\n');
        }else{
            // get Deal records (Deal__C.Network_Deal_Number__c) with their Schedule records
           OrderNumberSetNew.addall(OrderNumberSet);
            DealsWithSchedulesMap = new map<Id, Deal__c>();
            for(Deal__c deal : [SELECT Id,Program__r.Name , Name, Network_Deal_Number__c, (SELECT Id, Name, RecordTypeId, Week__c, Day__c, Units_Available__c, NFL_Daypart__c, Rate__c, ISCI_CODE__c, MGM_HD_Daypart__c, X30_Rate__c, COUNTMENOT__c, Week_Number__c, Status__c, Comments__c, Total_Time__c, Total_Dollars__c, X800_Number__c, Equiv_30__c, Spot_Count__c, Clearance__c, Day_of_Week__c, Intg_Week__c, Affidavit__c, Deal_Parent__c, DealProgram__c, DealAccount__c, DealContact__c, DealBrand__c, SS9_Titles__c, Units_Preempted__c, Units_Aired__c, TEST__c, COOL_TV_Daypart__c, UnitLength__c, Spot_Total__c, PI_Payout__c, Spot_Data_Dollars_CHECK__c, Spot_Data_Unit_CHECK__c, Long_Form__c, LF_Week__c, Time_Period__c, Barter_Package__c, DealClientCode__c, LF_Brand__c, X2Calculated_Time_Period__c, CIA__c, Intg_Date__c, Net_Total__c, Dollars_Booked__c, CALC_EQUIV_30__c, Total_Schedules__c, GM__c, Networks__c, Filler__c, Day_Restrictions__c, SS10_Titles__c, End_Time__c, Start_Time__c, Ghost_Order__c, Raycom_Make_Good__c, Product__c, Reviewed_for_Invoicing__c, SI_Number_if_Billed__c, PI__c, Equiv_30_Booked__c, Test_Impact_Event__c, SS10_Titles_Value__c, SS9_Titles_Value__c, Auto_Credited__c, LF_Daypart__c, Send_as_NEW__c, Incumbency__c, Recommended__c, Churn__c, Previous_Incumbent__c, LF_Rate_Needed__c, LF_Results__c, LF_Next_Month_Status__c, Integrates_This_Week__c, Month__c, Quarter__c, Total_Historical_Dollars__c, Year__c, PP_Revision_Comment__c, PP_Revision__c, PI_Payout_TEST__c, Integrated__c, Due_Date__c, Program_Week__c, X120s__c, X30s__c, X15s__c, Priority__c, Days_Allowed__c, Max_Per_Day__c FROM Schedules__r WHERE IsDeleted=false AND Status__c =:'Sold') FROM Deal__c WHERE Network_Deal_Number__c IN :OrderNumberSet and IsDeleted=false]){
                if(OrderNumberSet.contains(deal.Network_Deal_Number__c)){
                    // --      ISSUE ON THIS LINE 
                    if(OrderNumberSetNew.contains(deal.Network_Deal_Number__c)){           
                        OrderNumberSetNew.remove(deal.Network_Deal_Number__c);
                    }
                    DealsWithSchedulesMap.put(deal.id,deal);
                    System.debug('Deals Found matching Network deal number: ' + deal);
                }
                
            }
        
        
        }
        Boolean NoDealOrScheduleFOund = false;
        //if( DealsWithSchedulesMap==NULL ){
        
        
        if(!OrderNumberSetNew.isEmpty()){
        
        
        System.debug('DealsWithSchedulesMap.isEmptyDealsWithSchedulesMap.isEmpty');
        
            for(SpotDataMirror__c rec: records){
                if(OrderNumberSet.contains(rec.Network_Deal_Number__c)){
                 rec.Msg__c = 'Network Deal Number not found';
                 rec.Problem__c=true;
                 }
            }
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: PROBLEM : Could not find any Deals with Schedules - DealsWithSchedulesMap is NOT valid.\n\n');
        
        
        }
        
        if(!DealsWithSchedulesMap.isEmpty()){
            
            
            DealsWithSchedulesList = DealsWithSchedulesMap.values();
            
            // loop through the Deals & make a Map of Order Number to Deal Ids
            for(Deal__c deal:DealsWithSchedulesList){
                if(OrderNumberToDealIdMap.containsKey(deal.Network_Deal_Number__c) == false){
                    OrderNumberToDealIdMap.put(deal.Network_Deal_Number__c, deal.Id); 
                }
                //Added By Abhijeet Baneka (Cloud Sherpas) : 18/2/2013
                if(OrderNumberToDeallistMap.containsKey(deal.Network_Deal_Number__c)){
                    OrderNumberToDeallistMap.get(deal.Network_Deal_Number__c).add(deal);
                }else{
                    OrderNumberToDeallistMap.put(deal.Network_Deal_Number__c,new list<Deal__c>{deal});
                }
            }
        }
        if(!Util.ValidateMap(OrderNumberToDealIdMap)){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: PROBLEM : OrderNumberToDealIdMap is NOT valid.\n\n');
        }else{
            //system.debug(LoggingLevel.INFO, METHODNAME + ' :: looping through SpotDataMirror__c records now.\n\n');
            list<Spot_Data__c> SpotDataRecordsToInsert = new list<Spot_Data__c>();
            
            String msg;
            Boolean needToUpdateSpotDataMirrorRecords;
            // loop through SpotDataMirror__c records and get matching Schedule for each
            for(Integer kLoop=0;kLoop<records.size();kLoop++)
            {
                SpotDataMirror__c rec = records[kLoop];
                //msg = '';
                //rec.Msg__c = '';
                needToUpdateSpotDataMirrorRecords = false;
                
                if(OrderNumberToDealIdMap.containsKey(rec.Network_Deal_Number__c)){
                 
                
                    //Deactivated by Abhijeet Baneka(Cloud Sherpas)
                    //Id DealId = OrderNumberToDealIdMap.get(rec.Network_Deal_Number__c);
                    
                    //Added By Abhijeet Baneka (Cloud Sherpas) : 18/2/2013
                    
                    //Added By Vaibhav (Cloud Sherpas) Starts Here
                    if(OrderNumberToDeallistMap.containsKey(rec.Network_Deal_Number__c)){
                        system.debug('OrderNumberToDeallistMap ABHIJEET' + OrderNumberToDeallistMap);
                        DealIds = getDealId(OrderNumberToDeallistMap.get(rec.Network_Deal_Number__c),rec);
                    }
                    else{
                        rec.Msg__c = 'No valid network deal number found.';
                    }
                    //Added By Vaibhav (Cloud Sherpas) Ends Here
                    
                    Boolean scheduleFound = false;
                    if(!DealIds.isEmpty() && DealIds !=null){
                       
                        for(Id DealId : DealIds){
                           if(scheduleFound ){
                                //rec.Msg__c = '';
                                break;
                            }
                            if(!DealsWithSchedulesMap.containsKey(DealId)){
                                system.debug(LoggingLevel.INFO, METHODNAME + ' :: The DealsWithSchedulesMap does not contain the DealId for this Spot Data Mirror record ['+ DealId +'].\n\n');
                                /*if(rec.Msg__c == '' || rec.Msg__c == null)
                                    rec.Msg__c += 'The DealsWithSchedulesMap does not contain the DealId for Spot Data Mirror record #'+ (kLoop+1) +' ['+ DealId +']';
                                else
                                    rec.Msg__c += '; The DealsWithSchedulesMap does not contain the DealId for Spot Data Mirror record #'+ (kLoop+1) +' ['+ DealId +']';
                                *//*
                                rec.Msg__c ='Network Deal Number not found';
                                if( !needToUpdateSpotDataMirrorRecords ) needToUpdateSpotDataMirrorRecords = true;
                                    rec.Problem__c=true;
                            }else{
                                Deal__c d = DealsWithSchedulesMap.get(DealId);
                                if(d == null){
                                    
                                }else{
                                    if(d.Schedules__r != null){
                                        schedules = d.Schedules__r;
                                        //rec.Msg__c += 'Got '+ schedules.size() +' Schedules for this Deal ('+ d.Name +' / '+ d.Network_Deal_Number__c +').\n';
                                    }else{
                                        /*if(rec.Msg__c == '' || rec.Msg__c == null)
                                            rec.Msg__c += 'No Schedules for this Deal ('+ d.Name +' / '+ d.Network_Deal_Number__c +').\n\n';
                                        else
                                            rec.Msg__c += '; No Schedules for this Deal ('+ d.Name +' / '+ d.Network_Deal_Number__c +').\n\n';
                                        *//*
                                        system.debug(LoggingLevel.INFO, METHODNAME + ' :: no Schedules for this Deal ('+ d.Name +' / '+ d.Network_Deal_Number__c +').\n\n');
                                    }
                                    
                                    // need to loop through Schedules to find correct one
                                   
                                    for(Integer iLoop=0;iLoop < schedules.size();iLoop++)
                                    {
                                        Schedules__c sched = schedules[iLoop];
                                        
                                        /*if(rec.Msg__c == '' || rec.Msg__c == null)
                                            rec.Msg__c += 'Schedule # '+ (iLoop+1) +' ['+ sched.Name + ' / ' + sched.Id +'] checking....\n';
                                        else
                                            rec.Msg__c += '\n Schedule # '+ (iLoop+1) +' ['+ sched.Name + ' / ' + sched.Id +'] checking....\n';
                                        *//*
                                        ScheduleCheckResult chkres = SpotDataServices.ScheduleIsCorrectOne(sched, rec, iLoop);
                                        if( chkres.result == true ){
                                            Spot_Data__c spotDataRec = SpotDataServices.getSpotDataRecord(sched.Id, rec);
                                            SpotDataRecordsToInsert.add(spotDataRec);
                                            scheduleFound = true;
                                            //if(rec.Msg__c != '' || rec.Msg__c != null) rec.Msg__c = '';
                                            rec.Schedule__c = sched.Id;
                                            break;
                                        }else{
                                            /*if(rec.Msg__c == '' || rec.Msg__c == null)
                                                rec.Msg__c = rec.Msg__c + chkres.resultMsg + '\nSchedule # '+ (iLoop+1) +' ['+ sched.Name + ' / ' + sched.Id +'] DID NOT MATCH for this SpotDataMirror record ('+ rec.Network_Deal_Number__c +').\n\n';
                                            else
                                                rec.Msg__c = rec.Msg__c + chkres.resultMsg + '\nSchedule # '+ (iLoop+1) +' ['+ sched.Name + ' / ' + sched.Id +'] DID NOT MATCH for this SpotDataMirror record ('+ rec.Network_Deal_Number__c +').\n\n';
                                            *//*
                                            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] DID NOT MATCH for this SpotDataMirror record ('+ rec.Network_Deal_Number__c +').\n\n');
                                        }
                                    }
                                    if( !scheduleFound ){
                                        system.debug(LoggingLevel.INFO, METHODNAME + ' :: No Schedule Found!.\n\n');
                                        /*if(rec.Msg__c == '' || rec.Msg__c == null)
                                            rec.Msg__c += 'No Schedule found for this Spot Data Mirror record!';
                                        else
                                            rec.Msg__c += '; No Schedule found for this Spot Data Mirror record!';
                                        *//*
                                        rec.Msg__c ='Matching schedule not found due to length, rate or time';
                                        rec.Problem__c=true;
                                        if( !needToUpdateSpotDataMirrorRecords ) needToUpdateSpotDataMirrorRecords = true;
                                    }
                                }
                            }
                        }
                       
                        if(rec.Schedule__c == NULL){
                            rec.Problem__c = true;
                        }else{
                            rec.Problem__c = false;
                            rec.msg__c='';
                        }
                    }else{
                        
                    system.debug(LoggingLevel.INFO, METHODNAME + ' :: Deals Not Found.\n\n');system.debug(LoggingLevel.INFO, METHODNAME + ' :: Deals Not Found.\n\n');
                    //rec.Msg__c = 'No valid network deal number found.';
                    
                    //Added by Vaibhav (Cloud Sherpas) Starts Here
                        rec.Msg__c = 'No valid network found.';
                    //Added by Vaibhav (Cloud Sherpas) Ends Here    
                        
                    rec.Problem__c=true;
                    }
                }
            }
            if(!Util.ValidateList(SpotDataRecordsToInsert)){
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: NO Spot_Data__c records to insert.\n\n');
            }else{
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: There are '+ SpotDataRecordsToInsert.size() +' Spot_Data__c records to insert.\n\n');
                //try{
                    list<Database.saveResult> results = Database.insert(SpotDataRecordsToInsert, false); 

                    Integer counter = 0;
                    for (Database.SaveResult sr : results)
                    {
                        if(!sr.isSuccess()){
                            system.debug(logginglevel.info, '\n\n****** Error while updating... = '+sr.getErrors()[0]+'\n\n'); 
                            
                            for(Integer iLoop=0;iLoop<sr.getErrors().size();iLoop++){
                                Database.Error err = sr.getErrors()[iLoop];
                                system.debug(logginglevel.info,METHODNAME + ' :: Error #'+ (iLoop+1) +' Fields: ' + err.getFields());
                                system.debug(logginglevel.info,METHODNAME + ' :: Error #'+ (iLoop+1) +' Message: ' + err.getMessage());
                                system.debug(logginglevel.info,METHODNAME + ' :: Error #'+ (iLoop+1) +' Status Code: ' + err.getStatusCode());
                            }
                        }else{
                            counter+=1;
                            spotDataRecIds.add(sr.getid());
                            
                        }
                    }
                    
               /* }catch(DmlException dmle){
                    
                    system.Debug(LoggingLevel.ERROR, METHODNAME + ' :: ******************************** DML EXCEPTION BEG ********************************\n');
                    
                    for(Integer i=0; i < dmle.getNumDml(); i++){
                        system.Debug(LoggingLevel.ERROR,'\n' + dmle.getDmlMessage(i) + '\n');
                    }
                    system.Debug(LoggingLevel.ERROR, METHODNAME + ' :: ******************************** DML EXCEPTION END ********************************\n');
                    throw dmle;
                    //throw BaseApplicationException.NewException(METHODNAME, dmle.getMessage(),'A problem has occurred while trying to update Account revenue totals via batch job - please contact your Administrator to review the logs for additional details.');

                }catch(Exception ex){
                    throw ex;
                }*//*
            }
            
            if( needToUpdateSpotDataMirrorRecords ){// update records;
            }
        }
        system.debug('spotDataRecIdsspotDataRecIds==========='+spotDataRecIds);
        system.debug('UniqIdWithSpDataMirror============'+UniqIdWithSpDataMirror);
        if(!spotDataRecIds.isempty() && !UniqIdWithSpDataMirror.Isempty()){
              for(Spot_Data__c spt:[SELECT id ,SpotDataMirror_Reference__c FROM Spot_Data__c WHERE id IN :spotDataRecIds]){
                        system.debug('spt============'+spt);
                       if(UniqIdWithSpDataMirror.containsKey(spt.SpotDataMirror_Reference__c)){
                           SpotDataMirror__c sptMirr= UniqIdWithSpDataMirror.get(spt.SpotDataMirror_Reference__c);
                           sptMirr.Spot_Data__c=spt.id;
                       }
              }
        }
    }
    
    public static Spot_Data__c getSpotDataRecord(Id schedId, SpotDataMirror__c rec)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'getSpotDataRecord');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        Spot_Data__c spotDataRec = new Spot_Data__c();
        spotDataRec.Schedule__c = schedId;
        spotDataRec.X800__c = rec.X800__c ;
        spotDataRec.Air_Date__c = rec.Air_Date__c ;
        //spotDataRec.Air_Date_Time__c = rec.Air_Date_Time__c ;
        //spotDataRec.Air_Date_YYYY__c = rec.Air_Date_YYYY__c ;
        spotDataRec.Air_Time__c = rec.Air_Time__c ;
        spotDataRec.Break_Code__c = rec.Break_Code__c ;
        spotDataRec.Commercial_Title__c = rec.Commercial_Title__c ;
        spotDataRec.House_Number__c = rec.House_Number__c ;
        spotDataRec.ISCI__c = rec.ISCI__c ;
        spotDataRec.Length__c = rec.Length__c ;
        spotDataRec.Line_Number__c = rec.Line_Number__c ;
        spotDataRec.Line_Type__c = rec.Line_Type__c ;
        spotDataRec.Market__c = rec.Market__c ;
        //spotDataRec.Network__c = rec.Network__c ;
        spotDataRec.Plot_End__c = rec.Plot_End__c ;
        spotDataRec.Plot_Start__c = rec.Plot_Start__c ;
        spotDataRec.Program_ID__c = rec.Program_ID__c ;
        spotDataRec.Raycom_Invoice_Number__c = rec.Raycom_Invoice_Number__c ;
        spotDataRec.Raycom_Order_Number__c = rec.Network_Deal_Number__c ;
        //spotDataRec.Spot_Equiv_30__c = rec.Spot_Equiv_30__c ;
        spotDataRec.Spot_Rate__c = rec.Spot_Rate__c ;
        spotDataRec.Spot_Status__c = rec.Spot_Status__c ;
        spotDataRec.Spot_Type__c = rec.Spot_Type__c ;
        spotDataRec.Status__c = rec.Status__c ;
        spotDataRec.Time_Period__c = rec.Time_Period__c ;
        //spotDataRec.Credit__c = rec.Credit__c;
        spotDataRec.SpotDataMirror_Reference__c=schedId+rec.name+Increment;
        UniqIdWithSpDataMirror.put(schedId+rec.name+Increment,rec);
        Increment++;
        system.debug('UniqIdWithSpDataMirrorUniqIdWithSpDataMirror'+UniqIdWithSpDataMirror);
          system.debug('IncrementIncrement'+Increment);
        return spotDataRec;
    }
    class ScheduleCheckResult{
        Boolean result{get;set;}
        String resultMsg{get;set;}
        
        public ScheduleCheckResult(){
            
        }
    }
    private static ScheduleCheckResult ScheduleIsCorrectOne(Schedules__c sched, SpotDataMirror__c rec, Integer num)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'ScheduleIsCorrectOne');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        Boolean scheduleFound = true;
        String s = '';
        system.debug(LoggingLevel.INFO, '**** ' + METHODNAME + ' :: Schedule #'+ num +' Week__c is '+ sched.Week__c +'.\nSchedule\'s Days_Allowed__c is '+ sched.Days_Allowed__c +'.\nSchedule\'s Start_Time__c is '+ sched.Start_Time__c +'.\nSchedule\'s End_Time__c is '+ sched.End_Time__c +'.\nSchedule\'s UnitLength__c (Air Length) is '+ sched.UnitLength__c +'.\nSpotDataMirror\'s Air_Date__c is '+ rec.Air_Date__c +'.\nSpotDataMirror\'s Length__c is '+ rec.Length__c +'.\nSpotDataMirror\'s Break_Code__c is '+ rec.Break_Code__c +'.\nSpotDataMirror\'s Time_Period__c is '+ rec.Time_Period__c +'.\nSpotDataMirror\'s Air_Time__c is '+ rec.Air_Time__c +'.\n\n');

        ScheduleCheckResult AirLengthResult = SpotDataServices.AirLengthIsOK(sched, rec);
        if( AirLengthResult.result==false ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule #'+ num +' ['+ sched.Id +'] FAILS due to Air Length\n\n');
            //return false;
            res.result = AirLengthResult.result;
            res.resultMsg = AirLengthResult.resultMsg;
            return res;
        }else{
            s += 'Schedule ['+ sched.Id +'] is OK for Air Length\n';
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] is OK with Air Length\n\n');
            }
        
        ScheduleCheckResult AirDateResult = SpotDataServices.AirDateIsOK(sched, rec);
        if( AirDateResult.result==false ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule #'+ num +' ['+ sched.Name + ' / ' + sched.Id +'] FAILS due to Air Date\n\n');
            //return false;
            res.result = AirDateResult.result;
            res.resultMsg = s + AirDateResult.resultMsg;
            return res;
        }else{
            s += 'Schedule ['+ sched.Id +'] is OK for Air Date\n';
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] is OK with Air Date\n\n');
            }
        
        ScheduleCheckResult AirTimeResult = SpotDataServices.AirTimeIsOK(sched, rec);
        if( AirTimeResult.result==false ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule #'+ num +' ['+ sched.Name + ' / ' + sched.Id +'] FAILS due to Air Time\n\n');
            //return false;
            res.result = AirTimeResult.result;
            res.resultMsg = s + AirTimeResult.resultMsg;
            return res;
        }else{
            s += 'Schedule ['+ sched.Id +'] is OK for Air Time\n';
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] is OK with Air Time\n\n');
            }
        
        ScheduleCheckResult RateResult = SpotDataServices.RateIsOK(sched, rec);
        if( RateResult.result==false ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule #'+ num +' ['+ sched.Name + ' / ' + sched.Id +'] FAILS due to Rate\n\n');
            //return false;
            res.result = RateResult.result;
            res.resultMsg = s + RateResult.resultMsg;
            return res;
        }else{
            s += 'Schedule ['+ sched.Id +'] is OK for Rate\n';
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] is OK with Rate\n\n');
            }
        
        //return scheduleFound;
        res.result = scheduleFound;
        res.resultMsg = s + 'Schedule #'+ num +' ['+ sched.Name + ' / ' + sched.Id +'] is a MATCH.';
        return res;
    }
    
    private static ScheduleCheckResult AirLengthIsOK(Schedules__c sched, SpotDataMirror__c rec)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'AirLengthIsOK');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        Boolean OK = true;
        SpotDataServices.ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        if(sched.UnitLength__c == null){
            res.result = false;
            res.resultMsg = 'The Schedule Air Length (UnitLength__c) is NULL.';
            return res;
        }
        if(rec.Length__c == null){
            res.result = false;
            res.resultMsg = 'The record Air Length (Length__c) is NULL.';
            return res;
        }
        if(Decimal.valueof(rec.Length__c) == null){
            res.result = false;
            res.resultMsg = 'The Decimal.valueof() for record Air Length (Length__c) is NULL.';
            return res;
        }
        if( sched.UnitLength__c != Decimal.valueof(rec.Length__c) ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Length DOES NOT MATCH.\n\n');
            //return false;
            res.result = false;
            res.resultMsg = 'Air Length  ('+ Decimal.valueof(rec.Length__c) +') DOES NOT MATCH Schedule Air Length ('+ sched.UnitLength__c +').';
            return res;
        }
        //return OK;        
        res.result = OK;
        res.resultMsg = '';
        return res;
    }
    
    private static ScheduleCheckResult RateIsOK(Schedules__c sched, SpotDataMirror__c rec)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'RateIsOK');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        Boolean OK = true;
        ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        if( rec.Spot_Rate__c != sched.Rate__c){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Rate DOES NOT MATCH Schedule Rate.\n\n');
            //return false;
            res.result = false;
            res.resultMsg = 'Rate ('+ rec.Spot_Rate__c +') DOES NOT MATCH Schedule Rate ('+ sched.Rate__c +').';
            return res;
        }
        //return OK;        
        res.result = OK;
        res.resultMsg = '';
        return res;
    }
    
    private static Boolean DateIsInWeekRange(Date schedWeek, Date recAirDate)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'DateIsInWeekRange');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + ' with Sched Week value of '+ schedWeek +' and Air Date value of '+ recAirDate +' \n\n');
        Boolean boo = false;
        ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        Date startOfBroadcastWeek = schedWeek;
        Date endOfBroadcastWeek = startOfBroadcastWeek.addDays(6);
        system.debug(LoggingLevel.INFO, METHODNAME + '...\nstart of Schedule\'s broadcast week is: '+ startOfBroadcastWeek +'\nend of Schedule\'s broadcast week is: '+ endOfBroadcastWeek +'\nAir Date is: '+ recAirDate +'\n\n');
        if( recAirDate.isSameDay(startOfBroadcastWeek) ) return true;
        if( recAirDate.isSameDay(endOfBroadcastWeek) ) return true;
        if( (recAirDate > startOfBroadcastWeek) && (recAirDate < endOfBroadcastWeek) ){
            boo = true;
        }
        return boo;
    }

    private static ScheduleCheckResult AirDateIsOK(Schedules__c sched, SpotDataMirror__c rec)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'AirDateIsOK');
        system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        Boolean OK = true;
        ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();

        // The Week__c is always the Monday of the broadcast week.  Any spot that has an air date from that Mon-Sun can belong to the schedule
        if( SpotDataServices.DateIsInWeekRange(sched.Week__c, rec.Air_Date__c) == false ){
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Date DOES NOT fall with Broadcast Week.\n\n');
            //return false;
            res.result = false;
            res.resultMsg = 'Air Date ('+ rec.Air_Date__c +') DOES NOT fall with Broadcast Week ('+ sched.Week__c +').';
            return res;
        }
        else{
            // now check Days Allowed
            String airDate = DayAbbrev(rec.Air_Date__c); // ex: 'Mon', 'Tue', etc.
            if( sched.Days_Allowed__c == null ){ 
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Date check fails due to NULL Days Allowed on Schedule.\n\n');
                //return false;
                res.result = false;
                res.resultMsg = 'Air Date check fails due to NULL Days Allowed on Schedule.';
                return res;
            }else{
                if( !sched.Days_Allowed__c.contains(airDate) ){
                    //return false;
                    res.result = false;
                    res.resultMsg = 'The Days Allowed on the Schedule ('+ sched.Days_Allowed__c +') DOES NOT contain the Air Date ('+ airDate +').';
                    return res;
                }
            }
        }
        res.result = OK;
        res.resultMsg = '';
        return res;
    }

    private static ScheduleCheckResult AirTimeIsOK(Schedules__c sched, SpotDataMirror__c rec)
    {
        String METHODNAME = CLASSNAME.replace('METHODNAME', 'AirTimeIsOK');
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n', '\n\n Inside ') + '\n\n');
        Boolean OK = true;
        ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        Boolean ignoreCableDayparts = false;

        Datetime allowedAirDateStartTime;
        Datetime allowedAirDateEndTime;
        Datetime actualAirDateTime;

        Integer hour;
        Integer minute;
        Integer second;
        Integer day;

        system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Time BEFORE is: '+ rec.Air_Time__c.trim() +'\n\n');
        
        String recordAirTime = rec.Air_Time__c.trim().replace(' ','').replace('PM','').replace('AM','').replace('pm','').replace('am',''); // ex: 10:59:49 AM or 3:39:06 PM     
        String[] parts = recordAirTime.split(':');
        
        //EDITED BY: Abhijeet Baneka(Cloud Sherpas) - 14/2/2013
        hour = Integer.valueof(parts[0]);
        // determine if 12 hours should be added or not
        //Boolean add12 = false;
        day = rec.Air_Date__c.day();
        if(rec.Air_Time__c.trim().contains('PM') || rec.Air_Time__c.trim().contains('pm') || rec.Air_Time__c.trim().contains('P') || rec.Air_Time__c.trim().contains('p')) {
            
            if(hour != 12 ){
                hour += 12;
            }

        }else if(rec.Air_Time__c.trim().contains('AM') || rec.Air_Time__c.trim().contains('am') || rec.Air_Time__c.trim().contains('A') || rec.Air_Time__c.trim().contains('a')){
             if(hour == 12 || hour == 1 || hour == 2 || hour == 3 || hour == 4 || hour == 5){
                    day = day + 1;
             }
             
             //This is to consider that 12 AM == 00 in newinstance method used for date time.
             if(hour == 12){
                    hour = hour - 12;
             }
        }
        
        if(parts.size() != 3){
            
        }else{
           hour = ( hour-5 ); // IMPORTANT - for EST offset
           minute = Integer.valueof(parts[1]);
           second = Integer.valueof(parts[2]);
            
        }
        actualAirDateTime = Datetime.newInstance(rec.Air_Date__c.year(), rec.Air_Date__c.month(), day, hour, minute, second);
        system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Time AFTER is: '+ actualAirDateTime +'\n\n');
        
        // Instructions From Client: These are two fields.  If they are filled in, these start end times override the daypart time.
        // If they are blank, then the start end times should be the daypart times.
        // ex: 09:00A and 07:00P
        if( (sched.Start_Time__c != null && sched.End_Time__c != null) && (sched.Start_Time__c != '' && sched.End_Time__c != '') )
            ignoreCableDayparts = true;
        
        String dp = sched.MGM_HD_Daypart__c; // Cable Dayparts
        if(ignoreCableDayparts)
        {
            String startTm = sched.Start_Time__c.trim().replace(' ','');// ex: 09:00A and 07:00P
            String endTm = sched.End_Time__c.trim().replace(' ','');// ex: 09:00A and 07:00P
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: Schedule ['+ sched.Name + ' / ' + sched.Id +'] start time = '+ startTm +' and end time = '+ endTm +'\n\n');
            
            //system.debug(LoggingLevel.INFO, METHODNAME + ' :: startTm = '+ startTm +'\n\n');
            String a;
            String b;
            String c = startTm.Right(1);
            second = 0;
            //system.debug(LoggingLevel.INFO, METHODNAME + ' :: c = '+ c.ToUpperCase() +'\n\n');
            if( c.ToUpperCase() == 'A'){
                a =     startTm.substring(0,2).removeStart('0');
                b =     startTm.substring(3,5).removeStart('0');
                //system.debug(LoggingLevel.INFO, METHODNAME + ' :: a = '+ a +'\n\n');
                //system.debug(LoggingLevel.INFO, METHODNAME + ' :: b = '+ b +'\n\n');
                day = rec.Air_Date__c.day();
                hour = Integer.valueOf(a);
                if(hour == 12 || hour == 1 || hour == 2 || hour == 3 || hour == 4 || hour == 5){
                    day = day + 1;
                }
                if(hour == 12){
                    hour = hour - 12;
                }
                hour = ( hour-5 ); // IMPORTANT - for EST offset
                minute = Integer.valueOf(b);
                
            }else if ( c.ToUpperCase() == 'P'){
                a =     startTm.substring(0,2).removeStart('0');
                b =     startTm.substring(3,5).removeStart('0');
                //system.debug(LoggingLevel.INFO, METHODNAME + ' :: a = '+ a +'\n\n');
                //system.debug(LoggingLevel.INFO, METHODNAME + ' :: b = '+ b +'\n\n');
                day = rec.Air_Date__c.day();
                hour = Integer.valueOf(a);
                
                //EDITED BY: Abhijeet Baneka(Cloud Sherpas) - 14/2/2013
                if(hour != 12){
                    hour +=12;
                }
                
                hour = ( hour-5 ); // IMPORTANT - for EST offset
                minute = Integer.valueOf(b);
            }
            
            allowedAirDateStartTime = Datetime.newInstance(rec.Air_Date__c.year(), rec.Air_Date__c.month(), day, hour, minute, second);
            
            
            c = endTm.Right(1);
            if( c.ToUpperCase() == 'A'){
                a =     endTm.substring(0,2).removeStart('0');
                b =     endTm.substring(3,5).removeStart('0');
                
                // if End time is 12:00A it is "really" the next day, so going to subtract one (1) second to make it 23:59:59

                hour = Integer.valueOf(a);
                day = rec.Air_Date__c.day();
                if(hour == 12 || hour == 1 || hour == 2 || hour == 3 || hour == 4 || hour == 5 || hour == 6){
                    day = day + 1;
                    if(hour == 6){
                        hour = 5; 
                        b = '59';
                        second = 59;
                    }
                }
                if(hour == 12){
                    hour = hour - 12;
                }
                hour = ( hour-5 ); // IMPORTANT - for EST offset
                minute = Integer.valueOf(b);
            }else if ( c.ToUpperCase() == 'P'){
                a =     endTm.substring(0,2).removeStart('0');
                b =     endTm.substring(3,5).removeStart('0');
                hour = Integer.valueOf(a);
                day = rec.Air_Date__c.day();
                //EDITED BY: Abhijeet Baneka(Cloud Sherpas) - 14/2/2013
                if(hour != 12 ){
                    hour +=12;
                }
                
                hour = ( hour-5 ); // IMPORTANT - for EST offset
                minute = Integer.valueOf(b);
            }
            allowedAirDateEndTime = Datetime.newInstance(rec.Air_Date__c.year(), rec.Air_Date__c.month(), day, hour, minute, second);
            
            system.debug(LoggingLevel.INFO, METHODNAME + ' :: allowed AirDate Start Time is: '+ allowedAirDateStartTime +'; allowed AirDate End Time is: '+ allowedAirDateEndTime +'; actual AirDate Time is: '+ actualAirDateTime +'\n\n');
            Boolean actualVersusAllowedStartIsOK = (actualAirDateTime >= allowedAirDateStartTime);
            Boolean actualVersusAllowedEndIsOK = (actualAirDateTime <= allowedAirDateEndTime);
            if( (actualVersusAllowedStartIsOK == false) || (actualVersusAllowedEndIsOK == false) ){
                if( !actualVersusAllowedStartIsOK ){
                    if(res.resultMsg != null)
                    res.resultMsg += 'The actual Air Date Time ('+ actualAirDateTime +') IS NOT >= the END time '+ allowedAirDateEndTime +').';
                    else
                    res.resultMsg = 'The actual Air Date Time ('+ actualAirDateTime +') IS NOT >= the END time '+ allowedAirDateEndTime +').';
                }
                if( !actualVersusAllowedEndIsOK ){
                    if(res.resultMsg != null)
                    res.resultMsg += 'The actual Air Date Time ('+ actualAirDateTime +') IS NOT <= the END time '+ allowedAirDateEndTime +').';
                    else
                    res.resultMsg = 'The actual Air Date Time ('+ actualAirDateTime +') IS NOT <= the END time '+ allowedAirDateEndTime +').';
                }
                system.debug(LoggingLevel.INFO, METHODNAME + ' :: Air Date Time DOES NOT fall with allowable time frame.\n\n');
                res.result = false;
                res.resultMsg += '\nThe actual Air Date Time ('+ actualAirDateTime +') DOES NOT fall with allowable time frame (START = '+ allowedAirDateStartTime +'  and  END = '+ allowedAirDateEndTime +').';
                return res;
            }
        }
        res.result = OK;
        res.resultMsg = '';
        return res;
    }
    
    private static String DayAbbrev(Date d) {
        Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day());
        return (dt.format('EEEE')).substring(0,3); //returns Sunday or Monday or .. 
    }
    
    testmethod private static void test_DayAbbrev(){
        system.assert(SpotDataServices.DayAbbrev(date.parse('1/25/2013')) == 'Fri');
    }
    testmethod private static void test_DateIsInWeekRange(){
        system.assert(SpotDataServices.DateIsInWeekRange(date.parse('12/31/2012'), date.parse('1/8/2013')) == false);
    }
    testmethod private static void test_InnerClass(){
        SpotDataServices.ScheduleCheckResult res = new SpotDataServices.ScheduleCheckResult();
        res.result = true;
        res.resultMsg = 'TEST';
        system.assert(res.result);
        system.assert(res.resultMsg == 'TEST');
    }
    testmethod private static void coverclass(){
        test.starttest();
        Programs__c prg = new Programs__c(Name = 'test', ClientCode__c = '14');
        insert prg; 
        Account act = new Account (name='test Act');
        insert act;
        Contact con = new Contact(LastName='TestCon',AccountId=act.id);
        insert con; 

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;

        Deal__c deal= new Deal__c(Length__c='60',Program__c = prg.id, Contact__c = con.id,Network_Deal_Number__c ='1420', Brands__c = brand.Id);
        insert deal;
        
        list<Schedules__c> schlist = new list<Schedules__c>();
        for(Integer i = 0 ; i<10; i++){
            Schedules__c sch = new Schedules__c(Deal_Parent__c=deal.id, Units_Available__c=1, Rate__c= 60+i,Start_Time__c='11:00A',End_Time__c='12:00A',Week__c=date.newinstance(2013, 1, 14));
            schlist.add(sch); 
        }
        insert schlist;
        SpotDataMirror__c sdm = new SpotDataMirror__c(Name = 'test', Air_Date__c = date.newinstance(2013, 1, 12), Air_Time__c = '12:27:25 PM', Length__c = '60', Network_Deal_Number__C = '1420', SPOT_RATE__C = 60, NETWORK__C = 'Tennis Channel');
        insert sdm ;
        test.stoptest();
    }
    */
}