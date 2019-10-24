/**
* @author Adrian Pichardo
* @date 06/30/2018
* @description APEX Batch class that creates Spot Data for Bundle Availability Schedules. Code is invoked in Process Builder.
*              Process: BundlesSpotsProgram.
**/
global class BundleSpotsBatch implements Database.batchable <sobject>
{

    private static BundleSelector bundleSelector = new BundleSelector();

    public void setBundleSelector(BundleSelector bSelector){
        bundleSelector = bSelector;
    }

    private static ScheduleSelector scheduleSelector = new ScheduleSelector();

    public void setScheduleSelector(ScheduleSelector sSelector){
        scheduleSelector = sSelector;
    }

    private static ProgramSelector programSelector = new ProgramSelector();

    public void setProgramSelector(ProgramSelector pSelector){
        programSelector = pSelector;
    }

    private static SpotDataSelector spotDataSelector = new SpotDataSelector();

    public void setSpotDataSelector(SpotDataSelector sDSelector){
        spotDataSelector = sDSelector;
    }

    global static List<String> listedPrograms = new List<String> {'Raycom Bounce Locals','Raycom Connect','Raycom Connect Extra','Retro Raycom','Hearst Unwired'};
    global String network;
    global class ApplicationException extends Exception {}

    global BundleSpotsBatch(String n)
    {
        if(n == 'All') {
            this.network = '' ;
        } else {
            this.network = n;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<Programs__c> weeksReconciled = programSelector.getProgramsForBundleSpotsBatchStart(network);
        Date week = weeksReconciled[0].Reconciled_Week__c;
        return Database.getQueryLocator([SELECT Id,
                                       	 	    UnitLength__c,
                                       	 	    Week__c
                                           FROM Schedules__c
                                          WHERE DealProgram__c = :network
                                            AND Week__c = :week]);
    }

    global void execute(Database.BatchableContext bc, List<Schedules__c> records){

        if(records.isEmpty()){
            throw new ApplicationException('No Schedules for the Reconciled week listed');
        }
        if(spotsExist(records[0].Id) == 1){
            throw new ApplicationException('Avail Spot Data already exists for this Week');
        }

        Integer i;
        List<Spot_Data__c> spotsToInsert = new List<Spot_Data__c>();

        for(Schedules__c schedule : records){
            spotsToInsert.addAll(BuildSpots(schedule.Id));
        }
        database.insert(spotsToInsert, false);
    }

    global void finish(Database.BatchableContext bc){
        //Necessary for Batch code
    }

    /**
    * @author Adrian Pichardo
    * @date 06/30/2018
    * @description Returns a list of new Spot Data records using a schedule from the start method. Takes Bundle Pricing Units
    *              for each Schedule and creates a Spot Data record accordingly. One Spot Data record corresponds to one Bundle
    *              Pricing Unit.
    * @param Id sch - ID of a Schedule record
    * @return List<Spot_Data__c> - List of new Spot Data that will be inserted into our Salesforce Org in the execute method.
    **/
    global static List<Spot_Data__c> BuildSpots(Id sch)
    {
        List<Spot_Data__c> availSpots  = new List<Spot_Data__c>();
        List<Id> Progid = new List<Id>();
        Integer j;

        Schedules__c[] ssch = scheduleSelector.getSchedulesForBuildSpots(sch);


        Progid.add(ssch[0].Deal_Parent__r.Program__r.Id);
        Bundle_Pricing__c[] bundles = bundleSelector.getBundlePricingForBuildSpots(progid);

        if(ssch[0].UnitLength__c == null){
            throw new ApplicationException('The Units are missing from either the Bundle or the Schedule');
        }

        for(j = 0; j < bundles.size(); j++){
            if(bundles[j].Units__c == null){
                throw new ApplicationException('The Units for the Bundle:' + bundles[j] + ' is empty' );
            }
            if(bundles[j].Rate_per_30__c == null || bundles[j].Units__c == null){
                throw new ApplicationException('The Units or the Rate for the Bundle is empty');
            }
            if(bundles[j].Stationn__c == null){
                throw new ApplicationException('The Stationn for the Bundle is empty');
            }

            String aTime = RandomTime(bundles[j].Start_Time__c);

            Spot_Data__c spot = new Spot_Data__c(
                    Schedule__c = ssch[0].Id,
                    Length__c = String.valueOf((ssch[0].UnitLength__c)*(bundles[j].Units__c)),
                    Spot_Rate__c = bundles[j].Total__c,
                    Stationn__c = bundles[j].Stationn__c,
                    Availability__c = true,
                    Air_Date__c = ssch[0].Week__c,
                    Air_Time__c = aTime
            );
            availSpots.add(spot);
        }

        return availSpots;
    }

    /**
    * @author Adrian Pichardo
    * @date 06/30/2018
    * @description Uses the hour of the start string (parameter) and gives random minutes and seconds for the new time string.
    * @param String start - String of time
    * @return String - new String that corresponds to a time.
    **/
    global static String RandomTime(String start)
    {
        String randomTime = '';
        randomTime = start.left(3) + String.valueOf(Math.random()*60).left(1) + String.valueOf(Math.random()*100).left(1) + ':' + String.valueOf(Math.random()*6).left(1) + String.valueOf(Math.random()*10).left(1) + ' ' + start.right(1) + 'M';
        return randomTime;
    }

    /**
    * @author Adrian Pichardo
    * @date 07/14/2018
    * @description Returns the Integer 1 if Avail Spot Data exists for the record given
    * @param Id sch - ID of a Schedule record
    * @return Integer - Integer that returns 1 if Avail Spots exist.
    **/
    global static Integer spotsExist(Id sch)
    {
        Spot_Data__c[] s = spotDataSelector.getSpotsForSpotsExist(sch);
        if(s.isEmpty()){
            return 0;
        }else{
            return 1;
        }
    }

}