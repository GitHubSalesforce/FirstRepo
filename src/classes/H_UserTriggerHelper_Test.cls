/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 11/20/2015
        @description  : Test Class for H_UserTriggerH_UserTriggerHelper class
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              11/20/2015           Original Version
*/
@istest(seeAllData = false)
public  class H_UserTriggerHelper_Test {
   //Test method to test scenarios to populate Federation Id
    static testMethod void  testTaskDeletion(){
        Test.startTest();
         try{
            user userRecord = H_ParsingTestDataUtility.initUser('System Administrator','testalias',null,'DCD Parts Agent');
            userRecord.FederationIdentifier = '5678944536';
            if(userRecord != null)
            insert userRecord;
            system.assertNotequals(userRecord.Id,null);
            
            //Update FederationId
            userRecord.FederationIdentifier = '56789445389';
            if(userRecord != null)
            update userRecord;
            userRecord = [Select Id, Federation_Id__c from User where Id =: userRecord.Id];
            system.assertNotequals(userRecord.Federation_Id__c,null);
            system.assertequals(userRecord.Federation_Id__c,'56789445389');
         }
         catch(Exception e){
            system.debug(e.getMessage());
         }
            
        Test.stopTest();
    }
}