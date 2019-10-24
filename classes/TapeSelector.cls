/**
 * @date 1/9/2019
 * @description Tape Selector used for querying tapes via DML
 */
public with sharing virtual class TapeSelector {

    /**
     * @description The Object being Selected from
     */
    private final String OBJ = 'Tape__c';

    /**
     * @description Retrieve a list of Tape's with the specified fields
     *
     * @param fields The fields being specified to be retrieved from the list of tapes
     *
     * @return The retrieved list of tapes from the database
     */
    public virtual List<Tape__c> getTapes(List<SObjectField> fields) {
        return Database.query('SELECT ' + String.join(getFieldNames(fields), ', ') + ' FROM ' + OBJ);
    }

    /**
     * @description Retrieve a list of tapes from start week and end week
     *
     * @param startDate The first week being selected from
     * @param endDate The end week being selected from
     *
     * @return The retrieved list from the database
     */
    public virtual List<Tape__c> getTapesInFlightRange(Date startDate, Date endDate) {
        return [
                SELECT  Id,
                        Name,
                        X800_Number__c,
                        Account__c,
                        Brand__c,
                        Flight_End__c,
                        Flight_Start__c,
                        ISCI_2__c,
                        ISCI_3__c,
                        Program__c,
                        Rotation__c,
                        Length__c,
                        ISCI__c
                   FROM Tape__c
                  WHERE Flight_Start__c <= :startDate
                   AND Flight_End__c >= :endDate
        ];
    }

    /**
     * @description Retrieve a single Tape__c instance from a requested Id
     *
     * @param TapeId The Id of the requested Tape__c
     *
     * @return The resulting Tape__c SObject
     */
    public virtual Tape__c getTapeFromId(Id TapeId) {
        return [
                SELECT Id,
                        Name,
                        X800_Number__c,
                        Account__c,
                        Brand__c,
                        Flight_Start__c,
                        Flight_End__c,
                        ISCI_2__c,
                        ISCI_3__c,
                        Program__c,
                        Rotation__c,
                        Length__c,
                        ISCI__c
                   FROM Tape__c
                  WHERE Id = :TapeId
        ];
    }

    /**
     * @description Retrieve a list of Field names from a list of fields
     *
     * @param fields The fields being accessed
     *
     * @return The names of the fields requested
     */
    private List<String> getFieldNames(List<SObjectField> fields) {
        List<String> result = new List<String>();
        for (SObjectField field : fields) {
            result.add(field.getDescribe().name);
        }
        return result;
    }
}