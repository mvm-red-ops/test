/**
 * @date 1/22/2019
 * @description Service class for SpotDataScheduleBatch
 */
public with sharing class SpotDataScheduleService {

  //
  // Constants
  //
  private final static String EMAIL_SUBJECT = 'MV: Apex Spot Data Schedule Batch Job Completion';
  private final static String EMAIL_BODY = 'NOTE: The Spot Data Schedule Batch Process has finished. Please check the Spot Data.\n\n';

  //
  // Fields
  //
  public static SpotDataSelector spotDataSelector { get {
    if (spotDataSelector == null) {
      spotDataSelector = new SpotDataSelector();
    }
    return spotDataSelector;
  } set; }

  public List<Id> spotDataMirrorIdList { get; set; }
  public String network { get; set; }

  /**
   * @description Construct a SpotDataScheduleBatch with a pre-defined spotDataMirrorIdList
   * @param spotDataMirrorIdList The pre-defined spotDataMirrorIdList
   */
  public SpotDataScheduleService(List<Id> spotDataMirrorIdList) {
    this.spotDataMirrorIdList = spotDataMirrorIdList;
  }

  /**
   * @description Construct a SpotDataScheduleBatch with only a network defined.
   *  This will allow the database to create it's own list.
   * @param network The provided network that the list will be created from.
   */
  public SpotDataScheduleService(String network) {
    this.network = (network == 'All') ? '' : network;
  }

  /**
   * @description Retrieve a list of SpotDataMirror__c objects from the provided Map.
   *  This selects a list of Spot_Data__c objects from the database and adds the Mirror to the resulting list if necessary
   * @param mirrorMap The map being compared against
   * @return The resulting list of SpotDataMirror__c objects that need updating
   */
  public static List<SpotDataMirror__c> getMirrorListFromMapNeedingUpdate(Map<String, SpotDataMirror__c> mirrorMap) {
    List<SpotDataMirror__c> result = new List<SpotDataMirror__c>();
    List<Spot_Data__c> spotData = spotDataSelector.getSpotDataFromReferenceMap(mirrorMap);
    Set<String> mirrorIds = new Set<String>();

    // Load SDMList with SpotDataMirrors of SpotData from database
    for (Spot_Data__c SP : spotData) {
      if (mirrorMap.containsKey(SP.SpotDataMirror_Reference__c) && !mirrorIds.contains(SP.SpotDataMirror_Reference__c)) {
        System.debug('SP values - ' + SP.SpotDataMirror_Reference__c + ' - ' + mirrorMap.get(SP.SpotDataMirror_Reference__c).Id);
        mirrorIds.add(SP.SpotDataMirror_Reference__c);
        result.add(loadMirrorFromSpotData(mirrorMap.get(SP.SpotDataMirror_Reference__c).Id, SP));
      }
    }

    return result;
  }

  /**
   * @description Load a list of spot data from a provided scope (of spot data mirrors)
   *  Map the mirrors schedule Id with the SpotDataMirror.
   * @param mirrorMap The map the schedule is being mapped to
   * @param scope The scope being loaded from
   * @return The resulting list of spot data
   */
  public static List<Spot_Data__c> loadSpotDataMirrorMap(Map<String, SpotDataMirror__c> mirrorMap, List<SpotDataMirror__c> scope) {
    List<Spot_Data__c> result = new List<Spot_Data__c>();
    Integer increment = 0;

    // Load mirrors from provided scope
    for (SpotDataMirror__c sdm : scope) {
      if (validSchedule(sdm)) {
        Spot_Data__c spotDataRec = loadSpotDataFromMirror(sdm, increment);
        mirrorMap.put(sdm.Schedule__c + String.valueOf(sdm.Id) + increment, sdm);
        System.debug('map value - ' + (sdm.Schedule__c + String.valueOf(sdm.Id) + increment) + ' - ' + sdm.Id);
        increment++;
        result.add(spotDataRec);
      }
    }

    return result;
  }

  /**
   * Checks a SpotDataMirror__c to verify that is has a valid Schedules__c attached.
   *
   * @param mirror The SpotDataMirror__c to check
   *
   * @return A Boolean representing validity
   */
  public static Boolean validSchedule(SpotDataMirror__c mirror) {
    return mirror.Schedule__c != null
            && mirror.Schedule__r.Rate__c == mirror.Spot_Rate__c
            && mirror.Schedule__r.Deal_Parent__c != null
            && mirror.Schedule__r.Deal_Parent__r.Length__c == mirror.Length__c
            && mirror.Schedule__r.Network_Deal_Number__c == mirror.Network_Deal_Number__c;
  }

  /**
   * @description Load a SpotDataMirror__c from a provided Spot_Data__c object
   * @param referencedSpotDataId The mirror Id provided from the spotData reference
   * @param spotData The spot data being mirrored
   * @return The resulting SpotDataMirror__c object
   */
  public static SpotDataMirror__c loadMirrorFromSpotData(Id referencedSpotDataId, Spot_Data__c spotData) {
    return new SpotDataMirror__c(
        Id = referencedSpotDataId,
        Spot_Data__c = spotData.Id,
        ErrorReason__c = null,
        Schedule__c = spotData.Schedule__c,
        Problem__c = false
    );
  }

  /**
   * @description Load the properties of a SpotData__c object from a SpotDataMirror__c object
   * @param sdm The SpotDataMirror__c being loaded from
   * @param increment The increment provided to the Mirror Reference
   * @return The loaded SpotData__c object
   */
  public static Spot_Data__c loadSpotDataFromMirror(SpotDataMirror__c sdm, Integer increment) {
    return new Spot_Data__c(
        Schedule__c = sdm.Schedule__c,
        X800__c = sdm.X800__c,
        Air_Date__c = sdm.Air_Date__c,
        Air_Time__c = sdm.Air_Time__c,
        Break_Code__c = sdm.Break_Code__c,
        Commercial_Title__c = sdm.Commercial_Title__c,
        House_Number__c = sdm.House_Number__c,
        ISCI__c = sdm.ISCI__c,
        Length__c = sdm.Length__c,
        Line_Number__c = sdm.Line_Number__c,
        Line_Type__c = sdm.Line_Type__c,
        Market__c = sdm.Market__c,
        Plot_End__c = sdm.Plot_End__c,
        Plot_Start__c = sdm.Plot_Start__c,
        Program_ID__c = sdm.Program_ID__c,
        Raycom_Invoice_Number__c = sdm.Raycom_Invoice_Number__c,
        Raycom_Order_Number__c = sdm.Network_Deal_Number__c,
        Spot_Rate__c = sdm.Spot_Rate__c,
        Spot_Status__c = sdm.Spot_Status__c,
        Spot_Type__c = sdm.Spot_Type__c,
        Status__c = sdm.Status__c,
        Time_Period__c = sdm.Time_Period__c,
        SpotDataMirror__c = sdm.Id,
        Error__c = sdm.Error__c,
        SpotDataMirror_Reference__c = sdm.Schedule__c + String.valueOf(sdm.Id) + increment
    );
  }

  /**
   * @description Establish the query for retrieving spot data
   * @return The established query
   */
  public String getSpotDataQuery() {
    String query;
    String fields = SaberGF.GetObjectsFieldsForQueries(SpotDataMirror__c.class.getName()) + ','
            + 'Schedule__r.Rate__c,Schedule__r.Deal_Parent__c,' +
            + 'Schedule__r.Deal_Parent__r.Length__c,' +
            + 'Schedule__r.Network_Deal_Number__c';

    if (spotDataMirrorIdList == null) {
      query = 'SELECT ' + String.escapeSingleQuotes(fields) +
          ' FROM SpotDataMirror__c' +
          ' WHERE Spot_Data__c = null' +
          ' AND Schedule__c != null' +
          ' AND CreatedDate >= LAST_WEEK' +
          ' AND Network__c LIKE \'%' + String.escapeSingleQuotes(this.network) + '%\'';
    } else {
      if (spotDataMirrorIdList.size() > 0) {
        query = 'SELECT ' + String.escapeSingleQuotes(fields) +
            ' FROM SpotDataMirror__c' +
            ' WHERE Id in ' + SaberGF.ReturnDynamicQueryList(spotDataMirrorIdList);
      } else {
        query = 'SELECT ' + String.escapeSingleQuotes(fields) +
            ' FROM SpotDataMirror__c' +
            ' WHERE Spot_Data__c = null' +
            ' AND Schedule__c != null' +
            ' AND CreatedDate >= LAST_WEEK';
      }
    }

    // Batch testing requires query limits of 200
    if (Test.isRunningTest()) {
      query += ' LIMIT 200 ';
    }

    return query;
  }

  /**
   * @description Toggle the PrelogBatchNetworks 'isProcessingSpot' to the desired value
   * @param processingSpot The value being set
   */
  public void updatePrelogBatchNetworksProcessing(Boolean processingSpot) {
    Prelog_Batch_Networks__c current = Prelog_Batch_Networks__c.getValues(this.network);
    current.isProcessingSpot__c = processingSpot;
    update current;
  }

  /**
   * @description Dispatch the processing done email.
   * @param emailAddresses The list of email addresses the processing is being sent to.
   */
  public void dispatchEmail(List<String> emailAddresses) {
    //we should send an email to support with the error.
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setToAddresses(emailAddresses);
    mail.setSubject(EMAIL_SUBJECT);
    mail.setPlainTextBody(EMAIL_BODY);
    try {
      Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
          mail
      });
    } catch (Exception ex) {
      System.debug(ex.getStackTraceString());
    }
  }

  /**
   * @description Process the spot data from the provided mirrors
   * @param scope The SpotDataMirrors the SpotData is being loaded from
   */
  public static void processSpotDataRecords(List<SpotDataMirror__c> scope) {
    Map<String, SpotDataMirror__c> uniqueIdSpotDataMirrorMap = new Map<String, SpotDataMirror__c>();
    List<Spot_Data__c> spotDataList = loadSpotDataMirrorMap(uniqueIdSpotDataMirrorMap, scope);

    // Make sure we have loaded Spot Data
    if (spotDataList.size() > 0) {
      // Insert spot data in database
      insert spotDataList;

      // Load the list of SpotDataMirrors
      List<SpotDataMirror__c> SDMList = getMirrorListFromMapNeedingUpdate(uniqueIdSpotDataMirrorMap);

      // Update mirror list in database
      Database.update(SDMList, false);
    }
  }

}