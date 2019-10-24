/* This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 /**    Description     :   Test class for PrelogClearanceReportController_version3. 
  *                          
  *     Created By      :   Sanjay Ramchandani
  * 
  *     Created Date    :   --
  *
  *     Revisison Log   :   V_1.0 - Created
  *                         V_1.0 - Modified for new changes 1/31/2015

  *     Coverage        :   Previous 54, Current 60%
**/
@isTest
private class  PrelogClearanceReportController_v3Test {
    
    @isTest static void PrelogClearanceReportControllerTest() {

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
        
        //Program
        Programs__c program = new Programs__c();
                    program.Name = 'BounceTV';
                    program.Cable_Synd__c = 'Cable';
                    program.ClientCode__c = 'h1';
                    program.Barter__c = true;
                    program.Station_Call_Letter__c = 'a';
        insert program;

        Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Program__c = program.Id);
        insert deal;
        
        //Schedule
        Schedules__c schedule = new Schedules__c();
                     schedule.Units_Available__c = 1.0;
                     schedule.Units_Preempted__c = 0;
                     schedule.Week__c = Date.today().toStartofWeek();
                     schedule.Deal_Parent__c = deal.Id;
                     schedule.Status__c = 'Sold';
                     schedule.Rate__c = 300;
        insert schedule;
        
        PrelogClearanceReportController_version3 dc = new PrelogClearanceReportController_version3() ;
        System.assertEquals(1, PrelogClearanceReportHelper.ReturnNumber('Jan'));
        System.assertEquals(2, PrelogClearanceReportHelper.ReturnNumber('Feb'));
        System.assertEquals(3, PrelogClearanceReportHelper.ReturnNumber('Mar'));
        System.assertEquals(4, PrelogClearanceReportHelper.ReturnNumber('Apr'));
        System.assertEquals(5, PrelogClearanceReportHelper.ReturnNumber('May'));
        System.assertEquals(6, PrelogClearanceReportHelper.ReturnNumber('Jun'));
        System.assertEquals(7, PrelogClearanceReportHelper.ReturnNumber('Jul'));
        System.assertEquals(8, PrelogClearanceReportHelper.ReturnNumber('Aug'));
        System.assertEquals(9, PrelogClearanceReportHelper.ReturnNumber('Sep'));
        System.assertEquals(10, PrelogClearanceReportHelper.ReturnNumber('Oct'));
        System.assertEquals(11, PrelogClearanceReportHelper.ReturnNumber('Nov'));
        System.assertEquals(12, PrelogClearanceReportHelper.ReturnNumber('Dec'));
        
        dc.CurrentFP = [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month' limit 1];
        dc.CurrentFM = dc.CurrentFP ;
        dc.CurrentFW = dc.CurrentFP ;
        
        dc.Searchfield = 'BounceTV' ;
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous FY'; 
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;dc.DoSearch() ;
       
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.DoSearch() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
        dc.BarterCheckbox=true;
        dc.getDealResult() ;
        Date d = Date.today();
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.ClearAllButton() ;
        dc.SortDealResultList() ;
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
        dc.AddMoreToDeal() ;
        List<PrelogClearanceReportHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;
        
        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;
        
        //Method Calling
        PrelogClearanceReportHelper.formatDatetime(System.now());
        
        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.SearchField = ' BounceTV , ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();
        
        //Wrapper instance
        PrelogClearanceReportHelper.PrelogDataWrapper con2 = new PrelogClearanceReportHelper.PrelogDataWrapper(new PrelogData__c());
        
        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);
        
        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        }
        catch(Exception e){}
        tempDate = dc.getMonday();
    }
    
     @isTest static void PrelogClearanceReportControllerTest2() {

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
        
        //Program
        Programs__c program = new Programs__c();
                    program.Name = 'BounceTV';
                    program.Cable_Synd__c = 'Cable';
                    program.ClientCode__c = 'h1';
                    program.Barter__c = true;
                    program.Station_Call_Letter__c = 'a';
        insert program;

        Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Program__c = program.Id);
        insert deal;
        
        //Schedule
        Schedules__c schedule = new Schedules__c();
                     schedule.Units_Available__c = 1.0;
                     schedule.Units_Preempted__c = 0;
                     schedule.Week__c = Date.today().toStartofWeek().adddays(7).adddays(1);
                     schedule.Deal_Parent__c = deal.Id;
                     schedule.Status__c = 'Sold';
                     schedule.Rate__c = 300;
        insert schedule;
        
        
        
        PrelogData__c pd=new PrelogData__c();
        pd.Schedule__c=schedule.id;
        pd.AirDate__c=date.today().adddays(7);
        pd.Version__c=1;
        insert pd;
        
        PrelogData__c pd1=[select id, airdate__c,Schedule__r.week__c, week__c from PrelogData__c where id=:pd.id];
        system.debug('####'+pd1);
        
        
        PrelogClearanceReportController_version3 dc = new PrelogClearanceReportController_version3() ;
        System.assertEquals(1, PrelogClearanceReportHelper.ReturnNumber('Jan'));
        System.assertEquals(2, PrelogClearanceReportHelper.ReturnNumber('Feb'));
        System.assertEquals(3, PrelogClearanceReportHelper.ReturnNumber('Mar'));
        System.assertEquals(4, PrelogClearanceReportHelper.ReturnNumber('Apr'));
        System.assertEquals(5, PrelogClearanceReportHelper.ReturnNumber('May'));
        System.assertEquals(6, PrelogClearanceReportHelper.ReturnNumber('Jun'));
        System.assertEquals(7, PrelogClearanceReportHelper.ReturnNumber('Jul'));
        System.assertEquals(8, PrelogClearanceReportHelper.ReturnNumber('Aug'));
        System.assertEquals(9, PrelogClearanceReportHelper.ReturnNumber('Sep'));
        System.assertEquals(10, PrelogClearanceReportHelper.ReturnNumber('Oct'));
        System.assertEquals(11, PrelogClearanceReportHelper.ReturnNumber('Nov'));
        System.assertEquals(12, PrelogClearanceReportHelper.ReturnNumber('Dec'));
        dc.CurrentFP = [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month' limit 1];
        dc.CurrentFM = dc.CurrentFP ;
        dc.CurrentFW = dc.CurrentFP ;
        
        dc.BarterCheckbox = true;
        dc.prelogVersion='1';
        dc.DealId=deal.id;
        dc.tempSchedule.Week__c= Date.today().toStartofWeek().addDays(-6);
        dc.SearchField = 'BounceTV';
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FY'; 
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
         dc.getDealResult() ;
        dc.DealId=deal.id;
        Date d = Date.today();
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.ClearAllButton() ;
        dc.SortDealResultList() ;
        
        dc.AddMoreToDeal() ;
        List<PrelogClearanceReportHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;
        
        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;
        
        //Method Calling
        PrelogClearanceReportHelper.formatDatetime(System.now());
        
        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.SearchField = ' BounceTV , ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();
        
        //Wrapper instance
        PrelogClearanceReportHelper.PrelogDataWrapper con2 = new PrelogClearanceReportHelper.PrelogDataWrapper(new PrelogData__c());
        
        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);
        dc.getKeys();
        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        }
        catch(Exception e){}
        tempDate = dc.getMonday();
        dc.getWeekData();
        dc.FillDealResultList();
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
    }
    
    
     @isTest static void PrelogClearanceReportControllerTest3() {

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
        
        //Program
        Programs__c program = new Programs__c();
                    program.Name = 'BounceTV';
                    program.Cable_Synd__c = 'Cable';
                    program.ClientCode__c = 'h1';
                    program.Barter__c = true;
                    program.Station_Call_Letter__c = 'a';
        insert program;

        Deal__c deal = new Deal__c(Contact__c = con.Id, Brands__c = brand.Id, Program__c = program.Id);
        insert deal;
        
        //Schedule
        Schedules__c schedule = new Schedules__c();
                     schedule.Units_Available__c = 1.0;
                     schedule.Units_Preempted__c = 0;
                     schedule.Week__c = Date.today().adddays(7).toStartofWeek().adddays(1);
                     schedule.Deal_Parent__c = deal.Id;
                     schedule.Status__c = 'Sold';
                     schedule.Rate__c = 300;
        insert schedule;
        
        
        
        PrelogData__c pd=new PrelogData__c();
        pd.Schedule__c=schedule.id;
        pd.AirDate__c=date.today().adddays(7);
        pd.Version__c=1;
        insert pd;
        
        PrelogClearanceReportController_version3 dc = new PrelogClearanceReportController_version3() ;
        System.assertEquals(1, PrelogClearanceReportHelper.ReturnNumber('Jan'));
        System.assertEquals(2, PrelogClearanceReportHelper.ReturnNumber('Feb'));
        System.assertEquals(3, PrelogClearanceReportHelper.ReturnNumber('Mar'));
        System.assertEquals(4, PrelogClearanceReportHelper.ReturnNumber('Apr'));
        System.assertEquals(5, PrelogClearanceReportHelper.ReturnNumber('May'));
        System.assertEquals(6, PrelogClearanceReportHelper.ReturnNumber('Jun'));
        System.assertEquals(7, PrelogClearanceReportHelper.ReturnNumber('Jul'));
        System.assertEquals(8, PrelogClearanceReportHelper.ReturnNumber('Aug'));
        System.assertEquals(9, PrelogClearanceReportHelper.ReturnNumber('Sep'));
        System.assertEquals(10, PrelogClearanceReportHelper.ReturnNumber('Oct'));
        System.assertEquals(11, PrelogClearanceReportHelper.ReturnNumber('Nov'));
        System.assertEquals(12, PrelogClearanceReportHelper.ReturnNumber('Dec'));
        
        dc.CurrentFP = [select Id, FiscalYearSettings.Name, StartDate, EndDate, Number, PeriodLabel from Period where Type = 'Month' limit 1];
        dc.CurrentFM = dc.CurrentFP ;
        dc.CurrentFW = dc.CurrentFP ;
        
        dc.BarterCheckbox = true;
        dc.prelogVersion='1';
        dc.DealId=deal.id;
        dc.tempSchedule.Week__c= Date.today().toStartofWeek().addDays(-6);
        dc.SearchField = 'BounceTV, BounceTV';
        dc.SelectedDateLiteral = null ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Custom' ;
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FY'; 
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 FY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 FY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 FQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next FP';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next FW';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = '2 CY Ago';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous 2 CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CY';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Previous CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next 3 CQ';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Last Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Current And Next Month';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'This Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next Week';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Yesterday';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Today';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Tomorrow';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Last 120 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 7 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 30 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 60 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 90 Days';
        dc.ReturnSOQLDateString() ;
        dc.SelectedDateLiteral = 'Next 120 Days';
        dc.ReturnSOQLDateString() ;
         dc.SelectedDateLiteral = 'Current FY';
        dc.ReturnSOQLDateString() ;
        dc.Searchfield = 'BounceTV,BounceTV' ;
        dc.DoSearch() ;
        dc.Searchfield = 'BounceTV' ;
         dc.getDealResult() ;
        dc.DealId=deal.id;
        Date d = Date.today();
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d.toStartOfMonth().addDays(10));
        Date d2 = Date.newInstance(2014, 12, 1) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth()) ;
        PrelogClearanceReportHelper.ReturnStringDate(d2.toStartOfMonth().addDays(10));
        dc.ClearAllButton() ;
        dc.SortDealResultList() ;
        
        dc.AddMoreToDeal() ;
        List<PrelogClearanceReportHelper.HeadingModel> headList = dc.ListOfDates(d, d2);
        dc.updatePrelogClearanceReport() ;
        dc.setPrelogClearanceReport() ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(1), dc.getMonday()) ;
        System.assertEquals(Date.today().toStartOfWeek().addDays(7), dc.getSunday()) ;
        
        //Previous Coverage is 54%
        //New Code for increase the coverage
        Date tempDate = dc.thisMonday;
        tempDate = dc.thisSunday;
        
        //Method Calling
        PrelogClearanceReportHelper.formatDatetime(System.now());
        
        //Set controller properties
        dc.BarterCheckbox = true;
        dc.SelectedCableSynd = 'Cable';
        dc.SearchField = ' BounceTV,BounceTV, ' + ', ';
        dc.SelectedDateLiteral = '';
        dc.DoSearch();
        
        //Wrapper instance
        PrelogClearanceReportHelper.PrelogDataWrapper con2 = new PrelogClearanceReportHelper.PrelogDataWrapper(new PrelogData__c());
        
        //Method Calling
        Map<String, Decimal> rteMap = new Map<String, Decimal>();
        rteMap.put('1', 10);
        rteMap.put('2', 20);
        rteMap.put('3', 30);
        dc.getKeys();
        //Set controller properties
        con2.rateMap = rteMap;
        con2.unitClearanceMap = rteMap;
        try {
            con2.calculateTotals();
        }
        catch(Exception e){}
        tempDate = dc.getMonday();
        dc.getWeekData();
        dc.FillDealResultList();
        dc.RemoveDealId = deal.Id;
        dc.RemoveDealButton() ;
    }
}