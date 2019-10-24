// Status = Sold
// Program = Bundle Program
// 
// Reconciled = 'Y'
// 
public class CreateSpotsForBundles{
    public List<Spot_Data__c> availSpots  = new List<Spot_Data__c>();
    public class ApplicationException extends Exception {}
    
    @InvocableMethod
    public static void SpotstoInsert(List<Id> Scheds)
    {   
        List<Spot_Data__c> newSpots = new List<Spot_Data__c>();
        newSpots = CreateSpots(Scheds);       
        insert newSpots;
    }
    
    public static List<Spot_Data__c> CreateSpots(List<Id> SchedsIds){
        List<Spot_Data__c> availSpots  = new List<Spot_Data__c>();
        List<Id> Progid = new List<Id>();
        Integer i;
        
        Schedules__c[] ssch = [SELECT Id, Units_Aired__c, Sum_Spot_Equiv_30__c, PI_Payout_TEST__c, Spot_Total__c, Rate__c, Week__c, Deal_Parent__r.Program__c, DealBrand__c, Deal_Parent__r.Program__r.Id, UnitLength__c
                        FROM Schedules__c 
                        WHERE Id in :SchedsIds];
    
        Progid.add(ssch[0].Deal_Parent__r.Program__r.Id);    

        Bundle_Pricing__c[] bundles = [SELECT Call_Letters__c, Rate_per_30__c, Days__c, Program__c, Units__c, Total__c, Start_Time__c, Market__c, Station__c 
                        FROM Bundle_Pricing__c
                        WHERE Active__c != false
                        AND Program__r.Id in :Progid];

    
        if(ssch[0].Id == null){
            throw new ApplicationException('The Advertiser lookup is missing from the Deal. Please add an Advertiser and try again.');
        }
        if(ssch[0].UnitLength__c == null){
            throw new ApplicationException('The Units are missing from either the Bundle or the Schedule');
        }
        
        for(i = 0; i < bundles.size(); i++){
        if(bundles[i].Units__c == null){
            throw new ApplicationException('The Units for the Bundle:' + bundles[i] + ' is empty' );
        }
        if(bundles[i].Rate_per_30__c == null || bundles[i].Units__c == null){
            throw new ApplicationException('The Units or the Rate for the Bundle is empty');
        }
        if(bundles[i].Station__c == null){
            throw new ApplicationException('The Stationn for the Bundle is empty');
        }
            
        String a = bundles[0].Start_Time__c;
        String aTime = a.left(3) + String.valueOf(Math.random()*60).left(1) + String.valueOf(Math.random()*100).left(1) + a.right(1);
        Spot_Data__c spot = new Spot_Data__c(); 
                    spot.Schedule__c = ssch[0].Id;
                    spot.Length__c = String.valueOf((ssch[0].UnitLength__c)*(bundles[i].Units__c));
                    spot.Spot_Rate__c = ((bundles[i].Rate_per_30__c)*(bundles[i].Units__c));                    
                    spot.Stationn__c = bundles[i].Station__c;
                    spot.Availability__c = true;
                    spot.Air_Date__c = ssch[0].Week__c;
                    spot.Air_Time__c = aTime;

                    availSpots.add(spot);
        }
        
        return availSpots;
    }
    

}