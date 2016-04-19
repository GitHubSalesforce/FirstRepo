/**
*      @author       : Shilpa Menghani(Deloitte)
*      @date         : 11/04/2015
       @description  : Helper class for H_UserTrigger Apex Trigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Shilpa (Deloitte)                           11/04/2015           Original Version
*/
public with sharing class H_UserTriggerHelper{    
    public static void populateFederationId(list<User>lstUser,map<Id,User>mapOldUser){
        for(User userRecord : lstUser){
          if(String.isnotBlank(userRecord.FederationIdentifier)){
              if(mapOldUser == null){
                 userRecord.Federation_Id__c = userRecord.FederationIdentifier;
              }
              else{
                 if(userRecord.FederationIdentifier != null && mapOldUser.get(userRecord.Id).FederationIdentifier != userRecord.FederationIdentifier){
                     userRecord.Federation_Id__c = userRecord.FederationIdentifier;
                 }
              }
           }
           else{
             userRecord.Federation_Id__c = null;
           }
         
        }
    }
    
}