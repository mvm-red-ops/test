@isTest
public class BroadcastDateRangeTest {
    @isTest static void dateFallsInFirstBroadcastMonth(){
      Date testDate = date.newInstance(2019, 01, 12);
      Date expectedStart = date.newInstance(2018, 12, 31);
      Date expectedEnd = date.newInstance(2019, 01, 27);

	  List<Date> results = BroadcastDateRange.returnDateRange(testDate);
      // assert 

      System.assertEquals(expectedStart, results[0]);
      System.assertEquals(expectedEnd, results[1]);
	  System.assertEquals(2, results.size());
    }
    
    @isTest static void dateFallsInLastBroadcastMonth(){
      Date testDate = date.newInstance(2019, 07, 12);
      Date expectedStart = date.newInstance(2019, 07, 01);
      Date expectedEnd = date.newInstance(2019, 07, 28);

	  List<Date> results = BroadcastDateRange.returnDateRange(testDate);

      System.assertEquals(expectedStart, results[0]);
      System.assertEquals(expectedEnd, results[1]);
	  System.assertEquals(2, results.size());        
    }
    
   	@isTest static void dateNotOnBroadcastCalendar(){
      Date testDate = date.newInstance(2019, 10, 12);
      Date expectedStart = date.newInstance(2019, 07, 01);
      Date expectedEnd = date.newInstance(2019, 07, 28);

	  List<Date> results = BroadcastDateRange.returnDateRange(testDate);

	  System.assertEquals(null, results);      
    }
}