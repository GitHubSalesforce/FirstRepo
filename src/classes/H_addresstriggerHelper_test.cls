/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 15/10/2015
       @description  : Test class for H_addresstriggerHelper and H_addresstrigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   15/10/2015         Test class for H_addresstriggerHelper and H_addresstrigger
*/    
@istest
public class H_addresstriggerHelper_test{
    static testMethod void  testaddressTrigger(){
        
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
        
        List<Address__c>lstAddress1 = H_ParsingTestDataUtility.createAddress(1);
        lstAddress1[0].AddressUsageValue__c = 'SECONDARY RESIDENCE';
        lstAddress1[0].Contact__c = lstContact[0].Id;
        lstAddress1[0].EndDate__c = system.today();
        
        List<Address__c>lstAddress = H_ParsingTestDataUtility.createAddress(1);
        lstAddress[0].AddressUsageValue__c = 'PRIMARY RESIDENCE';
        lstAddress[0].Contact__c = lstContact[0].Id;
        lstAddress[0].EndDate__c = system.today() + 10;
        Test.starttest();
            if(lstAddress != null && !lstAddress.isEmpty()){
                insert lstAddress;                
                lstAddress[0].AddressUsageValue__c = 'SECONDARY RESIDENCE';
                update lstAddress;
             }
            if(lstAddress1 != null && !lstAddress1.isEmpty()){
                insert lstAddress1;
                lstAddress1[0].AddressUsageValue__c = 'PRIMARY RESIDENCE';                
                update lstAddress1;            
                delete lstAddress1;
            }
        Test.stopTest();
    }
}