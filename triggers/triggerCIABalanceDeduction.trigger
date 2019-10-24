trigger triggerCIABalanceDeduction on Account (before update) {
    for (Account a : trigger.new) {
        if (a.CIA_Amount_To_Book__c != 0) {
            decimal grossBookingAmount = a.CIA_Amount_To_Book__c;
            decimal previousCIABalance = a.CIA_Balance__c;
            decimal netBookingAmount = a.CIA_Amount_To_Book__c * .85;
            decimal newCIABalance = previousCIABalance - netBookingAmount;
            a.CIA_Balance__c = newCIABalance;
            a.CIA_Amount_To_Book__c = 0;
        }
    }
}