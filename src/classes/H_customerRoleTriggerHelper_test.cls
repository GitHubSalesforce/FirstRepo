/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 01/10/2015
        @description  : Test Class for H_customerRoleTriggerHelper class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           01/10/2015           Original Version
*/
@istest
public class H_customerRoleTriggerHelper_test{
    //Test method to test scenarios for multi picklist
    static testMethod void  testAutoPopulate(){
        user  userRecordAdmin = H_ParsingTestDataUtility.initUser('System Administrator','test aliasAdmin',null,null);
        if(userRecordAdmin != null)
            insert userRecordAdmin;
        system.assertnotEquals(userRecordAdmin.Id,null);
        
        user  userRecord = H_ParsingTestDataUtility.initUser('API - MDM - Real Time','test alias',null,'CRM Agent');
        system.runas(userRecordAdmin){
            if(userRecord != null)
            insert userRecord;
        }
        system.assertnotEquals(userRecord.Id,null);
        
        //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        system.runas(userRecord){
            if(objAccount != null)
            insert objAccount;
        }
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3215075310566789';
        lstContact[0].AccountId = objAccount.Id;
        lstContact[0].phone = '1234567890';
        lstContact[0].email = 'test@test.com';
        lstContact[0].mailingstreet = 'test';
        
        if(lstContact != null && !lstContact.isEmpty()){
            system.runas(userRecord){
                insert lstContact;
            }
            system.assertEquals(lstContact.size(),1);
        }
        
        
        Product__c productRecord = H_ParsingTestDataUtility.createProduct();
        system.runas(userRecord){
            if(productRecord != null)
            insert productRecord;
        }
        system.assertnotEquals(productRecord.Id,null);      
        
        vin__c vinRecord = H_ParsingTestDataUtility.createVin();
        vinRecord.Product__c = productRecord.Id;
        vinRecord.ProductSerialNumber__c = '1234567899234888';
        system.runas(userRecord){
            if(vinRecord != null)
            insert vinRecord;
        }
        system.assertnotEquals(vinRecord.Id,null);
        
        vin__c vinRecord1 = H_ParsingTestDataUtility.createVin();
        vinRecord1.Product__c = productRecord.Id;
        vinRecord1.ProductSerialNumber__c = '1234567899234999';
        system.runas(userRecord){
            if(vinRecord1 != null)
            insert vinRecord1;
        }
        system.assertnotEquals(vinRecord1.Id,null);
        
        CASS_No__c cassRecord = new CASS_No__c(contact__c = lstContact[0].Id,Cass_No__c='1234532');
        system.runas(userRecord){
            if(cassRecord != null)
            insert cassRecord;
        }
        system.assertnotEquals(cassRecord.Id,null);
        
        Customer_Role__c  custRoleRecord1 = H_ParsingTestDataUtility.createCustomerRole(lstContact[0].Id);        
        custRoleRecord1.vin__c = vinRecord.Id;
        custRoleRecord1.roleValue__c ='Buyer';
        system.runas(userRecord){
            if(custRoleRecord1 != null)
            insert custRoleRecord1;
        }
        system.assertnotEquals(custRoleRecord1.Id,null);
        
        Customer_Role__c  custRoleRecord = H_ParsingTestDataUtility.createCustomerRole(lstContact[0].Id);        
        custRoleRecord.vin__c = vinRecord.Id;
        Test.startTest();
            system.runas(userRecord){
                if(custRoleRecord != null)
                    insert custRoleRecord;
            }
        system.runas(userRecordAdmin){
            update custRoleRecord;
        }
        Test.stopTest();
    }
}