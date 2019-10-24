public with sharing class CancelSchedulesController {
	public Deal__c dealLTCDate{set; get;}
	public boolean done{set; get;}
	public boolean cancel{set; get;}
	public String dealId{set; get;}
	public CancelSchedulesController(){
		done=false;
		cancel=false;
		dealId = ApexPages.currentPage().getParameters().get('dealId');
		if(dealId!=null && dealId.trim().length()>0){
			dealLTCDate = [select LTC_Date__c from Deal__c where id=:dealId];
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'The LTC Date will cancel all Schedules after the date entered. Are you sure you would like to CANCEL all the schedules to be aired after this date?'));
	}
	public PageReference save(){
		update dealLTCDate;
		/*if(dealLTCDate.LTC_Date__c!=null && dealLTCDate.LTC_Date__c<=System.today()){
			List<Schedules__c> lstSchedules = [Select id, Week__c from Schedules__c where Week__c>:dealLTCDate.LTC_Date__c];
			System.debug('@@Delting rows:'+lstSchedules.size());
		}*/
		
		done=true; 
		return null;
	}
	public PageReference cancel(){
		cancel=true;	
		return null;	
	}
}