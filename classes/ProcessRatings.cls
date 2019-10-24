public class ProcessRatings {

    // Selectors
    private static ProgramSelector programSelector = new ProgramSelector();
    private static RatingSelector ratingSelector = new RatingSelector();
    private static ScheduleSelector scheduleSelector = new ScheduleSelector();
    private static SpotDataSelector spotDataSelector = new SpotDataSelector();

    public static void setProgramSelector(ProgramSelector pSelector) {
        programSelector = pSelector;
    }

    public static void setRatingSelector(RatingSelector rSelector) {
        ratingSelector = rSelector;
    }

    public static void setScheduleSelector(ScheduleSelector sSelector) {
        scheduleSelector = sSelector;
    }

    public static void setSpotDataSelector(SpotDataSelector spSelector) {
        spotDataSelector = spSelector;
    }

    /**
    * @author Adrian Pichardo
    * @date 04/09/2018
    * @description main method: inserts ratings list(depending on the Program name)
    * @param List<String> impProg - List of Programs with specific demographic information
    * @param List<Ratings_compiled__c> ratingsList - The list that gets inserted into Salesforce with ratings records
    * @param Boolean blankImp - Boolean that controls method invocation; also lets the class know if ratings exist.
    * @param List<Programs_c> Program - Collects the Program being triggered for ratings creation.
    **/
    @InvocableMethod
    public static void CreateRatings(List<Id> ProgramIds) {
        // Get networks based on given Ids
        List<Programs__c> Program = programSelector.GetProgramsWithIds(ProgramIds);
        if (Program.isEmpty()) {
            return;
        }

        Map<String, Program> progs = new Map<String, Program>{
                'BounceTV - Local' => new Program_BounceTVLocal(Program[0]),
                'BounceTV' => new Program_BounceTV(Program[0]),
                'Escape' => new Program_BounceTV(Program[0]),
                'Grit' => new Program_BounceTV(Program[0]),
                'Laff' => new Program_BounceTV(Program[0]),
                'AntennaTV' => new Program_AntennaTV(Program[0]),
                'Justice' => new Program_JusticeNetwork(Program[0]),
                'ThisTV' => new Program_ThisTV(Program[0]),
                'Stadium' => new Program_Stadium(Program[0]),
                'MLB' => new Program_MLB(Program[0]),
                'NHL' => new Program_MLB(Program[0]),
                'Newsy' => new Program_MLB(Program[0]),
                'TVG' => new Program_TVG(Program[0]),
                'MGM' => new Program_MGM(Program[0]),
                'Quest' => new Program_MGM(Program[0])
        };

        // Determine if program has specific demographic information
        Program prog = checkContains(progs, Program[0].Name);
        if (prog != null) {
            Database.executeBatch(new RatingsBatchClass(prog.getRatings()), 100);
            //insert prog.getRatings();
            return;
        }

        // If team is 'Onyx'
        if (Program[0].Team__c.equals('Onyx')) {
            Database.executeBatch(new RatingsBatchClass(prog.getRatings()), 100);

            //insert (new Program_Onyx(Program[0])).getRatings();
            return;
        }

        // Otherwise
             Database.executeBatch(new RatingsBatchClass(prog.getRatings()), 100);

        //insert (new Program_OtherDP(Program[0])).getRatings();

    }

    private static Program checkContains(Map<String, Program> progs, String check) {
        for (String key : progs.keySet()) {
            if (check.contains(key)) {
                return progs.get(key);
            }
        }
        return null;
    }

    /**
     * errorMessage
     * @description Checks if the select for ratings returns any data
     *
     * @param network the network (Programs__c)
     *
     * @return Boolean representing if data exists
     */
    public static Boolean errorMessage(Programs__c network) {
        return !ratingSelector.GetRatingsForProgram(network).isEmpty();
    }

}