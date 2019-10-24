/**

 */

public with sharing class Program_MGM extends Program {

    private List<String> fiveDayparts = new List<String>{
            'EM', 'DA', 'PR', 'ON', 'LN'
    };

    public Program_MGM(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = super.getSchedules();
        if (scheds == null || scheds.isEmpty()) {
            return null;
        }
        super.dprc_BASE(result, program_c, scheds);

        Decimal ir = 0;
        Decimal dr = 0;
        Decimal aur = 0;

        for (String idp : fiveDayparts) {
            for (Schedules__c sched : scheds) {
                if (sched.Daypart__c == idp) {
                    ir = ir + sched.Sum_Spot_Equiv_30__c;
                    dr = dr + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
                }
            }
            if (dr == 0 || ir == 0) {
                aur = 0;
            } else {
                aur = dr / ir;
            }

            Ratings_compiled__c rcrfi = super.defaultDPRating(program_c, 'HH', idp, ir, dr, aur);

            result.add(rcrfi);

            ir = 0.0;
            dr = 0.0;
        }
        return result;
    }

    public override void setPrelog(Contact c, Date d) {
    }

    public override void setPostlog(Contact c, Date d) {
    }
}