@IsTest
public with sharing class DealSearchControllerTest {

    @IsTest
    private static void DealSearchController_GetDealSelection_findMatchingDeals() {
        PrepDealSelectionReturn prepReturn = prepGetDealSelection();
        PageReference page = Page.DealSearch;
        context = new DealSearchController();
        context.schedule = prepReturn.schedules[0];
        Deal__c testDeal = prepReturn.deals[0];
        List<Deal__c> dealSearchReturnList = findDealsForController(prepReturn.deals[0]);

        Deal__c dealSearchReturn = dealSearchReturnList[0];
        context.deal = dealSearchReturn;
        Test.setCurrentPage(page);
        context.search();
        List<Deal__c> returnDealList = context.dealList;
        System.assertEquals(1, returnDealList.size());
        Deal__c returnDeal = returnDealList[0];
        System.assertEquals(dealSearchReturn, returnDeal);
    }

    private static DealSearchController context { get; set; }

    private static Account createAccount() {
        Account testAcct = new Account(Name = 'Test Account');
        return testAcct;
    }

    private static Contact createContact(Account testAcct) {
        Contact contact = new Contact(
                FirstName = 'Test',
                LastName = 'Name',
                Email = 'test@testemail.com',
                Phone = '(758) 771-0091',
                Account = testAcct
        );
        return contact;
    }

    static Deal__c createDeal(Contact testContact, String dealNumber) {
        Deal__c testDeal = new Deal__c(
                Contact__c = testContact.Id,
                Network_Deal_Number__c = dealNumber,
                length__c = '5'
        );
        return testDeal;
    }

    private static Schedules__c createSchedule(Deal__c testDeal) {

        Schedules__c schedule = new Schedules__c(
                Deal_Parent__c = testDeal.Id,
                Week__c = Date.today().toStartOfWeek(),
                Days_Allowed__c = 'Mon',
                Start_Time__c = '06:00A',
                End_Time__c = '06:30A',
                Rate__c = 100,
                Units_Available__c = 5
        );

        return schedule;
    }

    private static Programs__c createProgram(String dealNumber) {
        Programs__c program = new Programs__c(
                Name = 'testNetwork',
                Cable_Synd__c = 'Cable',
                Station_Call_Letter__c = Utils.generateRandomCallsign(),
                ClientCode__c = dealNumber,
                Clock_Start_Time__c = '',
                Reconciled_Week__c = Date.today().toStartOfWeek().addDays(-6),
                Team__c = 'Emerald'
        );
        return program;
    }

    public static Advertiser__c createAdvertiser() {
        Advertiser__c testAdvertiser = new Advertiser__c(
                Name = Utils.randomString(10),
                Duplicate_Approval__c = 'Approved',
                Advertiser_Approved_to_Book__c = true
        );
        return testAdvertiser;
    }

    public static Brands__c createBrand(Advertiser__c advertiser) {
        Brands__c testBrand = new Brands__c(
                Name = 'Availability',
                Advertiser__c = advertiser.Id,
                Approved_Duplicate__c = 'Approved',
                Category__c = 'Other'
        );
        return testBrand;
    }

    private static PrepDealSelectionReturn prepGetDealSelection() {
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<Deal__c> dealList = new List<Deal__c>();
        List<Schedules__c> scheduleList = new List<Schedules__c>();
        List<Programs__c> programList = new List<Programs__c>();
        List<Advertiser__c> advertiserList = new List<Advertiser__c>();
        List<Brands__c> brandList = new List<Brands__c>();


        Integer dataAmount = 5;
        Integer i = 0;
        for (i = 0; i < dataAmount; i++) {
            accountList.add(createAccount());
            programList.add(createProgram(String.valueOf(i)));
            advertiserList.add(createAdvertiser());
        }

        insert accountList;
        insert programList;
        insert advertiserList;


        for (i = 0; i < dataAmount; i++) {
            contactList.add(createContact(accountList[i]));
            brandList.add(createBrand(advertiserList[i]));
        }
        Contact testContact = contactList[0];
        insert contactList;
        insert brandList;

        Deal__c tempDeal;
        for (i = 0; i < dataAmount; i++) {
            tempDeal = createDeal(contactList[i], String.valueOf(i));
            tempDeal.Program__c = programList[i].Id;
            tempDeal.Agency_Deal_Number__c = 'test';
            tempDeal.Brands__c = brandList[i].Id;
            tempDeal.Contact__c = contactList[i].Id;
            dealList.add(tempDeal);
        }

        insert dealList;

        Schedules__c tempSchedule;
        for (i = 0; i < dataAmount; i++) {
            tempSchedule = createSchedule(dealList[i]);
            tempSchedule.LF_Brand__c = brandList[i].Id;
            tempSchedule.Deal_Parent__c = dealList[i].Id;
            scheduleList.add(tempSchedule);
        }
        PrepDealSelectionReturn returnClass = new PrepDealSelectionReturn(scheduleList, dealList);
        return returnClass;
    }

    public class PrepDealSelectionReturn {
        List<Schedules__c> schedules;
        List<Deal__c> deals;

        PrepDealSelectionReturn(List<Schedules__c> scheduleList, List<Deal__c> dealList) {
            this.schedules = scheduleList;
            this.deals = dealList;
        }
    }

    private static List<Deal__c> findDealsForController(Deal__c dealSearch) {
        return [
                SELECT Id,
                       Name,
                       Program__c,
                       Brands__c,
                       Contact__c,
                       Length__c,
                       Campaign__c,
                       Client_Account__c,
                       Week_MIN_Field__c,
                       Agency_Deal_Number__c,
                       Network_Deal_Number__c,
                       Sum_of_Total_Dollars__c,
                       Sum_of_Units_Available__c,
                       Program__r.Id,
                       Contact__r.Id,
                       Contact__r.Account.Id,
                       Brands__r.Id,
                       Program__r.Name,
                       Contact__r.Name,
                       Client_Account__r.Name,
                       Brands__r.Name,
                       CreatedDate,
                       ContactAccount__c
                  FROM Deal__c
                 WHERE Id = :dealSearch.Id
        ];
    }
}