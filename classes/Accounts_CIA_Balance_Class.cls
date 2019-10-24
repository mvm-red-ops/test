public class Accounts_CIA_Balance_Class {
    
    public static Decimal previousMonthBookingNetTotal(Account accountRecord) {
        List<ffps_dealinv__Broadcast_Month__c> startDateList = previousBroadcastMonthStartDate();
        List<ffps_dealinv__Broadcast_Month__c> endDateList = previousBroadcastMonthEndDate();
        Datetime rawStartDate = startDateList[0].ffps_dealinv__Start_Date__c;
        Datetime rawEndDate = endDateList[0].ffps_dealinv__End_Date__c;
        Date soqlStartDate = rawStartDate.date();
        Date soqlEndDate = rawEndDate.date();
        String soqlAccountName = '%' + accountRecord.Name + '%';
        // When pushed to live, replace LIKE %CHIEF% with :soqlAccountName
        List<AggregateResult> getGrossTotalDollars = [SELECT SUM(Total_Dollars__c) FROM schedules__c WHERE Deal_Parent__c IN (SELECT id FROM deal__c WHERE ContactAccount__c LIKE :soqlAccountName) AND LF_Week__c >= 2018-01-01 AND LF_Week__c <= 2018-01-30];
        Object sum = getGrossTotalDollars[0].get('expr0');
        Decimal getNetTotalDollars = .85 * (Decimal) sum;
        System.debug('Here is the total net dollars of the previous month: ' + getNetTotalDollars);
        return getNetTotalDollars;
    }
    
    public static List<ffps_dealinv__Broadcast_Month__c> previousBroadcastMonthStartDate() {
       List<ffps_dealinv__Broadcast_Month__c> startDateList = new List<ffps_dealinv__Broadcast_Month__c>();
       startDateList.add([SELECT ffps_dealinv__Start_Date__c FROM ffps_dealinv__Broadcast_Month__c WHERE ffps_dealinv__Start_Date__c <= TODAY ORDER BY ffps_dealinv__Start_Date__c DESC LIMIT 1 OFFSET 1][0]);
       System.debug('PreviousBroadcastMonthStartDate first array position start date: ' + startDateList[0].ffps_dealinv__Start_Date__c);
       return startDateList;
    }
    
    public static List<ffps_dealinv__Broadcast_Month__c> previousBroadcastMonthEndDate() {
        List<ffps_dealinv__Broadcast_Month__c> endDateList = new List<ffps_dealinv__Broadcast_Month__c>();
        endDateList.add([SELECT ffps_dealinv__End_Date__c FROM ffps_dealinv__Broadcast_Month__c WHERE ffps_dealinv__End_Date__c <= TODAY ORDER BY ffps_dealinv__End_Date__c DESC LIMIT 1][0]);
        System.debug('PreviousBroadcastMonthEndDate first array position end date: ' + endDateList[0].ffps_dealinv__End_Date__c);
        return endDateList;
    }    
    
}