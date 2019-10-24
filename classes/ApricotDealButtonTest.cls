/**
 * @date 1/14/2019
 * @description Test class for ApricotDealButton
 */
@IsTest
public with sharing class ApricotDealButtonTest {

    //
    // Testing Vars
    //
    private static DealTestSelector dealSelector { get; set; }
    private static ApexPages.StandardController controller { get; set; }
    private static ApricotDealButton context { get; set; }

    /**
     * @description Run a basic setup for all unit tests
     */
    private static void basicSetup() {
        dealSelector = new DealTestSelector();
        controller = new ApexPages.StandardController(new Deal__c());
        Test.setCurrentPage(Page.ApricotDealButton);
    }

    /**
     * @description Test the result of no deals being found in the database
     */
    @IsTest
    static void apricotDealButton_pageSetup_TestNoDealsFound() {
        basicSetup();
        dealSelector.fabricationAmount = 0;
        context = new ApricotDealButton(controller, dealSelector);

        // Network should remain null (because no deal was found)
        System.assertEquals(null, context.network);
    }

    /**
     * @description Test the result of each type of network with the deals
     */
    @IsTest
    static void apricotDealButton_pageSetup_TestNetworkTypes() {
        basicSetup();
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('BounceTV - Local', 'BounceTV - Local');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('Bounce', 'Bounce');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('Tennis Channel', 'MGM HD');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('COZI', 'COZI');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('COZI - Local', 'COZI');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('MLB Network', 'MLB');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('Documentary Channel', 'DOC');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('AntennaTV', 'Antenna TV');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('Antenna TV - Local', 'Antenna TV');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('ThisTV', 'This TV');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal('ThisTV - Local', 'This TV');
        apricotDealButton_pageSetup_TestNetworkTypeFromDeal(Utils.randomString(16), 'None');
    }

    /**
     * @description Test the result of the view-page reference after setting deal data
     */
    @IsTest
    static void apricotDealButton_viewPage_TestValidViewRedirection() {
        basicSetup();

        String dealId = Utils.randomString(8);
        String dealName = Utils.randomString(8);
        String networkName = Utils.randomString(8);

        dealSelector.fabricationAmount = 0;
        context = new ApricotDealButton(controller, dealSelector);

        // Set deal data
        context.dealId = dealId;
        context.dealName = dealName;
        context.network = networkName;
        Test.setCurrentPage(context.viewPage());

        // Generate test page reference
        PageReference ref = new PageReference('/a08/e?retURL=' + dealId + '&RecordType=012C0000000QexD&ent=01I80000000G533&CF00N80000002dVQS=' + dealName + '&00N80000004dNEJ=' + networkName);

        // Ensure proper URL
        System.assertEquals(ref.getUrl(), ApexPages.currentPage().getUrl());
    }

    /**
     * @description Test the fabrication of each type of program name and make sure the network gets set to the correct value
     * @param programName The specified program name for fabrication
     * @param expectedNetwork The expected name the network should be set to
     */
    private static void apricotDealButton_pageSetup_TestNetworkTypeFromDeal(String programName, String expectedNetwork) {
        dealSelector.fabricationAmount = 1;
        dealSelector.fabricationFields = new Map<SObjectField, Object>{
                Programs__c.Name => programName
        };
        context = new ApricotDealButton(controller, dealSelector);
        System.assertEquals(expectedNetwork, context.network);
    }

}