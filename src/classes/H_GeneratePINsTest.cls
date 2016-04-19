@isTest
private class H_GeneratePINsTest {
	
	private static Account acc;
	private static Contact con;
	private static Campaign cam;
	

	private static void setupTestValues() {

		//Create an Account
		acc = new Account(Name = 'MS',
							Dealer_Code__c = '2008');
		insert acc;

		//create Contact
		con = new Contact(FirstName = 'MS',
							LastName = 'MS',
							AccountId = acc.Id);
		insert con;


		//Create a campaign;
		cam = new Campaign(Name = 'Test Campaign 123',
							IsActive = true,
							Status = 'In Progress',
							StartDate = Date.today(),
							EndDate = Date.today().addDays(1));
		insert cam;

		CampaignMember cm = new CampaignMember(ContactId = con.Id, 
												CampaignId = cam.Id);

		insert cm;
	}

	@isTest
	private static void executeGeneratePINsButton_Test() {
		setupTestValues();

		Test.startTest();

		H_GeneratePINs.executeGeneratePINsBatch(cam.Id, 3);
		Test.stopTest();
		
		List<PIN__c> pinsInserted = [SELECT Id FROM PIN__c];
		System.assert(pinsInserted.size() == 3, '3 pins inserted per contact.');

	}

	@isTest
	private static void logErrors_Test() {
		setupTestValues();

		Test.startTest();

		List<PIN__c> pinsToCreate = new List<PIN__c>();

		// Pretend to insert pins where the Pin Code is the same value
		for(Integer i = 0; i < 2; i++) {
			
			PIN__c pin = new PIN__c();
			pin.Name = 'pin123';
			pin.Pin_Code__c = 'pin123';
			pin.Campaign__c = cam.Id;
			pin.Customer__c = con.Id; 
			pin.Status__c = 'Active';
			
			
			pinsToCreate.add(pin);
			
		}

		Database.SaveResult[] srList = Database.insert(pinsToCreate, false);

		insert H_GeneratePINs.createErrorLogs(srList, 'Test', 'test', 'test', 'Test', 'Test' , pinsToCreate);

		Test.stopTest();

		List<ErrorLog__c> errorLogs = [SELECT Id FROM ErrorLog__c];
		System.assert(errorLogs.size() > 0, '1 error log inserted because a duplicate pincode pin record cannot be inserted');
	}



}