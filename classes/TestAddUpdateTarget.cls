/*
    Name        : TestAfterInsertUpdateDeal
    Description : It is a test class for "AfterInsertUpdateDeal" Trigger
*/
@isTest
public class TestAddUpdateTarget{
    @isTest
    public static void test(){
        //Creating new Programs__c
        /**Programs__c newProgram = new Programs__c(name='XX',ClientCode__c='xx');
        insert newProgram;
        //Creating new Advertiser__c
        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;

        Contact con = new Contact(LastName = 'Test') ;
        insert con ;

        //Creating new Dealobject
        Deal__c newDeal = new Deal__c(Program__c=newProgram.id,Brands__c=brand.id,Status__c='Historical',PI__c=false, Contact__c = con.Id);
        insert newDeal;
        upsert newDeal;
        List<Targets__c> lstTargets = [select id,Target_Name__c from targets__c 
                                        where Target_Name__c=:(newProgram.name+'-'+brand.name)];
        //System.assert(lstTargets.size()>0,'Didnot find corresponding Target');
	**/
    }
}