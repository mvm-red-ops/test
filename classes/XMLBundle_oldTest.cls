@isTest
public class XMLBundle_oldTest {
	
	// Test Data class for use below. Builds basic test records that have the neccessary details for building the XML files
	public class TestData {
		public Advertiser__c advertiser {get; set;}
		public Brands__c brand {get; set;}
		public Contact contact {get; set;}
		public Programs__c program {get; set;}
		public Deal__c deal {get; set;}
		public Market__c market {get; set;}
		public Station__c station {get; set;}

		public TestData () {}

		public TestData createNewAdvertiser() {
			this.advertiser = new Advertiser__c(Name = 'TestAdvertiser', Duplicate_Approval__c = 'Approved', Advertiser_Approved_to_Book__c = true);
			insert this.advertiser;

			return this;
		}

		public TestData createNewBrand() {
			if(this.advertiser == null) {
				this.createNewAdvertiser();
			}

			this.brand = new Brands__c(Name = 'Test Brand', Advertiser__c = this.advertiser.Id, Approved_Duplicate__c = 'Approved', Category__c = 'Other');
			insert this.brand;

			return this;
		}

		public TestData createNewContact() {
			Account a = new Account(Name = 'Test Account');
			insert a;

			this.contact = new Contact(LastName = 'Smith', FirstName = 'Joe', AccountId = a.Id, Email = 'test@test.com', Phone = '8001234567');
			insert this.contact;

			return this;
		}

		public TestData createNewProgram() {
			if(this.contact == null) {
				this.createNewContact();
			}

			this.program = new Programs__c(Name = 'TestProgram', ClientCode__c = '123', Bundle_Name__c = 'Hearst', Logs_Contact__c = this.contact.Id);
			insert this.program;

			return this;
		}

		public TestData createNewDeal() {
			if(this.brand == null) {
				this.createNewBrand();
			}

			if(this.contact == null) {
				this.createNewContact();
			}

			if(this.program == null) {
				this.createNewProgram();
			}

			this.deal = new Deal__c(Brands__c = this.brand.Id,
				Contact__c = this.contact.Id,
				Program__c = this.program.Id,
				Length__c = '60',
				Bundle_Start_Week__c = Date.newInstance(2015, 9, 28),
				Status__c = 'Historical');
			insert this.deal;
			this.deal = [SELECT Id, Brands__c, Bundle_Start_Week__c, Contact__c, Program__c, Length__c, Name FROM Deal__c WHERE Id = :this.deal.Id];

			return this;
		}

		public TestData createNewMarket(String name) {
			this.market = new Market__c(Name = name);
			insert this.market;

			return this;
		}

		public TestData createNewStation(String marketName, String callLetters) {
			this.createNewMarket(marketName);
			this.station = new Station__c(Market__c = this.market.Id, Call_Letters__c = callLetters);
			insert this.station;

			return this;
		}

	}

	@isTest static void test_ScheduleChunkWrapper() {
		Date chunkStart = Date.newInstance(2000, 1, 1);
		Date chunkEnd = Date.newInstance(2001, 2, 20);

		XMLBundle_old.ScheduleChunkWrapper wrapper = new XMLBundle_old.ScheduleChunkWrapper(chunkStart, chunkEnd, 1, 'ID12345');

		System.assertEquals('2000-01-01', wrapper.chunkStart);
		System.assertEquals('2001-02-20', wrapper.chunkEnd);
		System.assertEquals(1, wrapper.weekCount);
		System.assertEquals('ID12345', wrapper.scheduleIds);
	}

	@isTest static void test_buildScheduleList() {
		// Setup test data
		TestData td = new TestData();
		td.createNewDeal();

		// Insert single schedule and verify
		List<Schedules__c> schedules = new List<Schedules__c>();
		Schedules__c s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
		schedules.add(s);
		insert schedules;

		List<XMLBundle_old.ScheduleChunkWrapper> scheduleChunks = XMLBundle_old.buildScheduleList(td.deal.Id, td.deal.Bundle_Start_Week__c);
		System.assertEquals(scheduleChunks.size(), 1);
		System.assertEquals('2015-09-28', scheduleChunks[0].chunkStart);
		System.assertEquals('2015-10-04', scheduleChunks[0].chunkEnd);
		System.assertEquals(1, scheduleChunks[0].weekCount);
		System.assertEquals(s.Id, scheduleChunks[0].scheduleIds);

		// Insert old schedule from previous week and make sure it is not included
		s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 21));
		schedules.add(s);
		upsert schedules;

		scheduleChunks = XMLBundle_old.buildScheduleList(td.deal.Id, td.deal.Bundle_Start_Week__c);
		System.assertEquals(scheduleChunks.size(), 1);
		System.assertEquals('2015-09-28', scheduleChunks[0].chunkStart);
		System.assertEquals('2015-10-04', scheduleChunks[0].chunkEnd);
		System.assertEquals(1, scheduleChunks[0].weekCount);
		System.assertEquals(schedules[0].Id, scheduleChunks[0].scheduleIds);

		// Insert 3 more schedules and verify
		s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 12));
		schedules.add(s);
		s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 10, 19));
		schedules.add(s);
		s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 11, 9));
		schedules.add(s);
		upsert schedules;

		scheduleChunks = XMLBundle_old.buildScheduleList(td.deal.Id, td.deal.Bundle_Start_Week__c);
		System.assertEquals(scheduleChunks.size(), 3);

		System.assertEquals('2015-09-28', scheduleChunks[0].chunkStart);
		System.assertEquals('2015-10-04', scheduleChunks[0].chunkEnd);
		System.assertEquals(1, scheduleChunks[0].weekCount);

		System.assertEquals('2015-10-12', scheduleChunks[1].chunkStart);
		System.assertEquals('2015-10-25', scheduleChunks[1].chunkEnd);
		System.assertEquals(2, scheduleChunks[1].weekCount);

		System.assertEquals('2015-11-09', scheduleChunks[2].chunkStart);
		System.assertEquals('2015-11-15', scheduleChunks[2].chunkEnd);
		System.assertEquals(1, scheduleChunks[2].weekCount);
	}

	@isTest static void test_StationWrapper() {
		XMLBundle_old.StationWrapper wrapper = new XMLBundle_old.StationWrapper('WMUR', 'Manchester');
		System.assertEquals('WMUR', wrapper.callLetters);
		System.assertEquals('Manchester', wrapper.marketName);
		System.assertEquals(0, wrapper.pricingList.size());

		wrapper.pricingList.add(new Bundle_Pricing__c());
		System.assertEquals(1, wrapper.pricingList.size());
	}

	@isTest static void test_buildStationList() {
		// Setup test data
		TestData td = new TestData();
		td.createNewProgram();

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

		insert bundlePricingList;

		bundlePricingList = [SELECT Id, Call_Letters__c, Station__r.Market__r.Name FROM Bundle_Pricing__c];
		System.assertEquals(4, bundlePricingList.size());

		// Check results
		Map<String, XMLBundle_old.StationWrapper> stations = XMLBundle_old.buildStationList(bundlePricingList);
		System.assertEquals(3, stations.keySet().size());

		System.assertEquals('WMUR', stations.get('WMUR').callLetters);
		System.assertEquals('Manchester', stations.get('WMUR').marketName);
		System.assertEquals(1, stations.get('WMUR').pricingList.size());

		System.assertEquals('KCCI', stations.get('KCCI').callLetters);
		System.assertEquals('Des Moines', stations.get('KCCI').marketName);
		System.assertEquals(2, stations.get('KCCI').pricingList.size());

		System.assertEquals('KCRA', stations.get('KCRA').callLetters);
		System.assertEquals('Sacramento', stations.get('KCRA').marketName);
		System.assertEquals(1, stations.get('KCRA').pricingList.size());
	}

	@isTest static void test_civilianToMilitaryTime() {
		String timeStr = '1:00A';
		System.assertEquals('1:00', XMLBundle_old.civilianToMilitaryTime(timeStr));

		timeStr = '10:15A';
		System.assertEquals('10:15', XMLBundle_old.civilianToMilitaryTime(timeStr));

		timeStr = '2:30P';
		System.assertEquals('14:30', XMLBundle_old.civilianToMilitaryTime(timeStr));

		timeStr = '11:40P';
		System.assertEquals('23:40', XMLBundle_old.civilianToMilitaryTime(timeStr));

		// Handle special case for midnight
		timeStr = '12:00A';
		System.assertEquals('00:00', XMLBundle_old.civilianToMilitaryTime(timeStr));

		// Handle special case for noon
		timeStr = '12:00P';
		System.assertEquals('12:00', XMLBundle_old.civilianToMilitaryTime(timeStr));

		// Handle special case for 12:15A
		timeStr = '12:15A';
		System.assertEquals('00:15', XMLBundle_old.civilianToMilitaryTime(timeStr));

		// Handle special case for 12:15P
		timeStr = '12:15P';
		System.assertEquals('12:15', XMLBundle_old.civilianToMilitaryTime(timeStr));

		timeStr = 'foobar';
		System.assertEquals('Error: Invalid time string', XMLBundle_old.civilianToMilitaryTime(timeStr));
	}

	@isTest static void test_saveData() {
		// Setup test data
		TestData td = new TestData();
		td.createNewDeal();

		// Send bad Deal Id, insert should fail
		String result = XMLBundle_old.saveData('12345', 'filename', 'samplefiledata');
		System.assertNotEquals('SUCCESS', result);

		List<Attachment> att = [SELECT Id, Name, ParentId FROM Attachment];
		System.assertEquals(0, att.size());

		// Send valid Deal Id, everything works as expected
		result = XMLBundle_old.saveData(td.deal.Id, 'HearstBundle.zip', 'samplefiledata');
		System.assertEquals('SUCCESS', result);

		att = [SELECT Id, Name, ParentId FROM Attachment];
		System.assertEquals(1, att.size());
		System.assertEquals(td.deal.Id, att[0].ParentId);
		System.assertEquals('HearstBundle.zip', att[0].Name);
	}

	@isTest static void test_markXMLSent() {
		// Setup test data
		TestData td = new TestData();
		td.createNewDeal();

		// Insert single schedule and verify
		List<Schedules__c> schedules = new List<Schedules__c>();
		Schedules__c s = new Schedules__c(Deal_Parent__c = td.deal.Id, Units_Available__c = 1, Rate__c = 10, Week__c = Date.newInstance(2015, 9, 28));
		schedules.add(s);
		insert schedules;

		String result = XMLBundle_old.markXMLSent(schedules[0].Id);
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

		result = XMLBundle_old.markXMLSent(String.join(scheduleIds, ';'));
		System.assertEquals('SUCCESS', result);

		schedules = [SELECT XML_Sent__c FROM Schedules__c WHERE Id IN :scheduleIds];
		for(Schedules__c schedule : schedules) {
			System.assertEquals(true, schedule.XML_Sent__c);
		}

		// Test with an invalid Id
		result = XMLBundle_old.markXMLSent('12345');
		System.assertNotEquals('SUCCESS', result);
	}
	
}