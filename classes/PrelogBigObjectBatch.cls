public class PrelogBigObjectBatch implements Database.Batchable<sObject>{

    private List<Prelog_Big_Object_Mapping__mdt> prelogMappings;
    private Set<String> prelogFields;

    private Date startDate;
    private Date endDate;
    private Set<String> programIds;

    public PrelogBigObjectBatch(Date startDate, Date endDate, Set<String> programIds){
        this.startDate = startDate;
        this.endDate = endDate;
        this.programIds = programIds;

        prelogMappings = PrelogBigObjectBatchService.getPrelogMappings();
        prelogFields = PrelogBigObjectBatchService.getPrelogFields(prelogMappings);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT ';
        query += String.join(new List<String>(prelogFields), ',');
        query += ' FROM PrelogData__c';
        query += ' WHERE Archived_Date__c = null AND Schedule__r.Week__c >= :startDate AND Schedule__r.Week__c <= :endDate';
        query += ' AND Schedule__r.Deal_Parent__r.Program__c IN :programIds';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<SObject> records){
        List<Prelog__b> Prelogs_bo = new List<Prelog__b>();
        for(PrelogData__c prelog : (List<PrelogData__c>)records){
            Prelog__b pbo = new Prelog__b();
            for(Prelog_Big_Object_Mapping__mdt mapping : prelogMappings){
                if(mapping.Source_Field__c.contains('.')){
                    Object fieldValue = PrelogBigObjectBatchService.traverseParentObject(mapping.Source_Field__c, prelog);
                    pbo.put(mapping.Target_Field__c, fieldValue);
                }
                else{
                    pbo.put(mapping.Target_Field__c, prelog.get(mapping.Source_Field__c));
                }
            }
            Prelogs_bo.add(pbo);
        }

        List<Database.SaveResult> results = Database.insertImmediate(Prelogs_bo);
        List<Prelog__b> successfulPrelogs = new List<Prelog__b>();
        Integer iterator = 0;
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                successfulPrelogs.add(Prelogs_bo[iterator]);
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
            iterator++;
        }
        if(!successfulPrelogs.isEmpty()){
            System.enqueueJob(new PrelogBigObjectBatchService.UpdatePrelogs(successfulPrelogs));
        }

    }

    public void finish(Database.BatchableContext bc){

    }

    public static void run(Date startDate, Date endDate, Set<String> programIds){
        PrelogBigObjectBatch batch = new PrelogBigObjectBatch(startDate, endDate, programIds);
        Database.executeBatch(batch, 200);
    }

    public static void run(Date startDate, Date endDate){
        List<Programs__c> programs = PrelogWeekBatchService.getPrograms();
        Set<String> programIds = new Set<String>();
        for(Programs__c program : programs) programIds.add(program.Id);

        PrelogBigObjectBatch batch = new PrelogBigObjectBatch(startDate, endDate, programIds);
        Database.executeBatch(batch, 200);
    }

}