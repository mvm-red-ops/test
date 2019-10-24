public with sharing class ScheduleTestSelector extends ScheduleSelector {

    //
    // Fields
    //
    public Map<SObjectField, Object> fabricationFields { get; set; }
    public List<Schedules__c> fabricatedList { get; set; }
    public Integer fabricationAmount { get; set; }
    public Boolean requireID { get; set; }

    //
    // Init Fields
    //
    {
        this.fabricationFields = new Map<SObjectField, Object>();
        this.fabricatedList = new List<Schedules__c>();
        this.fabricationAmount = 0;
        this.requireID = true;
    }

    /**
     * {@inheritDocs}
     *
     * @return A Fabricated list of Schedules
     */
    public override List<Schedules__c> getSchedules(List<SObjectField> fields) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount, this.fabricationFields);
        } else {
            return this.fabricatedList;
        }
    }

    /**

     * {@inheritDocs}     * @return A Fabricated list of Schedules
     */
    public override List<Schedules__c> getSchedulesFromSelected(List<Schedules__c> selected) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount, this.fabricationFields);
        } else {
            return this.fabricatedList;
        }
    }

    /**
     * {@inheritDocs}
     * @return A Fabricated list of Schedules
     */
    public override List<Schedules__c> getSchedulesFromTape(Tape__c tapeRecord) {
        if (this.fabricatedList.isEmpty()) {
            return this.getFabricatedList(this.fabricationAmount, this.fabricationFields);
        } else {
            return this.fabricatedList;
        }
    }

    /**
     * @description Retrieve a list of fabricated Schedules with the assigned fields
     *  Useful for mocking Schedules and assigning fields
     *
     * @param amount The amount of fabricated Schedules to retrieve
     * @param fields A Map of the fields being set on the fabricated Schedules
     *
     * @return The resulting list of fabricated Schedules
     */
    private List<Schedules__c> getFabricatedList(Integer amount, Map<SObjectField, Object> fields) {

        // Set up Mock Dependencies
        sfab_FabricatedSObject advertiserFab = new sfab_FabricatedSObject(Advertiser__c.class)
                .setField(Advertiser__c.Duplicate_Approval__c, 'Approved')
                .setField(Advertiser__c.Advertiser_Approved_to_Book__c, true);
        Advertiser__c advertiser = (Advertiser__c) advertiserFab.toSObject();

        sfab_FabricatedSObject brandFab = new sfab_FabricatedSObject(Brands__c.class)
                .setField(Brands__c.Name, 'Availability')
                .setField(Brands__c.Category__c, 'Other')
                .setField(Brands__c.Advertiser__c, advertiser.Id)
                .setField(Brands__c.Approved_Duplicate__c, 'Approved');
        Brands__c brand = (Brands__c) brandFab.toSObject();

        sfab_FabricatedSObject conFab = new sfab_FabricatedSObject(Contact.class)
                .setField(Contact.FirstName, 'TEST')
                .setField(Contact.LastName, 'TEST')
                .setField(Contact.Email, 'test@test.com')
                .setField(Contact.Phone, '5555551212');
        Contact con = (Contact) conFab.toSObject();

        sfab_FabricatedSObject programFab = new sfab_FabricatedSObject(Programs__c.class)
                .setField(Programs__c.Name, 'COZI');
        Programs__c program = (Programs__c) programFab.toSObject();

        sfab_FabricatedSObject dealFab = new sfab_FabricatedSObject(Deal__c.class)
                .setField(Deal__c.Contact__c, con.Id)
                .setField(Deal__c.Status__c, 'Sold')
                .setField(Deal__c.Length__c, '30')
                .setField(Deal__c.Brands__c, brand.Id)
                .setField(Deal__c.Program__c, program.Id)
                .setField(Deal__c.PI__c, false);
        Deal__c deal = (Deal__c) dealFab.toSObject();

        List<Schedules__c> result = new List<Schedules__c>();
        for (Integer x = 0; x < amount; x++) {
            sfab_FabricatedSObject scheduleFab = new sfab_FabricatedSObject(Schedules__c.class, fields);
            // Set Default fields
            scheduleFab
                    .setField(Schedules__c.Week__c, Utils.getOrDefault(fields, Schedules__c.Week__c, Date.newInstance(2019, 1, 1)))
                    .setField(Schedules__c.Deal_Parent__c, Utils.getOrDefault(fields, Schedules__c.Deal_Parent__c, deal.Id))
                    .setField(Schedules__c.Units_Available__c, Utils.getOrDefault(fields, Schedules__c.Units_Available__c, 1))
                    .setField(Schedules__c.Rate__c, Utils.getOrDefault(fields, Schedules__c.Rate__c, 1));
            result.add((Schedules__c) scheduleFab.toSObject());
        }
        return result;
    }

    public override List<Schedules__c> GetSchedulesForGenerateWeeklyBuy(Deal__c deal, Date minWeek) {
        return new List<Schedules__c>{
                (Schedules__c)
                        new sfab_FabricatedSObject(Schedules__c.class)
                                .setField(Schedules__c.Week__c, Date.today())
                                .setField(Schedules__c.Rate__c, 5.0)
                                .setField(Schedules__c.UnitLength__c, 4.0)
                                .setField(Schedules__c.Daypart__c, '9A-6P – Day')
                                .setField(Schedules__c.Units_Available__c, 6.0)
                                .setField(Schedules__c.WO_Units__c, 8.0)
                                .setField(Schedules__c.Days_Allowed__c, 'Tue')
                                .setField(Schedules__c.Start_Time__c, '04:00P')
                                .setField(Schedules__c.End_Time__c, '4:30A').toSObject()
        };
    }


    public override Deal__c getSchedulesForGetXMLFiles(Id dealId) {
        sfab_FabricatedSObject testBrand =
                new sfab_FabricatedSObject(Brands__c.class)
                        .setField(Brands__c.Name, 'testName')
                        .setField(Brands__c.id, 'a0780000002em0dAAA');

        sfab_FabricatedSObject testProgram =
                new sfab_FabricatedSObject(Programs__c.class)
                        .setField(Programs__c.Logs_Contact__c, 'test')
                        .setField(Brands__c.id, 'a0780000002em0dAAH');


        sfab_FabricatedSObject testDeal =
                new sfab_FabricatedSObject(Deal__c.class)

                        .setParent('Brands__r', testBrand)
                        .setParent('Program__r', testProgram)
                        .setField(Deal__c.Name, 'my name')
                        .setField(Deal__c.Id, Utils.randomString(8))
                        .setField(Deal__c.Advertiser__c, 'Clipro')
                        .setField(Deal__c.Bundle_Start_Week__c, Date.today())
                        .setField(Deal__c.Week_MIN_Field__c, Date.today())
                        .setField(Deal__c.Week_Max__c, Date.today())
                        .setField(Deal__c.ContactAccount__c, 'my contact')
                        .setField(Deal__c.Length__c, 120)
                        .setField(Deal__c.Sum_of_Total_Dollars__c, 20.0)
                        .setField(Deal__c.program__c, Utils.randomString(8))
                        .setField(Deal__c.CreatedDate, Date.today());


        Deal__c testDeal2 = (Deal__c) testDeal.toSObject();
        return testDeal2;
    }

    public override List<Schedules__c> getSchedulesForgenerateBuylines(Deal__c deal) {
        return new List<Schedules__c>{
                (Schedules__c)
                        new sfab_FabricatedSObject(Schedules__c.class)
                                .setField(Schedules__c.Week__c, Date.today())
                                .setField(Schedules__c.Rate__c, 5.0)
                                .setField(Schedules__c.UnitLength__c, 4.0)
                                .setField(Schedules__c.Daypart__c, '9A-6P – Day')
                                .setField(Schedules__c.Units_Available__c, 6.0)
                                .setField(Schedules__c.WO_Units__c, 8.0)
                                .setField(Schedules__c.Days_Allowed__c, 'Tue')
                                .setField(Schedules__c.Start_Time__c, '04:00P')
                                .setField(Schedules__c.End_Time__c, '4:30A').toSObject()

        };

    }

    private sfab_FabricatedSObject makeDummySchedule() {
        return new sfab_FabricatedSObject(Schedules__c.class)
                .setField(Schedules__c.Week__c, Date.today())
                .setField(Schedules__c.Rate__c, 5.0)
                .setField(Schedules__c.UnitLength__c, 4.0)
                .setField(Schedules__c.Daypart__c, '9A-6P – Day')
                .setField(Schedules__c.Units_Available__c, 6.0)
                .setField(Schedules__c.WO_Units__c, 8.0)
                .setField(Schedules__c.Days_Allowed__c, 'Tue')
                .setField(Schedules__c.Start_Time__c, '04:00P')
                .setField(Schedules__c.End_Time__c, '4:30A');
    }


    public override List<Schedules__c> getSchedulesForbuildScheduleList(Id dealId, Date bundleStartWeek) {
        List<Schedules__c> schedulesList = new List<Schedules__c>();
        Integer i = 0;
        for (i = 0; i < 10; i++) {
            schedulesList.add((Schedules__c)makeDummySchedule().toSObject());
        }
        return schedulesList;
    }

    public override List<Schedules__c> getSchedulesInWeek(Programs__c network) {
        return new List<Schedules__c> { (Schedules__c)
                new sfab_FabricatedSObject(Schedules__c.class)
                        .setParent('Deal_Parent__r', new sfab_FabricatedSObject(Deal__c.class)
                        .setParent('Program__r', new sfab_FabricatedSObject(Programs__c.class)
                                .setField(Programs__c.Name, 'a06C000001pVGTMIA4')))
                        .setField(Schedules__c.Id, 'a080R000005ktQsQAI')
                        .setField(Schedules__c.Name, 'a080R000005ktQsQAI')
                        .setField(Schedules__c.Week__c, network.RCreconciled_Week__c)
                        .setField(Schedules__c.Daypart__c, 'DA')
                        .setField(Schedules__c.Sum_Spot_Equiv_30__c, 1.0)
                        .setField(Schedules__c.Spot_Total__c, 1.0)
                        .setField(Schedules__c.PI_Payout_TEST__c, 1.0)
                        .setField(Schedules__c.CALC_EQUIV_30__c, 1.0)
                        .setField(Schedules__c.Total_Dollars__c, 1.0)
                        .toSObject()
        };
    }

    public override List<Schedules__c> getSchedulesByContacts(List<Id> contactIds, Date lastMonday, Date thisMonday) {
        Map<SObjectField, Object> fields = new Map<SObjectField, Object> {
                Schedules__c.Id => 'a080R000005ktQsQAI',
                Schedules__c.Name => 'a080R000005ktQsQAI',
                Schedules__c.Deal_Parent__c => '',
                Schedules__c.Spot_Count__c => 1,
                Schedules__c.Prelog_Count__c => 1,
                Schedules__c.Units_Preempted__c => 1
        };
        Map<String,String> programFields = new Map<String, String> {
                'BounceTV - Local' => 'Cable',
                'AntennaTV' => 'Cable',
                'ThisTV' => 'Cable',
                'NHL Network - Local' => 'Cable',
                'TVG - Local' => 'Cable',
                'TVG2 - Local' => 'Cable',
                'MAV TV' => 'Cable',
                'MLB Network' => 'Cable',
                'Other' => 'Cable',
                'AntennaTV' => 'Syndication'
        };

        List<Schedules__c> result = new List<Schedules__c>();
        for (String name : programFields.keySet()) {
            result.add((Schedules__c) new sfab_FabricatedSObject(Schedules__c.class, fields)
                    .setParent('Deal_Parent__r', new sfab_FabricatedSObject(Deal__c.class)
                            .setParent('Program__r', new sfab_FabricatedSObject(Programs__c.class)
                                    .setField(Programs__c.Name, name)
                                    .setField(Programs__c.Cable_Synd__c, programFields.get(name))
                            )
                            .setField(Deal__c.Contact__c, contactIds[0])
                    )
                    .setField(Schedules__c.Week__c, lastMonday)
                    .toSObject());
        }
        for (String name : programFields.keySet()) {
            result.add((Schedules__c) new sfab_FabricatedSObject(Schedules__c.class, fields)
                    .setParent('Deal_Parent__r', new sfab_FabricatedSObject(Deal__c.class)
                            .setParent('Program__r', new sfab_FabricatedSObject(Programs__c.class)
                                    .setField(Programs__c.Name, name)
                                    .setField(Programs__c.Cable_Synd__c, programFields.get(name))
                            )
                            .setField(Deal__c.Contact__c, contactIds[0])
                    )
                    .setField(Schedules__c.Week__c, thisMonday)
                    .toSObject());
        }
        result.add((Schedules__c) new sfab_FabricatedSObject(Schedules__c.class, fields)
                .setParent('Deal_Parent__r', new sfab_FabricatedSObject(Deal__c.class)
                        .setParent('Program__r', new sfab_FabricatedSObject(Programs__c.class)
                                .setField(Programs__c.Name, 'Other')
                                .setField(Programs__c.Cable_Synd__c, 'Other')
                        )
                        .setField(Deal__c.Contact__c, contactIds[0])
                )
                .setField(Schedules__c.Week__c, thisMonday)
                .toSObject());
        return result;
    }

    private static Deal__c createDeal(Brands__c brand) {
        Contact con = new Contact(
                LastName = 'Test',
                Email = 'test@test.com',
                Phone = '8001234567'
        );
        insert con;

        Deal__c deal = new Deal__c(
                Contact__c = con.Id,
                Brands__c = brand.Id,
                Length__c = '30'
        );
        insert deal;
        return deal;
    }

    private static Account createAccount() {
        Account acc = new Account(Name = 'test');
        insert acc;
        return acc;
    }

    private static Brands__c createBrand() {
        Advertiser__c advertiser = new Advertiser__c(
                Duplicate_Approval__c = 'Approved',
                Advertiser_Approved_to_Book__c = true
        );
        insert advertiser;

        Brands__c brand = new Brands__c(
            Name = 'Availability',
            Category__c = 'Other',
            Advertiser__c = advertiser.Id,
            Approved_Duplicate__c = 'Approved'
        );
        insert brand;
        return brand;
    }

    private static Programs__c createProgram() {
        Programs__c program = new Programs__c(
            Name = 'Availability',
            ClientCode__c = '123'
        );
        insert program;
        return program;
    }

    public override List<Schedules__c> getSchedulesFromQuery(String query) {
        Brands__c brand = createBrand();
        Deal__c deal = createDeal(brand);
        Programs__c program = createProgram();
        Account acc = createAccount();

        List<Schedules__c> result = new List<Schedules__c> {
                (Schedules__c) new sfab_FabricatedSObject(Schedules__c.class)
                        .setField(Schedules__c.Deal_Parent__c, deal.Id)
                        .setField(Schedules__c.Rate__c, 100)
                        .setField(Schedules__c.Comments__c, 'test')
                        .setField(Schedules__c.Week__c, System.today().toStartOfWeek().addDays(1))
                        .setField(Schedules__c.Units_Available__c, 1)
                        .setField(Schedules__c.OrderNumber__c, '1')
                        .setField(Schedules__c.Total_Dollars__c, 17)
                        .toSObject(),
                (Schedules__c) new sfab_FabricatedSObject(Schedules__c.class)
                        .setField(Schedules__c.Deal_Parent__c, deal.Id)
                        .setField(Schedules__c.Rate__c, 100)
                        .setField(Schedules__c.Comments__c, 'test')
                        .setField(Schedules__c.Week__c, System.today().toStartOfWeek().addDays(1))
                        .setField(Schedules__c.Units_Available__c, 1)
                        .setField(Schedules__c.OrderNumber__c, '1')
                        .setField(Schedules__c.Total_Dollars__c, 17)
                        .toSObject()
        };
        return result;
    }

    /**
     * @description Retrieve a random valid Schedule__c Id from the static resource
     *
     * @return The randomly chosen Schedule__c Id
     */
    public static Id getRandomId() {
        StaticResource schedule_ids = [
                SELECT Id,
                       Body
                  FROM StaticResource
                 WHERE Name = 'TestScheduleIDs'
                 LIMIT 1
        ];
        List<String> ids = schedule_ids.Body.toString().split(',');
        return Id.valueOf(ids.get(Utils.randomBounds(0, ids.size())));
    }
}