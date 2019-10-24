/**
 * DealRevisionController
 * @description Main controller for the DealRevisions Page
 */

public class DealRevisionController {

    // Testing injection
    public DateSelector dates {get;set;}
    public DealSelector dealSelector {get;set;}

    // Extensions
    public DealQueryExtension dealQueryExt {get;set;}
    public DealUpdateExtension dealUpdateExt {get;set;}

    // Page variables
    public String searchString {get;set;}
    public String dateSOQLString {get;set;}
    public Boolean barterCheckbox {get; set;}
    public Boolean reconciledCheckbox {get; set;}
    public String cableSyndDrop {get; set;}
    public String teamDrop {get; set;}
    public String dateRangeDrop {get;set;}
    public Schedules__c WeekStartDate {get; set;}
    public Schedules__c WeekEndDate {get; set;}


    public DealRevisionController() {
        this.dealQueryExt = new DealQueryExtension(this);
        this.dealUpdateExt = new DealUpdateExtension(this);

        // Setup testing env
        this.dates = new DateSelector();
        this.dealSelector = new DealSelector();

        // Setup variables
        this.searchString = '';
        this.barterCheckbox = false;
        this.reconciledCheckbox = true;
        this.cableSyndDrop = '';
        this.teamDrop = '';
        this.WeekStartDate = new Schedules__c();
        this.WeekEndDate = new Schedules__c();
    }

    public void UpdateDateField() {
        try {
            // Set default value
            dateSOQLString = '';

            // If a picklist entry was not selected
            if (dateRangeDrop == null || dateRangeDrop == '') {
                return;
            }

            // If 'Custom' was selected, use date fields
            if (dateRangeDrop == 'Custom') {
                if (WeekStartDate.Week__c != null && WeekEndDate.Week__c != null) {
                    dateSOQLString = ' AND ( Week_MIN_Field__c >= '
                            + DealUtils.ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= '
                            + DealUtils.ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
                }
            }
            // Otherwise, use CalendarPeriods to get date range
            else {
                Map<String, CalendarPeriod> sel = DealUtils.getCustomCalendarPeriods(dates);
                CalendarPeriod val = sel.get(dateRangeDrop);
                if (val != null && val.setDates()) {
                    WeekStartDate.Week__c = val.weekStart;
                    WeekEndDate.Week__c = val.weekEnd;
                    dateSOQLString = ' AND ( Week_MIN_Field__c >= '
                        + DealUtils.ReturnStringDate(WeekStartDate.Week__c) + ' AND Week_MIN_Field__c <= '
                        + DealUtils.ReturnStringDate(WeekEndDate.Week__c) + ' ) ';
                }
            }
        }
        // Handle any exceptions
        catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public void SearchDeals() {
        try {
            // Check for empty search field
            if (searchString == null || searchString == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Search field can not be empty'));
                return;
            }

            // Setup variables
            dealQueryExt.selectedDealId = null;
            dealQueryExt.deals = new List<Deal__c>();
            dealUpdateExt.selectedDeal = null;
            UpdateDateField();
            Map<Id, Deal__c> uniqueDeals = new Map<Id, Deal__c>();
            Map<Integer,Set<Id>> Accuracy = new Map<Integer, Set<Id>>();
            Accuracy.put(1, new Set<Id>{});

            // Iterate through comma-separated searches
            searchString = searchString.replace(' , ', ',').replace(' ,', ',').replace(', ', ',');
            List<String> searches = searchString.split(',');
            for (String sea : searches) {
                String search = sea.normalizeSpace();
                search = '%' + search + '%';

                // Retrieve deals
                List<Deal__c> deals = dealSelector.getDealsFromQueryForRevision(
                        dateSOQLString, search, teamDrop, barterCheckbox, cableSyndDrop, '1000');

                // Sort using accuracy
                for(Deal__c dlist : deals) {
                    Boolean notInList = false;
                    uniqueDeals.put(dlist.Id, dlist);
                    for(Integer i = Accuracy.size(); i>0; i--) {
                        if(Accuracy.get(i).contains(dlist.Id)) {
                            notInList = true;
                            if(Accuracy.containsKey(i+1)) {
                                Set<Id> dealset1 = Accuracy.get(i+1);
                                dealset1.add(dlist.Id);
                                Accuracy.put(i+1, dealset1);
                            } else {
                                Set<Id> dealset1 = new Set<Id>();
                                dealset1.add(dlist.Id);
                                Accuracy.put(i+1, dealset1);
                            }
                            Accuracy.get(i).remove(dlist.Id);
                        }
                    }
                    if(notInList == false) {
                        Set<Id> dealset1 = Accuracy.get(1);
                        dealset1.add(dlist.Id);
                        Accuracy.put(1, dealset1);
                    }
                }
            }

            // Add up to 200 deals to result list
            Integer count = 0;
            List<Deal__c> result = new List<Deal__c>();
            if (Accuracy.containsKey(searches.size())) {
                for(Id MapofDeals : Accuracy.get(searches.size())) {
                    if (count < 200) {
                        result.add(uniqueDeals.get(MapofDeals));
                        count++;
                    }
                }
            }

            // If deals were found
            if (result.size() > 0) {
                dealQueryExt.deals = result;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                        'Found ' + result.size() + ' deals for query \'' + searchString + '\''));
            }
            // If no deals found
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                        'The Search did not return any results'));
            }
        }
        // Handle any exceptions
        catch(Exception e) {
            DealUtils.handleException(e);
        }
    }

    public List<SelectOption> cableSyndDropList {
        get {
            return DealUtils.ReturnCableSyndSOList();
        }

    }
    public List<SelectOption> teamDropList {
        get {
            return DealUtils.ReturnTeamOptions();
        }
    }

    public List<SelectOption> dateRangeDropList {
        get {
            return DealUtils.ReturnDateLiteralSOList();
        }
    }

}