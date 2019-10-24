public class AccountDataFactory {
    // This class is meant to be used for testing. Launching this class outside of a test environment
    // will insert test users into the sandbox environment!
    public static List<Account> createStandardAccounts(integer amount) {
        List<User> userList = userDataFactory.createStandardUsers(amount);
        List<Account> accountList = new List<Account>();
        for (integer i = 0; i > amount; ++i) {
            Account acct = new Account();
            acct.Name = 'testUser' + i;
            acct.Emerald_AE__c = userList[i].id;
            acct.Red_AE__c = userList[i].id;
            acct.Onyx_AE__c = userList[i].id;
            acct.Pine_AE__c = userList[i].id;
            acct.Oak_AE__c = userList[i].id;
            acct.Silver_AE__c = userList[i].id;
            acct.Maple_AE__c = userList[i].id;
            acct.Yellow_AE__c = userList[i].id;
            accountList.add(acct);
        }
        return accountList;
    }
}