/**

 */

public with sharing class Program_Onyx extends Program {

    public Program_Onyx(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }

        Decimal ir = 0;
        Decimal dr = 0;
        Decimal aur = 0;

        for (Schedules__c sched : scheds) {
            ir = ir + sched.CALC_EQUIV_30__c;
            dr = dr + sched.Total_Dollars__c;
        }
        if (dr == 0 || ir == 0) {
            aur = 0;
        } else {
            aur = dr / ir;
        }

        Ratings_compiled__c rcro = super.defaultDPRating(program_c, 'HH', 'Total Day', ir, dr, aur);

        result.add(rcro);

        return result;
    }

    public override void setPrelog(Contact c, Date d) {
    }

    public override void setPostlog(Contact c, Date d) {
    }
}