public with sharing class BundleTestSelector extends BundleSelector {
    public override Bundle_Pricing__c[] getBundlePricingForBuildSpots(List<Id> progid) {
            return [SELECT Call_Letters__c,
                           Rate_per_30__c,
                           Days__c,
                           Program__c,
                           Units__c,
                           Total__c,
                           Start_Time__c,
                           Market__c,
                           Station__c,
                           Stationn__c
                      FROM Bundle_Pricing__c
                     WHERE Active__c != false
                       AND Program__r.Id in :Progid];
        }
}