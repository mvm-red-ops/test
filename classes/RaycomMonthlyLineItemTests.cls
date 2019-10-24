@isTest
public class RaycomMonthlyLineItemTests {
	
    @testSetup
    public static void setup() {
        
        Contact con = new Contact(
        	FirstName = 'TEST',
            LastName = 'TEST',
            Email = 'test@test.com',
            Phone = '5555551212'
        );
        insert con;
        
        Deal__c deal = new Deal__c(
        	Contact__c = con.Id,
            Status__c = 'Historical'
        );
        insert deal;
        
        Schedules__c sch = new Schedules__c(
        	Week__c = Date.newInstance(2017,1,2),
            Deal_Parent__c = deal.Id,
            Units_Available__c = 1,
            Rate__c = 1
        );
        insert sch;
        
        Spot_Data__c sd = new Spot_Data__c(
            Raycom_Order_Number__c = '12345',
            Schedule__c = sch.Id,
            Air_Date__c = sch.Week__c
        );
        insert sd;
        
        RaycomMonthlyLineItem__c li = new RaycomMonthlyLineItem__c(
        	OrderNumber__c = '12345',
            Invoice__c = '99999',
            BillingMonth__c = Date.newInstance(2017,1,2)
        );
        insert li;
        
    }
    
    @isTest
    public static void test() {
        
        RaycomMonthlyLineItem__c li = [select Id, Invoice__c from RaycomMonthlyLineItem__c limit 1];
        
        Test.startTest();
        Database.executeBatch(new RaycomMonthlyLineItemBatch(), 1);
        Test.stopTest();
        
        Spot_Data__c sd = [select Id, Raycom_Invoice_Number__c from Spot_Data__c limit 1];
        
        system.assertEquals(li.Invoice__c, sd.Raycom_Invoice_Number__c);
        
        // assert the delete works
        List<RaycomMonthlyLineItem__c> lis = [select Id from RaycomMonthlyLineItem__c];
        system.assertEquals(0, lis.size());
        
    }
    
    @isTest
    public static void testException() {
        
        Test.startTest();
        RaycomMonthlyLineItemBatch.forceExceptionError = true;
        Database.executeBatch(new RaycomMonthlyLineItemBatch(), 1);
        Test.stopTest();
        
        RaycomMonthlyLineItem__c li = [select Id, Spot_Data_Failure_Count__c, Invoice__c from RaycomMonthlyLineItem__c limit 1];
        system.assertEquals(1, li.Spot_Data_Failure_Count__c);
        
    }
    
}