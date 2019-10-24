trigger trgRatingsCompiled on Ratings_compiled__c (after insert) {

    Set<Id> rIds = trigger.newMap.keySet();
    ratingsCompiledTriggerHandler.compileFuture(rIds);
    
}