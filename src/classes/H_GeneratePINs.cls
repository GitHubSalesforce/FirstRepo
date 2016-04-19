/**
*      @author       : Merisha Shim (Deloitte)
*      @date         : 02/16/3016
*      @description  : Class for the "Generate PINs" button on Campaign and other helper methods for 
*					   generating PINs in the H_GeneratePINsBatch and H_GenerateExceptionPINsController classes
*      Modification Log:
*      ------------------------------------------------------------------------------------------
*      Developer               User story            Date                Description
*      ------------------------------------------------------------------------------------------
*      Merisha Shim                                  02/16/3016          Used in H_GeneratePINsBatch and
*																		 H_GenerateExceptionPins
*																																				 Visualforce Page
*/
global with sharing class H_GeneratePINs {

	private static final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';

	
	webservice static void executeGeneratePINsBatch(Id campaignId, Integer numberOfPINs) {
		
		Database.executeBatch(new H_GeneratePINsBatch(campaignId, numberOfPINs), 100);

	}

	/*
	 * This method is used to create batch status records when the batch is in Progress, Completed
	 * or Errored.
	 *
	 * @return 	BatchStatus__c record
	 */
	public static BatchStatus__c createBatchStatus(String batchName, String status, String jobId) {

		BatchStatus__c batchStatus = new BatchStatus__c();
		batchStatus.Name = batchName + ' ' + jobId;
		batchStatus.Status__c = status;
		batchStatus.JobId__c = jobId;

		return batchStatus;
	}

	/*
	 * This method is used to create error Log records for every PIN record that cannot be created.
	 * A record is created only if the the PIN's pin_code__c is duplicated. The field on the object
	 * is unique.
	 *
	 * @return 	List<ErrorLog__c> records
	 */
	public static List<ErrorLog__c> createErrorLogs(List<Database.SaveResult> srList, String batchName, String jobId, String dmlOpp, String theSObject, String campaignId, List<PIN__c> pinsToInsert) {
		List<ErrorLog__c> errorsToInsert = new List<ErrorLog__c>();

		// Iterate through each returned result
		for (Integer i = 0; i < srList.size(); i++) {
		    if (!srList[i].isSuccess()) {
		        
		        ErrorLog__c error = new ErrorLog__c();
		        error.Name = batchName + ' ' + jobId;
		        error.Message__c = '';
		        error.Status_Code__c = '';

		        // Operation failed, so get all errors                
		        for(Database.Error err : srList[i].getErrors()) { 
		        	
		        	error.Message__c += err.getMessage();     
		        	error.Status_Code__c += String.valueOf(err.getStatusCode()); 
		        	            

		        }
		        error.Type__c = dmlOpp; 
		        error.Message__c += '\n' + 'Campaign: ' + campaignId 
		        					+ '\n' + 'Contact: ' + pinsToInsert[i].Customer__c;
		        error.SObject__c = theSObject;
		        errorsToInsert.add(error);
		    }
		}

		return errorsToInsert;
	}

	/*
	 * This method is used when Generate PINs button on the campaign is clicked. PINs are generated and linked
	 * to a contact and campaign.
	 *
	 * @return 	Map<String, PIN__c> map of PINs with the String pincode
	 */
	public static Map<String, PIN__c> createPIN(Integer pins, Id contactId, Id campaignId, String status) {
		Map<String, PIN__c> pinsToCreate = new Map<String, PIN__c>();
		for(Integer i = 0; i < pins; i++) {

			String pinCode = generateRandomString();
			
			PIN__c pin = new PIN__c();
			pin.Name = pinCode;
			pin.Pin_Code__c = pinCode;
			pin.Campaign__c = campaignId;
			pin.Customer__c = contactId; 
			pin.Status__c = status;
			
			
			pinsToCreate.put(pin.Name, pin);
			
		}
		return pinsToCreate;
	}

	/*
	 * This method is used when generating exception pins on the campaign. Only a campaign is liked to the PIN.	
	 *
	 * @return List<PIN__c> exception PINs
	 */
	public static List<PIN__c> createPIN(Integer pins, Id campaignId, String status) {
		List<PIN__c> pinsToCreate = new List<PIN__c>();
		
		for(Integer i = 0; i < pins; i++) {

			String pinCode = generateRandomString();
			
			PIN__c pin = new PIN__c();
			pin.Name = pinCode;
			pin.Pin_Code__c = pinCode;
			pin.Campaign__c = campaignId;
			pin.Status__c = status;
			
			
			pinsToCreate.add(pin);
			
		}
		return pinsToCreate;
	}

	/*
	 * This method is used to create an alpha-numeric 6 digit pin code	
	 *
	 * @return String pincode
	 */
	private static String generateRandomString() {
    
	    String randStr = '';
	    while (randStr.length() < 6) {
	       Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
	       randStr += chars.substring(idx, idx+1);
	    }
	    return randStr; 
	}
	

	public class H_GeneratePINsException extends Exception{}

}