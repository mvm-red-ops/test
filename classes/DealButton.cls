public class DealButton
{
    public String Dealid {get;set;}
    public String Dealname {get;set;}
    public String Network;
    public DealButton(ApexPages.StandardController controller)
    {
        Set<String> PicklistNetworkStrings = new Set<String>();
        if (Schema.getGlobalDescribe().containsKey('Schedules__c'))
        {
            if (Schema.getGlobalDescribe().get('Schedules__c').getDescribe().fields.getMap().containsKey('Networks__c'))
            {
                for (Schema.PicklistEntry PE : Schema.getGlobalDescribe().get('Schedules__c').getDescribe().fields.getMap().get('Networks__c').getDescribe().getPicklistValues())
                {
                    PicklistNetworkStrings.add(PE.getValue());
                }
            }
        }
        
        Dealid = controller.getId();
        for(Deal__c deal : [SELECT Id, Name, Program__r.Name FROM Deal__c WHERE Id =:Dealid])
        {
            Dealname = deal.Name; 
            if(deal.Program__r.Name.contains('BounceTV - Local'))
            {
                Network ='BounceTV - Local';     
            }
            else if(deal.Program__r.Name.contains('Bounce'))
            {
                Network ='Bounce';     
            }
            else if(deal.Program__r.Name.contains('Tennis Channel'))
            {
                Network ='TENNIS';     
            }
            else if(deal.Program__r.Name.contains('MGM HD'))
            {
                Network ='MGM HD';     
            }
            else if(deal.Program__r.Name.contains('COZI'))
            {
                Network ='COZI';     
            }
            else if(deal.Program__r.Name.contains('COZI - Local'))
            {
                Network ='COZI';     
            }
            else if(deal.Program__r.Name.contains('MLB Network'))
            {
                Network ='MLB';     
            }
            else if(deal.Program__r.Name.contains('Documentary Channel'))
            {
                Network ='DOC';     
            }
            else if(deal.Program__r.Name.contains('AntennaTV'))
            {
                Network ='Antenna TV';     
            }
            else if(deal.Program__r.Name.contains('Antenna TV – Local'))
            {
                Network ='Antenna TV';     
            }
            else if(deal.Program__r.Name.contains('ThisTV'))
            {
                Network ='This TV';     
            }
            else if(deal.Program__r.Name.contains('ThisTV – Local'))
            {
                Network ='This TV';     
            }
            else if(PicklistNetworkStrings.contains(deal.Program__r.Name))
            {
                Network = deal.Program__r.Name;     
            }
            else
            {
                Network  ='None';     
            }
        } 
    }
    public PageReference ViewPage()
    {
        PageReference pageRef = new PageReference('/a08/e?retURL='+Dealid+'&RecordType=012C0000000Lxq9IAC&ent=01I80000000G533&CF00N80000002dVQS='+Dealname+'&00N80000004dNEJ='+Network);
        return pageRef; 
    }
}