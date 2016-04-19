/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 20/12/2015
       @description  : Test class for H_ContacttriggerHelper and H_contacttrigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   20/12/2015         Test class for H_ContacttriggerHelper and H_contacttrigger
          Piyush Rathor                                   05/01/2016         Updation of test class for postal code update
*/    
@istest
public class H_ContacttriggerHelper_test{
    static testMethod void  testContactTrigger(){
        
        //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0];
        if(objAccount != null)
            insert objAccount;
        
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3215075397531134';
        lstContact[0].AccountId = objAccount.Id;
        lstContact[0].Phone = '1234567890';
        lstContact[0].Email = 'a@gmail.com';
        lstContact[0].mailingStreet = 'test';
        lstContact[0].MailingCity = 'test';
        lstContact[0].MailingCountry = 'USA';
        if(lstContact != null && !lstContact.isEmpty())
            insert lstContact;
       
        system.assertEquals(lstContact.size(),1);
        
        List<Address__c>lstAddress = H_ParsingTestDataUtility.createAddress(1);
        lstAddress[0].AddressUsageValue__c = H_Constants.addressUsageVal;
        lstAddress[0].Contact__c = lstContact[0].Id;
        lstAddress[0].EndDate__c = system.today() + 10;
        insert lstAddress;
        
        list<ContactMethod__c>lstContactMethod = new list<ContactMethod__c>();
        ContactMethod__c ContactMethod = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValuePhone;
        lstContactMethod.add(ContactMethod);
        
        ContactMethod__c ContactMethod1 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod1.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValue;
        lstContactMethod.add(ContactMethod1);
        insert lstContactMethod;
        
        Test.starttest();
             lstContact[0].firstName = 'testUpdateName';
             lstContact[0].LastName = 'testUpdateLast';
             lstContact[0].MailingPostalCode = '12345';
             update lstContact;
        Test.stopTest();
    }
}