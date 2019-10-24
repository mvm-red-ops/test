public class ShortForm
{
    public String prelogNetwork { get; set; }
    public String spotNetwork { get; set; }

    public List<SelectOption> getNetworks() {
        List<SelectOption> optionList = new List<SelectOption>() ;
        optionList.add(new SelectOption('---', '---'));
        List<Prelog_Batch_Networks__c> networks = Prelog_Batch_Networks__c.getAll().values();
        for(Prelog_Batch_Networks__c n : networks) {
            optionList.add(new SelectOption(n.Name, n.Name));
        }
        System.debug('***ShortForm.getNetworks: optionList' + optionList);

        return optionList ;
    }

    public ShortForm()
    {
    }
    public void StartBatchJob()
    {
        Database.executeBatch(new ContactAiredBatch(),10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Deprecated, please use the buttons below.'));
    }
    public void StartBatchJobPostLog()
    {
        Database.executeBatch(new ContactAiredBatchV2('PostLogButton'),10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Dates Batch has started. You can monitor the status of the batch at Setup -> Administration Setup -> Monitoring -> Apex Jobs'));
    }
    public void StartBatchJobPreLog()
    {
        Database.executeBatch(new ContactAiredBatchV2('PreLogButton'),10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Dates Batch has started. You can monitor the status of the batch at Setup -> Administration Setup -> Monitoring -> Apex Jobs'));
    }
    public void StartBatchJobNextWeekPreLog()
    {
        Database.executeBatch(new ContactAiredBatchV2('NextWeekPreLogButton'),10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Contact Dates Batch has started. You can monitor the status of the batch at Setup -> Administration Setup -> Monitoring -> Apex Jobs'));
    }
    public void StartSpotDataMirrorBatchJob()
    {
        if(spotNetwork == '---') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an actual network to process.'));
            return ;
        }
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(spotNetwork);
        if(current.isProcessingSpot__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This network is already currently being processed. Please wait or choose another.'));
            return ;
        }
        System.debug('***ShortForm.StartSpotDataMirrorBatchJob: spotNetwork' + spotNetwork);
        Database.executeBatch(new SpotDataBatch(spotNetwork), 10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Spot Data Mirror Batch has started. You can monitor the status of the batch by clicking <a href="/apexpages/setup/listAsyncApexJobs.apexp">Here</a>'));
    }
    public void StartSpotDataMirrorBatchJobV2()
    {
        if(spotNetwork == '---') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an actual network to process.'));
            return ;
        }
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(spotNetwork);
        if(current.isProcessingSpot__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This network is already currently being processed. Please wait or choose another.'));
            return ;
        }
        System.debug('***ShortForm.StartSpotDataMirrorBatchJobV2: spotNetwork' + spotNetwork);
        if (spotNetwork != 'Newsy' && spotNetwork != 'MAV TV') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can only start V2 with Newsy or MAV TV.'));
        } else {
            Database.executeBatch(new SpotDataBatchV2(spotNetwork), 10);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Spot Data Mirror Batch has started. You can monitor the status of the batch by clicking <a href="/apexpages/setup/listAsyncApexJobs.apexp">Here</a>'));
        }
    }
    public void StartSpotDataMirrorWithSchedulesBatchJob()
    {
        if(spotNetwork == '---') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an actual network to process.'));
            return ;
        }
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(spotNetwork);
        if(current.isProcessingSpot__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This network is already currently being processed. Please wait or choose another.'));
            return ;
        }
        System.debug('***ShortForm.StartSpotDataMirrorWithSchedulesBatchJob: spotNetwork' + spotNetwork);
        Database.executeBatch(new SpotDataScheduleBatch(spotNetwork), 10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Spot Data Mirror Batch has started. You can monitor the status of the batch by clicking <a href="/apexpages/setup/listAsyncApexJobs.apexp">Here</a>'));

    }
    public void StartSpotDataMirrorWithSchedulesBatchJobV2()
    {
        if(spotNetwork == '---') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an actual network to process.'));
            return ;
        }
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(spotNetwork);
        if(current.isProcessingSpot__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This network is already currently being processed. Please wait or choose another.'));
            return ;
        }
        System.debug('***ShortForm.StartSpotDataMirrorWithSchedulesBatchJobV2: spotNetwork' + spotNetwork);
        if (spotNetwork != 'Newsy' && spotNetwork != 'MAV TV') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You can only start V2 with Newsy or MAV TV.'));
        } else {
            Database.executeBatch(new SpotDataScheduleBatchV2(spotNetwork), 10);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Spot Data Mirror Batch has started. You can monitor the status of the batch by clicking <a href="/apexpages/setup/listAsyncApexJobs.apexp">Here</a>'));
        }

    }
    public void StartPreLogDataMirrorBatchJob()
    {
        if(prelogNetwork == '---') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select an actual network to process.'));
            return ;
        }
        Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(prelogNetwork);
        if(current.isProcessing__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This network is already currently being processed. Please wait or choose another.'));
            return ;
        }
        System.debug('***ShortForm.StartPreLogDataMirrorBatchJob: prelogNetwork' + prelogNetwork);
        Database.executeBatch(new PrelogDataBatch(prelogNetwork), 10);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Prelog Data Mirror Batch has started. You can monitor the status of the batch by clicking <a href="/apexpages/setup/listAsyncApexJobs.apexp">Here</a>'));
    }
}