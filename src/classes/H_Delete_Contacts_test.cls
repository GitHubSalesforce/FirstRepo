/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 10/09/2015
        @description  : Test Class for H_Delete_Contacts_Schedule and H_Delete_Contacts_Batch class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           06/10/2015           Original Version
*/
@istest
public class H_Delete_Contacts_test{
    //Test method to test scenarios to delete contact and related records
    static testMethod void  testContactDeletion(){
         //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0];
        if(objAccount != null) 
        insert objAccount;
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3444445310010135';
        lstContact[0].AccountId = objAccount.Id;
        lstContact[0].ToBeDeleted__c = true;
        lstContact[0].phone = '1234567890';
        lstContact[0].email = 'test@test.com';
        lstContact[0].mailingstreet = 'test';
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),1);
        
        vin__c vinRecord = H_ParsingTestDataUtility.createVin();
        if(vinRecord != null)
        insert vinRecord;
        system.assertnotEquals(vinRecord.Id,null);
        
        if(lstContact != null && !lstContact.isEmpty()){
	        Customer_Role__c  custRoleRecord = H_ParsingTestDataUtility.createCustomerRole(lstContact[0].Id);
	        if(vinRecord != null)
	        custRoleRecord.vin__c = vinRecord.Id;
	        if(custRoleRecord != null)
	        insert custRoleRecord;
	        system.assertnotEquals(custRoleRecord.Id,null);
        }
        
        List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(1);
        if(lstContact != null && !lstContact.isEmpty())
        lstAddress[0].Contact__c = lstContact[0].Id;
        lstAddress[0].UCID__c = '3444445310010135';
        if(lstAddress != null && !lstAddress.isEmpty())
        insert lstAddress;
        system.assertEquals(lstAddress.size(),1);
        
        test.startTest();
            H_Delete_Contacts_Schedule contactDeleteSchedule = new H_Delete_Contacts_Schedule();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test Delete', sch, contactDeleteSchedule); 
        test.stopTest();
    }
}