/**

 */

public with sharing class Program_JusticeNetwork extends Program {
    private List<String> demoJustice = new List<String>{
            'F18-34', 'F18-49', 'F18-99', 'F25-34', 'F25-49', 'F25-54', 'F25-99', 'F2-99', 'F35-64', 'F50-99', 'F55-99', 'F65-99', 'HH', 'M18-34', 'M18-99', 'M25-54', 'M25-99', 'M2-99', 'M35-54', 'M35-64', 'M55-99', 'M65-99', 'P18-34', 'P18-49', 'P18-99', 'P25-54', 'P25-99', 'P2-99', 'P35-54', 'P35-64', 'P35-99', 'P50-99', 'P55-99', 'P65-99'
    };

    public Program_JusticeNetwork(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        return super.imp_demos(scheds, impFiveDayparts, demoJustice);
    }

    public override void setPrelog(Contact c, Date d) {
    }

    public override void setPostlog(Contact c, Date d) {
    }
}