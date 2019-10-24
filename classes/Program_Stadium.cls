/**

 */

public with sharing class Program_Stadium extends Program {

    private static List<String> demoStad = new List<String>{
            'P55-99', 'P35-64', 'P25-54', 'P21-49', 'P21-34', 'P2-99', 'P18-99', 'P18-49', 'P18-34', 'P18-24', 'M55-99', 'M35-64', 'M25-54', 'M21-34', 'M2-99', 'M18-99', 'M18-49', 'M18-34', 'M18-24', 'HH', 'F55-99', 'F35-64', 'F25-54', 'F21-34', 'F2-99', 'F18-99', 'F18-49', 'F18-34', 'F18-24'
    };
    private static List<String> tvgDayparts = new List<String>{
            'DA', 'PR', 'ON'
    };

    public Program_Stadium(Programs__c program) {
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

        //Total Day calculation
        for (Schedules__c sched : scheds) {
            ir = ir + sched.Sum_Spot_Equiv_30__c;
            dr = dr + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
        }
        if (ir == 0 || dr == 0) {
            return result;
        }
        for (String demoB : demoStad) {
            Ratings_compiled__c rcrstad = super.defaultDPRating(program_c, demoB, 'Total Day', ir, dr, aur);

            result.add(rcrstad);
        }
        ir = 0.0;
        dr = 0.0;
        for (String fdp : tvgDayparts) {
            for (Schedules__c sched : scheds) {
                if (sched.Daypart__c == fdp) {
                    ir = ir + sched.Sum_Spot_Equiv_30__c;
                    dr = dr + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
                }
            }
            if (ir == 0 || dr == 0) {
                aur = 0;
            } else {
                aur = dr / ir;
            }
            for (String demoB : demoStad) {
                Ratings_compiled__c rcrstad = super.defaultDPRating(program_c, demoB, fdp, ir, dr, aur);

                result.add(rcrstad);
            }
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