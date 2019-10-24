public with sharing class TapeScheduleFind {

	//
	// Constants
	//
	private static final String INVALID_TAPE = 'The Tape record is missing values to compare against schedules';
	private static final String NO_MATCHING_SCHEDULES = 'There were no matching schedules found';
	private static final String ERROR = 'Error - ';
	private static final String LINE_NUMBER = 'Line Number - ';

	//
	// Public Page Fields
	//
	public Tape__c tapeRecord { get; set; }
	public String tapeId { get; set; }
	public List<ScheduleWrapper> scheduleWrapperList { get; set; }

	//
	// Private Class Fields
	//
	public TapeSelector tapeSelector { get; set; }
	public ScheduleSelector scheduleSelector { get; set; }

	/**
     * @description Construct the TapeScheduleFind with custom database Selectors
     * @param sc The StandardController for holding the Tape__c SObject
     * @param ss The Custom ScheduleSelector used
     * @param ts The Custom TapeSelector used
     */
	public TapeScheduleFind(ApexPages.StandardController sc, ScheduleSelector ss, TapeSelector ts) {
		this.scheduleSelector = ss;
		this.tapeSelector = ts;
		this.pageSetup(sc);
	}

	/**
     * @description Construct the TapeScheduleFind Page with default database Selectors
     * @param sc The StandardController for holding the Tape__c SObject
     */
	public TapeScheduleFind(ApexPages.StandardController sc) {
		// Set up database selectors
		this.tapeSelector = new TapeSelector();
		this.scheduleSelector = new ScheduleSelector();
		this.pageSetup(sc);
	}

	/**
     * @description TapeScheduleFind setup using StandardController
     * @param sc The standard controller being used to setup the page
     */
	public void pageSetup(ApexPages.StandardController sc) {
		try {
			if (sc != null) {
				this.loadTapeRecord(sc);
			}
		} catch (Exception ex) {
			this.loadErrorMessages(ex);
		}
	}

	/**
     * @description Method run when the "Save" button is executed
     * @return The PageReference result of the SaveButton
     *  (Should redirect to the TapeRecord page)
     */
	public PageReference saveButton() {
		try {
            this.populateWrappersFromTape(this.scheduleWrapperList, this.tapeRecord);
			return new PageReference('/' + tapeRecord.Id);
		} catch (Exception ex) {
			this.loadErrorMessages(ex);
			return null;
		}
	}

	/**
     * @description Method run when the "Cancel" button is executed
     * @return The PageReference result of the CancelButton
     *  (Should redirect to the TapeRecord page)
     */
	public PageReference cancelButton() {
		try {
			return new PageReference('/' + tapeRecord.Id);
		} catch (Exception ex) {
			this.loadErrorMessages(ex);
			return null;
		}
	}

	/**
     * @description Add to the ScheduleWrapper list from Database selector
     *  Set the page errors if matching schedules weren't found.
     */
	private List<ScheduleWrapper> populateScheduleWrapper() {
		List<ScheduleWrapper> result = new List<ScheduleWrapper>();
		List<Schedules__c> ScheduleList = scheduleSelector.getSchedulesFromTape(tapeRecord);
		if (ScheduleList.size() > 0) {
			for (Schedules__c sch : ScheduleList) {
				result.add(new ScheduleWrapper(sch));
			}
		} else {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, NO_MATCHING_SCHEDULES));
		}
		return result;
	}

    /**
     * @description Update a list of selected ScheduleWrappers from the provided Tape__c record
     * @param wrapperList The list of ScheduleWrapper's being populated
     * @param tapeRecord The Tape__c object being used to update the Wrappers
     */
    private void populateWrappersFromTape(List<ScheduleWrapper> wrapperList, Tape__c tapeRecord) {
        List<Schedules__c> scheduleList = new List<Schedules__c>();
        for (ScheduleWrapper schw : wrapperList) {
            if (schw.selected) {
                Schedules__c schRecord = new Schedules__c(Id = schw.scheduleRecord.Id);
                schRecord.ISCI_CODE__c = tapeRecord.ISCI__c;
                schRecord.ISCI2__c = tapeRecord.ISCI_2__c;
                schRecord.ISCI3__c = tapeRecord.ISCI_3__c;
                schRecord.Rotation__c = tapeRecord.Rotation__c;
                schRecord.X800_Number__c = tapeRecord.X800_Number__c;
                schRecord.Traffic__c = tapeRecord.Id;
                scheduleList.add(schRecord);
            }
        }
        update scheduleList;
    }

	/**
     * @description Load the TapeRecord from the StandardController
     *  Set the page errors if the Tape Record is invalid
     * @param sc The view controller being used
     */
	private void loadTapeRecord(ApexPages.StandardController sc) {
		this.tapeId = sc.getId();
		this.tapeRecord = tapeSelector.getTapeFromId(this.tapeId);
		if (this.checkValidTape(tapeRecord)) {
			this.scheduleWrapperList = this.populateScheduleWrapper();
		} else {
			ApexPages.addMessage(new ApexpAges.Message(ApexPages.Severity.INFO, INVALID_TAPE));
		}
	}

	/**
     * @description Check whether necessary properties are set on the Tape Record
     * @param tapeRecord The Tape Record being checked for validity
     * @return Whether the Tape Record has the valid properties set
     */
	private Boolean checkValidTape(Tape__c tapeRecord) {
		return tapeRecord.Account__c != null
				&& tapeRecord.Brand__c != null
				&& tapeRecord.Flight_End__c != null
				&& tapeRecord.Flight_Start__c != null
				&& tapeRecord.Program__c != null;
	}

	/**
     * @description Load appropriate error message on the page
     * @param ex The exception which the error message is being loaded from
     */
	private void loadErrorMessages(Exception ex) {
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR + ex.getMessage()));
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, LINE_NUMBER + ex.getLineNumber()));
	}

	/**
     * @description ScheduleWrapper classes used to hold data about a Schedule__c
     *  in loaded ScheduleWrapperList
     */
	public class ScheduleWrapper {
		public Boolean selected { get; set; }
		public Schedules__c scheduleRecord { get; set; }
		public ScheduleWrapper(Schedules__c pScheduleRecord) {
			this.scheduleRecord = pScheduleRecord;
			this.selected = false;
		}
	}
}