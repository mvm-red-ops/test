@isTest
public class DOCEntryCheckControllerTest{
    @isTest
    private static void testClass(){
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

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
         
        Deal__c deal = new Deal__c(Contact__c = con.Id);
        deal.Program__c = program.Id;
        deal.Length__c = '30' ;
        //deal.Status__c = 'Canceled';
        deal.RecordTypeId = getRecordTypeId('Short Form', 'Deal__c');
        deal.Brands__c = brand.Id ;
        
        insert deal;
        
        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = deal.Id;
        schedule.Rate__c = 100;
        schedule.Week__c = date.newInstance(2011,9,5);
        schedule.status__c = 'Sold';
        schedule.Units_Available__c = 1;
        schedule.Units_Preempted__c = 0;
        //schedule.Units_Aired__c =1;
        insert schedule;
        schedule = [select COUNTMENOT__c from Schedules__c where id =: schedule.id];
        
        System.Debug(' ####### = countme	'+schedule.COUNTMENOT__c);
        ApexPages.currentPage().getParameters().put('sid',schedule.id);
        DOCEntryCheckController doc = new DOCEntryCheckController();        
        System.Debug('#######DOCSchedule Id is ===>'+doc.sDate);
        
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
        doc.searchMonth();
/*      doc.sdate=new Schedules__c();
        doc.edate=new Schedules__c();
*/        //doc.applyFilter();
        doc.sDate = new Schedules__c(Week__c = date.newInstance(2011,9,1)); 
        doc.eDate = new Schedules__c(Week__c = date.newInstance(2011,9,10));
        doc.cancel ();
        doc.showReport();
    }
    
    private static Id getRecordTypeId(String rtName, String SObjectType){
        return [SELECT Id FROM RecordType WHERE Name =: rtName AND SObjectType =: SObjectType].Id;
    }
}