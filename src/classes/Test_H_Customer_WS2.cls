/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 22/06/2015
        @description  : Test Class for H_Customer_WS2 class
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              24/08/2015           Original Version
*/
@istest(seeAllData = false)
public  class Test_H_Customer_WS2 {
    
    static testMethod void  testPostRestService(){
        Test.startTest();
        
            H_ParsingTestDataUtility.generateNotificationHierarchyData(); 
            
            Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0];
            insert objAccount;
            
            Contact objContact = H_ParsingTestDataUtility.createContact(1)[0];
            objContact.AccountId = objAccount.Id;
            objContact.UCID__c = '3215075310010139';
            insert objContact;
            
            Address__c objAddress = H_ParsingTestDataUtility.createAddress(1)[0];  
            objAddress.UCID__c = '3215075310010139';
            objAddress.Contact__c = objContact.Id;
            insert objAddress;
            
            Alert__c objAlert = H_ParsingTestDataUtility.createAlerts(1)[0];
            objAlert.Contact__c = objContact.Id;
            insert objAlert;
            
            Case objCase = H_ParsingTestDataUtility.createCase(1)[0];
            objCase.ContactId = objContact.Id;
            insert objCase;
           
            String xmlFile = H_ParsingTestDataUtility.getXMLFile();
        
        
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
                 
            req.requestURI = '/services/apexrest/ContactMapping';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueOf(xmlFile);
            RestContext.request = req;
            RestContext.response= res;
        
           String successMsg = H_Customer_WS2.doPost();
          
           system.assertNotEquals(successMsg,null);
           
           List<String> lstSuccessUCID = successMsg.split('-');
           
           system.assertEquals(lstSuccessUCID.size(),2);
           system.assertEquals(lstSuccessUCID[1],'3215075310010139','UCID value didnt match');
           
           Integer intCount = Integer.valueOf([Select count(Id) total from Address__c where UCID__c = '3215075310010139'][0].get('total'));
           System.assertEquals(1, intCount, 'Count didnt match');
           
           
           intCount = Integer.valueOf([Select count(Id) total from Alert__c where Contact__r.UCID__c =: '3215075310010139'][0].get('total'));
           System.assertEquals(1, intCount, 'Count didnt match');
          
        Test.stopTest();
    }

}