public with sharing class XMLBundleDeal {

	public String dealId {get; set;}
	public String zipFileName {get; set;}
	public String programId {get; set;}
	public String bundleName {get; set;}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Controller instantiation. Grabs the selected Deal's record Id from the URL query string
	*	and makes it accessible to the JavaScript code in XMLBundleDeal.page. Queries for Program and Program's Bundle Name.
	*	Also formulates the zip filename.
	**/
	public XMLBundleDeal() {
		this.dealId = ApexPages.currentPage().getParameters().get('id');
		Deal__c deal = [SELECT Brands__r.Name, ContactAccount__c, Name, Program__c, Program__r.Bundle_Name__c FROM Deal__c WHERE Id = :dealId];
		this.programId = deal.Program__c;
		this.bundleName = deal.Program__r.Bundle_Name__c;

		this.zipFileName = deal.Program__r.Bundle_Name__c + '-' + deal.Name + '-' + deal.ContactAccount__c + '-' + deal.Brands__r.Name + '-NEW BUY-';
		Date d = Date.today();
		this.zipFileName += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '.zip';
	}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Remote wrapper function for the XMLBundle.getXMLFiles() function. Passes along the Deal Id and returns result.
	**/
	@RemoteAction
	public static Map<String, String> getXMLFiles(String dealId) {
		return XMLBundle.getXMLFiles(dealId, null);
	}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Remote wrapper function for the XMLBundle.saveData() function. Passes along the required data and returns result.
	**/
	@RemoteAction
	public static String saveData(String recordId, String filename, String data) {
		return XMLBundle.saveData(recordId, filename.replace('&','and'), data);
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