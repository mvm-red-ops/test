@isTest
public class AgingReportMapperTest {
    
    @testSetup static void setup(){
        //query for test data spots 
     	List<Spot_Data__c> spotResults = [select id, air_date__c, Raycom_Order_Number__c from spot_data__c where Raycom_Order_Number__c = '100' or Raycom_Order_Number__c = '200'];

        //if no spots exist, run the createTestData method to generate all necesarry objects for spot data and related objects
        if(spotResults.size() == 0){
      		//creates 60 instances of spot data 
       		//30 with order#100, 1 for each day 03/01/2019 to 03/30/2019
       		//30 have order#200, 1 for each day 04/01/2019 to 04/30/2019
           createTestData(); 
         }
       
    }
    
     @isTest public static void testAprilSpots(){ 
        
        Date broadcastMonthStartDate = date.newInstance(2019, 04, 01);
        Date broadcastMonthEndDate = date.newInstance(2019, 04, 28);

        List<Spot_Data__c>  aprilSpots =  [
            select id, air_date__c, Raycom_Order_Number__c 
            from spot_data__c where Raycom_Order_Number__c = '200' 
            and air_date__c >= :broadcastMonthStartDate 
            and air_date__c <= :broadcastMonthEndDate 
        ];
        //check assertion
        System.assertEquals(28 , aprilSpots.size());
  
    }
    
   	public static void createTestData(){
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard Platform User'];
      
            User u = new User(Alias = 'standt', Email='BrianHorowitz@mvmediasales.com', 
            EmailEncodingKey='UTF-8', LastName='exec', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='TestAugustTestUser@testorg.com');
            
            User u2 = new User(Alias = 'standt', Email='BrianHorowitz@mvmediasales.com', 
           	EmailEncodingKey='UTF-8', LastName='oper', LanguageLocaleKey='en_US', 
         	LocaleSidKey='en_US', ProfileId = p.Id, 
         	TimeZoneSidKey='America/Los_Angeles', UserName='TestAugustTestUser2@testorg.com');
              
            List<User> executives = [SELECT Id FROM User WHERE LastName = 'exec'];
            User executive = executives[0];
            
            List<User> operations = [SELECT Id FROM User WHERE LastName = 'oper'];
            User operations1 = operations[0];
            
            Account acct = new Account();
            acct.Name = 'name';
            acct.Emerald_AE__c = executive.id;
            acct.Red_AE__c = executive.id;
            acct.Onyx_AE__c = executive.id;
            acct.Pine_AE__c = executive.id;
            acct.Oak_AE__c = executive.id;
            acct.Silver_AE__c = executive.id;
            acct.Maple_AE__c = executive.id;
            acct.Yellow_AE__c = executive.id;
           
       		insert acct; 
                
        
            Programs__c program = new Programs__c();
            program.Name = 'Retro Raycom Two';
            program.Reconciled_Week__c = Date.today().adddays(-21).toStartofWeek().adddays(1);
            program.Cable_Synd__c = 'Cable';
            program.ClientCode__c = 'br7';
            program.Team__c = 'Onyx';
            program.Account_Exec_1__c = executive.id;
            program.Assistant__c = operations1.id;
            program.Network_System_Entry__c = Programs__c.Network_System_Entry__c.getDescribe().getPicklistValues()[0].getValue();
            program.Network_System__c = Programs__c.Network_System__c.getDescribe().getPicklistValues()[0].getValue();
            program.Prelog__c = operations1.id;
            program.Post_Log__c = operations1.id;          
            program.Station_Call_Letter__c = 'kt';
           
            insert program; 
        
            
            Contact con = new Contact(LastName = 'TestTesterson', Email = 'test@test154.com', Phone = '8001294567', Emerald_AE__c = executive.id, Green_AE__c = executive.id, Onyx_AE__c = executive.id, Silver_AE__c = executive.id, Maple_AE__c = executive.id, Pine_AE__c = executive.id, Oak_AE__c = executive.id, Fire_AE_Bounce__c = executive.id, Fire_AE_Escape__c = executive.id, Red_AE__c = executive.id, Fire_AE_Grit__c = executive.id, Fire_AE_Laff__c = executive.id, Yellow_AE__c = executive.id);
            insert con; 
        
        
            Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true, Account__c = acct.id);
            insert advertiser; 
        
            Brands__c brand = new Brands__c();
            brand.Name = 'Available';
            brand.Category__c = 'Other';
            brand.Advertiser__c = advertiser.id;
            brand.Approved_Duplicate__c = 'Approved' ;
            insert brand; 
        
            Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Program__c = program.Id, Length__c = '30', Network_Deal_Number__c = '111111');
            insert deal; 
        
        
            Schedules__c schedule4 = new Schedules__c();
              schedule4.Units_Available__c = 2.0;
              schedule4.Units_Preempted__c = 0;
              schedule4.Week__c = Date.today().adddays(-14).toStartofWeek().adddays(1);
              schedule4.Deal_Parent__c = deal.Id;
              schedule4.Status__c = 'Sold';
              schedule4.Rate__c = 1800;
              insert schedule4; 
        
			Integer counter = 1;
            Integer counter2 = 1;
            
            List<Spot_Data__c> insertData = new List<Spot_Data__c>();
            
            while(counter < 31){
                Spot_Data__c spotTest = new Spot_Data__c();
                Integer day = counter; 
                Integer month = 3;
                Integer year = 2019;
                Date myDate = Date.newInstance(year, month, day); 
                spotTest.Schedule__c = [select id from schedules__c limit 1].id;
                spotTest.air_date__c = myDate;
                spotTest.Raycom_Order_Number__c  = '100';
                insertData.add(spotTest);
                counter++;
            }
            
            while(counter2 < 31){
             Spot_Data__c spotTest = new Spot_Data__c();
             Integer day = counter2; 
             Integer month = 4;
             Integer year = 2019;
             Date myDate = Date.newInstance(year, month, day); 
             spotTest.Schedule__c = [select id from schedules__c limit 1].id;
             spotTest.air_date__c = myDate;
             spotTest.Raycom_Order_Number__c  = '200';
             insertData.add(spotTest);
             counter2++;
            }
            insert insertData;
        }
 

   
}