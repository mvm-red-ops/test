public with sharing class XMLBundleSchedule {

	public String scheduleId {get; set;}
	public String dealId {get; set;}
	public String zipFileName {get; set;}
	public String programId {get; set;}
	public String bundleName {get; set;}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Controller instantiation. Grabs the selected Schedule's record Id from the URL query string
	*	and makes it accessible to the JavaScript code in XMLBundleSchedule.page. Queries for other necessary data.
	*	Also formulates the zip filename.
	*	This controller is a simplified version of XMLBundleDeal and generates XML files for only a single Schedule record
	*		instead of every Schedule record on a Deal.
	**/
	public XMLBundleSchedule() {
		this.scheduleId = ApexPages.currentPage().getParameters().get('id');
		Schedules__c schedule = [SELECT Name, Deal_Parent__c FROM Schedules__c WHERE Id = :scheduleId];
		if(schedule.Deal_Parent__c != null) {
			this.dealId = schedule.Deal_Parent__c;
			Deal__c deal = [SELECT Brands__r.Name, ContactAccount__c, Name, Program__c, Program__r.Bundle_Name__c FROM Deal__c WHERE Id = :dealId];
			this.programId = deal.Program__c;
			this.bundleName = deal.Program__r.Bundle_Name__c;

			this.zipFileName = deal.Program__r.Bundle_Name__c + '-' + schedule.Name + '-' + deal.ContactAccount__c + '-' + deal.Brands__r.Name + '-NEW BUY-';
			Date d = Date.today();
			this.zipFileName += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '.zip';
		}
	}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Remote wrapper function for the XMLBundle.getXMLFiles() function. Passes along the Deal Id and Schedule Id and returns result.
	**/
	@RemoteAction
	public static Map<String, String> getXMLFiles(String dealId, String scheduleId) {
		return XMLBundle.getXMLFiles(dealId, scheduleId);
	}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Remote wrapper function for the XMLBundle.saveData() function. Passes along the required data and returns result.
	**/
	@RemoteAction
	public static String saveData(String recordId, String filename, String data) {
		return XMLBundle.saveData(recordId, filename, data);
	}

	/**
	* @author Ryan Scott
	* @date 12/18/2015
	* @description Remote wrapper function for the XMLBundle.markXMLSent() function. Passes along the required data and returns result.
	**/
	@RemoteAction
	public static String markXMLSent(String scheduleIds) {
		return XMLBundle.markXMLSent(scheduleIds);
	}

}