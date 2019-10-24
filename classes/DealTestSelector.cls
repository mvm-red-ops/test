/**
 * @date 1/14/2019
 * @description DealSelector class used in unit testing
 */
public with sharing class DealTestSelector extends DealSelector {

    //
    // Fields
    //
    public Integer fabricationAmount { get; set; }
    public Map<SObjectField, Object> fabricationFields { get; set; }

    //
    // Init Fields
    //
    {
        this.fabricationAmount = 0;
        this.fabricationFields = new Map<SObjectField, Object>();
    }

    /**
     * @description Retrieve a list of fabricated ("mocked") Deal__c objects
     * @param dealId The dealId being selected from (unused)
     * @return The resulting list of Deal__c objects associated with the specified dealId
     */
    public override List<Deal__c> getDealsFromId(Id dealId) {
        // Set up dependencies
        Contact con = new Contact(
                FirstName = 'FIRSTNAME',
                LastName = 'LASTNAME',
                Email = 'test@email.com',
                Phone = '5555555555'
        );
        insert con;
        Programs__c program = new Programs__c(
                Name = (String) Utils.getOrDefault(this.fabricationFields, Programs__c.Name, Utils.randomString(8)),
                ClientCode__c = 'TST'
        );
        insert program;
        List<Deal__c> result = new List<Deal__c>();
        for (Integer i = 0; i < this.fabricationAmount; i++) {
            Deal__c deal = new Deal__c(
                    Program__c = program.Id,
                    Contact__c = con.Id
            );
            result.add(deal);
        }
        insert result;

        Id resultId = null;
        if (result.size() > 0) resultId = result[0].Id;

        // Retrieve from query to get valid inserted children test data
        return super.getDealsFromId(resultId);
    }

    public override List<Deal__c> getDealsFromQuery(String query) {
        sfab_FabricatedSObject conFab = new sfab_FabricatedSObject(Contact.class)
                .setField(Contact.FirstName, 'TEST')
                .setField(Contact.LastName, 'TEST')
                .setField(Contact.Email, 'test@test.com')
                .setField(Contact.Phone, '5555551212');

        List<Deal__c> result = new List<Deal__c> {
                (Deal__c) new sfab_FabricatedSObject(Deal__c.class)
                        .setParent('Contact__r', conFab)
                        .toSObject()
        };
        return result;
    }

    public override List<Deal__c> getDealsFromQueryForRevision(
            String SOQLDateString,
            String tempstringListLoop,
            String programTeam,
            Boolean BarterCheckbox,
            String SelectedCableSynd,
            String limitAmt)
    {
        Contact con = new Contact(LastName = 'LastName');
        List<Deal__c> deals = new List<Deal__c>();
        for (Integer i = 0; i < 10; i++) {
            deals.add((Deal__c) new sfab_FabricatedSObject(Deal__c.class)
                    .setField(Deal__c.Id, 'a0AC0000031P3mrMA' + i)
                    .toSObject()
            );
        }
        return deals;
    }

    public override List<Deal__c> getDealsFromSearchQuery(
            String SOQLDateString,
            List<String> stringList,
            Period pr,
            Boolean BarterCheckbox,
            String SelectedCableSynd,
            String programTeam,
            String limitAmt)
    {
        Contact con = new Contact(LastName = 'LastName');
        List<Deal__c> deals = new List<Deal__c>();
        for (Integer i = 0; i < 10; i++) {
            deals.add((Deal__c) new sfab_FabricatedSObject(Deal__c.class)
                    .setField(Deal__c.Id, 'a0AC0000031P3mrMA' + i)
                    .toSObject()
            );
        }
        return deals;
    }

}