public class UserDataFactory {
    
    public static List<User> createStandardUsers(integer Amount) {
        List<User> userList = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard Platform User'];
        for (integer i = 0; i <= Amount; ++i) {
            User u = new User(Alias = 'alias' + i, Email='testUser' + i + '@mvmediasales.com', 
            EmailEncodingKey='UTF-8', LastName='smith' + i, LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='TestUser' + i + '@mvmediasales.com');
            UserList.add(u);
        }
        return userList;
    }
    
}