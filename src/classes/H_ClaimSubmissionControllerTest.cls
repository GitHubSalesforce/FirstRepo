@isTest
private class H_ClaimSubmissionControllerTest {
	
	private static final Id ACM_RT = Schema.SObjectType.Entitlement__c.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();

	private static Account acc;
	private static Contact con;
	private static User portalUser;
	private static Campaign cam;
	private static PIN__c p;
	private static VIN__c v;
	private static Product__c prod;
	private static ServiceHistorys__x shx;
	private static Entitlement__c entitlement;
	private static ACM_Entitlement_Settings__c acmEntitlements;

	private static void setupTestValues() {

		Id pId = [select id from profile where name='Dealer Community User'].id;

		//Create an Account
		acc = new Account(Name = 'MS',
							Dealer_Code__c = '2008');
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
							EndDate = Date.today().addDays(1));
		insert cam;

		// Create a PIN
		p = new PIN__c(Name = 'pin123',
						  Campaign__c = cam.Id,
						  Status__c = 'Active');
		insert p;

		prod = new Product__c(Model_Group__c = 'RL', MDL_YR_CD__c = 'RL2005', Model_Year__c = '2005');
		insert prod;

		v = new VIN__c(ProductSerialNumber__c = 'vin123', Product__c = prod.Id);
		insert v;

		//Create RO
		shx = new ServiceHistorys__x(RoVin__c = v.Id, RoNum__c = 'ro123', MileageIn__c = '190000');
	//	Database.insertImmediate(shx);

		acmEntitlements = new ACM_Entitlement_Settings__c();
     	acmEntitlements.Name = 'RL 2010';
     	acmEntitlements.ACM_Duration__c = 1;
     	acmEntitlements.ACM_Duration_Unit__c = 'Years';
     	acmEntitlements.ACM_KM_Limit__c = 900000;
     	acmEntitlements.Main_Symbols__c = 'A;B';
     	acmEntitlements.Sub_Symbols__c = '1;2;3;4;5';

     	insert acmEntitlements;
		entitlement = new Entitlement__c(VIN__c = v.Id, RecordTypeId = ACM_RT, ACM_Entitlement_Settings__c = acmEntitlements.Id);
		insert entitlement;

		Regionalized_Grouping__c rg = new Regionalized_Grouping__c(Name='AZ-Dlr 2008');

		insert rg;

		List<Regional_Pricing_Model__c> regionalPricingModelsList = new List<Regional_Pricing_Model__c>();

		Regional_Pricing_Model__c r1 = new Regional_Pricing_Model__c(Product__c = prod.Id, 
																		Symbol_Description__c = 'test',
																		Symbol__c = 'A',
																		Regionalized_Grouping__c = rg.Id,
																		Price__c = 10.00);
		regionalPricingModelsList.add(r1);
		
		Regional_Pricing_Model__c r2 = new Regional_Pricing_Model__c(Product__c = prod.Id, 
																		Symbol_Description__c = 'test',
																		Symbol__c = 'B',
																		Regionalized_Grouping__c = rg.Id,
																		Price__c = 20.00);
		regionalPricingModelsList.add(r2);
		Regional_Pricing_Model__c r3 = new Regional_Pricing_Model__c(Product__c = prod.Id, 
																		Symbol_Description__c = 'test',
																		Symbol__c = '1',
																		Regionalized_Grouping__c = rg.Id,
																		Price__c = 30.00);
		regionalPricingModelsList.add(r3);
		Regional_Pricing_Model__c r4 = new Regional_Pricing_Model__c(Product__c = prod.Id, 
																		Symbol_Description__c = 'test',
																		Symbol__c = '2',
																		Regionalized_Grouping__c = rg.Id,
																		Price__c = 30.00);
		
		regionalPricingModelsList.add(r4);
		Regional_Pricing_Model__c r5 = new Regional_Pricing_Model__c(Product__c = prod.Id, 
																		Symbol_Description__c = 'test',
																		Symbol__c = '3',
																		Regionalized_Grouping__c = rg.Id,
																		Price__c = 30.00);
		regionalPricingModelsList.add(r5);

		insert regionalPricingModelsList;



	}


	@isTest
	private static void updateLanguage_Test() {
		setupTestValues();

		Test.startTest();

		system.runAs(portalUser) {
           H_ClaimSubmissionController ctlr = new H_ClaimSubmissionController(); 
           ctlr.updateLanguage();

        }
		Test.stopTest();
		portalUser = [SELECT Id, LanguageLocaleKey FROM User WHERE Id =: portalUser.Id LIMIT 1];
		System.assert(portalUser.LanguageLocaleKey == 'fr', 'Portal User\'s Language updated form english to french');

	}

	@isTest
	private static void submitClaimValid_Test() {
		setupTestValues();

		Test.startTest();
	


		system.runAs(portalUser) {
           	H_ClaimSubmissionController.mockedServiceHistorys.add(shx);
			H_ClaimSubmissionController ctlr = new H_ClaimSubmissionController(); 
        	
           	ctlr.getMainSymbols();
           	ctlr.getSubSymbols();

           	ctlr.vinCode = 'vin123';
           	ctlr.roNumber = 'ro123';
           	//ctlr.model = 'RL';
           	ctlr.selectedMainSymbol = 'A';
           	ctlr.selected1stSubSymbol = '1';
           	ctlr.selected2ndSubSymbol = '2';
           	ctlr.selected3rdSubSymbol = '3';

           	ctlr.submitClaim();
           	ctlr.confirmClaim();

        }
		Test.stopTest();
		List<Claim__c> claim = [SELECT Id, X1st_Sub_Symbol__c, X2nd_Sub_Symbol__c, X3rd_Sub_Symbol__c, Main_Symbol__c, Model__c, Price_of_1st_Sub_Symbol__c,
									Price_of_2nd_Sub_Symbol__c, Price_of_3rd_Sub_Symbol__c, Price_of_Main_Symbol__c, Valid_Date__c, Valid_KM_Limit__c, VIN__c
									FROM Claim__c];

		System.assert(claim.size() == 1, '1 claim created');


	}

	@isTest
	private static void alreadySubmittedClaim_Test() {
		setupTestValues();
		
		//Create an existing Claim
		Claim__c claim = new Claim__c(X1st_Sub_Symbol__c = '1', 
									X2nd_Sub_Symbol__c = '2',
									X3rd_Sub_Symbol__c = '3',
									Main_Symbol__c = 'A',
									Model__c = 'RL',
									Price_of_1st_Sub_Symbol__c = 30.00,
									Price_of_2nd_Sub_Symbol__c = 30.00,
									Price_of_3rd_Sub_Symbol__c = 30.00,
									Price_of_Main_Symbol__c = 10.00,
									MileageIn__c = '123',
									VIN__c = v.Id,
									Entitlement__c = entitlement.Id);
		insert claim;

		Test.startTest();

		system.runAs(portalUser) {
           	H_ClaimSubmissionController.mockedServiceHistorys.add(shx);
			H_ClaimSubmissionController ctlr = new H_ClaimSubmissionController(); 
        	
           	ctlr.getMainSymbols();
           	ctlr.getSubSymbols();

           	ctlr.vinCode = 'vin123';
           	ctlr.roNumber = 'ro123';
           	//ctlr.model = 'RL';
           	ctlr.selectedMainSymbol = 'A';
           	ctlr.selected1stSubSymbol = '1';
           	ctlr.selected2ndSubSymbol = '2';
           	ctlr.selected3rdSubSymbol = '3';

           	ctlr.submitClaim();


        }
		Test.stopTest();

		List<Claim__c> claims= [SELECT Id, X1st_Sub_Symbol__c, X2nd_Sub_Symbol__c, X3rd_Sub_Symbol__c, Main_Symbol__c, Model__c, Price_of_1st_Sub_Symbol__c,
									Price_of_2nd_Sub_Symbol__c, Price_of_3rd_Sub_Symbol__c, Price_of_Main_Symbol__c, Valid_Date__c, Valid_KM_Limit__c, VIN__c
									FROM Claim__c];

		System.assert(claims.size() == 1, 'There is already a claim on the RO, another claim cannot be inserted');


	}

	@isTest
	private static void testButtons() {
		setupTestValues();

		Test.setCurrentPage(Page.H_ClaimSubmission);

		Test.startTest();

		system.runAs(portalUser) {
           	
        	H_ClaimSubmissionController.mockedServiceHistorys.add(shx);
			H_ClaimSubmissionController ctlr = new H_ClaimSubmissionController(); 

           	ctlr.getMainSymbols();
           	ctlr.getSubSymbols();

           	ctlr.vinCode = 'vin123';
           	ctlr.roNumber = 'ro123';
           	//ctlr.model = 'RL';
           	ctlr.selectedMainSymbol = 'A';
           	ctlr.selected1stSubSymbol = '1';
           	ctlr.selected2ndSubSymbol = '2';
           	ctlr.selected3rdSubSymbol = '3';

           	ctlr.submitClaim();

           	ctlr.goBack();
           	ctlr.refreshPage();

        }
		Test.stopTest();

	}
}