/**

 */

public with sharing class Program_AntennaTV extends Program {
    private List<String> demoAntenna = new List<String>{
            'F18-34', 'F18-99', 'F25-54', 'F25-64', 'F25-99', 'F35-54', 'F35-99', 'F50-99', 'F55-99', 'HH', 'M18-34', 'M18-49', 'M18-99', 'M25-54', 'M25-99', 'M35-54', 'M35-64', 'M35-99', 'M50-99', 'M55-99', 'M65-99', 'P18-34', 'P18-49', 'P18-99', 'P2-11', 'P2-17', 'P25-54', 'P25-99', 'P2-99', 'P35-54', 'P35-64', 'P35-99', 'P50-99', 'P55-99'
    };

    public Program_AntennaTV(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        return super.imp_demos(scheds, impFourDayparts, demoAntenna);
    }

    public override void setPrelog(Contact c, Date d) {
        c.AntennaTV_Pre_Log_Week__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.AntennaTV_Post_Week__c = d;
    }
}