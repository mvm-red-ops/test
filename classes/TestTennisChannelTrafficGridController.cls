/**
@ name          :    TestTennisChannelTrafficGridController    
@ author        :
@ date          :    9 Augest, 2011
@ descripton    :  Test Class For TennisChannelTrafficGridController Class
*/
@isTest
public class TestTennisChannelTrafficGridController {
    @isTest
    public static void Test () {     
                
        Account acc = New Account();
        acc.name = 'Test';
        insert acc;
        
        Contact con = new Contact(Email = 'test@test.com', Phone = '8001234567');
        con.AccountID = acc.id;
        con.LastName = 'Test';
        insert con;
        
        Programs__c pro = new Programs__c();
        pro.Name = 'Tennis PP';
        pro.ClientCode__C = 'TC2';
        insert pro;

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        
        Deal__C de = new Deal__C(Contact__c = con.Id);
        de.Program__c = pro.id;     
        de.Brands__c = brand.Id ;   
        insert de;
        
        Schedules__c sch = new Schedules__c();        
        sch.Deal_Parent__c = de.Id;
        //sch.DealProgram__c = pro.Id;
        sch.Week__c = system.today();                
        sch.Long_Form__c = 'A-2:00';        
        sch.Units_Preempted__c = 0;
        //sch.Units_Aired__c = 0.0;
        sch.Rate__c = 100;
        sch.Units_Available__c = 1;
        
        //sch.Total_Dollars__c = 0;                
        
        insert sch;        
        
        Date weekFrom = sch.week__c;
        date weekTo = sch.week__c;        
        
        list<Schedules__c> scList = new List<Schedules__c>([SELECT id,Deal_Parent__c,Week__c,Long_Form__c,Units_Preempted__c,
                                    Rate__c FROM Schedules__c WHERE Units_Preempted__c != 1 AND
                                    DealProgram__c =: 'Tennis PP'  AND Week__c >=: weekFrom AND Week__c <=: weekTo
                                    LIMIT 5 ]);
                                    
        apexPages.CurrentPage().getParameters().put('chk_1', sch.id);
        TennisChannelTrafficGridController T=new TennisChannelTrafficGridController(); 
        
        T.dealKeyword = acc.name;
        T.months = 'Aug-2011';        
        T.save();

        

        T.requestTraffic();
        T.requestTrafficWeek();
        

        //T.SendEmail();
        
        
        
        System.assert(scList.size()>0,'No Record Saved');
        t.search();        
        System.assert(scList.size()>0,'No Record Found');
    }
}