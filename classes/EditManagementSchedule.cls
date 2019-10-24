/**
@ name        :        EditManagementSchedule
@ author        :        
@ date        :        12 September, 2011
@ description    :     To edit the schedule records
*/

public class EditManagementSchedule{
    Public List<Schedules__c> sechList;
    Public Schedules__c schedule{get;set;}
    Public Boolean closeWindow{get;set;}
    public EditManagementSchedule(){
        closeWindow = false;
        schedule = new Schedules__c();
        sechList = new List<Schedules__c>();
        Boolean whereFlag = true; 
                
        Set<Id> ids = new Set<Id>();
        for(integer i=0; i<apexpages.currentpage().getParameters().keySet().size(); i++){
            string value = apexpages.currentpage().getParameters().get('id_' + i);
            if(value != null && value.trim().length() >= 15){
                ids.add(value);
            }
        }
       
        system.debug('$$$ Ids = ' + ids); 
        
        //system.debug('### query From and To = '+query);
        
        sechList = getSchedules(ids);
        
        system.debug('### sechList Size : '+sechList.size());
        system.debug('### sechList : '+sechList);
    }
    
    private List<Schedules__c> getSchedules(Set<Id> ids){
         List<Schedules__c> schedules = [Select 
                                             id, Week__c, Long_Form__c, Units_Preempted__c,
                                             Rate__c, LF_Brand__c, X800_Number__c, Name,
                                             Comments__c,Filler__c, Test__c, ISCI_CODE__c, Status__c 
                                        FROM Schedules__c
                                        Where id in:ids]; 
         return schedules;
    }
    
    public pageReference save(){
        if(sechList != null && sechList.size() > 0){
               for(Schedules__c sech : sechList){
                    
                    if(schedule.Rate__c != null)
                        sech.Rate__c = schedule.Rate__c;
                    
                    if(schedule.X800_Number__c != null)
                        sech.X800_Number__c = schedule.X800_Number__c;
                    
                    if(schedule.Comments__c != null)
                        sech.Comments__c = schedule.comments__c;
                        
                    if(schedule.ISCI_CODE__c != null)
                        sech.ISCI_CODE__c = schedule.ISCI_CODE__c;
                     
                    if(schedule.Test__c != null)
                        sech.Test__c = schedule.Test__c;
                        
                    if(schedule.Status__c != null)
                        sech.Status__c = schedule.Status__c;
                    
                    sech.Filler__c = schedule.Filler__c;
                }
                
                update sechList;
                closeWindow = true;
                     
        }
        //PageReference pg = new PageReference('/apex/managementReport');
        return null;
    }
    
    public PageReference cancel(){
        PageReference pg = new PageReference('/apex/managementReport');
        return pg;
    }
}