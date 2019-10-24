public with sharing class SaberGF {

    public static String FormatTime(Datetime TimeToFormat, String Format) {
        /*
           Specifier	Type				Example
           Ft			Adds Zeros			1:1:0 to 01:01:00

       */


        String rValue = ''; //Returned String

        if (Format.contains('F')) {
            //Full Time Needed
            if (Format == 'Ft') {
                Format = 'HH:MM:SS'; // 09:09:00
            }

        }

        rValue = Format;

        String sHour = String.valueOf(TimeToFormat.hour());
        String sMinute = String.valueOf(TimeToFormat.minute());
        String sSecond = String.valueOf(TimeToFormat.second());

        rValue = rValue.replace('HH', ((sHour.length() == 1) ? '0' + sHour : sHour));

        rValue = rValue.replace('MM', ((sMinute.length() == 1) ? '0' + sMinute : sMinute));

        rValue = rValue.replace('SS', ((sSecond.length() == 1) ? '0' + sSecond : sSecond));

        return rValue;

    }
    public static String formatDate(Date DateToFormat, String Format) {
        /*
              Specifier         Type                    Example
              Fd                Short Date              10/12/2002
              FD                Long date               December 10, 2002
              FM                Month day pattern       December 10
              FY                Year month pattern      December, 2002
              -------------------------------------------------
              YY                Year                    98
              YYYY              Year                    1998
              MMMM              Month                   January
              MMM               Month                   Jan
              MM                Month                   01
              M                 Month                   1 or 10
              DDDD              Day                     Monday
              DDD               Day                     Mon
              DD                Day                     08
              D                 Day                     8 or 10
        */


        Map<Integer, String> MonthsMap = SaberGF.MonthsMap();
        Map<Integer, String> MonthAbbreviationsMap = SaberGF.MonthAbbreviationsMap();

        String rValue = ''; //Returned String

        if (Format.contains('F')) {
            //Full Date Needed
            if (Format == 'Fd') {
                Format = 'MM/DD/YYYY'; //10/12/2002
            } else if (Format == 'FQD') {
                Format = 'YYYY-MM-DD';
            } else if (Format == 'LFD') {
                Format = 'MMMM DD, YYYY'; //December 10, 2002
            } else if (Format == 'FM') {
                Format = 'MMMM DD'; //December 10
            } else if (Format == 'FY') {
                Format = 'MMMM, YYYY'; //December, 2002
            }
        }


        rValue = Format;

        String sYear = String.valueOf(DateToFormat.year());
        String sMonth = String.valueOf(DateToFormat.month());
        String sDay = String.valueOf(DateToFormat.day());

        if (rValue.contains('YYYY')) {
            rValue = rValue.replace('YYYY', sYear);
        } else if (rValue.contains('YY')) {
            rValue = rValue.replace('YY', sYear.substring(2));
        }

        if (rValue.contains('MMMM')) {
            rValue = rValue.replace('MMMM', MonthsMap.get(Integer.valueOf(sMonth)));
        } else if (rValue.contains('MMM')) {
            rValue = rValue.replace('MMM', MonthsMap.get(Integer.valueOf(sMonth)));
        } else if (rValue.contains('MM')) {
            rValue = rValue.replace('MM', ((sMonth.length() == 1) ? '0' + sMonth : sMonth));
        } else if (rValue.contains('M')) {
            rValue = rValue.replace('M', sMonth);
        }

        if (rValue.contains('DDDD')) {
            rValue = rValue.replace('DDDD', DayOfWeek(DateToFormat, false));
        } else if (rValue.contains('DDD')) {
            rValue = rValue.replace('DDD', DayOfWeek(DateToFormat, true));
        } else if (rValue.contains('DD')) {
            rValue = rValue.replace('DD', ((sDay.length() == 1) ? '0' + sDay : sDay));
        } else if (rValue.contains('D')) {
            rValue = rValue.replace('D', sDay);
        }
        return rValue;

    }

    public static String DayOfWeek(Date d, Boolean UseAbbreviation) {
        Integer C2 = d.day();
        Integer C3 = d.month();
        Integer C4 = d.year();
        Integer a = (1461 * (C4 + 4800 + (C3 - 14) / 12)) / 4 + (367 * (C3 - 2 - 12 * ((C3 - 14) / 12))) / 12 - (3 * ((C4 + 4900 + (C3 - 14) / 12) / 100)) / 4 + C2 - 32075;
        Integer b = Math.mod(a, 7);
        Map<Integer, String> DaysOfWeek = (UseAbbreviation) ? SaberGF.DaysOfWeekAbbreviationsMap() : SaberGF.DaysOfWeekMap();
        return DaysOfWeek.get(b);
    }

    public static Map<Integer, String> DaysOfWeekMap() {
        Map<Integer, String> DaysOfWeek = new Map<Integer, String>();
        DaysOfWeek.put(0, 'Monday');
        DaysOfWeek.put(1, 'Tuesday');
        DaysOfWeek.put(2, 'Wednesday');
        DaysOfWeek.put(3, 'Thursday');
        DaysOfWeek.put(4, 'Friday');
        DaysOfWeek.put(5, 'Saturday');
        DaysOfWeek.put(6, 'Sunday');
        return DaysOfWeek;
    }
    public static Map<Integer, String> DaysOfWeekAbbreviationsMap() {
        Map<Integer, String> DaysOfWeek = new Map<Integer, String>();
        DaysOfWeek.put(0, 'Mon');
        DaysOfWeek.put(1, 'Tue'); //Tu., Tue., or  Tues.
        DaysOfWeek.put(2, 'Wed');
        DaysOfWeek.put(3, 'Thur'); //Th., Thu., Thur., or Thurs.
        DaysOfWeek.put(4, 'Fri');
        DaysOfWeek.put(5, 'Sat');
        DaysOfWeek.put(6, 'Sun');
        return DaysOfWeek;
    }

    public static Map<Integer, String> MonthsMap() {
        Map<Integer, String> MonthsMap = new Map<Integer, String>();
        MonthsMap.put(1, 'January');
        MonthsMap.put(2, 'February');
        MonthsMap.put(3, 'March');
        MonthsMap.put(4, 'April');
        MonthsMap.put(5, 'May');
        MonthsMap.put(6, 'June');
        MonthsMap.put(7, 'July');
        MonthsMap.put(8, 'August');
        MonthsMap.put(9, 'September');
        MonthsMap.put(10, 'October');
        MonthsMap.put(11, 'November');
        MonthsMap.put(12, 'December');
        return MonthsMap;
    }

    public static Map<Integer, String> MonthAbbreviationsMap() {
        Map<Integer, String> MonthAbbreviationsMap = new Map<Integer, String>();
        MonthAbbreviationsMap.put(1, 'Jan');
        MonthAbbreviationsMap.put(2, 'Feb');
        MonthAbbreviationsMap.put(3, 'Mar');
        MonthAbbreviationsMap.put(4, 'Apr');
        MonthAbbreviationsMap.put(5, 'May');
        MonthAbbreviationsMap.put(6, 'Jun');
        MonthAbbreviationsMap.put(7, 'Jul');
        MonthAbbreviationsMap.put(8, 'Aug');
        MonthAbbreviationsMap.put(9, 'Sept'); //Or Sep
        MonthAbbreviationsMap.put(10, 'Oct');
        MonthAbbreviationsMap.put(11, 'Nov');
        MonthAbbreviationsMap.put(12, 'Dec');
        return MonthAbbreviationsMap;
    }

    public static String GetValue(String s) {
        return (s == null) ? '' : s;
    }

    public static Decimal GetValue(Decimal d) {
        return (d == null) ? 0 : d;
    }
    public static String CurrencyFormat(Decimal d) {
        if (d == null) {
            return '$0.00';
        } else {
            d = d.setScale(2);
            String str = d.format();

            if (!(str.indexOf('.') > -1)) {
                str += '.00';
            } else if (str.substring(str.indexOf('.')).length() == 2) {
                str += '0';
            }

            return '$' + str;
        }
    }


    public static List<SelectOption> GetObjectsFields(String ObjectName, Boolean OrderByLabel, Boolean IncludeBrackets, Boolean ExcludeSystemFields) {

        /*
        <apex:selectList size="1">
              <apex:selectOptions value="{!FieldsOfObject}"/>
        </apex:selectList>
        */

        Set<String> SystemFields = new Set<String>();
        SystemFields.add('CreatedById');
        SystemFields.add('CreatedDate');
        SystemFields.add('Id');
        SystemFields.add('IsDeleted');
        SystemFields.add('LastModifiedById');
        SystemFields.add('LastModifiedDate');
        SystemFields.add('OwnerId');
        SystemFields.add('SystemModstamp');

        List<SelectOption> out = new List<SelectOption>();
        out.add(new SelectOption('', 'Please Choose'));

        try {
            /*
            String ObjectName = 'Account'; // Object Name Goes Here
            Boolean OrderByLabel = true; //Order Results by Label
            */

            Map<String, Schema.SObjectField> ObjectFieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();

            //The returned map is ordered by the date/time it the field was created
            List<String> OrderedListOfFieldNames = SaberGF.GetOrderedListOfFieldNames(ObjectFieldMap, OrderByLabel);

            for (String s : OrderedListOfFieldNames) {
                Schema.DescribeFieldResult field = ObjectFieldMap.get(s).getDescribe();

                //Check if the logged in user has access
                if (field.isAccessible()) {
                    Boolean OkToAddToList = true;
                    if (ExcludeSystemFields) {
                        OkToAddToList = (SystemFields.contains(field.getName())) ? false : true;
                    }
                    if (OkToAddToList) {
                        String FieldName = (IncludeBrackets) ? '{!' + field.getName() + '}' : field.getName();
                        if (OrderByLabel) {
                            out.add(new SelectOption(FieldName, field.getLabel()));
                        } else {
                            out.add(new SelectOption(FieldName, field.getName()));
                        }
                    }
                }
            }

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return out;

    }

    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName) {
        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.fieldSets.getMap().get(fieldSetName);

        return fieldSetObj.getFields();
    }

    public static List<String> getObjectsFieldsForQueriesFromFieldSet(String objectName, String fieldSetName) {
        List<String> fields = new List<String>();
        try {
            List<Schema.FieldSetMember> fieldSetMemberList = readFieldSet(fieldSetName, objectName);
            for (Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList) {
                fields.add(fieldSetMemberObj.getFieldPath());
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return fields;
    }

    public static String GetObjectsFieldsForQueries(String ObjectName) {
        /*
        <apex:selectList size="1">
              <apex:selectOptions value="{!FieldsOfObject}"/>
        </apex:selectList>
        */

        String SystemFields = '';
        try {
            /*
            String ObjectName = 'Account'; // Object Name Goes Here
            Boolean OrderByLabel = true; //Order Results by Label
            */

            Map<String, Schema.SObjectField> ObjectFieldMap = Schema.getGlobalDescribe().get(ObjectName).getDescribe().fields.getMap();

            //The returned map is ordered by the date/time it the field was created
            List<String> OrderedListOfFieldNames = SaberGF.GetOrderedListOfFieldNames(ObjectFieldMap, true);

            for (String s : OrderedListOfFieldNames) {
                Schema.DescribeFieldResult field = ObjectFieldMap.get(s).getDescribe();

                //Check if the logged in user has access
                //Red Argyle - remove large Schedule formula fields from the final String in order to decrease the 64k Oracle SQL limit
                if (field.isAccessible() && (ObjectName != 'Schedules__c' || (field.getName() != 'X2Calculated_Time_Period__c' && field.getName() != 'X30_Rate_Round__c' && field.getName() != 'LF_Daypart__c' && field.getName() != 'Quarter_Change__c' && field.getName() != 'Week_in_Quarter__c' && field.getName() != 'Quarter__c' && field.getName() != 'Increvenue__c' && field.getName() != 'Booked_Increvenue__c' && field.getName() != 'New_Filler__c' && field.getName() != 'Week_in_Year__c' && field.getName() != 'EUR_Filler_Decile__c' && field.getName() != 'Filler_Rate__c' && field.getName() != 'Missing_Long_Form_Traffic__c' && field.getName() != 'Missing_Long_Form_Traffic_Current__c'))) {
                    SystemFields += field.getName() + ',';
                }
            }
            SystemFields = SystemFields.substring(0, SystemFields.length() - 1);
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return SystemFields;

    }

    /*******************************************************
    * ObjectFieldMap - Map of Fields from getDescribe
    * pOrderByLabel - Boolean; true=Order by the Label, False = Order by the Field's Name
    ********************************************************/
    public static List<String> GetOrderedListOfFieldNames(Map<String, Schema.SObjectField> ObjectFieldMap, Boolean pOrderByLabel) {
        List<String> OrderedListOfFieldNames = new List<String>();

        try {
            if (pOrderByLabel) {
                List<String> TempOrderedListOfFieldNames = new List<String>();
                for (String s : ObjectFieldMap.keySet()) {
                    Schema.DescribeFieldResult F = ObjectFieldMap.get(s).getDescribe();
                    TempOrderedListOfFieldNames.add(F.getLabel() + '~' + F.getName());
                }

                TempOrderedListOfFieldNames.sort();
                for (String s : TempOrderedListOfFieldNames) {
                    OrderedListOfFieldNames.add(s.split('~')[1]);
                }
            } else {
                for (String s : ObjectFieldMap.keySet()) {
                    Schema.DescribeFieldResult F = ObjectFieldMap.get(s).getDescribe();
                    OrderedListOfFieldNames.add(F.getName());
                }

                OrderedListOfFieldNames.sort();

            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }

        return OrderedListOfFieldNames;
    }


    public static String TemplateToString(String Template, String sObjecType, String ObjId, Boolean FormatsObjectGetResults) {
        System.debug('Template---' + Template);
        System.debug('sObjecType---' + sObjecType);
        System.debug('ObjId---' + ObjId);
        System.debug('FormatsObjectGetResults---' + FormatsObjectGetResults);

        //Get valid fields for the object
        Map<String, Schema.SObjectField> ObjFields = Schema.getGlobalDescribe().get(sObjecType).getDescribe().fields.getMap();


        //Use a map to put Schema.DescribeFieldResult's in. We use a map so we don't have to run a DescribeFieldResult command on the same field twice.
        Map<String, Schema.DescribeFieldResult> DescribeFieldResults = new Map<String, Schema.DescribeFieldResult>();


        //Map of fields that need to be replaced in the template
        Map<String, String> FieldsToReplace = new Map<String, String>();

        //This is the query string we must generate
        String DynamicQryStr = 'SELECT ';


        //We use a regular expression to find fields enclosed in "{!}""
        Template = Template.replace('{!Date.Today()}', formatDate(Date.today(), 'LFD'));
        Pattern sPattern = Pattern.compile('\\{!(.*?)\\}');
        Matcher TbStr = sPattern.matcher(Template);

        while (TbStr.find()) {
            String TempFieldName = TbStr.group();

            //Take away the "{!" and "}"
            String FieldName = TempFieldName.replace('{!', '').replace('}', '');

            //Check if Field is a valid field for the object
            if (ObjFields.containsKey(FieldName)) {
                /*Field is Valid*/

                //Check to Make sure field doesn't already exists in FieldsToReplace Map
                if (!FieldsToReplace.containsKey(TempFieldName)) {
                    /*Field Doesn't Exists, Process The Field*/

                    /*Check if Field is Reference, if so get the "Name" field of the parent object*/
                    //First check if a DescribeFieldResult has been called on the field, if not call one.
                    Schema.DisplayType FieldDisplayType = null;
                    Schema.DescribeFieldResult DesFieldResult = null;

                    if (DescribeFieldResults.containsKey(FieldName)) {
                        DesFieldResult = DescribeFieldResults.get(FieldName);
                        FieldDisplayType = DesFieldResult.getType();
                    } else {
                        DesFieldResult = ObjFields.get(FieldName).getDescribe();

                        //Place in Map incase needed again
                        DescribeFieldResults.put(FieldName, DesFieldResult);

                        FieldDisplayType = DesFieldResult.getType();
                    }

                    //Check if Field is Accessible
                    if (DesFieldResult.isAccessible()) {
                        /*User Has Access*/

                        if (FieldDisplayType == Schema.DisplayType.REFERENCE) {
                            /*Is Reference Field*/

                            //Add to FieldsToReplace; but put a "~" to symbolize it is a reference field
                            FieldsToReplace.put(TempFieldName, FieldName + '~');

                            //Get Relationship Name and append "Name", example AccountId -> Account.Name
                            //Add Field to Dynamic Qry
                            DynamicQryStr += DescribeFieldResults.get(FieldName).getRelationshipName() + '.Name' + ',';
                        } else {
                            FieldsToReplace.put(TempFieldName, FieldName);

                            //Add Field to Dynamic Qry
                            DynamicQryStr += FieldName + ',';
                        }
                    }


                }
            }


        }

        //Take away last "," in the DynamicQryStr qry
        DynamicQryStr = DynamicQryStr.substring(0, DynamicQryStr.length() - 1);

        //Add FROM and WHERE Clause to DynamicQryStr
        DynamicQryStr += ' FROM ' + sObjecType + ' WHERE Id=\'' + ObjId + '\'';

        System.debug('DynamicQryStr:' + DynamicQryStr);

        //Qry the Database, use sObject becuase you what object you are querying against when writing this function
        for (SObject sObjectQryResult : Database.query(DynamicQryStr)) {

            //Loop through the FieldsToReplace Keyset
            for (String TempFieldToReplace : FieldsToReplace.keySet()) {

                //try
                //{
                String FieldName = FieldsToReplace.get(TempFieldToReplace);

                String ValueToReplaceTemplateWith = '';

                Object QtyFieldResult = null;

                if (FieldName.contains('~')) {
                    //Is Reference Field
                    QtyFieldResult = sObjectQryResult.getSObject(DescribeFieldResults.get(FieldName.replace('~', '')).getSobjectField()).get('Name');
                } else {
                    //Not a Reference Field
                    QtyFieldResult = sObjectQryResult.get(FieldName);
                }


                if (FormatsObjectGetResults) {
                    ValueToReplaceTemplateWith = SaberGF.FormatsObjectGetResult(DescribeFieldResults.get(FieldName), QtyFieldResult);
                } else {
                    ValueToReplaceTemplateWith = (QtyFieldResult == null) ? '' : String.valueOf(QtyFieldResult);
                }

                Template = Template.replace(TempFieldToReplace, ValueToReplaceTemplateWith);
                /*
                }
                catch (Exception e)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Error,e.getMessage()));

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                    string EmailSubject = 'CR Onsrud | Error | Class.SaberGF.TemplateToString';

                    string HTMLBody = '';

                    HTMLBody += '<br /><br /><table cellpadding="3">';

                    HTMLBody += '<tr><td><b>Error</b></td><td>'		+ e.getMessage() 		+ '</td></tr>';
                    HTMLBody += '<tr><td><b>Template</b></td><td>' 	+ Template 				+ '</td></tr>';
                    HTMLBody += '<tr><td><b>Object Id</b></td><td>' + ObjId 				+ '</td></tr>';
                    HTMLBody += '<tr><td><b></b></td><td>' 			+ TempFieldToReplace 	+ '</td></tr>';
                    HTMLBody += '</table>';

                    mail.setToAddresses(new string[]{'bbrantly@sabersolutions.com'});
                    mail.setReplyTo('bbrantly@sabersolutions.com');
                    mail.setSenderDisplayName('CR Onsrud Error');
                    mail.setSubject(EmailSubject);
                    mail.setUseSignature(false);
                    mail.setHtmlBody(HTMLBody);

                    Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
                */
            }

        }

        return Template;

    }

    public static String FormatsObjectGetResult(Schema.DescribeFieldResult F, Object Obj) {
        String ObjectValue = (Obj == null) ? '' : String.valueOf(Obj);
        if (F.getType() == Schema.DisplayType.BOOLEAN) {
            ObjectValue = (ObjectValue.toLowerCase() == 'false') ? 'FALSE' : 'TRUE';
        } else if (F.getType() == Schema.DisplayType.CURRENCY) {
            if (ObjectValue == '') {
                ObjectValue = SaberGF.CurrencyFormat(0.00);
            } else {
                ObjectValue = SaberGF.CurrencyFormat(Decimal.valueOf(ObjectValue));
            }
        } else if (F.getType() == Schema.DisplayType.DATE) {
            if (ObjectValue != '') {
                String sDay = Date.valueOf(ObjectValue).day().format();
                String sMonth = Date.valueOf(ObjectValue).month().format();
                String sYear = Date.valueOf(ObjectValue).year().format();

                if (sDay.length() == 1) {
                    sDay = '0' + sDay;
                }
                if (sMonth.length() == 1) {
                    sMonth = '0' + sMonth;
                }

                ObjectValue = Date.valueOf(ObjectValue).format();
            }
        } else if (F.getType() == Schema.DisplayType.DATETIME) {
            if (ObjectValue != '') {
                ObjectValue = Datetime.valueOf(ObjectValue).format();
            }
        } else if (F.getType() == Schema.DisplayType.PERCENT) {
            ObjectValue = (ObjectValue != '') ? ObjectValue + '%' : '';
        } else if (F.getType() == Schema.DisplayType.TEXTAREA) {
            ObjectValue = ObjectValue.replace('\n', '<br />');
        }


        return ObjectValue;
    }
    public static String ReturnDynamicQueryList(List<String> StringList) {
        try {
            String QueryList = '(';
            if (StringList != null) {
                if (StringList.size() > 0) {
                    for (String pString : StringList) {
                        QueryList += '\'' + pString + '\',';
                    }
                    if (QueryList.endsWith(',')) {
                        QueryList = QueryList.substring(0, QueryList.length() - 1) + ')';
                    }
                } else {
                    return '(\'\')';
                }
            } else {
                return '(\'\')';
            }
            return QueryList;
        } catch (Exception ex) {
            System.debug('Error - ' + ex.getMessage());
            System.debug('Line Number - ' + ex.getLineNumber());
            return null;
        }
    }
    public static String ReturnDynamicQueryList(Set<String> StringList) {
        try {
            String QueryList = '(';
            if (StringList != null) {
                if (StringList.size() > 0) {
                    for (String pString : StringList) {
                        QueryList += '\'' + pString + '\',';
                    }
                    if (QueryList.endsWith(',')) {
                        QueryList = QueryList.substring(0, QueryList.length() - 1) + ')';
                    }
                } else {
                    return '(\'\')';
                }
            } else {
                return '(\'\')';
            }
            return QueryList;
        } catch (Exception ex) {
            System.debug('Error - ' + ex.getMessage());
            System.debug('Line Number - ' + ex.getLineNumber());
            return null;
        }
    }
}