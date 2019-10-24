public class PrelogWeekBatchService {

    public static Prelog_Week__c newPrelogWeekKey(PrelogData__c prelogData, Date startDate) {
        if (prelogData.Version__c == null) return null;
        if (prelogData.Hour_of_Day__c == null) return null;
        if (prelogData.Schedule__r.Week__c == null) return null;
        if (prelogData.Schedule__r.Deal_Parent__r.Program__c == null) return null;
        if (prelogData.Schedule__r.Deal_Parent__r.Brands__c == null) return null;
        if (prelogData.Schedule__r.Deal_Parent__r.Brands__r.Advertiser__c == null) return null;
        if (prelogData.Schedule__r.Deal_Parent__r.Brands__r.Advertiser__r.Commercial__c == null) return null;

        String daypart = calculateDaypart(prelogData.Hour_of_Day__c);
        return new Prelog_Week__c(
            Program__c = prelogData.Schedule__r.Deal_Parent__r.Program__c,
            Commercial_Type__c = prelogData.Schedule__r.Deal_Parent__r.Brands__r.Advertiser__r.Commercial__c,
            Week__c = startDate,
            Daypart__c = daypart,
            Version__c = Integer.valueOf(prelogData.Version__c)
        );

    }

    public static Prelog_Week__c newPrelogWeekKey(Prelog_Week__c prelogWeek) {
        return new Prelog_Week__c(
                Program__c = prelogWeek.Program__c,
                Commercial_Type__c = prelogWeek.Commercial_Type__c,
                Week__c = prelogWeek.Week__c,
                Daypart__c = prelogWeek.Daypart__c,
                Version__c = Integer.valueOf(prelogWeek.Version__c)
        );

    }

    public static List<Programs__c>  getPrograms(Set<String> programIds) {
        return [SELECT Id, Name FROM Programs__c WHERE Id IN :programIds];
    }

    public static List<Programs__c>  getPrograms() {
        return [SELECT Id, Name FROM Programs__c];
    }

    public static List<Prelog_Week__c>  getAllPrelogWeeksByProgram(Set<String> programIds, Date week) {
        return [
                SELECT Id, Program__c, Commercial_Type__c, Week__c, Daypart__c, Version__c
                FROM Prelog_Week__c
                WHERE Program__c IN :programIds
                AND Week__c = :week
                ORDER BY Name
        ];

    }

    private static final Map<String, String> hoursOfDayToDaypartMap = new Map<String, String>{
            '6am' => '1-EM 6-9a',
            '7am' => '1-EM 6-9a',
            '8am' => '1-EM 6-9a',
            '9am' => '2-DT 9a-6p',
            '10am' => '2-DT 9a-6p',
            '11am' => '2-DT 9a-6p',
            '12pm' => '2-DT 9a-6p',
            '1pm' => '2-DT 9a-6p',
            '2pm' => '2-DT 9a-6p',
            '3pm' => '2-DT 9a-6p',
            '4pm' => '2-DT 9a-6p',
            '5pm' => '2-DT 9a-6p',
            '6pm' => '4-PR 6-12a',
            '7pm' => '4-PR 6-12a',
            '8pm' => '4-PR 6-12a',
            '9pm' => '4-PR 6-12a',
            '10pm' => '4-PR 6-12a',
            '11m' => '4-PR 6-12a',
            '12am' => '6-LN 12-3a',
            '1am' => '6-LN 12-3a',
            '2am' => '6-LN 12-3a',
            '3am' => '7-OV 3-6a',
            '4am' => '7-OV 3-6a',
            '5am' => '7-OV 3-6a'
    };

    private static String calculateDaypart(String hourOfDay) {
        return hoursOfDayToDaypartMap.get(hourOfDay);
    }
}