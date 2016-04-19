/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 25/09/2015
        @description  : Test Class for H_caseAutoPopulateController class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           25/09/2015           Original Version
*/
@istest
public class H_caseAutoPopulateController_test{
    //Test method to test scenarios to populate related account
    static testMethod void  testRelatedContact(){
        list<recordtype>lstRecordtype = [select id,name from recordtype where SobjectType = 'case' limit 1];
        system.assertequals(lstRecordtype.size(),1);
        
        
        user userRecord = H_ParsingTestDataUtility.initUser('System Administrator','testalias',null,'DCD Parts Agent');
        if(userRecord != null)
        insert userRecord;
        system.assertNotequals(userRecord.Id,null);
        
         //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        system.runas(userRecord){
        	if(objAccount != null)
            insert objAccount;
            system.assertnotEquals(objAccount.Id,null);
        }
        
        vin__c vinRecord = H_ParsingTestDataUtility.createVin();
        vinRecord.ProductSerialNumber__c = '1234167349234888';
        system.runas(userRecord){
        	if(vinRecord != null)
            insert vinRecord;
            system.assertnotEquals(vinRecord.Id,null);
        }
        
        role_mapping__c roleMappingRecord = new role_mapping__c();
        roleMappingRecord.Contact_Center_Company__c = 'Honda Canada';
        roleMappingRecord.Group__c = 'DCD Parts';
        roleMappingRecord.name = 'DCD Parts';
        system.runas(userRecord){
        	if(roleMappingRecord != null)
            insert roleMappingRecord;
            system.assertNotequals(roleMappingRecord.Id,null);
        }
        
        list<case>lstCase = H_ParsingTestDataUtility.createCase(1);
        system.runas(userRecord){
        	if(lstCase != null && !lstCase.isEmpty())
            insert lstCase;
            system.assertequals(lstCase.size(),1);
        }
        
        Test.startTest();
            system.runas(userRecord){
                ApexPages.StandardController sc = new ApexPages.standardController(lstCase[0]);
                ApexPages.CurrentPage().getParameters().put('def_account_id', objAccount.Id);
                ApexPages.CurrentPage().getParameters().put(Label.Vin_field, vinRecord.name);
                ApexPages.CurrentPage().getParameters().put(vinRecord+'_lkid', vinRecord.Id);
                ApexPages.CurrentPage().getParameters().put('RecordType', lstRecordtype[0].Id);
                H_caseAutoPopulateController autoPopulate = new H_caseAutoPopulateController(sc);
                autoPopulate.redirectToPage();
            }
        test.stopTest();
    }
}