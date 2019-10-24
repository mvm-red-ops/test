/**
 * @date 1/10/2019
 * @description Unit Testing for TapeScheduleFind.cls
 */
@IsTest
public with sharing class TapeScheduleFindTest {

    //
    // Testing Variables
    //
    private static TapeTestSelector tapeSelector = null;
    private static ScheduleTestSelector scheduleSelector = null;
    private static ApexPages.StandardController tsc;
    private static TapeScheduleFind tsf;

    //
    // (Valid) Mock Objects
    //
    static Account acct;
    static Advertiser__c advertiser;
    static Brands__c brand;
    static Programs__c program;
    static Contact con;
    static Deal__c deal;

    /**
     * @description Initialize basic testing environment to be used throughout tests
     */
    private static void basicSetup() {
        setupMocks();
        tapeSelector = new TapeTestSelector();
        scheduleSelector = new ScheduleTestSelector();
        Test.setCurrentPage(Page.TapeScheduleFind);
    }

    /**
     * @description Set up the mock objects for testing
     */
    private static void setupMocks() {
        acct = new Account(Name = Utils.randomString(8));
        insert acct;
        advertiser = new Advertiser__c(
                Name = 'NordVPN',
                Duplicate_Approval__c = 'Approved'
        );
        insert advertiser;
        brand = new Brands__c(
                Name = Utils.randomString(8),
                Category__c = 'Other',
                Advertiser__c = advertiser.Id,
                Approved_Duplicate__c = 'Approved'
        );
        insert brand;
        program = new Programs__c(
                Name = Utils.randomString(8),
                ClientCode__c = 'TST'
        );
        insert program;
        con = new Contact(
                FirstName = 'TEST',
                LastName = 'TEST',
                Email = 'test@test.com',
                Phone = '5555551212'
        );
        insert con;
        deal = new Deal__c(
                Contact__c = con.Id,
                Status__c = 'Sold',
                Length__c = '30',
                Brands__c = brand.Id,
                Program__c = program.Id,
                PI__c = false
        );
        insert deal;
    }

    /**
     * @description Test the result of an invalid Tape
     */
    @IsTest
    static void tapeScheduleFind_PageSetup_TestInvalidTape() {
        // Run basic test setup
        basicSetup();

        // Setup StdController with InvalidTapeRecord
        tsc = new ApexPages.StandardController(getInvalidTape());
        tsf = new TapeScheduleFind(tsc);

        List<String> errorMessages = new List<String>{
                'Error - List has no rows for assignment to SObject',
                'Line Number - '
        };

        // Verify errors
        verifyErrorMessage(errorMessages);
    }

    /**
     * @description Test the result of loading page with a tape that doesn't match a valid schedule
     */
    @IsTest
    static void tapeScheduleFind_PageSetup_TestInvalidTapeRecordValues() {
        // Run basic setup
        basicSetup();

        // Setup StdController
        tsc = new ApexPages.StandardController(getInvalidTape());
        tsf = new TapeScheduleFind(tsc, scheduleSelector, tapeSelector);

        // Ensure same num of warning messages
        List<String> errorMessages = new List<String>{
                'The Tape record is missing values to compare against schedules'
        };
        System.assertEquals(errorMessages.size(), ApexPages.getMessages().size());

        // Ensure all warning messages are the same
        for (ApexPages.Message message : ApexPages.getMessages()) {
            System.assert(errorMessages.contains(message.getSummary()));
            System.assertEquals(message.getSeverity(), ApexPages.Severity.INFO);
        }
    }

    /**
     * @description Test the result of loading the page with no matching schedules for the Tape
     */
    @IsTest
    static void tapeScheduleFind_PageSetup_TestNoMatchingSchedules() {
        // Run basic setup
        basicSetup();

        // Mock "valid" tape
        Tape__c validTapeRecord = getValidTape();
        // NOTE: Schedule is not mocked and modified because we are testing the result of having 0 matching schedules

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);

        // Setup StdController
        tsc = new ApexPages.StandardController(validTapeRecord);
        tsf = new TapeScheduleFind(tsc, scheduleSelector, tapeSelector);

        // Ensure same num of warning messages
        List<String> errorMessages = new List<String>{
                'There were no matching schedules found'
        };
        System.assertEquals(errorMessages.size(), ApexPages.getMessages().size());

        // Ensure all warning messages are the same
        for (ApexPages.Message message : ApexPages.getMessages()) {
            System.assert(errorMessages.contains(message.getSummary()));
            System.assertEquals(message.getSeverity(), ApexPages.Severity.INFO);
        }
    }

    /**
     * @description Test the result of loading the page with a valid Tape__c
     */
    @IsTest
    static void tapeScheduleFind_PageSetup_TestValidTape() {
        // Run basic setup
        basicSetup();

        // Mock "valid" tape
        Tape__c validTapeRecord = getValidTape();
        Schedules__c validSchedule = getValidSchedule(validTapeRecord);

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);
        scheduleSelector.fabricatedList.add(validSchedule);

        // Setup StdController
        tsc = new ApexPages.StandardController(validTapeRecord);
        tsf = new TapeScheduleFind(tsc, scheduleSelector, tapeSelector);

        // Ensure WrapperList size
        System.assertEquals(tsf.scheduleWrapperList.size(), 1);

        // Ensure WrapperList contents
        System.assertEquals(validSchedule.Name, tsf.scheduleWrapperList.get(0).scheduleRecord.Name);
    }

    /**
     * @description Test the result of the "Save" Button action
     *  Tests a valid result
     */
    @IsTest
    static void tapeScheduleFind_SaveButton_TestValidSaveButton() {
        // Run basic setup
        basicSetup();

        // Mock Objects
        Tape__c validTapeRecord = getValidTape();
        Schedules__c validSchedule = getValidSchedule(validTapeRecord);

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);
        scheduleSelector.fabricatedList.add(validSchedule);

        // Setup StdController (with null values to skip PageSetup)
        tsf = new TapeScheduleFind(null, null, null);
        tsf.tapeRecord = validTapeRecord;

        // Reset ScheduleWrapperList & Select Entry
        TapeScheduleFind.ScheduleWrapper fabScheduleWrapper = new TapeScheduleFind.ScheduleWrapper(validSchedule);
        fabScheduleWrapper.selected = true;
        tsf.scheduleWrapperList = new List<TapeScheduleFind.ScheduleWrapper>{
                fabScheduleWrapper
        };

        // Save button press
        Test.setCurrentPage(tsf.saveButton());

        // Verify page update
        System.assertEquals('/' + validTapeRecord.Id, ApexPages.currentPage().getUrl());

        // Verify successful update
        Schedules__c updatedSchedule = getUpdatedScheduleData(validSchedule.Id);
        System.assertNotEquals(null, updatedSchedule.Name);
        System.assertEquals(validTapeRecord.ISCI__c, updatedSchedule.ISCI_CODE__c);
        System.assertEquals(validTapeRecord.ISCI_2__c, updatedSchedule.ISCI2__c);
        System.assertEquals(validTapeRecord.ISCI_3__c, updatedSchedule.ISCI3__c);
        System.assertEquals(validTapeRecord.Rotation__c, updatedSchedule.Rotation__c);
        System.assertEquals(validTapeRecord.X800_Number__c, updatedSchedule.X800_Number__c);
        System.assertEquals(validTapeRecord.Id, updatedSchedule.Traffic__c);
    }

    /**
     * @description Test the result of the "Save" Button action
     *  Tests an invalid result
     */
    @IsTest
    static void tapeScheduleFind_SaveButton_TestInvalidSaveButton() {
        // Run basic setup
        basicSetup();

        // Mock Objects
        Tape__c validTapeRecord = getValidTape();

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);

        // Setup StdController
        tsc = new ApexPages.StandardController(validTapeRecord);
        tsf = new TapeScheduleFind(null, null, null);
        tsf.tapeRecord = null;

        // Attempt save
        tsf.saveButton();

        List<String> errorMessages = new List<String>{
                'Error - Attempt to de-reference a null object',
                'Line Number - '
        };

        // Verify errors
        verifyErrorMessage(errorMessages);
    }

    /**
     * @description Test the result of the "Cancel" Button action
     *  Tests a valid result
     */
    @IsTest
    static void tapeScheduleFind_CancelButton_TestValidCancelButton() {
        // Run basic setup
        basicSetup();

        // Mock Objects
        Tape__c validTapeRecord = getValidTape();
        Schedules__c validSchedule = getValidSchedule(validTapeRecord); // This will link the inserted schedule with the tape record during testing

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);
        scheduleSelector.fabricatedList.add(validSchedule);

        // Setup StdController
        tsc = new ApexPages.StandardController(validTapeRecord);
        tsf = new TapeScheduleFind(null, null, null);
        tsf.tapeRecord = validTapeRecord;

        // Save button press
        Test.setCurrentPage(tsf.cancelButton());

        // Verify page update
        System.assertEquals(ApexPages.currentPage().getUrl(), '/' + validTapeRecord.Id);
    }

    /**
     * @description Test the result of the "Cancel" Button action
     *  Tests an invalid result
     */
    @IsTest
    static void tapeScheduleFind_CancelButton_TestInvalidCancelButton() {
        // Run basic setup
        basicSetup();

        // Mock "valid" tape
        Tape__c validTapeRecord = getValidTape();

        // Add entries to fab list
        tapeSelector.fabricatedList.add(validTapeRecord);

        // Setup StdController
        tsc = new ApexPages.StandardController(validTapeRecord);
        tsf = new TapeScheduleFind(null, null, null);
        tsf.tapeRecord = null;

        // Attempt save
        tsf.cancelButton();

        List<String> errorMessages = new List<String>{
                'Error - Attempt to de-reference a null object',
                'Line Number - '
        };

        // Verify errors
        verifyErrorMessage(errorMessages);
    }

    /**
     * @description Verify standard set of error messages
     */
    private static void verifyErrorMessage(List<String> errorMessages) {
        // Ensure the same num of error messages
        System.assertEquals(errorMessages.size(), ApexPages.getMessages().size());

        // Ensure Correct Error Message
        List<ApexPages.Message> messages = ApexPages.getMessages();
        for (ApexPages.Message message : messages) {
            // Replace numbers because line number is inconsistent
            System.assert(errorMessages.contains(message.getSummary().replaceAll('\\d', '')));
            System.assertEquals(message.getSeverity(), ApexPages.Severity.ERROR);
        }
    }

    /**
     * @description Mock an "invalid" Tape__c object.
     *  This will NOT insert the tape into the database.
     *  This will give a Tape__c with a NULL Id.
     *
     * @return The "invalid" (or not inserted) tape object.
     */
    private static Tape__c getInvalidTape() {
        Tape__c invalidTapeRecord = null;
        tapeSelector.fabricationFields = new Map<SObjectField, Object>{
                Tape__c.Id => null
        };
        invalidTapeRecord = tapeSelector.getTapeFromId(null);
        return invalidTapeRecord;
    }

    /**
     * Mock a Valid Tape__c object
     *  This will automatically insert the valid tape into the Test database
     *
     * @return The valid mocked Tape__c object
     */
    private static Tape__c getValidTape() {
        Tape__c validTapeRecord = new Tape__c(
                Account__c = acct.Id,
                Brand__c = brand.Id,
                Program__c = program.Id,
                Flight_Start__c = Date.newInstance(2019, 1, 1),
                Flight_End__c = Date.newInstance(2019, 1, 1),
                Length__c = '1',
                ISCI__c = Utils.randomString(8),
                ISCI_2__c = Utils.randomString(8),
                ISCI_3__c = Utils.randomString(8),
                Rotation__c = 'Spot',
                X800_Number__c = con.Phone
        );
        insert validTapeRecord;
        return validTapeRecord;
    }

    /**
     * @description Retrieve a valid Schedule with the Traffic (Tape__c) set to the provided one
     *
     * @param validTapeRecord The Traffic field being set
     *
     * @return The valid, inserted Schedule__c object
     */
    private static Schedules__c getValidSchedule(Tape__c validTapeRecord) {
        Schedules__c fabSchedule = new Schedules__c(
                Traffic__c = validTapeRecord.Id,
                Start_Time__c = '01:00A',
                End_Time__c = '01:30A',
                Week__c = Date.newInstance(2019, 1, 7),
                Deal_Parent__c = deal.Id,
                Units_Available__c = 1,
                Rate__c = 1
        );
        insert fabSchedule;
        return fabSchedule;
    }

    /**
     * Pull out data from schedule that was updated from Tape Record
     * @param scheduleId The schedule Id being selected from
     * @return The resulting Schedule__c with data that was updated
     */
    private static Schedules__c getUpdatedScheduleData(Id scheduleId) {
        return [
                SELECT Name,
                        ISCI_CODE__c,
                        ISCI2__c,
                        ISCI3__c,
                        Rotation__c,
                        X800_Number__c,
                        Traffic__c
                FROM Schedules__c
                WHERE Id = :scheduleId
                LIMIT 1
        ];
    }

}