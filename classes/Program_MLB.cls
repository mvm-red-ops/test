/**

 */

public with sharing class Program_MLB extends Program {

    public Program_MLB(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        super.dprc_BASE(result, program_c, scheds);

        return result;
    }

    public override void setPrelog(Contact c, Date d) {
        c.MLB_PreLog_Week__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.MLB_Post_Log_Week__c = d;
    }
}