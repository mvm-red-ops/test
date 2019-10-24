/**
 * DealQueryExtension
 * @description Extension for handling displaying found Deals
 */

public class DealQueryExtension {

    private DealRevisionController controller;

    public List<Deal__c> deals {get;set;}
    public Id selectedDealId {get;set;}

    public DealQueryExtension(DealRevisionController con) {
        this.controller = con;
        this.deals = new List<Deal__c>();
        this.selectedDealId = null;
    }

    public void selectDeal() {
        if (selectedDealId != null) {
            controller.dealUpdateExt.selectedDeal = getDealFromId(selectedDealId);
            controller.dealUpdateExt.SearchforSchedules();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Selected deal \''
                    + controller.dealUpdateExt.selectedDeal.Name + '\'.'));
        }
    }

    private Deal__c getDealFromId(Id i) {
        for (Deal__c deal : deals) {
            if (deal.Id.equals(i)) {
                return deal;
            }
        }
        return null;
    }
}