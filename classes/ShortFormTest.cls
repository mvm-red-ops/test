@isTest
public with sharing class ShortFormTest {

    @testsetup
    private static void setup() {
        insert new Prelog_Batch_Networks__c(Name = 'test');
    }

    @isTest
    private static void shortForm_startBatchJobPostLog_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.StartBatchJobPostLog();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    @isTest
    private static void shortForm_startBatchPreLog_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.StartBatchJobPreLog();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    @isTest
    private static void shortForm_startBatchNextWeekPreLog_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.StartBatchJobNextWeekPreLog();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    @isTest
    private static void shortForm_startSpotDataMirrorBatchJob_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.spotNetwork = 'test';
        form.StartSpotDataMirrorBatchJob();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    @isTest
    private static void shortForm_startSpotDataMirrorWithSchedulesBatchJob_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.spotNetwork = 'test';
        form.startSpotDataMirrorWithSchedulesBatchJob();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    @isTest
    private static void shortForm_startPreLogDataMirrorBatchJob_batchStarted() {
        ShortForm form = new ShortForm();
        Test.startTest();
        form.spotNetwork = 'test';
        form.startPreLogDataMirrorBatchJob();
        Test.stopTest();

        List<AsyncApexJob> jobsApexBatch = getApexBatchJobs();
        System.assertEquals(1, jobsApexBatch.size());
    }

    private static List<AsyncApexJob> getApexBatchJobs() {
        return [SELECT Id,
                       ApexClassID,
                       ApexClass.Name,
                       Status,
                       JobType
                  FROM AsyncApexJob
                 WHERE JobType = 'BatchApex'];
    }


}