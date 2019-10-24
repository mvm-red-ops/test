trigger SpotDataMirror on SpotDataMirror__c (after delete, after insert, after undelete, after update, before delete, before insert, before update)
{
    /*
    if(Trigger.isBefore){
        if(Trigger.isInsert){
//            SpotDataServices.SpotDataMirrorOnAfterInsert(trigger.new);
        }else if(Trigger.isUpdate){
            
            list<SpotDataMirror__c> passedToLogic = new list<SpotDataMirror__c>();
            list<SpotDataMirror__c> manualIntervention = new list<SpotDataMirror__c>();
            for (SpotDataMirror__c sdm : Trigger.new){
                SpotDataMirror__c beforeUpdate = System.Trigger.oldMap.get(sdm.Id); 
                
                if(sdm.Schedule__c != null && (beforeUpdate.Schedule__c == null || sdm.Schedule__c!=beforeUpdate.Schedule__c)){
                    manualIntervention.add(sdm);
                }else if(sdm.Schedule__c!=beforeUpdate.Schedule__c || sdm.Schedule__c == null){
                    passedToLogic.add(sdm);
                }
            }
            
            list<Spot_Data__c> insertSpotDataforManualInterventions = new list<Spot_Data__c>();
            if(!manualIntervention.isEmpty()){
                for(SpotDataMirror__c sdm:manualIntervention){
//                    insertSpotDataforManualInterventions.add(SpotDataServices.getSpotDataRecord(sdm.Schedule__c,sdm));
                    sdm.Problem__c = false;
                    sdm.msg__c = '';
                }
            }
            
            if(!insertSpotDataforManualInterventions.isEmpty()){
                try{
                    insert insertSpotDataforManualInterventions;
                }catch(DMLException e){
                    system.debug('Error while creating spot Data record for the spot Data Mirror records');
                }
            }
            
            //Added By: Abhijeet Baneka(Cloud Sherpas) - 14/02/2013
            //To Support on updation as well. 
            if(!passedToLogic.isEmpty()){
//                SpotDataServices.SpotDataMirrorOnAfterInsert(passedToLogic);
            }
        }else if(Trigger.isDelete){
            // OnBeforeDelete is Currently unsupported
        }else{
            // ??
        }
    }//else if(Trigger.isAfter){
       // if(Trigger.isInsert){
            // handler = new SpotDataMirrorTriggerHandler(Trigger.isExecuting, Trigger.size);
            //SpotDataServices.SpotDataMirrorOnAfterInsert(trigger.new);
       // }else if(Trigger.isUpdate){
            // OnAfterUpdate is Currently unsupported
       // }else if(Trigger.isDelete){
            // OnAfterDelete is Currently unsupported
       // }else if(Trigger.isUnDelete){
            // OnAfterUnDelete is Currently unsupported
       // }else{
            // ??
      //  }
   // }
   */

}