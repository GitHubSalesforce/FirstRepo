@isTest
private class H_GenerateExceptionPINsControllerTest {
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

		Test.setCurrentPageReference(new PageReference('Page.H_GenerateExceptionPINs')); 
		System.currentPageReference().getParameters().put('id', cam.Id);


		Test.startTest();

		H_GenerateExceptionPINsController ctlr = new H_GenerateExceptionPINsController();
		ctlr.numberOfPins = 10;

		ctlr.generateExceptionPINs();


		Test.stopTest();


	}

}