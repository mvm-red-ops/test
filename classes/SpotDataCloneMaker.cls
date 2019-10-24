public class SpotDataCloneMaker {
    public static void createClones(){
        Integer counter = 0;
        List<SpotDataClone__c> clones = new List<SpotDataClone__c>();
        while(counter < 500){
            SpotDataClone__c  sdc = new SpotDataClone__c ();
     		Integer day = Integer.valueof((Math.random() * 28)) + 1; 
            Integer month = Integer.valueof((Math.random() * 11)) + 1;
            Integer year = Integer.valueof((Math.random() * 19)) + 2000;
            //air date           
            Date myDate = Date.newInstance(year, month, day); 
			sdc.AirDate__c = myDate;
            //order number
            sdc.OrderNumber__c = Integer.valueof((Math.random() * 20));
			clones.add(sdc);
            counter++;
        }
        insert clones;
    }
    
    public static void deleteRecords(){
        List<SpotDataClone__c> clones = [select id from SpotDataClone__c];
        delete clones;
          
    }
}