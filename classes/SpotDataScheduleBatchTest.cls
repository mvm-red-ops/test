/**
 * @date 1/15/2019
 * @description Unit testing for SpotDataScheduleBatch.cls
 */
@IsTest
public with sharing class SpotDataScheduleBatchTest {

    //
    // Constants
    //
    private final static String SETTING_NAME = 'Quest';
    private final static String ALL_NETWORK_NAME = 'All';

    //
    // Testing Variables
    //
    private static TestSpotDataSelector spotDataSelector;
    private static SpotDataScheduleBatch batch;
    private static SpotDataScheduleService instance;

    /**
     * @description Method to run basic setup instructions in the beginning of each test
     */
    private static void basicSetup() {
        spotDataSelector = new TestSpotDataSelector();
        instance = new SpotDataScheduleService(SETTING_NAME);
        batch = new SpotDataScheduleBatch(instance);
        SpotDataScheduleService.spotDataSelector = spotDataSelector;

        // Create custom settings for retrieval
        Prelog_Batch_Networks__c testSetting = new Prelog_Batch_Networks__c(
                Name = SETTING_NAME
        );
        insert testSetting;
    }

    /**
     * @description Test the result of constructing a SpotDataScheduleBatch with different network names
     */
    @IsTest
    static void SpotDataScheduleBatch_SpotDataScheduleBatch_TestValidNetworkConstruction() {
        basicSetup();

        // Test random network name
        String networkName = Utils.randomString(8);
        instance = new SpotDataScheduleService(networkName);
        batch = new SpotDataScheduleBatch(networkName);
        System.assertEquals(networkName, instance.network);

        // Test 'All' networks
        String allNetworkName = ALL_NETWORK_NAME;
        instance = new SpotDataScheduleService(allNetworkName);
        batch = new SpotDataScheduleBatch(networkName);
        System.assertEquals('', instance.network);
    }

    /**
     * @description Test the result of constructing a SpotDataScheduleBatch with a few different lists
     */
    @IsTest
    static void SpotDataScheduleBatch_SpotDataScheduleBatch_TestMirrorIdListConstruction() {
        basicSetup();

        // Test Empty Mirror List
        List<Id> testList = new List<Id>();
        batch = new SpotDataScheduleBatch(testList);
        testListSizeAndContents(SpotDataScheduleBatch.service.spotDataMirrorIdList, testList);

        // Test Size-1 List
        List<Id> testList2 = new List<Id>{
                Id.valueOf('0018000000Lz2g1AAB')
        };
        batch = new SpotDataScheduleBatch(testList2);
        testListSizeAndContents(SpotDataScheduleBatch.service.spotDataMirrorIdList, testList2);

        // Test Multi-Size List (8)
        List<Id> testList3 = new List<Id>{
                Id.valueOf('0010R00000VLDM1QAP'),
                Id.valueOf('0018000000Lz2ftAAB'),
                Id.valueOf('0018000000Lz2fuAAB'),
                Id.valueOf('0018000000Lz2fwAAB'),
                Id.valueOf('0018000000Lz2fxAAB'),
                Id.valueOf('0018000000Lz2fyAAB'),
                Id.valueOf('0018000000Lz2fzAAB'),
                Id.valueOf('0018000000Lz2g0AAB')
        };
        batch = new SpotDataScheduleBatch(testList3);
        System.assertEquals(SpotDataScheduleBatch.service.spotDataMirrorIdList, testList3);
    }

    /**
     * @description Test the result of retrieving and processing data from the database, rather than providing a list of Ids
     */
    @IsTest
    static void SpotDataScheduleService_processSpotDataRecords_TestProcessingNetworkAllList() {
        basicSetup();

        // Fill database with stuff
        List<Schedules__c> schedules = getMockSchedule(1);
        getMockSpotData(10, schedules, null);

        // Make sure list is null
        instance.spotDataMirrorIdList = null;

        // Begin batch job
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Test successful batch job
        testValidInsertionAndUpdates(schedules.get(0).Id);
    }

    /**
     * @description Test the result of providing an empty list of Ids to be processed
     *  This should force the data to be pulled from a time frame specified
     */
    @IsTest
    static void SpotDataScheduleService_processSpotDataRecords_TestProcessingEmptyIdList() {
        basicSetup();

        List<Schedules__c> schedules = getMockSchedule(1);
        getMockSpotData(10, schedules, null);

        // Make sure list is empty
        List<Id> testList = new List<Id>();
        instance = new SpotDataScheduleService(testList);
        batch = new SpotDataScheduleBatch(instance);

        // Avoid network null
        instance.network = SETTING_NAME;

        // Begin batch job
        Test.startTest();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        // Test successful batch job
        testValidInsertionAndUpdates(schedules.get(0).Id);
    }

    /**
     * @description Test the result of providing a filled list of Ids to be processed
     *  This should result in pulling SpotData from the database from the Ids provided
     */
    @IsTest
    static void SpotDataScheduleBatch_processSpotDataRecords_TestProcessingFilledIdList() {
        basicSetup();

        // Retrieve Mocked SpotData Ids
        List<Schedules__c> schedules = getMockSchedule(1);
        List<SpotDataMirror__c> spotDataMirrors = getMockSpotDataMirrors(10, schedules);
        List<Id> spotDataIds = new List<Id>();
        for (SpotDataMirror__c sdm : spotDataMirrors) {
            spotDataIds.add(sdm.Id);
        }
        instance = new SpotDataScheduleService(spotDataIds);
        batch = new SpotDataScheduleBatch(instance);
        SpotDataScheduleService.spotDataSelector = new SpotDataSelector();
        instance.network = SETTING_NAME;

        // Make sure selector will output data
        spotDataSelector.fabricatedList = getMockSpotData(10, schedules, spotDataMirrors);

        // Begin batch job
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

        // Test sucessful batch job
        testValidInsertionAndUpdates(schedules.get(0).Id);
    }

    /**
     * @description Test the result of having no data pulled from the database
     */
    @IsTest
    static void SpotDataScheduleService_processSpotDataRecords_TestInvalidSpotDataListProcessing() {
        basicSetup();

        List<Id> testList = new List<Id>{
                Id.valueOf('0010R00000VLDL8QAP'),
                Id.valueOf('0010R00000VLDLNQA5'),
                Id.valueOf('0010R00000VLDLrQAP'),
                Id.valueOf('0010R00000VLDLwQAP'),
                Id.valueOf('0010R00000VLDM1QAP'),
                Id.valueOf('0018000000Lz2ftAAB'),
                Id.valueOf('0018000000Lz2fuAAB'),
                Id.valueOf('0018000000Lz2fwAAB')
        };
        instance = new SpotDataScheduleService(testList);
        batch = new SpotDataScheduleBatch(instance);

        // Avoid network null
        instance.network = SETTING_NAME;

        // Begin batch job
        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();
    }

    /**
     * @description Helper method to test a list size and contents
     * @param expectedList The expected list size and contents
     * @param objectList The provided list size and contents
     */
    private static void testListSizeAndContents(List<Object> expectedList, List<Object> objectList) {
        // Check size
        System.assertEquals(expectedList.size(), objectList.size());

        // Check contents
        for (Object obj : objectList) {
            System.assert(expectedList.contains(obj));
        }
    }

    /**
     * @description Retrieve a list of mocked Schedule__c objects
     * @param amount The amount of mocked objects you want to fabricate
     * @return The inserted list of mocked objects
     */
    private static List<Schedules__c> getMockSchedule(Integer amount) {
        Contact con = new Contact(
                FirstName = 'FIRSTNAME',
                LastName = 'LASTNAME',
                Email = 'test@email.com',
                Phone = '5555555555'
        );
        insert con;
        Deal__c deal = new Deal__c(
                Contact__c = con.Id
        );
        insert deal;

        List<Schedules__c> result = new List<Schedules__c>();
        for (Integer i = 0; i < amount; i++) {
            Schedules__c schedule = new Schedules__c(
                    Deal_Parent__c = deal.Id,
                    Units_Available__c = 1,
                    Rate__c = 1
            );
            result.add(schedule);
        }
        insert result;
        return result;
    }

    /**
     * @description Retrieve a list of mocked Spot_Data__c objects
     * @param amount The amount of mocked objects you want to fabricate
     * @param mirrorMap OPTIONAL list of mirrors to map Id's to
     * @return The inserted list of mocked objects
     */
    private static List<Spot_Data__c> getMockSpotData(Integer amount, List<Schedules__c> scheduleMap, List<SpotDataMirror__c> mirrorMap) {
        List<Spot_Data__c> result = new List<Spot_Data__c>();
        for (Integer i = 0; i < amount; i++) {
            Spot_Data__c spotData = new Spot_Data__c(
                    Schedule__c = scheduleMap.get(0).Id
            );
            // Link to mirror reference
            if (mirrorMap != null && mirrorMap.size() > i) {
                spotData.SpotDataMirror_Reference__c = scheduleMap.get(0).Id + String.valueOf(mirrorMap.get(i).Id) + i;
            }
            result.add(spotData);
        }

        return result;
    }

    /**
     * @description Retrieve a list of mocked SpotDataMirror__c objects
     * @param amount The amount of mocked objects you want to fabricate
     * @return The inserted list of mocked objects
     */
    private static List<SpotDataMirror__c> getMockSpotDataMirrors(Integer amount, List<Schedules__c> scheduleMap) {
        List<SpotDataMirror__c> result = new List<SpotDataMirror__c>();

        for (Integer i = 0; i < amount; i++) {
            result.add(new SpotDataMirror__c(
                    Air_Date__c = Date.today(),
                    Air_Time__c = '02:00A',
                    Network__c = SETTING_NAME,
                    Network_Deal_Number__c = '0',
                    Spot_Rate__c = 0,
                    Schedule__c = scheduleMap.get(0).Id
            ));
        }
        insert result;
        return result;
    }

    /**
     * @description Retrieve a list of SpotDataMirror__c objects from an associated Schedule__c Id
     * @param scheduleId The Schedule__c Id being compared
     * @return The resulting list of SpotDataMirror__c objects
     */
    private static List<SpotDataMirror__c> getMirrorsFromScheduleId(Id scheduleId) {
        return [
                SELECT  Id,
                        Spot_Data__c,
                        ErrorReason__c,
                        Schedule__c,
                        Problem__c
                   FROM SpotDataMirror__c
                  WHERE Schedule__c = :scheduleId
        ];
    }

    /**
     * @description Retrieve a list of Spot_Data__c objects from an associated Schedule__c Id
     * @param scheduleId The Schedule__c Id being compared
     * @return The resulting list of Spot_Data__c objects
     */
    private static List<Spot_Data__c> getDataFromScheduleId(Id scheduleId) {
        return [
                SELECT  Id,
                        SpotDataMirror__c,
                        Schedule__c
                   FROM Spot_Data__c
                  WHERE Schedule__c = :scheduleId
        ];
    }

    /**
     * @description Retrieve a SpotDataMirror__c object with desired fields from it's Id
     * @param mirrorId The Id being used to retrieve the SpotDataMirror__c object
     * @return The resulting SpotDataMirror__c object
     */
    private static SpotDataMirror__c getMirrorFromId(Id mirrorId) {
        return [
                SELECT  Id,
                        Spot_Data__c,
                        ErrorReason__c,
                        Schedule__c,
                        Problem__c
                   FROM SpotDataMirror__c
                  WHERE Id = :mirrorId
        ];
    }

    /**
     * @description Run assertions to validate that processSpotDataRecords is performing its database insertions and updates properly
     * @param scheduleId The Id of the Schedule__c object being used to access the database records
     */
    private static void testValidInsertionAndUpdates(Id scheduleId) {
        // Re-query for spot data mirrors
        List<SpotDataMirror__c> mirrors = getMirrorsFromScheduleId(scheduleId);
        List<Spot_Data__c> data = getDataFromScheduleId(scheduleId);

        System.assertEquals(data.size(), mirrors.size());

        // Verify SpotDataMirror__c was updated
        for (Integer i = 0; i < data.size(); i++) {
            Spot_Data__c sd = data.get(i);
            SpotDataMirror__c sdm = getMirrorFromId(String.valueOf(sd.SpotDataMirror__c));

            System.assertEquals(sd.SpotDataMirror__c, sdm.Id);
            System.assertEquals(sd.Id, sdm.Spot_Data__c);
            System.assertEquals(null, sdm.ErrorReason__c);
            System.assertEquals(sd.Schedule__c, sdm.Schedule__c);
            System.assertEquals(false, sdm.Problem__c);
        }
    }

}