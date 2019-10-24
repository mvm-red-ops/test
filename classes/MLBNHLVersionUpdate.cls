public class MLBNHLVersionUpdate {
    
    @InvocableMethod
    public static void SetVersion(List<Programs__c> Prog)
    {   
      String nameOfPro = Prog[0].Name;       
      database.executeBatch(new MLBNHLSetVersion(nameOfPro), 20);
    }

}