/**
*      @author       : Merisha Shim (Deloitte)
*      @date         : 02/03/2016
*      @description  : Class for H_PinSubmission Visualforce Page
*      Modification Log:
*      ------------------------------------------------------------------------------------------
*      Developer               User story            Date                Description
*      ------------------------------------------------------------------------------------------
*      Merisha Shim                                  08/01/2016          Class for H_PinSubmission
*                                                                                                                                                Visualforce Page
*/
public with sharing class H_PINSubmissionController {

    private static final Id ACM_RT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();
    private static final Id ACM_ENTITLEMENT_RT = Schema.SObjectType.Entitlement__c.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();

    private final String FRENCH = 'fr';
    private final String ENGLISH = 'en';
    private final String ENGLISH_US = 'en_US';
    
    private final String INVALID = 'Invalid';
    private final String INVALID_VIN = 'Invalid VIN';
    private final String INVALID_DEALER_CODE = 'Invalid Dealer Code';
    private final String EXPIRED = 'Expired';
    private final String ACTIVE = 'Active';
    private final String REDEEMED = 'Redeemed';
    private final String SUBMITTED = 'Submitted';

    private static final String DAYS = 'Days';
    private static final String YEARS = 'Years';
    private static final String MONTHS = 'Months';
    
    public String siteType { get; set; }
    public String successPINMessage { get; set; }
    public String expiredPINMessage { get; set; }

    private PIN__c pin { get; set; }
    public String invalidType { get; set; }

    public String dealerCode { get; set; }
    public String pinCode { get; set; }
    public Campaign campaignDetails { get; set; }
    public String vinCode { get; set; }
    public Boolean isDealer { get; set; }
    public User dealerAccount { get; set; }

    private Id partnerProfileId { get; set; }

    public H_PINSubmissionController() {

        siteType = ApexPages.currentPage().getParameters().get('site');
        isDealer = false;

        if(siteType == null) {
            siteType = 'honda';
        }
        
        //check to see if the current user is a dealer community profile
        partnerProfileId = [SELECT Id FROM Profile WHERE Name = 'Dealer Community User' LIMIT 1].Id;

        if(UserInfo.getProfileId() == partnerProfileId) {
            
            isDealer = true;
            
            dealerAccount = [SELECT Id, AccountId, Account.Dealer_Code__c, LanguageLocaleKey FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];

            dealerCode = dealerAccount.Account.Dealer_Code__c;
            
        }

    }


    /**
    * Verifies that the PIN is valid for submission. If the PIN is valid details
    * of the Campaign is shown.
    */
    public void verifyPIN() {

        if(pinCode != null) {
            List<PIN__c> pinsList = [SELECT Id, PIN_Expiry__c, Campaign__c, Status__c 
                                     FROM PIN__c 
                                     WHERE Name =: pinCode LIMIT 1];

            if(!pinsList.isEmpty()) {
                pin = pinsList[0];

                if(pin.Status__c == REDEEMED ) {
                    invalidType = REDEEMED;
                    campaignDetails = new Campaign();

                } else if(pin.Status__c == EXPIRED) {
                    modifyExpiredMessage(pin.PIN_Expiry__c);
                    invalidType = EXPIRED;
                    campaignDetails = new Campaign();
                } else {
                    invalidType = ACTIVE;
                    campaignDetails = [SELECT Id, Name, EndDate, RecordTypeId, Complimentary_Maintenance_Duration__c,
                                        Complimentary_Maintenance_Duration_Unit__c, Complimentary_Maintenance_KM_Limit__c,
                                        Main_Symbols__c, Sub_Symbols__c, Campaign_Display_Name__c
                                        FROM Campaign 
                                        WHERE Id =: pinsList[0].Campaign__c];
                }

            } else {
                invalidType = INVALID;
                campaignDetails = new Campaign();
            }

        } else {
            invalidType = INVALID;
            campaignDetails = new Campaign();
        }

    }

    /*
     * A PIN is submitted for redemption. The PIN is updated as redeemed with the VIN
     * inputted. 
     */
    public void submitPin() {
        verifyPIN();
        // Check if the PIN is active and available.
        if(invalidType == ACTIVE) {
            // Encure the VIN input is not null
            if(vinCode != null) {
                List<VIN__c> vinList = [SELECT Id FROM VIN__c WHERE ProductSerialNumber__c =: vinCode];
                if(!vinList.isEmpty()) {
                    if(dealerCode != null) {
                        List<Account> dealerAccountsList = [SELECT Id FROM Account WHERE Dealer_Code__c =: dealerCode];
                        if(!dealerAccountsList.isEmpty()) {

                            modifySuccessMessage(pinCode, vinCode);
                            updatePIN(vinList[0].Id, dealerAccountsList[0].Id);
                            clearValuesOnPage();
                            
                        } else {
                            invalidType = INVALID_DEALER_CODE;
                            campaignDetails = new Campaign();
                        } 
                    // If the dealer Code input is null, it's invalid
                    } else {
                        invalidType = INVALID_DEALER_CODE;
                        campaignDetails = new Campaign();
                        
                    }
                    
                // If there is no vin that matches the one inputted, it is invalid
                } else {
                    invalidType = INVALID_VIN;
                    campaignDetails = new Campaign();
                    
                }
            // If the VIN input is null, the vin is invalid 
            } else {
                invalidType = INVALID_VIN;
                campaignDetails = new Campaign();
                
            }

        }
    }

    /*
     * Modifies the PIN submitted success Custom Label to take in the PIN and VIN inputted.
     *
     * @param   pinCode - The PIN value inputted
     * @param   vinCode = The VIN value inputted
     */
    private void modifySuccessMessage(String pinCode, String vinCode) {
        successPINMessage = (Label.ACM_PIN_Success).replace('{PIN}', pinCode).replace('{VIN}', vinCode);
    }

    /*
     * Modifies the PIN expired Custom Label to take in the end date of the campaign/adjusted 
     * End Date of the PIN
     *
     * @param   endDate - The Campaign End Date / PIN Adjusted End Date
     */
    private void modifyExpiredMessage(Date endDate) {
        Integer endMonth = endDate.month();
        Integer endYear = endDate.year();
        Integer endDay = endDate.day();
        expiredPINMessage = (Label.ACM_Expired_PIN).replace('{DATE}', endMonth + '/' + endDay + '/' + endYear);
    }

    /*
     * Once the PIN has been submitted, all values on the form are cleared.
     */
    private void clearValuesOnPage() {
        // Clear Form Data
        if(isDealer == false) {
            dealerCode = null;
        }
        pinCode = null;
        vinCode = null;
        campaignDetails = new Campaign();
    }

    /*
     * This method creates an entitlement record when a PIN from an Acura Complimentary Maintenance
     * campaign.
     *
     */
    public void insertEntitlementAgainstVIN() {
        if(campaignDetails.RecordTypeId == ACM_RT) {
            List<VIN__c> vins = [SELECT Id, Retail_Process_Date__c, (SELECT Id FROM Entitlements__r)
                                    FROM VIN__c
                                    WHERE ProductSerialNumber__c =: vinCode];

            // Only create an entitlement record on the VIN if the isn't one already.
            if(vins[0].Entitlements__r.size() == 0) {
                Entitlement__c entitlementToAdd = new Entitlement__c();
                entitlementToAdd.RecordTypeId = ACM_ENTITLEMENT_RT;
                entitlementToAdd.Campaign__c = campaignDetails.Id;
                entitlementToAdd.VIN__c = vins[0].Id;
                try {
                    insert entitlementToAdd;
                } catch(Exception e) {
                    throw new H_PINSubmissionException(e.getMessage());
                }   
            }
                
        }
        
    }

    /*
     * This method updates the user's record to the language they've selected on the page.
     *
     */
    public void updateLanguage() {
        if((dealerAccount.LanguageLocaleKey).contains(ENGLISH)) {
            dealerAccount.LanguageLocaleKey = FRENCH;
        } else {
            dealerAccount.LanguageLocaleKey = ENGLISH_US;
        }
        try {
            update dealerAccount;
        } catch(Exception e) {
            throw new H_PINSubmissionException(e.getMessage());
        }

        
    }

    /*
     * This method updates the updates the PIN record when it's been redeemed.
     *
     */
    public void updatePIN(String vinId, String dealerAccountId) {

        //Update the PIN record to "Redeemed", link VIN record to the PIN
        pin.Status__c = REDEEMED;
        pin.Redeemed_Date__c = Date.today();
        pin.VIN_Serial_Number__c = vinId;
        pin.Dealer__c = dealerAccountId;
        try {
            update pin;
            insertEntitlementAgainstVIN();
            invalidType = SUBMITTED;
        }
        catch(Exception e) {
            throw new H_PINSubmissionException(e.getMessage());
        }
    }

    public class H_PINSubmissionException extends Exception{}

}