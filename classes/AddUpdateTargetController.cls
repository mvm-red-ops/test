public class AddUpdateTargetController{
    private static boolean executed = false;
    public static boolean getExecuted(){
        return executed;
    }
    public static void setExecuted(){
        executed = true;
    }
}