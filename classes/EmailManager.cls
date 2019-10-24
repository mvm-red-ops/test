public class EmailManager {
	// Public Method that returns void (i.e. nothing returns), with three string arguments 
    public static void sendMail (String address, String[] ccAddresses, String subject, String htmlBody) {
        // Create an email message object
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // The two string lists below hold the primary email addresses and cc'd email addresses.
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setCcAddresses(ccAddresses);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        // Pass this email message to the built-in sendEmail method
        // of the Messaging class
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] { mail }
        );
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }
    
    // Helper Method
    private static Boolean inspectResults (Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results.
        // In this method, the methods send only one email.
        // so we should only have one result.
        
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());
            }
        }
        
        return sendResult;
    }
}