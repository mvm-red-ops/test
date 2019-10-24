/**

 */

public with sharing class Program_BounceTVLocal extends Program {

    public Program_BounceTVLocal(Programs__c program) {
        super(program);
    }

    public override List<Ratings_compiled__c> getRatings() {
        Decimal i = 0;
        Decimal d = 0;
        Decimal aur = 0;

        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        List<Schedules__c> scheds = super.getSchedules();

        //Total Day calculation
        for (Schedules__c sched : scheds) {
            i = i + sched.Sum_Spot_Equiv_30__c;
            d = d + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
        }
        if (i == 0 || d == 0) {
            return result;
        } else {
            aur = d / i;
        }
        
        Ratings_compiled__c rcr = new Ratings_compiled__c(
            Program__c = program_c.Id,
            Playback__c = 'Live+SD | TV | Linear with VOD',
            Budget_Label__c = 'Actual',
            Type__c = 'Actual',
            Demographic__c = 'HH',
            Daypart__c = 'Total Day',
            Week__c = program_c.RCreconciled_Week__c,
            INV__c = i,
            Dollar_Amount__c = d,
            AUR__c = aur
        );
        result.add(rcr);

        i = 0.0;
        d = 0.0;
        for (String fdp : impFiveDayparts) {
            for (Schedules__c sched : scheds) {
                if (sched.Daypart__c == fdp) {
                    i = i + sched.Sum_Spot_Equiv_30__c;
                    d = d + sched.Spot_Total__c;
                }
            }
            if (i == 0 || d == 0) {
                aur = 0;
            } else {
                aur = d / i;
            }

            Ratings_compiled__c rcrr = new Ratings_compiled__c(
                Program__c = program_c.Id,
                Playback__c = 'Live+SD | TV | Linear with VOD',
                Budget_Label__c = 'Actual',
                Type__c = 'Actual',
                Demographic__c = 'HH',
                Daypart__c = fdp,
                Week__c = program_c.RCreconciled_Week__c,
                INV__c = i,
                Dollar_Amount__c = d,
                AUR__c = aur
            );
            result.add(rcrr);

            i = 0.0;
            d = 0.0;
        }
        return result;
    }

    public override void setPrelog(Contact c, Date d) {
        c.Bounce_Prelog_Week__c = d;
    }

    public override void setPostlog(Contact c, Date d) {
        c.Bounce_Post_Week__c = d;
    }
}