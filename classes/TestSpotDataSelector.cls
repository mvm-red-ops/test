/**
 * @date 1/15/2019
 * @description Mock database selector for unit testing with SpotDataSelector.cls
 */
public with sharing class TestSpotDataSelector extends SpotDataSelector {

    //
    // Fields
    //
    public Integer fabricationAmount { get; set; }
    public Map<SObjectField, Object> fabricationFields { get; set; }
    public List<Spot_Data__c> fabricatedList { get; set; }

    /**
     * Construct a TestSpotDataSelector
     *  Initialize Fields
     */
    public TestSpotDataSelector() {
        this.fabricationAmount = 0;
        this.fabricationFields = new Map<SObjectField, Object>();
        this.fabricatedList = new List<Spot_Data__c>();
    }

    /**
     * {@inheritDocs}
     *
     * @return A fabricated list of spot data being "loaded" from the reference map
     */
    public override List<Spot_Data__c> getSpotDataFromReferenceMap(Map<String, SpotDataMirror__c> refMap) {
        if (this.fabricatedList.isEmpty()) {
            List<Spot_Data__c> result = new List<Spot_Data__c>();

            return result;
        } else {
            return this.fabricatedList;
        }
    }

}