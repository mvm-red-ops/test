/**
* @author Adrian Pichardo
* @date 08/06/2018
* @description Used in WeekInQuarter trigger to populate Real_Week_In_Quarter
**/
public class WeekInQuarters {
    
    /**
    * @author Adrian Pichardo
    * @date 08/06/2018
    * @description sets Real_Week_In_Quarter to the correct number
    * @param Schedules__c sch: Schedule that was triggered
    * @variable Integer change: Sets up for first mod calculation (figures out Week 13, (doesnt take year-week count into account))
    * @variable Integer changetwo: Sets up for second mod calculation (figures out 'Other Weeks' (does take year-week count into account, non 13/14))
    **/
    public static void weekNumber(Schedules__c sch){
        
        Integer change = 0;
        Integer changetwo = 0;
        if((sch.LF_Week__c.isSameDay(date.newInstance(2012,9,24))) || (sch.LF_Week__c.isSameDay(date.newInstance(2017,12,25))) || (sch.LF_Week__c.isSameDay(date.newInstance(2018,9,24))) ){
            sch.New_Week_in_Quarter__c = 14;
            return;
        }

        if(sch.Week__c > date.newInstance(2012,9,30)){
            change += -1; 
        }
        if(sch.Week__c > date.newInstance(2017,12,31)){
            change += -1; 
        }
        if(sch.Week__c > date.newInstance(2018,3,25) && sch.Week__c < date.newInstance(2018,9,30)){
            change += 1; 
        }
        if(sch.UnitLength__c == 1710){
            change += date.newInstance(2007,12,31).daysBetween(sch.LF_Week__c)/7 + 1;
        }else{
            change += date.newInstance(2007,12,31).daysBetween(sch.Week__c)/7 + 1;
        }

        if(Math.mod(change,13) == 0){
            sch.New_Week_in_Quarter__c = 13;
            return;
        }

        if(sch.Week__c > date.newInstance(2012,9,30) && sch.Week__c < date.newInstance(2012,12,31)){
            changetwo += -1;
        }
        if(sch.Week__c > date.newInstance(2017,12,31)){
            changetwo += -1;
        }
        if(sch.Week__c > date.newInstance(2018,3,25) && sch.Week__c < date.newInstance(2018,9,30)){
            changetwo += 1;
        }

        if(sch.UnitLength__c == 1710){
            changetwo += date.newInstance(2007,12,31).daysBetween(sch.LF_Week__c)/7;    
        }else{
            changetwo += date.newInstance(2007,12,31).daysBetween(sch.Week__c)/7;
        }

        changetwo += 1;

        if(sch.Week__c > date.newInstance(2008,12,29)){
            if(sch.Week__c > date.newInstance(2009,12,28)){
                if(sch.Week__c > date.newInstance(2010,12,27)){
                    if(sch.Week__c > date.newInstance(2011,12,26)){
                        if(sch.Week__c > date.newInstance(2012,12,30)){
                            changetwo += -261;
                        }else{
                            changetwo += -208;      
                    }}else{
                        changetwo += -156;
                    }}else{
                        changetwo += -104;  
                    }}else{
                        changetwo += -52;
                    }}  
        sch.New_Week_in_Quarter__c = Math.mod(changetwo,13);
        return;

    }
}