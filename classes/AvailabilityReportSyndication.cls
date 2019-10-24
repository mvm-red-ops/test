public class AvailabilityReportSyndication 
{
    public List<schedules__c> schedules;
    public List<programTeamModel> programTeams{get;set;}
    public Integer grand{get;set;}
    
    //Constructor definition
    public AvailabilityReportSyndication ()
    {
        getRecords();
    }
    private void getRecords() 
    {
    	programTeams = new List<programTeamModel>();
        schedules = [SELECT 
                        id, name, Week__c, Units_Available__c, Rate__c, DealProgram__c, Deal_Parent__c, 
                        Deal_Parent__r.Program__r.Team__c, DealBrand__c, Deal_Parent__r.Program__r.Cable_Synd__c 
                        FROM Schedules__c
                        WHERE Week__c >= LAST_N_DAYS:7 AND DealBrand__c = 'Availability' AND Deal_Parent__r.Program__r.Cable_Synd__c = 'Syndication' 
                        AND Deal_Parent__r.Program__r.Fixed_Inventory__c = false ORDER BY week__c LIMIT 1000
                    ];
        // 
        System.debug('######Records found==>'+schedules.size()+'###'+schedules);

        Map<String, Map<Date, List<Schedules__c>>> teamMap = new Map<String, Map<Date, List<Schedules__c>>>();
        for(Schedules__c sch: schedules)
        {
            if(sch.Deal_Parent__r.Program__r.Team__c != null)
            {
                Map<Date, List<Schedules__c>> weekMap = teamMap.get(sch.Deal_Parent__r.Program__r.Team__c);
                if(weekMap != null)
                {
                    List<Schedules__c> scheds = weekMap.get(sch.Week__c);
                    if(scheds != null)
                    {
                        scheds.add(sch);
                    }else
                    {
                        weekMap.put(sch.Week__c, new List<Schedules__c>{sch});
                    }
                }
                else
                {
                    weekMap = new Map<Date, List<Schedules__c>>();
                    weekMap.put(sch.Week__c, new List<Schedules__c>{sch});
                    teamMap.put(sch.Deal_Parent__r.Program__r.Team__c, weekMap);
                }
            }
        }
        grand = 0;
        for(String t : teamMap.keySet())
        {
            programTeamModel ptm = new programTeamModel();
            ptm.team = t;
            Map<Date, List<Schedules__c>> wMap = teamMap.get(t);
            
            List<Date> lstDates = new List<Date>();
            List<weekModel> wModelList = new List<weekModel>();
            integer i=0;
            lstDates.addAll(wMap.keySet());
            lstDates.sort();
            for(Date d : lstDates)
            {
              	weekModel wModel = new weekModel();
                List<Schedules__c> s = wMap.get(d);
                wModel.week = d;
                wModel.schList = s;
                wModelList.add(wModel);
                wModel.wCount = s.size();
                i += wModel.wCount;
            }
            ptm.weeks = wModelList;
            ptm.tCount = i;
            programTeams.add(ptm);
            grand += ptm.tCount;
        }
        
    }
    public void save() 
    {
        Set<Schedules__c> updatedSch = new Set<Schedules__c>();
        List<Schedules__c> updatedSchList = new List<Schedules__c>();
        for(programTeamModel p : programTeams)
        {
            List<weekModel> weekList = p.weeks;
            for(weekmodel w : weekList)
            {
                List<schedules__c> sList = w.schList;
                for(Schedules__c s : sList)
                {
                    updatedSch.add(s);
                }
            }
        }
        for(Schedules__c s:updatedSch)
        {
            updatedSchList.add(s);
        }
        upsert updatedSchList;
        system.debug('@@@@@@ Records saved####');
        getrecords();
    }
    class weekModel 
    {
        public integer wCount{get;set;}
        public Date week {get;set;}
        public List<Schedules__c> schList {get;set;}
        public weekModel()
        {
            schList = new List<Schedules__c>();
        }
    }
    class programTeamModel 
    {
        public Integer tCount{get;set;}
        public String team {set;get;}
        public List<weekModel> weeks {get;set;}
        public programTeamModel()
        {
            weeks = new List<weekModel>();
        }
    }
}