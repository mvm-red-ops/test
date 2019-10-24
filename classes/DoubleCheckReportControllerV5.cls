public class DoubleCheckReportControllerV5 
{
    public List<string> testlist;
    public set<string> testset;
    public List<List<SObject>> DealSearchList;
    public List<WeekModel> quarterweek {get;set;}
    public List<HeadingModel> headingModels {get;set;}
    public list<date> quarterdates {get;set;}
    public List<Deal__c> DealResultList {get;set;}
    public List<rateModel> ratelist {get;set;}
    public List<RateModel> fillerlist {get;set;}
    public List<RateModel> LTClist {get;set;}
    public List<RateModel> ExtensionList {Get;set;}
    public List<RateModel> UnitsAvailableList {Get;set;}
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
    public Date LowestDate {get;set;}
    public Date HighestDate {get;set;}
    public Date QuarterEndDate {get;set;}
    public Schedules__c DummySchedule1 {get;set;}
    public Schedules__c DummySchedule2 {get;set;}
    public Schedules__c DummySchedule3 {get;set;}
    public Schedules__c DummySchedule4 {get;set;}
    public Schedules__c DummySchedule5 {get;set;}
 	public string SelectedExtensionDate {get;set;}
 	public string SelectedOrderLineNumber {get;set;}
 	public string SelectedFiller {Get;set;}
    public Boolean BarterCheckbox {get;set;}
    public String SelectedCableSynd {get;set;}
   	public List<SelectOption> CableSyndSOList {Get;set;}
    
    public Schedules__c WeekStartDate {get;set;}
   	public Schedules__c WeekEndDate {Get;set;}
   	public List<SelectOption> DateLiteralSOList {Get;set;}
   	public String SelectedDateLiteral {Get;set;}
   	public string SOQLDateString {get;set;}
   	
   	public Map<String, FiscalYearSettings> FiscalMap = new Map<String, FiscalYearSettings>();
    public FiscalYearSettings CurrentFY;
	public Period CurrentFP;
	public Period CurrentFW;
	public Period CurrentFM;
   	public Map<String, Map<Integer, Period>> QuarterPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> WeekPeriodMap = new Map<String, Map<Integer, Period>>();
    public Map<String, Map<Integer, Period>> MonthPeriodMap = new Map<String, Map<Integer, Period>>();
        	    	    	
    public string PreselectedDealId {get;set;}
    public List<String> WeekDollarsList {get;set;}
    public List<HeadingModel> HeadingList {Get;set;}
      	
   	public DoubleCheckReportControllerV5 ()
    { 
        SaveDescision   ='';
        selectAll = false;
        CableSyndSOList = new List<SelectOption>();
        CableSyndSOList.add(new SelectOption('','Please Select'));
        CableSyndSOList.add(new SelectOption('Cable','Cable'));
        CableSyndSOList.add(new SelectOption('Syndication','Syndication'));
        CableSyndSOList.add(new SelectOption('PP','PP'));
    	SelectedCableSynd = '';
    	
    	WeekStartDate = new Schedules__c();
        WeekEndDate = new Schedules__c();
        DateLiteralSOList = new List<SelectOption>();
        DateLiteralSOList.add(new SelectOption('','Please Select'));
        DateLiteralSOList.add(new SelectOption('Custom','Custom'));
        DateLiteralSOList.add(new SelectOption('Fiscal Year', 'Fiscal Year', true));
        DateLiteralSOList.add(new SelectOption('Current FY', 'Current FY'));
        DateLiteralSOList.add(new SelectOption('Previous FY', 'Previous FY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 FY', 'Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('2 FY Ago', '2 FY Ago'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FY', 'Current And Previous FY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 FY', 'Current And Previous 2 FY'));
        DateLiteralSOList.add(new SelectOption('Fiscal Quarter', 'Fiscal Quarter', true));
        DateLiteralSOList.add(new SelectOption('Current FQ','Current FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next FQ','Current And Next FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FQ','Current And Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Next FQ','Next FQ'));
        DateLiteralSOList.add(new SelectOption('Previous FQ', 'Previous FQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 FQ', 'Current And Next 3 FQ'));
        DateLiteralSOList.add(new SelectOption('Fiscal Period', 'Fiscal Period', true));
       	DateLiteralSOList.add(new SelectOption('Last FP', 'Last FP'));
        DateLiteralSOList.add(new SelectOption('This FP', 'This FP'));
        DateLiteralSOList.add(new SelectOption('Next FP', 'Next FP'));
        DateLiteralSOList.add(new SelectOption('Current And Previous FP', 'Current And Previous FP'));
        DateLiteralSOList.add(new SelectOption('Current And Next FP', 'Current And Next FP'));
        DateLiteralSOList.add(new SelectOption('Fiscal Week', 'Fiscal Week', true));
       	DateLiteralSOList.add(new SelectOption('Last FW', 'Last FW'));
        DateLiteralSOList.add(new SelectOption('This FW', 'This FW'));
        DateLiteralSOList.add(new SelectOption('Next FW', 'Next FW'));
        DateLiteralSOList.add(new SelectOption('Calendar Year', 'Calendar Year', true));
       	DateLiteralSOList.add(new SelectOption('Current CY', 'Current CY'));
        DateLiteralSOList.add(new SelectOption('Previous CY', 'Previous CY'));
        DateLiteralSOList.add(new SelectOption('Previous 2 CY', 'Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('2 CY Ago', '2 CY Ago'));
        DateLiteralSOList.add(new SelectOption('Next CY', 'Next CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CY', 'Current And Previous CY'));
        DateLiteralSOList.add(new SelectOption('Current And Previous 2 CY', 'Current And Previous 2 CY'));
        DateLiteralSOList.add(new SelectOption('Current And Next CY', 'Current And Next CY'));
        DateLiteralSOList.add(new SelectOption('Current Quarter', 'Current Quarter', true));
       	DateLiteralSOList.add(new SelectOption('Current CQ', 'Current CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next CQ', 'Current And Next CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Previous CQ', 'Current And Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Next CQ', 'Next CQ'));
        DateLiteralSOList.add(new SelectOption('Previous CQ', 'Previous CQ'));
        DateLiteralSOList.add(new SelectOption('Current And Next 3 CQ', 'Current And Next 3 CQ'));
        DateLiteralSOList.add(new SelectOption('Calendar Month', 'Calendar Month', true));
       	DateLiteralSOList.add(new SelectOption('Last Month','Last Month'));
        DateLiteralSOList.add(new SelectOption('This Month','This Month'));
        DateLiteralSOList.add(new SelectOption('Next Month','Next Month'));
        DateLiteralSOList.add(new SelectOption('Current And Last Month', 'Current And Last Month'));
        DateLiteralSOList.add(new SelectOption('Current And Next Month', 'Current And Next Month'));
        DateLiteralSOList.add(new SelectOption('Calendar Week', 'Calendar Week', true));
       	DateLiteralSOList.add(new SelectOption('Last Week','Last Week'));
        DateLiteralSOList.add(new SelectOption('This Week','This Week'));
        DateLiteralSOList.add(new SelectOption('Next Week','Next Week'));
        DateLiteralSOList.add(new SelectOption('Day', 'Day', true));
       	DateLiteralSOList.add(new SelectOption('Yesterday','Yesterday'));
        DateLiteralSOList.add(new SelectOption('Today','Today'));
        DateLiteralSOList.add(new SelectOption('Tomorrow','Tomorrow'));
        DateLiteralSOList.add(new SelectOption('Last 7 Days','Last 7 Days'));
        DateLiteralSOList.add(new SelectOption('Last 30 Days','Last 30 Days'));
        DateLiteralSOList.add(new SelectOption('Last 60 Days','Last 60 Days'));
        DateLiteralSOList.add(new SelectOption('Last 90 Days','Last 90 Days'));
        DateLiteralSOList.add(new SelectOption('Last 120 Days','Last 120 Days'));
        DateLiteralSOList.add(new SelectOption('Next 7 Days','Next 7 Days'));
        DateLiteralSOList.add(new SelectOption('Next 30 Days','Next 30 Days'));
        DateLiteralSOList.add(new SelectOption('Next 60 Days','Next 60 Days'));
        DateLiteralSOList.add(new SelectOption('Next 90 Days','Next 90 Days'));
        DateLiteralSOList.add(new SelectOption('Next 120 Days','Next 120 Days'));
        
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
    	for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Quarter'])
    	{
    		if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today())
    		{
    			CurrentFP = PR;
    			system.debug('CurrentFP - ' + CurrentFP.StartDate + ' - ' + CurrentFP.EndDate);
    		}
    		if (QuarterPeriodMap.containsKey(PR.FiscalYearSEttings.Name))
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = QuarterPeriodMap.get(PR.FiscalYearSettings.Name);
    			TempQuarterPeriodMap.put(PR.Number, PR);
    			QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    		else
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
    			TempQuarterPeriodMap.put(PR.Number, PR);
    			QuarterPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    	}
    	
    	for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number from Period where Type = 'Week'])
    	{
    		if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today())
    		{
    			CurrentFW = PR;
    			system.debug('CurrentFW - ' + CurrentFW.StartDate + ' - ' + CurrentFW.EndDate);
    		}
    		if (WeekPeriodMap.containsKey(PR.FiscalYearSEttings.Name))
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = WeekPeriodMap.get(PR.FiscalYearSettings.Name);
    			TempQuarterPeriodMap.put(PR.Number, PR);
    			WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    		else
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
    			TempQuarterPeriodMap.put(PR.Number, PR);
    			WeekPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    	}
    	
    	for (Period PR : [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month'])
    	{
    		if (PR.StartDate <= Date.Today() && PR.EndDate >= Date.Today())
    		{
    			CurrentFM = PR;
    			system.debug('CurrentFM - ' + CurrentFM.StartDate + ' - ' + CurrentFM.EndDate);
    		}
    		if (MonthPeriodMap.containsKey(PR.FiscalYearSEttings.Name))
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = MonthPeriodMap.get(PR.FiscalYearSettings.Name);
    			if (PR.Number == null)
    			{
    				TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
    			}
    			else
    			{
    				TempQuarterPeriodMap.put(PR.Number, PR);
    			}
    			MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    		else
    		{
    			Map<Integer, Period> TempQuarterPeriodMap = new Map<Integer, Period>();
    			if (PR.Number == null)
    			{
    				TempQuarterPeriodMap.put(ReturnNumber(PR.PeriodLabel), PR);
    			}
    			else
    			{
    				TempQuarterPeriodMap.put(PR.Number, PR);
    			}
    			MonthPeriodMap.put(PR.FiscalYearSettings.Name, TempQuarterPeriodMap);
    		}
    	}
    	
    	if (ApexPages.CurrentPage().getParameters().containsKey('DealId'))
    	{
    		PreselectedDealId = ApexPages.CurrentPage().getParameters().get('DealId');
    		Deal__c PreselectedDeal = [select Id, Name from Deal__c where Id =: PreselectedDealId];
    		SearchField = PreselectedDeal.Name;
    		BarterCheckbox = false;
    		SelectedCableSynd = '';
    		SelectedDateLiteral = '';
    		DoSearch();
    		DEalId = PreselectedDealId;
    		SearchforSchedules();
    	}
    }
    public string ReturnStringDate(Date pDate)
	{
		string pString = String.valueOf(pDate.Year()) + '-';
		if (pDate.month() < 10)
		{
			pString += '0' + String.valueOf(pDate.month()) + '-';
		}
		else
		{
			pString += String.valueOf(pDate.month()) + '-';
		}
		if (pDate.day() < 10)
		{
			pString += '0' + String.valueOf(pDate.day());
		}
		else
		{
			pString += String.valueOf(pDate.day());
		}
		return pString;
	}
	public integer ReturnNumber(String pMonth)
    {
    	if (pMonth.toLowerCase() == 'jan')
    	{
    		return 1;
    	}
    	else if (pMonth.ToLowerCase() == 'feb')
    	{
    		return 2;
    	}
    	else if (pMonth.ToLowerCase() == 'mar')
    	{
    		return 3;
    	}
    	else if (pMonth.ToLowerCase() == 'apr')
    	{
    		return 4;
    	}
    	else if (pMonth.ToLowerCase() == 'may')
    	{
    		return 5;
    	}
    	else if (pMonth.ToLowerCase() == 'jun')
    	{
    		return 6;
    	}
    	else if (pMonth.ToLowerCase() == 'jul')
    	{
    		return 7;
    	}
    	else if (pMonth.ToLowerCase() == 'aug')
    	{
    		return 8;
    	}
    	else if (pMonth.ToLowerCase() == 'sep')
    	{
    		return 9;
    	}
    	else if (pMonth.ToLowerCase() == 'oct')
    	{
    		return 10;
    	}
    	else if (pMonth.ToLowerCase() == 'nov')
    	{
    		return 11;
    	}
    	else 
    	{
    		return 12;
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
        				SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
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
        					NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
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
        					NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
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
        					NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
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
        					NumberMonth = ReturnNumber(CurrentFM.PeriodLabel);
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
        		else if (SelectedDateLiteral == 'Current CY')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = THIS_YEAR ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year(), 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12,31);
        		}
        		else if (SelectedDateLiteral == 'Previous CY')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_YEAR ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() - 1, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year() - 1, 12,31);
        		}
        		else if (SelectedDateLiteral == 'Previous 2 CY')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 ) ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() - 2, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year() -1, 12,31);
        		}
        		else if (SelectedDateLiteral == '2 CY Ago')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_YEARS:2 ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() - 2, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year() -2, 12,31);
        		}
        		else if (SelectedDateLiteral == 'Next CY')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_YEAR ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() +1, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year() +1, 12,31);
        		}
        		else if (SelectedDateLiteral == 'Current And Previous CY')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = LAST_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() -1, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12,31);
        		}
        		else if (SelectedDateLiteral == 'Current And Previous 2 CY')
        		{
        			SOQLDateString = ' AND  ( Week_MIN_Field__c = LAST_YEAR OR Week_Min_Field__c = LAST_N_YEARS:2 OR Week_MIN_Field__c = THIS_YEAR ) ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() -2, 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12,31);
        		}
        		else if (SelectedDateLiteral == 'Current And Next CY')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = NEXT_YEAR OR Week_MIN_Field__c = THIS_YEAR ) ';
        			WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        			WeekEndDate.Day__c = Date.newInstance(Date.Today().year() + 1, 12,31);
        		}
        		else if (SelectedDateLiteral == 'Current CQ')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = THIS_QUARTER ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 3, 31);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 6, 30);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 9, 30);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12, 31);
        			}
        		}
        		else if (SelectedDateLiteral == 'Current And Next CQ')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_QUARTER ) ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 6, 30);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 9, 30);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12, 31);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() + 1, 3, 31);
        			}
        		}
        		else if (SelectedDateLiteral == 'Current And Previous CQ')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = LAST_QUARTER ) ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 3, 31);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 6, 31);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 9, 30);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() , 12, 31);
        			}
        		}
        		else if (SelectedDateLiteral == 'Next CQ')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_QUARTER ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 6, 30);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 9, 30);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 12, 31);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() + 1 , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() , 3, 31);
        			}
        		}
        		else if (SelectedDateLiteral == 'Previous CQ')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_QUARTER ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() -1, 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() - 1, 12, 31);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 3, 31);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year(), 6, 30);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year()  , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() , 9, 30);
        			}
        		}
        		else if (SelectedDateLiteral == 'Current And Next 3 CQ')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_QUARTER OR Week_MIN_Field__c = NEXT_N_QUARTERS:3 ) ';
        			if (Date.Today().month() >=1 && Date.Today().month() <= 3)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 1, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() , 12, 31);
        			}
        			else if (Date.Today().month() >=4 && Date.Today().month() <= 6)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 4, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year()+ 1, 3, 31);
        			}
        			else if (Date.Today().month() >=7 && Date.Today().month() <= 9)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year() , 7, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() + 1, 6, 30);
        			}
        			else if (Date.Today().month() >=10 && Date.Today().month() <= 12)
        			{
        				WeekStartDate.Day__c = Date.newInstance(Date.Today().year()  , 10, 1);
        				WeekEndDate.Day__c = Date.newInstance(Date.Today().year() + 1 , 9, 30);
        			}
        		}
        		else if (SelectedDateLiteral == 'Last Month')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_MONTH ';
        			WeekStartDate.Day__c = Date.Today().addmonths(-1).ToStartOfMOnth();
        			WeekEndDate.Day__C = Date.Today().ToStartOfMonth().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'This Month')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = THIS_MONTH ';
        			WeekStartDate.Day__c = Date.Today().ToStartOfMOnth();
        			WeekEndDate.Day__C = Date.Today().addmonths(1).ToStartOfMonth().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'Next Month')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_MONTH ';
        			WeekStartDate.Day__c = Date.Today().addmonths(1).ToStartOfMOnth();
        			WeekEndDate.Day__C = Date.Today().addmonths(2).ToStartOfMonth().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'Current And Last Month')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = LAST_MONTH ) ';
        			WeekStartDate.Day__c = Date.Today().addmonths(-1).ToStartOfMOnth();
        			WeekEndDate.Day__C = Date.Today().addmonths(1).ToStartOfMonth().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'Current And Next Month')
        		{
        			SOQLDateString = ' AND ( Week_MIN_Field__c = THIS_MONTH OR Week_MIN_Field__c = NEXT_MONTH ) ';
        			WeekStartDate.Day__c = Date.Today().ToStartOfMOnth();
        			WeekEndDate.Day__C = Date.Today().addmonths(2).ToStartOfMonth().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'Last Week')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_WEEK ';
        			WeekStartDate.Day__c = Date.Today().toStartOfWeek().addDays(-7);
        			WeekEndDate.Day__C = Date.Today().toStartOfWeek().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'This Week')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = THIS_WEEK ';
        			WeekStartDate.Day__c = Date.Today().toStartOfWeek();
        			WeekEndDate.Day__C = Date.Today().toStartOfWeek().addDays(6);
        		}
        		else if (SelectedDateLiteral == 'Next Week')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_WEEK ';
        			WeekStartDate.Day__c = Date.Today().addDays(7).ToStartOfWeek();
        			WeekEndDate.Day__C = Date.Today().addDays(7).ToStartOfWeek().addDays(6);
        		}
        		else if (SelectedDateLiteral == 'Yesterday')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = YESTERDAY ';
        			WeekStartDate.Day__c = Date.Today().addDays(-1);
        			WeekEndDate.Day__C = Date.Today().addDays(-1);
        		}
        		else if (SelectedDateLiteral == 'Today')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = TODAY ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Tomorrow')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = TOMORROW ';
        			WeekStartDate.Day__c = Date.Today().addDays(1);
        			WeekEndDate.Day__C = Date.Today().addDays(1);
        		}
        		else if (SelectedDateLiteral == 'Last 7 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:7 ';
        			WeekStartDate.Day__c = Date.Today().addDays(-7);
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Last 30 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:30 ';
        			WeekStartDate.Day__c = Date.Today().addDays(-30);
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Last 60 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:60 ';
        			WeekStartDate.Day__c = Date.Today().addDays(-60);
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Last 90 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:90 ';
        			WeekStartDate.Day__c = Date.Today().addDays(-90);
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Last 120 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = LAST_N_DAYS:120 ';
        			WeekStartDate.Day__c = Date.Today().addDays(-120);
        			WeekEndDate.Day__C = Date.Today();
        		}
        		else if (SelectedDateLiteral == 'Next 7 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:7 ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today().addDays(7);
        		}
        		else if (SelectedDateLiteral == 'Next 30 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:30 ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today().addDays(30);
        		}
        		else if (SelectedDateLiteral == 'Next 60 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:60 ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today().addDays(60);
        		}
        		else if (SelectedDateLiteral == 'Next 90 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:90 ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today().addDays(90);
        		}
        		else if (SelectedDateLiteral == 'Next 120 Days')
        		{
        			SOQLDateString = ' AND Week_MIN_Field__c = NEXT_N_DAYS:120 ';
        			WeekStartDate.Day__c = Date.Today();
        			WeekEndDate.Day__C = Date.Today().addDays(120);
        		}
        	}
        	if (WeekStartDate.Day__c != null && WeekEndDate.Day__c != null)
        	{
        		SOQLDateString = ' AND ( Week_MIN_Field__c >= ' + ReturnStringDate(WeekStartDate.Day__c) + ' AND Week_MIN_Field__c <= ' + ReturnStringDate(WeekEndDate.Day__c) + ' ) ';
        	}
        	else
        	{
        		SOQLDateString = '';
        	}
        	system.debug('Start And End Dates - ' + WeekStartDate.Day__c + ' - ' + WeekEndDate.Day__c);
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));       
        }  
	}
    public void DoSearch()
    {
        try
        {
            DealResultList = new List<Deal__c>();
            SearchList = new List<string>();
            map<id,Deal__c> MapofFinalDeals = new map<id,Deal__c>();
            Map<Integer,set<id>> Accurancy = new Map<Integer, set<id>>();
            ReturnSOQLDateString();
            if(Searchfield != null && Searchfield  !='')
            {
                searchField = SearchField.replace(' , ',',').replace(' ,',',').replace(', ',',');
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
                        
                        String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,' 
                                                + 'Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,'
                                                + 'Program__r.Name ' 
                                            	+ ' From Deal__c '
                                            	+ ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                                + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\''
                                                + ' OR Name Like \'' + tempstringListLoop + '\' ) AND Week_MIN_Field__c != null '
                                                + SOQLDateString;
                        if (BarterCheckbox)
                        {
                        	DealQuery += ' AND Program__r.Barter__c = True ';
                        }                       
                        if (SelectedCableSynd != '' && SelectedCableSynd != null)
                        {
                        	DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                        }
                        DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 1000';
                        
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
                        } 
                    }   
                    integer count=0;
                    /*for(integer i =  Accurancy.size(); i>0; i--)
                    {
                        for(Id MapofDeals : Accurancy.get(i))
                        {
                            if (Count < 200)
                        	{
                        		DealResultList.add(MapofFinalDeals.get(mapofdeals));
                        		count++;
                        	}       
                        }  
                    }*/
                    if (Accurancy.containsKey(SearchList.size()))
                    {
                      	for(Id MapofDeals : Accurancy.get(SearchList.size()))
                      	{
                           	if (Count < 200)
                        	{
                        		DealResultList.add(MapofFinalDeals.get(mapofdeals)); 
                        		count++;
                        	}      
                      	}  
                    }  
                }
                else
                {
                    string tempstringListLoop = '%'+SearchList[0] +'%';
                    
                    
                    String DealQuery = 'SELECT Id,Program__c,Contact__c,Client_Account__c,Brands__c,Name, Length__c, Campaign__c,Week_MIN_Field__c,Agency_Deal_Number__c,Contact__r.Name,Brands__r.Name,'
                                       		+ ' Network_Deal_Number__c,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c,ContactAccount__c,Week_Max__c, Client_Account__r.Name, Contact__r.Account.id,'
                                            + ' Program__r.Name '
                                            + ' From Deal__c '
                                            + ' Where (Program__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Client_Account__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Contact__r.Account.Name Like \'' + tempstringListLoop + '\'' 
                                            + ' OR Brands__r.Name Like \'' + tempstringListLoop + '\''
                                            + ' OR Network_Deal_Number__c Like \'' + tempstringListLoop + '\'' 
                                            + ' OR Name Like \'' + tempstringListLoop + '\' )  AND Week_MIN_Field__c != null '
                                            + SOQLDateString;
                    if (BarterCheckbox)
                    {
                    	DealQuery += ' AND Program__r.Barter__c = True ';
                    }                       
                    if (SelectedCableSynd != '' && SelectedCableSynd != null)
                    {
                    	DealQuery += ' AND Program__r.Cable_Synd__c = \'' + SelectedCableSynd + '\'';
                    }
                    DealQuery += 'ORDER BY Week_MIN_Field__c DESC limit 200';                        
                    System.debug('DealQuery - ' + DealQuery);
                    List<Deal__c> DealList = Database.query(DealQuery);
                    for(Deal__c dlist : DealList )
                    {
                        DealResultList.add(dlist);
                    }   
                }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Search field can not be null'  ));    
            }  
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
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));       
        }     
    }
    
    public void SearchforSchedules()
    {
        try
        {
            testlist= new List<string>();
            testset = new set<string>(); 
            ratelist = new List<rateModel>();
            fillerlist = new List<RateModel>();
            UnitsAvailableList = new List<RateModel>();
            LTClist = new List<RateModel>();
            ExtensionList = new List<RateModel>();
            DummySchedule1 = new Schedules__c();
            DummySchedule2 = new Schedules__c();
            DummySchedule3 = new Schedules__c();
            DummySchedule4 = new Schedules__c();
            DummySchedule5 = new Schedules__c();
            map<string,List<Schedules__c>> schgroup = new map<string,List<Schedules__c>>(); 
            Map<Date, Decimal> WeekDollarsMap = new Map<Date, Decimal>();
            LowestDate = Date.newInstance(3000,1,1);
            HighestDate = Date.newInstance(1000,1,1);
            /*for(Schedules__c schlist : [SELECT Id,Name, OrderNumber__c,Days_Allowed__c,Start_End_Time__c,UnitLength__c,Rate__c,Filler__c,Deal_Parent__c,Units_Available__c,Week__c,
                                            Test__c,Status__c,Start_Time__c,MilitaryTime__c,Day__c,DaysAllowedFormula__c,Deal_Parent__r.Week_MIN_Field__c
                                        From Schedules__c
                                        WHERE  Deal_Parent__c=:DealId
                                        ORDER BY MilitaryTime__c  , Rate__c 
                                        ]) */
                                        
            for (Schedules__c schlist : Database.query('Select ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' from Schedules__c where Deal_Parent__c = \'' + DealId + '\' ORDER BY MilitaryTime__c, Rate__c' ))
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
            List<Deal__c> DealList = [select Id,Sum_of_Total_Dollars__c,Sum_of_Units_Available__c, Program__r.Name, Brands__r.Name, Name, Week_MIN_Field__c from Deal__c where Id =: DealId];
            if (DealList.size() > 0)
            {
                ListOfDates(DealList[0].Week_MIN_Field__c); 
                SelectedDeal = DealList[0];
            }
            system.debug('Final Lowest Date - ' + LowestDate);
            for(string mapkeylist : testlist ) 
            {
                List<Schedules__c> tempwraplist = schgroup.get(mapkeylist); 
                RateModel Lm = new RateModel();
                RateModel Fm = new RateModel();
                RateModel rm = new RateModel();
                RateModel EM = new RateModel();
                RateModel UM = new RateModel();
                Lm.OrderLineNumber = mapkeylist;
                Fm.OrderLineNumber = mapkeylist;
                rm.OrderLineNumber = mapkeylist;
                EM.OrderLineNumber = mapKeyList;
                UM.OrderLineNumber = mapKeyList;
                if(tempwraplist[0].Rate__c != 0 || tempwraplist[0].Rate__c != null)
                {
                    Lm.rate = string.valueof(tempwraplist[0].Rate__c);
                    Fm.rate = string.valueof(tempwraplist[0].Rate__c);
                    rm.rate = string.valueof(tempwraplist[0].Rate__c);
                    EM.rate = String.valueOf(tempWrapList[0].Rate__c);
                    UM.rate = string.valueOf(tempWrapList[0].Rate__c);
                }
                else
                {
                    Lm.rate = '0';  
                    Fm.rate = '0';
                    rm.rate = '0';  
                    EM.rate = '0';
                    UM.rate = '0';
                }
                Lm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                Lm.SETime = tempwraplist[0].Start_End_Time__c;
                Lm.UnitLength = tempwraplist[0].UnitLength__c;
                Fm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                Fm.SETime = tempwraplist[0].Start_End_Time__c;
                Fm.UnitLength = tempwraplist[0].UnitLength__c;
                rm.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                rm.SETime = tempwraplist[0].Start_End_Time__c;
                rm.UnitLength = tempwraplist[0].UnitLength__c;
                EM.DaysAllowed = tempwraplist[0].DaysAllowedFormula__c;
                EM.SeTime = tempwrapList[0].Start_End_Time__c;
                EM.UnitLength = tempwrapList[0].UnitLength__c;
                UM.DaysAllowed = tempWrapList[0].DaysAllowedFormula__c;
                UM.SeTime = tempWrapList[0].Start_End_Time__c;
                UM.UnitLength = tempWrapList[0].UnitLength__c;
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
                            Fm.Filler = true;
                            rm.Filler = true;
                            EM.Filler = true;
                            UM.Filler = true;
                        }   
                    } 
                }
                RM.LowestDate = RMLowestDate;
                FM.LowestDate = RMLowestDate;
                LM.LowestDate = RMLowestDate;
                EM.LowestDate = RMLowestDate;
                UM.LowestDate = RMLowestDate;
                RM.HighestDate = RMHighestDate;
                FM.HighestDate = RMHighestDate;
                LM.HighestDate = RMHighestDate;
                EM.HighestDate = RMHighestDate;
                EM.HighestDate = RMHighestDate;
                Map<Date,Schedules__c> weekMap = new Map<Date,Schedules__c>(); 
                Map<Date, Boolean> DuplicateWeekMap = new Map<Date, Boolean>();
                for(Schedules__c schtemp:tempwraplist )
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
	                                Fm.weeks.add(new weekModel(sow,weekmap.get(sow), true)); 
	                                rm.weeks.add(new weekModel(sow,weekmap.get(sow), true));    
	                                EM.Weeks.add(new WeekModel(sow,weekmap.get(sow), true));
	                                UM.Weeks.add(new WeekModel(sow,WeekMap.get(sow), true));
                            	}
                            	else
                            	{
	                                Lm.weeks.add(new weekModel(sow,weekmap.get(sow), false)); 
	                                Fm.weeks.add(new weekModel(sow,weekmap.get(sow), false)); 
	                                rm.weeks.add(new weekModel(sow,weekmap.get(sow), false));    
	                                EM.Weeks.add(new WeekModel(sow,weekmap.get(sow), false));
	                                UM.Weeks.add(new WeekModel(sow,WeekMap.get(sow), false));
                            	}
                            }
                            else
                            {
                                Lm.weeks.add(new weekModel(sow,tempwraplist[0].OrderNumber__c)); 
                                Fm.weeks.add(new weekModel(sow,tempwraplist[0].OrderNumber__c));
                                rm.weeks.add(new weekModel(sow,tempwraplist[0].OrderNumber__c));
                                EM.weeks.add(new WeekModel(sow,tempwraplist[0].OrderNumber__c));   
                                UM.Weeks.add(new WeekModel(sow,tempWrapList[0].OrderNumber__c)); 
                            }
                        }
                    }
                }
                List<String> TempWeekDollarsList = new List<String>();
              	//HeadingList = ListOfDates(DealList[0].Week_MIN_Field__c, DealList[0].Program__r.Reconciled_Week__c); 
              	for (headingModel HM : headingModels)
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
              	WeekDollarsList = TempWeekDollarsList;
                ratelist.add(rm);
                Fillerlist.add(Fm);
                LTClist.add(Lm);
                ExtensionList.add(EM);
                UnitsAvailableList.add(UM);
                Display();
            }
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));       
        }  
    }
    public void Display()
    {
        if(ratelist.size() == 0 )
        {
            schedulemessage = true;
            showtable = false;
        }
        else
        {
            showtable = true;
            schedulemessage = false;    
        }    
    }
    public void ListOfDates(Date pAnchorDate)
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
                ListOfDates(AnchorDate.addDays(7));
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
                    system.debug('date compare - ' + sow + ' - ' + LowestDate + ' - ' + (SOW >= LowestDate));
                    if (sow >= LowestDate)
                    {
                        headingModels.add(hm);
                    }
                }
            }
            
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
   
    public void ScheduleChange()
    {
        try
        {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            for(RateModel rate : LTClist )
            {
                if(rate.ischecked)
                {
                    if(rate.Scheduleobj.Day__c != null )
                    {
                    	if (rate.ScheduleObj.Day__c < Date.Today().ToStartOfWeek().addDays(1))
                    	{
                    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERror, 'Past weeks cannot be cancelled'));
                    	}
                    	else
                    	{
	                        for(WeekModel weekobj :rate.weeks)
	                        {
	                            if(weekobj.schObj != null)
	                            {
	                                if(weekobj.schObj.week__c >= rate.Scheduleobj.Day__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1) )
	                                {
	                                    weekobj.schObj.Status__c  = 'Canceled'; 
	                                    schtoupdate.add(weekobj.schobj);  
	                                }
	                            }
	                        }  
                    	}
                    }  
                } 
            }
            update schtoupdate; 
            SearchforSchedules();
            SaveDescision  = ''; 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
    public void FillerUpdate()
    {
        try
        {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            for(RateModel rate : FillerList )
            {
                if(rate.isChecked = true)
                {
                    if(rate.Scheduleobj.Day__c != null )
                    {
                    	if (rate.ScheduleObj.Day__c < Date.Today().ToStartOfWeek().addDays(1))
                    	{
                    		ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The Filler cannot be updated for past weeks'));
                    	}
                    	else
                    	{
                        	for(WeekModel weekobj :rate.weeks)
                        	{
                           		if(weekobj.schObj != null)
                           	 	{
                                	if(weekobj.schObj.week__c >= rate.Scheduleobj.Day__c  && weekobj.schObj.week__c >= Date.Today().toStartOfWeek().addDays(1)) //Date.today().toStartofWeek().addDays(1)
                                	{
                                    	weekobj.schObj.Filler__c = true; 
                                    	schtoupdate.add(weekobj.schobj);           
                                	}
                            	}
                        	}
                    	}
                    }    
                } 
            }
            update schtoupdate; 
            SearchforSchedules();
            SaveDescision  = ''; 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
    
    public void RateUpdate()
    {
        try
        {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            for(RateModel rate : rateList)
            {
                system.debug('rate 501 - ' + rate.OrderLineNumber);
                if(rate.ischecked)
                {
                    system.debug('rate 504 checked - ' + rate.OrderLineNumber + ' - ' + rate.rate + ' - ' + rate.Scheduleobj.Day__c);
                    if(rate.Scheduleobj.Day__c != null )
                    {
                    	if (rate.ScheduleObj.Day__c < Date.Today().toStartOfWeek().addDays(1))
                    	{
                    		ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'The rate cannot be updated for past weeks'));
                    	}
                    	else
                    	{
	                        system.debug('rate 508 Day not null - ' + rate.OrderLineNumber);
	                        for(WeekModel weekobj :rate.weeks)
	                        {
	                            if(weekobj.schObj != null)
	                            {
	                                system.debug('rate 514 schobj not null - ' + rate.OrderLineNumber + ' - ' + weekobj.schObj.Id);
	                                if(weekobj.schObj.week__c >= rate.Scheduleobj.Day__c  && weekobj.SchObj.week__c >= Date.Today().toStartOfWeek().addDays(1))
	                                {
	                                    weekobj.schObj.Rate__c = Decimal.valueof(rate.rate); 
	                                    system.debug('Rate updated - ' + weekobj.schObj.Id + ' - ' + weekobj.schObj.Rate__c);
	                                    schtoupdate.add(weekobj.schobj);          
	                                }
	                            }
	                        } 
                    	}
                    }   
                } 
            }
            update schtoupdate; 
            system.debug('schtoupdate size - ' + schtoupdate.size());
            SearchforSchedules();
            SaveDescision  = ''; 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
    public void UnitsAvailableUpdate()
    {
        try
        {
            List<Schedules__c> schtoupdate = new List<Schedules__c>();
            for(RateModel rate : UnitsAvailableList)
            {
                if(rate.ischecked)
                {
                    if(rate.Scheduleobj.Day__c != null )
                    {
                    	if (rate.ScheduleObj.Day__c < Date.Today().toStartOfWeek().addDays(1))
                    	{
                    		ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Units Available cannot be updated for past weeks'));
                    	}
                    	else
                    	{
	                        for(WeekModel weekobj :rate.weeks)
	                        {
	                            if(weekobj.schObj != null)
	                            {
	                                if(weekobj.schObj.week__c >= rate.Scheduleobj.Day__c  && weekobj.SchObj.week__c >= Date.Today().toStartOfWeek().addDays(1))
	                                {
	                                    weekobj.schObj.units_Available__c = decimal.valueOf(rate.UnitsAvailable);  
	                                    schtoupdate.add(weekobj.schobj);          
	                                }
	                            }
	                        } 
                    	}
                    }   
                } 
            }
            update schtoupdate; 
            SearchforSchedules();
            SaveDescision  = ''; 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
    public void ExtensionUpdate()
    {
        try
        {
            List<Schedules__c> NewSchedulesToInsert = new List<Schedules__c>();
            for(RateModel rate : ExtensionList )
            {
                if(rate.isChecked = true)
                {
                    system.debug('rate.Scheduleobj.Day__c - ' + rate.ScheduleObj.Day__c);
                    if(rate.Scheduleobj.Day__c != null )
                    {
                        system.debug('date values - ' + rate.ScheduleObj.Day__c + ' - ' + rate.HighestDate);
                        if (rate.ScheduleObj.Day__c < Date.Today().toStartOfWeek().addDays(1))
                        {
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Extensions cannot be created for past weeks'));
                        }
                        else if (rate.ScheduleObj.Day__c > QuarterEndDate)
                        {
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Extensions cannot be created for weeks that extend beyond the last week of the quarter'));
                        }
                        else
                        {
	                        if (rate.ScheduleObj.Day__c > rate.HighestDate )
	                        {
	                            Boolean ScheduleFound = false;
	                            integer WeekSize = rate.Weeks.size() - 1;
	                            Schedules__c CloneSchedule;
	                            while (!ScheduleFound)
	                            {
	                                if (rate.weeks[WeekSize].schObj != null)
	                                {
	                                    ScheduleFound = true;
	                                    CloneSchedule = rate.Weeks[weekSize].schObj;
	                                }
	                                else
	                                {
	                                    WeekSize = WeekSize - 1;
	                                }
	                            }
	                            system.debug('comes inside end date - ' + endDate + ' - ' + QuarterEndDate);
	                            if (CloneSchedule != null)
	                            {
	                            	if (CloneSchedule.week__c.addDays(7) <= rate.ScheduleObj.Day__c)
	                            	{
		                                //Change the Date.TOday().ToStartOfWeek().addDays(1) to HighestDate
		                                for (Date StartDate = CloneSchedule.week__c.addDays(7); StartDate <= rate.ScheduleObj.Day__c && StartDate <= QuarterEndDate; StartDate = StartDate.addDays(7))
		                                { 
		                                    system.debug('Schedule Created - ' + StartDate);
		                                    system.debug('CloneSchedule values - ' + CloneSchedule.Name + ' - ' + CloneSchedule.Week__c);
		                                    sObject NewScheduleObj = (sObject)(CloneSchedule).clone(false, false, false);
		                                    Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);
		                                    NewSCHRecord.Total_Schedules__c	 = '0';	
						                    NewSCHRecord.SI_Number_if_Billed__c = null;
						                    NewSCHRecord.Reviewed_for_Invoicing__c = false;
						                    NewSCHREcord.Intacct_SI_Number__c = null;
						                    NewSCHRecord.Units_Preempted__c = null;
						                    NewSCHRecord.Status__c = 'Sold';
						                    NewSCHRecord.ISCI_CODE__c = null;
						                    NewSCHRecord.X800_Number__c = null;
						                    NewSCHrecord.Days_of_Air__c = null;
						                    newSCHRecord.Pod__c = null;
						                    NewSCHRecord.LF_traffic__c = null;
						                    NewSCHRecord.Comments__c = null;
						                    NewSCHRecord.Error_Cost__c = null;
						                    NewSCHrecord.Error_Logged_To__c = null;
						                    NewSCHRecord.Error_Reason__c = null;
						                    newSCHRecord.Discrepancy_Comment__c = null;
						                    NewSCHRecord.Week__c = StartDate;
						                    NewSCHRecord.Duplicate_Check__c= null;
		                                    NewSchedulesToInsert.add(NewSCHRecord);
		                                }
	                            	}
	                            }
	                        }
                        }
                    }    
                } 
            }
            if (NewSchedulesToInsert.size() > 0)
            {
                insert NewSchedulesToInsert;
            } 
            SearchforSchedules();
            SaveDescision  = ''; 
        }
        catch (Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));        
        }
    }
    public void cellsave()
    {
        try
        {
            if( (CellId != null && CellId != '') && (cellrate != null && cellrate != '') )
            {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schtoupdate.rate__c = Decimal.valueof(cellrate);
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';   
            } 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));    
        }
    }
    public void FillerChecksave()
    {
        try
        {
            if( (CellId != null && CellId != '') && (SelectedFiller != null && SelectedFiller != '') )
            {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                system.debug('Filled values - ' + CellId + ' - ' + SelectedFiller);
                schtoupdate.filler__c = Boolean.valueOf(SelectedFiller);
                upsert schtoupdate;
                SearchforSchedules();
                SelectedFiller ='';   
            } 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));    
        }
    }
    public void UnitsAvailableSave()
    {
        try
        {
            if( (CellId != null && CellId != '') && (cellUnits != null && cellUnits != '') )
            {
                Schedules__c schtoupdate = new Schedules__c(id = CellId);
                schtoupdate.Units_Available__c = Decimal.valueof(cellUnits);
                upsert schtoupdate;
                SearchforSchedules();
                cellUnits ='';   
                
            } 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));    
        }
    }
	public void LTCsave()
    {
        try
        {
            if( (CellId != null && CellId != '') )
            {
                Schedules__c schtoupdate = [select Id, Status__c from Schedules__c where Id =: CellId];
                if (schtoUpdate.status__c == 'Canceled')
                {
                	schtoUpdate.status__c = 'Sold';
                }
                else
                {
                	schtoUpdate.Status__c = 'Canceled';
                }
                upsert schtoupdate;
                SearchforSchedules();
                cellrate ='';   
            } 
        }
        catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));    
        }
    }
    public void ExtensionSave()
    {
    	try
    	{
    		if (SelectedExtensionDate != null && SelectedOrderLineNumber != null && SelectedOrderLineNumber != '')
    		{
    			List<String> StrList = SelectedExtensionDate.split('-');
                Date WeekDate = Date.NewInstance(integer.valueOf(StrList[0]), Integer.valueof(StrList[1]), Integer.valueOf(StrList[2]));
                String ScheduleQuery = 'select ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' from Schedules__c where OrderNumber__c = \'' + SelectedOrderLineNumber + '\' AND Week__c < ' + SaberGF.FormatDate(WeekDate, 'FQD') + ' ORDER BY Week__c DESC Limit 1';
                system.debug('ScheduleQuery - ' + ScheduleQUery);
                List<Schedules__c> SchedulesList = Database.query(ScheduleQuery);
    			if (SchedulesList.size() > 0)
    			{
    				if (StrList.size() == 3)
                    {
	                    sObject NewScheduleObj = (sObject)(SchedulesList[0]).clone(false, false, false);
	                    Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);
	                    
	                    system.debug('Duplicate Check 1 - ' + NewSCHRecord.Duplicate_Check_1a__c + ' - ' + NewSCHRecord.Duplicate_Check__c);
	                    NewSCHRecord.Total_Schedules__c	 = '0';	
	                    NewSCHRecord.SI_Number_if_Billed__c = null;
	                    NewSCHRecord.Reviewed_for_Invoicing__c = false;
	                    NewSCHREcord.Intacct_SI_Number__c = null;
	                    NewSCHRecord.Units_Preempted__c = null;
	                    NewSCHRecord.Status__c = 'Sold';
	                    NewSCHRecord.ISCI_CODE__c = null;
	                    NewSCHRecord.X800_Number__c = null;
	                    NewSCHrecord.Days_of_Air__c = null;
	                    newSCHRecord.Pod__c = null;
	                    NewSCHRecord.LF_traffic__c = null;
	                    NewSCHRecord.Comments__c = null;
	                    NewSCHRecord.Error_Cost__c = null;
	                    NewSCHrecord.Error_Logged_To__c = null;
	                    NewSCHRecord.Error_Reason__c = null;
	                    newSCHRecord.Discrepancy_Comment__c = null;
	                    NewSCHRecord.Week__c = WeekDate;
	                    NewSCHRecord.Duplicate_Check__c= null;
	                    system.debug('Duplicate Check 2 - ' + NewSCHRecord.Duplicate_Check_1a__c + ' - ' + NewSCHRecord.Duplicate_Check__c);
	                    system.debug('DealParentId Before - ' + NewSCHRecord.Deal_Parent__c);
	                    insert NewSCHRecord;
	                    System.debug('DealParentId After - ' + NewSCHRecord.Deal_Parent__c);
	                    SearchforSchedules();
	                	cellrate ='';  
	                	SelectedExtensionDate = null;
	                	SelectedOrderLineNumber = '';
                    }
    			}
    		}
    	}
    	catch(exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Message: ' + e.getMessage()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'LineNumber: ' + e.getLineNumber()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'TypeName: ' + e.getTypeName()));
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Stack Trace: ' + e.getStackTraceString()));    
        }
    }
    public void cellcancel()
    {
        SearchforSchedules();       
    }
    public class HeadingModel
    {
        public String cols{get;set;}
        public Date startOfWeek {get;set;} 
    }
    public class RateModel 
    {
        public boolean isChecked {get;set;}
        public string rate {set;get;}
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
        public rateModel()
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