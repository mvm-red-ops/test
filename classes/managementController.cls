/**
@ Name           :    managementController
@ Author         :    
@ Date           :    11 Sep, 2011
@ Description    :    This Controller Shows records on vf page as report Management.
*/
public class managementController 
{
    public boolean hasRecords {get;set;}
    public boolean filler{get;set;}
    public boolean missingReq {get;set;}
    public Decimal totalSpend {get;set;}
    public Decimal sumEquiv {get;set;}
    public Boolean whereFlag{get;set;}
    public decimal average {get;set;}
    public Integer count15 {get;set;}
    public Integer count30 {get;set;}
    public Integer count60 {get;set;}
    public Integer count90 {get;set;}
    public Integer count120 {get;set;}
    public Deal__c deal {get;set;}
    public Schedules__c sch{get;set;}
    public List<Schedules__c> schList{get;set;}
    public List<ScheduleModel> airScheduleList{get;set;}
    public List<ScheduleModel> preEmptionsList{get;set;}
    public List<ScheduleModel> canceledList{get;set;}
    public List<ScheduleModel> availabilityList{get;set;}
    String program;
    String Brand;
    String agency;
    String dealId;
    String avail = 'Availability';
    Date fromdate;
    Date toDate;
    public list<selectoption> team{get;set;}    
    public string selectedTeam {get;set;}
    
    //Constructor definition
    public managementController () 
    {
        team = new list<selectoption>();
        team.add(new selectoption('None','None'));
        team.add(new selectoption('Red','Red'));
        team.add(new selectoption('Blue','Blue'));
        team.add(new selectoption('Green','Green'));
        team.add(new selectoption('Orange','Orange'));
        
        hasRecords = true;
        missingReq = false;
        deal = new Deal__c();
        sch = new Schedules__c();
        setCurrentWeek();
        whereFlag = false;
    }
    
    //Method sets current week in fr0m and to date filters
    private void setCurrentWeek() 
    {
        sch.Week__c = Date.today().toStartOfWeek().addDays(1);
        sch.Day__c = sch.Week__c.addDays(6);
    }
    public PageReference refresh()
    {    
        search();
        return null;
    }
    
    //Method to filter records
	public pageReference search() 
    {
    	schList = new List<Schedules__c>();
        missingReq = false;
        hasRecords = true;
        whereFlag = false;
        totalSpend = 0;
        sumEquiv = 0;
        average = 0;
        count15=0;
        count30=0;
        count60=0;
        count90=0;
        count120=0;
        
        if((sch.Week__c == null || sch.day__c == null)&& sch.Deal_Parent__c == null)
        {
            missingReq = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Week date OR Deal No. is Required..!'));
            return null;
        }
        System.debug('@@ Program Id = ' + deal.Program__c);
        fromDate = sch.Week__c;
        toDate = sch.day__c;
        System.Debug('$$$$$$Filler is '+filler);
        String query = ' Select s.Week__c, s.Units_Preempted__c, s.Units_Available__c, s.Units_Aired__c, s.Days_of_Air__c, s.Pod__c, ';
               query += 's.TEST__c, s.Status__c, s.Rate__c, s.Product__c, s.Name, s.UnitLength__c, Comments__c, ';
               query += 's.Long_Form__c, s.LF_Week__c, s.LF_Results__c, s.DealProgram__c, s.DealContact__c, s.SS10_Titles__c, ';
               query += 's.LF_Daypart__c, s.LF_Brand__c, s.Id, s.ISCI_CODE__c, s.Day_Restrictions__c, s.Total_Dollars__c, ';
               query += 's.X30_Rate__c,  s.Equiv_30__c, s.End_Time__c, s.Dollars_Booked__c, s.Deal_Parent__c, Deal_Parent__r.Campaign__c, ';
               query += 's.DealClientCode__c, s.DealBrand__c, s.DealAccount__c, s.Day_of_Week__c, s.Day__c, Deal_Parent__r.Client_Account__c, ';
               query += 's.COUNTMENOT__c, s.COOL_TV_Daypart__c, s.X800_Number__c, s.Filler__c From Schedules__c s ';
        if(filler == true)
        {
       		query += ' WHERE Filler__c = true ';
       		whereFlag = true;
        }
        if(sch.Deal_Parent__c != null)
        {
            dealId = sch.Deal_Parent__c;
            if(whereFlag)
            {
                query += 'AND ';
            }
            else
            {
                query += 'WHERE ';
                whereFlag = true;
            }
            query += 'Deal_Parent__c =: dealID ';
        }
        else
        {
            if(whereFlag)
            {
                query += 'AND ';
            }
            else
            {
                query += 'WHERE ';
                whereFlag = true;
            }
            query += ' Week__c >= :fromDate AND Week__c <= : toDate ';
        }
        if(selectedTeam != 'None' && selectedTeam != null)
        {
            if(whereFlag)
            {
                query += 'AND ';
            }
            else
            {
                query += 'WHERE ';
                whereFlag = true;
            }
            query += ' Deal_Parent__r.Program__r.Team__c like \'%' + selectedTeam + '%\' ';
        }
        system.debug('###### Selected Team ==> '+selectedTeam);
        if(deal.Program__c != null) 
        {
            String programId = deal.Program__c;
            list<Programs__c> progList = [SELECT id, name from Programs__c where id =: programId];
            if(progList.size() > 0)
            {
                Programs__c prog = progList.get(0);
                program = prog.name;
            }
            if(program != null && program.trim().length() > 0)
            {
                if(whereFlag)
                {
                    query += 'AND ';
                }
                else
                {
                    query += 'WHERE ';
                    whereFlag = true;
                }
                query += ' DealProgram__c like \'%' + program + '%\' ';
            }
        }
        if(sch.LF_Brand__c != null) 
        {
            string brandId = sch.LF_Brand__c;
            list<Brands__c> brandList = [SELECT id, name from Brands__c where id =: brandId];
            if(brandList.size() > 0)
            {
                Brands__c obj = brandList.get(0);
                brand= obj.name;
            }
            if(brand != null && brand.trim().length() > 0)
            {
                if(whereFlag)
                {
                    query += 'AND ';
                }
                else
                {
                    query += 'WHERE ';
                    whereFlag = true;
                }
                query += ' DealBrand__c like \'%' + brand + '%\' ';
            }
        }
        if(deal.Client_Account__c != null)
        {
            string accountId = deal.Client_Account__c;
            list<account> accList = [SELECT id, name from Account where id =: accountId];
            if(accList.size() > 0)
            {
                Account acc = accList.get(0);
                agency = acc.name;
            }
            if(agency != null && agency.trim().length() > 0)
            {
                if(whereFlag)
                {
                    query += 'AND ';
                }
                else
                {
                    query += 'WHERE ';
                    whereFlag = true;
                }
                query += ' DealAccount__c like \'%' + agency + '%\' ';
            }
        }
        System.debug('####### Deal===>'+sch.Deal_Parent__c);      
        System.debug('####### Program===>'+program);
        System.debug('####### Brands===>'+brand);
        System.debug('####### Agency===>'+agency);
        System.debug('####### from date===>'+fromdate);
        System.debug('####### to date===>'+todate);                
        System.debug('####### query===>'+query);
        
        getFilterList(query);
            
        if(availabilityList.size() <= 0 && airScheduleList.size() <= 0 && preEmptionsList.size() <=0) 
        {
            hasRecords=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found..!'));
            return null;
        }
        PageReference pg = new PageReference('/apex/managementReport');
        return pg;
    }
    
    //Method to move at home page
    public PageReference back()
    {
        PageReference pg = new PageReference('/apex/management');
        return pg;
    }
        
    //Method for Previous week button
    public void oneWeekLater()
    {
        sch.Week__c = sch.Week__c.addDays(7);
        sch.Day__c = sch.Day__c.addDays(7);
        search();
    }
    
    //Method for next week button
    public void oneWeekBack()
    {
        sch.Week__c = sch.Week__c.addDays(-7);
        sch.Day__c = sch.Day__c.addDays(-7);
        search();
    }
    //Method searching records on main report
    public pageReference newSearch() 
    {
        schList = new List<Schedules__c>();
        missingReq = false;
        hasRecords = true;
        totalSpend = 0;
        sumEquiv = 0;
        average = 0;
        count15=0;
        count30=0;
        count60=0;
        count90=0;
        count120=0;
        
        if((sch.Week__c == null || sch.day__c == null)&& sch.Deal_Parent__c == null)
        {
            missingReq = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Week date OR Deal No. is Required..!'));
            return null;
        }
        System.debug('@@ Program Id = ' + deal.Program__c);
        fromDate = sch.Week__c;
        toDate = sch.day__c;
        System.Debug('@@@@@@Filler is '+filler);
        String query = ' Select s.Week__c, s.Units_Preempted__c, s.Units_Available__c, s.Units_Aired__c, s.Days_of_Air__c, s.Pod__c, ';
               query += 's.TEST__c, s.Status__c, s.Rate__c, s.Product__c, s.Name, s.UnitLength__c, Comments__c, ';
               query += 's.Long_Form__c, s.LF_Week__c, s.LF_Results__c, s.DealProgram__c, s.DealContact__c, s.SS10_Titles__c, ';
               query += 's.LF_Daypart__c, s.LF_Brand__c, s.Id, s.ISCI_CODE__c, s.Day_Restrictions__c, s.Total_Dollars__c, ';
               query += 's.X30_Rate__c,  s.Equiv_30__c, s.End_Time__c, s.Dollars_Booked__c, s.Deal_Parent__c, Deal_Parent__r.Campaign__c, ';
               query += 's.DealClientCode__c, s.DealBrand__c, s.DealAccount__c, s.Day_of_Week__c, s.Day__c, Deal_Parent__r.Client_Account__c, ';
               query += 's.COUNTMENOT__c, s.COOL_TV_Daypart__c, s.X800_Number__c, s.Filler__c '; 
               query += 'From Schedules__c s WHERE Week__c >= :fromDate AND Week__c <= : toDate ';
        if(filler == true)
        {
            query += 'AND  Filler__c =: filler ';
        }
        if(sch.Deal_Parent__c != null)
        {
            dealId = sch.Deal_Parent__c;
            query += 'AND Deal_Parent__c =: dealID ';
        }
        if(selectedTeam != 'None' && selectedTeam != null)
        {
            query += 'AND Deal_Parent__r.Program__r.Team__c like \'%' + selectedTeam + '%\' ';
        }
        system.debug('###### Selected Team ==> '+selectedTeam);
        if(deal.Program__c != null) 
        {
            String programId = deal.Program__c;
            list<Programs__c> progList = [SELECT id, name from Programs__c where id =: programId];
            if(progList.size() > 0)
            {
                Programs__c prog = progList.get(0);
                program = prog.name;
            }
            if(program != null && program.trim().length() > 0)
            {
                query += 'AND DealProgram__c like \'%' + program + '%\' ';
            }
        }
        if(sch.LF_Brand__c != null) 
        {
            string brandId = sch.LF_Brand__c;
            list<Brands__c> brandList = [SELECT id, name from Brands__c where id =: brandId];
            if(brandList.size() > 0)
            {
                Brands__c obj = brandList.get(0);
                brand= obj.name;
            }
            if(brand != null && brand.trim().length() > 0)
            {
                query += ' AND DealBrand__c like \'%' + brand + '%\' ';
            }
        }
        if(deal.Client_Account__c != null)
        {
            string accountId = deal.Client_Account__c;
            list<account> accList = [SELECT id, name from Account where id =: accountId];
            if(accList.size() > 0)
            {
                Account acc = accList.get(0);
                agency = acc.name;
            }
            if(agency != null && agency.trim().length() > 0)
            {
                query += ' AND DealAccount__c like \'%' + agency + '%\' ';
            }
        }
        System.debug('####### Deal===>'+sch.Deal_Parent__c);          
        System.debug('####### Program===>'+program);
        System.debug('####### Brands===>'+brand);
        System.debug('####### Agency===>'+agency);
        System.debug('####### from date===>'+fromdate);
        System.debug('####### to date===>'+todate);                
        System.debug('####### query===>'+query);
        System.debug('####### Filler===>'+filler);
        
        getFilterList(query);
            
        if(availabilityList.size() <= 0 && airScheduleList.size() <= 0 && preEmptionsList.size() <=0) 
        {
            hasRecords=false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No Records Found..!'));
            return null;
        }
        return null;
    }
    private void getFilterList(String query)
    {
        getAirScheduleList(query);
        getPreEmptionList(query);
        getCanceledList(query);
        getAvailabilityList(query);
    }    
    
    //Method to create Air Schedule List
    private void getAirScheduleList(String query) 
    {
        List<Schedules__c> schList;
        airScheduleList = new List<ScheduleModel>();
        integer i=0;
        
        query += ' AND COUNTMENOT__c != \'N\' AND Deal_Parent__r.Brands__r.name != \'Availability\' ORDER BY X30_Rate__c desc LIMIT 250';
        schList = database.query(query);
        
        system.debug('###### size 1 ===>'+schList.size());
        
        for(Schedules__c s: schList)
        {
            ScheduleModel m = new ScheduleModel (s, 1);
            airScheduleList.add(m);
            i++;
            
            if(s.Rate__C != null)
            {
                totalSpend += s.Rate__c;
            }
            if(s.Equiv_30__c != null)
            {
                sumEquiv += s.Equiv_30__c;
            }
            if(s.X30_Rate__c != null)
            {
                average += s.X30_Rate__c;
            }
            
            if(s.unitLength__c == 30)
            {
                count30++;
            }
            if(s.unitLength__c == 15)
            {
                count15++;
            }
            if(s.unitLength__c == 60)
            {
                count60++;
            }
            if(s.unitLength__c == 90)
            {
                count90++;
            }
            if(s.unitLength__c == 120)
            {
                count120++;
            }
        }
        if(schList.size()>0)
        {
            average = average/schList.size();
        }
        system.debug('###### Air schedule size===>'+airScheduleList.size());
    }
    
    //Method to create Pre emption list
    private void getPreEmptionList(String query) 
    {
        List<Schedules__c> schList;
        preEmptionsList = new List<ScheduleModel>();
        integer i=0;
        query += 'AND Units_Preempted__c >= 1 AND Status__c != \'Canceled\' ORDER BY X30_Rate__c desc LIMIT 250';
        
        schList = database.query(query);
        system.debug('###### size 2 ===>'+schList.size());
        for(Schedules__c s: schList) 
        {
            ScheduleModel m = new ScheduleModel (s, i);
            preEmptionsList.add(m);
            i++;
        }
        system.debug('###### Pre Emption size===>'+preEmptionsList.size());
    }
    
    //Method to create Canceled List
    private void getCanceledList(String query) 
    {
        List<Schedules__c> schList;
        canceledList = new List<ScheduleModel>();
        integer i=0;
        query += 'AND Status__c = \'Canceled\' ORDER BY X30_Rate__c desc LIMIT 250';
        //AND Units_Preempted__c >= 1 
        schList = database.query(query);
        system.debug('###### size 4 ===>'+schList.size());
        for(Schedules__c s: schList) 
        {
            ScheduleModel m = new ScheduleModel (s, i);
            canceledList.add(m);
            i++;
        }
        system.debug('###### Canceled size===>'+canceledList.size());
    }
    
    //Method to create Availability List
    private void getAvailabilityList(String query) 
    {
        List<Schedules__c> schList;
        availabilityList = new List<ScheduleModel>();
        
        integer i=0;
        
        query += 'AND Deal_Parent__r.Brands__r.name like \'%' + avail + '%\' ORDER BY X30_Rate__c desc LIMIT 250';
        
        schList = database.query(query);
        system.debug('###### size 3 ===>'+schList.size());
        
        for(Schedules__c s: schList) 
        {
            ScheduleModel m = new ScheduleModel (s, i);
            availabilityList.add(m);
            i++;
        }
        system.debug('###### Availability size===>'+availabilityList.size());
    }
    public Boolean ToBeSaved(ScheduleModel sm)
	{
		if(sm.schedule.Pod__c != sm.Pod || sm.schedule.Days_of_Air__c != sm.DOA 
										|| sm.schedule.X800_Number__c != sm.VFNumber 
										|| sm.schedule.Units_Available__c != sm.VFUB 
										|| sm.schedule.Week__c != sm.VFweek 
										|| sm.schedule.Units_Preempted__c != sm.VFUPE 
										|| sm.schedule.Rate__c != sm.VFrate 
										|| sm.schedule.ISCI_CODE__c != sm.VFCode 
										|| sm.schedule.Comments__c != sm.VFComment 
										|| sm.schedule.Status__c != sm.VFStatus 
										|| sm.schedule.Filler__c != sm.VFfiller 
										|| sm.schedule.TEST__c != sm.VFTest)
        {
            return true;
        }
        return false;
    }

    public void save() 
    {
        List<Schedules__c> updateAirSch = new List<Schedules__c>();
        Set<Id> dontsaveAS = new set<id>();
        Set<Id> dontsavePE = new set<id>();  
        Set<Id> dontsaveCancel= new set<id>();
        for(ScheduleModel sm : airScheduleList)
        { 
            if(TOBESAVED(sm))    
            {
                dontsaveAS.add(sm.schedule.id);
                updateAirSch.add(sm.schedule);
            }
        }
        upsert updateAirSch;
        List<Schedules__c> updatePreEmp = new List<Schedules__c>();
        for(ScheduleModel sm : preEmptionsList)
        {
            If (TOBESAVED(sm))
            {
            	If (!dontsaveAS.contains(sm.schedule.id) )
            	{
               		dontsavePE.add(sm.schedule.id);
                	updatePreEmp.add(sm.schedule);
            	}
            }
        }
        upsert updatePreEmp;
        List<Schedules__c> updateCanceled = new List<Schedules__c>();
        for(ScheduleModel sm : canceledList)
        {
            if (TOBESAVED(sm))
            {
            	If (!dontsaveAS.contains(sm.schedule.id) && !dontsaveAS.contains(sm.schedule.id) )
            	{
                	dontsaveCancel.add(sm.schedule.id);
                	updateCanceled.add(sm.schedule);
            	}
        	}
        }
        upsert updateCanceled;
        List<Schedules__c> updateAvail = new List<Schedules__c>();
        for(ScheduleModel sm : availabilityList)
        {
            if (TOBESAVED(sm))
            {
            	If (!dontsaveAS.contains(sm.schedule.id) && !dontsavePE.contains(sm.schedule.id) && !dontsaveCancel.contains(sm.schedule.id) )
	            {
	               updateAvail.add(sm.schedule);
	            }
            }
        }
        upsert updateAvail;
        newsearch();
    }
    
    public class ScheduleModel 
    {
        public Integer srNo{get;set;}
        public Schedules__c schedule{get;set;}
        public boolean Haschanged;

        //test param
        public string DOA;     
        public String Pod; 
        public Date VFweek;     
        public decimal VFUB;  
        public Decimal VFUPE;  
        public Decimal VFrate; 
        public String VFCode;   
        public String VFNumber;  
        public String VFComment;   
        public String VFStatus;  
        public Boolean VFfiller;      
        public Boolean VFTest;

        public ScheduleModel(schedules__c s, integer count)
        {
            srNo=count;
            schedule = s;
            VFUB  = s.Units_Available__c; 
            VFrate = s.Rate__c;
            VFweek = s.Week__c;
            VFStatus = s.Status__c;
            VFNumber = s.X800_Number__c;
            VFUPE = s.Units_Preempted__c;
            VFCode = s.ISCI_CODE__c;
            VFComment = s.Comments__c;
            VFfiller = s.Filler__c;
            VFTest= s.TEST__c;
            DOA = s.Days_Of_Air__c;
            Pod = s.Pod__c;
        }
    }
}