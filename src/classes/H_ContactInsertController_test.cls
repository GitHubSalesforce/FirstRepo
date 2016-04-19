/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 08/01/2016
       @description  : Test Class for H_ContactInsert Visualforce Page, H_ContactInsertController class and for custom contact creation
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   08/01/2016         Test Class for H_ContactInsert Visualforce Page, H_ContactInsertController class and for custom contact creation
*/    
@istest
public class H_ContactInsertController_test{
    static testMethod void  testContactCreation(){
         //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        if(objAccount != null)
        insert objAccount;
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(9);
        for(integer i=0;i<9;i++){
            lstContact[i].UCID__c = '321507539753113'+i;
            lstContact[i].AccountId = objAccount.Id;
            lstContact[i].Phone ='';
            lstContact[i].email ='';
            lstContact[i].mailingcity ='';
            lstContact[i].mailingcountry ='';
            if(i != 0){
                lstContact[i].phone = '1234567890';
            }
            else
                lstContact[i].phone = '';
            if(i != 1){
                lstContact[i].email = 'test@test.com';
            }
            else
                lstContact[i].email = '';
            if(i != 2){
                lstContact[i].MailingStreet = 'test';
            }
            else
                lstContact[i].MailingStreet = '';
            if(i != 3){
                lstContact[i].MailingCity = 'test';
            }
            else
                lstContact[i].MailingCity = '';
            if(i != 4){
                lstContact[i].MailingCountry = 'USA';
            }
            else
                lstContact[i].MailingCountry = '';
            if(i != 5){
                lstContact[i].MailingPostalCode = '12345';
            }
            else
                lstContact[i].MailingPostalCode = '';
            if(i != 6){
                lstContact[i].MailingState = 'test';
            }
            else
                lstContact[i].MailingState  = '';
            
        }
        if(lstContact != null && !lstContact.isEmpty())
        //insert lstContact;
        system.assertEquals(lstContact.size(),9);
        
        list<recordtype>lstRecType = [select id,DeveloperName from recordtype where DeveloperName =: label.Customer_Record_Type_Name and SobjectType = 'contact'];
        system.assertNotEquals(lstContact.size(),0);
        
        System.currentPageReference().getParameters().put('RecordType', lstRecType[0].Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(lstContact[0]);
        H_ContactInsertController contactInsert = new H_ContactInsertController(sc);
        contactInsert.selectedProvince = '';
        contactInsert.selectedCountry = '';
        contactInsert.getProvince();
        contactInsert.getCountry();
        contactInsert.contactRecord = lstContact[0];
        contactInsert.saveRec();
        contactInsert.cancelRec();
        contactInsert.contactRecord = lstContact[1];
        contactInsert.saveRec();
        contactInsert.contactRecord = lstContact[2];
        contactInsert.saveRec();
        contactInsert.contactRecord = lstContact[3];
        contactInsert.saveRec();
        contactInsert.contactRecord = lstContact[4];
        contactInsert.saveRec();
        contactInsert.contactRecord = lstContact[5];
        contactInsert.saveRec();
        contactInsert.selectedProvince = 'AP';
        contactInsert.selectedCountry = 'Canada';
        contactInsert.contactRecord = lstContact[6];
        contactInsert.saveRec();
        
        contactInsert.contactRecord = lstContact[7];
        contactInsert.saveRec();
        contactInsert.contactRecord = lstContact[8];
        contactInsert.saveRec();
        lstContact[8].email ='';
        lstContact[8].phone ='';
        upsert lstContact;
        contactInsert.contactRecord = lstContact[8];
        contactInsert.saveRec();
    }
}