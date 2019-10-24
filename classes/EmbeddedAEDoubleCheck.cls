public with sharing class EmbeddedAEDoubleCheck 
{
	public DealWrapper SelectedDealWrapper {get;set;}
	public List<WeekModel> quarterweek {get;set;}
    public string DealId {Get;set;}
    public List<HeadingModel> headingModels {get;set;}
    public Date LowestDate {get;set;}
    public Date HighestDate {get;set;}
    public Date QuarterEndDate {get;set;}
   	public Deal__c SelectedDeal {get;set;}
    public list<date> quarterdates {get;set;}
    public Date anchordate;
    public date startdate;
    public date enddate;
    
	public EmbeddedAEDoubleCheck(ApexPages.StandardController sc)
	{
		try
		{
			if (sc != null)
			{
				DealId = sc.getID();
              	List<LineItemModel> ratelist = new List<LineItemModel>();
              	Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();

				List<Schedules__c> schedules = Database.query(buildQueryForReport(DealId));
				setHighestLowestDates(schedules);
				map<string,List<Schedules__c>> schgroup = createSchedulesByOrderNumberMap(schedules);

/*
              	for (Schedules__c schlist : schedules)
              	{
				
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
				  */
              	List<Deal__c> DealList = [select Id,Contact__c,ContactAccount__c, Contact__r.Name, Contact__r.Accountid, Contact__r.Account.Name,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c, Program__r.Name, Program__r.Reconciled_Week__c, Brands__c, Brands__r.Name, Name, Week_MIN_Field__c, Length__c,SF_Deal_ID__c from Deal__c where Id =: DealId];
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
              	for(string mapkeylist : schgroup.keySet() ) 
              	{
                  	List<Schedules__c> tempwraplist = schgroup.get(mapkeylist); 
                  	LineItemModel Lm = new LineItemModel();
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
	                                  	Lm.weeks.add(new weekModel(sow,weekmap.get(sow), true)); 
	                                }
	                                else
	                                {
                                    	Lm.weeks.add(new weekModel(sow,weekmap.get(sow), false)); 
                                	}
                              	}
                              	else
                              	{
                                  	Lm.weeks.add(new weekModel(sow,tempwraplist[0].OrderNumber__c)); 
                              	}
                          	}
                      	}
                  	}
                  	ratelist.add(Lm);
                  	//Display();
	            }
              	DealWrapper DW = new DealWrapper();
              	DW.DealREcord = SelectedDeal;
              	DW.HeadingList = ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c); 
              	List<String> TempWeekDollarsList = new List<String>();
              	for (headingModel HM : DW.HeadingList)
              	{
              		if (WeekDollarsMap.containsKey(HM.StartOfWeek))
              		{
              			decimal DollarAmount = WeekDollarsMap.get(HM.StartOfWeek);
              			String StringAmount;
              			if (DollarAmount < 1000)
              			{
              				StringAmount = 	'$' + String.valueOf(DollarAmount);
              				StringAMount = StringAmount.replace('.00','');
              			}
              			else
              			{
              				DOllarAmount = DollarAMount.setScale(0);
							DollarAmount = DollarAmOunt/1000.0;
							DollarAmount = DollarAmount.setScale(1);
							StringAmount = 	'$' + String.valueOf(DollarAmount);
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
              	SelectedDealWrapper = DW;
			}	
		}	
		catch (Exception ex)
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Error - ' + ex.getMessage()));
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Line Number - ' + ex.getLineNumber()));
		}
	}

	private Map<String, List<Schedules__c>> createSchedulesByOrderNumberMap(List<Schedules__c> schedules) {
        Map<String,List<Schedules__c>> schgroup = new Map<String, List<Schedules__c>>(); 
		for (Schedules__c schlist : schedules) {
            if(schlist.OrderNumber__c != null) {
				if(schgroup.containskey(schlist.OrderNumber__c)) {
                	List<Schedules__c> temp = schgroup.get(schlist.OrderNumber__c); 
                    temp.add(schlist); 
                    schgroup.put(schlist.OrderNumber__c,temp);      
                } else {
                    List<Schedules__c> temp = new List<Schedules__c>(); 
                    temp.add(schlist); 
                    schgroup.put(schlist.OrderNumber__c,temp);      
                }
            }
        }
		return schgroup;
	}

	private void setHighestLowestDates(List<Schedules__c> schedules) {
		if (LowestDate == null && HighestDate == null) {
			LowestDate = Date.newInstance(3000,1,1);
            HighestDate = Date.newInstance(1000,1,1);
		}
		for (Schedules__c schedule: schedules) {
			if (LowestDate > schedule.Week__c) {
				LowestDate = schedule.Week__c;
			}
			if (HighestDate < schedule.Week__c) {
				HighestDate = schedule.Week__c;
			}
		}

		
		
	}

	public String buildQueryForReport(Id dealId) {
        List<String> fieldsForQuery = SaberGF.getObjectsFieldsForQueriesFromFieldSet('Schedules__c', 'Deal_Revision');
        String queryString = '';
        for (String field: fieldsForQuery) {
            queryString += field + ', ';
        }
        return 'SELECT ' + queryString + ' MGM_Hd_Daypart__c FROM Schedules__c WHERE Deal_Parent__c = \'' + DealId + '\' ORDER BY MilitaryTime__c, Rate__c';
    }

	public List<headingModel> ListOfDates(Date pAnchorDate, Date pReconciledDate)
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
            headingModels  = new List<headingModel>();
            quarterweek = new List<WeekModel>();
            for(Date sow: quarterdates)
            {
                if (sow != null)
                {
                    HeadingModel hm = new Headingmodel();
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
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
        return null;
    }
	public class DealWrapper
    {
      	public Deal__c DealRecord {get;set;}
      	public List<HeadingModel> HeadingList {Get;set;}
      	public List<LineItemModel> LineItemModelList {get;set;}
      	public decimal UnitsAired {Get;set;}
      	public decimal UnitsAvailable {Get;set;}
      	public integer ClearancePercentage {get;set;}
      	public decimal TotalDollars {get;set;}
      	public decimal TotalDollarsBooked {Get;set;}
     	public integer DollarClearancePercentage {get;set;}
     	public Map<Date, Decimal> WeekDollarsMap {get;set;}
      	public List<String> WeekDollarsList {get;set;}
    }
    public class HeadingModel
    {
        public String cols{get;set;}
        public string bgcolor {get;set;}
        public Date startOfWeek {get;set;} 
    }
    public class LineItemModel 
    {
        public boolean isChecked {get;set;}
        public decimal rate {set;get;}
        public string OrderLineNumber {get;set;}
        public String DaysAllowed {get;set;}
        public String SETime {get;set;}
        public Decimal UnitLength  {get;set;}
        public List<weekModel> weeks {get;set;}
        public Boolean Filler {get;set;}
        public Decimal changerate {get;set;}
        public Schedules__c Scheduleobj {get;set;}
        public Date DayValue {get;set;}
        public Date LowestDate {get;set;}
        public Date HighestDate {get;set;}
        public string UnitsAvailable {Get;set;}
        public LineItemModel()
        {
            isChecked = false;
            weeks = new List<weekModel>();
            Scheduleobj = new Schedules__c();
            UnitsAvailable = '0'; 
            
        }
    }
    public class WeekModel 
    {
        public Date startOfWeek {get;set;}
        public Schedules__c schObj{get;set;}
        public string color {get;set;}
        public Decimal changerate {get;set;}
        public Boolean CellAvailable {get;set;}
        public Boolean ExtensionAvailable {Get;set;}
        public string OrderLineNumber {get;set;}
        public string ExtensionDate {Get;set;}
        public Boolean MultipleSchedules {Get;set;}
        public weekModel(Date pstartOfWeek , Schedules__c pschObj, Boolean pMultipleSchedules)
        {
          	MultipleSchedules = pMultipleSchedules;
         	ExtensionDate = string.valueOf(pStartOfWeek.Year()) + '-' + String.valueOf(pStartOfWeek.month()) + '-' + String.valueOf(pStartOfWeek.day());
          	ExtensionAvailable = false;
          	CellAvailable = true;
            startOfWeek = pstartOfWeek; 
            schObj = pschObj;
            if(schObj.Status__c == 'Canceled')
            {
                color ='red';
            }       
            else if(schObj.Test__c == true)
            {
                color='blue';
            }
            else
            {
                color='black';    
            }
            if (pschObj.Week__c < Date.Today().ToStartOfWeek().addDays(1))
            {
              	CellAvailable = false;
            }
        }
        public weekmodel(Date pstartOfWeek, string pOrderLineNumber)
        {
            ExtensionDate = string.valueOf(pStartOfWeek.Year()) + '-' + String.valueOf(pStartOfWeek.month()) + '-' + String.valueOf(pStartOfWeek.day());
          	startOfWeek = pstartOfWeek;  
            CellAvailable = false;   
            if (pStartOfWeek >= Date.Today().ToStartOfWeek().addDays(1))
            {
              	ExtensionAvailable = true;
            }
            else
            {
              	ExtensionAvailable = false;
            }
            OrderLineNumber = pOrderLineNUmber;
        }
    }
}