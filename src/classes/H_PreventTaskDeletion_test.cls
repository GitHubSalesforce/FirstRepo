/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 22/06/2015
        @description  : Test Class for H_PreventTaskDeletion trigger
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              24/08/2015           Original Version
*/
@istest(seeAllData = false)
public  class H_PreventTaskDeletion_test {
	//Test method to test scenarios to populate related account
    static testMethod void  testTaskDeletion(){
       
        user userRecord = H_ParsingTestDataUtility.initUser('System Administrator','testalias',null,'DCD Parts Agent');
        if(userRecord != null)
        insert userRecord;
        system.assertNotequals(userRecord.Id,null);
        
        list<case>lstCase = H_ParsingTestDataUtility.createCase(1);
        system.runas(userRecord){
        	if(lstCase != null && !lstCase.isEmpty()){
            	insert lstCase;
            	system.assertequals(lstCase.size(),1);
        	}
        }
        
        Task taskRecord = H_ParsingTestDataUtility.createTask();
        if(lstCase != null && !lstCase.isEmpty()){
          taskRecord.WhatId = lstCase[0].Id;
        }
        system.runas(userRecord){
        	if(taskRecord != null){
	            insert taskRecord;
	            system.assertequals(taskRecord.WhatId.getSObjectType(),Case.getSobjectType());
        	}
        }
        
        Test.startTest();
            try {
		          system.runas(userRecord){
		          	if(taskRecord != null){
            	  	   delete taskRecord;
		          	}
		          }
		     }
		     catch (DmlException ex) {
		          System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, ex.getDmlType(0));
		          System.assertEquals('Your administrator has disabled task deletions.', ex.getDmlMessage(0));
		     }
        Test.stopTest();    
    }
}