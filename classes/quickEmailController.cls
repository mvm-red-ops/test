public class quickEmailController{
    
    ApexPages.StandardSetController setCon;
    
    public quickEmailController(ApexPages.StandardSetController controller)
    {
        setCon = controller;
    }

    public pageReference doSomething()
    {
        // do something with the selected records
        for ( Deal__c acc : (Deal__c[])setCon.getSelected() )
        {
                System.debug('Deal__c name = ' + acc.Name);
        }
        return null;
    }
}