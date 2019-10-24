/*
    Name        : OUTDOORFilterByDealAccountController
    Author      :
    Date        : 24th August 2011
    Description : This controller will generates a Lookup like VFPage for selecting Deal Account on DOCEntruCheck VFPage
*/
public class OUTDOORFilterByDealAccountController{

    public List<Deal__c> lstDealAccount{set;get;}
    public void dealAccountName{set;get;}
    public OUTDOORFilterByDealAccountController(){
        createList();
    }
    //This function will fetch the Deals according to criteria passed as Parameters
    public void createList(){
        String program = ApexPages.currentPage().getParameters().get('pg');
        String month = ApexPages.currentPage().getParameters().get('month');
        String year = ApexPages.currentPage().getParameters().get('year');
        System.debug('=='+program+' , '+month+' , '+year);
        if(program!=null && program.trim().equals('')==false && month!=null && month.trim().equals('')==false && year!=null && year.trim().equals('')==false){
            integer iMonth = Integer.valueOf(month);
            integer iYear = Integer.valueOf(year);
            Programs__c pg = [select id from Programs__c where name=:program].get(0);    
            lstDealAccount = [select ContactAccount__c, name 
                                from Deal__c 
                                Where program__c = :pg.id
                                and week_min_Field__c >=:Date.newInstance(iYear,iMonth,1)
                                and week_min_Field__c <:Date.newInstance(iYear,iMonth+1,1)
                                limit 1000
                            ];    
            /*
                [select ContactAccount__c, name 
                                from Deal__c 
                                Where program__c =:program
                                and week_min_Field__c >=:Date.newInstance(iYear,iMonth,1)
                                and week_min_Field__c <:Date.newInstance(iYear,iMonth+1,1)
                            ];        
            */
        }
    }
    public PageReference selectAccount(){
        System.debug('##YesSelectAccount() is called# #');
        String accName = ApexPages.currentPage().getParameters().get('accName');
        PageReference pf =new PageReference('/apex/DOCEntryCheck?acc='+accName);
        pf.setRedirect(true);
        return pf;
    }
}