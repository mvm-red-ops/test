public with sharing class DealRevisionLightningController {

    public static DateSelector dates = new DateSelector();

    private static List<String> DEAL_FIELDS = new String[]{
            'Id', 'Program__c', 'Contact__c', 'Client_Account__c', 'Brands__c', 'Name', 'Length__c', 'Campaign__c',
            'Week_MIN_Field__c', 'Agency_Deal_Number__c', 'Contact__r.Name', 'Brands__r.Name', 'Network_Deal_Number__c',
            'Sum_of_Total_Dollars__c', 'Sum_of_Units_Available__c', 'ContactAccount__c', 'Week_Max__c',
            'Client_Account__r.Name', 'Contact__r.Account.id', 'SF_Deal_ID__c', 'Program__r.Name',
            'Program__r.Prelog_Date_Time__c', 'Advertiser_ID__c', 'Advertiser__c',
            '(SELECT Status__c, Week__c, Name, Cap__c, LastModifiedDate FROM Schedules__r WHERE Status__c = \'Sold\')'
    };

    private static List<String> SCHEDULE_FIELDS() {
        Set<String> result = new Set<String>(SaberGF.getObjectsFieldsForQueriesFromFieldSet('Schedules__c', 'Deal_Revision'));
        result.addAll(new List<String>{'Name', 'BGColor__c', 'Reconciled__c', 'Dollars_Booked__c', 'MGM_HD_Daypart__c',
                'Days_Allowed_Formula__c', 'DaysAllowedFormula__c', 'Start_End_Time__c', 'UnitLength__c', 'End_Time__c',
                'Total_Dollars__c', 'TEST__c', 'Units_Aired__c', 'Units_Available__c', 'Cap__c', 'Max_Per_Day__c',
                'Deal_Parent__r.Week_MIN_Field__c'
        });

        return new List<String>(result);
    }

    static final Integer PAGINATION_SIZE = 50;

    @AuraEnabled
    public static String searchDeals(String searchString, Integer page, String range, String startString, String endString,
                                            String team, String cableSyndication, Boolean barter, Boolean hideReconciled) {
        String query = 'SELECT ' + String.join(DEAL_FIELDS, ',') + ' FROM Deal__c';

        String whereClause = ' WHERE ';

        List<String> filterFields = new String[]{
                'Program__r.Name', 'Contact__r.Name', 'Client_Account__r.Name', 'Contact__r.Account.Name',
                'Brands__r.Name', 'Network_Deal_Number__c', 'Brands__r.Advertiser__r.Name', 'Name'
        };

        whereClause += '(' + String.join(filterFields, ' LIKE \'%' + searchString + '%\' OR ') + ' LIKE \'%' + searchString + '%\')';

        if (barter == true) {
            whereClause += ' AND Program__r.Barter__c = TRUE';
        }
        if (cableSyndication != null && cableSyndication != '') {
            whereClause += ' AND Program__r.Cable_Synd__c = \'' + cableSyndication + '\'';
        }
        if (team != null && team != '') {
            whereClause += ' AND Program__r.Team__c = \'' + team + '\'';
        }

        Map<String,Date> rangeDates = getRangeDates(range);
        if (rangeDates != null) {
            startString = DealUtils.ReturnStringDate(rangeDates.get('from'));
            endString = DealUtils.ReturnStringDate(rangeDates.get('to'));
        }

        if (startString != null && startString != '' && endString != null && endString != '') {
            whereClause += ' AND Week_MIN_Field__c >= ' + startString + ' AND Week_MIN_Field__c <= ' + endString;
        }

        whereClause += ' AND Week_MIN_Field__c != NULL';
        query += whereClause + ' ORDER BY Week_MIN_Field__c DESC LIMIT ' + PAGINATION_SIZE;

        if (page != null) {
            query += ' OFFSET ' + (PAGINATION_SIZE * page);
        }

        List<Deal__c> deals = Database.query(query);

        query = 'SELECT COUNT() FROM Deal__c' + whereClause;
        Integer count = Database.countQuery(query);

        return JSON.serialize(new Map<String, Object>{
            'deals' => deals,
            'count' => count
        });
    }

    @AuraEnabled
    public static List<Schedules__c> getDealSchedules(Id dealId) {
        String query = 'SELECT ' + String.join(SCHEDULE_FIELDS(), ',') +
                ' FROM Schedules__c WHERE Deal_Parent__c = \'' + dealId + '\'';
        return Database.query(query);
    }

    public class ScheduleGroup {
        @AuraEnabled public Schedules__c[] schedules;
        @AuraEnabled public String index;
        @AuraEnabled public String startEndTime;
        @AuraEnabled public Decimal rate;
        @AuraEnabled public Date week;
        @AuraEnabled public Decimal unitsAvailable;
        @AuraEnabled public String cap;
        @AuraEnabled public String networks;
        @AuraEnabled public String daypart;
        @AuraEnabled public String startTime;
        @AuraEnabled public String endTime;
        @AuraEnabled public String daysAllowed;
        @AuraEnabled public Decimal maxPerDay;
        @AuraEnabled public Boolean test;

        @AuraEnabled public Date hiatusStartDate;
        @AuraEnabled public Date hiatusEndDate;
        @AuraEnabled public String hiatusStartTime;
        @AuraEnabled public String hiatusEndTime;
    }

    public static Date getEndOfQuarter(Deal__c selectedDeal, List<ScheduleGroup> groups) {

        Date lowestDate = null;
        Date highestDate = null;

        for (ScheduleGroup scheduleGroup : groups) {
            for (Schedules__c schedule : scheduleGroup.schedules) {
                if (lowestDate == null || lowestDate > schedule.Week__c) {
                    lowestDate = schedule.Week__c;
                }
                if (highestDate == null || highestDate < schedule.Week__c) {
                    highestDate = schedule.Week__c;
                }
            }
        }

        Period period = null;
        Date endOfQuarter = null;

        selectedDeal = new DealSelector().getDealsFromId(selectedDeal.Id)[0];
        Date anchorDate = selectedDeal.Week_MIN_Field__c;
        do {
            period = new PeriodSelector().getQuarterPeriodFromDate(anchorDate);
            endOfQuarter = period.EndDate;
            if (highestDate > endOfQuarter) {
                endOfQuarter = highestDate;
            }
            if (anchorDate > endOfQuarter) {
                anchorDate = anchorDate.addDays(7);
            }
        } while  (anchorDate > endOfQuarter);

        return endOfQuarter;
    }

    @AuraEnabled
    public static String updateSchedules(Id selectedDealId, String groupsJSON, String selectedTab) {
        List<ScheduleGroup> groups = (List<ScheduleGroup>) JSON.deserialize(groupsJSON, List<ScheduleGroup>.class);
        System.debug('selectedDealId ' + selectedDealId);
        System.debug('groups ' + groups);
        System.debug('selectedTab ' + selectedTab);
        Deal__c selectedDeal = new Deal__c(Id = selectedDealId);
        Date endOfQuarter = getEndOfQuarter(selectedDeal, groups);
        Map<Id,Schedules__c> actualSchedules = getActualSchedules(groups);

        DateSelector dates = new DateSelector();
        List<Mass_Deal_Change__c> changes = new List<Mass_Deal_Change__c>();
        List<Schedules__c> schedulesToUpdate = new List<Schedules__c>();
        List<Schedules__c> schedulesToInsert = new List<Schedules__c>();
        Map<String, String> errors = new Map<String, String>();

        for (ScheduleGroup scheduleGroup : groups) {
            if (selectedTab != 'Hiatus') {
                if (scheduleGroup.week == null) {
                    errors.put(scheduleGroup.index, 'You must specify the date');
                } else {
                    scheduleGroup.week = Date.newInstance(scheduleGroup.week.year(), scheduleGroup.week.month(), scheduleGroup.week.day());
                    if (scheduleGroup.week < dates.today().toStartOfWeek().addDays(1)) {
                        errors.put(scheduleGroup.index, 'You cannot update past weeks');
                    } else if (!scheduleGroup.week.isSameDay(scheduleGroup.week.toStartOfWeek().addDays(1))) {
                        errors.put(scheduleGroup.index, 'The selected date must be a Monday: ' + scheduleGroup.week);
                    } else if (scheduleGroup.week > endOfQuarter) {
                        errors.put(scheduleGroup.index, 'Cannot select dates for weeks that extend beyond the last ' +
                                ' week of the quarter (' + String.valueOf(endOfQuarter) + ')');
                    }
                }
            }
            if (errors.get(scheduleGroup.index) != null) {
                System.debug(errors.get(scheduleGroup.index));
                continue;
            }

            Mass_Deal_Change__c change = new Mass_Deal_Change__c(
                Deal__c = selectedDeal.Id,
                Tab__c = selectedTab
            );

            Schedules__c highestDate = new Schedules__c(Week__c = Date.newInstance(1000, 0, 1));
            Integer i = 0;
            for (Schedules__c s : scheduleGroup.schedules) {
                if (s != null) {
                    Schedules__c schedule = actualSchedules.get(s.Id);
                    highestDate = (schedule.Week__c > highestDate.Week__c) ? schedule : highestDate;
                    scheduleGroup.schedules[i] = schedule;
                }
                i++;
            }

            List<String> scheduleNames = new List<String>();
            Boolean hasUpdatedMassChange = false;
            for (Schedules__c schedule : scheduleGroup.schedules) {
                if (schedule == null) continue;

                if (selectedTab == 'LTC' && schedule.Week__c == scheduleGroup.week.toStartOfWeek().addDays(1)) {
                    schedulesToUpdate.add(
                        ScheduleHiatus.hiatusDateRange(
                            new List<Schedules__c>{schedule},
                            scheduleGroup.week.addDays(1),
                            schedule.Week__c.addDays(6)
                        )[0]
                    );
                    continue;
                }

                if (selectedTab != 'Hiatus' && selectedTab != 'Extend'
                        && (schedule.Week__c < scheduleGroup.week
                        || schedule.Week__c < dates.today().toStartOfWeek().addDays(1))) {
                    continue;
                } else if (selectedTab == 'Extend' && scheduleGroup.week <= highestDate.Week__c) {
                    continue;
                }

                if (!hasUpdatedMassChange) {
                    hasUpdatedMassChange = true;

                    change.Original_Rate__c = schedule.Rate__c;
                    change.Original_Daypart__c = schedule.MGM_HD_Daypart__c;
                    change.Original_Days_Allowed__c = schedule.Days_Allowed__c;
                    change.Original_Start_End_Time__c = schedule.Start_End_Time__c;
                    change.Original_Units_Available__c = schedule.Units_Available__c;
                    change.Original_Cap__c = schedule.Cap__c;
                    change.Original_Max_Per_Day__c = schedule.Max_Per_Day__c;

                    // Executes once
                    switch on selectedTab {
                        when 'LTC'{
                            change.Week_Start__c = schedule.Week__c;
                        } when 'Rate' {
                            change.Changed_Rate__c = scheduleGroup.rate;
                        } when 'Extend' {
                            System.debug(highestDate.Week__c);
                            if (highestDate.Id != null && highestDate.Week__c.addDays(7) <= scheduleGroup.week) {
                                schedulesToInsert.addAll(handleExtend(highestDate, scheduleGroup, endOfQuarter));
                                if (!schedulesToInsert.isEmpty()) {
                                    change.Week_Start__c = highestDate.Week__c.addDays(7);
                                    change.Week_End__c = schedulesToInsert[schedulesToInsert.size() - 1].Week__c;
                                }
                            }
                        } when 'Frequency' {
                            change.Changed_Units_Available__c = scheduleGroup.unitsAvailable;
                        } when 'Test' {
                            change.Week_Start__c = schedule.Week__c;
                        } when 'Cap' {
                            change.Changed_Cap__c = scheduleGroup.cap;
                        } when 'Daypart' {
                            change.Changed_Daypart__c = scheduleGroup.daypart;
                            change.Changed_Days_Allowed__c = scheduleGroup.daysAllowed;
                            change.Changed_Start_End_Time__c = scheduleGroup.startTime + '-' + scheduleGroup.endTime;
                        } when 'Max Per Day' {
                            change.Changed_Max_Per_Day__c = scheduleGroup.maxPerDay;
                        }
                    }
                }
                // Executes every time
                switch on selectedTab {
                    when 'LTC' {
                        schedule.Status__c = 'Canceled';
                    } when 'Rate' {
                        schedule.Rate__c = scheduleGroup.rate;
                    } when 'Frequency' {
                        schedule.Units_Available__c = scheduleGroup.unitsAvailable;
                    } when 'Test' {
                        schedule.TEST__c = scheduleGroup.test;
                    } when 'Cap' {
                        schedule.Cap__c = scheduleGroup.cap;
                    } when 'Daypart' {
                        schedulesToUpdate.add(new Schedules__c(
                            Id = schedule.Id,
                            Networks__c = scheduleGroup.networks,
                            MGM_HD_Daypart__c = scheduleGroup.daypart,
                            Start_Time__c = scheduleGroup.startTime,
                            End_Time__c = scheduleGroup.endTime,
                            Days_Allowed__c = scheduleGroup.daysAllowed
                        ));
                    } when 'Max Per Day' {
                        schedule.Max_Per_Day__c = scheduleGroup.maxPerDay;
                    } when 'Hiatus' {
                        schedulesToUpdate.addAll(handleHiatus(
                                scheduleGroup.hiatusStartDate,
                                scheduleGroup.hiatusEndDate,
                                scheduleGroup.hiatusStartTime,
                                scheduleGroup.hiatusEndTime,
                                selectedDealId,
                                scheduleGroup.index,
                                errors
                        ));
                    }
                }

                if (change.Week_Start__c == null) {
                    change.Week_Start__c = schedule.Week__c;
                } else if (schedule.Week__c < change.Week_Start__c) {
                    change.Week_Start__c = schedule.Week__c;
                }

                if (change.Week_End__c == null) {
                    change.Week_End__c = schedule.Week__c;
                } else if (schedule.Week__c > change.Week_End__c) {
                    change.Week_End__c = schedule.Week__c;
                }

                // Daypart/Hiatus strip some data from the schedule above
                if (selectedTab != 'Daypart' && selectedTab != 'Hiatus') {
                    schedulesToUpdate.add(schedule);
                }
                scheduleNames.add(schedule.Name);
            }

            if (scheduleNames.size() >= 1) {
                String names = String.join(scheduleNames, ';');
                change.Schedules__c = names;
                change.LTC_Date__c = change.Week_Start__c;
                changes.add(change);
            }
        }

        //System.debug('updating' + schedulesToUpdate[0].Units_Available__c);
        update (List<SObject>) schedulesToUpdate;
        insert (List<SObject>) schedulesToInsert;
        insert (List<SObject>) changes;

        if (errors.size() > 0) {
            return JSON.serialize(
                new Map<String, Object>{
                    'success' => false,
                    'errors' => errors
                }
            );
        }

        return JSON.serialize(
            new Map<String, Object>{
                'success' => true,
                'changes' => changes,
                'schedules' => schedulesToUpdate,
                'inserted' => schedulesToInsert
            }
        );
    }

    private static Map<Id,Schedules__c> getActualSchedules(List<ScheduleGroup> groups) {
        Set<Id> scheduleIds = new Set<Id>();
        for (ScheduleGroup g : groups) {
            for (Schedules__c s : g.schedules) {
                scheduleIds.add(s.Id);
            }
        }

        String query = 'SELECT ' + String.join(new List<String>(new Set<String>(SCHEDULE_FIELDS())), ', ') +
                ' FROM Schedules__c WHERE Id IN :scheduleIds';
        return new Map<Id,Schedules__c>((List<Schedules__c>) Database.query(query));
    }

    @AuraEnabled
    public static String getSchedulePicklistOptions() {
        Map<String, List<Schema.PicklistEntry>> picklists = new Map<String, List<Schema.PicklistEntry>>();
        picklists.put('Cap__c', Schedules__c.Cap__c.getDescribe().getPicklistValues());
        picklists.put('Start_Time__c', Schedules__c.Start_Time__c.getDescribe().getPicklistValues());
        picklists.put('End_Time__c', Schedules__c.End_Time__c.getDescribe().getPicklistValues());

        return JSON.serialize(picklists);
    }

    @AuraEnabled
    public static Map<String,Date> getRangeDates(String range) {
        Map<String, CalendarPeriod> sel = DealUtils.getCustomCalendarPeriods(dates);
        CalendarPeriod val = sel.get(range);
        if (val != null && val.setDates()) {
            return new Map<String,Date>{'from' => val.weekStart, 'to' => val.weekEnd};
        }
        return null;
    }

    private static List<Schedules__c> handleHiatus(Date startDate, Date endDate, String startTime, String endTime, Id dealId, String index, Map<String,String> errors) {
        List<Schedules__c> hiatusSchedules = new List<Schedules__c>();

        if(startDate == null) {
            errors.put(index, 'Must at least fill in a Start Date for the Hiatus');
        } else if (startDate < Date.today().toStartOfWeek().addDays(1)) {
            errors.put(index, 'Cannot be updated for past weeks');
        } else if(endDate != null && endDate < startDate) {
            errors.put(index, 'Hiatus End Date must come after Hiatus Start Date');
        } else {
            // Query for all schedules on the deal, using the reconciled flag
            String query = 'SELECT ' + SaberGF.GetObjectsFieldsForQueries('Schedules__c')
                    + ' FROM Schedules__c WHERE Deal_Parent__c = \'' + dealId + '\'';

            if (endDate != null) {
                hiatusSchedules = ScheduleHiatus.hiatusDateRange(Database.query(query), startDate, endDate);
            } else if (endTime != null) {
                hiatusSchedules = ScheduleHiatus.hiatusTimeAfter(Database.query(query), startDate, endTime);
            } else if (startTime != null) {
                hiatusSchedules = ScheduleHiatus.hiatusTimeBefore(Database.query(query), startDate, startTime);
            } else {
                hiatusSchedules = ScheduleHiatus.hiatusSingleDay(Database.query(query), startDate);
            }
        }
        return hiatusSchedules;
    }

    private static List<Schedules__c> handleExtend(Schedules__c CloneSchedule, ScheduleGroup scheduleGroup, Date endOfQuarter) {
        List<Schedules__c> result = new List<Schedules__c>();
        for (Date StartDate = CloneSchedule.Week__c.addDays(7); StartDate <= scheduleGroup.week && StartDate <= endOfQuarter; StartDate = StartDate.addDays(7)) {
            SObject NewScheduleObj = (SObject)(CloneSchedule).clone(false, false, false);
            Schedules__c NewSCHRecord = (Schedules__c)(NewScheduleObj);
            NewSCHRecord.Total_Schedules__c  = '0';
            NewSCHRecord.SI_Number_if_Billed__c = null;
            NewSCHRecord.Reviewed_for_Invoicing__c = false;
            NewSCHRecord.Intacct_SI_Number__c = null;
            NewSCHRecord.Units_Preempted__c = null;
            NewSCHRecord.Status__c = 'Sold';
            NewSCHRecord.ISCI_CODE__c = null;
            NewSCHRecord.X800_Number__c = null;
            NewSCHRecord.Days_of_Air__c = null;
            NewSCHRecord.Pod__c = null;
            NewSCHRecord.LF_traffic__c = null;
            NewSCHRecord.Comments__c = null;
            NewSCHRecord.Error_Cost__c = null;
            NewSCHRecord.Error_Logged_To__c = null;
            NewSCHRecord.Error_Reason__c = null;
            NewSCHRecord.Discrepancy_Comment__c = null;
            NewSCHRecord.Week__c = StartDate;
            NewSCHRecord.Duplicate_Check__c= null;
            NewSCHRecord.TEST__c = false;
            result.add(NewSCHRecord);
        }
        return result;
    }
}