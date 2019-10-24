@isTest
private class creteClonesTest
{
	static testMethod void testBatch() {
	    Test.startTest();

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

	    Deal__c dealRecord=new Deal__c(Campaign__c='Test', Contact__c = con.Id, Brands__c = brand.Id);
	    insert dealRecord;
	    Schedules__c schedule=new Schedules__c(Deal_Parent__c=dealRecord.id, Units_Available__c=1, Total_Schedules__c='5',Week__c=date.parse('12/07/2009'),Rate__c=5);
	    insert  schedule;
	    Test.stopTest();
	} 
}