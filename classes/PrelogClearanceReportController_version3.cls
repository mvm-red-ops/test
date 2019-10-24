/** 
*  Purpose         :   Controller class for PrelogClearanceReport
*  
*  Created By      :   Sanjay Ramchandani
*  
*  Created Date    :   --
*  
*  Revision Logs   :   V_1.0 - Created
V_1.1 - Modified for new changes 1/31/2016
* 
MG cloned this CTRLR as a 'version2' from the orig May 16 2016
MG Reload into refreshed Sandbox 8-15-16
* 
**/
public class PrelogClearanceReportController_version3 {
    
    public List<string> testlist;
    public set<string> testset;
    public List<List<SObject>> DealSearchList;
    public List<PrelogClearanceReportHelper.WeekModel> quarterweek {get;set;}
    public List<PrelogClearanceReportHelper.HeadingModel> headingModels {get;set;}
    public list<date> quarterdates {get;set;}
    private transient List<Deal__c> DealResultList {get;set;}
    
    
    public transient List<PrelogClearanceReportHelper.DealWrapper> DealWrapperList {Get;set;}
    //MG created to track Deal string IDs, and associated data in the class
    public map<string,PrelogClearanceReportHelper.DealWrapper> DealWrapperMap {Get;set;}
    public Set<Id> DealWrapperIdSet {Get;set;}
    public List<string> SearchList;
    public string Searchfield {get;set;}
    public string DealId {get;set;}
    public String cellrate {get;set;}
    public string cellUnits {Get;set;}
    public String CellId {get;set;}
    public string DealName {get;set;}
    public Decimal RateforCell {get;set;}
    public String SaveDescision {get;set;}
    public boolean selectAll {get;set;}
    public Date anchordate;
    public date startdate;
    public date enddate;
    public boolean schedulemessage {get;set;}
    public boolean showtable {get;set;}
    public Deal__c SelectedDeal {get;set;}
    public Map<string, Deal__c> SelectedDealMap {get;set;}
    public Date LowestDate {get;set;}
    public Date HighestDate {get;set;}
    public Date QuarterEndDate {get;set;}
    public string SelectedExtensionDate {get;set;}
    public string SelectedOrderLineNumber {get;set;}
    public string SelectedFiller {Get;set;}
    public string RemoveDealId {get;set;}
    public string SelectedDealSet {Get;set;}
    public Boolean BarterCheckbox {get;set;}
    public String SelectedCableSynd {get;set;}
    public List<SelectOption> CableSyndSOList {Get;set;}
    public string currentVersion {get;set;} 
    public Schedules__c WeekStartDate {get;set;}
    public Schedules__c WeekEndDate {Get;set;}
    public List<SelectOption> DateLiteralSOList {Get;set;}
    public String SelectedDateLiteral {Get;set;}
    public string SOQLDateString {get;set;}
    public boolean dealSelectionOperation{get;set;}
    public map<string,string> VersionMap {get;set;}
    //Map to hold day of month with month name
    public Map<Integer, String> mapDayOfMonthWithName;
    
    //Added by Sanjay on 2/15/2016
    public Brands__c brand {get; set;}
    
    //Added by Sanjay on 2/18/2016
    public String prelogVersion {get; set;}
    
    //Added by Sanjay on 2/1/2016
    public Schedules__c tempSchedule {get; set;}
    
    public Map<String, FiscalYearSettings> FiscalMap = new Map<String, FiscalYearSettings>();
    public FiscalYearSettings CurrentFY;
    public Period CurrentFP;
    public Period CurrentFW;
    public Period CurrentFM;
    public transient Map<String, Map<Integer, Period>> QuarterPeriodMapTemp  ;
    public transient Map<String, Map<Integer, Period>> WeekPeriodMapTemp  ;
    public transient Map<String, Map<Integer, Period>> MonthPeriodMapTemp  ;
    
    public Map<String, Map<Integer, Period>> MonthPeriodMap{
        get {
            if(MonthPeriodMapTemp==null){
                    MonthPeriodMapTemp = new Map<String, Map<Integer, Period>>();
                    for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month']) {
                    if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today()) {
                        CurrentFM = PR;
                        system.debug('CurrentFM - ' + CurrentFM.StartDate + ' - ' + CurrentFM.EndDate);
                    }
                    if (MonthPeriodMapTemp.containsKey(PR.FiscalYearSEttings.Name)) {
                        Map<Integer, Period> TempQuarterPeriodMap = MonthPeriodMapTemp.get(PR.FiscalYearSettings.Name);
                        if (PR.Number == null) {
                            TempQuarterPeriodMap.put(PrelogClearanceReportHelper.ReturnNumber(PR.PeriodLabel), PR);
                        }
                        else {
                            TempQuarterPeriodMap.put(PR.Number, PR);
                        }
                        MonthPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                    }
                    else {
                        Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                        if (PR.Number == null) {
                            TempQuarterPeriodMap.put(PrelogClearanceReportHelper.ReturnNumber(PR.PeriodLabel), PR);
                        }
                        else {
                            TempQuarterPeriodMap.put(PR.Number, PR);
                        }
                        MonthPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                    }
                }
            }
            return MonthPeriodMapTemp;
        }
    }
    
    public Map<String, Map<Integer, Period>> WeekPeriodMap{
        get {
            if(WeekPeriodMapTemp==null){
                    WeekPeriodMapTemp = new Map<String, Map<Integer, Period>>();
                    for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Week']) {
                        if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today())
                        {
                            CurrentFW = PR;
                            system.debug('CurrentFW - ' + CurrentFW.StartDate + ' - ' + CurrentFW.EndDate);
                        }
                        if (WeekPeriodMapTemp.containsKey(PR.FiscalYearSEttings.Name))
                        {
                            Map<Integer, Period> TempQuarterPeriodMap = WeekPeriodMapTemp.get(PR.FiscalYearSettings.Name);
                            TempQuarterPeriodMap.put(PR.Number, PR);
                            WeekPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                        }
                        else
                        {
                            Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                            TempQuarterPeriodMap.put(PR.Number, PR);
                            WeekPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                        }
                    }
            }
            return WeekPeriodMapTemp;
        }
    }
    
    public Map<String, Map<Integer, Period>> QuarterPeriodMap{
        get {
            if(QuarterPeriodMapTemp==null){
                    QuarterPeriodMapTemp = new Map<String, Map<Integer, Period>>();
                    for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Quarter']){
                        if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today())
                        {
                            CurrentFP = PR;
                            system.debug('CurrentFP - ' + CurrentFP.StartDate + ' - ' + CurrentFP.EndDate);
                        }
                        if (QuarterPeriodMapTemp.containsKey(PR.FiscalYearSEttings.Name))
                        {
                            Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMapTemp.get(PR.FiscalYearSettings.Name);
                            TempQuarterPeriodMap.put(PR.Number, PR);
                            QuarterPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                        }
                        else
                        {
                            Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
                            TempQuarterPeriodMap.put(PR.Number, PR);
                            QuarterPeriodMapTemp.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
                        }
                    }
            }
            return QuarterPeriodMapTemp;
        }
    }
    
    
    
    public List<Deal__c> getDealResult() {
        if(Searchfield !=null && Searchfield !='')
            FillDealResultList();
        return DealResultList ;
    }
    
    // MG for vForce Page rendering Weeks being Searched Monday-compiled
    public string weekEntries {get; set;}
    public Date thisMonday {
        get {
            if(thisMonday == null) {
                thisMonday = this.getMonday() ;
            }
            return thisMonday ;
        } 
        set;
    }
    
    public Date thisSunday {
        get {
            if(thisSunday == null) {
                thisSunday = this.getSunday() ;
            }
            return thisSunday ;
        } 
        set;
    }
    // MG  for CTRLR preparing the Set of Weeks being passed
    public set<string> weekSet {get; set;}
    
    public PrelogClearanceReportController_version3 ()
    { 
        // MG  initialize variables on Page Load  108-109
        weekSet = new set<string>();
        currentVersion ='';
        VersionMap = new map<string,string>();
        weekEntries ='';
        SaveDescision   ='';
        selectAll = false;
        if(DealWrapperList ==null) DealWrapperList = new List<PrelogClearanceReportHelper.DealWrapper>();
        // MG  for Initialization
        DealWrapperMap = new map<string,PrelogClearanceReportHelper.DealWrapper>();
        DealWrapperIdSet = new Set<Id>();
        SelectedDealSet = '';
        SelectedDealMap = new Map<string, Deal__c>() ;
        CableSyndSOList = new List<SelectOption>();
        CableSyndSOList.add(new SelectOption('','Please Select'));
        CableSyndSOList.add(new SelectOption('Cable','Cable'));
        CableSyndSOList.add(new SelectOption('Syndication','Syndication'));
        CableSyndSOList.add(new SelectOption('PP','PP'));
        SelectedCableSynd = '';
        WeekStartDate = new Schedules__c();
        WeekEndDate = new Schedules__c();
        DateLiteralSOList = PrelogClearanceReportHelper.ReturnDateLiteralSOList();
        
        //Initialization (By Sanjay)
        tempSchedule = new Schedules__c();
        
        brand = new Brands__c();
        prelogVersion = '';
        
        //Populate the map
        mapDayOfMonthWithName = new Map<Integer, String>();
        mapDayOfMonthWithName.put(1, 'Jan');
        mapDayOfMonthWithName.put(2, 'Feb');
        mapDayOfMonthWithName.put(3, 'Mar');
        mapDayOfMonthWithName.put(4, 'Apr');
        mapDayOfMonthWithName.put(5, 'May');
        mapDayOfMonthWithName.put(6, 'Jun');
        mapDayOfMonthWithName.put(7, 'Jul');
        mapDayOfMonthWithName.put(8, 'Aug');
        mapDayOfMonthWithName.put(9, 'Sep');
        mapDayOfMonthWithName.put(10, 'Oct');
        mapDayOfMonthWithName.put(11, 'Nov');
        mapDayOfMonthWithName.put(12, 'Dec');
        
        //Set current week in the week
        tempSchedule.Week__c = Date.today().toStartofWeek().addDays(1);
        
        for (FiscalYearSettings FYS : [select Id, Name, StartDate, EndDate from FiscalYearSettings])
        {
            FiscalMap.put(FYS.Name, FYS);
            system.debug('CurrentFY Compare - ' + FYS.StartDate + ' - ' + FYS.EndDate + ' - ' + Date.Today() + ' - ' + (FYS.StartDate <= Date.Today() && FYS.EndDate >= Date.Today()));
            if (FYS.StartDate <= Date.Today() && FYS.EndDate >= Date.Today())
            {
                CurrentFY = FYS;
                system.debug('CurrentFY - ' + CurrentFY.StartDate + ' - ' + CurrentFY.EndDate);
            }
        }
        
        
        
        
        
        
    }
    
    public period getCurrentQuoter(date inputDate){
        integer no=(inputdate.month()/4)+1;
        Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(string.valueOf(inputdate.year()));
        return TempQuarterPeriodMap.get(no);
        
        return null;
    }
    
    
    public void DoSearch()
    {
        try
        {
            DealResultList = new List<Deal__c>();
            currentVersion ='';
            VersionMap = new map<string,string>();
            // MG added for purpose of making Week/Dates unSelected when subsequent Week/Date is Selected
            //DealWrapperIdSet = new Set<Id>();
            //ClearAllButton();
            //DealWrapperList = new List<DealWrapper>();
            //DealWrapperIdSet = new Set<Id>();
            
            //New Changes added by Sanjay - 2/2/2016
            //DealWrapperList = new List<DealWrapper>();
            //DealWrapperIdSet = new Set<Id>();
            // MG added for purpose of making Week/Dates unSelected when subsequent Week/Date is Selected
            SelectedDealSet='';
            SearchList = new List<string>();
            map<id,Deal__c> MapofFinalDeals = new map<id,Deal__c>();
            Map<Integer,set<id>> Accurancy = new Map<Integer, set<id>>();
            
            
            dealSelectionOperation=false;
            ReturnSOQLDateString();
            if(Searchfield != null && Searchfield  !='')
            {
                //searchField = SearchField.replace(' , ',',').replace(' ,',',').replace(', ',',');
                while (searchField.contains(' , '))
                {
                    SearchField = SearchField.replace(' , ',',');
                }
                while (SearchField.contains(' ,'))
                {
                    SearchField = SearchField.replace(' ,',',');
                }
                while (SearchField.contains(', '))
                {
                    SearchField = SearchField.replace(', ',',');
                }
                string tempSearch = '%'+Searchfield +'%';
                SearchList = Searchfield.split(',');
                Accurancy.put( 1 ,new Set<id>{} );
                if (SearchList.size() > 1)
                {
                    for(String stringListLoop : SearchList)
                    {
                        while(stringListLoop.startsWith(' ') || stringListLoop.endsWith(' '))
                        {
                            if (StringListLoop.startsWith(' '))
                            {
                                StringListLoop = StringListLoop.substringAfter(' ');
                            }
                            if (StringListLoop.endsWith(' '))
                            {
                                StringListLoop = StringListLoop.substringBeforeLast(' ');
                            }
                        }
                        string tempstringListLoop = '%'+stringListLoop+'%';
                        set<Deal__c> tempDealList = new set<Deal__c>();
                        period pr=getCurrentQuoter(tempSchedule.Week__c);
                        date start_date=pr.startDate;
                    date end_date=pr.EndDate;
                        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,' 
                            + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                            + 'Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') '
                            + ' From Deal__c '
                            + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                            + ' OR Brands__r.Advertiser__r.Name Like \'' + tempstringListLoop + '\''
                            + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null   And Week_MIN_Field__c<=:end_date And Week_MIN_Field__c>=:start_date  '
                            + SOQLDateString;
                        if (BarterCheckbox)
                        {
                            DealQuery += ' AND Program__r.Barter__c = True ';
                        }                       
                        if (SelectedCableSynd != '' && SelectedCableSynd != null)
                        {
                            DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                        }
                        
                        //Added by Sanjay 2/15/2016
                        //if(brand.Advertiser__c != null)
                        //DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                        
                        //Add Order by clause
                        DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 9000';
                        System.debug('***end_date - ' + end_date );
                    System.debug('***start_date - ' + start_date );
                        System.debug('***DealQuery - ' + DealQuery);
                        List<Deal__c> DealList = Database.query(DealQuery);
                        for(Deal__c dlist : DealList )
                        {
                            DealResultList.add(dlist);
                            system.debug('tempStringListLoop - ' + tempStringListLoop + ' - ' + dlist.Name + ' - ' + dlist.Program__r.Name + ' - ' + dlist.Contact__r.Name + ' - ' + dlist.Client_Account__r.Name + ' - ' + dlist.Brands__r.Name);
                            boolean NotInList = false;
                            MapofFinalDeals.put( dlist.id , dlist);
                            for(integer i = Accurancy.size(); i>0; i--)
                            {
                                If(Accurancy.get(i).contains(dlist.id))
                                {
                                    NotInList = true;
                                    if(Accurancy.containskey(i+1))
                                    {
                                        set<id> dealset1 = accurancy.get(i+1);
                                        dealset1.add(dlist.id);
                                        Accurancy.put(i+1, dealset1); 
                                    }
                                    else
                                    {
                                        set<id> dealset1 = new Set<id>();
                                        dealset1.add(dlist.id);
                                        Accurancy.put(i+1, dealset1);     
                                    }
                                    Accurancy.get(i).remove(dlist.id);
                                }
                            } 
                            if(NotinList == false)
                            {
                                set<id> dealset1 = accurancy.get(1);
                                dealset1.add(dlist.id);
                                Accurancy.put(1, dealset1);     
                            }
                        } 
                    }
                    for (integer Count : Accurancy.keySet())
                    {
                        system.debug('Accurancy Count - ' + Count + ' - ' + Accurancy.get(Count));
                    }   
                    integer count=0;
                    
                    if (Accurancy.containsKey(SearchList.size()))
                    {
                        for(Id MapofDeals : Accurancy.get(SearchList.size()))
                        {
                            if (Count < 200)
                            {
                                DealResultList.add(MapofFinalDeals.get(mapofdeals));
                                Count++;
                            }       
                        }  
                    }   
                }
                else
                {
                    string tempstringListLoop = '%'+SearchList[0] +'%';
                    period pr=getCurrentQuoter(tempSchedule.Week__c);
                        date start_date=pr.startDate;
                    date end_date=pr.EndDate;
                    String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                        + ' Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                        + ' Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') ' 
                        + ' From Deal__c '
                        + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\'' 
                        + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\'' 
                        + ' OR Brands__r.Advertiser__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Name Like \'' + tempstringListLoop + '\' )  AND Week_MIN_Field__c != null And Week_MIN_Field__c<=:end_date And Week_MIN_Field__c>=:start_date  '
                        + SOQLDateString;
                    if (BarterCheckbox)
                    {
                        DealQuery += ' AND Program__r.Barter__c = True ';
                    }                       
                    if (SelectedCableSynd != '' && SelectedCableSynd != null)
                    {
                        DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                    }
                    
                    //Added by Sanjay 2/15/2016
                    //if(brand.Advertiser__c != null)
                    //DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                    
                    DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 9000';        
                    System.debug('***end_date - ' + end_date );
                    System.debug('***start_date - ' + start_date );                
                    System.debug('***DealQuery - ' + DealQuery);
                    List<Deal__c> DealList = Database.query(DealQuery);
                    for(Deal__c dlist : DealList)
                    {
                        DealResultList.add(dlist);
                    }   
                }
            }   
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Search field can not be null'  ));    
            }
            
            System.debug('######### this monday' + this.getMonday() + ' %%%%% this sunday' + this.getSunday());
            
            Map<Id, List<PrelogData__c>> scheduleMap = new Map<Id, List<PrelogData__c>>();
            
            //** Modified the Query by Sanjay *//
            Date currentMonday = tempSchedule.Week__c;
            Date currentSunday = tempSchedule.Week__c.addDays(6);
            
            system.debug('CurrentMon' + currentMonday  +' '+currentSunday );
            
            for(Deal__c Deal:DealResultList){
                if(prelogVersion!=null && prelogVersion!=''){ 
                    VersionMap.put(Deal.id,prelogVersion);
                }
                else 
                    VersionMap.put(Deal.id,'');
                
            }
            
            //String to hold soql string
            // MG  APR20.2016    added  Version__c, Current_Version__c   with respect to "sOQLString += ' AND Current_Version__c = true';"
            String sOQLString = 'SELECT Id, Version__c, Current_Version__c, Schedule__r.Deal_Parent__c,Schedule__r.Deal_Parent__r.name, Schedule__c, Schedule__r.Id, Schedule__r.Name,'
                + 'Schedule__r.Cap__c FROM PrelogData__c WHERE Schedule__r.Deal_Parent__c IN: DealResultList '
                + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday ';
            
            //Check for version
            if(String.isNotBlank(prelogVersion)) {
                Integer tempInt = Integer.valueOf(prelogVersion);
                sOQLString += ' AND Version__c =: tempInt';
            }
            else {
                sOQLString += ' AND Current_Version__c = true';
            }
            
            System.debug('#### Query::  ' + sOQLString);
            
            for(PrelogData__c p: Database.query(sOQLString)) {
                
                if(scheduleMap.containsKey(p.Schedule__r.Deal_Parent__c)) {
                    scheduleMap.get(p.Schedule__r.Deal_Parent__c).add(p) ;
                } else {
                    List<PrelogData__c> tmpPrelogList = new List<PrelogData__c>() ;
                    tmpPrelogList.add(p) ;
                    scheduleMap.put(p.Schedule__r.Deal_Parent__c, tmpPrelogList) ;
                }
                
                //     MG APR20.2016 rendering Version Number based on Default in Schedule.PreLog Data Default Version
                //     if((!String.isNotBlank(prelogVersion)) && p.Current_Version__c==true && p.Version__c!=null) prelogVersion= p.Version__c;
                //     if((!String.isNotBlank(prelogVersion)) && p.Current_Version__c==true && p.Version__c!=null) prelogVersion= string.valueOf(p.Version__c);
                if((!String.isNotBlank(prelogVersion)) && p.Current_Version__c==true && p.Version__c!=null) currentVersion= string.valueOf(p.Version__c);
                
                if(prelogVersion!=null && prelogVersion!=''){
                    if(VersionMap.containsKey(p.Schedule__r.Deal_Parent__c) && VersionMap.get(p.Schedule__r.Deal_Parent__c)!='')
                        VersionMap.put(p.Schedule__r.Deal_Parent__c,prelogVersion);
                }
                else if(p.Current_Version__c==true && p.Version__c!=null){
                    VersionMap.put(p.Schedule__r.Deal_Parent__c,string.valueOf(p.Version__c));
                }   
                system.debug('%%%% '+p.Schedule__r.Deal_Parent__r.name + ' %%%%% '+ VersionMap.get(p.Schedule__r.Deal_Parent__c));
                //VersionMap.put(p.Schedule__r.Deal_Parent__c,Version);
                
            }
            
            
            
            System.debug('***scheduleMap: after ' + scheduleMap) ;
            Integer i = 0;
            
            //Code Commented by Sanjay Ramchandani for Prelog changes point no 3
            
            /*while(i < DealResultList.size()) {
System.debug('***DealResultList deal: ' + DealResultList[i]) ;
if(!scheduleMap.containsKey(DealResultList[i].Id)) {
Boolean keep = false ;*/
            /*                    for(Schedules__c s: DealResultList[i].Schedules__r) {
if(s.Status__c == 'Sold') keep = true ;
}
*/
            
            /*if(!keep) DealResultList.remove(i) ;
} else {
i++ ;
}
}*/
            
            System.debug('***DealResultList: after ' + DealResultList) ;
            
            /*
*/
            
            //Map to hold deal id as a key and list of schedules as a value
            Map<Id, List<Schedules__c>> mapDealIdWithSchedules = new Map<Id, List<Schedules__c>>();
            
            System.debug('####tempSchedule.Week__c' + tempSchedule.Week__c);
            
            //Logic for include the deals records where schedule exists with the entered week
            for(Schedules__c sch : [Select Id, Deal_Parent__c From Schedules__c where Status__c = 'Sold' AND
                                    Week__c >=: tempSchedule.Week__c AND Week__c <=: tempSchedule.Week__c.addDays(6)]) {
                                        
                                        //Check for map key
                                        if(!mapDealIdWithSchedules.containsKey(sch.Deal_Parent__c))
                                            mapDealIdWithSchedules.put(sch.Deal_Parent__c, new List<Schedules__c>{sch});
                                        else
                                            mapDealIdWithSchedules.get(sch.Deal_Parent__c).add(sch);                            
                                    }
            
            System.debug('####DealResultList size before' + DealResultList.size());
            System.debug('####mapDealIdWithSchedules' + mapDealIdWithSchedules.size());
            
            //List to hold deal records
            List<Deal__c> tempDeal = new List<Deal__c>();
            
            //Check for map size
            if(mapDealIdWithSchedules.size() > 0) {
                for(Deal__c dl : DealResultList) {
                    if(mapDealIdWithSchedules.containsKey(dl.Id)) {
                        tempDeal.add(dl);
                    }   
                }
                DealResultList = tempDeal;
            }
            
            System.debug('####DealResultList size after' + DealResultList.size());
            
            if (DealResultList.size() == 0 && Searchfield != null && Searchfield  !='' )
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'The Search did not return any results'));
            } 
            DealId =''; 
            DealName=''; 
            cellrate =''; 
            CellId =''; 
            showtable = false; 
            schedulemessage = false;
            SortDealResultList();
        }
        catch(exception e){HandleException(e);} 
    }
    public void ClearAllButton()
    {
        try
        {
            DealWrapperList = new List<PrelogClearanceReportHelper.DealWrapper>();
            DealWrapperIdSet = new Set<Id>();
            SelectedDealSet = '';
            SelectedDealMap.clear() ;
        }
        catch(exception e){HandleException(e);} 
    }
    public void SortDealResultList()
    {
        try
        {
            Map<Date, List<Deal__c>> DealDateList = new Map<Date, List<Deal__c>>();
            Set<Date> DateList = new Set<Date>();
            List<Deal__c> NoDateList = new List<Deal__c>();
            for (Deal__c DR : DealResultList)
            {
                if (DR.Week_MIN_Field__c != null)
                {
                    DateList.add(DR.Week_MIN_Field__c);
                    if (DealDateList.containsKey(DR.Week_MIN_Field__c))
                    {
                        List<Deal__c> DealL = DealDateList.get(DR.Week_MIN_Field__c);
                        DealL.add(DR);
                        DealDateList.put(DR.Week_MIN_Field__c, DealL);
                    }
                    else
                    {
                        List<Deal__c> DealL = new List<Deal__c>();
                        DealL.add(DR);
                        DealdateList.put(DR.Week_MIN_Field__c, DealL);
                    }
                }
                else
                {
                    NoDateList.add(DR);
                }
            }
            List<Date> DateSortList = new List<Date>();
            for (Date DS : DateList)
            {
                DateSortList.add(DS);
            }
            DateSortList.sort();
            DealResultList.clear();
            for (integer i = DateSortList.size()-1 ; i >=0 ; i-- )
            {
                if (DealDateList.containsKey(DateSortList[i]))
                {
                    DealResultList.addAll(DealDateList.get(DateSortList[i]));
                }
            }
            DealResultList.addAll(NoDateList);
        }
        catch(exception e){HandleException(e);} 
    }
    public void RemoveDealButton()
    {
        try
        {
            if (RemoveDealId != null)
            {
                List<PrelogClearanceReportHelper.DealWrapper> TempDealWrapper = new List<PrelogClearanceReportHelper.DealWrapper>();
                TempDealWrapper.addAll(DealWrapperList);
                DealWrapperList = new List<PrelogClearanceReportHelper.DealWrapper>();
                DealWrapperIdSet = new Set<Id>();
                SelectedDealSet = '';
                
                SelectedDealMap.remove(dealid) ;
                
                if(DealWrapperMap.containsKey(RemoveDealId )) DealWrapperMap.remove(RemoveDealId );
                for (string key : DealWrapperMap.keySet()){
                    PrelogClearanceReportHelper.DealWrapper DW = DealWrapperMap.get(key );
                    weekEntries += ',' + DW.getkey();
                    DW.isPreviousWeekData=true;
                    DealWrapperIdSet.add(DW.DealRecord.Id);
                    SelectedDealSet += DW.DealRecord.Id;
                }
                
            }
        }
        catch(exception e){HandleException(e);} 
    }
    
    
    
    public list<string> getKeys(){
        /*list<PrelogClearanceReportHelper.DealWrapper> ls = new list<PrelogClearanceReportHelper.DealWrapper>();

for(PrelogClearanceReportHelper.DealWrapper str:DealWrapperMap.values()){
ls.add(str);
}*/
        
        list<string> ls = new list<string>();
        for(string str:DealWrapperMap.keyset()){
            ls.add(str);
        }
        list<string> ls1 = new list<string>();
        integer count=ls.size();
        
        for(integer index=count-1;index>=0;index--){
            ls1.add(ls[index]);
        }
        
        return ls1;
    }
    
    public void AddMoreToDeal()
    {
        try
        {
            //if (DealWrapperMap.keyset().size() > 7)
            //{
            //    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'More than 7 sections cannot be viewed at the same time'));
            //}
            //else //if (!DealWrapperIdSet.contains(DealId))
            //{
                testlist= new List<string>();
                testset = new set<string>(); 
                List<PrelogClearanceReportHelper.LineItemModel> ratelist = new List<PrelogClearanceReportHelper.LineItemModel>();
                map<string,List<Schedules__c>> schgroup = new map<string,List<Schedules__c>>(); 
                Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();
                LowestDate = Date.newInstance(3000,1,1);
                HighestDate = Date.newInstance(1000,1,1);
                
                for (Schedules__c schlist : Database.query('Select ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ', Deal_Parent__r.Week_MIN_Field__c from Schedules__c where Deal_Parent__c = \'' + DealId + '\' ORDER BY MilitaryTime__c, Rate__c' ))
                {
                    if (LowestDate > schlist.Week__c)
                    {
                        LowestDate = schlist.Week__c;
                    }
                    if (HighestDate < schlist.Week__c)
                    {
                        HighestDate = schlist.Week__c;
                    }
                    if(schlist.OrderNumber__c != null)
                    {
                        if(!testset.contains(schlist.OrderNumber__c))
                        {
                            testlist.add(schlist.OrderNumber__c);
                            testset.add(schlist.OrderNumber__c);
                        }
                        If(schgroup.containskey(schlist.OrderNumber__c))
                        {
                            List<Schedules__c> temp = schgroup.get(schlist.OrderNumber__c); 
                            temp.add(schlist); 
                            schgroup.put(schlist.OrderNumber__c,temp);      
                        }
                        else
                        {
                            List<Schedules__c> temp = new List<Schedules__c>(); 
                            temp.add(schlist); 
                            schgroup.put(schlist.OrderNumber__c,temp);      
                        }
                    }
                    
                }
                
                
                //Modified the query by Sanjay 2/3/2016 //
                
                //Check for null
                if(tempSchedule.Week__c == null)
                    tempSchedule.Week__c = Date.today().toStartOfWeek().addDays(1);
                
                List<Deal__c> DealList = [select Id,Contact__c,ContactAccount__c, Campaign__c, Contact__r.Name, Contact__r.Accountid, Contact__r.Account.Name,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c, Program__c, Program__r.Prelog_Date_Time__c, Program__r.Name, Program__r.Reconciled_Week__c, Brands__c, Brands__r.Name, Name, Week_MIN_Field__c, Length__c,SF_Deal_ID__c, Advertiser_ID__c, Advertiser__c, (SELECT Deal_Parent__r.Brands__r.Name, OrderLineNumber__c, Days_Allowed_Formula__c, Start_Time__c, Days_Allowed__c, End_Time__c, Rate__c, MGM_HD_Daypart__c, Total_Dollars__c, Units_Available__c, Units_Aired__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = 'Sold' AND Week__c =: tempSchedule.Week__c) from Deal__c where Id =: DealId];
                if (DealList.size() > 0)
                {
                    ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].program__r.Reconciled_Week__c); 
                    SelectedDeal = DealList[0];
                }
                system.debug('Final Lowest Date - ' + LowestDate);
                decimal TotalUnitsAired = 0;
                decimal TotalUnitsAvailable = 0;
                decimal TotalDollars = 0;
                decimal TotalDollarsBooked = 0;
                for(string mapkeylist : testlist ) 
                {
                    List<Schedules__c> tempwraplist = schgroup.get(mapkeylist); 
                    PrelogClearanceReportHelper.LineItemModel Lm = new PrelogClearanceReportHelper.LineItemModel();
                    Lm.OrderLineNumber = mapkeylist;
                    if(tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null)
                    {
                        Lm.rate = tempwraplist[0].Rate__c;
                    }
                    else
                    {
                        Lm.rate = 0;  
                    }
                    Lm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                    Lm.SETime = tempwraplist[0].Start_End_Time__c;
                    Lm.UnitLength = tempwraplist[0].UnitLength__c;
                    Date RMLowestDate = Date.newInstance(3000,1,1);
                    Date RMHighestDate = Date.newInstance(1000,1,1);
                    for(Schedules__c sch :tempwraplist)
                    {
                        if (RMLowestDate > sch.Week__c)
                        {
                            RMLowestDate = sch.Week__c;
                        }
                        if (RMHighestDate < sch.Week__c)
                        {
                            RMHighestdate = sch.Week__c;
                        }
                        if(sch.week__c >= Date.today().toStartofWeek().addDays(1) )
                        {
                            if(sch.Filler__c == true)
                            {
                                Lm.Filler = true;
                            }   
                        } 
                        if (sch.Reconciled__c == 'Y')
                        {
                            if (sch.Status__c != 'Canceled')
                            {
                                TotalUnitsAired += (sch.Units_Aired__c == null ? 0 : sch.Units_Aired__c );
                                TotalUnitsAvailable += (sch.Units_Available__c == null ? 0 : sch.Units_Available__c );
                            }
                            
                            TotalDollars += (sch.Total_Dollars__c == null ? 0 : sch.Total_Dollars__c);
                            TOtalDollarsBooked += (sch.Dollars_Booked__c == null ? 0 : sch.Dollars_Booked__c);
                        }
                    }
                    LM.LowestDate = RMLowestDate;
                    LM.HighestDate = RMHighestDate;
                    Map<Date,Schedules__c> weekMap = new Map<Date,Schedules__c>(); 
                    Map<Date, Boolean> DuplicateWeekMap = new Map<Date, Boolean>();
                    for(Schedules__c schtemp : tempwraplist )
                    {
                        if (WeekMap.containsKey(schtemp.Week__c))
                        {
                            DuplicateWeekMap.put(schtemp.Week__c, true);
                        }   
                        weekmap.put(schtemp.Week__c, schtemp);  
                        if (WeekDollarsMap.containsKey(schtemp.Week__c))
                        {
                            Decimal WeekDollars = WeekDollarsMap.get(schtemp.Week__c);
                            WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                            WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        }
                        else
                        {
                            Decimal WeekDollars = 0;
                            WeekDollars = WeekDollars + schtemp.Total_Dollars__c;
                            WeekDollarsMap.put(schtemp.Week__c, WeekDollars);
                        }
                    } 
                    for(Date sow: quarterdates)
                    {
                        if (sow != null)
                        {
                            if (sow >= LowestDate)
                            {
                                if(weekmap.containskey(sow))
                                {
                                    if (DuplicateWeekMap.containsKey(sow))
                                    {
                                        Lm.weeks.add(new PrelogClearanceReportHelper.WeekModel(sow,weekmap.get(sow), true)); 
                                    }
                                    else
                                    {
                                        Lm.weeks.add(new PrelogClearanceReportHelper.WeekModel(sow,weekmap.get(sow), false)); 
                                    }
                                }
                                else
                                {
                                    Lm.weeks.add(new PrelogClearanceReportHelper.WeekModel(sow,tempwraplist[0].OrderNumber__c)); 
                                }
                            }
                        }
                    }
                    ratelist.add(Lm);
                    //Display();
                }
                PrelogClearanceReportHelper.DealWrapper DW = new PrelogClearanceReportHelper.DealWrapper();
                DW.DealREcord = SelectedDeal;
                DW.HeadingList = ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c); 
                List<String> TempWeekDollarsList = new List<String>();
                for (PrelogClearanceReportHelper.HeadingModel HM : DW.HeadingList)
                {
                    if (WeekDollarsMap.containsKey(HM.StartOfWeek))
                    {
                        decimal DollarAmount = WeekDollarsMap.get(HM.StartOfWeek);
                        String StringAmount;
                        if (DollarAmount < 1000)
                        {
                            StringAmount =  '$' + String.valueOf(DollarAmount);
                            StringAMount = StringAmount.replace('.00','');
                        }
                        else
                        {
                            DOllarAmount = DollarAMount.setScale(0);
                            DollarAmount = DollarAmOunt/1000.0;
                            DollarAmount = DollarAmount.setScale(1);
                            StringAmount =  '$' + String.valueOf(DollarAmount);
                            StringAmount = StringAmount.replace('.0','') + 'K';
                        }
                        TempWeekDollarsList.add(StringAmount);
                    }
                    else
                    {
                        TempWeekDollarsList.add('$0');
                    }
                }
                DW.WeekDollarsList = TempWeekDollarsList;
                DW.LineItemModelList = rateList;
                DW.UnitsAired = TotalUnitsAired;
                DW.UnitsAvailable = TotalUnitsAvailable;
                DW.WeekDollarsMap = WeekDollarsMap;
                DW.ClearancePercentage = (DW.UnitsAvailable == 0 ? 0 : ( DW.UnitsAired / DW.UnitsAvailable * 100.0).intValue());
                DW.TotalDollars = TotalDollars;
                DW.TotalDollarsBooked = TotalDollarsBooked;
                DW.DollarClearancePercentage = (DW.TotalDollarsBooked == 0 ? 0 : (DW.TotalDollars / DW.TotalDollarsBooked * 100.0).intValue());
                
                //Logic for format the prelog date time in local time zone
                String weekDay = null;
                if(DW.DealRecord.Program__r.Prelog_Date_Time__c!=null)weekDay = DW.DealRecord.Program__r.Prelog_Date_Time__c.format('EEEE').left(3);
                
                String monthOfYear = null;                
                if(DW.DealRecord.Program__r.Prelog_Date_Time__c!=null)monthOfYear =  mapDayOfMonthWithName.get(DW.DealRecord.Program__r.Prelog_Date_Time__c.month());
                
                String dayString = null;                
                if(DW.DealRecord.Program__r.Prelog_Date_Time__c!=null)dayString= String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.day());
                
                String hourString = null;
                if(DW.DealRecord.Program__r.Prelog_Date_Time__c!=null)hourString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.hour());
                
                String minuteString = null;
                if(DW.DealRecord.Program__r.Prelog_Date_Time__c!=null)minuteString = String.valueOf(DW.DealRecord.Program__r.Prelog_Date_Time__c.minute());
                
                //Prepare final string
                DW.prelogDateTime = '';
                if(weekDay !=null && monthOfYear!=null && dayString !=null && hourString !=null && minuteString !=null)
                    DW.prelogDateTime = weekDay + ' ' + monthOfYear + ' ' + dayString + ' ' + hourString + ':' + minuteString + ' EST';
                
                DW.Week=getWeek();
                DW.preLogVersion = VersionMap.get(DW.DealRecord.Id); 
                system.debug('1.Inserting prelogversion#'+ DW.preLogVersion + '#Original'+ VersionMap.get(DW.DealRecord.Id));
                // MG added for adding IDs to sets, maps "DW.DealRecord.Id + getWeek(),DW"
                if(!DealWrapperMap.containsKey(DW.getKey())){  
                    system.debug('2.Inserting prelogversion#'+ DW.preLogVersion + '#Original'+ VersionMap.get(DW.DealRecord.Id));
                    weekEntries += ',' + DW.getKey();      
                    DealWrapperList.add(DW);
                    
                    DealWrapperMap.put(DW.getKey(),DW);
                    DealWrapperIdSet.add(SelectedDeal.Id);
                    SelectedDealSet += SelectedDeal.Id;
                    SelectedDealMap.put(SelectedDeal.Id + getWeek()+ DW.preLogVersion, SelectedDeal) ;
                    
                }
                //Logic For Sort the Wrapper list so that newly searched record coming at the very first row in the table
                List<PrelogClearanceReportHelper.DealWrapper> tempDealWrapper = new List<PrelogClearanceReportHelper.DealWrapper>();
                
                //Loop through the wrapper
                for(Integer j = DealWrapperList.size()-1 ; j >= 0 ; j--)
                    tempDealWrapper.add(DealWrapperList[j]);
                
                System.debug('#########' + tempDealWrapper);
                
                //Re-populate the wrapper
                DealWrapperList = tempDealWrapper;
           // }
        }
        catch(exception e){HandleException(e);} 
    }
    public void Display()
    {
        /*if(ratelist.size() == 0 )
{
schedulemessage = true;
showtable = false;
}
else
{*/
        showtable = true;
        schedulemessage = false;    
        //}    
    }
    public List<PrelogClearanceReportHelper.HeadingModel> ListOfDates(Date pAnchorDate, Date pReconciledDate)
    {
        try
        {
            //Red Argyle - #2791:Controller issues with atypical fiscal quarters
            Date AnchorDate = pAnchorDate;
            
            Period period = [SELECT Id, EndDate, StartDate, Type 
                        FROM Period 
                        WHERE Type = 'Quarter' 
                        AND StartDate <= :AnchorDate 
                        AND EndDate >= :AnchorDate 
                        LIMIT 1];
            Date StartOfQuarter = period.StartDate;
            Date EndOfQuarter = period.EndDate;
            QuarterEndDate = period.EndDate;
            
            if (HighestDate > EndOfQuarter)
            {
                EndOfQuarter = HighestDate;
            }
            if (AnchorDate > EndOfQuarter)
            {
                ListOfDates(AnchorDate.addDays(7),pReconciledDate);
            }
            quarterDates = new List<Date>();
            while (StartOfQuarter <= EndOfQuarter)
            {
                quarterdates.add(StartOfQuarter);
                endDate = StartOfQuarter;
                StartOfQuarter = StartOfQuarter.addDays(7);
            }
            //quarterdates.add(enddate); 
            headingModels  = new List<PrelogClearanceReportHelper.HeadingModel>();
            quarterweek = new List<PrelogClearanceReportHelper.WeekModel>();
            for(Date sow: quarterdates)
            {
                if (sow != null)
                {
                    PrelogClearanceReportHelper.HeadingModel hm = new PrelogClearanceReportHelper.HeadingModel();
                    hm.startOfWeek = sow;
                    if (pReconciledDate >= sow)
                    {
                        hm.bgcolor = '#848484';
                    }
                    else
                    {
                        hm.bgcolor = '#86BCFF';
                    }
                    system.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (SOW >= LowestDate));
                    if (sow >= LowestDate)
                    {
                        headingModels.add(hm);
                    }
                }
            }
            return headingModels;
        }
        catch(exception e){HandleException(e);} 
        return null;
    }
    
    
    
    
    
    //Maps each selected deal Id to a map that maps each order line number to the prelog data.
    public Map<string, Map<String, PrelogClearanceReportHelper.PrelogDataWrapper>> dealMap {get; set;}
    
    //Maps each selected deal Id to a list of grand totals.
    public Map<string, Map<String, Decimal>> grandTotalMap {get; set;}
    
    //Add the selected deal and rerun the prelog clearance report.
    public void updatePrelogClearanceReport() {
        //if(DealId!=null && this.dealMap!=null && this.dealMap.containsKey(DealId)) this.dealMap.remove(DealId + getWeek()+ VersionMap.get(DealId ));
        //if(DealId!=null && this.DealWrapperMap!=null && this.DealWrapperMap.containsKey(DealId)) this.DealWrapperMap.remove(DealId + getWeek()+ VersionMap.get(DealId ));
        //SelectedDealSet += DealId;
        DealWrapperList = new List<PrelogClearanceReportHelper.DealWrapper>();
        this.AddMoreToDeal();
        this.setPrelogClearanceReport();
        weekSet.add(getweek());
        DealWrapperList = new List<PrelogClearanceReportHelper.DealWrapper>();
    }
    
    //Get the prelog clearance report for the specified DealId
    public void setPrelogClearanceReport() {
        system.debug('Monday ==> ' + this.getMonday());
        system.debug('Sunday ==> ' + this.getSunday());
        Set<Id> scheduleIdSet = new Set<Id>() ;
        
        //** Modified the Query by Sanjay *//
        Date currentMonday = tempSchedule.Week__c;
        Date currentSunday = tempSchedule.Week__c.addDays(6);
        
        //Modified the query by Sanjay on 2/18/2016    
        List<PrelogData__c> prelogData = new List<PrelogData__c>();
        
        system.debug('dealWrapperIdSet '+ dealWrapperIdSet ); 
        
        //String to hold the query
        String queryString = 'SELECT Schedule__r.Deal_Parent__r.Brands__r.Name, Schedule__r.OrderLineNumber__c,'
            + 'Schedule__r.Days_Allowed_Formula__c, Schedule__r.Start_Time__c, Schedule__r.Days_Allowed__c,'
            + 'Schedule__r.End_Time__c, Schedule__r.Rate__c, Schedule__c,'
            + 'Schedule__r.MGM_HD_Daypart__c, Day_of_Week__c,' 
            + 'Rate__c, Schedule__r.Total_Dollars__c, Schedule__r.Units_Available__c,'
            + 'Schedule__r.Units_Aired__c, Schedule__r.Name, Schedule__r.Id,'
            + 'Schedule__r.Cap__c, Schedule__r.LastModifiedDate, Version__c '
            + 'FROM PrelogData__c '
            + 'WHERE Schedule__r.Deal_Parent__c IN: dealWrapperIdSet '
            + 'AND AirDate__c >=: currentMonday AND AirDate__c <=: currentSunday';
        
        //Check for version
        if(String.isNotBlank(prelogVersion)) {
            Integer tempInt = Integer.valueOf(prelogVersion);
            queryString += ' AND Version__c =: tempInt';
        }
        else {
            queryString += ' AND Current_Version__c = true';
        }
        
        //Add records in the query
        prelogData = Database.query(queryString);
        
        //Instantiate the deal map and add all of the selected deal Id keys.
        //Adding the deal Ids will prevent any key errors on the Visualforce side in case there is no prelog data for a given deal.
        if(this.dealMap==null)this.dealMap = new Map<string, Map<String, PrelogClearanceReportHelper.PrelogDataWrapper>>();
        this.grandTotalMap = new Map<string, Map<String, Decimal>>();
        
        
        
        for (PrelogClearanceReportHelper.DealWrapper DW : this.DealWrapperList) {
            if(DW.DealRecord.id==dealId && DW.prelogVersion==VersionMap.get(dealId) && DW.Week==getWeek()){ 
                this.dealMap.put(DW.getKey(), new Map<String, PrelogClearanceReportHelper.PrelogDataWrapper>());
                this.grandTotalMap.put(DW.getKey(), new Map<String, Decimal>{'Total Dollars' => 0.0, 'Total Rate' => 0.0, 'Total Clearance' => 0.0});
            }
        }
        
        for (PrelogData__c d : prelogData) {
            //if(d.Schedule__r.Deal_Parent__c!=dealid) continue;
            if(d.Schedule__r.Deal_Parent__c  == dealId ){
                scheduleIdSet.add(d.Schedule__c) ;
                //This maps each order line number to the prelog data for a given deal.
                Map<String, PrelogClearanceReportHelper.PrelogDataWrapper> prelogMap = new Map<String, PrelogClearanceReportHelper.PrelogDataWrapper>();
                if (this.dealMap.containsKey(d.Schedule__r.Deal_Parent__c + getWeek()+ d.Version__c)) {
                    prelogMap = this.dealMap.get(d.Schedule__r.Deal_Parent__c + getWeek()+ d.Version__c);
                }
                
                //This holds all of the information about the prelog data for a given day of the week.
                PrelogClearanceReportHelper.PrelogDataWrapper w = new PrelogClearanceReportHelper.PrelogDataWrapper(d);
                if (prelogMap.containsKey(d.Schedule__r.OrderLineNumber__c)) {
                    w = prelogMap.get(d.Schedule__r.OrderLineNumber__c);
                }
                
                Decimal totalRate = 0;
                
                //Check for null
                if(d.Rate__c != null)
                    totalRate = d.Rate__c;
                
                if (w.rateMap.containsKey(d.Day_of_Week__c)) {
                    totalRate += w.rateMap.get(d.Day_of_Week__c);
                }
                system.debug('$$$$'+d.Schedule__r.Deal_Parent__c + getWeek()+ d.Version__c);
                system.debug('$$$$'+d.Day_of_Week__c + '$$$$'+ totalRate);
                w.rateMap.put(d.Day_of_Week__c, totalRate);
                
                Decimal totalDollars = d.Schedule__r.Total_Dollars__c;
                Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;
                w.clearanceMap.put(d.Day_of_Week__c, clearance);
                w.unitClearanceMap.put(d.Day_of_Week__c, w.unitClearanceMap.get(d.Day_of_Week__c)+1);
                w.unitsAvailableMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Available__c) ;
                w.unitsAiredMap.put(d.Day_of_Week__c, d.Schedule__r.Units_Aired__c) ;
                
                //Update the inner, prelog map, and then the deal map.
                prelogMap.put(d.Schedule__r.OrderLineNumber__c, w);
                this.dealMap.put(d.Schedule__r.Deal_Parent__c + getWeek()+ d.Version__c, prelogMap);
            }
        }
        
        
        for (PrelogClearanceReportHelper.DealWrapper DW : this.DealWrapperList) {
            
            //if(DW.DealRecord.id!=dealId) continue ;
            if(!SelectedDealMap.containsKey(DW.DealRecord.id )) continue ;
            for(Schedules__c s: SelectedDealMap.get(DW.DealRecord.id ).Schedules__r) {
                if(scheduleIdSet.contains(s.Id)) continue ;
                //This maps each order line number to the prelog data for a given deal.
                Map<String, PrelogClearanceReportHelper.PrelogDataWrapper> prelogMap = new Map<String, PrelogClearanceReportHelper.PrelogDataWrapper>();
                if (this.dealMap.containsKey(s.Deal_Parent__c + getWeek()+ DW.preLogVersion)) {
                    prelogMap = this.dealMap.get(s.Deal_Parent__c + getWeek()+ DW.preLogVersion);
                }
                //This holds all of the information about the prelog data for a given day of the week.
                PrelogClearanceReportHelper.PrelogDataWrapper w = new PrelogClearanceReportHelper.PrelogDataWrapper(new PrelogData__c(Schedule__r = s));
                if (prelogMap.containsKey(s.OrderLineNumber__c)) {
                    w = prelogMap.get(s.OrderLineNumber__c);
                }
                
                Decimal totalRate = 0;
                Decimal totalDollars = s.Total_Dollars__c;
                Decimal clearance = totalDollars != 0.0 ? ((totalRate / totalDollars)).setScale(2) : 0.0;
                
                //Update the inner, prelog map, and then the deal map.
                prelogMap.put(s.OrderLineNumber__c, w);
                this.dealMap.put(s.Deal_Parent__c + getWeek() + DW.preLogVersion, prelogMap);
            }
        }
        system.debug('####DealWrapperMap' + DealWrapperMap.keyset());
        //Calculate the totals for each prelog wrapper. 
        //Also, calculate the grand totals for each selected deal.
        for (string dealId1 : this.dealMap.keySet()) {
            //if(DealWrapperMap.containsKey(dealid1 ) && DealWrapperMap.get(dealid1 ).DealRecord.id==dealId){
            
            Decimal dealTotalDollars = 0.0;
            Decimal dealTotalRate = 0.0;
            Decimal dealTotalClearance = 0.0;
            
            system.debug('1####' + dealId);
            system.debug('1####prelogversion ' + preLogVersion);
            
            
            if(DealWrapperMap.containsKey(dealid1  )){
                system.debug('1####prelogversion ' + DealWrapperMap.get(dealid1 ).prelogversion);
                DealWrapperMap.get(dealid1 ).prelogversion = null;
                DealWrapperMap.get(dealid1 ).prelogversionMap.put(getWeek()+ VersionMap.get(DealId1 ), null);
            } 
            
            
            //if(dealid!=null && this.dealMap.containsKey(dealId+getWeek() + preLogVersion))
            for (PrelogClearanceReportHelper.PrelogDataWrapper w : this.dealMap.get(dealId1 ).values()) {
                system.debug('1####w.prelogData.Version__c ' + w.prelogData.Version__c);
                w.calculateTotals();
                // MG added for setting the current PreLog Version
                if(DealWrapperMap.containsKey(dealid1 ) && w.prelogData.Version__c!=null ){
                    DealWrapperMap.get(dealid1).prelogversion = string.valueOf(w.prelogData.Version__c);
                    DealWrapperMap.get(dealid1 ).prelogversionMap.put(getWeek()+ VersionMap.get(DealId1 ),string.valueOf(w.prelogData.Version__c));
                }
                
                dealTotalDollars += w.totalDollars;
                dealTotalRate += w.rate;
                dealTotalClearance = dealTotalDollars != 0.0 ? ((dealTotalRate / dealTotalDollars)).setScale(2) : 0.0;
            }
            
            if(DealWrapperMap.containsKey(dealid1  )){
                weekEntries += ',' + dealid1  ;//DealWrapperMap.get(dealid ).DealRecord.Id + getWeek()+ DealWrapperMap.get(dealid ).preLogVersion; 
            }
            this.grandTotalMap.put(dealId1, new Map<String, Decimal>{
                'Total Dollars' => dealTotalDollars, 
                    'Total Rate' => dealTotalRate,
                    'Total Clearance' => dealTotalClearance
                    });
        }
        
        //}
    }
    
    //Returns the Monday of this week for use in a soql query.
    public Date getMonday() {
        Date t = Date.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getMonday: daysBetween: ' + daysBetween);
        if((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(1);
    }
    
    //Returns the Sunday of this week for use in a soql query.
    public Date getSunday() {
        Date t = Date.today() ;
        Integer daysBetween = t.toStartOfWeek().daysBetween(t) ;
        System.debug('***getSunday: daysBetween: ' + daysBetween);
        if((daysBetween == 0) || (daysBetween >= 5)) {
            t.addDays(7) ;
        }
        return t.toStartOfWeek().addDays(7);
    }
    
    // MG added to get 1st Day of Week in specific format MM/DD/YYYY
    public string getWeek(){
        return string.valueOf(tempSchedule.Week__c.toStartOfWeek().Month() + '/' + (tempSchedule.Week__c.toStartOfWeek().day()+1) + '/' + tempSchedule.Week__c.toStartOfWeek().year());
    }
    
    // MG added for making section sort, last table selection derives at top
    public list<string> getWeekData(){ 
        List<String> fList = new List<String>(weekSet);
        List<String> finalList= new List<String>();
        for(Integer i = fList.size()-1; i>=0;i--){
            
            finalList.add(fList[i]);
            
        }
        
        return finalList;
        
    }
    
    public void FillDealResultList(){
        DealResultList = new List<Deal__c>();
        
        // MG added for purpose of making Week/Dates unSelected when subsequent Week/Date is Selected
        SearchList = new List<string>();
        map<id,Deal__c> MapofFinalDeals = new map<id,Deal__c>();
        Map<Integer,set<id>> Accurancy = new Map<Integer, set<id>>();
        
        
        
        ReturnSOQLDateString();
        if(Searchfield != null && Searchfield  !='')
        {
            //searchField = SearchField.replace(' , ',',').replace(' ,',',').replace(', ',',');
            while (searchField.contains(' , '))
            {
                SearchField = SearchField.replace(' , ',',');
            }
            while (SearchField.contains(' ,'))
            {
                SearchField = SearchField.replace(' ,',',');
            }
            while (SearchField.contains(', '))
            {
                SearchField = SearchField.replace(', ',',');
            }
            string tempSearch = '%'+Searchfield +'%';
            SearchList = Searchfield.split(',');
            Accurancy.put( 1 ,new Set<id>{} );
            if (SearchList.size() > 1)
            {
                for(String stringListLoop : SearchList)
                {
                    while(stringListLoop.startsWith(' ') || stringListLoop.endsWith(' '))
                    {
                        if (StringListLoop.startsWith(' '))
                        {
                            StringListLoop = StringListLoop.substringAfter(' ');
                        }
                        if (StringListLoop.endsWith(' '))
                        {
                            StringListLoop = StringListLoop.substringBeforeLast(' ');
                        }
                    }
                    string tempstringListLoop = '%'+stringListLoop+'%';
                    set<Deal__c> tempDealList = new set<Deal__c>();
                    period pr=getCurrentQuoter(tempSchedule.Week__c);
                        date start_date=pr.startDate;
                    date end_date=pr.EndDate;
                    String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,' 
                        + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                        + 'Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') '
                        + ' From Deal__c '
                        + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                        + ' OR Brands__r.Advertiser__r.Name Like \'' + tempstringListLoop + '\''
                        + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null  And Week_MIN_Field__c<=:end_date And Week_MIN_Field__c>=:start_date '
                        + SOQLDateString;
                    if (BarterCheckbox)
                    {
                        DealQuery += ' AND Program__r.Barter__c = True ';
                    }                       
                    if (SelectedCableSynd != '' && SelectedCableSynd != null)
                    {
                        DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                    }
                    
                    //Added by Sanjay 2/15/2016
                    //if(brand.Advertiser__c != null)
                    //DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                    
                    //Add Order by clause
                    DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 9000';
                    System.debug('***end_date - ' + end_date );
                    System.debug('***start_date - ' + start_date );
                    System.debug('***DealQuery - ' + DealQuery);
                    List<Deal__c> DealList = Database.query(DealQuery);
                    for(Deal__c dlist : DealList )
                    {
                        system.debug('tempStringListLoop - ' + tempStringListLoop + ' - ' + dlist.Name + ' - ' + dlist.Program__r.Name + ' - ' + dlist.Contact__r.Name + ' - ' + dlist.Client_Account__r.Name + ' - ' + dlist.Brands__r.Name);
                        boolean NotInList = false;
                        MapofFinalDeals.put( dlist.id , dlist);
                        for(integer i = Accurancy.size(); i>0; i--)
                        {
                            If(Accurancy.get(i).contains(dlist.id))
                            {
                                NotInList = true;
                                if(Accurancy.containskey(i+1))
                                {
                                    set<id> dealset1 = accurancy.get(i+1);
                                    dealset1.add(dlist.id);
                                    Accurancy.put(i+1, dealset1); 
                                }
                                else
                                {
                                    set<id> dealset1 = new Set<id>();
                                    dealset1.add(dlist.id);
                                    Accurancy.put(i+1, dealset1);     
                                }
                                Accurancy.get(i).remove(dlist.id);
                            }
                        } 
                        if(NotinList == false)
                        {
                            set<id> dealset1 = accurancy.get(1);
                            dealset1.add(dlist.id);
                            Accurancy.put(1, dealset1);     
                        }
                        DealResultList.add(dlist);
                    } 
                }
                for (integer Count : Accurancy.keySet())
                {
                    system.debug('Accurancy Count - ' + Count + ' - ' + Accurancy.get(Count));
                }   
                integer count=0;
                
                if (Accurancy.containsKey(SearchList.size()))
                {
                    for(Id MapofDeals : Accurancy.get(SearchList.size()))
                    {
                        if (Count < 200)
                        {
                            DealResultList.add(MapofFinalDeals.get(mapofdeals));
                            Count++;
                        }       
                    }  
                }   
            }
            else
            {
                string tempstringListLoop = '%'+SearchList[0] +'%';
                period pr=getCurrentQuoter(tempSchedule.Week__c);
                        date start_date=pr.startDate;
                    date end_date=pr.EndDate;
                String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                    + ' Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,SF_Deal_ID__c,'
                    + ' Program__r.Name, Program__r.Prelog_Date_Time__c, Advertiser_ID__c, Advertiser__c, (SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\') ' 
                    + ' From Deal__c '
                    + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                    + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                    + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                    + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\'' 
                    + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                    + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\'' 
                    + ' OR Brands__r.Advertiser__r.Name Like \'' + tempstringListLoop + '\''
                    + ' OR Name Like \'' + tempstringListLoop + '\' )  AND Week_MIN_Field__c != null   And Week_MIN_Field__c<=:end_date And Week_MIN_Field__c>=:start_date  '
                    + SOQLDateString;
                if (BarterCheckbox)
                {
                    DealQuery += ' AND Program__r.Barter__c = True ';
                }                       
                if (SelectedCableSynd != '' && SelectedCableSynd != null)
                {
                    DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                }
                
                //Added by Sanjay 2/15/2016
                //if(brand.Advertiser__c != null)
                //DealQuery += ' AND Brands__r.Advertiser__c =\'' + brand.Advertiser__c + '\'';
                
                DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 9000';
                System.debug('***end_date - ' + end_date );
                    System.debug('***start_date - ' + start_date );                        
                System.debug('***DealQuery - ' + DealQuery);
                List<Deal__c> DealList = Database.query(DealQuery);
                for(Deal__c dlist : DealList)
                {
                    DealResultList.add(dlist);
                }   
            }
        }   
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Search field can not be null'  ));    
        }
    }
    
    
    public void ReturnSOQLDateString()
    {
        try
        {
            if (SelectedDateLiteral == null || SelectedDateLiteral == '')
            {
                SOQLDateString = '';
            }
            else
            {
                if (SelectedDateLiteral == 'Custom')
                {
                    if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null)
                    {
                        SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + PrelogClearanceReportHelper.ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + PrelogClearanceReportHelper.ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
                    }
                    else
                    {
                        SOQLDateString = '';
                    }
                }
                else if (SelectedDateLiteral == 'Previous FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_YEAR ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Previous 2 FY')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = LAST_FISCAL_YEAR ) ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.day__c = FYS2.StartDate;
                            WeekEndDate.Day__c = FYS1.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == '2 FY Ago')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.Day__c = FYS.StartDate;
                            WeekEndDate.Day__c = FYS.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 1));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.day__c = FYS1.StartDate;
                            WeekEndDate.Day__c = FYS2.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous 2 FY')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
                    if (CurrentFY != null)
                    {
                        if (FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2)) && FiscalMap.containsKey(String.valueOf(Integer.valueOf(CurrentFY.Name))))
                        {
                            FiscalYearSettings FYS1 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name) - 2));
                            FiscalYearSettings FYS2 = FiscalMap.get(String.valueOf(Integer.valueOf(CurrentFY.Name)));
                            WeekStartDate.day__c = FYS1.StartDate;
                            WeekEndDate.Day__c = FYS2.EndDate;
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current FQ')
                {
                    if (CurrentFP != null)
                    {
                        WeekStartDate.Day__c = CurrentFP.StartDate;
                        WeekEndDate.Day__c = CurrentFP.EndDate;
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 4)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Previous FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFP.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFP.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Next FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 4)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number + 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Previous FQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_FISCAL_QUARTER ';
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) - 1)));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(CurrentFP.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(CurrentFP.FiscalYearSettings.Name);
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current And Next 3 FQ')
                {
                    if (CurrentFP != null)
                    {
                        if (CurrentFP.Number == 1)
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name)))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name))));
                                if (TempQuarterPeriodMap.containsKey(4))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(4);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (QuarterPeriodMap.containsKey(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1))))
                            {
                                Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(String.valueof((Integer.valueOf(CurrentFP.FiscalYearSettings.Name) + 1)));
                                if (TempQuarterPeriodMap.containsKey(CurrentFP.Number - 1))
                                {
                                    Period TempPeriod = TempQuarterPeriodMap.get(CurrentFP.Number - 1);
                                    WeekStartDate.Day__c = CurrentFP.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Last FP')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_PERIOD ';
                    if (CurrentFM != null)
                    {
                        integer NumberMonth;
                        if (CurrentFM.number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = PrelogClearanceReportHelper.ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 1)
                        {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12))
                                {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'This FP')
                {
                    if (CurrentFM != null)
                    {
                        WeekStartDate.Day__c = CurrentFM.StartDate;
                        WeekEndDate.Day__c = CurrentFM.EndDate;
                    }   
                }
                else if (SelectedDateLiteral == 'Next FP')
                {
                    if (CurrentFM != null)
                    {
                        integer NumberMonth;
                        if (CurrentFM.number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = PrelogClearanceReportHelper.ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 12)
                        {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Current And Previous FP')
                {
                    if (CurrentFM != null)
                    {
                        integer NumberMonth;
                        if (CurrentFM.number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = PrelogClearanceReportHelper.ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 1)
                        {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(12))
                                {
                                    Period TempPeriod = TempPeriodMap.get(12);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFM.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = CurrentFM.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Current And Next FP')
                {
                    if (CurrentFM != null)
                    {
                        integer NumberMonth;
                        if (CurrentFM.number != null)
                        {
                            NumberMonth = CurrentFM.Number;
                        }
                        else
                        {
                            NumberMonth = PrelogClearanceReportHelper.ReturnNumber(CurrentFM.PeriodLabel);
                        }
                        if (NumberMonth == 12)
                        {
                            if (MOnthPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFM.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = CurrentFM.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (MOnthPeriodMap.containsKey(CurrentFM.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = MonthPeriodMap.get(CurrentFM.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(NumberMonth + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(NumberMonth + 1);
                                    WeekStartDate.Day__c = CurrentFM.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }   
                }
                else if (SelectedDateLiteral == 'Last FW')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
                    if (CurrentFW != null)
                    {
                        if (CurrentFW.Number == 1)
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) - 1));
                                if (TempPeriodMap.containsKey(53))
                                {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                                else if (TempPeriodMap.containsKey(52))
                                {
                                    Period TempPeriod = TempPeriodMap.get(52);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else
                        {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(CurrentFW.Number - 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number - 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'This FW')
                {
                    if (CurrentFW != null)
                    {
                        WeekStartDate.Day__c = CurrentFW.StartDate;
                        WeekEndDate.Day__c = CurrentFW.EndDate;
                    }
                }
                else if (SelectedDateLiteral == 'Next FW')
                {
                    if (CurrentFW != null)
                    {
                        if (CurrentFW.Number == 53)
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1)))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                if (TempPeriodMap.containsKey(1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                        else if (CurrentFW.Number == 52)
                        {
                            if (WeekPeriodMap.containsKey(CurrentFW.FiscalYearSettings.Name))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(CurrentFW.FiscalYearSettings.Name);
                                if (TempPeriodMap.containsKey(53))
                                {
                                    Period TempPeriod = TempPeriodMap.get(53);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                                else
                                {
                                    if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1)))
                                    {
                                        Map<Integer, Period> TempPeriodMap1 = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name) + 1));
                                        if (TempPeriodMap1.containsKey(1))
                                        {
                                            Period TempPeriod = TempPeriodMap1.get(1);
                                            WeekStartDate.Day__c = TempPeriod.StartDate;
                                            WeekEndDate.Day__c = TempPeriod.EndDate;
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (WeekPeriodMap.containsKey(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name))))
                            {
                                Map<Integer, Period> TempPeriodMap = WeekPeriodMap.get(String.valueOf(Integer.valueOf(CurrentFW.FiscalYearSettings.Name)));
                                if (TempPeriodMap.containsKey(CurrentFW.Number + 1))
                                {
                                    Period TempPeriod = TempPeriodMap.get(CurrentFW.Number + 1);
                                    WeekStartDate.Day__c = TempPeriod.StartDate;
                                    WeekEndDate.Day__c = TempPeriod.EndDate;
                                }
                            }
                        }
                    }
                }
                else if (SelectedDateLiteral == 'Current CY')SOQLDateString = setDateString(' AND Week_MIN_Field__c = THIS_YEAR '
                                                                                            ,Date.newInstance(Date.Today().year(), 1, 1),Date.newInstance(Date.Today().year(), 12,31)
                                                                                            ,WeekStartDate,WeekEndDate);    
                else if (SelectedDateLiteral == 'Previous CY')SOQLDateString = setDateString(' AND Week_MIN_Field__c = LAST_YEAR '
                                                                                             ,Date.newInstance(Date.Today().year() - 1, 1, 1),Date.newInstance(Date.Today().year() - 1, 12,31)
                                                                                             ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == 'Previous 2 CY') SOQLDateString = setDateString(' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 ) '
                                                                                                ,Date.newInstance(Date.Today().year() - 2, 1, 1),Date.newInstance(Date.Today().year() -1, 12,31)
                                                                                                ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == '2 CY Ago') SOQLDateString = setDateString(' AND Week_MIN_Field__c = LAST_N_YEARS:2 '
                                                                                           ,Date.newInstance(Date.Today().year() - 2, 1, 1),Date.newInstance(Date.Today().year() -2, 12,31)
                                                                                           ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == 'Next CY')SOQLDateString = setDateString(' AND Week_MIN_Field__c = NEXT_YEAR '
                                                                                         ,Date.newInstance(Date.Today().year() +1, 1, 1),Date.newInstance(Date.Today().year() +1, 12,31)
                                                                                         ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == 'Current And Previous CY') SOQLDateString = setDateString(' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_MIN_Field__c = THIS_YEAR ) '
                                                                                                          ,Date.newInstance(Date.Today().year() -1, 1, 1),Date.newInstance(Date.Today().year(), 12,31)
                                                                                                          ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'Current And Previous 2 CY') SOQLDateString = setDateString(' AND  ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = THIS_YEAR ) '
                                                                                                            ,Date.newInstance(Date.Today().year() -2, 1, 1),Date.newInstance(Date.Today().year(), 12,31)
                                                                                                            ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == 'Current And Next CY') SOQLDateString = setDateString(' AND ( Week_MIN_Field__c = NEXT_YEAR OR Week_MIN_Field__c = THIS_YEAR ) '
                                                                                                      ,Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year() + 1, 12,31)
                                                                                                      ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'Current CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = THIS_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3) 
                        setDateString(Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year(), 3, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year(), 6, 30),WeekStartDate,WeekEndDate);  
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 7, 1),Date.newInstance(Date.Today().year(), 9, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year() , 10, 1),Date.newInstance(Date.Today().year(), 12, 31),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Current And Next CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_QUARTER ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3)
                        setDateString(Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year(), 6, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year(), 9, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 7, 1),Date.newInstance(Date.Today().year(), 12, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year() , 10, 1),Date.newInstance(Date.Today().year() + 1, 3, 31),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Current And Previous CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = LAST_QUARTER ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3)
                        setDateString(Date.newInstance(Date.Today().year() , 10, 1),Date.newInstance(Date.Today().year(), 3, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year(), 6, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year(), 9, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year() , 7, 1),Date.newInstance(Date.Today().year() , 12, 31),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Next CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = NEXT_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year(), 6, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 7, 1),Date.newInstance(Date.Today().year(), 9, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 10, 1),Date.newInstance(Date.Today().year(), 12, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year() + 1 , 1, 1),Date.newInstance(Date.Today().year() , 3, 31),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Previous CQ')
                {
                    SOQLDateString = ' AND Week_MIN_Field__c = LAST_QUARTER ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3)
                        setDateString(Date.newInstance(Date.Today().year() -1, 10, 1),Date.newInstance(Date.Today().year() - 1, 12, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year(), 3, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year(), 6, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year()  , 7, 1),Date.newInstance(Date.Today().year() , 9, 30),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Current And Next 3 CQ')
                {
                    SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_N_QUARTERS:3 ) ';
                    if (Date.Today().month() >=1 && Date.Today().month() <= 3)
                        setDateString(Date.newInstance(Date.Today().year() , 1, 1),Date.newInstance(Date.Today().year() , 12, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
                        setDateString(Date.newInstance(Date.Today().year() , 4, 1),Date.newInstance(Date.Today().year()+ 1, 3, 31),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
                        setDateString(Date.newInstance(Date.Today().year() , 7, 1),Date.newInstance(Date.Today().year() + 1, 6, 30),WeekStartDate,WeekEndDate); 
                    else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
                        setDateString(Date.newInstance(Date.Today().year()  , 10, 1),Date.newInstance(Date.Today().year() + 1 , 9, 30),WeekStartDate,WeekEndDate); 
                }
                else if (SelectedDateLiteral == 'Last Month') SOQLDateString = setDateString(' AND Week_MIN_Field__c = LAST_MONTH '
                                                                                             ,Date.Today().addmonths(-1).ToStartOfMOnth(),Date.Today().ToStartOfMonth().addDays(-1)
                                                                                             ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'This Month') SOQLDateString = setDateString(' AND Week_MIN_Field__c = THIS_MONTH '
                                                                                             ,Date.Today().ToStartOfMOnth(),Date.Today().addmonths(1).ToStartOfMonth().addDays(-1)
                                                                                             ,WeekStartDate,WeekEndDate);     
                else if (SelectedDateLiteral == 'Next Month') SOQLDateString = setDateString(' AND Week_MIN_Field__c = NEXT_MONTH '
                                                                                             ,Date.Today().addmonths(1).ToStartOfMOnth(),Date.Today().addmonths(2).ToStartOfMonth().addDays(-1)
                                                                                             ,WeekStartDate,WeekEndDate);    
                else if (SelectedDateLiteral == 'Current And Last Month') SOQLDateString = setDateString(' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = LAST_MONTH ) '
                                                                                                         ,Date.Today().addmonths(-1).ToStartOfMOnth(),Date.Today().addmonths(1).ToStartOfMonth().addDays(-1)
                                                                                                         ,WeekStartDate,WeekEndDate);    
                else if (SelectedDateLiteral == 'Current And Next Month')SOQLDateString = setDateString(' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = NEXT_MONTH ) '
                                                                                                        ,Date.Today().ToStartOfMOnth(),Date.Today().addmonths(2).ToStartOfMonth().addDays(-1)
                                                                                                        ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'Last Week')SOQLDateString = setDateString(' AND Week_MIN_Field__c = LAST_WEEK '
                                                                                           ,Date.Today().ToStartOfWeek().addDays(-7),Date.Today().ToStartOfWeek().addDays(-1)
                                                                                           ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'This Week')SOQLDateString = setDateString(' AND Week_MIN_Field__c = THIS_WEEK '
                                                                                           ,Date.Today().ToStartOfWeek(),Date.Today().ToStartOfWeek().addDays(6)
                                                                                           ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'Next Week')SOQLDateString = setDateString(' AND Week_MIN_Field__c = NEXT_WEEK '
                                                                                           ,Date.Today().addDays(7).ToStartOfWeek(),Date.Today().addDays(7).ToStartOfWeek().addDays(6)
                                                                                           ,WeekStartDate,WeekEndDate);   
                else if (SelectedDateLiteral == 'Yesterday')SOQLDateString = setDateString(' AND Week_MIN_Field__c = YESTERDAY '
                                                                                           ,Date.Today().addDays(-1),Date.Today().addDays(-1)
                                                                                           ,WeekStartDate,WeekEndDate);  
                else if (SelectedDateLiteral == 'Today') SOQLDateString = setDateString(' AND Week_MIN_Field__c = TODAY '
                                                                                        ,Date.Today(),Date.Today()
                                                                                        ,WeekStartDate,WeekEndDate); 
                else if (SelectedDateLiteral == 'Tomorrow') SOQLDateString = setDateString(' AND Week_MIN_Field__c = TOMORROW '
                                                                                           ,Date.Today().addDays(1),Date.Today().addDays(1)
                                                                                           ,WeekStartDate,WeekEndDate); 
                else if (SelectedDateLiteral == 'Last 7 Days')SOQLDateString = setDateString('7',WeekStartDate,WeekEndDate,false); 
                else if (SelectedDateLiteral == 'Last 30 Days')SOQLDateString = setDateString('30',WeekStartDate,WeekEndDate,false);   
                else if (SelectedDateLiteral == 'Last 60 Days')SOQLDateString = setDateString('60',WeekStartDate,WeekEndDate,false);  
                else if (SelectedDateLiteral == 'Last 90 Days')SOQLDateString = setDateString('90',WeekStartDate,WeekEndDate,false); 
                else if (SelectedDateLiteral == 'Last 120 Days')SOQLDateString = setDateString('120',WeekStartDate,WeekEndDate,false); 
                else if (SelectedDateLiteral == 'Next 7 Days')SOQLDateString = setDateString('7',WeekStartDate,WeekEndDate,true); 
                else if (SelectedDateLiteral == 'Next 30 Days') SOQLDateString = setDateString('30',WeekStartDate,WeekEndDate,true); 
                else if (SelectedDateLiteral == 'Next 60 Days')SOQLDateString = setDateString('60',WeekStartDate,WeekEndDate,true); 
                else if (SelectedDateLiteral == 'Next 90 Days') SOQLDateString = setDateString('90',WeekStartDate,WeekEndDate,true); 
                else if (SelectedDateLiteral == 'Next 120 Days') SOQLDateString = setDateString('120',WeekStartDate,WeekEndDate,true);
                
            }
            if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null)
            {
                SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + PrelogClearanceReportHelper.ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + PrelogClearanceReportHelper.ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
            }
            else
            {
                SOQLDateString = '';
            }
            system.debug('SOQLDateString  ' + SOQLDateString );
            system.debug('Start And End Dates - ' + WeekStartDate.Day__c + ' - ' + WeekEndDate.Day__c);
        }
        catch(exception e) {HandleException(e);} 
    }public string setDateString(string days, Schedules__c WeekStartDate,Schedules__c WeekEndDate, boolean isAdd){
        
        string SOQL= '';
        if(isAdd) SOQL = ' AND Week_MIN_Field__c = NEXT_N_DAYS:' + days + ' ';
        else  SOQL = ' AND Week_MIN_Field__c = LAST_N_DAYS:' + days + ' ';
        
        integer daycount=integer.valueOf(days);
        
        if(!isAdd) daycount = daycount* (-1);
        
        if(isAdd){
            WeekStartDate.Day__c = Date.Today();
            WeekEndDate.Day__C = Date.Today().addDays(daycount);
        }
        else{
            WeekStartDate.Day__c = Date.Today().addDays(daycount);
            WeekEndDate.Day__C = Date.Today();
        }   
        return SOQL;
    }
    
    public string setDateString(string SOQL,date date1, date date2, Schedules__c WeekStartDate,Schedules__c WeekEndDate){       
        WeekStartDate.Day__c = date1;
        WeekEndDate.Day__C = date2; 
        return SOQL;
    }
    
    public void setDateString( date date1, date date2, Schedules__c WeekStartDate,Schedules__c WeekEndDate){       
        WeekStartDate.Day__c = date1;
        WeekEndDate.Day__C = date2;  
    }
    
    public void HandleException(exception e){
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
        ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));       
    }
    
}