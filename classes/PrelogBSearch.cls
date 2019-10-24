public with sharing class PrelogBSearch {

    @AuraEnabled
    public static List<Prelog__b> getPrelogs(String payload) {
        System.debug(payload);
        return [SELECT AirDate__c, Program_Name__c, Schedule__c from Prelog__b Where Program_Name__c = 'AntennaTV' AND AirDate__c < 2019-09-01T23:01:01Z];
    }
}