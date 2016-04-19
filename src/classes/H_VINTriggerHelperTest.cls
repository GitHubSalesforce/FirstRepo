@isTest
private class H_VINTriggerHelperTest {
    private static Account acc;
    private static Contact con;
    private static User portalUser;
    private static Campaign cam;
    private static PIN__c p;
    private static VIN__c v;
    private static Product__c vinProduct;
    private static ACM_Entitlement_Settings__c acmEntitlements;

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
        
        vinProduct = new Product__c(Model_Group__c = 'RL', Model_Year__c = '2010', MDL_YR_CD__c = 'RL2010');
        insert vinProduct;

        acmEntitlements = new ACM_Entitlement_Settings__c();
        acmEntitlements.Name = 'RL 2010';
        acmEntitlements.ACM_Duration__c = 1;
        acmEntitlements.ACM_Duration_Unit__c = 'Years';
        acmEntitlements.ACM_KM_Limit__c = 900000;
        acmEntitlements.Main_Symbols__c = 'A;B';
        acmEntitlements.Sub_Symbols__c = '1;2;3;4;5';
        acmEntitlements.Product__c = vinProduct.Id;

        insert acmEntitlements;

    }


    @isTest
    private static void test_insert_vin_with_entitlements() {
        setupTestValues();

        Test.startTest();

        v = new VIN__c(ProductSerialNumber__c = 'vin123', Retail_Process_Date__c = Date.today().addDays(-3), Product__c = vinProduct.Id);
        insert v;
        

        Test.stopTest();
        List<Entitlement__c> eList = [SELECT Id, Complimentary_Maintenance_Start_Date__c FROM Entitlement__c];
        System.assert(eList.size() > 0, 'Entitlement was inserted against the VIN');
        System.assert(eList[0].Complimentary_Maintenance_Start_Date__c == Date.today().addDays(-3), 'The Complimentary Maintenance Start Date is the same say as the Retail Process Date');


    }

}