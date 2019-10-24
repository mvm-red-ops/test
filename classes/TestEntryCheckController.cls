@isTest
private class TestEntryCheckController {
    @isTest
    private static void testClass() {
        Account acc = new Account();
        acc.name = 'test';
        insert acc;

        Contact con = new Contact(Email = 'test@test.com', Phone = '8001234567');
        con.LastName = 'test';
        con.Account = acc;
        insert con;

        Programs__c program = new Programs__c();
        program.Name = 'DOC PP';
        program.ClientCode__c = 'ZZ';
        insert program;

        Advertiser__c advertiser = new Advertiser__c(Account__c = acc.Id, Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
        insert advertiser;

        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;

        Deal__c deal = new Deal__c();
        deal.Program__c = program.Id;
        deal.Contact__c = con.id;
        deal.Brands__c = brand.Id;
        deal.Length__c = '30' ;
        //deal.Status__c = 'Canceled';
        deal.RecordTypeId = getRecordTypeId('Short Form', 'Deal__c');
        insert deal;

        List<RecordType> schRecType = [select id from RecordType where name = 'Paid Programming' and SObjectType = 'Schedules__c'];
        Schedules__c schedule = new Schedules__c();
        if (schRecType.size() > 0) {
            schedule.recordTypeId = schRecType.get(0).id;
        }
        schedule.Deal_Parent__c = deal.Id;
        schedule.Rate__c = 100;
        schedule.Week__c = date.newInstance(2013, 1, 14);
        schedule.status__c = 'Sold';
        schedule.Units_Available__c = 1;
        schedule.Units_Preempted__c = 0;
        //schedule.Units_Aired__c =1;
        insert schedule;
        schedule = [select COUNTMENOT__c from Schedules__c where id = :schedule.id];

        System.Debug(' ####### = countme    ' + schedule.COUNTMENOT__c);
        ApexPages.currentPage().getParameters().put('sid', schedule.id);
        EntryCheckController doc = new EntryCheckController();
        doc.deal.Program__c = program.id;
        doc.sWeek = string.valueof(date.newinstance(2013, 1, 14));
        System.Debug('#######DOCSchedule Id is ===>' + doc.sDate);

        /*doc.sDtY=0;
        doc.sDtM=0;
        doc.sDtD=0;
    
        doc.eDtY=0;
        doc.eDtM=0;
        doc.eDtD=0;
        doc.fYear=0;
        doc.fMonth=0;
        
        doc.activeFilter=0;
*/
        doc.months = system.today().month() + '-' + system.today().year();
        //doc.searchMonth();
        //doc.applyFilter();
        doc.sDate = new Schedules__c(Week__c = date.newInstance(2013, 4, 15));
        doc.eDate = new Schedules__c(Week__c = date.newInstance(2013, 4, 19));
        doc.search();
        doc.getMonth();
        doc.getOptions();
        doc.sid = schedule.Id;

        string year = '2013';
        string month = '4';
        string day = '15';
        //could cause test to fail 
        //String.valueOF(system.today().Year()+'-'+system.today().Month()+'-'+system.today().Day());
        doc.sWeek = year + '-' + month + '-' + day;
        doc.slf = 'A-7:00';
        doc.cancel();

        doc.con.AccountId = acc.id;
        doc.showReport();
        doc.oneWeekLater();
        doc.oneWeekBack();
        doc.save();
        doc.checkAll();
        doc.createChangeLog();
        doc.sch = schedule.id;

        doc.replaceSchedule();
        doc.replace();
    }

    private static Id getRecordTypeId(String rtName, String SObjectType) {
        return [SELECT Id FROM RecordType WHERE Name = :rtName AND SObjectType = :SObjectType].Id;
    }
}