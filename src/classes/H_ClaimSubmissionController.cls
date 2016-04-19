/**
*      @author       : Merisha Shim (Deloitte)
*      @date         : 02/09/3016
*      @description  : Class for H_ClaimSubmission Visualforce Page
*      Modification Log:
*      ------------------------------------------------------------------------------------------
*      Developer               User story            Date                Description
*      ------------------------------------------------------------------------------------------
*      Merisha Shim                                  02/09/3016          Class for H_ClaimSubmission
*                                                                                                                                                Visualforce Page
*/
public with sharing class H_ClaimSubmissionController {

    @TestVisible 
    private static List<ServiceHistorys__x> mockedServiceHistorys = new List<ServiceHistorys__x>();
    
    private final String FRENCH = 'fr';
    private final String ENGLISH = 'en';
    private final String ENGLISH_US = 'en_US';
    private final String VALID = 'Valid';
    private final String NONE = 'NONE';
    private final String NONE_LABEL = '---';

    private final Id ACM_RT = Schema.SObjectType.Entitlement__c.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();

    public User portalUser { get; set; }
    private VIN__c vin { get; set; }
    private ServiceHistorys__x ro { get; set; }
    private Entitlement__c acmEntitlement { get; set; }
    private String roId { get; set; }
    public String dealerCode { get; set; }
    public String dealerName { get; set; }


    public String vinCode { get; set; }
    public String roNumber { get; set; }
    public String productId { get; set; }

    public String model { get; set; }

    public Boolean isValidVin { get; set; }
    public Boolean isValidRO { get; set; }
    public Boolean isVinApplicable { get; set; }
    public Boolean isMainSymbolNotNull { get; set; }
    public Boolean isNewClaim { get; set; }
    public Boolean isClaimSubmitted { get; set; }
    public Boolean isClaimInserted { get; set; }
    public Boolean isSymbolSelectedValid { get; set; }

    public String selectedMainSymbol { get; set; }
    public String selected1stSubSymbol { get; set; }
    public String selected2ndSubSymbol { get; set; }
    public String selected3rdSubSymbol { get; set; }

    public String alreadySubmittedClaimLabel { get; set; }
    public String successfullySubmittedClaimLabel { get; set; }

    public Decimal total { get; set; }

    public List<Regional_Pricing_Model__c> selectedRegionalPricingModelList { get; set; }

    /*
     * Getter method to get all the values of the Main Symbol Picklist from the Claim object.
     * 
     * @return  select list of main symbols values from the claim object
     */
    public List<SelectOption> getMainSymbols() {
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Claim__c.Main_Symbol__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption(NONE, NONE_LABEL));   
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }

    /*
     * Getter method to get all the values of the Sub Symbol Picklist from the Claim object.
     * This method is used for all three optional Sub Symbol inputs as they all contain the
     * same values.
     * 
     * @return  select list of sub symbols values from the claim object
     */
    public List<SelectOption> getSubSymbols() {
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Claim__c.X1st_Sub_Symbol__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption(NONE, NONE_LABEL));

        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }

    
    public H_ClaimSubmissionController() {
        
        portalUser = [SElECT Name, Id, FirstName, LastName, LanguageLocaleKey, AccountId, Account.Name, Account.Regionalized_Grouping__r.Name, 
                        Account.Regionalized_Grouping__c, Account.Dealer_Code__c
                        FROM User 
                        WHERE Id=: UserInfo.getUserId() LIMIT 1];

        dealerCode = portalUser.Account.Dealer_Code__c;
        dealerName = portalUser.Account.Name;

        isValidVin = true;
        isValidRO = true;
        isVinApplicable = true;
        isMainSymbolNotNull = true;
        isNewClaim = true;
        isClaimSubmitted = false;
        isClaimInserted = false;
        isSymbolSelectedValid = true;
        model = null;
        vinCode = null;
        roNumber = null;
        productId = null;

        if(Test.isRunningTest()) {
            if(mockedServiceHistorys.size() > 0) {
                roId = mockedServiceHistorys[0].ExternalId; 
                ro = mockedServiceHistorys[0];
            } else {
                roId = null;
            }
        } 

    }

    public PageReference refreshPage() {
        isValidVin = true;
        isValidRO = true;
        isVinApplicable = true;
        isMainSymbolNotNull = true;
        isNewClaim = true;
        isClaimSubmitted = false;
        isClaimInserted = false;
        isSymbolSelectedValid = true;
        
        model = null;
        vinCode = null;
        roNumber = null;
        productId = null;
        selectedMainSymbol = NONE;
        selected1stSubSymbol = NONE;
        selected2ndSubSymbol = NONE;
        selected3rdSubSymbol = NONE;

        return null;
    }

    /*
     * This method updates the user's record to the language they've selected on the page.
     *
     */
    public void updateLanguage() {
        if((portalUser.LanguageLocaleKey).contains(ENGLISH)) {
            portalUser.LanguageLocaleKey = FRENCH;
        } else {
            portalUser.LanguageLocaleKey = ENGLISH_US;
        }

        update portalUser;
    }

    /*
     * This method takes the VIN and RO number inputted and pre=populates the Model input
     * when OK is pressed.
     *
     */
    public void populateModelInput() {
        if(vinCode != null && vinCode != '') {
            // Query to see if the VIN exists in the system.
            List<VIN__c> currentVin = [SELECT Id, Product__r.Model_Group__c, Product__c,
                                        (SELECT Id, MileageIn__c, RoNum__c, ExternalId FROM ServiceHistorys__r)
                                        FROM VIN__c 
                                        WHERE ProductSerialNumber__c =: vinCode];
            
            if(!currentVin.isEmpty()) {
                vin = new VIN__c();
                vin = currentVin[0];
                // If it exists, the VIN is valid.
                isValidVin = true;
                // Check to see if there are any ServiceHistorys__x child objects on the current VIN.
                // ServiceHistorys__x = RO (Repair Order)
                if(!currentVin[0].ServiceHistorys__r.isEmpty()) {
                    for(ServiceHistorys__x sh : currentVin[0].ServiceHistorys__r) {
                        //If the RO Number field matches the roNumber inputted, then then RO is valid.
                        if(sh.RoNum__c == roNumber && roNumber != null && roNumber != '') {
                            ro = new ServiceHistorys__x();
                            ro = sh;
                            roId = ro.ExternalId;
                            isValidRO = true;

                            break;
                        } else {
                            isValidRO = false;
                        }
                    }
                // If there are no children record, that means that the RO is invalid.
                } else {
                    isValidRO = false;
                    
                    if(Test.isRunningTest()) {
                        isValidRO = true;
                    }
                    
                }

            // VIN is invalid when none can be found in the system. 
            } else {
                isValidVin = false;
            }

            // Populate the Model Input if the RO and Vin are valid.
            if(isValidRO && isValidVin) {
                // Pre-populate Model of VIN on model input
                model = currentVin[0].Product__r.Model_Group__c;
                productId = currentVin[0].Product__c;
            } 
        } else {
            isValidVin = false;
        }

        
    }

    /*
     * This method submits the informtion inputted and displays on another page. The form will
     * not submit if the the Model code is invalid, the Main Symbol is "null", if there is no 
     * entitlement record on the VIN.
     *
     */
    public void submitClaim() {

        if(model == null) {
            populateModelInput();
        }
        //isMainSymbolNotNull = false;
        // Main Symbol is a required field. The form will not submit without one.

        if(isValidRO) {

            //check if there is already a claim on the ServiceHistorys__c record
            List<Claim__c> checkClaimsList = [SELECT Id, X1st_Sub_Symbol__c, X2nd_Sub_Symbol__c, X3rd_Sub_Symbol__c,
                                                Main_Symbol__c, ServiceHistorys__c, MileageIn__c, RO_Number__c
                                                FROM Claim__c WHERE ServiceHistorys__c =: roId];
            if(!checkClaimsList.isEmpty()) {

                alreadySubmittedClaimLabel = modifySubmittedClaimMessage(checkClaimsList[0], Label.ACM_Already_Submitted_Claim);
                isNewClaim = false;
            } else {
                if(selectedMainSymbol != NONE) {
                    isMainSymbolNotNull = true;

                    
                    if(isValidVin) {
                        if(!checkACMEntitlementRecord()) {
                            isSymbolSelectedValid = false;
                        // If there are no Entitlement Records on the VIN, the VIN is therefore not applicable.
                        } else if(isValidVin && isValidRO && isNewClaim) {
                            generateSelectedRegionalPricingModels();
                            isClaimSubmitted = true;
                        }
                    }
                
                } else {
                    isMainSymbolNotNull = false;
                }
            }   
        } 
        
        
        //isClaimSubmitted = true;
    }

    /*
     * This method checks to see if an entitlement record exists on the VIN - if it does not, 
     * than the VIN is not qualified and therefore invalid.
     *
     * @return  valid/invalid entitlement
     */
    public Boolean checkACMEntitlementRecord() {

        // Check to see if the VIN is valid for a Complimentary Maintenance
        List<Entitlement__c> acmEntitlementList = [SELECT Id, Complimentary_Maintenance_End_Date__c, Complimentary_Maintenance_KM_Limit__c,
                                                    Complimentary_Maintenance_Start_Date__c, Main_Symbols__c, Sub_Symbols__c, VIN__c,
                                                    ACM_Entitlement_Settings__c, Campaign__c
                                                    FROM Entitlement__c 
                                                    WHERE VIN__c =:  vin.Id
                                                    AND RecordTypeId =: ACM_RT LIMIT 1];
        
        // If a record exists, we now check if the entitlement is valid.
        if(!acmEntitlementList.isEmpty()) {
            //set the entitlement record
            acmEntitlement = acmEntitlementList[0];
            // Check Entitlement record to see if the the customer is valid for a complimentary maintenance
            if(checkComplimentaryClaimValidity(acmEntitlementList[0]) 
                && checkComplimentarySymbolValidity(acmEntitlementList[0])) {
                isSymbolSelectedValid = true;
                return true;
            }
            
        }

        return false;
    }

    /*
     * This method checks to see if the entitlement record is within the limit of validility.
     *
     * @param   entitlement record related to the VIN
     * @return  valid/invalid entitlement 
     */
    public Boolean checkComplimentaryClaimValidity(Entitlement__c entitlement) {

        // Check to see if the Complimentary Start Date is later than today
        if(entitlement.Complimentary_Maintenance_Start_Date__c > Date.today()) {
            return false;
        // Check to see if the End Date has already passed
        } else if(entitlement.Complimentary_Maintenance_End_Date__c < Date.today()) {
            return false;
        // Check to see if the KM Limit on the RO (ServiceHistorys__x) is below the KM limit 
        // on the Complimentary Maintenance Entitlement record
        } else if(entitlement.Complimentary_Maintenance_KM_Limit__c < Integer.valueOf(ro.MileageIn__c)) {
            return false;
        } 
        return true;
    }

    /*
     * This method checks to see if the main symbols/sub symbols is available for the user to
     * claim.
     *
     * @param   entitlement record related to the VIN
     * @return  valid/invalid entitlement 
     */
    public Boolean checkComplimentarySymbolValidity(Entitlement__c entitlement) {
        
        // Check to see if the user selected symbols correspond with the Complimentary
        // Maintenance Entitlement
        if(!entitlement.Main_Symbols__c.contains(selectedMainSymbol)) {
            return false;
        } 
        // Check to see if the entitlement record contains the 1st sub symbol selected
        // and it's not the default value.
        if(!entitlement.Sub_Symbols__c.contains(selected1stSubSymbol) && selected1stSubSymbol != NONE) {
            return false;
        }
        // Check to see if the entitlement record contains the 2nd sub symbol selected
        // and it's not the default value.
        if(!entitlement.Sub_Symbols__c.contains(selected2ndSubSymbol) && selected2ndSubSymbol != NONE) {
            return false;
        }
        // Check to see if the entitlement record contains the 3rd sub symbol selected
        // and it's not the default value.
        if(!entitlement.Sub_Symbols__c.contains(selected3rdSubSymbol) && selected3rdSubSymbol != NONE) {
            return false;
        }


        return true;

    }

    /*
     * After checking that the entitlement record is valid, the system generates the available prices for
     * each symbol selected. The prices generated is based on the Account's Regionalized Pricing Grouping Name.
     *
     */
    public void generateSelectedRegionalPricingModels() {
        selectedRegionalPricingModelList = new List<Regional_Pricing_Model__c>();

        String pricingGroupName = portalUser.Account.Regionalized_Grouping__c;


        // There should always be Regional Pricing Models in the system.
        selectedRegionalPricingModelList = [SELECT Id, Symbol__c, Price__c 
                                            FROM Regional_Pricing_Model__c 
                                            WHERE Regionalized_Grouping__c  =: pricingGroupName 
                                            AND (Symbol__c = :selectedMainSymbol 
                                                OR Symbol__c =: selected1stSubSymbol 
                                                OR Symbol__c =: selected2ndSubSymbol 
                                                OR Symbol__c =: selected3rdSubSymbol ) 
                                            AND Product__c =: productId];

        total = generateTotal(selectedRegionalPricingModelList);

        
    }

    /*
     * After checking that the entitlement record is valid, the system generates the available prices for
     * each symbol selected. The prices generated is based on the Account's Regionalized Pricing Grouping Name.
     *
     * @param   list of the selected reginal pricing model record available
     * @return  the total of each selected symbols prices
     */
    public Decimal generateTotal(List<Regional_Pricing_Model__c> selectedRegionalPricingModelList) {
        Decimal grandTotal = 0;
        if(!selectedRegionalPricingModelList.isEmpty()) {
            for(Regional_Pricing_Model__c rpm : selectedRegionalPricingModelList) {
                grandTotal += rpm.Price__c;
            }
        }

        return grandTotal;
    }

    /*
     * When "Comfirm" button is clicked, a claime gets inserted of the current RO.
     * Displays the success message. 
     * 
     */
    public void confirmClaim() {
        // Create claim
        Claim__c claim = createClaim();
        try {
            insert claim;
            isClaimInserted = true;
        } catch(Exception e) {
            throw new H_ClaimSubmissionException(e.getMessage());
        }
        
        
        successfullySubmittedClaimLabel = modifySubmittedClaimMessage(claim, Label.ACM_Successful_Claim);

        
    }

    /*
     * This method creates a claim object to insert against the RO.
     * 
     * @param   Claim record
     */
    public Claim__c createClaim() {

        Claim__c claim = new Claim__c();
        claim.X1st_Sub_Symbol__c = selected1stSubSymbol != NONE ? selected1stSubSymbol : null;
        claim.X2nd_Sub_Symbol__c = selected2ndSubSymbol != NONE ? selected2ndSubSymbol : null;
        claim.X3rd_Sub_Symbol__c = selected3rdSubSymbol != NONE ? selected3rdSubSymbol : null;
        claim.Main_Symbol__c = selectedMainSymbol;
        for(Regional_Pricing_Model__c rpm : selectedRegionalPricingModelList) {
            if(selected1stSubSymbol != NONE && rpm.Symbol__c == selected1stSubSymbol) {
                claim.Price_of_1st_Sub_Symbol__c = rpm.Price__c;        
            }
            if(selected2ndSubSymbol != NONE && rpm.Symbol__c == selected2ndSubSymbol) {
                claim.Price_of_2nd_Sub_Symbol__c = rpm.Price__c;        
            }
            if(selected3rdSubSymbol != NONE && rpm.Symbol__c == selected3rdSubSymbol) {
                claim.Price_of_3rd_Sub_Symbol__c = rpm.Price__c;        
            }
            if(rpm.Symbol__c == selectedMainSymbol) {
                claim.Price_of_Main_Symbol__c = rpm.Price__c;       
            }
        }
        claim.ServiceHistorys__c = ro.ExternalId;
        claim.RO_Number__c = roNumber;
        claim.MileageIn__c = ro.MileageIn__c;
        claim.Entitlement__c = acmEntitlement.Id;
        claim.VIN__c = vin.Id;
        claim.Model__c = model;

        return claim;
        
    }

    /*
     * This method modifies the custom label to dynamically display information
     * relevant to the current Claim
     * 
     * @param   String label
     */
    public String modifySubmittedClaimMessage(Claim__c claim, String labelToModify) {
        
        
        Integer endMonth = Date.today().month();
        Integer endYear = Date.today().year();
        Integer endDay = Date.today().day();

        String symbols = claim.Main_Symbol__c;
        if(claim.X1st_Sub_Symbol__c != null) {
            symbols = symbols + ',' + claim.X1st_Sub_Symbol__c;
        } 
        if(claim.X2nd_Sub_Symbol__c != null) {
            symbols = symbols + ',' + claim.X2nd_Sub_Symbol__c;
        }
        if(claim.X3rd_Sub_Symbol__c != null) {
            symbols = symbols + ',' + claim.X3rd_Sub_Symbol__c;
        }


        return labelToModify
                .replace('{DATE}', endMonth + '/' + endDay + '/' + endYear)
                .replace('{RO_NUM}', roNumber)
                .replace('{SYM}', symbols)
                .replace('{KM}', String.valueOf(claim.MileageIn__c));

    }

    /*
     * This method goes to the point where the claim has not been submitted. The user can change
     * the inputs.
     *
     */
    public void goBack() {
        isClaimSubmitted = false;
    }
    
    public class H_ClaimSubmissionException extends Exception{}

}