public class ratingsCompiledTriggerHandler {

  @future 
  public static void compileFuture(Set<Id> ratingIds) {

    List<Ratings_compiled__c> ratingsComp = [SELECT Id, Daypart__c, Program__c, Week__c, Impressions__c, INV__c, Dollar_Amount__c, AUR__c, CPM__c 
                                             FROM Ratings_compiled__c 
                                             WHERE Id IN :ratingIds
                                             ORDER BY Week__c ASC];

    decimal d = 0;
    decimal i = 0;
    date oldest = date.newInstance(2015, 1, 1);
    if (!ratingsComp.isEmpty()) {
        oldest = ratingsComp[0].week__c;
    }
    
    List<String> enteringPrograms = new List<String>();
    
    for(Ratings_compiled__c rc : ratingsComp){
        enteringPrograms.add(rc.Program__c);
    }
    
    Schedules__c[] s = [SELECT Id, CALC_EQUIV_30__c, Total_Dollars__c, Week__c, Deal_Parent__r.Program__c, Daypart__c
                        FROM Schedules__c 
                        WHERE Week__c >= :oldest
                        AND Deal_Parent__r.Brands__r.Name != 'Availability'
                        AND COUNTMENOT__c != 'N'
                        AND Reconciled__c = 'Y'
                        AND Deal_Parent__r.Program__c IN :enteringPrograms];

    for(Ratings_compiled__c rcf : ratingsComp){
        for(Schedules__c c:s){
            if (rcf.week__c == c.week__c && rcf.Daypart__c == c.Daypart__c && rcf.Daypart__c != 'Total Day' && rcf.Program__c == c.Deal_Parent__r.Program__c) {
                i = i + c.CALC_EQUIV_30__c;
                d = d + c.Total_Dollars__c;
            }
            if (rcf.Daypart__c == 'Total Day' && rcf.week__c == c.week__c && rcf.Program__c == c.Deal_Parent__r.Program__c) {
                i = i + c.CALC_EQUIV_30__c;
                d = d + c.Total_Dollars__c;
            }
        }
        if(i > 0 && d > 0){
            rcf.Dollar_Amount__c = d;
            rcf.INV__c = i;
            rcf.AUR__c = d/i;
            
            if(rcf.Impressions__c != null){
            rcf.CPM__c = (d/i)/rcf.Impressions__c;
            }

            d=0;
            i=0;
        }
    }
    update ratingsComp;
  }
}