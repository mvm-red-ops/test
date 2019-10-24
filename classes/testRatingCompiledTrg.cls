@isTest
Public class testRatingCompiledTrg{
    static testMethod void validateRatingTrigger() {
        
        Ratings_compiled__c rc = new Ratings_compiled__c();
        rc.Source__c = 'test';
        insert rc;
        
    }
}