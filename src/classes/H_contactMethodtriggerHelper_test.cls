/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 15/10/2015
       @description  : Test class for H_contactMethodtriggerHelper and H_contactMethodtrigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   15/10/2015         Test class for H_contactMethodtriggerHelper and H_contactMethodtrigger
*/    
@istest
public class H_contactMethodtriggerHelper_test{
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
        lstContact[0].MailingCity = 'test';
        lstContact[0].MailingCountry = 'USA';
        
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),1);
        
        ContactMethod__c ContactMethod = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod.ContactMethodUsageValue__c = H_Constants.SECONDARY_EMAIL;
        if(ContactMethod != null)
        insert ContactMethod;
        system.assertNotEquals(ContactMethod.Id,null);
        
        ContactMethod__c ContactMethod1 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod1.ContactMethodUsageValue__c = H_Constants.SECONDARY_EMAIL;
        if(ContactMethod1 != null)
            insert ContactMethod1;
        system.assertNotEquals(ContactMethod1.Id,null);
        
        ContactMethod__c ContactMethod2 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        
        ContactMethod__c ContactMethod3 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod3.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValuePhone;
        
        ContactMethod__c ContactMethod4 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        ContactMethod4.ContactMethodUsageValue__c = H_Constants.SECONDARY_PHONE;
        
        Test.starttest();
            if(ContactMethod2 != null)
                insert ContactMethod2;
            if(ContactMethod3 != null)
                insert ContactMethod3;
                
            ContactMethod2.ContactMethodUsageValue__c = H_Constants.MOBILE_TELEPHONE;
            if(ContactMethod2 != null)
                update ContactMethod2;
            
            ContactMethod2.ContactMethodUsageValue__c = H_Constants.SECONDARY_PHONE;
            if(ContactMethod2 != null)
                update ContactMethod2;
            
            ContactMethod2.ContactMethodUsageValue__c = H_Constants.SECONDARY_EMAIL;
            if(ContactMethod2 != null)
                update ContactMethod2;
           
            ContactMethod.ContactMethodUsageValue__c=H_Constants.contactMethodUsageValue;
            if(ContactMethod != null)
            update ContactMethod;
           
            ContactMethod3.ContactMethodUsageValue__c = H_Constants.SECONDARY_PHONE;
            if(ContactMethod3 != null)
            update ContactMethod3;
        
            ContactMethod3.ContactMethodUsageValue__c = H_Constants.SECONDARY_EMAIL;
            if(ContactMethod3 != null)
                update ContactMethod3;
           
            ContactMethod3.ReferenceNumber__c='abc';
            if(ContactMethod3 != null)
                update ContactMethod3;
            
            ContactMethod2.ContactMethodUsageValue__c=H_Constants.contactMethodUsageValuePhone;
            if(ContactMethod2 != null)
            update ContactMethod2;
        
            ContactMethod1.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValuePhone;
            if(ContactMethod1 != null)
                update ContactMethod1;
            
            ContactMethod1.ContactMethodUsageValue__c = H_Constants.MOBILE_TELEPHONE;
            if(ContactMethod1 != null)
                update ContactMethod1;
            
            if(ContactMethod4 != null)
                insert ContactMethod4;
            
            if(ContactMethod != null)
                delete ContactMethod;
            if(ContactMethod1 != null)
                delete ContactMethod1; 
            if(ContactMethod3 != null)
                delete ContactMethod3;
            if(ContactMethod4 != null)
                delete ContactMethod4;          
                  
        Test.stopTest();
    }
}