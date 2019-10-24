trigger triggerOverpaymentsAndAdvances on Account (before update) {
    for (Account a : trigger.new) {
        System.debug('this is the account: ' + a);
        System.debug('Here is the trigger.oldMap of A, for the O&A field : ');
        if (a.Overpayments_Advances__c != trigger.oldMap.get(a.id).Overpayments_Advances__c && a.CIA__c == true) {
            Decimal x = Accounts_CIA_Balance_Class.previousMonthBookingNetTotal(a);
            Decimal ciaBalance = a.overpayments_Advances__c - x;
            a.CIA_Balance__c = ciaBalance;
     }
   }
}