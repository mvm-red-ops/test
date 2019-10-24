public class InvokeBundlesSpotBatch {
    
    @InvocableMethod
    public static void SpotsIn(List<Programs__c> Pro)
    {   
        String nameOfProgram = Pro[0].Name;       
        database.executeBatch(new BundleSpotsBatch(nameOfProgram), 20);
    }

}