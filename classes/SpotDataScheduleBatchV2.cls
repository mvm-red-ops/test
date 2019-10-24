global class SpotDataScheduleBatchV2 implements Database.Batchable<SObject>, Database.Stateful {

    //
    // Fields
    //
    public SpotDataScheduleService service { get; set; }

    /**
     * Construct the SpotDataScheduleBatchV2 with a custom SpotDataScheduleService
     *
     * @param service The custom service being injected for the batch job
     */
    public SpotDataScheduleBatchV2(SpotDataScheduleService service) {
        service = service;
    }

    /**
     * Construct the SpotDataScheduleBatchV2 with a specified mirror list
     *
     * @param spotDataMirrorIdList Provide a custom list to the SpotDataScheduleService
     */
    public SpotDataScheduleBatchV2(List<Id> spotDataMirrorIdList) {
        service = new SpotDataScheduleService(spotDataMirrorIdList);
    }

    /**
     * Construct the SpotDataScheduleBatchV2 with a specified Network
     */
    public SpotDataScheduleBatchV2(String network) {
        service = new SpotDataScheduleService(network);
    }

    /**
     * @description Start the batch process
     * @param bc The BatchableContext provided
     * @return
     */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('SpotDataMirrorIdList - ' + service.spotDataMirrorIdList);
        String query = service.getSpotDataQuery();
        System.debug('Start: query locator SOQL ' + query);

        // Mark as processing
        service.updatePrelogBatchNetworksProcessing(true);

        // Begin execution on query results
        return Database.getQueryLocator(query);
    }

    /**
     * @description Execute the batch process
     * @param bc The BatchableContext provided
     * @param scope The scope
     */
    global void execute(Database.BatchableContext bc, List<SpotDataMirror__c> scope) {
        SpotDataScheduleService.processSpotDataRecords(scope);
    }

    /**
     * @description Finish the batch process
     * @param bc The BatchableContext provided
     */
    global void finish(Database.BatchableContext bc) {
        // Mark as done processing
        service.updatePrelogBatchNetworksProcessing(false);
        // Send out email
        service.dispatchEmail(new String[]{
                UserInfo.getUserEmail()
        });
    }

}