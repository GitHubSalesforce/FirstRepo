/**
*      @author       : Merisha Shim (Deloitte)
*      @date         : 02/16/3016
*      @description  : Batch Class for the Generate PINs button Campaign
*
*      Modification Log:
*      ------------------------------------------------------------------------------------------
*      Developer               User story            Date                Description
*      ------------------------------------------------------------------------------------------
*      Merisha Shim                                  02/16/3016          Batch Class for the Generate 
*																		 PINs button Campaign
*																																				 Visualforce Page
*/
global class H_GeneratePINsBatch implements Database.Batchable<sObject> {
	
	final String BATCH_NAME = 'Generate PINs Batch';
	final String ACTIVE = 'Active';
	final String IN_PROGRESS = 'In Progress';
	final String COMPLETED = 'Completed';
	final String ERRORED = 'Errored';
	final String DML_OPERATION = 'DML Operation';
	final String PIN = 'PIN__c';

	Integer numberOfPINs;
	Id campaignId;
	Campaign currentCampaign;
	String query;
	
	global H_GeneratePINsBatch(Id camId, Integer pins) {
		numberOfPINs = pins;
		campaignId = camId;
		query = 'Select Id, ContactId, CampaignId FROM CampaignMember WHERE CampaignId =: campaignId';
		currentCampaign = [SELECT Id, Generate_PINS_Batch_Status__c 
							FROM Campaign 
							WHERE Id =: campaignId];
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		
		currentCampaign.Generate_PINS_Batch_Status__c = IN_PROGRESS;

		try {
			// Create an 'In Progress' batch status record
			insert H_GeneratePINs.createBatchStatus(BATCH_NAME, IN_PROGRESS, BC.getJobId());
			update currentCampaign;
		} catch(Exception e) {
			throw new H_GeneratePINs.H_GeneratePINsException(e.getMessage());
		}
		

		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<CampaignMember> scope) {
		
		// Create a map of pin names (the unique pin code) and the PIN record
		Map<String, PIN__c> pinsToInsert = new Map<String, PIN__c>();

		// Set of Contact Ids
		Set<Id> contactIds = new Set<Id>();
		
		// For each Campaign Member, create PINs related to the Contact and Campaign
		for(CampaignMember cm : scope) {
			contactIds.add(cm.ContactId);
			pinsToInsert.putAll(H_GeneratePINs.createPIN(numberOfPins, cm.ContactId, cm.CampaignId, ACTIVE));
		}

		Database.SaveResult[] srList = Database.insert(pinsToInsert.values(), false);

		// Query for all the campaign members in the scope that has less than the number of PINs records
		Map<Id, Contact> contactsWithPINs = new Map<Id, Contact> ([SELECT Id, (SELECT Id FROM PIN__r WHERE Campaign__c =: campaignId)
																		FROM Contact
																		WHERE Id IN: contactIds]);

		List<Contact> contactWithIncorrectPINs = new List<Contact>();

		//go through each contact and make sure the number of pins are correct
		for(Contact c : contactsWithPINs.values()) {
			if(c.PIN__r.size() < numberOfPINs) {
				contactWithIncorrectPINs.add(c);
			}
		}

		if(!contactWithIncorrectPINs.isEmpty() || Test.isRunningTest()) {
			
			List<ErrorLog__c> errorsToInsert = new List<ErrorLog__c>();

			try {
				insert H_GeneratePINs.createErrorLogs(srList, 
														BATCH_NAME, 
														BC.getJobId(), 
														DML_OPERATION, 
														PIN, 
														campaignId, 
														pinsToInsert.values());

			} catch(Exception e) {
				throw new H_GeneratePINs.H_GeneratePINsException(e.getMessage());
			}

			

		}

		
	}
	
	global void finish(Database.BatchableContext BC) {
		// Create a batch status record
		BatchStatus__c batchStatus = H_GeneratePINs.createBatchStatus(BATCH_NAME, COMPLETED, BC.getJobId());
		currentCampaign.Generate_PINS_Batch_Status__c = COMPLETED;
		
		List<ErrorLog__c> dupeErrors = [SELECT Id FROM ErrorLog__c WHERE Name LIKE: '%' + BC.getJobId() + '%'];
		
		if(!dupeErrors.isEmpty()) {
			batchStatus.Status__c = ERRORED;
			currentCampaign.Generate_PINS_Batch_Status__c = ERRORED;
		}

		try {

			insert batchStatus;
			update currentCampaign;

		} catch(Exception e) {
			throw new H_GeneratePINs.H_GeneratePINsException(e.getMessage());
		}
	}

	
}