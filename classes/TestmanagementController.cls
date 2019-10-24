@isTest
public class TestmanagementController{
    @isTest
    public static void TestClass(){

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

        Deal__c d = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id);
        insert d;
        Schedules__c sch = new Schedules__c();
        sch.Deal_Parent__c = d.id;
        sch.Rate__c = 100;
        sch.Units_Preempted__c = 1;
        sch.Units_Available__c = 1;
        insert sch;
        managementController m = new managementController ();
        m.search();
        m.refresh();
        m.oneWeekLater();
        m.oneWeekBack();
        m.newSearch();
        m.save();
        
    }
}