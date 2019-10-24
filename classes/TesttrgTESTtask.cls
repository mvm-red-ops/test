@isTest
public class TesttrgTESTtask {
    @isTest static void testInsert(){
        Task d = new Task();
        Test.startTest();
        try{
            insert d;
        }
        catch(exception e){
            Test.StopTest();
        }
    }

}