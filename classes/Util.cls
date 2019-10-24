//@author : Cloudtrigger, Inc.
//@date : 11/5/2012
//@description : Class of common methods that facilitate 
global class Util
{
    static final String CLASSNAME = '\n\n Util';

	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a String is NULL or has zero length ("empty")
	//@paramaters : a String to evaluate
	//@returns : a Boolean indicating if a String has an actual value or not
    global static Boolean StringIsNullOrEmpty(String pStringToValidate)
    {
        String METHODNAME = CLASSNAME + '.StringIsNullOrEmpty(String pStringToValidate)';
        //system.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n ', '\n\n Inside ') + ' :: String to validate = ' + pStringToValidate +'\n\n');
        Boolean returnValue = (pStringToValidate == null);
		if (!returnValue) {
			returnValue = (pStringToValidate.trim().equals(''));
		}
        return returnValue;
    }

	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to evaluate a String and return a default value if the String is invalid
	//@paramaters : a String to evaluate & a String to use as the default value if needed
	//@returns : a String representing the String that was passed in OR a default value if the String is NUll/Empty
    global static String StringGetValueOrDefault(String pStringToValidate, String pDefaultValue)
    {
        String METHODNAME = CLASSNAME + '.StringGetValueOrDefault(String pStringToValidate, String pDefaultValue)';
        System.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n ', '\n\n Inside ') + ' :: String to validate = ' + pStringToValidate + ' and Default = '+ pDefaultValue +'\n\n');
        String returnValue = pDefaultValue;
		if (Util.StringIsNullOrEmpty(pStringToValidate) == false) {
			returnValue = pStringToValidate;
		}
        return returnValue;
    }   
     
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : 
	//@paramaters : none
	//@returns : a Boolean representing ...
	global static Boolean ValidateSaveresultList(List<Database.SaveResult> pResults)
    {
        String METHODNAME = CLASSNAME + '.ValidateSaveresultList(list<Database.Saveresult> pResults)';
        System.debug(LoggingLevel.INFO, METHODNAME.replace('\n\n ', '\n\n Inside ') + ' :: pResults.size() = ' + pResults.size() + '\n\n');
        Boolean returnValue = true;
        for(Integer iLoop = 0;iLoop<pResults.size();iLoop++)
        {
        	System.debug(LoggingLevel.INFO, METHODNAME + ' :: Result #' + iLoop + ' isSuccess() = '+ pResults[iLoop].isSuccess() +'\n\n');
        	if(pResults[iLoop].isSuccess() == false)
        	{
        		returnValue = false;
        		break;
        	}
        }
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of Objects is populated or not
	//@paramaters : collection of Objects
	//@returns : a Boolean indicating if the collection of Objects is populated or not
    global static Boolean ValidateList(List<Object> pList)
    {
        String METHODNAME = CLASSNAME + '.ValidateList(list<object>)';
        Boolean returnValue = true;
        if(pList == null){return false;}
        if(pList.size() < 1){return false;}
        if(pList.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of SObjects is populated or not
	//@paramaters : collection of SObjects
	//@returns : a Boolean indicating if the collection of SObjects is populated or not
    global static Boolean ValidateList(List<SObject> pList)
    {
        String METHODNAME = CLASSNAME + '.ValidateList(list<sObject>)';
        Boolean returnValue = true;
        if(pList == null){return false;}
        if(pList.size() < 1){return false;}
        if(pList.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of key/value pairs - SObjects and their IDs - is populated or not
	//@paramaters : a collection of key/value pairs - SObjects and their IDs
	//@returns : a Boolean indicating if the collection of key/value pairs is populated or not
    global static Boolean ValidateMap(Map<Id, SObject> pMap)
    {
        String METHODNAME = CLASSNAME + '.ValidateMap(map<Id, SObject>)';
        Boolean returnValue = true;
        if(pMap == null){return false;}
        if(pMap.size() < 1){return false;}
        if(pMap.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of key/value pairs is populated or not
	//@paramaters : a collection of key/value pairs
	//@returns : a Boolean indicating if the collection of key/value pairs is populated or not
    global static Boolean ValidateMap(Map<String, Id> pMap)
    {
        String METHODNAME = CLASSNAME + '.ValidateMap(map<String, Id>)';
        Boolean returnValue = true;
        if(pMap == null){return false;}
        if(pMap.size() < 1){return false;}
        if(pMap.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of Strings is populated or not
	//@paramaters : a collection of Strings
	//@returns : a Boolean indicating if the collection of Strings is populated or not
    global static Boolean ValidateSet(Set<String> pSet)
    {
        String METHODNAME = CLASSNAME + '.ValidateSet(Set<String> pSet)';
        Boolean returnValue = true;
        if(pSet == null){return false;}
        if(pSet.size() < 1){return false;}
        if(pSet.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of Integers is populated or not
	//@paramaters : a collection of Integers
	//@returns : a Boolean indicating if the collection of Integers is populated or not
    global static Boolean ValidateSet(Set<Integer> pSet)
    {
        String METHODNAME = CLASSNAME + '.ValidateSet(Set<Integer> pSet)';
        Boolean returnValue = true;
        if(pSet == null){return false;}
        if(pSet.size() < 1){return false;}
        if(pSet.isEmpty()){return false;}
        return returnValue;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if a collection of IDs is populated or not
	//@paramaters : a collection of IDs
	//@returns : a Boolean indicating if the collection of IDs is populated or not
    global static Boolean ValidateSet(Set<Id> pSet)
    {
        String METHODNAME = CLASSNAME + '.ValidateSet(Set<Id> pSet)';
        Boolean returnValue = true;
        if(pSet == null){return false;}
        if(pSet.size() < 1){return false;}
        if(pSet.isEmpty()){return false;}
        return returnValue;
    }

	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to determine if an Object is found in a collection of Objects
	//@paramaters : an Object to search for, and a collection of Objects to evaluate
	//@returns : a Boolean indicating if the Object param is found in the collection of Objects
    global static Boolean ExistsInList(Object toSearchFor, List<Object> listOfAny)
    {       
        Boolean returnVal = false;
        for(Object a : listOfAny)
        {
            returnVal = (a == toSearchFor);
            if(returnVal) break;
        }
        return returnVal;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to build a delimited string of IDs for use in an 'IN' clause as part of a SOQL query from a Set of IDs
	//@paramaters : a String representing the character to use as a separator, and a collection ('Set') of sObject IDs
	//@returns : a delimited String of IDs 
    global static String BuildStringOfIDsForInClause(Set<Id> pIds, String pSeparatorChar)
    {
    	String returnVal = '';
        //for(Integer iLoop = 0; iLoop <  pIds.size(); iLoop++)
        Integer iLoop = 0;
        for(Id i:pIds)
        {
        	returnVal += '\'' + i + '\'';
			if (iLoop < (pIds.size() - 1)) {
				returnVal += pSeparatorChar;
			}
        	iLoop++;
        }

    	return returnVal;
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to build a delimited string of IDs for use in an 'IN' clause as part of a SOQL query from a List of IDs
	//@paramaters : a String representing the character to use as a separator, and a list of sObjects
	//@returns : a delimited String of IDs 
    global static String BuildStringOfIDsForInClause(List<SObject> pSObjects, String pSeparatorChar)
    {
    	String returnVal = '';
        for(Integer iLoop = 0; iLoop <  pSObjects.size(); iLoop++)
        {
        	returnVal += '\'' + pSObjects[iLoop].Id + '\'';
			if (iLoop < (pSObjects.size() - 1)) {
				returnVal += pSeparatorChar;
			}
        }

    	return returnVal;
    }

	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to get a RecordType ID from its Name
	//@paramaters : a String representing a RecordType Name
	//@returns : a String representing the RecordType ID based on the RecordType Name param
    global static String GetRecordTypeIdByRecordTypeName(String pRecordTypeName)
    {
    	Map<Id, RecordType> RecordTypeMap = Util.GetRecordTypeMapBySobjectType('');
    	return GetRecordTypeIdByRecordTypeName(RecordTypeMap, pRecordTypeName);
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to get a RecordType ID from its Name based on SObject type (i.e. "Account")
	//@paramaters : a String representing a RecordType Name and a String representing the Sobject Name (i.e. "Account")
	//@returns : a String representing the RecordType ID based on the params
	//@sample: GetRecordTypeIdBySobjectTypeAndRecordTypeName('Account', 'Prospect')
    global static String GetRecordTypeIdBySobjectTypeAndRecordTypeName(String pSobjectType, String pRecordTypeName)
    {
    	Map<Id, RecordType> RecordTypeMap = Util.GetRecordTypeMapBySobjectType(pSobjectType);
    	return GetRecordTypeIdByRecordTypeName(RecordTypeMap, pRecordTypeName);
    }
    
	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : method to get a RecordType ID from its Name
	//@paramaters : a collection of key/value pairs - RecordTypes & their IDs - and a String representing a RecordType Name
	//@returns : a String representing a RecordType ID based on the RecordType's Name
    private static String GetRecordTypeIdByRecordTypeName(Map<Id, RecordType> pRecordTypeMap, String pRecordTypeName)
    {
    	// NOTE: there might be multiple RecordTypes with the same name but for different objects, so need to check for multiple
    	Integer NumberOfMatchesOnName = 0;
    	String returnValue;
    	for(String key : pRecordTypeMap.keySet())
    	{
    		RecordType rt = pRecordTypeMap.get(key);
    		if(rt.Name.equals(pRecordTypeName))
    		{
    			returnValue = rt.Id;
    			NumberOfMatchesOnName++;
    		}
    	}
		if (NumberOfMatchesOnName < 2) {
			return returnValue;
		}
	   	else
	   	{
	   		return 'MULTIPLE RECORDTYPES WITH THAT NAME';
	   	}
    }

	//@author : Cloudtrigger, Inc.
	//@date : 11/5/2012
	//@description : 
	//@paramaters : a String representing the name of the SObject we want RecordTypes for (i.e. "Account")
	//@returns : a collection of key/value pairs - the RecordTypes & their IDs - for the type of object passed in
	//			OR
	//			a collection of key/value pairs - the RecordTypes & their IDs - for ALL ACTIVE RecordTypes
    public static Map<Id, RecordType> GetRecordTypeMapBySobjectType(String pSobjectType)
    {
    	Map<Id, RecordType> RecordTypeMap = (Util.StringIsNullOrEmpty(pSobjectType))
    										? (new Map<Id, RecordType>([SELECT r.BusinessProcessId, r.Description, r.DeveloperName, r.Id, r.IsActive, r.Name, r.NamespacePrefix, r.SobjectType FROM RecordType r WHERE r.IsActive = TRUE]))
    										: (new Map<Id, RecordType>([SELECT r.BusinessProcessId, r.Description, r.DeveloperName, r.Id, r.IsActive, r.Name, r.NamespacePrefix, r.SobjectType FROM RecordType r WHERE r.IsActive = TRUE AND r.SobjectType = :pSobjectType]));
    	
    	return RecordTypeMap;
    }
    
	global static Set<Id> GetRoleSubordinateUserIds(Id pUserId)
	{
	    // get requested user's role
	    Id roleId = [SELECT UserRoleId FROM User WHERE Id = :pUserId].UserRoleId;
	    
	    // get all of the roles underneath the user
	    Set<Id> allSubRoleIds = GetAllSubRoleIds(new Set<Id>{roleId});
	    
	    // get all of the ids for the users in those roles
	    Map<Id,User> users = new Map<Id, User>([SELECT Id, Name, FirstName, LastName FROM User WHERE UserRoleId IN :allSubRoleIds ORDER BY FirstName ASC]);
	    
	    // return the ids as a set so you can do what you want with them
	    return users.keySet();
	}
 
	global static Map<Id,User> GetRoleSubordinateUserMap(Id pUserId)
	{
	    // get requested user's role
	    Id roleId = [SELECT UserRoleId FROM User WHERE Id = :pUserId].UserRoleId;
	    
	    // get all of the roles underneath the user
	    Set<Id> allSubRoleIds = GetAllSubRoleIds(new Set<Id>{roleId});
	    
	    // get all of the ids for the users in those roles
	    Map<Id,User> users = new Map<Id, User>([SELECT Id, Name, FirstName, LastName FROM User WHERE UserRoleId IN :allSubRoleIds ORDER BY FirstName ASC]);
	    
	    // return the IDs & Users as a map so you can do what you want with them
	    return users;
		
	}
	
 
	global static List<User> GetRoleSubordinateUserList(Id pUserId)
	{
	    // get requested user's role
	    Id roleId = [SELECT UserRoleId FROM User WHERE Id = :pUserId].UserRoleId;
	    
	    // get all of the roles underneath the user
	    Set<Id> allSubRoleIds = GetAllSubRoleIds(new Set<Id>{roleId});
	    
	    // get all of the ids for the users in those roles
	    //map<Id,User> users = new map<Id, User>([SELECT Id, Name, FirstName, LastName FROM User WHERE UserRoleId IN :allSubRoleIds ORDER BY FirstName ASC]);
	    List<User> users = [SELECT Id, Name, FirstName, LastName FROM User WHERE UserRoleId IN :allSubRoleIds ORDER BY LastName, FirstName ASC];
	    
	    return users;
		
	}

	private static Set<Id> GetAllSubRoleIds(Set<Id> pRoleIds)
	{
	    Set<Id> currentRoleIds = new Set<Id>();
	 
	    // get all of the roles underneath the passed roles
		for (UserRole userRole : [SELECT Id FROM UserRole WHERE ParentRoleId IN :pRoleIds AND ParentRoleId != NULL]) {
			currentRoleIds.add(userRole.Id);
		}
	 
	    // go fetch some more rolls!
		if (currentRoleIds.size() > 0) {
			currentRoleIds.addAll(GetAllSubRoleIds(currentRoleIds));
		}
	 
	    return currentRoleIds;
	}
	
	public static Boolean LimitsCheckScriptStatementsOK()
	{
		String METHODNAME = CLASSNAME + '.LimitsCheckScriptStatementsOK()';
		System.debug(LoggingLevel.INFO, METHODNAME + ' :: Script Statements Limit is '+ Limits.getLimitScriptStatements() +' and Heap Size so far is '+ Limits.getHeapSize() +'.\n\n');
		return (Limits.getScriptStatements() < Limits.getLimitScriptStatements());
	}
	
	public static Boolean LimitsCheckDmlStatementsOK()
	{
		String METHODNAME = CLASSNAME + '.LimitsCheckDmlStatementsOK()';
		System.debug(LoggingLevel.INFO, METHODNAME + ' :: Dml Statements Limit is '+ Limits.getLimitDmlStatements() +' and Heap Size so far is '+ Limits.getHeapSize() +'.\n\n');
		return (Limits.getDmlStatements() < Limits.getLimitDmlStatements());
	}
	
	public static Boolean LimitsCheckDmlRowsOK()
	{
		String METHODNAME = CLASSNAME + '.LimitsCheckDmlRowsOK()';
		System.debug(LoggingLevel.INFO, METHODNAME + ' :: Dml Rows Limit is '+ Limits.getLimitDmlRows() +' and Heap Size so far is '+ Limits.getHeapSize() +'.\n\n');
		return (Limits.getDmlRows() < Limits.getLimitDmlRows());
	}
	
	public static Boolean LimitsCheckQueriesOK()
	{
		String METHODNAME = CLASSNAME + '.LimitsCheckQueriesOK()';
		System.debug(LoggingLevel.INFO, METHODNAME + ' :: Queries Limit is '+ Limits.getLimitQueries() +' and Heap Size so far is '+ Limits.getHeapSize() +'.\n\n');
		return (Limits.getQueries() < Limits.getLimitQueries());
	}
	
	public static Boolean LimitsCheckHeapSizeOK()
	{
		String METHODNAME = CLASSNAME + '.LimitsCheckHeapSizeOK()';
		System.debug(LoggingLevel.INFO, METHODNAME + ' :: Heap Size Limit is '+ Limits.getLimitHeapSize() +' and Heap Size so far is '+ Limits.getHeapSize() +'.\n\n');
		//return (Limits.getHeapSize() < (Limits.getLimitHeapSize()*0.98));
		return (Limits.getHeapSize() < Limits.getLimitHeapSize());
	}

/* =============================================  TEST METHODS  ============================================= */

    static testMethod void test_GetGetRoleSubordinateUsers()
    {
    	//Set<ID> UserIds = Util.GetRoleSubordinateUsers(userId);
    	
    }
    
    static testMethod void test_GetRecordTypeIdByRecordTypeName()
    {
		List<RecordType> types = [SELECT
									  r.SobjectType
									, r.NamespacePrefix
									, r.Name
									, r.IsActive
									, r.Id
									, r.DeveloperName
									, r.Description
									, r.BusinessProcessId
								FROM
									RecordType r
								WHERE
									r.IsActive = TRUE];
        
        RecordType rt;
        if(ValidateList(types))
        {
        	rt = types[0];
	    	System.assert(rt.Id != null);
	    	System.debug(LoggingLevel.INFO, 'RecType ID ' + rt.Id + '\n\n RecType.Name = '+ rt.Name +'\n\n');
	    	String returnedId = GetRecordTypeIdByRecordTypeName(rt.Name);
	    	System.debug(LoggingLevel.INFO, 'RecType ID ' + rt.Id + '\n\n returnedId = ' + returnedId +'\n\n');
	    	if(returnedId.equals('MULTIPLE RECORDTYPES WITH THAT NAME')){
	    		System.assert(true);
	    	} else {
				System.assert(rt.Id == returnedId);
			}
        }
   	
    }

    static testMethod void test_GetRecordTypeIdBySobjectTypeAndRecordTypeName()
    {
		List<RecordType> types = [SELECT
									  r.SobjectType
									, r.NamespacePrefix
									, r.Name
									, r.IsActive
									, r.Id
									, r.DeveloperName
									, r.Description
									, r.BusinessProcessId
								FROM
									RecordType r
								WHERE
									r.IsActive = TRUE];
        
        RecordType rt;
        if(ValidateList(types))
        {
        	rt = types[0];
	
	    	System.assert(rt.Id != null);
	    	
	    	String returnedId = GetRecordTypeIdBySobjectTypeAndRecordTypeName(rt.SobjectType, rt.Name);
	    	
	    	System.assert(rt.Id == returnedId);
        }
   	
    }

    static testMethod void test_ValidateSaveresultListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'CA'
            ,MailingPostalCode    = '12345'
        );

        List<Contact> Contacts = new List<Contact>();
        Contacts.add(cont);
        List<Database.SaveResult> Results = Database.insert(Contacts);
    	System.assert(ValidateSaveresultList(Results) == true);
   	
    }

    static testMethod void test_ValidateMapPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'CA'
            ,MailingPostalCode    = '12345'
        );
        insert cont;
    	Map<Id, Contact> myMap = new Map<Id, Contact>();
    	myMap.put(cont.Id, cont);
    	System.assert(ValidateMap(myMap) == true);
   	
    }
    
    static testMethod void test_ValidateMapNegativeNull()
    {
    	Map<Id, Contact> myMap;
    	System.assert(ValidateMap(myMap) == false);
    }
    
    static testMethod void test_ValidateMapNegativeEmpty()
    {
    	Map<Id, Contact> myMap = new Map<Id, Contact>();
    	System.assert(ValidateMap(myMap) == false);
    }
    
    static testMethod void test_ExistsInListNegative()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'CA'
            ,MailingPostalCode    = '12345'
        );
        List<Contact> Contacts = new List<Contact>();
        System.assert(ExistsInList(cont, Contacts) == false);
    }

    static testMethod void test_ExistsInListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'CA'
            ,MailingPostalCode    = '12345'
        );
        List<Contact> Contacts = new List<Contact>();
        Contacts.add(cont);
        System.assert(ExistsInList(cont, Contacts) == true);
    }

    static testMethod void test_ValidateSobjectListPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'CA'
            ,MailingPostalCode    = '12345'
        );
        List<Contact> Contacts = new List<Contact>();
        Contacts.add(cont);
        System.assert(ValidateList(Contacts) == true);
    }

    static testMethod void test_ValidateSobjectListNegative()
    {
        List<Contact> Contacts = new List<Contact>();
        System.assert(ValidateList(Contacts) == false);
    }

    static testMethod void test_ValidateObjectList()
    {
        List<Integer> ints = new List<Integer>{1,2,3};
        System.assert(ValidateList(ints));
    }

    static testMethod void test_StringGetValueOrDefault1()
    {
        String one = '';
        String defaultVal = 'DEFAULT';
        System.assert(StringGetValueOrDefault(one, defaultVal) == 'DEFAULT');
    }

    static testMethod void test_StringGetValueOrDefault2()
    {
        String one = 'TEST';
        String defaultVal = 'DEFAULT';
        System.assert(StringGetValueOrDefault(one, defaultVal) == 'TEST');
    }

    static testMethod void test_BuildStringOfIdsForInClause_WithList()
    {

        Contact cont1 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName1'
            ,LastName             = 'Test_Lastname1'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        Contact cont2 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName2'
            ,LastName             = 'Test_Lastname2'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        List<Contact> conts = new List<Contact>();
        conts.add(cont1);
        conts.add(cont2);
        insert conts;

    	String soql = BuildStringOfIDsForInClause(conts,',');
    	
   	   	System.assert(soql.contains(conts[0].Id));
    	System.assert(soql.contains(conts[1].Id));
    	System.assert(soql.contains(','));
   	
    }

    static testMethod void test_BuildStringOfIdsForInClause_WithSet()
    {

        Contact cont1 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName1'
            ,LastName             = 'Test_Lastname1'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        Contact cont2 = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName2'
            ,LastName             = 'Test_Lastname2'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        
        List<Contact> conts = new List<Contact>();
        conts.add(cont1);
        conts.add(cont2);
        insert conts;
        
        System.debug('*****TEST :: ID is for Cont #1 is: ' + conts[0].Id);
        System.debug('*****TEST :: ID is for Cont #2 is: ' + conts[1].Id);

    	Set<Id> mySet = new Set<Id>{conts[0].Id, conts[1].Id};
    	String soql = BuildStringOfIDsForInClause(mySet,',');

    	System.assert(soql.contains(conts[0].Id));
    	System.assert(soql.contains(conts[1].Id));
    	System.assert(soql.contains(','));
   	
    }

    static testMethod void test_ValidateSetPositive()
    {
        Contact cont = new Contact
        (
             MailingStreet        = 'Test Street'
            ,MailingCity          = 'Test City'
            ,Email                = 'unamefortesting@aciworldwide.net'
            ,FirstName            = 'Test_FirstName'
            ,LastName             = 'Test_Lastname'
            ,Phone                = '2234567890'
            ,OtherPhone           = '2234567890'
            ,MailingState         = 'FL'
            ,MailingPostalCode    = '12345'
        );
        insert cont;

    	Set<Id> mySet = new Set<Id>{cont.Id};
    	System.assert(ValidateSet(mySet) == true);
   	
    }
    
    static testMethod void test_ValidateSetNegativeNull()
    {
    	Set<Id> mySet;
    	System.assert(ValidateSet(mySet) == false);
    }
    
    static testMethod void test_ValidateSetNegativeEmpty()
    {
    	Set<Id> mySet = new Set<Id>();
    	System.assert(ValidateSet(mySet) == false);
    }
    
    static testMethod void test_GetRoleSubordinateUserIds()
    {
		UserRole ur1 = new UserRole(Name = 'TEST ROLE');
		Database.insert(ur1);
		UserRole ur2 = new UserRole(Name = 'TEST SUBORDINATE ROLE');
		ur2.ParentRoleId = ur1.Id;
		Database.insert(ur2);
		/*
    	User testUser1 = UnitTestUtil.CreateUser('');
    	testUser1.UserRoleId = ur1.Id;
    	Database.update(testUser1);
    	User testUser2 = UnitTestUtil.CreateUser('');
    	testUser2.UserRoleId = ur2.Id;
    	Database.update(testUser2);
    	Set<ID> s = GetRoleSubordinateUserIds(testUser1.Id);
    	system.assert(s != null);
    	system.assert(s.size()>0);
    	*/
    }
    
    
    static testMethod void test_GetRoleSubordinateUserMap()
    {
		UserRole ur1 = new UserRole(Name = 'TEST ROLE');
		Database.insert(ur1);
		/*
    	User testUser1 = UnitTestUtil.CreateUser('');
    	testUser1.UserRoleId = ur1.Id;
    	Database.update(testUser1);
		
		UserRole ur2 = new UserRole(name = 'TEST SUBORDINATE ROLE');
		ur2.ParentRoleId = ur1.Id;
		Database.insert(ur2);
    	User testUser2 = UnitTestUtil.CreateUser('');
    	testUser2.UserRoleId = ur2.Id;
    	Database.update(testUser2);

    	map<Id,User> m = GetRoleSubordinateUserMap(testUser1.Id);
    	system.assert(m != null);
    	system.assert(m.size()>0);
    	*/
    }
    
	static testMethod void test_GetRoleSubordinateUserList()
	{
		UserRole ur1 = new UserRole(Name = 'TEST ROLE');
		Database.insert(ur1);
    	
    	/*
    	User testUser1 = UnitTestUtil.CreateUser('');
    	testUser1.UserRoleId = ur1.Id;
    	Database.update(testUser1);
		
		UserRole ur2 = new UserRole(name = 'TEST SUBORDINATE ROLE');
		ur2.ParentRoleId = ur1.Id;
		Database.insert(ur2);
    	User testUser2 = UnitTestUtil.CreateUser('');
    	testUser2.UserRoleId = ur2.Id;
    	Database.update(testUser2);

		list<User> m = GetRoleSubordinateUserList(testUser1.Id);
    	system.assert(m != null);
    	system.assert(m.size()>0);
    	*/
	}
	
	static testMethod void test_LimitsCheckQueriesOK()
	{
		System.assert(LimitsCheckQueriesOK());
	}
	
	static testMethod void test_LimitsCheckDmlRowsOK()
	{
		System.assert(LimitsCheckDmlRowsOK());
	}
	
	static testMethod void test_LimitsCheckHeapSizeOK()
	{
		System.assert(LimitsCheckHeapSizeOK());
	}

	static testMethod void test_LimitsCheckDmlStatementsOK()
	{
		System.assert(LimitsCheckDmlStatementsOK());
	}

	static testMethod void test_LimitsCheckScriptStatementsOK()
	{
		System.assert(LimitsCheckScriptStatementsOK());
	}

}