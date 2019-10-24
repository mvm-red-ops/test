trigger AddUpdateTarget on Deal__c (after insert, after update) {
    /*
    List<Deal__C> dealList = new List<Deal__C>();
    List<Targets__C> upTarget = new List<Targets__C>();
    map<String,Deal__C> targetnames = new Map<String,Deal__C>();
    List<Targets__C> targetList = new List<Targets__C>();
    List<Targets__C> newTargetList = new List<Targets__C>();
    Map<String,Targets__C> targetMap = new Map<String,Targets__C>();
    if(!AddUpdateTargetController.getExecuted()){
        AddUpdateTargetController.setExecuted();
        dealList = [select id,
                        Program__r.name,Status__c,PI__c, Brands__r.name, Test_PP__c, Contact__c, Client_Account__c
                        from Deal__c
                        where id in: Trigger.newMap.keySet()];
                        
        if(Trigger.isInsert){
            dealList = [select id,
                        Program__r.name,Status__c,PI__c, Brands__r.name, Test_PP__c, Contact__c, Client_Account__c
                        from Deal__c
                        where id in: Trigger.newMap.keySet()];
        }else if(Trigger.isUpdate){
            List<ID> changedDeal= new List<ID>();
            Deal__c oldDeal;
            Deal__c newDeal;
            for(String key:Trigger.newMap.keySet()){
                newDeal=Trigger.newMap.get(key);
                oldDeal=Trigger.oldMap.get(key);
                //if(oldDeal!=null){
                    //if(newDeal.Program__c!=oldDeal.Program__c || newDeal.Brands__c!=oldDeal.Brands__c){
                        changedDeal.add(newDeal.id);
                    //}
                //}
           }
            dealList = [select id,
                        Program__r.name,PI__c, Brands__r.name, Test_PP__c, Contact__c,Status__c, Client_Account__c
                        from Deal__c
                        where id in: changedDeal];
        }
        if(dealList.size()>0){
            for(Deal__C dl: dealList){
                if(dl.Status__c != 'Historical' && dl.PI__c == false){
                    System.Debug('@@@@Target Creation Is Added');
                    targetNames.put(dl.program__r.name + '-' + dl.brands__r.name,dl);        
                }
            }
            dealList.clear();
            targetList = [select id, Target_Name__c , Status__C,
                            To_Do__C
                            from Targets__C
                            where Target_Name__C in: targetNames.keySet()];
            System.Debug('%%%%%%%TargetList Size is '+ targetList.size());
            for(Targets__C tg : targetList){
                targetMap.put(tg.Target_Name__C,tg);
            }
            for(String name : targetNames.keySet()){
                Targets__C tg;
                if(targetMap.containsKey(name)){
                    //tg = targetMap.get(name);
                    targetMap.get(name).To_Do__C = true;
                    if(targetNames.get(name).Test_PP__c == true){
                        targetMap.get(name).Status__C = 'TEST';
                    }
                    
                }else{
                       tg = new Targets__C();
                       tg.Target_Name__C  = name;
                       tg.Program__c = targetNames.get(name).Program__C;
                       tg.Brands__c = targetNames.get(name).Brands__c;
                       tg.Contact__c = targetNames.get(name).Contact__c;
                       tg.Account__c = targetNames.get(name).Client_Account__c;
                       tg.To_Do__C  = true;
                       if(targetNames.get(name).Test_PP__c == true){
                           tg.Status__C = 'TEST';
                       }
                       upTarget.add(tg);
                }
            }
            update targetList;       
            upsert upTarget;
            newTargetList = [select id, Target_Name__C
                                from Targets__C
                                where Target_Name__C in: targetNames.keySet() order by LastModifiedDate];
                                
            Map<String,Targets__c> firstTargets=new Map<String,Targets__c>();
            List<Targets__c> delTargets= new List<Targets__c>();        
            for(Targets__C tg : newTargetList){
                if(firstTargets.containsKey(tg.Target_Name__c)){
                    delTargets.add(tg);
                }else{
                    Deal__c dl = targetNames.get(tg.Target_Name__c);
                    dl.Target__c = tg.id;
                    dealList.add(dl);
                    firstTargets.put(tg.Target_Name__c,tg);
                }
            }
            update dealList;
            delete delTargets;
        }
    }
    */
}