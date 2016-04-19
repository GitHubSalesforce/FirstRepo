/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 22/06/2015
        @description  : Test Class for H_Logger
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              25/08/2015           Original Version
*/
@istest(seeAllData = false)
public class Test_H_Logger {

  static testMethod void testDoInsert(){
        try {
            List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(2);
            
            Test.startTest();
            ErrorLog__c log_obj=new ErrorLog__c(Message__c='testMessage',Log_Level__c='DEBUG',Type__c='Apex',Notify_Admin__c=true,Status_Code__c='testStatus');
            if(log_obj != null)
            insert log_obj;
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, 'This is a FATAL error');
            List<Database.SaveResult> results = H_DBFunctions.doInsert(lstAddress, 'H_LoggerTest', 'testCallingErrorFunctions', false); 
            
            H_Logger.notify=true;
            H_Logger.getDMLErrorMsg(results);
            H_Logger.error(results,'testOrigin','error xml','objType',null);
            H_Logger.log('message','level','statusCode','logtype');
            H_Logger.log('message','level','statusCode','logtype','error xml','objType',null,false); 
            H_Logger.error('message','statusCode','logtype','error xml','objType',null); 
            H_Logger.errorAsync('message','statusCode','logtype'); 
            H_Logger.warn('message','statusCode','logtype');
            H_Logger.debug('message','statusCode','logtype');
            H_Logger.trace('message','statusCode','logtype');
            H_Logger.addPageMessage(myMsg);
            H_Logger.getDMLSuccessMsg(results);
            H_Logger.errorAsync('msg','origin');
            H_Logger.info('message','statusCode','logtype');
            H_Logger.toString(log_obj);
            Test.stopTest();
        } 
        catch (DmlException e) { 
            System.assertEquals('Attempt to de-reference a null object', e.getDmlStatusCode(0));                                                           
        }
    }
    
    static testMethod void testDoUpsert2(){
        try {
            List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(2);
            
            Test.startTest();
            
            ErrorLog__c log_obj=new ErrorLog__c(Message__c='testMessage',Log_Level__c='DEBUG',Type__c='Apex',Notify_Admin__c=true,Status_Code__c='testStatus');
            if(log_obj != null)
            insert log_obj;
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, 'This is a FATAL error');
            List<Database.UpsertResult> results = H_DBFunctions.doUpsert(lstAddress, 'H_LoggerTest', 'testCallingErrorFunctions', false); 
            
            H_Logger.notify=true;
            H_Logger.getDMLErrorMsg(results);
            H_Logger.error(results,'testOrigin','error xml','objType',null);
            H_Logger.log('message','level','statusCode','logtype');
             H_Logger.log('message','level','statusCode','logtype','error xml','objType',null,false);
            H_Logger.error('message','statusCode','logtype','error xml','objType',null);
            H_Logger.errorAsync('message','statusCode','logtype');
            H_Logger.warn('message','statusCode','logtype');
            H_Logger.debug('message','statusCode','logtype');
            H_Logger.trace('message','statusCode','logtype');
            H_Logger.addPageMessage(myMsg);
            H_Logger.addPageMessage(ApexPages.Severity.FATAL,'my Error message');
            H_Logger.getDMLSuccessMsg(results);
            H_Logger.errorAsync('msg','origin');
            H_Logger.info('message','statusCode','logtype');
            H_Logger.toString(log_obj);
            
            Test.stopTest();
        } 
        catch (DmlException e) { 
            System.assertEquals('Attempt to de-reference a null object', e.getDmlStatusCode(0));                                                           
        }
    }

     static testMethod void testDoDelete(){
        try {
            List<Address__c> lstAddress = H_ParsingTestDataUtility.createAddress(2);
            
            Test.startTest();
            
            ErrorLog__c log_obj=new ErrorLog__c(Message__c='testMessage',Log_Level__c='DEBUG',Type__c='Apex',Notify_Admin__c=true,Status_Code__c='testStatus');
            if(log_obj != null)
            insert log_obj;
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, 'This is a FATAL error');
            List<Database.SaveResult> results = H_DBFunctions.doInsert(lstAddress, 'H_LoggerTest', 'testCallingErrorFunctions', false); 
            List<Database.DeleteResult> resultPostDelete = H_DBFunctions.doDelete(lstAddress, 'H_LoggerTest', 'testCallingErrorFunctions', false); 
            
            H_Logger.notify=true;
            H_Logger.getDMLErrorMsg(resultPostDelete);
            H_Logger.error(results,'testOrigin','error xml','objType',null);
            H_Logger.log('message','level','statusCode','logtype');
            H_Logger.log('message','level','statusCode','logtype','error xml','objType',null,false); 
            H_Logger.error('message','statusCode','logtype');
            H_Logger.error('message','statusCode','logtype','error xml','objType',null);
            H_Logger.errorAsync('message','statusCode','logtype');
            H_Logger.warn('message','statusCode','logtype');
            H_Logger.debug('message','statusCode','logtype');
            H_Logger.trace('message','statusCode','logtype');
            H_Logger.addPageMessage(myMsg);
            H_Logger.getDMLSuccessMsg(resultPostDelete);
            H_Logger.errorAsync('msg','origin');
            H_Logger.info('message','statusCode','logtype');
            H_Logger.toString(log_obj);
            Test.stopTest();
        } 
        catch (DmlException e) { 
            System.assertEquals('Attempt to de-reference a null object', e.getDmlStatusCode(0));                                                           
        }
    }
    
}