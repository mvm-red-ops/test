@IsTest
private class ProcessRatingsTest {

    @IsTest static void ProcessRatings_errorMessage_noEntries() {
        // Ensure function returns false if no rating entries exist
        Programs__c program = new ProgramTestSelector().GetPrograms(null)[0];
        System.assert(!ProcessRatings.errorMessage(program));
    }

    @IsTest static void ProcessRatings_errorMessage_someEntries() {
        // Ensure function returns true if some rating entries exist
        Programs__c program = new ProgramTestSelector().GetPrograms(null)[0];
        ProcessRatings.setRatingSelector(new RatingTestSelector());
        System.assert(ProcessRatings.errorMessage(program));
    }

    @IsTest static void ProcessRatings_CreateRatings_NoRatings() {

        // Initialize selectors
        ProcessRatings.setProgramSelector(new ProgramTestSelector());
        ProcessRatings.setRatingSelector(new RatingSelector());
        ScheduleSelector s = new ScheduleTestSelector();
        SpotDataSelector sp = new SpotDataTestSelector();
        ProcessRatings.setScheduleSelector(s);
        ProcessRatings.setSpotDataSelector(sp);
        Program.setScheduleSelector(s);
        Program.setSpotDataSelector(sp);

        Integer size = 0;
        try {
            // Not a valid program so no ratings will be found
            ProgramTestSelector.setPos(1337);
            ProcessRatings.CreateRatings(new List<Id>());
            size = getSize();

            // Assert no ratings inserted
            System.assertEquals(0,size);

        } catch (Exception e) {
            System.debug(e.getStackTraceString());

            // Assert false if failure
            System.assert(false);
        }
    }

    private static Integer getSize() {
        return new RatingSelector().GetRatings(new List<SObjectField>{Schedules__c.Id}).size();
    }

    private static Integer getDiffSize(Integer size) {
        return getSize() - size;
    }


    @IsTest static void ProcessRatings_CreateRatings_ImpRatings() {

        // Initialize selectors
        ProgramSelector programSelector = new ProgramTestSelector();
        ScheduleSelector s = new ScheduleTestSelector();
        SpotDataSelector sp = new SpotDataTestSelector();
        ProcessRatings.setProgramSelector(programSelector);
        ProcessRatings.setRatingSelector(new RatingSelector());
        ProcessRatings.setScheduleSelector(s);
        ProcessRatings.setSpotDataSelector(sp);
        Program.setScheduleSelector(s);
        Program.setSpotDataSelector(sp);

        Integer size = 0;
        List<Integer> diffs = new List<Integer> {6,240,240,240,240,170,204,130};
        for (Integer i = 0; i < 8; i++) {
            ProgramTestSelector.setPos(i);
            try {
                // Insert ratings
                ProcessRatings.CreateRatings(new List<Id>());
                Integer diffSize = getDiffSize(size);
                size = getSize();
                System.debug('\'' + programSelector.GetProgramsWithIds(null)[0].Name + '\' diffSize: ' + diffSize);

                // Assert amount inserted is correct
                System.assertEquals(diffs[i], diffSize);

            } catch (Exception e) {
                System.debug(e.getMessage() + '::' + e.getStackTraceString());

                // Assert false if failure
                System.assert(false);
            }
        }

    }

    @IsTest static void ProcessRatings_CreateRatings_DPRatings() {

        // Initialize selectors
        ProgramSelector programSelector = new ProgramTestSelector();
        ScheduleSelector s = new ScheduleTestSelector();
        SpotDataSelector sp = new SpotDataTestSelector();
        ProcessRatings.setProgramSelector(programSelector);
        ProcessRatings.setRatingSelector(new RatingSelector());
        ProcessRatings.setScheduleSelector(s);
        ProcessRatings.setSpotDataSelector(sp);
        Program.setScheduleSelector(s);
        Program.setSpotDataSelector(sp);

        Integer size = 0;
        List<Integer> diffs = new List<Integer> {116,1,1,1,1,4,6,6,5};
        for (Integer i = 8; i < 17; i++) {
            ProgramTestSelector.setPos(i);
            try {
                // Insert ratings
                ProcessRatings.CreateRatings(new List<Id>());
                Integer diffSize = getDiffSize(size);
                size = getSize();
                System.debug('\'' + programSelector.GetProgramsWithIds(null)[0].Name + '\' diffSize: ' + diffSize);

                // Assert amount inserted is correct
                System.assertEquals(diffs[i - 8], diffSize);

            } catch (Exception e) {
                System.debug(e.getMessage() + '::' + e.getStackTraceString());

                // Assert false if failure
                System.assert(false);
            }
        }

    }
}