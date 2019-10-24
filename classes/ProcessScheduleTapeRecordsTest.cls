/**
 * @date 1/9/2019
 * @description Test the ProcessScheduleTapeRecords (PSTR) Page
 */
@IsTest
private class ProcessScheduleTapeRecordsTest {

    /* Database Selectors */
    static ScheduleSelector schSelector;
    static TapeSelector tapeSelector;

	/* Set up test variables */
	private static ApexPages.StandardSetController ssc;
	private static ProcessScheduleTapeRecords pstr;

	/**
	 * Run setup before each test
	 */
	private static void basicSetup() {
        // Set test page
        Test.setCurrentPage(Page.ProcessScheduleTapeRecords);

        // Establish PSTR
        ssc = new ApexPages.StandardSetController(new List<Schedules__c>());
        pstr = new ProcessScheduleTapeRecords(ssc);

        // Verify FilterID
        if (pstr.filterId != null) {
            // Ensure valid substring
            System.assert(pstr.filterId.length() <= 15);
        }

        // Set up fake Database Selectors
        tapeSelector = new TapeTestSelector();
        schSelector = new ScheduleTestSelector();
        pstr.schSelector = schSelector;
        pstr.tapeSelector = tapeSelector;
	}

	/**
	 * Test the result of no records on the page
	 */
	@IsTest
    static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_NoRecordsTest() {
		basicSetup();
        processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestRecordAmount(0);
	}

	/**
	 * Test the result of one record on the page
	 */
	@IsTest
    static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_SingleRecordTest() {
        basicSetup();
        processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestRecordAmount(1);
	}

	/**
	 * Test the result of multiple records on the page
	 */
	@IsTest
    static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_MultipleRecordsTest() {
        basicSetup();
        processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestRecordAmount(8);
    }

    /**
     * Test the result of an error occurring on the page
     */
    @IsTest
    static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_InvalidRecordTest() {
        basicSetup();
        pstr.schSelector = null;
        pstr.processScheduleTapeRecordsMethod();

        List<String> expectedErrors = new List<String>{
                'Error - Attempt to de-reference a null object',
                'Line Number - '
        };
        processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestPageErrors(expectedErrors);
    }

    /**
     * Test the result of pressing the "go back" button
     */
    @IsTest
    static void processScheduleTapeRecords_GoBackButton_ValidGoBackTest() {
        basicSetup();

        // Expected redirection paths
        String WITH_FILTER = '/a08?fcf=';
        String WITHOUT_FILTER = '/a08';

        String savedFilter = String.valueOf(pstr.filterId);

        // Go back (without filter)
        try {
            pstr.filterId = null;
            Test.setCurrentPage(pstr.goBackButton());
        } catch (Exception ex) {
            System.assert(false, '');
        }

        // Ensure we have gone back (without filter)
        System.assertEquals(ApexPages.currentPage().getUrl(), WITHOUT_FILTER);

        // Reset page
        Test.setCurrentPage(Page.ProcessScheduleTapeRecords);

        // Go back (with filter)
        try {
            pstr.filterId = savedFilter;
            Test.setCurrentPage(pstr.goBackButton());
        } catch (Exception ex) {
            System.assert(false, '');
        }

        // Ensure we have gone back (with filter)
        System.assertEquals(ApexPages.currentPage().getUrl(), WITH_FILTER + pstr.filterId);
    }

    /**
     * Perform a record test with a specified amount of fabricated schedules
     *
     * @param amount The amount of fabricated ("mocked") schedules
     */
    private static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestRecordAmount(Integer amount) {
        // Setup TestSelector Fabrication Settings
        ((ScheduleTestSelector) pstr.schSelector).fabricationAmount = amount;
        ((ScheduleTestSelector) pstr.schSelector).fabricationFields = new Map<SObjectField, Object>{
                Schedules__c.UnitLength__c => 60
        };
        ((TapeTestSelector) pstr.tapeSelector).fabricationAmount = amount;
        ((TapeTestSelector) pstr.tapeSelector).fabricationFields = new Map<SObjectField, Object>{
                Tape__c.Length__c => '60'
        };

        // Run main method
        pstr.processScheduleTapeRecordsMethod();

        // Make sure we have nothing selected
        List<Schedules__c> testList = new List<Schedules__c>();
        System.assertEquals(testList, ssc.getSelected());

        // Make sure ssc has no records
        System.assertEquals(testList, ssc.getRecords());

        System.debug(pstr.wrapperList);

        // Verify WrapperList empty
        System.assertEquals(amount, pstr.wrapperList.size());
    }


    /**
     * Test the page for expected errors occurring
     *
     * @param expectedErrors The list of expected errors to occur
     */
    private static void processScheduleTapeRecords_ProcessScheduleTapeRecordsMethod_TestPageErrors(List<String> expectedErrors) {
        List<ApexPages.Message> receivedErrors = ApexPages.getMessages();

        // Ensure same error size
        System.assertEquals(expectedErrors.size(), receivedErrors.size());

        // Ensure same errors
        for (ApexPages.Message message : receivedErrors) {
            System.assert(expectedErrors.contains(message.getSummary().replaceAll('\\d', '')));
        }
    }
}