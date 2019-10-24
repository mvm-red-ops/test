trigger RaycomMonthlyLineItemTriggers on RaycomMonthlyLineItem__c (after insert) {
    
    /**
    Map<String, List<RaycomMonthlyLineItem__c>> lineItemsByKey = new Map<String, List<RaycomMonthlyLineItem__c>>();
    
    for(RaycomMonthlyLineItem__c li : Trigger.new) {
        if(li.OrderNumber__c == null || li.BillingMonth__c == null || li.Invoice__c == null) continue;
        String liKey = li.OrderNumber__c;
        liKey += DateTime.newInstance(li.BillingMonth__c, Time.newInstance(0,0,0,0)).format('MMMM');
        if(!lineItemsByKey.containsKey(liKey)) lineItemsByKey.put(liKey, new List<RaycomMonthlyLineItem__c>());
        lineItemsByKey.get(liKey).add(li);
    }
    
    List<Spot_Data__c> spotDatas = [select 
                                    Id, 
                                    Raycom_Invoice_Number__c, 
                                    RaycomKeyIndexed__c 
                                    from Spot_Data__c 
                                    where RaycomKeyIndexed__c in :lineItemsByKey.keySet() 
                                    and Raycom_Invoice_Number__c = null 
                                    limit 9000
                                   ];
    
    List<Spot_Data__c> updatedSpotDatas = new List<Spot_Data__c>();
    
    for(Spot_Data__c sd : spotDatas) {
        if(!lineItemsByKey.containsKey(sd.RaycomKeyIndexed__c)) continue;
        if(lineItemsByKey.get(sd.RaycomKeyIndexed__c).isEmpty()) continue;
        RaycomMonthlyLineItem__c li = lineItemsByKey.get(sd.RaycomKeyIndexed__c)[0];
        sd.Raycom_Invoice_Number__c = li.Invoice__c;
        updatedSpotDatas.add(sd);
    }    

    if(!updatedSpotDatas.isEmpty()) update updatedSpotDatas;
    
    List<RaycomMonthlyLineItem__c> deletes = [select Id from RaycomMonthlyLineItem__c where Id = :Trigger.new];
    delete deletes;
    **/
}