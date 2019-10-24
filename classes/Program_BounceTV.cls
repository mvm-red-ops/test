/**

 */

public with sharing class Program_BounceTV extends Program {
    private static List<String> demoEbgl = new List<String>{
            'F18-34', 'F18-99', 'F25-54', 'F25-99', 'F35-64', 'F35-99', 'F50-99', 'F55-99', 'F65-99', 'HH', 'M18-34', 'M18-49', 'M18-99', 'M25-54', 'M25-99', 'M35-64', 'M35-99', 'M50-99', 'M55-99', 'M65-99', 'P18-34', 'P18-49', 'P18-99', 'P25-54', 'P25-99', 'P35-64', 'P35-99', 'P50-99', 'P55-99', 'P65-99'
    };

    public Program_BounceTV(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        if (!super.imp_standard(result, scheds, demoEbgl)) {
            result.addAll(insertWkndRC(scheds));
        }
        return result;
    }

    public override void setPrelog(Contact c, Date d) {
        System.debug('made it to set prelog');
        c.Bounce_Prelog_Week__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.Bounce_Post_Week__c = d;
    }
}