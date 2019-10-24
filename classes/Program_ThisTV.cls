/**

 */

public with sharing class Program_ThisTV extends Program {
    private List<String> demoThistv = new List<String>{
            'F25-54', 'F25-64', 'F25-99', 'F35-49', 'F35-64', 'F50-64', 'F55-99', 'HH', 'M25-54', 'M25-64', 'M25-99', 'M35-49', 'M35-64', 'M50-64', 'M55-99', 'P25-54', 'P25-64', 'P25-99', 'P2-99', 'P35-49', 'P35-64', 'P35-99', 'P50-64', 'P50-99', 'P55-99', 'P65-99'
    };

    public Program_ThisTV(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        return super.imp_demos(scheds, impFourDayparts, demoThistv);
    }

    public override void setPrelog(Contact c, Date d) {
        c.ThisTV_PreLog_Week__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.ThisTV_Post_Week__c = d;
    }
}