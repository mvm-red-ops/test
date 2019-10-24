/**
 * @date 1/9/2019
 * @description TapeSelector for use in Unit Tests with fabricated (mocked) Tapes
 */
public with sharing class TapeTestSelector extends TapeSelector {

    //
    // Fields
    //
    public Map<SObjectField, Object> fabricationFields { get; set; }
    public Integer fabricationAmount { get; set; }
    public List<Tape__c> fabricatedList { get; set; }

    //
    // Init Fields
    //
    Public TapeTestSelector(){
        this.fabricationFields = new Map<SObjectField, Object>();
        this.fabricationAmount = 0;
        this.fabricatedList = new List<Tape__c>();
    }

    /**
     * {@inheritDocs}
     * @return Mock list of tapes to use for testing
     */
    public override List<Tape__c> getTapes(List<SObjectField> fields) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount, this.fabricationFields);
        } else {
            return this.fabricatedList;
        }
    }

    /**
     * {@inheritDocs}
     * @return Mock list of tapes to use for testing
     */
    public override List<Tape__c> getTapesInFlightRange(Date startDate, Date endDate) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount, this.fabricationFields);
        } else {
            return this.fabricatedList;
        }
    }

    /**
     * {@inheritDocs}
     * @return Mock Tape__c object used for testing
     */
    public override Tape__c getTapeFromId(Id tapeId) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount > 0 ? this.fabricationAmount : 1, this.fabricationFields).get(0);
        } else {
            return this.fabricatedList.get(0);
        }
    }

    /**
     * @description Retrieve a list of fabricated SObjects with the assigned fields
     *  Useful for mocking SObjects and assigning fields
     * @param amount The amount of fabricated SObjects to retrieve
     * @param fields A Map of the fields being set on the fabricated SObjects
     * @return The resulting list of fabricated SObjects
     */
    private List<Tape__c> getFabricatedList(Integer amount, Map<SObjectField, Object> fields) {
        List<Tape__c> result = new List<Tape__c>();
        for (Integer x = 0; x < amount; x++) {
            sfab_FabricatedSObject tapeFab = new sfab_FabricatedSObject(Tape__c.class, fields);
            result.add((Tape__c) tapeFab.toSObject());
        }
        return result;
    }

}