public class BroadcastDateRange {
    public static List<Date> returnDateRange(Date invDate){
  	
        List<Date> broadcastDates = BroadcastCalendar19.startEndDates();
        List<Date> startEndDate = new List<Date>();

            
        //check if date is within range
        //throw error if not
        if(invDate < broadcastDates[0] || invDate > broadcastDates[13]){
            return null;
        }
        Integer startPointer = 0;
       	Integer endPointer = 1;
        Date currStart;
        Date currEnd;
        Boolean found = false;

        //find which broadcast month date is in
        while(found == false){
            currStart = broadcastDates[startPointer];
            currEnd = broadcastDates[endPointer];

            if(invDate <= currEnd){
                startEndDate.add(currStart);
            	startEndDate.add(currEnd);
                found = true;
                System.debug(startEndDate);

                return startEndDate;
            }
            startPointer += 2;
            endPointer += 2;
        }

        //last exception catch 
        return null;
     }
}