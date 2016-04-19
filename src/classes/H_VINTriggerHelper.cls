/**
 *      @author       : Merisha Shim (Deloitte)
 *      @date         : 02/11/2016
 *      @description  : Helper class for H_VINTrigger Apex Trigger
 *      Modification Log:
 *      ------------------------------------------------------------------------------------------
 *           Developer               User story            Date                Description
 *      ------------------------------------------------------------------------------------------
 *          Merisha Shim (Deloitte)                        02/11/2016          Original Version
 */
public with sharing class H_VINTriggerHelper {

    private static final Id ACM_RT = Schema.SObjectType.Entitlement__c.getRecordTypeInfosByName().get('Acura Complimentary Maintenance').getRecordTypeId();


    /*
    * When a VIN is inserted, the system checks the “Complimentary Maintenance” custom settings for the VIN’s model group. If the model 
    * group exists in the custom settings, a Complimentary Maintenance record gets automatically created for the VIN.
    */
    public static void insertACMENtitlementBasedOnCustomSettings(List<VIN__c> newVINsList) {
        
        List<VIN__c> vinsToCreateEntitlementsList = new List<VIN__c>();
        List<Entitlement__c> entitlementsToCreate = new List<Entitlement__c>();
        Map<Id, Id> vinIdToProductId = new Map<Id, Id>();
        Map<Id, Id> productIdToACMSettingsId = new Map<Id, Id>();

        // Query for the Active entitlements in the system
        List<ACM_Entitlement_Settings__c> acmEntitlements = [SELECT Id, ACM_Duration__c, ACM_Duration_Unit__c, ACM_KM_Limit__c, Main_Symbols__c, 
                                                                Sub_Symbols__c, Product__c
                                                                FROM ACM_Entitlement_Settings__c
                                                                WHERE Deactivate__c != TRUE];

        for(ACM_Entitlement_Settings__c acm : acmEntitlements) {
            productIdToACMSettingsId.put(acm.Product__c, acm.Id);
        }


        if(!acmEntitlements.isEmpty()) {
            //Re-query the VINs so we can get lookup fields. 
            newVINsList = [SELECT Id, Air_Condition__c, Cylinders__c, Door_Type__c, Drive_Train__c, Immobilizer_Indicator__c,
                            isVINUpdated__c, Model_Grade_Code__c, Model_Group__c, Model_Group_Code__c, Model_Year__c,
                            Motive_Power__c, Product__c, ProductLastUpdateDate__c, ProductLastUpdateUser__c, Product_Line__c,
                            ProductValue__c, Telematic_Flag__c, Transmission_Speed__c, ProductSerialNumber__c, Wheelbase__c, 
                            XMITN_Code__c, Product__r.Model_Year__c, Retail_Process_Date__c, (SELECT Id FROM Entitlements__r)
                            FROM VIN__c
                            WHERE Id IN: newVINsList ];

            for(Integer i = 0; i < newVINsList.size(); i++) {
                if((newVINsList[i].Entitlements__r).isEmpty() && productIdToACMSettingsId.get(newVINsList[0].Product__c) != NULL) {
                    vinIdToProductId.put(newVINsList[i].Id, newVINsList[i].Product__c);
                   
                }
            }

            if(!vinIdToProductId.isEmpty()) {
                for(Id v : vinIdToProductId.keySet()){
                    
                    Entitlement__c entitlementToAdd = new Entitlement__c();
                    entitlementToAdd.RecordTypeId = ACM_RT;
                    entitlementToAdd.VIN__c = v;
                    entitlementToAdd.ACM_Entitlement_Settings__c = productIdToACMSettingsId.get(vinIdToProductId.get(v));
                    entitlementsToCreate.add(entitlementToAdd);

                }
            }

            if(!entitlementsToCreate.isEmpty()) {
                try {
                    insert entitlementsToCreate;
                } catch(Exception e) {
                    throw new H_VINTriggerHelperException(e.getMessage());
                }
                
            }
        }

        
    }

    public class H_VINTriggerHelperException extends Exception{}
}