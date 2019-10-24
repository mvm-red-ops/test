trigger trgTESTtask on Task (before insert, before update) {

    if(Trigger.new[0].RecordTypeId == '0123b000000IJvm'){
        Trigger.new[0].Program_Task_Relationship__c = Trigger.new[0].WhatId;
    }

}