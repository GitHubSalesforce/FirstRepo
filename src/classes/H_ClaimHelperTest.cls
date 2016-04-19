@isTest
private class H_ClaimHelperTest {

	@isTest
	private static void testManualShareRead_oneRecord(){

		List<Contact> contactsList = new List<Contact>();
		List<User> portalUsersList = new List<User>();

		Id pId = [select id from profile where name='Dealer Community User'].id;

		//Create an Account
		Account acc = new Account(Name = 'MS',
								Dealer_Code__c = '2008');
		insert acc;

		//create Contact
		Contact con = new Contact(FirstName = 'MS',
									LastName = 'MS',
									AccountId = acc.Id);
		contactsList.add(con);

		Contact con2 = new Contact(FirstName = 'TS',
									LastName = 'TS',
									AccountId = acc.Id);
		contactsList.add(con2);

		insert contactsList;

		//Create User
		User portalUser = new User(alias = 'test123', email='test123@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

		portalUsersList.add(portalUser);

		User portalUser2 = new User(alias = 'te222', email='test1233333@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con2.Id, timezonesidkey='America/Los_Angeles', username='tester232323@noemail.com');

		portalUsersList.add(portalUser2);

		insert portalUsersList;

		Product__c prod = new Product__c(Model_Group__c = 'RL', MDL_YR_CD__c = 'RL2005', Model_Year__c = '2005');
		insert prod;

		VIN__c v = new VIN__c(ProductSerialNumber__c = 'vin123', Product__c = prod.Id);
		insert v;

		//Create RO
		ServiceHistorys__x shx = new ServiceHistorys__x(RoVin__c = v.Id, RoNum__c = 'ro123', MileageIn__c = '190000');

   		List<Claim__c> claimsList = new List<Claim__c>();

   		Test.startTest();
   		
   		System.runAs(portalUser) {
   			//Create an existing Claim
   			Claim__c c = new Claim__c(X1st_Sub_Symbol__c = '1', 
									X2nd_Sub_Symbol__c = '2',
									X3rd_Sub_Symbol__c = '3',
									Main_Symbol__c = 'A',
									Model__c = 'RL',
									Price_of_1st_Sub_Symbol__c = 30.00,
									Price_of_2nd_Sub_Symbol__c = 30.00,
									Price_of_3rd_Sub_Symbol__c = 30.00,
									Price_of_Main_Symbol__c = 10.00,
									MileageIn__c = '123',
									VIN__c = v.Id);

			claimsList.add(c);

			insert claimsList;
   		}
   		
		Test.stopTest();

		claimsList = [SELECT Id FROM Claim__c WHERE Id IN: claimsList];

      	// Query job sharing records.
     	List<Claim__Share> claimShares = [SELECT Id, UserOrGroupId, AccessLevel, 
        RowCause FROM Claim__Share WHERE ParentId IN: claimsList];
      
      	// Test for only one manual share on job.
      	System.assertEquals(claimShares.size(), 2, 'Set the object\'s sharing model to Read.');

      	System.debug(claimShares);
      
	    // Test attributes of manual share.
	    //System.assertEquals(claimShares[0].AccessLevel, 'Read');
	    //System.assertEquals(claimShares[0].RowCause, 'Manual');
	    //System.assertEquals(claimShares[0].UserOrGroupId, user2Id);
      
        // Test invalid job Id.
        //delete j;   
   
        // Insert manual share for deleted job id. 
        //System.assertEquals(JobSharing.manualShareRead(j.Id, user2Id), false);
   }  

   @isTest
	private static void testManualShareRead_batchRecords(){

		List<Account> accsList = new List<Account>();
		List<Contact> contactsList = new List<Contact>();
		List<User> portalUsersList = new List<User>();

		Id pId = [select id from profile where name='Dealer Community User'].id;

		//Create an Account
		Account acc = new Account(Name = 'MS',
								Dealer_Code__c = '2008');
		accsList.add(acc);

		Account acc2 = new Account(Name = 'testMS',
									Dealer_Code__c = '2122');
		accsList.add(acc2);

		insert accsList;

		//create Contact
		Contact con = new Contact(FirstName = 'MS',
									LastName = 'MS',
									AccountId = acc.Id);
		contactsList.add(con);

		Contact con2 = new Contact(FirstName = 'TS',
									LastName = 'TS',
									AccountId = acc.Id);
		contactsList.add(con2);

		Contact con3 = new Contact(FirstName = 'RE',
									LastName = 'RE',
									AccountId = acc2.Id);

		contactsList.add(con3);

		Contact con4 = new Contact(FirstName = 'RE2',
									LastName = 'RE2',
									AccountId = acc2.Id);

		contactsList.add(con4);


		insert contactsList;

		//Create User
		User portalUser = new User(alias = 'test123', email='test123@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con.Id, timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

		portalUsersList.add(portalUser);

		User portalUser2 = new User(alias = 'te222', email='test1233333@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con2.Id, timezonesidkey='America/Los_Angeles', username='tester232323@noemail.com');

		portalUsersList.add(portalUser2);

		//Create User
		User portalUser3 = new User(alias = 'test133', email='teee33@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con3.Id, timezonesidkey='America/Los_Angeles', username='teee33@noemail.com');

		portalUsersList.add(portalUser3);

		User portalUser4 = new User(alias = 'te422', email='test323@noemail.com',
					                emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
					                localesidkey='en_US', profileid = pId, country='United States',IsActive =true,
					                ContactId = con4.Id, timezonesidkey='America/Los_Angeles', username='test323@noemail.com');

		portalUsersList.add(portalUser4);

		insert portalUsersList;


		Product__c prod = new Product__c(Model_Group__c = 'RL', MDL_YR_CD__c = 'RL2005', Model_Year__c = '2005');
		insert prod;

		List<VIN__c> vinsList = new List<VIN__c>();
		VIN__c v = new VIN__c(ProductSerialNumber__c = 'vin123', Product__c = prod.Id);
		vinsList.add(v);

		VIN__c v2 = new VIN__c(ProductSerialNumber__c = 'vin1231212', Product__c = prod.Id);
		vinsList.add(v2);

		insert vinsList;


		//Create RO
		ServiceHistorys__x shx = new ServiceHistorys__x(RoVin__c = v.Id, RoNum__c = 'ro123', MileageIn__c = '190000');

   		List<Claim__c> claimsList = new List<Claim__c>();

   		Test.startTest();
   		
   		System.runAs(portalUser) {
   			//Create an existing Claim
   			Claim__c c = new Claim__c(X1st_Sub_Symbol__c = '1', 
									X2nd_Sub_Symbol__c = '2',
									X3rd_Sub_Symbol__c = '3',
									Main_Symbol__c = 'A',
									Model__c = 'RL',
									Price_of_1st_Sub_Symbol__c = 30.00,
									Price_of_2nd_Sub_Symbol__c = 30.00,
									Price_of_3rd_Sub_Symbol__c = 30.00,
									Price_of_Main_Symbol__c = 10.00,
									MileageIn__c = '123',
									VIN__c = v.Id);

			claimsList.add(c);

			Claim__c c2 = new Claim__c(X1st_Sub_Symbol__c = '1', 
									X2nd_Sub_Symbol__c = '2',
									X3rd_Sub_Symbol__c = '3',
									Main_Symbol__c = 'A',
									Model__c = 'RL',
									Price_of_1st_Sub_Symbol__c = 30.00,
									Price_of_2nd_Sub_Symbol__c = 30.00,
									Price_of_3rd_Sub_Symbol__c = 30.00,
									Price_of_Main_Symbol__c = 10.00,
									MileageIn__c = '123',
									VIN__c = v2.Id);

			claimsList.add(c2);

			insert claimsList;	
   		
   		}
		Test.stopTest();

		claimsList = [SELECT Id FROM Claim__c WHERE Id IN: claimsList];

      	// Query job sharing records.
     	List<Claim__Share> claimShares = [SELECT Id, UserOrGroupId, AccessLevel, 
        RowCause FROM Claim__Share WHERE ParentId IN: claimsList];
      
      	// Test for only one manual share on job.
      	System.assertEquals(claimShares.size(), 4, 'Set the object\'s sharing model to Read.');

      	System.debug(claimShares);
      
	    // Test attributes of manual share.
	    //System.assertEquals(claimShares[0].AccessLevel, 'Read');
	    //System.assertEquals(claimShares[0].RowCause, 'Manual');
	    //System.assertEquals(claimShares[0].UserOrGroupId, user2Id);
      
        // Test invalid job Id.
        //delete j;   
   
        // Insert manual share for deleted job id. 
        //System.assertEquals(JobSharing.manualShareRead(j.Id, user2Id), false);
   }  
}