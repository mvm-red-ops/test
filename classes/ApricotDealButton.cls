public class ApricotDealButton {

    //
    // Fields
    //
    public ApexPages.StandardController controller { get; set; }
    public DealSelector dealSelector { get; set; }
    public String dealId { get; set; }
    public String dealName { get; set; }
    public String network = null;

    /**
     * @description Construct ApricotDealButton with injected DealSelector
     * @param controller The page view controller
     * @param dealSelector The custom dealSelector being injected
     */
    public ApricotDealButton(ApexPages.StandardController controller, DealSelector dealSelector) {
        this.controller = controller;
        this.dealSelector = dealSelector;
        this.dealSelector = dealSelector;
        this.pageSetup();
    }

    /**
     * @description Construct ApricotDealButton with default DealSelector
     * @param controller The page view controller being assigned
     */
    public ApricotDealButton(ApexPages.StandardController controller) {
        this.controller = controller;
        this.dealSelector = new DealSelector();
        this.pageSetup();
    }

    /**
     * @description Set up the page from the selected controller ID
     */
    private void pageSetup() {
        // Retrieve all picklist values from Networks__c
        Set<String> picklistNetworkStrings = this.getPickListValues(Schedules__c.class, Schedules__c.Networks__c.getDescribe().name);
        List<Deal__c> deals = dealSelector.getDealsFromId(controller.getId());
        Map<String, String> programNetworkMap = this.setupProgramNetworkMap();

        for (Deal__c deal : deals) {
            this.dealName = deal.Name;
            this.dealId = deal.Id;
            String programName = deal.Program__r.Name;

            this.network = programNetworkMap.get(programName);

            // If the network was not listed, check if it's in the picklist
            if (network == null) {
                if (picklistNetworkStrings.contains(programName)) {
                    network = programName;
                } else {
                    network = 'None';
                }
            }
        }
    }

    /**
     * @description Retrieve an instance of the page reference based on selected deal data
     * @return The view-page reference
     */
    public PageReference viewPage() {
        PageReference pageRef = new PageReference('/a08/e?retURL=' + dealId + '&RecordType=012C0000000QexD&ent=01I80000000G533&CF00N80000002dVQS=' + dealName + '&00N80000004dNEJ=' + network);
        return pageRef;
    }

    /**
     * @description Retrieve a set of picklist values from an object type
     * @param obj The Object being selected from
     * @param picklist The picklist whose values are being retrieved
     * @return The constructed set of picklist values
     */
    private Set<String> getPickListValues(Type obj, String picklist) {
        Set<String> result = new Set<String>();
        String objectName = obj.getName();
        if (Schema.getGlobalDescribe().containsKey(objectName)) {
            if (Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().containsKey(picklist)) {
                for (Schema.PicklistEntry PE : Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(picklist).getDescribe().getPicklistValues()) {
                    result.add(PE.getValue());
                }
            }
        }
        return result;
    }

    /**
     * Retrieve a map of program to network names
     *
     * @return The mapped values of program names to network names
     */
    private Map<String, String> setupProgramNetworkMap() {
        return new Map<String, String>{
                'BounceTV - Local' => 'BounceTV - Local',
                'Bounce' => 'Bounce',
                'Tennis Channel' => 'MGM HD',
                'COZI' => 'COZI',
                'COZI - Local' => 'COZI',
                'MLB Network' => 'MLB',
                'Documentary Channel' => 'DOC',
                'AntennaTV' => 'Antenna TV',
                'Antenna TV - Local' => 'Antenna TV',
                'ThisTV' => 'This TV',
                'ThisTV - Local' => 'This TV'
        };
    }
}