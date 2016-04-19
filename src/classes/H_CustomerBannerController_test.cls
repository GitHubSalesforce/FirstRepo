/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 15/10/2015
       @description  : Test class for H_CustomerBannerController4
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   20/11/2015         Test class for H_CustomerBannerController4
*/    
@istest
public class H_CustomerBannerController_test{
    static testMethod void  testcontactMethodTrigger(){
        //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        if(objAccount != null)
        insert objAccount;
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3215075397531134';
        lstContact[0].AccountId = objAccount.Id;
        lstContact[0].phone = '1234567890';
        lstContact[0].email = 'test@test.com';
        lstContact[0].mailingstreet = 'test';
        lstContact[0].MailingCity = 'test';
        lstContact[0].MailingCountry = 'USA';
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),1);
        
        Banner__c bannerMax = new Banner__c(name = 'gauge',Max_Value__c =100);
        if(bannerMax != null)
        insert bannerMax;
        system.assertnotEquals(bannerMax.Id,null);
        
         Product__c productRecord = H_ParsingTestDataUtility.createProduct();         
        productRecord.Product_Line__c = 'MOTO';
        if(productRecord != null)
        insert productRecord;
        system.assertnotEquals(productRecord.Id,null);    
         
        vin__c vinRecord = H_ParsingTestDataUtility.createVin();
        vinRecord.Product__c = productRecord.Id;
        vinRecord.ProductSerialNumber__c = '1234567899234888';
        if(vinRecord != null)
        insert vinRecord;
        system.assertnotEquals(vinRecord.Id,null);
        
        Customer_Role__c  custRoleRecord = H_ParsingTestDataUtility.createCustomerRole(lstContact[0].Id);        
        custRoleRecord.vin__c = vinRecord.Id;
        custRoleRecord.RoleValue__c = 'Buyer';
        if(custRoleRecord != null)
        insert custRoleRecord;
        system.assertnotEquals(custRoleRecord.Id,null);
        
        Alert__c alert = new Alert__c(Contact__c = lstContact[0].Id,End_Date__c = system.today()+2);
        if(alert != null)
        insert alert;
        system.assertnotEquals(alert.Id,null);
        
        Test.starttest();
            ApexPages.StandardController sc = new ApexPages.StandardController(lstContact[0]);
            H_CustomerBannerController4 customerBanner = new H_CustomerBannerController4(sc);
        Test.stopTest();
    }
}