@IsTest
public class PrelogWeekBatchTests {

    @IsTest
    private static void testPrelogWeekBatch() {
        Schedules__c testSchedule = createSchedule('123', 'AntennaTV', 'Mon');
        createPrelogData(testSchedule.Id);

        Test.startTest();
        Date endDate = Date.today().toStartOfWeek();
        Date startDate = endDate.addDays(-6);
        PrelogWeekBatch.run(startDate, endDate);
        Test.stopTest();

        List<Prelog_Week__c> prelogWeeks = getAllPrelogWeeksByDaypart('2-DT 9a-6p');
        System.assertEquals(1, prelogWeeks.size());
        System.assertEquals(600.00, prelogWeeks[0].Rate_Sum__c);
        System.assertEquals(4, prelogWeeks[0].Equiv_30_Sum__c);

        prelogWeeks = getAllPrelogWeeksByDaypart('4-PR 6-12a');
        System.assertEquals(1, prelogWeeks.size());
        System.assertEquals(300.00, prelogWeeks[0].Rate_Sum__c);
        System.assertEquals(6, prelogWeeks[0].Equiv_30_Sum__c);
    }

    @IsTest
    private static void testPrelogWeekBatchSpecifiedProgramName() {
        Schedules__c testSchedule = createSchedule('123', 'AntennaTV', 'Mon');
        createPrelogData(testSchedule.Id);

        Test.startTest();
        Date endDate = Date.today().toStartOfWeek();
        Date startDate = endDate.addDays(-6);
        Programs__c program = [SELECT Id
                                FROM Programs__c
                                WHERE Name = 'AntennaTV'
                                LIMIT 1];
        PrelogWeekBatch.run(startDate, endDate, new Set<String>{program.Id});
        Test.stopTest();

        List<Prelog_Week__c> prelogWeeks = getAllPrelogWeeksByDaypart('2-DT 9a-6p');
        System.assertEquals(1, prelogWeeks.size());
        System.assertEquals(600.00, prelogWeeks[0].Rate_Sum__c);
        System.assertEquals(4, prelogWeeks[0].Equiv_30_Sum__c);

        prelogWeeks = getAllPrelogWeeksByDaypart('4-PR 6-12a');
        System.assertEquals(1, prelogWeeks.size());
        System.assertEquals(300.00, prelogWeeks[0].Rate_Sum__c);
        System.assertEquals(6, prelogWeeks[0].Equiv_30_Sum__c);
    }

    @IsTest
    private static void testCleanDuplicates() {
        Schedules__c testSchedule = createSchedule('123', 'AntennaTV', 'Mon');
        createPrelogData(testSchedule.Id);

        Programs__c program = [SELECT Id
                               FROM Programs__c
                               WHERE Name = 'AntennaTV'
                               LIMIT 1];
        Prelog_Week__c pw =  new Prelog_Week__c(
                Program__c = program.Id,
                Commercial_Type__c = 'DR',
                Week__c = Date.today().toStartOfWeek().addDays(-6),
                Daypart__c = '2-DT 9a-6p',
                Version__c = 6,
                Rate_Sum__c = 100.00,
                Equiv_30_Sum__c = 20
        );
        insert pw;

        Test.startTest();
        Date endDate = Date.today().toStartOfWeek();
        Date startDate = endDate.addDays(-6);
        PrelogWeekBatch.run(startDate, endDate);
        Test.stopTest();

        Prelog_Week__c prelogWeek = [SELECT Id, Rate_Sum__c
                                      FROM Prelog_Week__c
                                      WHERE Id = :pw.Id];
        System.assertEquals(600.00, prelogWeek.Rate_Sum__c);
    }

    private static Schedules__c createSchedule(String dealNumber, String programName, String airDate ) {
        Account testAcct = new Account();
        testAcct.Name = 'PrelogDataMirror Test';
        testAcct.BillingCity = 'Wakarusa';
        insert testAcct;

        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Name';
        contact.Email = 'test@testemail.com';
        contact.Phone = '(758) 771-0091';
        contact.Account = testAcct;
        insert contact;

        Programs__c program = new Programs__c();
        program.Name = programName;
        program.Cable_Synd__c = 'Cable';
        program.Station_Call_Letter__c = 'AWED';
        program.ClientCode__c = dealNumber;
        program.Clock_Start_Time__c = '7AM';
        insert program;

        Advertiser__c advertiser = new Advertiser__c(
            Name = Utils.randomString(10),
            Duplicate_Approval__c = 'Approved',
            Advertiser_Approved_to_Book__c = true,
            Commercial__c = 'DR'
        );
        insert advertiser;

        Brands__c brand = new Brands__c(
            Name = 'Availability',
            Advertiser__c = advertiser.Id,
            Approved_Duplicate__c = 'Approved',
            Category__c = 'Other'
        );
        insert brand;

        Deal__c testDeal = new Deal__c(
            Program__c = program.Id,
            Brands__c = brand.Id,
            Contact__c = contact.Id,
            Network_Deal_Number__c = dealNumber,
            Length__c = '1'
        );
        insert testDeal;

        Schedules__c schedule = new Schedules__c();
        schedule.Week__c = Date.today().toStartOfWeek().addDays(-6);
        schedule.Units_Available__c = 5;
        schedule.Deal_Parent__c = testDeal.Id;
        schedule.Days_Allowed__c = airDate;
        schedule.Start_Time__c = '09:00A';
        schedule.End_Time__c = '09:30A';
        schedule.Rate__c = 100;
        schedule.Units_Available__c = 5;
        insert schedule;
        return [
                SELECT Id, Week__c, Deal_Parent__c, Deal_Parent__r.Network_Deal_Number__c,
                        Days_Allowed__c, Start_Time__c, End_Time__c, Rate__c, Units_Available__c
                FROM Schedules__c
                WHERE Id =: schedule.Id
        ];
    }

    private static List<PrelogData__c> createPrelogData(String scheduleId){
        List<PrelogData__c> prelogs = new List<PrelogData__c> {
            new PrelogData__c(
                Schedule__c = scheduleId,
                Version__c = 6,
                ScheduleTime__c='11:57:01 AM',
                Rate__c = 300.00,
                ScheduleLength__c = '60'
            ),
            new PrelogData__c(
                    Schedule__c = scheduleId,
                    Version__c = 6,
                    ScheduleTime__c='12:57:01 PM',
                    Rate__c = 300.00,
                    ScheduleLength__c = '60'
            ),
            new PrelogData__c(
                    Schedule__c = scheduleId,
                    Version__c = 6,
                    ScheduleTime__c='9:57:01 PM',
                    Rate__c = 150.00,
                    ScheduleLength__c = '90'
            ),
            new PrelogData__c(
                    Schedule__c = scheduleId,
                    Version__c = 6,
                    ScheduleTime__c='10:57:01 PM',
                    Rate__c = 150.00,
                    ScheduleLength__c = '90'
            )
        };

        insert prelogs;
        return prelogs;
    }

    private static List<Prelog_Week__c>  getAllPrelogWeeksByDaypart(String daypart){
        return [
                SELECT Id, Week__c, Rate_Sum__c, Equiv_30_Sum__c
                FROM Prelog_Week__c
                WHERE Daypart__c = :daypart
        ];
    }

}