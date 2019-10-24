/**
 */

public with sharing class Program_NHL extends Program {

    public Program_NHL(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        dprc_BASE(result, program_c, scheds);

        return result;
    }

    public override void setPrelog(Contact c, Date d) {
        c.NHLLocalNetworkPreLogWeek__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.NHLLocalNetworkPostLogWeek__c = d;
    }

}