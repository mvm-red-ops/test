public class PrelogWeekBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    private static final Integer maxProgramsPerBatch = 5;

    private Date weekStartDate;
    private Date weekEndDate;
    private Date endDate;

    private List<Programs__c> networks;
    private List<Programs__c> remainingNetworks;
    private Set<String> programIds;
    private Map<Prelog_Week__c, Prelog_Week__c> prelogWeekMap = new Map<Prelog_Week__c, Prelog_Week__c>();

    public PrelogWeekBatch(Date startDate, Date endDate, List<Programs__c> networks) {
        this(startDate, endDate, networks, new List<Programs__c>(networks));
    }

    public PrelogWeekBatch(Date startDate, Date endDate, List<Programs__c> networks, List<Programs__c> remainingNetworks) {
        this.weekStartDate = startDate;
        this.weekEndDate = this.weekStartDate.addDays(6);
        this.endDate = endDate;
        this.networks = networks;
        this.remainingNetworks = remainingNetworks;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        programIds = new Set<String>();
        for (Integer i = 0; i < maxProgramsPerBatch; i++) {
            if (remainingNetworks.isEmpty()) break;

            programIds.add(remainingNetworks.remove(0).Id);
        }

        String query = 'SELECT Id, Rate__c, Prelog_Equiv_30__c, Version__c, Schedule__r.Week__c, Hour_of_Day__c, ' +
                'Schedule__r.Deal_Parent__r.Program__c, Schedule__r.Deal_Parent__r.Program__r.Name, ' +
                'Schedule__r.Deal_Parent__r.Brands__c, Schedule__r.Deal_Parent__r.Brands__r.Advertiser__c, ' +
                'Schedule__r.Deal_Parent__r.Brands__r.Advertiser__r.Commercial__c';
        query += ' FROM PrelogData__c';
        query += ' WHERE Schedule__r.Deal_Parent__r.Program__c IN :programIds';
        query += ' AND Schedule__r.Week__c >= :weekStartDate AND Schedule__r.Week__c <= :weekEndDate';
        query += ' AND Schedule__r.Deal_Parent__r.Brands__r.Name != \'long form\'';
        query += ' AND Version__c = 6';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<PrelogData__c> records) {
        for(PrelogData__c record : records) {
            Prelog_Week__c key = initializePrelogWeek(record);
            if (key == null) continue;

            Prelog_Week__c prelogWeek = prelogWeekMap.get(key);
            prelogWeek.Rate_Sum__c += record.Rate__c;
            prelogWeek.Equiv_30_Sum__c += record.Prelog_Equiv_30__c;
        }
    }

    public void finish(Database.BatchableContext bc) {
        checkForDuplicates();
        upsert prelogWeekMap.values();

        if (!remainingNetworks.isEmpty()) {
            // Reschedule Batch using remaining programs
            PrelogWeekBatch batch = new PrelogWeekBatch(this.weekStartDate, this.endDate, this.networks, this.remainingNetworks);
            if (!Test.isRunningTest()) {
                Database.executeBatch(batch, 200);
            }
        }
        else if (this.weekEndDate < this.endDate) {
            // Reschedule Batch using next week
            Date nextWeekStartDate = weekStartDate.addDays(7);
            PrelogWeekBatch batch = new PrelogWeekBatch(nextWeekStartDate, this.endDate, this.networks);
            if (!Test.isRunningTest()) {
                Database.executeBatch(batch, 200);
            }
        }
    }

    private Prelog_Week__c initializePrelogWeek(PrelogData__c prelogData) {
        Prelog_Week__c key = PrelogWeekBatchService.newPrelogWeekKey(prelogData, this.weekStartDate);
        if (key == null || key.Program__c == null) return null;

        if (!prelogWeekMap.containsKey(key)) {
            prelogWeekMap.put(key, new Prelog_Week__c(
                Program__c = key.Program__c,
                Commercial_Type__c = key.Commercial_Type__c,
                Week__c = this.weekStartDate,
                Daypart__c = key.Daypart__c,
                Version__c = key.Version__c,
                Rate_Sum__c = 0,
                Equiv_30_Sum__c = 0
            ));
        }

        return key;
    }

    private void checkForDuplicates() {
        List<Prelog_Week__c> prelogWeeks = PrelogWeekBatchService.getAllPrelogWeeksByProgram(this.programIds, this.weekStartDate);
        for(Prelog_Week__c prelogWeek : prelogWeeks) {
            Prelog_Week__c value = prelogWeekMap.get(PrelogWeekBatchService.newPrelogWeekKey(prelogWeek));
            if (value != null) {
                value.Id = prelogWeek.Id;
            }
        }
    }

    public static void run(Date startDate, Date endDate, Set<String> programIds) {
        List<Programs__c> programs = PrelogWeekBatchService.getPrograms(programIds);
        PrelogWeekBatch batch = new PrelogWeekBatch(startDate, endDate, programs);
        Database.executeBatch(batch, 200);
    }

    public static void run(Date startDate, Date endDate) {
        List<Programs__c> programs = PrelogWeekBatchService.getPrograms();
        PrelogWeekBatch batch = new PrelogWeekBatch(startDate, endDate, programs);
        Database.executeBatch(batch, 200);
    }

    public static void execute(SchedulableContext param1) {
        Date thisMonday = Date.today().toStartOfWeek().addDays(1);
        run(thisMonday, thisMonday.addDays(6));
    }
}