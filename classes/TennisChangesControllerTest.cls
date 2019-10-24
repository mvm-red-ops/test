@isTest
public class TennisChangesControllerTest {
    @isTest
    private static void testClass(){
        Programs__c program = new Programs__c();
        program.Name = 'Test PP TT';
        program.ClientCode__c = 'ZZ';
        insert program;

        Contact con = new Contact(LastName = 'Test', Email = 'test@test.com', Phone = '8001234567') ;
        insert con ;

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
        deal.RecordTypeId = getRecordTypeId('Short Form', 'Deal__c');
        deal.Length__c = '30' ;
        deal.Brands__c = brand.Id ;
        insert deal;
        
        Schedules__c schedule = new Schedules__c();
        schedule.Deal_Parent__c = deal.Id;
        schedule.Rate__c = 100;
        schedule.Week__c = date.newInstance(2011, 22, 8);
        schedule.Units_Available__c = 1;
        insert schedule;
        
        TennisChangesController tcc = new TennisChangesController();
        tcc.months = system.today().month() + '-' + system.today().year();
        tcc.searchMonth();
        
    }
    
    private static Id getRecordTypeId(String rtName, String SObjectType){
        return [SELECT Id FROM RecordType WHERE Name =: rtName AND SObjectType =: SObjectType].Id;
    }
}