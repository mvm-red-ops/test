public class DoubleCheckReadOnlyHelper {
    
    public class DealWrapper
    {
        public Deal__c DealRecord {get;set;}
        public List<HeadingModel> HeadingList {get;set;}
        public List<LineItemModel> LineItemModelList {get;set;}
        public Decimal UnitsAired {get;set;}
        public Decimal UnitsAvailable {get;set;}
        public Integer ClearancePercentage {get;set;}
        public Decimal TotalDollars {get;set;}
        public Decimal TotalDollarsBooked {get;set;}
        public Integer DollarClearancePercentage {get;set;}
        public Map<Date, Decimal> WeekDollarsMap {get;set;}
        public List<String> WeekDollarsList {get;set;}
        // MG added to return default PreLog Version
        public String prelogversion {get; set;}
        // MG created method to get the associated Deal ID
        public String getCurrentDealId(){
            if (DealRecord == null) {
                return '';
            } else {
                return String.valueOf(DealRecord.Id);
            }
        }
        
        public String getKey(){
            if (prelogversion != null) {
                return getCurrentDealId() + Week + prelogversion;
            } else {
                return getCurrentDealId() + Week;
            }
        }
        
        public String  Week{get; set;}
        
        //MG to track previous Week Data
        public Boolean isPreviousWeekData{get; set;}
        
        // MG to track Week : Prelogversion 
        public Map<String,String> prelogversionMap{get; set;}
        //String to hold prelog date time
        public String prelogDateTime {get; set;}
        
        // MG added for variable initialization
        public DealWrapper(){
            prelogversionMap = new Map<String,String>();
            isPreviousWeekData=false;
            prelogversion='';
        }
        
        
        // MG  added to get list of weeks associated with Deal
        public List<String> getWeeks(){
            List<String> ls=new List<String>();
            for(String str:this.prelogversionMap.keySet()){
                ls.add(str);
            }
            return ls;
        }
        
        // MG added to auto-filter records in visualForce  page for Deal ID + 1st day of Week
        public String getVersionString(){
            String version='';
            for(String key: prelogversionMap.keySet()){
                version = version + key;
            }
            return version;
        }
    }
    public class HeadingModel
    {
        public String cols{get;set;}
        public String bgcolor {get;set;}
        public Date startOfWeek {get;set;} 
    }
    public class LineItemModel 
    {
        public Boolean isChecked {get;set;}
        public Decimal rate {set;get;}
        public String OrderLineNumber {get;set;}
        public String DaysAllowed {get;set;}
        public String SETime {get;set;}
        public Decimal UnitLength  {get;set;}
        public List<WeekModel> weeks {get;set;}
        public Boolean Filler {get;set;}
        public Decimal changerate {get;set;}
        public Schedules__c Scheduleobj {get;set;}
        public Date DayValue {get;set;}
        public Date LowestDate {get;set;}
        public Date HighestDate {get;set;}
        public String UnitsAvailable {get;set;}
        public LineItemModel()
        {
            isChecked = false;
            weeks = new List<WeekModel>();
            Scheduleobj = new Schedules__c();
            UnitsAvailable = '0'; 
            
        }
    }
    public class WeekModel 
    {
        public Date startOfWeek {get;set;}
        public Schedules__c schObj{get;set;}
        public String color {get;set;}
        public Decimal changerate {get;set;}
        public Boolean CellAvailable {get;set;}
        public Boolean ExtensionAvailable {get;set;}
        public String OrderLineNumber {get;set;}
        public String ExtensionDate {get;set;}
        public Boolean MultipleSchedules {get;set;}
        public weekModel(Date pstartOfWeek , Schedules__c pschObj, Boolean pMultipleSchedules)
        {
            MultipleSchedules = pMultipleSchedules;
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-'
                    + String.valueOf(pstartOfWeek.month()) + '-' + String.valueOf(pstartOfWeek.day());
            ExtensionAvailable = false;
            CellAvailable = true;
            startOfWeek = pstartOfWeek; 
            schObj = pschObj;
            if(schObj.Status__c == 'Canceled')
            {
                color ='red';
            }       
            else if(schObj.TEST__c == true)
            {
                color='blue';
            }
            else
            {
                color='black';    
            }
            if (pschObj.Week__c < Date.today().toStartOfWeek().addDays(1))
            {
                CellAvailable = false;
            }
        }
        public weekmodel(Date pstartOfWeek, String pOrderLineNumber)
        {
            ExtensionDate = String.valueOf(pstartOfWeek.year()) + '-'
                    + String.valueOf(pstartOfWeek.month()) + '-' + String.valueOf(pstartOfWeek.day());
            startOfWeek = pstartOfWeek;  
            CellAvailable = false;   
            if (pstartOfWeek >= Date.today().toStartOfWeek().addDays(1))
            {
                ExtensionAvailable = true;
            }
            else
            {
                ExtensionAvailable = false;
            }
            OrderLineNumber = pOrderLineNumber;
        }
    }
    
    //Contains prelog data for a single OrderLineNumber for a single week.
    public class PrelogDataWrapper {
        public PrelogData__c prelogData {get; set;}
        
        //Map each day of the week to the correct value.
        public Map<String, Decimal> rateMap {get; set;}
        public Map<String, Decimal> clearanceMap {get; set;}
        public Map<String, Decimal> unitClearanceMap {get; set;}
        public Map<String, Decimal> unitsAvailableMap {get; set;}
        public Map<String, Decimal> unitsAiredMap {get; set;}
        
        //Grand totals
        public Decimal totalDollars {get; set;}
        public Decimal rate {get; set;}
        public Decimal clearance {get; set;}
        public Decimal unitClearance {get; set;}
        public Decimal unitAired {get; set;}
        public Decimal unitPlaced {get; set;}
        
        public PrelogDataWrapper(PrelogData__c prelogData) {
            this.prelogData = prelogData;
            this.rateMap = new Map<String, Decimal> {
                '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0,
                '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0
            };
            this.clearanceMap = new Map<String, Decimal> {
               '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0,
               '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0
            };
            this.unitClearanceMap = new Map<String, Decimal> {
                '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0,
                '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0
            };
            this.unitsAvailableMap = new Map<String, Decimal> {
                '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0,
                '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0
            };
            this.unitsAiredMap = new Map<String, Decimal> {
                '1Mon' => 0.0, '2Tues' => 0.0, '3Wed' => 0.0,
                '4Th' => 0.0, '5Fri' => 0.0, '6Sat' => 0.0, '7Sun' => 0.0
            };
            this.totalDollars = 0.0;
            this.rate = 0.0;
            this.clearance = 0.0;
            this.unitClearance = 0.0;
            this.unitAired = 0.0;
            this.unitPlaced = 0.0;
        }
        
        //Loops through maps and calculates the total rates for the week.
        public void calculateTotals() {
            this.rate=0;
            this.unitClearance=0;
            for (Decimal amt : this.rateMap.values()) {
                this.rate += amt;
            }
            for (Decimal amt : this.unitClearanceMap.values()) {
                this.unitClearance += amt;
                System.debug('***calculateTotals: amt ' + amt) ;
            }
            System.debug('***calculateTotals: unitClearance ' + this.unitClearance) ;
            this.totalDollars = this.prelogData.Schedule__r.Total_Dollars__c;
            System.debug('***calculateTotals: Total_Dollars__c ' + this.totalDollars) ;
            this.unitAired = this.prelogData.Schedule__r.Units_Aired__c ;
            System.debug('***calculateTotals: Units_Aired__c ' + this.unitAired) ;
            
            this.clearance = this.totalDollars != 0.0 ? ((this.rate / this.totalDollars)).setScale(2) : 0.0;
            this.unitPlaced = this.unitAired != 0.0 ? ((this.unitClearance / this.unitAired)).setScale(2) : 0.0;
        }
    }

    public static Integer ReturnNumber(String pMonth)
    {
        if (pMonth.toLowerCase() == 'jan') {
            return 1;
        }
        else if (pMonth.toLowerCase() == 'feb') {
            return 2;
        }
        else if (pMonth.toLowerCase() == 'mar') {
            return 3;
        }
        else if (pMonth.toLowerCase() == 'apr') {
            return 4;
        }
        else if (pMonth.toLowerCase() == 'may') {
            return 5;
        }
        else if (pMonth.toLowerCase() == 'jun') {
            return 6;
        }
        else if (pMonth.toLowerCase() == 'jul') {
            return 7;
        }
        else if (pMonth.toLowerCase() == 'aug') {
            return 8;
        }
        else if (pMonth.toLowerCase() == 'sep') {
            return 9;
        }
        else if (pMonth.toLowerCase() == 'oct') {
            return 10;
        }
        else if (pMonth.toLowerCase() == 'nov') {
            return 11;
        }
        else {
            return 12;
        }
    }

    public static List<SelectOption> ReturnDateLiteralSOList()
    {
        List<SelectOption> DateLiteralSOList = new List<SelectOption>();
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
        return DateLiteralSOList;
    }

    public static String ReturnStringDate(Date pDate)
    {
        String pString = String.valueOf(pDate.year()) + '-';
        if (pDate.month() < 10) {
            pString += '0' + String.valueOf(pDate.month()) + '-';
        }
        else {
            pString += String.valueOf(pDate.month()) + '-';
        }
        if (pDate.day() < 10) {
            pString += '0' + String.valueOf(pDate.day());
        }
        else {
            pString += String.valueOf(pDate.day());
        }
        return pString;
    }

    public static String formatDatetime(Datetime d)
    {
        return d.format('yyyy-MM-dd')+'T'+d.format('HH:mm:ssXXX');
    }

}