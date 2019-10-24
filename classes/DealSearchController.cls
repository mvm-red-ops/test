public class DealSearchController {
    public Schedules__c schedule { get; set; }
    public Deal__c deal { get; set; }
    public List<Deal__c> dealList { get; set; }
    public Boolean hasDeals { get; set; }
    public String dealId { get; set; }

    //Constructor definition
    public DealSearchController() {
        schedule = new Schedules__c();
        deal = new Deal__c();
        hasDeals = false;
    }

    //Method to Getting records
    public PageReference search() {
        hasDeals = true;
        getDealSection();
        return null;
    }
    //Method getting records for Deal Section
    private void getDealSection() {
        String agencyDealNumber;
        String networkDealNumber;
        String conId;
        String dealName;
        String brand;
        String agency;
        String program;
        String pid;
        String clId;
        String bid;
        String cid;

        String whereAnd = 'WHERE ';
        String dealQuery = 'SELECT id, Name, Program__c, Brands__c, Contact__c, Length__c, Campaign__c, Client_Account__c, ';
        dealQuery += 'Week_MIN_Field__c, Agency_Deal_Number__c, Network_Deal_Number__c, Sum_of_Total_Dollars__c, ';
        dealQuery += 'Sum_of_Units_Available__c, Program__r.Id, Contact__r.Id, Contact__r.Account.ID, Brands__r.Id, ';
        dealQuery += 'Program__r.Name, Contact__r.Name, Client_Account__r.Name, Brands__r.Name ,createdDate, ContactAccount__c ';
        dealQuery += ' FROM Deal__c ';

        if (schedule.Deal_Parent__c != null) {
            dealId = schedule.Deal_Parent__c;
            dealQuery += whereAnd + 'Id =: dealId ';
            whereAnd = 'AND ';
        }
        if (deal.Program__c != null) {
            pid = deal.Program__c;
            dealQuery += whereAnd + 'Program__c =: pid ';
            whereAnd = 'AND ';
        }
        if (deal.Client_Account__c != null) {
            clId = deal.Client_Account__c;
            dealQuery += whereAnd + 'Contact__r.Account.id =: clId ';
            whereAnd = 'AND ';
        }
        if (schedule.LF_Brand__c != null) {
            bid = schedule.LF_Brand__c;
            dealQuery += whereAnd + 'Brands__c =: bid ';
            whereAnd = 'AND ';
        }
        if (deal.Contact__c != null) {
            cid = deal.Contact__c;
            dealQuery += whereAnd + 'Contact__c =: cid ';
            whereAnd = 'AND ';
        }

        if (deal.Agency_Deal_Number__c != null && deal.Agency_Deal_Number__c.trim().length() > 0) {
            agencyDealNumber = deal.Agency_Deal_Number__c;
            dealQuery += whereAnd + 'Agency_Deal_Number__c =: agencyDealNumber ';
            whereAnd = 'AND ';
        }

        if (deal.Network_Deal_Number__c != null && deal.Network_Deal_Number__c.trim().length() > 0) {
            networkDealNumber = deal.Network_Deal_Number__c;
            dealQuery += whereAnd + 'Network_Deal_Number__c =: networkDealNumber ';
            whereAnd = 'AND ';
        }

        dealQuery += 'ORDER BY Week_MIN_Field__c DESC, Brands__r.Name  LIMIT 1000 ';
        dealList = Database.query(dealQuery);
        if (dealList.size() > 0) {
            hasDeals = true;
        } else {
            hasDeals = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No DEALS Found..!'));
        }
    }
}