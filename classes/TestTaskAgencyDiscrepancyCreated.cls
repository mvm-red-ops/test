@isTest
public class TestTaskAgencyDiscrepancyCreated {
    
    @isTest public static void testTaskCreation() {
        // Lines 6-16 instantiate and insert necessary records to create a task.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='BrianHorowitz@mvmediasales.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='AugustTestUser@testorg.com');
        Account acct = new Account(Name='TestAccount');
        insert u;
        System.debug('The following user was created: ' + u);
        insert acct;
        System.debug('The following account was created: ' + acct);
        Contact ctct = new Contact(FirstName='Test',LastName='Testerson', AccountId=acct.Id, OwnerId=u.Id, RecordTypeId='012C0000000Ly5VIAS', Email='TestTheEmail@emailtest.com', Phone='123-456-9999');
        
        // This try - catch statement checks whether the contact can be inserted. If it cannot, the catch
        // will give back a related error message that describes why the insert failed.
        try {
            insert ctct;
            System.debug('The follow contact was created: ' + ctct);
        } catch(DMLException e) {
            System.debug('ERROR: The following contact could not be DML-Inserted: ' + ctct.Name + '. More context here: ' + e.getMessage());
        }
        
        // Current ADT policy gives two days to resolve the task.
		Date testDate = date.today() + 2;
        // The task is instantiated using ids from the previous records we created, along with some default values.
        Task testTask = New Task(OwnerId=u.Id, 
                                 WhatId=acct.Id, 
                                 WhoId = ctct.Id, 
                                 Status='In Progress', 
                                 ActivityDate=testDate, 
                                 Priority='Low');
        System.debug('Record Type: ' + [SELECT id FROM RecordType WHERE Name='Agency Short Pay' LIMIT 1]);
        // Line 39 serves the purpose of assigning the Agency Short Pay record type to the task we're inserting.
        // Without assigning the recordtypeid, the task would not be inserted under any record type.
        testTask.RecordTypeId = [SELECT id FROM RecordType WHERE Name='Agency Short Pay' LIMIT 1].Id;
        Id testUserId = testTask.OwnerId;
        User testUser = [SELECT id, Name FROM User WHERE id=:testUserId];
        Test.startTest();
        Database.SaveResult result = Database.insert(testTask, false);

    	if (result.isSuccess()) {
        	// Operation was successful, so get the ID of the record that was processed
        	System.debug('Successfully inserted task. Task ID: ' + result.getId());
            System.debug('Here is the owner: ' + testUser.Name);
    	}
    	else {
    	    // Operation failed, so get all errors               
    	    for(Database.Error err : result.getErrors()) {
     	       System.debug('The following error has occurred.');                   
      	       System.debug(err.getStatusCode() + ': ' + err.getMessage());
     	       System.debug('Task fields that affected this error: ' + err.getFields());
        }
    }
        Test.stopTest();
        System.assert(result.isSuccess());
    }
    
    @isTest public static void testTaskEmailSent() {
        // Lines 64 - 74 serve the same purpose as the previous test method.
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='BrianHorowitz@mvmediasales.com', 
        	EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='AugustTestUser@testorg.com');
        Account acct = new Account(Name='TestAccount');
        insert u;
        insert acct;
        Date todaysDate = date.today();
		Date testDate = todaysDate + 2;
        Task testTask = New Task(OwnerId=u.Id, WhatId=acct.Id, Status='In Progress', ActivityDate=testDate, Priority='Low', RecordTypeId='0120R000000SvNYQA0');
        Test.startTest();
        Database.SaveResult result = Database.insert(testTask, false);
        // Invocations serves the purpose of retrieving an integer value related to the amount of emails that are sent out.
        Integer Invocations = Limits.getEmailInvocations();
        System.debug('A total of ' + Invocations + ' email(s) were sent out.');
        Test.stopTest();
        // Our test is based off of invocations. If an email was sent out, the test will pass.
        System.assertEquals(1, Invocations, 'System expected 1 email to be sent out, but the actual amount of emails sent out does not match.');
    }
    
}