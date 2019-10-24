trigger TaskAgencyDiscrepancyCreated on Task (after insert) {
    // The below is a SOQL query to retrieve the Record Type Id for Agency Short Pays
    RecordType rt = [Select Id FROM RecordType WHERE Name='Agency Short Pay'];
    for (Task t : trigger.new) {
        System.debug('This is t: ' + t);
        System.debug('This is the task record type: ' + rt);

        if (t.RecordTypeId == rt.Id) {
            // This user variable holds the user record that the task is associated with.
            User adtAssignedUser = [SELECT id, email, name FROM User WHERE id=:t.ownerId];
            // We follow on the previous variable declaration and pull the email field to use with the Email Manager class.
            String adtAssignedUserEmail = adtAssignedUser.Email;
            // This list of strings contains the emails that will always be cc'd within the email that's sent out.
            // As of current, it's set to email members of product team. This will be changed to members of finance
            // before it's pushed to live production.
            String[] adtCCEmails = new List<String> {'kiyanadunlock@mvmediasales.com', 'TaylorYoung@mvmediasales.com'};
            // The subject line of all ADT emails will remain static as such:
            String adtSubjectLine = 'An Agency Discrepancy task has been assigned to you';
            // Below, an html script is being localized to adtHtmlBody. EmailManager is expecting HTML to compose the
            // email message. Please note that when editing, it is necessary to keep strict HTML formatting within the
            // string, or the email message will not keep a proper appearance.
            String adtHtmlBody = '<p>Dear ' + adtAssignedUser.Name + ', </p> <br> <p>Finance has assigned an Agency Discrepancy Task for you, please follow the link to review: </p> <br> <a href="http://na104.salesforce.com/' + t.Id + '">Click Here to View Task </a><br><p>The task linked above has a due date of ' + t.ActivityDate + '.</p><br><p>If there are any concerns or updates, please reply all for Finance to review.</p>';
            // We take the four variables declared above, and insert them into the EmailManager's sendMail method as follows:
            EmailManager.sendMail(adtAssignedUserEmail, adtCCEmails, adtSubjectLine, adtHtmlBody);
            // At this point, the email is sent!
        } else {
            // This system debug will only fire on tasks that are created under a different record type than Agency Short Pays.
            System.debug('TaskAgencyDiscrepancyCreated trigger did not launch because the created task is of the following record type: ' + t.RecordType);
        }
    }
}