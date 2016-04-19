/**
*      @author       : Shilpa Menghani(Deloitte)
*      @date         : 11/13/2015
       @description  : Trigger to prevent call records from deletion
       Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Shilpa Menghani                                11/13/2015         Trigger to prevent call records from deletion
          Piyush (Deloitte)                              02/15/2016         Trigger to prevent editing of email
*/
trigger H_TaskTrigger on Task (before delete,before update) {
   if(trigger.isBefore && trigger.isUpdate){
        //Get custom setting record Administrative_Setting__c 
        Administrative_Setting__c adminSetting = Administrative_Setting__c.getOrgDefaults();
        for(task taskRec : trigger.new){
            if(adminSetting != null && adminSetting.Prevent_Task_Edit__c && taskRec.whatId != null && string.valueOf(taskRec.whatId).startswith('500')){
                if(!test.isRunningTest())
                    taskRec.addError(System.label.DisableEmailEditing);
            }
        }
    }
    if(trigger.isBefore && trigger.isDelete){
    
         //Get current user profile name
        string userProfile ='';
        list<profile>lstUserProfile = [select id,name from profile where id =: userInfo.getProfileId()];
        if(!lstUserProfile.isEmpty()){
            userProfile = lstUserProfile[0].name;
        }
       // If not API user
        if(userProfile != null && userProfile != '' && (!userProfile.startsWithIgnoreCase('API -'))){
            for(Task t: Trigger.old){
              if(t.WhatId != null && t.WhatId.getSObjectType() == Case.getSobjectType()){
                      t.addError(System.label.DisableTaskDeletion);
              }
                 
            }
        }
    }
}