public class PrelogBigObjectBatchService {

    public static List<Prelog_Big_Object_Mapping__mdt> getPrelogMappings(){
        return [SELECT MasterLabel, DeveloperName, Source_Field__c, Target_Field__c
                FROM Prelog_Big_Object_Mapping__mdt];
    }

    public static Set<String> getPrelogFields(List<Prelog_Big_Object_Mapping__mdt> prelogMappings){
        Set<String> fields  = new Set<String>();
        for(Prelog_Big_Object_Mapping__mdt mapping : prelogMappings){
            fields.add(mapping.Source_Field__c);
        }

        fields.add('Id');

        return fields;
    }

    public static Object traverseParentObject(String fieldName, PrelogData__c prelog){
        List<String> fieldNames = fieldName.split('\\.');
        SObject so = prelog;
        for(Integer i = 0; i < fieldNames.size() -1; i++){
            String sobjectString = fieldNames[i];
            so = so.getSObject(sobjectString);
        }
        Integer lastItemIndex = fieldNames.size() - 1;
        Object fieldValue = so.get(fieldNames[lastItemIndex]);
        return  fieldValue;
    }

    public class UpdatePrelogs implements Queueable{

        private List<Prelog__b> Prelogs_bo;
        public UpdatePrelogs(List<Prelog__b> BO_Prelogs){
            this.Prelogs_bo = BO_Prelogs;
        }

        public void execute(QueueableContext context) {
            List<PrelogData__c> prelogsToUpdate = new List<PrelogData__c>();
            for(Prelog__b pbo : Prelogs_bo){
                PrelogData__c pd = new PrelogData__c(
                    Id = pbo.uniqueprelog__c,
                    Archived_Date__c = DateTIme.now()
                );
                prelogsToUpdate.add(pd);
            }
            update prelogsToUpdate;
        }
    }

}