public class EntryCheckHelper {

    public class FBModels {
        public String lfDayPart { set; get; }
        public String key { get; set; }
        public List<FBEntryModel> fbEntryModels { get; set; }
        public FBEntryModel grandTotal { get; set; }
        public Decimal totalRate { get; set; }
        public Integer totalCount { get; set; }
        public Boolean chkbox { get; set; }
        public FBModels() {
            chkbox = false;
        }
    }

    public class FBEntryModel {
        public Schedules__c schedule { get; set; }
        //Week__C ==> for passing
        public boolean showEditable { set; get; }
        public integer wYear { set; get; }
        public integer wMonth { set; get; }
        public integer wDay { set; get; }
        public decimal sumOfRate { get; set; }
        public integer recordCount { get; set; }
        public integer rCount { get; set; }
        public boolean isSubTotal { get; set; }
        public string color { set; get; }
        public String getWeekStr() {
            return schedule.Week__c.Year() + '-' + schedule.Week__c.Month() + '-' + schedule.Week__c.Day();
        }

        public void setWeek(Date d) {
            wYear = d.year();
            wMonth = d.month();
            wDay = d.day();
            showEditable = false;
        }
        public FBEntryModel() {
            color = 'rgb(194,84,84)';
            sumOfRate = 0;
            recordCount = 0;
            schedule = new Schedules__c(rate__c = 0);

            //schedule.Week__c = fbEntryList.get(i).schedule.Week__c;
            //schedule.Long_Form__c = fbEntryList.get(i).schedule.Long_Form__c;
            //schedule.Rate__c =0;
        }
    }

    public class ModelTotals {
        public double sumOfRate { set; get; }
        public integer recordCount { set; get; }
        public string color { set; get; }
        public boolean isSubTotal { get; set; }

        public ModelTotals() {
            sumOfRate = 0;
            recordCount = 0;
            color = 'red';
            isSubTotal = false;
        }
    }

    public class HeadingModel {
        public String cols { get; set; }
        public Date startOfWeek { get; set; }
    }
}