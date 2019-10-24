public with sharing class XMLOSIDeal {

    public String dealId {get; set;}
	public String zipFileName {get; set;}
	public String programId {get; set;}
	public String bundleName {get; set;}

	private static DealSelector dealSelector = new DealSelector();

	public static void setDealSelector(DealSelector dSelector){
		dealSelector = dSelector;
	}

	/**
	* @author Adrian P
	* @date 11/03/2017
	* @description Controller instantiation. Grabs the selected Deal's record Id from the URL query string
	*	and makes it accessible to the JavaScript code in XMLOSIDeal.page. Queries for Program.
	*	Also formulates the zip filename.
	**/
	public XMLOSIDeal() {
		this.dealId = ApexPages.currentPage().getParameters().get('id');
		Deal__c deal = dealSelector.getDealsFromId(this.dealId)[0];
		this.zipFileName = deal.Name + '-' + deal.ContactAccount__c + '-' + deal.Brands__r.Name + '-NEW BUY-';
		Date d = Date.today();
		this.zipFileName += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '.zip';
	}

	/**
	* @author Adrian P
	* @date 11/03/2017
	* @description Remote wrapper function for the OSIxml.getXMLFiles() function. Passes along the Deal Id and returns result.
	**/
	@RemoteAction
	public static Map<String, String> getXMLFiles(String dealId) {
		return OSIxml.getXMLFiles(dealId, null);
	}

	/**
	* @author Adrian Pichardo
	* @date 11/03/2017
	* @description Remote wrapper function for the OSIxml.saveData() function. Passes along the required data and returns result.
	**/
	@RemoteAction
	public static String saveData(String recordId, String filename, String data) {
		return OSIxml.saveData(recordId, filename, data);
	}

	/**
	* @author Adrian P
	* @date 11/03/2017
	* @description Remote wrapper function for the OSIxml.markXMLSent() function. Passes along the required data and returns result.
	**/
	@RemoteAction
	public static String markXMLSent(String scheduleIds) {
		return OSIxml.markXMLSent(scheduleIds);
	}
}