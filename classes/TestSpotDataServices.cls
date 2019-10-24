@isTest
private class TestSpotDataServices
{
    /*
    static testMethod void validateScheduleOnSDM()
    {
        
        Test.startTest();
        Programs__c prg = new Programs__c(Name = 'Tennis Channel', ClientCode__c = 'TC1');
        insert prg; 
        
        Account act = new Account (name='test Act');
        insert act;
        
        Contact con = new Contact(LastName='TestCon',AccountId=act.id);
        insert con;

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        
        Deal__c deal= new Deal__c(Length__c='120',Program__c = prg.id, Contact__c = con.id,Network_Deal_Number__c ='1420', Brands__c = brand.Id);
        insert deal;
   
        list<Schedules__c> schlist = new list<Schedules__c>();
        for(Integer i = 0 ; i<10; i++){
            Schedules__c sch = new Schedules__c(Deal_Parent__c=deal.id,X800_Number__c= '9658969856',Units_Available__c= 4.0, Rate__c= 60+i,Start_Time__c='09:00A',End_Time__c='05:00P',Days_Allowed__c = 'Mon; Tue; Wed; Thu; Fri; Sat; Sun', Week__c=date.newinstance(2013, 6, 10),Status__c='Sold');
            schlist.add(sch); 
        }
        for(Integer i = 0 ; i<10; i++){
            Schedules__c sch = new Schedules__c(Deal_Parent__c=deal.id,X800_Number__c= '9658969856',Units_Available__c= 5.0,Rate__c= 60+i,Start_Time__c='09:00A',End_Time__c='05:00P',Days_Allowed__c = 'Wed;',Week__c=date.newinstance(2013, 6, 3),Status__c='Sold');
            schlist.add(sch); 
        }
        
        insert schlist;

        List< SpotDataMirror__c> sdms = new List< SpotDataMirror__c>();
        SpotDataMirror__c sdm2 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 6, 10), 
        Air_Time__c = '12:04:32 PM', Length__c = '120', Network_Deal_Number__C = '1420', SPOT_RATE__C = 60, 
        NETWORK__C = 'Tennis Channel');
        sdms.add(sdm2);
        
        SpotDataMirror__c sdm3 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 6, 3), 
        Air_Time__c = '3:04:32 AM', Network_Deal_Number__C = '14201', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
        sdms.add(sdm3);
        
        SpotDataMirror__c sdm4 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 6, 3), 
        Air_Time__c = '3:04:32 P', Network_Deal_Number__C = '14201', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
        sdms.add(sdm4);

        /*SpotDataMirror__c sdm3 = new SpotDataMirror__c(Name = 'SDM1', Air_Date__c = date.newinstance(2012, 2, 19),
         Air_Time__c = '11:27:25 AM',Network_Deal_Number__C = '377659', SPOT_RATE__C = 20, 
         NETWORK__C = 'Tennis Channel');
       
        
         SpotDataMirror__c sdm4 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 2, 17), 
        Air_Time__c = '10:27:25 AM', Length__c = '60', Network_Deal_Number__C = '1444', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
      

        SpotDataMirror__c sdm5 = new SpotDataMirror__c(Name = 'SDM1', Air_Date__c = date.newinstance(2012, 2, 19),
         Air_Time__c = '11:27:25 PM',Network_Deal_Number__C = '98745965588', SPOT_RATE__C = 20, 
         NETWORK__C = 'Tennis Channel');

        SpotDataMirror__c sdm6 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 2, 18), 
        Air_Time__c = '11:27:25 AM', Length__c = '20', Network_Deal_Number__C = '98745965588', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
      
        sdms.add(sdm);
        sdms.add(sdm2);
        sdms.add(sdm3);
        sdms.add(sdm4);
        sdms.add(sdm5);
        sdms.add(sdm6);*//*
        insert sdms;
        Test.stopTest();

        List<SpotDataMirror__c> spotdatamirrorrecords=[select  Name ,Air_Date__c ,Air_Time__c ,Network_Deal_Number__C ,SPOT_RATE__C,NETWORK__C  from  SpotDataMirror__c];
        
        List<SpotDataMirror__c> updatespotdatamirrorrecords=new List<SpotDataMirror__c>();
        for(SpotDataMirror__c s:spotdatamirrorrecords)
        {
        s.Length__c = '120';
        updatespotdatamirrorrecords.add(s);
        }
        update updatespotdatamirrorrecords;
        
        
        
        List<SpotDataMirror__c> spotdatamirrorrecords1=[select  Name ,Air_Date__c ,Air_Time__c ,Network_Deal_Number__C ,SPOT_RATE__C,NETWORK__C  from  SpotDataMirror__c];
        
        List<SpotDataMirror__c> updatespotdatamirrorrecords1=new List<SpotDataMirror__c>();
        for(SpotDataMirror__c s:spotdatamirrorrecords1)
        {
        s.Length__c = '120';
        s.NETWORK__C = 'BounceTV';
        updatespotdatamirrorrecords1.add(s);
        }
        update updatespotdatamirrorrecords1;
    }
    
    static testMethod void validateScheduleOnSDM1()
    {
        
        Test.startTest();
        Programs__c prg = new Programs__c(Name = 'Tennis Channel', ClientCode__c = 'TC1');
        insert prg; 
        
        Account act = new Account (name='test Act');
        insert act;
        
        Contact con = new Contact(LastName='TestCon',AccountId=act.id);
        insert con;

        Advertiser__c advertiser = new Advertiser__c(Duplicate_Approval__c = 'Approved');
        insert advertiser;
         
        Brands__c brand = new Brands__c();
        brand.Name = 'Availability';
        brand.Category__c = 'Other';
        brand.Advertiser__c = advertiser.id;
        brand.Approved_Duplicate__c = 'Approved' ;
        insert brand;
        
        Deal__c deal= new Deal__c(Length__c='120',Program__c = prg.id, Contact__c = con.id,Network_Deal_Number__c ='1420', Brands__c = brand.Id);
        insert deal;
   
        list<Schedules__c> schlist = new list<Schedules__c>();

        for(Integer i = 0 ; i<10; i++){
            Schedules__c sch = new Schedules__c(Deal_Parent__c=deal.id,X800_Number__c= '9658969856',Units_Available__c= 5.0,Rate__c= 60+i,Start_Time__c='09:00A',End_Time__c='05:00P',Days_Allowed__c = 'Wed;',Week__c=date.newinstance(2013, 6, 3),Status__c='Sold');
            schlist.add(sch); 
        }
        
        insert schlist;

        List< SpotDataMirror__c> sdms = new List< SpotDataMirror__c>();
        SpotDataMirror__c sdm2 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 6, 10), 
        Air_Time__c = '6:04:32 PM', Length__c = '120', Network_Deal_Number__C = '1420', SPOT_RATE__C = 60, 
        NETWORK__C = 'Tennis Channel');
       sdms.add(sdm2);
        
        SpotDataMirror__c sdm3 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 6, 3), 
        Air_Time__c = '3:04:32 AM', Network_Deal_Number__C = '14201', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');

        /*SpotDataMirror__c sdm3 = new SpotDataMirror__c(Name = 'SDM1', Air_Date__c = date.newinstance(2012, 2, 19),
         Air_Time__c = '11:27:25 AM',Network_Deal_Number__C = '377659', SPOT_RATE__C = 20, 
         NETWORK__C = 'Tennis Channel');
       
        
         SpotDataMirror__c sdm4 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 2, 17), 
        Air_Time__c = '10:27:25 AM', Length__c = '60', Network_Deal_Number__C = '1444', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
      

        SpotDataMirror__c sdm5 = new SpotDataMirror__c(Name = 'SDM1', Air_Date__c = date.newinstance(2012, 2, 19),
         Air_Time__c = '11:27:25 PM',Network_Deal_Number__C = '98745965588', SPOT_RATE__C = 20, 
         NETWORK__C = 'Tennis Channel');

        SpotDataMirror__c sdm6 = new SpotDataMirror__c(Name = 'test1', Air_Date__c = date.newinstance(2013, 2, 18), 
        Air_Time__c = '11:27:25 AM', Length__c = '20', Network_Deal_Number__C = '98745965588', SPOT_RATE__C = 60, 
        NETWORK__C = 'Cricket Channel');
      
        sdms.add(sdm);
        sdms.add(sdm2);
        sdms.add(sdm3);
        sdms.add(sdm4);
        sdms.add(sdm5);
        sdms.add(sdm6);*//*
        insert sdms;
        Test.stopTest();

    List<SpotDataMirror__c> spotdatamirrorrecords=[select  Name ,Air_Date__c ,Air_Time__c ,Network_Deal_Number__C ,SPOT_RATE__C,NETWORK__C  from  SpotDataMirror__c];
    
    List<SpotDataMirror__c> updatespotdatamirrorrecords=new List<SpotDataMirror__c>();
    for(SpotDataMirror__c s:spotdatamirrorrecords)
    {
    s.Length__c = '120';
    updatespotdatamirrorrecords.add(s);
    }
    update updatespotdatamirrorrecords;
    
    
    
    List<SpotDataMirror__c> spotdatamirrorrecords1=[select  Name ,Air_Date__c ,Air_Time__c ,Network_Deal_Number__C ,SPOT_RATE__C,NETWORK__C  from  SpotDataMirror__c];
    
    List<SpotDataMirror__c> updatespotdatamirrorrecords1=new List<SpotDataMirror__c>();
    for(SpotDataMirror__c s:spotdatamirrorrecords1)
    {
    s.Length__c = '120';
    s.NETWORK__C = 'BounceTV';
    updatespotdatamirrorrecords1.add(s);
    }
    update updatespotdatamirrorrecords1;
    
    
    }
    */
}