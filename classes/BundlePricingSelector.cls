/**
 * BundlePricingSelector
 * @description
 */

public with sharing virtual class BundlePricingSelector {

    public virtual List<Bundle_Pricing__c> getBundlesByProgram(Id progId) {
        return [
            SELECT Call_Letters__c,
                   Days__c,
                   End_Time__c,
                   Rate_per_30__c,
                   Start_Time__c,
                   Station__r.Market__r.Name,
                   Total__c,
                   Units__c
              FROM Bundle_Pricing__c
             WHERE Program__c = :progId
               AND Active__c = TRUE
        ];
    }
}