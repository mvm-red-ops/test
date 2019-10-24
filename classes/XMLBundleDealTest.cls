@isTest
private class XMLBundleDealTest {

    @isTest static void test_controller() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        Deal__c deal = [SELECT Id, Brands__r.Name, ContactAccount__c, Name FROM Deal__c WHERE Id = :td.deal.Id];

        PageReference pageRef = Page.XMLBundleDeal;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', deal.Id);

        XMLBundleDeal controller = new XMLBundleDeal();

        System.assertEquals(deal.Id, controller.dealId);

        String expectedFileName = 'Hearst-' + deal.Name + '-' + deal.ContactAccount__c + '-' + deal.Brands__r.Name + '-NEW BUY-';
        System.assert(controller.zipFileName.startsWith(expectedFileName));
    }

    @isTest static void test_saveData() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        // Send bad Deal Id, insert should fail
        String result = XMLBundleDeal.saveData('12345', 'filename', 'samplefiledata');
        System.assertNotEquals('SUCCESS', result);

        List<Attachment> att = [SELECT Id, Name, ParentId FROM Attachment];
        System.assertEquals(0, att.size());

        // Send valid Deal Id, everything works as expected
        result = XMLBundleDeal.saveData(td.deal.Id, 'HearstBundle.zip', 'samplefiledata');
        System.assertEquals('SUCCESS', result);

        att = [SELECT Id, Name, ParentId FROM Attachment];
        System.assertEquals(1, att.size());
        System.assertEquals(td.deal.Id, att[0].ParentId);
        System.assertEquals('HearstBundle.zip', att[0].Name);
    }

    @isTest static void test_markXMLSent() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        // Insert single schedule and verify
        List<Schedules__c> schedules = new List<Schedules__c>();
        Schedules__c s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
        schedules.add(s);
        insert schedules;

        String result = XMLBundleDeal.markXMLSent(schedules[0].Id);
        System.assertEquals('SUCCESS', result);
        s = [SELECT XML_Sent__c FROM Schedules__c WHERE Id = :schedules[0].Id];
        System.assertEquals(true, s.XML_Sent__c);

        // Insert 3 more schedules and verify
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 12));
        schedules.add(s);
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 19));
        schedules.add(s);
        s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 11, 9));
        schedules.add(s);
        upsert schedules;

        List<String> scheduleIds = new List<String>();
        for(Schedules__c schedule : schedules) {
            scheduleIds.add(schedule.Id);
        }

        result = XMLBundleDeal.markXMLSent(String.join(scheduleIds, ';'));
        System.assertEquals('SUCCESS', result);

        schedules = [SELECT XML_Sent__c FROM Schedules__c WHERE Id IN :scheduleIds];
        for(Schedules__c schedule : schedules) {
            System.assertEquals(true, schedule.XML_Sent__c);
        }

        // Test with an invalid Id
        result = XMLBundleDeal.markXMLSent('12345');
        System.assertNotEquals('SUCCESS', result);
    }

    // Run through the whole XML generating process
    @isTest static void test_getXMLFiles() {
        // Setup test data
        XMLBundleTest.TestData td = new XMLBundleTest.TestData();
        td.createNewDeal();

        List<Schedules__c> schedules = new List<Schedules__c>();
        schedules.add(new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28)));
        schedules.add(new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 12)));
        schedules.add(new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 19)));
        schedules.add(new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 11, 9)));
        insert schedules;

        List<Bundle_Pricing__c> bundlePricingList = new List<Bundle_Pricing__c>();

        td.createNewStation('Manchester', 'WMUR');
        bundlePricingList.add(new Bundle_Pricing__c(
            Program__c = td.program.Id,
            Station__c = td.station.Id,
            Days__c = 'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday',
            End_Time__c = '6:00A',
            Rate_per_30__c = 15,
            Start_Time__c = '1:00A',
            Units__c = 2,
            Active__c = true
        ));

        td.createNewStation('Des Moines', 'KCCI');
        bundlePricingList.add(new Bundle_Pricing__c(
            Program__c = td.program.Id,
            Station__c = td.station.Id,
            Days__c = 'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday',
            End_Time__c = '1:00P',
            Rate_per_30__c = 10,
            Start_Time__c = '7:00A',
            Units__c = 3,
            Active__c = true
        ));

        td.createNewStation('Sacramento', 'KCRA');
        bundlePricingList.add(new Bundle_Pricing__c(
            Program__c = td.program.Id,
            Station__c = td.station.Id,
            Days__c = 'Monday; Tuesday; Wednesday; Thursday; Friday; Saturday; Sunday',
            End_Time__c = '12:00A',
            Rate_per_30__c = 20,
            Start_Time__c = '6:00P',
            Units__c = 2,
            Active__c = true
        ));


        bundlePricingList.add(new Bundle_Pricing__c(
                Program__c = td.program.Id,
                Station__c = td.station.Id,
                Days__c = 'Monday; Tuesday; Wednesday; Thursday; Friday',
                End_Time__c = '1:00P',
                Rate_per_30__c = 15,
                Start_Time__c = '10:00P',
                Units__c = 4,
                Active__c = true
        ));

        insert bundlePricingList;

        // Check result
        Map<String, String> result = XMLBundleDeal.getXMLFiles(td.deal.Id);
        System.assertEquals(4, result.keySet().size());

        // Generate correct filenames and assert
        List<String> filenames = new List<String>();
        String baseFileName = '-' + td.deal.Name + '-Test Account-Test Brand-NEW BUY-';
        Date d = Date.today();
        baseFileName += d.year();
        if(d.month() > 9) {
            baseFileName += '-' + d.month();
        } else {
            baseFileName += '-0' + d.month();
        }

        if(d.day() > 9) {
            baseFileName += '-' + d.day();
        } else {
            baseFileName += '-0' + d.day();
        }
        baseFileName += '.xml';

        filenames.add('WMUR' + baseFileName);
        filenames.add('KCCI' + baseFileName);
        filenames.add('KCRA' + baseFileName);

        System.assert(result.containsKey(filenames[0]));
        System.assert(result.containsKey(filenames[1]));
        System.assert(result.containsKey(filenames[2]));


        String scheduleString = result.get('scheduleIds');
        List<String> scheduleIds = new List<String>();
        for(Schedules__c schedule : schedules) {
            scheduleIds.add(schedule.Id);
        }
        System.assertEquals(String.join(scheduleIds, ';'), scheduleString);
    }
}