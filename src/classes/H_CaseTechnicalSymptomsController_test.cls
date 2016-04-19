/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 25/09/2015
        @description  : Test Class for H_CaseTechnicalSymptomsController class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           29/09/2015           Original Version
*/
@istest
public class H_CaseTechnicalSymptomsController_test{
    //Test method to test scenarios for multi picklist
    static testMethod void  testTechnicalSymptoms(){
        Technical_Issue__c techIssue = H_ParsingTestDataUtility.createTechnicalIssue();
        if(techIssue != null)
        insert techIssue;
        system.assertnotequals(techIssue.Id,null);
        
        list<case>lstCase = H_ParsingTestDataUtility.createCase(1);
        lstCase[0].Technical_Symptoms__c = techIssue.Id;
        lstCase[0].Selected_Technical_Issue__c = 'problem1; problem2';
        if(lstCase != null && !lstCase.isEmpty())
        insert lstCase;
        system.assertequals(lstCase.size(),1);
        
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.standardController(lstCase[0]);
            H_CaseTechnicalSymptomsController technicalSymptoms = new H_CaseTechnicalSymptomsController(sc);
            technicalSymptoms.cancelRecord();
            technicalSymptoms.editRecord();
            technicalSymptoms.saveRecord();
        Test.stopTest();
    }
}