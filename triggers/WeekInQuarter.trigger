Trigger WeekInQuarter on Schedules__c (before insert, before update) {
    
    for(Schedules__c sch : Trigger.New){
        WeekInQuarters.weekNumber(sch);
    }
}