/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 26/08/2015
        @description  : Test Class for H_ErrorLogMapping class
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
              Piyush (Deloitte)                              26/08/2015           Original Version
*/
@istest
public class H_ErrorLogMapping_test{
     static testMethod void  testErrorLog(){
         list<Error_Structure__c>lstError = new list<Error_Structure__c>();
         Error_Structure__c error1 = new Error_Structure__c(name = 'DWLError', NodeField__c = 'Message__c');
         lstError.add(error1);
         
         Error_Structure__c error2 = new Error_Structure__c(name = 'ExternalCorrelationId', NodeField__c = 'ExternalCorrelationId__c');
         lstError.add(error2);
         
         Error_Structure__c error3 = new Error_Structure__c(name = 'requesterName', NodeField__c = 'RequesterName__c');
         lstError.add(error3);
         
         Error_Structure__c error4 = new Error_Structure__c(name = 'requestID', NodeField__c = 'RequestId__c');
         lstError.add(error4);
         
         Error_Structure__c error5 = new Error_Structure__c(name = 'ResultCode', NodeField__c = 'ResultCode__c');
         lstError.add(error5);
         
         Error_Structure__c error6 = new Error_Structure__c(name = 'ServiceTime', NodeField__c = 'ServiceTime__c');
         lstError.add(error6);
         
         if(lstError != null && !lstError.isEmpty())
         insert lstError;
         Test.startTest(); 
           
           //String xmlFile = H_ParsingTestDataUtility.getXMLFile();
           string xmlFile = '<?xml version="1.0" encoding="UTF-8"?><TCRMService xmlns="http://www.ibm.com/mdm/schema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.ibm.com/mdm/schema MDMDomains.xsd"><ResponseControl> <ResultCode>FATAL</ResultCode><ServiceTime>31</ServiceTime><DWLControl><requesterName>RDR VIN</requesterName>   <requesterLanguage>100</requesterLanguage><requesterLocale>en</requesterLocale><ExternalCorrelationId>111122223333</ExternalCorrelationId><requestID>39946</requestID></DWLControl></ResponseControl><TxResponse><RequestType>MaintainPartyProfile</RequestType><TxResult><ResultCode>FATAL</ResultCode><DWLError> <ComponentType>4000</ComponentType><ErrorMessage>The following is not correct:  AdminSystemType</ErrorMessage>  <ErrorType>DIERR</ErrorType><LanguageCode>100</LanguageCode><ReasonCode>3620</ReasonCode><Severity>0</Severity> <Throwable>com.dwl.base.exception.DWLDataInvalidException</Throwable></DWLError><DWLError><ComponentType>1009</ComponentType>           <ErrorMessage>The following is not correct: SourceIdentifierType</ErrorMessage><ErrorType>DIERR</ErrorType>     <LanguageCode>100</LanguageCode><ReasonCode>5111</ReasonCode><Severity>0</Severity><Throwable>com.dwl.base.exception.DWLDataInvalidException</Throwable></DWLError></TxResult></TxResponse></TCRMService>';
           RestRequest req = new RestRequest(); 
           RestResponse res = new RestResponse();
                 
           req.requestURI = '/services/apexrest/ErrorMapping';  //Request URL
           req.httpMethod = 'POST';//HTTP Request Type
           req.requestBody = Blob.valueOf(xmlFile);
           RestContext.request = req;
           RestContext.response= res;
        
          String successMsg = H_ErrorLogMapping.insertError();
          system.assertNotEquals(successMsg,null);
      
          Test.stopTest();
     }
}