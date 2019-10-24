/**

 */

public with sharing virtual class Program_TVG extends Program {

    private static List<String> tvgDayparts = new List<String>{
            'DA', 'PR', 'ON'
    };

    public Program_TVG(Programs__c program) {
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

        for (String idpt : tvgDayparts) {
            for (Schedules__c sched : scheds) {
                if (sched.Daypart__c == idpt) {
                    ir = ir + sched.Sum_Spot_Equiv_30__c;
                    dr = dr + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
                }
            }
            if (dr == 0 || ir == 0) {
                aur = 0;
            } else {
                aur = dr / ir;
            }

            Ratings_compiled__c rcrst = super.defaultDPRating(program_c, 'HH', idpt, ir, dr, aur);

            result.add(rcrst);

            ir = 0.0;
            dr = 0.0;
        }
        return result;
    }

    public override virtual void setPrelog(Contact c, Date d) {
        c.TVGPreLogWeek__c = d;
    }

    public override virtual void setPostlog(Contact c, Date d) {
        c.TVGPostLogWeek__c = d;
    }

}