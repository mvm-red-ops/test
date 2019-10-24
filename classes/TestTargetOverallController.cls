@isTest
public class TestTargetOverallController{
    @isTest
    public static void testController(){
       /** Account acc = new Account();
        acc.Name = 'testAcc';
        insert acc;
        system.assert(acc != null,'Account not inserted');
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        insert con;
        system.assert(con != null,'Contact not inserted');
        
        Programs__c program = new Programs__c();
        program.Name = 'test Program';
        program.Team__c = 'Red';
        program.ClientCode__c = 'TC1';
        insert program;
        system.assert(program != null,'Program not inserted');
        
        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        system.assert(brand!=null,'Brand not inserted');
        
        Targets__c target = new Targets__c();
        target.Brands__c = brand.Id;
        target.Status__c = 'Test';
        target.Comments__c = 'Test';
        target.Program__c = program.Id;
        insert target;
        system.assert(target != null,'Target not inserted');
        
        Deal__c deal = new Deal__c();
        deal.Brands__c = brand.Id;
        deal.Program__c = program.Id;
        deal.Client_Account__c = acc.Id;
        deal.Contact__c = con.Id;
        deal.Target__c = target.Id;
        deal.Length__c = '30';
        insert deal;
        system.assert(deal!=null,'Deal not inserted');
         
        Schedules__c schedule1 = new Schedules__c();
        schedule1.Week__c = System.today().toStartOfWeek().addDays(1);
        schedule1.Rate__c = 100;
        schedule1.Deal_Parent__c = deal.Id;
        schedule1.Units_Available__c = 1;
        insert schedule1;
        system.assert(schedule1 != null,'Schedule1 not inserted');
        
        Schedules__c schedule2 = new Schedules__c();
        schedule2.Week__c = System.today().toStartOfWeek().addDays(1);
        schedule2.Rate__c = 100;
        schedule2.Deal_Parent__c = deal.Id;
        schedule2.Units_Available__c = 1;
        insert schedule2;
        system.assert(schedule2 != null,'Schedule2 not inserted');
        
        Schedules__c schedule3 = new Schedules__c();
        schedule3.Week__c = System.today().toStartOfWeek().addDays(1);
        schedule3.Rate__c = 100;
        schedule3.Deal_Parent__c = deal.Id;
        schedule3.Units_Available__c = 1;
        insert schedule3;
        system.assert(schedule3 != null,'Schedule3 not inserted');
        
        TargetOverallController toc = new  TargetOverallController();
        toc.deal.Program__c = program.Id;
        toc.schedule.Week__c = system.today().addDays(-66);
        toc.schedule.Day__c = system.today().addDays(5);
        toc.deal.Brands__c = brand.Id;
        toc.deal.Client_Account__c = acc.Id;
        toc.deal.Brands__c = brand.Id;
        toc.deal.Contact__c = con.Id;
        toc.selectedTeam = 'Red';
        toc.schedule.TEST__c = true;
        toc.search();
        toc.schedule.TEST__c = false;
        toc.search();
        toc.save();**/
    }
}