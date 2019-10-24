public with sharing class ProcessScheduleTapeRecords {

    /* Database Selectors */
    public ScheduleSelector schSelector { get; set; }
    public TapeSelector tapeSelector { get; set; }

    /* View Controller */
    ApexPages.StandardSetController sdmssc { get; set; }

    /* Public Fields */
    public String filterId { get; set; }
    public List<WrapperClass> wrapperList { get; set; }

    /* Private Collections */
    private List<Schedules__c> schedulesList = new List<Schedules__c>();

    private Map<Id, Tape__c> tapeMap = new Map<Id, Tape__c>();
    private Map<Id, Set<Id>> dealProgramMap = new Map<Id, Set<Id>>();
    private Map<Id, Set<Id>> dealBrandMap = new Map<Id, Set<Id>>();
    private Map<Id, Set<Id>> dealAccountMap = new Map<Id, Set<Id>>();
    private Map<Id, Date> minWeekMap = new Map<Id, Date>();
    private Map<Id, Date> maxWeekMap = new Map<Id, Date>();

    private Map<Id, Id> scheduleTapeMap = new Map<Id, Id>();
    private Map<Id, Set<Id>> tapeDuplicateScheduleIdMap = new Map<Id, Set<Id>>();

    /**
     * Construct the ProcessScheduleTapeRecords
     *  Establish the SSC (view controller)
     *
     * @param ssc The StandardSetController being set
     */
    public ProcessScheduleTapeRecords(ApexPages.StandardSetController ssc) {

        // Ensure our Database Selectors are valid at this point
        if (this.tapeSelector == null) {
            this.tapeSelector = new TapeSelector();
        }
        if (this.schSelector == null) {
            this.schSelector = new ScheduleSelector();
        }

        if (ssc != null) {
            sdmssc = ssc;
            System.debug('Filter Id - ' + ssc.getFilterId());
            filterId = ssc.getFilterId();
            if (filterId.length() > 15) {
                filterId = filterId.substring(0, 15);
            }
        }

        wrapperList = new List<WrapperClass>();
    }


    /**
     * Primary method run for Processing the tape records.
     *  This is run from the page
     */
    public void processScheduleTapeRecordsMethod() {
        try {
            // Ensure View controller is valid
            if (sdmssc == null) {
                return;
            }

            // Load Schedule List (Based on selected schedule IDs)
            schedulesList = schSelector.getSchedulesFromSelected(sdmssc.getSelected());

            // Load Tapes
            this.loadTapes(this.getMinWeek(), this.getMaxWeek());

            // Process & Update Schedules from Tapes
            this.processSchedules();
            this.updateSchedules();
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error - ' + ex.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Line Number - ' + ex.getLineNumber()));
        }
    }


    /**
     * Retrieve the PageReference from pressing the "Go Back" button
     *  Gets the page reference based on filter (if set)
     *
     * @return The resulting page reference to redirect to depending on FilterID
     */
    public PageReference goBackButton() {
        try {
            if (filterId != null) {
                return new PageReference('/a08?fcf=' + filterId);
            } else {
                return new PageReference('/a08');
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error - ' + ex.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Line Number - ' + ex.getLineNumber()));
        }
        return null;
    }

    /**
     * Retrieve the MinWeek value from the loaded SchedulesList
     *
     * @return The minimum value from the loaded SchedulesList
     */
    private Date getMinWeek() {
        Date MinWeek = Date.newInstance(3000, 1, 1);
        for (Schedules__c schedule : schedulesList) {
            if (MinWeek < schedule.Week__c) {
                MinWeek = schedule.Week__c;
            }
        }
        return MinWeek;
    }

    /**
     * Retrieve the MaxWeek value from the loaded SchedulesList
     *
     * @return The maximum value from the loaded SchedulesList
     */
    private Date getMaxWeek() {
        Date MaxWeek = Date.newInstance(1000, 1, 1);
        for (Schedules__c schedule : schedulesList) {
            if (MaxWeek > schedule.Week__c) {
                MaxWeek = schedule.Week__c;
            }
        }
        return MaxWeek;
    }

    /**
     * Load Tapes into the TapeMap based on the provided date restraints
     *
     * @param MinWeek The Minimum date to load Tapes from
     * @param MaxWeek The Maximum date to load Tapes from
     */
    private void loadTapes(Date MinWeek, Date MaxWeek) {
        // Retrieve list of tapes
        List<Tape__c> TapeList = tapeSelector.getTapesInFlightRange(MinWeek, MaxWeek);

        for (Tape__c TapeRecord : TapeList) {
            Id ProgramId = TapeRecord.Program__c;
            Id BrandId = TapeRecord.Brand__c;
            Id AccountId = TapeRecord.Account__c;

            // Ensure ProgramMap Setup
            if (!dealProgramMap.containsKey(ProgramId)) {
                dealProgramMap.put(ProgramId, new Set<Id>());
            }

            // Ensure BrandMap Setup
            if (!dealBrandMap.containsKey(BrandId)) {
                dealBrandMap.put(BrandId, new Set<Id>());
            }

            // Ensure AccountMap Setup
            if (!dealAccountMap.containsKey(AccountId)) {
                dealAccountMap.put(AccountId, new Set<Id>());
            }

            // Add TapeRecord To Maps
            dealProgramMap.get(ProgramId).add(TapeRecord.Id);
            dealBrandMap.get(BrandId).add(TapeRecord.Id);
            dealAccountMap.get(AccountId).add(TapeRecord.Id);

            // Set Min/Max Weeks to Flight Start/End
            minWeekMap.put(TapeRecord.Id, TapeRecord.Flight_Start__c);
            maxWeekMap.put(TapeRecord.Id, TapeRecord.Flight_End__c);

            // Add to TapeMap
            tapeMap.put(TapeRecord.Id, TapeRecord);
        }
    }

    /**
     * Process the Schedules from the loaded SchedulesList
     */
    private void processSchedules() {
        System.debug(schedulesList.size());
        for (Schedules__c schedule : schedulesList) {
            Id programId = schedule.Deal_Parent__r.Program__c;

            if (!dealProgramMap.containsKey(programId)) {
                continue;
            }

            Set<Id> TapeIdSet = new Set<Id>();
            Set<Id> ProgramIdSet = dealProgramMap.get(programId);

            // Process TapeIDs for Program
            this.processTapes(schedule, ProgramIdSet, TapeIdSet);

            // Add to Duplicate map
            tapeDuplicateScheduleIdMap.put(schedule.Id, TapeIdSet);
        }
    }

    /**
     * Process Tapes from the provided schedule and program Id's
     *
     * @param schedule The Schedule used to process the Tapes
     * @param ProgramIds The list of programs loaded from the DealMap
     * @param TapeIdSet The list of Tape Id's added to while processing
     */
    private void processTapes(Schedules__c schedule, Set<Id> ProgramIds, Set<Id> TapeIdSet) {

        Id brandId = schedule.Deal_Parent__r.Brands__c;
        Id accountId = schedule.Deal_Parent__r.Contact__r.AccountId;

        for (Id TapeId : ProgramIds) {
            // Ensure TapeMap contains TapeID
            if (!tapeMap.containsKey(TapeId)) continue;
            // Ensure BrandMap has TapeID
            if (!dealBrandMap.containsKey(brandId) || !dealBrandMap.get(brandId).contains(TapeId)) continue;
            // Ensure AccountMap has TapeID
            if (!dealAccountMap.containsKey(accountId) || !dealAccountMap.get(accountId).contains(TapeId)) continue;
            // Ensure we are within time-frame
            if (minWeekMap.get(TapeId) > schedule.Week__c || maxWeekMap.get(TapeId) < schedule.Week__c) continue;

            // Retrieve the record from the TapeMap
            Tape__c TapeRecord = tapeMap.get(TapeId);

            // Ensure valid length
            if (TapeRecord.Length__c == null || Decimal.valueOf(TapeRecord.Length__c) != schedule.UnitLength__c) continue;

            // If not scheduled, add to schedule
            if (!scheduleTapeMap.containsKey(schedule.Id)) {
                scheduleTapeMap.put(schedule.Id, TapeId);
                System.debug('Schedule Id - ' + schedule.Id + ' - ' + TapeId);
            }

            TapeIdSet.add(TapeId);
        }
    }

    /**
     * Update the Processed Schedules
     */
    private void updateSchedules() {
        Map<Id, Schedules__c> ScheduleMap = new Map<Id, Schedules__c>();
        List<Schedules__c> SchedulesToUpdate = new List<Schedules__c>();

        // Load ScheduleMap
        for (Schedules__c schedule : schedulesList) {
            ScheduleMap.put(schedule.Id, schedule);
        }

        for (Id ScheduleId : scheduleTapeMap.keySet()) {
            if (tapeDuplicateScheduleIdMap.containsKey(ScheduleId)) {
                Set<Id> DuplicateIdSet = tapeDuplicateScheduleIdMap.get(ScheduleId);

                // Duplicate Set, add to be updated
                if (DuplicateIdSet.size() == 1) {
                    Tape__c TapeRecord = tapeMap.get(scheduleTapeMap.get(ScheduleId));
                    Schedules__c SchRecord = new Schedules__c(Id = ScheduleId);
                    SchRecord.ISCI_CODE__c = TapeRecord.ISCI__c;
                    SchRecord.ISCI2__c = TapeRecord.ISCI_2__c;
                    SchRecord.ISCI3__c = TapeRecord.ISCI_3__c;
                    SchRecord.Rotation__c = TapeRecord.Rotation__c;
                    SchRecord.X800_Number__c = TapeRecord.X800_Number__c;
                    SchRecord.Traffic__c = TapeRecord.Id;

                    /*if (ScheduleMap.containsKey(ScheduleId))
                    {
                        AllSchedulesList.add(ScheduleMap.get(ScheduleId));
                        TapeScheduleMap.put(ScheduleId, TapeRecord);
                    }*/

                    WrapperClass WC = new WrapperClass();
                    WC.SchRecord = ScheduleMap.get(ScheduleId);
                    WC.Status = 'Found & Updated';
                    WC.MatchingTapes = new List<Tape__c>{
                            TapeRecord
                    };
                    wrapperList.add(WC);
                    SchedulesToUpdate.add(SchRecord);
                } else if (DuplicateIdSet.size() > 1) {
                    WrapperClass WC = new WrapperClass();
                    WC.SchRecord = ScheduleMap.get(ScheduleId);
                    WC.Status = 'Multiple matching Tapes found';
                    List<Tape__c> DupTapeList = new List<Tape__c>();
                    for (Id TapeId : DuplicateIdSet) {
                        if (tapeMap.containsKey(TapeId)) {
                            DupTapeList.add(tapeMap.get(TapeId));
                        }
                    }
                    WC.MatchingTapes = DupTapeList;
                    wrapperList.add(WC);
                }
            }
        }

        // Look for matching tapes
        for (Schedules__c schedule : schedulesList) {
            if (!scheduleTapeMap.containsKey(schedule.Id)) {
                if (ScheduleMap.containsKey(schedule.Id)) {
                    WrapperClass WC = new WrapperClass();
                    WC.SchRecord = ScheduleMap.get(schedule.Id);
                    WC.Status = 'No matching tapes found';
                    WC.MatchingTapes = new List<Tape__c>();
                    wrapperList.add(WC);
                }
            }
        }


        System.debug('SchedulesList size - ' + schedulesList.size());
        update SchedulesToUpdate;
    }

    /**
     * Class loaded into WrapperList and fields loaded onto the page
     */
    public class WrapperClass {
        public Schedules__c SchRecord { get; set; }
        public String Status { get; set; }
        public List<Tape__c> MatchingTapes { get; set; }

        public WrapperClass() {

        }
    }
}