/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 20/01/2016
        @description  : Test Class for H_ErrH_ErrorLogsBatch class
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
              Shilpa(Deloitte)                              20/01/2016           Original Version
*/
@istest
public with sharing class H_ErrorLogsBatch_test {
  static testMethod void  testErrorLogBatch(){
         // Error Message Custom setting data
         ErrorMessage__c errorMsg = new ErrorMessage__c(name = 'Missing', MessageShort__c = 'missing');
         if(errorMsg != null)
         insert errorMsg;
         
         //ErrorLog custom object record
         List<ErrorLog__c> lst_ErrorLog = new  List<ErrorLog__c>();
         ErrorLog__c errorLog1 = new ErrorLog__c();
         errorLog1.Type__c = 'Webservice (MDM) - Inbound';
         errorLog1.SObject__c = 'Contact';
         errorLog1.message__c = 'missing record';
         errorLog1.Message_Short__c = 'missing record';
         lst_ErrorLog.add(errorLog1);
         
         ErrorLog__c errorLog2 = new ErrorLog__c();
         errorLog2.Type__c = 'Webservice (MDM) - Inbound';
         errorLog2.SObject__c = 'Contact';
         errorLog2.Message_Short__c = 'Error - Record Currently Unavailable:';
         errorLog2.Message__c = 'Error - Record Currently Unavailable:';
         lst_ErrorLog.add(errorLog2);
         
         
         Test.startTest(); 
         
	         if(lst_ErrorLog != null && !lst_ErrorLog.isEmpty())
	         insert lst_ErrorLog;
	         
	         String xmlFile = H_ParsingTestDataUtility.getXMLFile();
	         
	         if(lst_ErrorLog != null && lst_ErrorLog.size()> 1)
	         errorLog2 = lst_ErrorLog[1];
	         
	         if(errorLog2 != null && errorLog2.Id != null && String.isNotBlank(xmlFile)){
	           H_logger.saveNotificationXMLAttachment(xmlFile,errorLog2);
	         }
	        
	         H_ErrorLogsBatch errorLogBatch = new H_ErrorLogsBatch();
             String sch = '0 0 23 * * ?'; 
            system.schedule('Test Update', sch, errorLogBatch); 
	     Test.stopTest();   
  }
}