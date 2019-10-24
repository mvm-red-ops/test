@isTest
public class TestDealSearchController{
    @isTest
    public static void testClass(){

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
                
        Programs__c program = new Programs__c();
        program.Name='testProgram';
        program.ClientCode__c='123';
        insert program;
        
        Account acc = new Account();
        acc.Name='test';
        insert acc;
        
        Contact con = new Contact(Email = 'test@test.com', Phone = '8001234567');
        con.LastName = 'testCon';
        con.Accountid = acc.id;
        insert con ;
        
        Deal__c deal = new Deal__c();
        deal.Program__c = program.id;
        deal.Client_Account__c = acc.id;
        deal.Contact__c = con.id;
        deal.Brands__c = brand.id;
        insert deal;
        
        DealSearchController dc = new DealSearchController();
        dc.deal.Program__c=program.id;
        dc.deal.Client_Account__c=acc.id;
        dc.deal.Brands__c = brand.id;
        dc.deal.Contact__c = con.id;
        dc.schedule.Deal_Parent__c = deal.id;
        dc.search();
        
        
    }
}