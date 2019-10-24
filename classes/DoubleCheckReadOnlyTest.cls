@IsTest
private class DoubleCheckReadOnlyTest {
    @IsTest static void DoubleCheckReadOnly_Test() {
        Date constDate = Date.today().toStartOfWeek().addDays(1);

        Contact con = new Contact(
                LastName = 'Test',
                Email = 'test@test.com',
                Phone = '8001234567'
        );
        insert con;

        Advertiser__c advertiser = new Advertiser__c(
                Duplicate_Approval__c = 'Approved',
                Advertiser_Approved_to_Book__c = true
        );
        insert advertiser;

        Brands__c brand = new Brands__c(
                Name = 'Availability',
                Category__c = 'Other',
                Advertiser__c = advertiser.Id,
                Approved_Duplicate__c = 'Approved'
        );
        insert brand;

        //Program
        Programs__c program = new Programs__c(
                Name = 'BounceTV',
                Cable_Synd__c = 'Cable',
                ClientCode__c = 'h1',
                Barter__c = true,
                Station_Call_Letter__c = 'a',
                Prelog_Version__c = 5
        );
        insert program;

        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Program__c = program.Id,
                Length__c = '5'
        );
        insert deal;

        //Schedule
        Schedules__c schedule = new Schedules__c(
                Units_Available__c = 1.0,
                Units_Preempted__c = 0,
                Week__c = constDate,
                Deal_Parent__c = deal.Id,
                Status__c = 'Sold',
                Rate__c = 300
        );
        insert schedule;

        PrelogData__c pdata = new PrelogData__c(
                Schedule__c = schedule.Id,
                AirDate__c = constDate,
                Version__c = 5
        );
        insert pdata;

        deal = [
                SELECT Id,
                (SELECT Id, Deal_Parent__c, OrderLineNumber__c, Total_Dollars__c FROM Schedules__r),
                        Contact__c,
                        Brands__c,
                        Program__c,
                        Length__c
                FROM Deal__c
                WHERE Id = :deal.Id
                LIMIT 1
        ];


        DoubleCheckReadOnly dc = new DoubleCheckReadOnly();
        dc.Searchfield = '  grittv  ,  marci  ';
        dc.DoSearch();
        dc.Searchfield = 'grittv';
        dc.DoSearch() ;
        dc.SortDealResultList() ;
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton();

        dc.DealId = deal.Id;
        dc.DealWrapperIdSet.clear();
        dc.AddMoreToDeal();
    }

    @IsTest
    private static void DoubleCheckReadOnly_SOQLDate() {
        DoubleCheckReadOnly dc = new DoubleCheckReadOnly();
        dc.dates = new DateSelector(Date.newInstance(2019, 1, 31));
        dc.SelectedDateLiteral = null;
        dc.ReturnSOQLDateString();
        System.assertEquals('', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Custom';
        dc.ReturnSOQLDateString();
        System.assertEquals('', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous FY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-01-01 AND Week_MIN_Field__c <= 2018-12-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Custom';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-01-01 AND Week_MIN_Field__c <= 2018-12-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2016-12-26 AND Week_MIN_Field__c <= 2018-12-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2016-12-26 AND Week_MIN_Field__c <= 2017-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-12-29 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-01-01 AND Week_MIN_Field__c <= 2019-12-29 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2016-12-26 AND Week_MIN_Field__c <= 2019-12-29 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-06-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-10-01 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-04-01 AND Week_MIN_Field__c <= 2019-06-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-10-01 AND Week_MIN_Field__c <= 2018-12-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-12-29 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-01-27 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-28 AND Week_MIN_Field__c <= 2019-02-24 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-02-25 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-31 AND Week_MIN_Field__c <= 2019-02-24 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-28 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-21 AND Week_MIN_Field__c <= 2019-01-27 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-28 AND Week_MIN_Field__c <= 2019-02-03 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-02-04 AND Week_MIN_Field__c <= 2019-02-10 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-01-01 AND Week_MIN_Field__c <= 2018-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2017-01-01 AND Week_MIN_Field__c <= 2018-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2017-01-01 AND Week_MIN_Field__c <= 2017-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2020-01-01 AND Week_MIN_Field__c <= 2020-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-01-01 AND Week_MIN_Field__c <= 2019-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2017-01-01 AND Week_MIN_Field__c <= 2019-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2020-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-06-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-10-01 AND Week_MIN_Field__c <= 2019-03-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-04-01 AND Week_MIN_Field__c <= 2019-06-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-10-01 AND Week_MIN_Field__c <= 2018-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-01 AND Week_MIN_Field__c <= 2018-12-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'This Month';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-02-01 AND Week_MIN_Field__c <= 2019-02-28 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-01 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-02-28 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-20 AND Week_MIN_Field__c <= 2019-01-26 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-27 AND Week_MIN_Field__c <= 2019-02-02 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-02-03 AND Week_MIN_Field__c <= 2019-02-09 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-30 AND Week_MIN_Field__c <= 2019-01-30 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-02-01 AND Week_MIN_Field__c <= 2019-02-01 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-24 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-01 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-12-02 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-11-02 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2018-10-03 AND Week_MIN_Field__c <= 2019-01-31 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-02-07 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-03-02 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-04-01 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-05-01 ) ', dc.SOQLDateString);
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString();
        System.assertEquals(' AND ( Week_MIN_Field__c >= 2019-01-31 AND Week_MIN_Field__c <= 2019-05-31 ) ', dc.SOQLDateString);
    }

    @IsTest
    private static void DoubleCheckReadOnly_coverage() {
        DoubleCheckReadOnly dc = new DoubleCheckReadOnly();
        DoubleCheckReadOnly.setDealSelector(null);
        DoubleCheckReadOnly.setScheduleSelector(null);
        dc.Display();
    }

    private static Account createAccount() {
        Account testAcct = new Account();
        testAcct.Name = 'Test Account';
        return testAcct;
    }

    private static Contact createContact(Account testAcct) {
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Name';
        contact.Email = 'test@testemail.com';
        contact.Phone = '(758) 771-0091';
        contact.Account = testAcct;
        return contact;
    }

    static Deal__c createDeal(Contact testContact, String dealNumber) {
        Deal__c testDeal = new Deal__c();
        testDeal.Contact__c = testContact.Id;
        testDeal.Network_Deal_Number__c = dealNumber;
        testDeal.length__c = '5';
        return testDeal;
    }

    private static Schedules__c createSchedule(Deal__c testDeal) {

        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = testDeal.Id;
        schedule.Week__c = Date.newInstance(2019, 1, 7);
        schedule.Days_Allowed__c = 'Mon';
        schedule.Start_Time__c = '06:00A';
        schedule.End_Time__c = '06:30A';
        schedule.Rate__c = 100;
        schedule.Units_Available__c = 5;
        return schedule;
    }

    private static PrelogData__c createPrelogDataRecord(Id scheduleId, PrelogDataMirror__c rec) {
        PrelogData__c PrelogDataRec = new PrelogData__c();
        PrelogDataRec.AdvertiserProduct__c = rec.AdvertiserProduct__c;
        PrelogDataRec.Agency__c = rec.Agency__c;
        PrelogDataRec.AirDate__c = rec.AirDate__c;
        PrelogDataRec.BreakCode__c = rec.BreakCode__c;
        PrelogDataRec.MaterialDescription__c = rec.MaterialDescription__c;
        PrelogDataRec.OrderProductDescription__c = rec.OrderProductDescription__c;
        PrelogDataRec.PrelogDataMirror__c = rec.Id;
        PrelogDataRec.Rate__c = rec.Rate__c;
        PrelogDataRec.Commercial_Type__c = rec.Commercial_Type__c;
        PrelogDataRec.Schedule__c = scheduleId;
        PrelogDataRec.ScheduleAdID__c = rec.ScheduleAdID__c;
        PrelogDataRec.ScheduleLength__c = rec.ScheduleLength__c;
        PrelogDataRec.ScheduleTime__c = rec.ScheduleTime__c;
        PrelogDataRec.TimePeriod__c = rec.TimePeriod__c;
        PrelogDataRec.Version__c = rec.Version__c;
        PrelogDataRec.AirDate__c = Date.newInstance(2019, 2, 3);
        return PrelogDataRec;
    }

    private static PrelogDataMirror__c createPrelogDataMirror(String dealNumber) {
        Integer rate = 100;
        PrelogDataMirror__c mirror = new PrelogDataMirror__c();
        mirror.NetworkDealNumber__c = dealNumber;
        mirror.Network__c = 'test';
        mirror.ScheduleLength__c = '1';
        mirror.AirDate__c = Date.newInstance(2019, 1, 7);
        mirror.ScheduleTime__c = '6:00:00AM';
        mirror.Rate__c = rate;
        mirror.Version__c = 1;
        return mirror;
    }

    private static Programs__c createProgram(String dealNumber) {
        Programs__c program = new Programs__c();
        program.Name = 'testNetwork';
        program.Cable_Synd__c = 'Cable';
        program.Station_Call_Letter__c = Utils.generateRandomCallsign();
        program.ClientCode__c = dealNumber;
        program.Clock_Start_Time__c = '';
        program.Reconciled_Week__c = Date.today().toStartOfWeek().addDays(-6);
        program.Prelog_Version__c = 1;
        return program;
    }

    private static Advertiser__c createAdvertiser() {
        return new Advertiser__c(Duplicate_Approval__c = 'Approved');
    }

    private static Brands__c createBrand(Advertiser__c advertiser) {
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.Id;
        brand.Approved_Duplicate__c = 'Approved';
        return brand;
    }
}