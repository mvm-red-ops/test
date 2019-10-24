public with sharing class XMLBundleProgram {

	public String programId {get; set;}
	public String zipFileName {get; set;}

	public String testString {get; set;}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Controller instantiation. Grabs the selected Program's record Id from the URL query string
	*	and makes it accessible to the JavaScript code in XMLBundleProgram.page. Queries for Program Name and Week Pending fields.
	*	Also formulates the zip filename.
	**/
	public XMLBundleProgram() {
		this.programId = ApexPages.currentPage().getParameters().get('id');
		Programs__c program = [SELECT Id, Name, Week_Pending__c FROM Programs__c where Id = :programId];

		this.zipFileName = program.Name + '-XML Files-Week of ';
		Date d = program.Week_Pending__c;
		this.zipFileName += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '.zip';
	}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Used for manually throwing errors back to the Visualforce page.
	*	Usage: throw new ApplicationException('This is the error message');
	**/
	public class ApplicationException extends Exception {}

	/**
	* @author Ryan Scott
	* @date 12/02/2015
	* @description Function that initiates XML document generation for a Program record which can be sent to Hearst. 
	*	The Program must have Deal(s) and Schedule(s) linked to it, and the Program must have at least one active Bundle Pricing
	*	record linked to it. Data is grouped by Station into individual XML documents, and within each file the Station's Bundle Pricing
	*	data is displayed as buylines.
	*	This function is based on XMLBundle.getXMLFiles() and utilizes similar logic and supporting functions.
	* @param String programId - Record Id of the selected Program
	* @return Map<String, String> - A map containing the XML body of each file that was generated.
	*	Key: Filename using the Station's call letters with .xml added to the end (example: WMUR.xml)
	*	Value: Base64-encoded XML body content
	*	The map also includes a list of Schedules that were used, with the key 'scheduleIds'. The list contained record Ids separated by semicolons.
	**/
	@RemoteAction
	public static Map<String, String> getXMLFiles(String programId) {
		// Setup map to contain all results from this method. Will contain the generated XML files and a list of Schedules that were used in the process.
		Map<String, String> resultsData = new Map<String, String>();
		List<String> scheduleIds = new List<String>();

		Programs__c program = [SELECT Week_Pending__c, Logs_Contact__c FROM Programs__c WHERE Id = :programId];
		if(program.Logs_Contact__c == null) {
			throw new ApplicationException('The Logs Contact lookup is missing from the Program. Please add a Logs Contact and try again.');
		}

		// Get all active Bundle Pricing records for the Program and then group them by Station
		List<Bundle_Pricing__c> bundlePricingList = [
			SELECT Call_Letters__c,
			Days__c,
			End_Time__c,
			Rate_per_30__c,
			Start_Time__c,
			Station__r.Market__r.Name,
			Total__c,
			Units__c
			FROM Bundle_Pricing__c
			WHERE Program__c = :programId
				AND Active__c = true
		];
		if(bundlePricingList.size() == 0) {
			throw new ApplicationException('No active Bundle Pricing records were found. Please make sure that the Program has at least one active Bundle Pricing record.');
		}

		Map<String, XMLBundle.StationWrapper> stations = XMLBundle.buildStationList(bundlePricingList);

		Map<Id, Deal__c> deals = new Map<Id, Deal__c>([SELECT Id, Name, Advertiser__c, Brands__r.Name, ContactAccount__c, Length__c, Program__r.Bundle_Name__c, Program__r.Logs_Contact__r.FirstName, Program__r.Logs_Contact__r.LastName FROM Deal__c WHERE Program__c = :programId]);
		
		List<Schedules__c> schedules = [SELECT Id, Name, Week__c, Deal_Parent__c FROM Schedules__c WHERE Deal_Parent__c IN :deals.keySet() AND Week__c = :program.Week_Pending__c AND XML_Sent__c = false];
		Map<Id, Schedules__c> schedulesMap = new Map<Id, Schedules__c>();
		for(Schedules__c schedule : schedules) {
			schedulesMap.put(schedule.Deal_Parent__c, schedule);
		}

		for(Deal__c deal : deals.values()) {
			try {
				if(!schedulesMap.containsKey(deal.Id)) {
					continue;
				}

				Schedules__c schedule = schedulesMap.get(deal.Id);
				List<XMLBundle.ScheduleChunkWrapper> scheduleChunks = new List<XMLBundle.ScheduleChunkWrapper>();
				scheduleChunks.add(new XMLBundle.ScheduleChunkWrapper(schedule.Week__c, schedule.Week__c.addDays(6), 1, schedule.Id));

				// Generate the XML data for each Station. Put data in a map using the Station's filename as the keys and encoded data as values.
				for(XMLBundle.StationWrapper station : stations.values()) {
					String body = XMLBundle.generateXml(deal, scheduleChunks, station, deal.Name);

					String contactAccount = deal.ContactAccount__c.replaceAll('/', '');
					String brand = deal.Brands__r.Name.replaceAll('/', '');

					String filename = station.callLetters + '-' + schedule.Name + '-' + contactAccount + '-' + brand + '-NEW BUY-';
					Date d = Date.today();
					filename += d.year() + '-' + Utils.padIntegerWithLeadingZero(d.month()) + '-' + Utils.padIntegerWithLeadingZero(d.day()) + '.xml';

					resultsData.put(filename, EncodingUtil.base64Encode(Blob.valueOf(body)));
				}

				scheduleIds.add(schedule.Id);
			} catch(Exception e) {
				continue;
			}
		}

		if(resultsData.size() == 0) {
			throw new ApplicationException('None of the deals attached to this program have schedules for the week of ' + program.Week_Pending__c + '. Please add at least one schedule for this week and then try again. Make sure that the Schedules do not have the XML Sent field checked as those Schedules will be skipped.');
		}

		resultsData.put('scheduleIds', String.join(scheduleIds, ';'));

		return resultsData;
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