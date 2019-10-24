public with sharing class ContactAiredService {

    private static ScheduleSelector scheduleSelector = new ScheduleSelector();

    public static void setScheduleSelector(ScheduleSelector sSelector) {
        scheduleSelector = sSelector;
    }

	private String batchType;
	private Date lastMonday;
	private Date thisMonday;


	public ContactAiredService(String type) {
		batchType = type;
		lastMonday =  Date.today().toStartOfWeek().addDays(-6);
    	thisMonday = Date.today().toStartOfWeek().addDays(1);

		if (batchType.equals('NextWeekPreLogButton')) {
            lastMonday = lastMonday.addDays(7);
            thisMonday = thisMonday.addDays(7);
        }
	}

	/**
	 *	Name: getAiredContacts
	 *  Description: Given a list of contacts, parses through contact's schedules and program to
	 				 see if they were active during this week if PreLogBatch or last week if
					 PostLogBatch.
	 *  params: contacts - List of contacts
	 */
	public List<Contact> getAiredContacts(List<Contact> contacts) {
		Set<Id> contactIds = getContactIds(contacts);
		List<Id> cont = new List<Id>();
		cont.addAll(contactIds);
		Map<Id, List<Schedules__c>> schedulesByContactId = mapPreAndPostWeekSchedulesByContactId(cont);
		List<Contact> airedContacts = new List<Contact>();
		for (Contact contact: contacts) {
			if (schedulesByContactId.get(contact.Id) != null && isContactAired(contact, schedulesByContactId.get(contact.Id))) {
				airedContacts.add(contact);
			}
		}

		return airedContacts;
	}

	/*
	 * 	Name: mapPreAndPostWeekSchedulesByContactId
	 * 	Description: Give a set of Contact Ids, queries for each contact's schedules and returns
	 *				 a map of the schedules by contact id.
	 * 	param: contactIds - set of contact ids
	 */
	private Map<Id, List<Schedules__c>> mapPreAndPostWeekSchedulesByContactId(List<Id> contactIds) {

		List<Schedules__c> schedules = getPreAndPostWeekSchedulesByContactId(contactIds);
		Map<Id, List<Schedules__c>> schedulesByContactId = new Map<Id, List<Schedules__c>>();
		for(Schedules__c schedule : schedules) {
			if(schedulesByContactId.containsKey(schedule.Deal_Parent__r.Contact__c)) {
				schedulesByContactId.get(schedule.Deal_Parent__r.Contact__c).add(schedule);
			} else {
				schedulesByContactId.put(schedule.Deal_Parent__r.Contact__c, new List<Schedules__c>{schedule});
			}
		}
		return schedulesByContactId;
	}

	/*
	 * 	Name: isContactAired
	 * 	Description: Check for specific conditions on each schedule to see if they aired this week
	 *				 or last week.  If conditions met, send off to see if program can be set.
	 * 	param: contact - Contact to have program field updated.
	 *  param: schedules - List of schedules to check for airing conditions
	 */
	private Boolean isContactAired(Contact contact, List<Schedules__c> schedules) {
		Boolean contactUpdated = false;
		for (Schedules__c schedule: schedules) {

				if(schedule.Deal_Parent__r.Program__r.Cable_Synd__c == 'Cable') {

					if ( (batchType == 'PostLogButton') && (schedule.Spot_Count__c > 0) && schedule.Week__c.isSameDay(lastMonday)) {
						if (!contactUpdated) {
							contactUpdated = setContactPostLogWeekByProgramName(schedule.Deal_Parent__r.Program__r.Name, contact);
						} else {
							setContactPostLogWeekByProgramName(schedule.Deal_Parent__r.Program__r.Name, contact);
						}
					}

					if ( (batchType == 'PreLogButton' || batchType == 'NextWeekPreLogButton') &&  (schedule.Prelog_Count__c > 0 ) &&  schedule.Week__c.isSameDay(thisMonday) ){
						if (!contactUpdated) {
							contactUpdated = setContactPreLogWeekByProgramName(schedule.Deal_Parent__r.Program__r.Name, contact);
						} else {
							setContactPreLogWeekByProgramName(schedule.Deal_Parent__r.Program__r.Name, contact);
						}
					}
				} else if(schedule.Deal_Parent__r.Program__r.Cable_Synd__c == 'Syndication') {
					if ((batchType == 'PostLogButton' || batchType == 'NextWeekPreLogButton') && (schedule.Units_Preempted__c > 0 || schedule.Units_Aired__c >0) && schedule.Week__c.isSameDay(thisMonday)) {
						contact.Pre_Log_Week__c = thisMonday;
						contactUpdated = true;
					}
					if ( (batchType == 'PostLogButton') && (schedule.Units_Preempted__c > 0 || schedule.Units_Aired__c >0) && schedule.Week__c.isSameDay(lastMonday) ) {
						contact.Post_Log_Week__c = lastMonday;
						contactUpdated = true;
					}
				}
		}
		return contactUpdated;
	}

	private Map<String, Program> progs = new Map<String, Program>{
			'BounceTV' => new Program_BounceTV(null),
			'AntennaTV' => new Program_AntennaTV(null),
			'ThisTV' => new Program_ThisTV(null),
			'NHL' => new Program_NHL(null),
			'TVG2' => new Program_TVG2(null),
			'TVG' => new Program_TVG(null),
			'MLB' => new Program_MLB(null)
	};

	private static Program checkContains(Map<String, Program> progs, String check) {
		for (String key : progs.keySet()) {
			if (check.contains(key)) {
				return progs.get(key);
			}
		}
		return null;
	}

	private Boolean setContactPreLogWeekByProgramName(String name, Contact contact) {
		Program prog = checkContains(progs, name);
		if (prog != null) {
			prog.setPrelog(contact, thisMonday);
			return true;
		} else {
			Set<String> contactFieldSet = getContactFieldSet();
			if (contactFieldSet.contains(name.replace(' ','') + 'PreLogWeek__c')) {
				((SObject)(contact)).put(name.replace(' ','') + 'PreLogWeek__c', thisMonday);
				return true;
			} else if (contactFieldSet.contains(name.replace(' ','') + 'PreLog_Week__c')) {
				((SObject)(contact)).put(name.replace(' ','') + 'PreLog_Week__c', thisMonday);
				return true;
			}
		}
		return false;
    }

	private Boolean setContactPostLogWeekByProgramName(String name, Contact contact) {
		Program prog = checkContains(progs, name);
		if (prog != null) {
			prog.setPostlog(contact, lastMonday);
			return true;
		}
		else {
			Set<String> contactFieldSet = getContactFieldSet();
			if (contactFieldSet.contains(name.replace(' ','') + 'PostLogWeek__c')) {
				((SObject)(contact)).put(name.replace(' ','') + 'PostLogWeek__c', lastMonday);
				return true;
			}
		}
		return false;
	}

	private Set<String> getContactFieldSet() {
		Set<String> contactFieldSet = new Set<String>();
		for (Schema.SObjectField FieldObj : Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap().values()) {
          	Schema.DescribeFieldResult FieldDes = FieldObj.getDescribe();
          	if (FieldDes.getType().equals(Schema.DisplayType.DATE)) {
            	contactFieldSet.add(FieldDes.getName());
          	}
        }
		return contactFieldSet;
	}

	private List<Schedules__c> getPreAndPostWeekSchedulesByContactId(List<Id> contactIds) {
		return scheduleSelector.getSchedulesByContacts(contactIds, lastMonday, thisMonday);
	}

	private Set<Id> getContactIds(List<Contact> contacts) {
		Set<Id> contactIds = new Set<Id>();
		for (Contact contact : contacts) {
			contactIds.add(contact.Id);
		}
		return contactIds;
	}
}