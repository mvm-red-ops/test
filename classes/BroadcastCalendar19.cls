public class BroadcastCalendar19 {
    //first seven blocks are the hardcoded calendar data
    //underneath is the creation of the class property

    
    public static List<Date> startEndDates(){
       List<Date> bcDates = new List<Date>();
    //month 1
      Date monthOneStartDate = date.newInstance(2018, 12, 31);
      Date monthOneEndDate = date.newInstance(2019, 01, 27);

     //month 2
     Date monthTwoStartDate = date.newInstance(2019, 01, 28);
     Date monthTwoEndDate = date.newInstance(2019, 02, 24);

    //month 3
     Date monthThreeStartDate = date.newInstance(2019, 02, 25);
     Date monthThreeEndDate = date.newInstance(2019, 03, 31);
    
    //month 4
     Date monthFourStartDate = date.newInstance(2019, 04, 01);
      Date monthFourEndDate = date.newInstance(2019, 04, 28);


        
    //month 5
     Date monthFiveStartDate = date.newInstance(2019, 04, 29);
     Date monthFiveEndDate = date.newInstance(2019, 05, 26);
    
        
    //month 6
     Date monthSixStartDate = date.newInstance(2019, 05, 27);
     Date monthSixEndDate = date.newInstance(2019, 06, 30);
    
        
    //month 7
     Date monthSevenStartDate = date.newInstance(2019, 07, 01);
     Date monthSevenEndDate = date.newInstance(2019, 07, 28);   
            
       bcDates.add(monthOneStartDate);
       bcDates.add(monthOneEndDate);
        
       bcDates.add(monthTwoStartDate);
       bcDates.add(monthTwoEndDate);
        
       bcDates.add(monthThreeStartDate);
       bcDates.add(monthThreeEndDate);
        
       bcDates.add(monthFourStartDate);
       bcDates.add(monthFourEndDate);
                
       bcDates.add(monthFiveStartDate);
       bcDates.add(monthFiveEndDate);
        
                
       bcDates.add(monthSixStartDate);
       bcDates.add(monthSixEndDate);



       bcDates.add(monthSevenStartDate);
   	   bcDates.add(monthSevenEndDate);

       return bcDates;
        
    } 
    


    
    
    
}