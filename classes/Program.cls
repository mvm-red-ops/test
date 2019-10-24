/**
 *
 * Base class for Programs__c Wrapper
 */

public with sharing abstract class Program {
    protected Programs__c program_c {get;set;}
    private static ScheduleSelector scheduleSelector = new ScheduleSelector();
    private static SpotDataSelector spotDataSelector = new SpotDataSelector();

    public static void setScheduleSelector(ScheduleSelector sSelector) {
        scheduleSelector = sSelector;
    }

    public static void setSpotDataSelector(SpotDataSelector spSelector) {
        spotDataSelector = spSelector;
    }

    public static List<String> impFiveDayparts = new List<String>{
            'EM', 'DA', 'PR', 'LN', 'ON'
    };
    public static List<String> impFourDayparts = new List<String>{
            'EM', 'DA', 'PR', 'ON'
    };

    protected Program(Programs__c program) {
        this.program_c = program;
    }

    public List<Schedules__c> getSchedules() {
        return scheduleSelector.getSchedulesInWeek(program_c);
    }

    public abstract List<Ratings_compiled__c> getRatings();

    public abstract void setPrelog(Contact c, Date d);

    public abstract void setPostlog(Contact c, Date d);

    /**
     * imp_standard
     * @description Returns standard ratings (Ratings_compiled__C)
     *
     * @param result the mutable list of ratings (Ratings_compiled__C)
     * @param network the network (Programs__c)
     * @param scheds the schedules (Schedules__c) to use for calculating values
     *
     * @return Boolean representing if the list is finished and should be returned
     */
    public Boolean imp_standard(List<Ratings_compiled__c> result, List<Schedules__c> schedules, List<String> demos) {
        Decimal i = 0;
        Decimal d = 0;
        Decimal aur = 0;

        //Total Day calculation
        for (Schedules__c sched : schedules) {
            i = i + sched.Sum_Spot_Equiv_30__c;
            d = d + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
        }
        if (i == 0 || d == 0) {
            return true;
        }
        for (String demoB : demos) {

            Decimal a = (program_c.Name.equals('BounceTV')) ? aur : (d / i);
            Ratings_compiled__c rcr = createIMPRating(program_c, demoB, 'Total Day', i, d, a);

            result.add(rcr);
        }
        i = 0.0;
        d = 0.0;
        for (String fdp : impFiveDayparts) {
            for (Schedules__c sched : schedules) {
                if (sched.Daypart__c == fdp) {
                    i = i + sched.Sum_Spot_Equiv_30__c;
                    d = d + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
                }
            }
            if (i == 0 || d == 0) {
                aur = 0;
            } else {
                aur = d / i;
            }
            for (String demoB : demos) {
                Ratings_compiled__c rcr = createIMPRating(program_c, demoB, fdp, i, d, aur);

                result.add(rcr);
            }
            i = 0.0;
            d = 0.0;
        }
        return false;
    }

    /**
     * imp_demos
     * @description Returns ratings (Ratings_compiled__C) with specific demographic info
     *
     * @param result the mutable list of ratings (Ratings_compiled__C)
     * @param schedules the schedules (Schedules__c) to use for calculating values
     * @param dayParts the specific dayParts
     * @param demos the demographic information
     *
     * @return Boolean representing if the list is finished and should be returned
     */
    public List<Ratings_compiled__c> imp_demos(List<Schedules__c> schedules, List<String> dayParts, List<String> demos) {
        List<Ratings_compiled__c> result = new List<Ratings_compiled__c>();
        Decimal i = 0;
        Decimal d = 0;
        Decimal aur = 0;

        //Total Day calculation
        for (Schedules__c sched : schedules) {
            i = i + sched.Sum_Spot_Equiv_30__c;
            d = d + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
        }
        if (i == 0 || d == 0) {
            return result;
        }
        for (String demoB : demos) {
            Ratings_compiled__c rcr = createIMPRating(program_c, demoB, 'Total Day', i, d, d / i);

            result.add(rcr);
        }
        i = 0.0;
        d = 0.0;
        for (String fdp : dayParts) {
            for (Schedules__c sched : schedules) {
                if (sched.Daypart__c == fdp) {
                    i = i + sched.Sum_Spot_Equiv_30__c;
                    d = d + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
                }
            }
            if (i == 0 || d == 0) {
                aur = 0;
            } else {
                aur = d / i;
            }
            for (String demoB : demos) {
                Ratings_compiled__c rcr = createIMPRating(program_c, demoB, fdp, i, d, aur);

                result.add(rcr);
            }
            i = 0.0;
            d = 0.0;
        }
        return result;
    }

    /**
    * @author Adrian Pichardo
    * @date 04/09/2018
    * @description returns a list of ratings for Programs that require seperate Weekday and Weekend ratings records,
    *             loops through demographics and the DA daypart to created these seperate records.
    * @param List<Schedules__c> scheduleWknd - List of schedules used in this method to get the appropriate information for the
    *                                          ratings records.
    * @param List<String> demoBegl - Demographic info for Bounce Escape Grit Laff (Respectively)
    * @param List<String> schedIds - List for a loop to get all DA schedules from the scheduleWknd list
    * @param Programs__c prog - Program that caused the trigger
    * @param decimal amf - calculates INV for weekday ratings
    * @param decimal bmf - calculates Total Dollar for weekday ratings
    * @param decimal ass - calculates INV for weekend ratings
    * @param decimal bss - calculates Total Dollar for weekend ratings
    * @param decimal zzz - calculates PI Payout for weekday DA ratings
    * @return List<Ratings_compiled__c> weekendRC - List of rating records that will be returned
    **/
    public List<Ratings_compiled__c>insertWkndRC(List<Schedules__c> scheduleWknd) {
        List<Ratings_compiled__c> weekendRC = new List<Ratings_compiled__c>();
        List<String> demoBegl = new List<String>{
                'F18-34', 'F18-99', 'F25-54', 'F25-99', 'F35-64', 'F35-99', 'F50-99', 'F55-99', 'F65-99', 'HH', 'M18-34', 'M18-49', 'M18-99', 'M25-54', 'M25-99', 'M35-64', 'M35-99', 'M50-99', 'M55-99', 'M65-99', 'P18-34', 'P18-49', 'P18-99', 'P25-54', 'P25-99', 'P35-64', 'P35-99', 'P50-99', 'P55-99', 'P65-99'
        };
        List<String> schedIds = new List<String>();
        Programs__c prog = scheduleWknd[0].Deal_Parent__r.Program__r;
        Date week = scheduleWknd[0].Week__c;
        Decimal amf = 0;
        Decimal bmf = 0;
        Decimal ass = 0;
        Decimal bss = 0;
        Decimal zzz = 0;
        Decimal aur = 0;

        for (Schedules__c sc : scheduleWknd) {
            if (sc.Daypart__c == 'DA') {
                schedIds.add(sc.Id);
            }
        }

        for (Schedules__c schedid : scheduleWknd) {
            if (schedid.Daypart__c == 'DA') {
                zzz = zzz + schedid.PI_Payout_TEST__c;
            }
        }

        // Select Spot_Data__c objects
        List<Spot_Data__c> spots = spotDataSelector.GetSpotDataWithScheduleIds(schedIds);

        for (Spot_Data__c spot : spots) {
            if (spot.Day_of_Week__c.contains('Mon') || spot.Day_of_Week__c.contains('Tue') || spot.Day_of_Week__c.contains('Wed') || spot.Day_of_Week__c.contains('Th') || spot.Day_of_Week__c.contains('Fri')) {
                amf = amf + spot.Spot_Equiv_30__c;
                bmf = bmf + spot.Spot_Rate__c;
            }
            if (spot.Day_of_Week__c.contains('Sat') || spot.Day_of_Week__c.contains('Sun')) {
                ass = ass + spot.Spot_Equiv_30__c;
                bss = bss + spot.Spot_Rate__c;
            }

        }

        if (amf == 0 || bmf == 0) {
            aur = 0;
        } else {
            aur = (bmf + zzz) / amf;
        }

        for (String demoE : demoBegl) {
            Ratings_compiled__c rc = createWKNDRating(prog, week, demoE, 'DA - MF', amf, bmf + zzz, aur);

            weekendRC.add(rc);
        }

        if (ass == 0 || bss == 0) {
            aur = 0;
        } else {
            aur = (bss + zzz) / ass;
        }
        for (String demoE : demoBegl) {
            Ratings_compiled__c rca = createWKNDRating(prog, week, demoE, 'DA - SS', ass, bss, aur);

            weekendRC.add(rca);
        }

        return weekendRC;

    }

    /**
     * dprc_BASE
     * @description Returns the base DP ratings (Ratings_compiled_c)
     *
     * @param result the mutable list of ratings (Ratings_compiled_c)
     * @param network the network (Programs__c)
     * @param scheds the schedules (Schedules__c) to use for calculating values
     *
     */
    public void dprc_BASE(List<Ratings_compiled__c> result, Programs__c network, List<Schedules__c> scheds) {
        Decimal ir = 0;
        Decimal dr = 0;
        Decimal aur = 0;

        //Total Day calculation
        for (Schedules__c sched : scheds) {
            ir = ir + sched.Sum_Spot_Equiv_30__c;
            dr = dr + sched.Spot_Total__c + sched.PI_Payout_TEST__c;
        }
        if (dr == 0 || ir == 0) {
            aur = 0;
        } else {
            aur = dr / ir;
        }

        Ratings_compiled__c rcr = defaultDPRating(network, 'HH', 'Total Day', ir, dr, aur);

        result.add(rcr);
    }

    /**
     * createIMPRating
     * @description Creates a rating (Ratings_compiled_c) object for IMP networks (Programs__c)
     *
     * @param network the network (Programs__c)
     * @param demo the demographic information
     * @param idp the dayPart information
     * @param ir the INV value
     * @param dr the Dollar_Amount value
     * @param aur the AUR value
     *
     * @return the rating (Ratings_compiled__c) object
     */
    public Ratings_compiled__c createIMPRating(Programs__c network, String demo, String idp, Decimal ir, Decimal dr, Decimal aur) {
        Ratings_compiled__c result = new Ratings_compiled__c(
            Program__c = network.Id,
            Playback__c = 'Live+SD | TV | Linear with VOD',
            Demographic__c = demo,
            Budget_Label__c = 'Actual',
            Type__c = 'Actual',
            Daypart__c = idp,
            Week__c = network.RCreconciled_Week__c,
            INV__c = ir,
            Dollar_Amount__c = dr,
            AUR__c = aur
        );
        return result;
    }

    /**
     * createWKNDRating
     * @description Creates a rating (Ratings_compiled_c) object for weekends
     *
     * @param network the network (Programs__c)
     * @param week the Date for Monday of the rating (Ratings_compiled_c)
     * @param demo the demographic information
     * @param idp the dayPart information
     * @param ir the INV value
     * @param dr the Dollar_Amount value
     * @param aur the AUR value
     *
     * @return the rating (Ratings_compiled__c) object
     */
    public Ratings_compiled__c createWKNDRating(Programs__c network, Date week, String demo, String idp, Decimal ir, Decimal dr, Decimal aur) {
        Ratings_compiled__c result = new Ratings_compiled__c(
            Program__c = network.id,
            Playback__c = 'Live+SD | TV | Linear with VOD',
            Demographic__c = demo,
            Budget_Label__c = 'Actual',
            Type__c = 'Actual',
            Daypart__c = idp,
            Week__c = week,
            INV__c = ir,
            Dollar_Amount__c = dr,
            AUR__c = aur
        );
        return result;
    }

    /**
     * createDPRating
     * @description Creates a rating (Ratings_compiled_c) object for DP networks (Programs__c)
     *
     * @param network the network (Programs__c)
     * @param demo the demographic information
     * @param idp the dayPart information
     * @param ir the INV value
     * @param dr the Dollar_Amount value
     * @param aur the AUR value
     *
     * @return the rating (Ratings_compiled__c) object
     */
    public Ratings_compiled__c defaultDPRating(Programs__c network, String demo, String idp, Decimal ir, Decimal dr, Decimal aur) {
        Ratings_compiled__c result = new Ratings_compiled__c(
            Program__c = network.Id,
            Playback__c = 'Live+SD | TV | Linear with VOD',
            Demographic__c = demo,
            Budget_Label__c = 'Actual',
            Type__c = 'Actual',
            Daypart__c = idp,
            Week__c = network.RCreconciled_Week__c,
            INV__c = ir,
            Dollar_Amount__c = dr,
            AUR__c = aur
        );
        return result;
    }
}