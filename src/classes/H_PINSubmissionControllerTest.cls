@isTest
private class H_PINSubmissionControllerTest {
	
	private static Account acc;
	private static Contact con;
	private static User portalUser;
	private static Campaign cam;
	private static PIN__c p;
	private static VIN__c v;

	private final static Id ACM_RT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();


	private static void setupTestValues() {
		Id pId = [select id from profile where name='Dealer Community User'].id;

		//Create an Account
		acc = new Account(Name = 'MS',
							Dealer_Code__c = 'dd123');

		insert acc;

		//create Contact
		con = new Contact(FirstName = 'MS',
							LastName = 'MS',
							AccountId = acc.Id);
		insert con;

		//Create User
		portalUser = new User(alias = 'test123', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
                ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

		insert portalUser;

		//Create a campaign;
		cam = new Campaign(Name = 'Test Campaign 123',
							IsActive = true,
							Status = 'In Progress',
							StartDate = Date.today(),
							EndDate = Date.today().addDays(1),
							RecordTypeId = ACM_RT,
							Complimentary_Maintenance_KM_Limit__c = 9000000,
							Complimentary_Maintenance_Duration__c = 1,
							Complimentary_Maintenance_Duration_Unit__c = 'Years',
							Main_Symbols__c = 'A;B',
							Sub_Symbols__c = '1;2;3;4;5');
		insert cam;

		// Create a PIN
		p = new PIN__c(Name = 'pin123',
						  Campaign__c = cam.Id,
						  Status__c = 'Active');
		insert p;

		v = new VIN__c(ProductSerialNumber__c = 'vin123', Retail_Process_Date__c = Date.today().addDays(-3));
		insert v;

	}

	@isTest
	private static void test_update_language() {
		setupTestValues();

		Test.startTest();

		system.runAs(portalUser) {
           H_PINSubmissionController ctlr = new H_PINSubmissionController(); 
           ctlr.updateLanguage();

        }
		Test.stopTest();
		portalUser = [SELECT Id, LanguageLocaleKey FROM User WHERE Id =: portalUser.Id LIMIT 1];
		System.assert(portalUser.LanguageLocaleKey == 'fr', 'Portal User\'s Language updated form english to french');

	}


	@isTest 
	private static void test_verify_redeemed_pin() {
		setupTestValues();
		p.Status__c = 'Redeemed';

		update p;
		H_PINSubmissionController ctlr;

		Test.startTest();

		system.runAs(portalUser) {
			ctlr = new H_PINSubmissionController();
			ctlr.pinCode = p.Name;
			ctlr.verifyPIN();
		}
		Test.stopTest();

		System.assert(ctlr.invalidType == 'Redeemed', 'When a Redeemed PIN is verified, the invalidType is set as REDEEMED.');
	}
	
	@isTest 
	private static void test_verify_expired_pin() {
		setupTestValues();
		p.Status__c = 'Expired';

		update p;
		H_PINSubmissionController ctlr;

		Test.startTest();
		system.runAs(portalUser) {
			ctlr = new H_PINSubmissionController();
			ctlr.pinCode = p.Name;
			ctlr.verifyPIN();
			Test.stopTest();
		}

		System.assert(ctlr.invalidType == 'Expired', 'When an Expired PIN is verified, the invalidType is set as EXPIRED.');
	}

	@isTest 
	private static void test_verify_active_pin() {
		setupTestValues();

		Test.startTest();
		H_PINSubmissionController ctlr = new H_PINSubmissionController();
		ctlr.pinCode = p.Name;
		ctlr.verifyPIN();
		Test.stopTest();

		System.assert(ctlr.invalidType == 'Active', 'When an active PIN is verified, the invalidType is set as ACTIVE.');
	}

	@isTest 
	private static void test_verify_invalid_pin() {
		setupTestValues();

		Test.startTest();
		H_PINSubmissionController ctlr = new H_PINSubmissionController();
		ctlr.pinCode = 'tsdfss';
		ctlr.verifyPIN();
		Test.stopTest();

		System.assert(ctlr.invalidType == 'Invalid', 'When an invalid PIN is verified, the invalidType is set as INVALID.');
	}

	@isTest 
	private static void test_submit_active_pin() {
		setupTestValues();

		Test.startTest();
		H_PINSubmissionController ctlr = new H_PINSubmissionController();
		ctlr.pinCode = p.Name;
		ctlr.vinCode = v.ProductSerialNumber__c;
		ctlr.dealerCode = acc.Dealer_Code__c;
		ctlr.submitPIN();

		Test.stopTest();

		p = [SELECT Id, VIN_Serial_Number__c, Status__c FROM PIN__c where ID =: p.Id];
		List<Entitlement__c> eList = [SELECT Id from Entitlement__c WHERE VIN__c =: p.VIN_Serial_Number__c LIMIT 1];

		System.assert(ctlr.invalidType == 'Submitted', 'When an invalid PIN is submmited, the invalidType is set as Submitted.');
		System.assert(p.Status__c == 'Redeemed', 'The PIN is updated from Active to Redeemed');
		System.assert(eList.size() > 0, 'An entitlement record was created.');
	}

	@isTest 
	private static void test_submit_null_pin_null_vin() {
		setupTestValues();

		Test.startTest();
		H_PINSubmissionController ctlr = new H_PINSubmissionController();
		ctlr.pinCode = null;
		ctlr.vinCode = null;
		ctlr.submitPIN();
		Test.stopTest();

		System.assert(ctlr.invalidType == 'Invalid', 'When an invalid PIN is verified, the invalidType is set as INVALID.');
	}


	
}