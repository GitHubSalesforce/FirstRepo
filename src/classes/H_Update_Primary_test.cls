/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 10/28/2015 
        @description  : Test Class for H_Update_Primary_Schedule and H_Update_Primary_Batch class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           10/28/2015           Original Version
*/
@istest
public class H_Update_Primary_test{
    //Test method to test scenarios to update Primary Email and Phone on contact
    static testMethod void  testContactPrimary(){
         //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        if(objAccount != null)
        insert objAccount;
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3488885310010135';
        lstContact[0].AccountId = objAccount.Id;
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),1);

        ContactMethod__c conMethod1 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        conMethod1.EndDate__c = system.today();
        if(conMethod1 != null)
        insert conMethod1;
        system.assertNotEquals(conMethod1.Id,null);
        
        ContactMethod__c conMethod2 = H_ParsingTestDataUtility.createContactMethod(lstContact[0].Id);
        conMethod2.EndDate__c = system.today();
        conMethod2.ContactMethodUsageValue__c = 'Primary Phone';
        conMethod2.ReferenceNumber__c ='1234567890';
        conMethod2.ContactMethodValue__c = 'Telephone Number';
        if(conMethod2 != null)
        insert conMethod2;
        
        system.assertNotEquals(conMethod2.Id,null);
        
        test.startTest();
            H_Update_Primary_Schedule contactUpdateSchedule = new H_Update_Primary_Schedule();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Update', sch, contactUpdateSchedule); 
        test.stopTest();
    }
}