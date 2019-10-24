public with sharing class DealHiatusController extends DoubleCheckReadOnly {
    private static DealSelector dealSelector2 = new DealSelector();
    public static void setDealSelector(DealSelector dSelector) {
        dealSelector2 = dSelector;
    }
    private static ScheduleSelector scheduleSelector2 = new ScheduleSelector();
    public static void setScheduleSelector(ScheduleSelector scSelector) {
        scheduleSelector2 = scSelector;
    }

    public List<DealObject> DealObjList {get; set;}

    public String programTeam {get; set;}
    public Boolean filterReconciledWeeks {get; set;}

    public String PreselectedDealId {get; set;}
    public String hiatusTimeBefore {get; set;}
    public String hiatusTimeAfter {get; set;}
    public List<SelectOption> hiatusTimeOptions {get; set;}
    public Schedules__c hiatusTempScheduleStart {get; set;}
    public Schedules__c hiatusTempScheduleEnd {get; set;}

	public DealHiatusController() {
        super();

		// Default this checkbox to true
        filterReconciledWeeks = true;

        // Setup Hiatus Data
        hiatusTimeOptions = DealUtils.createHiatusTimeSelectList();
        hiatusTempScheduleStart = new Schedules__c();
        hiatusTempScheduleEnd = new Schedules__c();

        if (ApexPages.CurrentPage().getParameters().containsKey('DealId')) {
            PreselectedDealId = ApexPages.CurrentPage().getParameters().get('DealId');
            Deal__c PreselectedDeal = [select Id, Name from Deal__c where Id =: PreselectedDealId];
            SearchField = PreselectedDeal.Name;
            BarterCheckbox = false;
            SelectedCableSynd = '';
            SelectedDateLiteral = '';
            DoSearch();
            DealId = PreselectedDealId;
        }
	}

    public override void DoSearch() {
        try {
            DealResultList = new List<Deal__c>();
            SearchList = new List<String>();
            ReturnSOQLDateString();
            if(Searchfield == null || Searchfield == '') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,'Search field can not be null'));
                return;
            }

            SearchList = Searchfield.split(',');
            DealResultList = dealSelector2.getDealsFromSearchQuery(
                    SOQLDateString, SearchList, null, BarterCheckbox, SelectedCableSynd, programTeam, '200');

            if (DealResultList.size() == 0) {
                ApexPages.addMessage(new ApexPages.Message(
                        ApexPages.Severity.ERROR, 'The Search did not return any results'));
            }

            DealId = '';
            DealName = '';

            DealObjList = new List<DealObject>();
            for(Deal__c d : DealResultList) {
            	DealObjList.add(new DealObject(d));
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }     
    }

    public void HiatusUpdate() {
        try {
            if(hiatusTempScheduleStart.Week__c == null) {
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Must at least fill in a Start Date for the Hiatus'));
            } else if(hiatusTempScheduleStart.Week__c < Date.Today().ToStartOfWeek().addDays(1)) {
                ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.Error, 'Cannot be updated for past weeks'));
            } else if(hiatusTempScheduleEnd.Week__c != null && hiatusTempScheduleEnd.Week__c < hiatusTempScheduleStart.Week__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Hiatus End Date must come after Hiatus Start Date'));
            } else {
            	List<Id> dealIds = new List<Id>();
            	for(DealObject dealObj : DealObjList) {
            		if(dealObj.isChecked) {
	            		dealIds.add(dealObj.deal.Id);
	            	}
            	}

            	if(dealIds.size() < 1) {
            		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Must select as least one deal'));
            	} else {
	                List<Schedules__c> schedulesToUpdate;

	                // Query for all schedules on the deal, using the reconciled flag
	                String query = 'SELECT ' + SaberGF.getObjectsFieldsForQueries('Schedules__c') + ' FROM Schedules__c WHERE Deal_Parent__c IN :dealIds';
	                if(filterReconciledWeeks == true) {
	                    query += ' AND Reconciled__c = \'N\'';
	                }

	                if(hiatusTempScheduleEnd.Week__c != null) {
	                    schedulesToUpdate = ScheduleHiatus.hiatusDateRange(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTempScheduleEnd.Week__c);
	                } else if(hiatusTimeAfter != null) {
	                    schedulesToUpdate = ScheduleHiatus.hiatusTimeAfter(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTimeAfter);
	                } else if(hiatusTimeBefore != null) {
	                    schedulesToUpdate = ScheduleHiatus.hiatusTimeBefore(Database.query(query), hiatusTempScheduleStart.Week__c, hiatusTimeBefore);
	                } else {
	                    schedulesToUpdate = ScheduleHiatus.hiatusSingleDay(Database.query(query), hiatusTempScheduleStart.Week__c);
	                }
	                
	                if(schedulesToUpdate != null && schedulesToUpdate.size() > 0) {
	                    upsert schedulesToUpdate;
	                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Confirm, 'Successfully updated schedules with hiatus details!'));
	                } else {
	                	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'No schedules were updated with the selected hiatus details.'));
	                }
	            }
            }
        } catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public List<SelectOption> programTeamOptions {
        get {
            return DealUtils.ReturnTeamOptions();
        }
    }

    public class DealObject {
        public Boolean isChecked {get; set;}
        public Deal__c deal {get; set;}

        public DealObject(Deal__c d) {
            deal = d;
            isChecked = false;
        }
    }
}