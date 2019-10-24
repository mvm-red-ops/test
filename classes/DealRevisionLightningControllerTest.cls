@IsTest
public with sharing class DealRevisionLightningControllerTest {

    @IsTest
    public static void GetEndOfQuarter_Success() {
        Schedules__c schedule = TestDataFactory.schedule(true);
        Deal__c deal = [SELECT Id, Week_MIN_Field__c FROM Deal__c LIMIT 1];

        DealRevisionLightningController.ScheduleGroup scheduleGroup = new DealRevisionLightningController.ScheduleGroup();
        scheduleGroup.schedules = new Schedules__c[]{schedule};

        Date endOfQuarter = DealRevisionLightningController.getEndOfQuarter(deal, new DealRevisionLightningController.ScheduleGroup[]{
            scheduleGroup
        });


        DealRevisionController drc = new DealRevisionController();
        drc.dealSelector = new DealTestSelector();
        DealQueryExtension dqe = drc.dealQueryExt;
        DealUpdateExtension due = drc.dealUpdateExt;

        drc.searchString = 'a';
        drc.dateRangeDrop = 'Previous FY';
        drc.UpdateDateField();
        drc.SearchDeals();

        dqe.selectedDealId = deal.Id;
        dqe.selectDeal();

        due.selectedDeal = deal;
        due.SearchforSchedules();

        deal = new Deal__c();

        System.assertEquals(due.QuarterEndDate, endOfQuarter);
        System.assertNotEquals(null, endOfQuarter);
        System.debug(endOfQuarter);
    }

    public static DealRevisionLightningController.ScheduleGroup beginTestUpdateSchedules(String selectedTab) {
        Deal__c deal = TestDataFactory.deal(true);

        DealRevisionLightningController.ScheduleGroup scheduleGroup = new DealRevisionLightningController.ScheduleGroup();
        scheduleGroup.index = '0';
        scheduleGroup.rate = 1.00;
        scheduleGroup.week = Date.today().toStartOfWeek().addDays(1);
        scheduleGroup.unitsAvailable = 1;
        scheduleGroup.cap = 'Uncapped';
        scheduleGroup.networks = 'networks';
        scheduleGroup.daypart = '1';
        scheduleGroup.startTime = '9:00AM';
        scheduleGroup.endTime = '10:00PM';
        scheduleGroup.daysAllowed = '-TWTF--';
        scheduleGroup.maxPerDay = 1.00;
        scheduleGroup.schedules = new Schedules__c[]{
                TestDataFactory.schedule(deal.Id, false),
                TestDataFactory.schedule(deal.Id, false)
        };

        Schedules__c schedule = scheduleGroup.schedules[0];
        schedule.Week__c = Date.today().toStartOfWeek().addDays(8);
        schedule.Rate__c = scheduleGroup.rate;
        schedule.Units_Available__c = scheduleGroup.unitsAvailable;
        schedule.Cap__c = scheduleGroup.cap;
        schedule.Networks__c = scheduleGroup.networks;
        schedule.MGM_HD_Daypart__c = scheduleGroup.daypart;
        schedule.Start_Time__c = scheduleGroup.startTime;
        schedule.End_Time__c = scheduleGroup.endTime;
        schedule.Days_Allowed__c = scheduleGroup.daysAllowed;
        schedule.Max_Per_Day__c = scheduleGroup.maxPerDay;

        insert scheduleGroup.schedules;

        String result = DealRevisionLightningController.updateSchedules(
                deal,
                new DealRevisionLightningController.ScheduleGroup[]{
                        scheduleGroup
                },
                selectedTab
        );

        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(true, resultMap.get('success'));

        return scheduleGroup;
    }

    public static Map<String, String> getScheduleFieldsMap() {
        return new Map<String, String>{
                'Original_Rate__c' => 'Rate__c',
                'Original_Daypart__c' => 'MGM_HD_Daypart__c',
                'Original_Days_Allowed__c' => 'Days_allowed__c',
                'Original_Units_Available__c' => 'Units_Available__c',
                'Original_Cap__c' => 'Cap__c',
                'Original_Max_Per_Day__c' => 'Max_Per_Day__c'
        };
    }

    public static Mass_Deal_Change__c testUpdate(Map<String, String> scheduleFieldsMap, Map<String, String> groupFieldsMap,
            DealRevisionLightningController.ScheduleGroup scheduleGroup) {
        List<String> fields = new List<String>(scheduleFieldsMap.keySet());
        fields.addAll(new List<String>(groupFieldsMap.keySet()));

        String query = 'SELECT ' + String.join(fields, ', ') + ' FROM Mass_Deal_Change__c';

        List<Mass_Deal_Change__c> changes = Database.query(query);

        System.assertEquals(1, changes.size());

        Mass_Deal_Change__c change = changes[0];
        Schedules__c schedule = scheduleGroup.schedules[0];

        for (String changeField : scheduleFieldsMap.keySet()) {
            String scheduleField = scheduleFieldsMap.get(changeField);
            System.assertEquals(schedule.get(scheduleField), change.get(changeField),
                    'Data from schedule "' + scheduleField + '" was not copied to change "' + changeField + '"');
        }

        Map<String, Object> scheduleGroupFields = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(scheduleGroup));

        for (String changeField : groupFieldsMap.keySet()) {
            String groupField = groupFieldsMap.get(changeField);
            System.assertEquals(scheduleGroupFields.get(groupField), change.get(changeField),
                    'Data from schedule group "' + groupField + '" was not copied to change "' + changeField + '"');
        }

        return change;
    }

    @IsTest
    public static void UpdateSchedules_LTC_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('LTC');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();
        scheduleFieldsMap.put('Week_Start__c', 'Week__c');

        Map<String, String> groupFieldsMap = new Map<String, String>();

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        Schedules__c updatedSchedule = [
                SELECT Id, Status__c FROM Schedules__c WHERE Id = :scheduleGroup.schedules[0].Id
        ];

        System.assertEquals('Canceled', updatedSchedule.Status__c);
    }

    @IsTest
    public static void UpdateSchedules_Rate_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Rate');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>{
            'Changed_Rate__c' => 'rate'
        };

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        for (Schedules__c schedule : scheduleGroup.schedules) {
            System.assertEquals(scheduleGroup.rate, schedule.Rate__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_Frequency_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Frequency');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>{
                'Changed_Units_Available__c' => 'unitsAvailable'
        };

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        for (Schedules__c schedule : scheduleGroup.schedules) {
            System.assertEquals(scheduleGroup.unitsAvailable, schedule.Units_Available__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_Test_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Test');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>();

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        for (Schedules__c schedule : scheduleGroup.schedules) {
            System.assertEquals(true, schedule.TEST__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_Cap_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Cap');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>{
                'Changed_Cap__c' => 'cap'
        };

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        for (Schedules__c schedule : scheduleGroup.schedules) {
            System.assertEquals(scheduleGroup.cap, schedule.Cap__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_Daypart_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Daypart');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>{
                'Changed_Daypart__c' => 'daypart',
                'Changed_Days_Allowed__c' => 'daysAllowed'
        };

        Mass_Deal_Change__c change = testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);
        change = [SELECT Id, Changed_Start_End_Time__c FROM Mass_Deal_Change__c WHERE Id = :change.Id];

        System.assertEquals(scheduleGroup.startTime + '-' + scheduleGroup.endTime, change.Changed_Start_End_Time__c);

        List<Id> scheduleIds = new List<Id>();
        for (Schedules__c schedule : scheduleGroup.schedules) {
            scheduleIds.add(schedule.Id);
        }
        List<Schedules__c> schedules = [
            SELECT Id, Networks__c, MGM_HD_Daypart__c, Start_Time__c, End_Time__c, Days_Allowed__c
            FROM Schedules__c
            WHERE Id IN :scheduleIds
        ];

        for (Schedules__c schedule : schedules) {
            System.assertEquals(scheduleGroup.networks, schedule.Networks__c);
            System.assertEquals(scheduleGroup.daypart, schedule.MGM_HD_Daypart__c);
            System.assertEquals(scheduleGroup.startTime, schedule.Start_Time__c);
            System.assertEquals(scheduleGroup.endTime, schedule.End_Time__c);
            System.assertEquals(scheduleGroup.daysAllowed, schedule.Days_Allowed__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_Max_Success() {
        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules('Max');

        Map<String, String> scheduleFieldsMap = getScheduleFieldsMap();

        Map<String, String> groupFieldsMap = new Map<String, String>{
                'Changed_Max_Per_Day__c' => 'maxPerDay'
        };

        testUpdate(scheduleFieldsMap, groupFieldsMap, scheduleGroup);

        for (Schedules__c schedule : scheduleGroup.schedules) {
            System.assertEquals(scheduleGroup.maxPerDay, schedule.Max_Per_Day__c);
        }
    }

    @IsTest
    public static void UpdateSchedules_LTC_Failure() {
        String selectedTab = 'LTC';

        DealRevisionLightningController.ScheduleGroup scheduleGroup =
                beginTestUpdateSchedules(selectedTab);

        Deal__c deal = [SELECT Id FROM Deal__c];
        DealRevisionLightningController.ScheduleGroup[] groups = new DealRevisionLightningController.ScheduleGroup[]{scheduleGroup};

        // Test dates in the past
        scheduleGroup.week = scheduleGroup.week.addDays(-27);
        String result = DealRevisionLightningController.updateSchedules(deal, groups, selectedTab);

        Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(false, resultMap.get('success'));

        // Test non-monday dates
        scheduleGroup.week = scheduleGroup.week.addDays(28);
        result = DealRevisionLightningController.updateSchedules(deal, groups, selectedTab);

        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(false, resultMap.get('success'));

        // Test dates past the end of the quarter
        scheduleGroup.week = scheduleGroup.week.addYears(1);
        result = DealRevisionLightningController.updateSchedules(deal, groups, selectedTab);

        resultMap = (Map<String, Object>) JSON.deserializeUntyped(result);
        System.assertEquals(false, resultMap.get('success'));
    }
}