/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 1/15/2016
        @description  : This Batch class handles to parse the Failed Notification XML File from Error Log
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              1/15/2016           Original Version
*/
global with sharing class H_ErrorLogsBatch implements Database.Batchable<SObject>,Database.Stateful,Schedulable{
    
    Set<String> errorMessageSet = new Set<String>();
    
    public H_ErrorLogsBatch(){
        //Get All Values of Error Message Custom Setting
            List<ErrorMessage__c> LstErrorMessage = ErrorMessage__c.getAll().values();
            if(!LstErrorMessage.isEmpty()){
                for(ErrorMessage__c message : LstErrorMessage){
                    if(String.isNotBlank(message.MessageShort__c))
                    errorMessageSet.add('%'+message.MessageShort__c+'%');
                }
            }
            
    }
   /**
    * Query to get list of Error Log records 
    */
    public List<ErrorLog__c> getErrorLogRecords(){
                return [select Id,
                               CreatedDate,
                               Type__c,
                               Message_Short__c,
                               IsBatchProcessed__c,
                               (select id,
                                       Name
                                from attachments 
                                where Name like 'NotificationFile.xml' 
                                or Description like 'Error Notification XML File' 
                                limit 1) 
                        from ErrorLog__c
                        where  Type__c = 'Webservice (MDM) - Inbound'
                        and IsBatchProcessed__c = false
                        and CreatedDate != null
                        and (Not Message_Short__c like: errorMessageSet)
                        order by CreatedDate  asc 
                       ];
        
    }   
    /**
    * Query to get list of Error Log records 
    */
    private static Map<Id,Attachment> getAttachmentBody(List<Attachment> attachmentList){
                return new Map<Id,Attachment>([  select id,
                                 Name, 
                                 Body
                          from attachment 
                          where Id in: attachmentList
                       ]);
        
    }   
      
   /**        
    * Start method of batch
    */ 
    global Database.querylocator start(Database.BatchableContext BC){ 
           /**
            * Get Error Log record of type 'Webservice (MDM) - Inbound'
            * Fetch Attachment for XML file
            */
            return Database.getQueryLocator([ select Id,
                                                   CreatedDate,
                                                   Type__c,
                                                   Message_Short__c,
                                                   IsBatchProcessed__c,
                                                   (select id,
                                                           Name
                                                   from attachments 
                                                   where Name like '%NotificationFile.xml%' 
                                                   or Description like '%Error Notification XML File%'
                                                   limit 1)
                                                from ErrorLog__c
                                                where  Type__c = 'Webservice (MDM) - Inbound'
                                                and IsBatchProcessed__c = false
                                                and CreatedDate != null
                                                and (NOT Message_Short__c  like: errorMessageSet)
                                                order by CreatedDate  asc
                                                limit 1
                                            ]);  
                                            
                                            
     } 
    
    /**        
    * Execute method of batch, delete list of address records.
    */      
    global void execute(Database.BatchableContext BC, List<ErrorLog__c> lstErrorLogRecords){
       
       try{
        
            if(lstErrorLogRecords != null && !lstErrorLogRecords.isEmpty()){
                
                String message = '';
                List<Attachment> attachmentLst = new List<Attachment>();
                
                for(ErrorLog__c ErrorLogRecToBeProcessed : lstErrorLogRecords){
                    if(ErrorLogRecToBeProcessed != null && ErrorLogRecToBeProcessed.attachments != null && !ErrorLogRecToBeProcessed.attachments.isEmpty()){
                        attachmentLst.addAll(ErrorLogRecToBeProcessed.attachments);
                    }
                }
                
                Map<Id,Attachment> Map_AttachmentId_Record = getAttachmentBody(attachmentLst);
                
                //Call parsing logic by passing xml file
                for(ErrorLog__c ErrorLogRecToBeProcessed : lstErrorLogRecords){
                   if(ErrorLogRecToBeProcessed != null && ErrorLogRecToBeProcessed.attachments != null && !ErrorLogRecToBeProcessed.attachments.isEmpty()){
                        
                        List<Attachment> attachmentLstTobeProcessed = ErrorLogRecToBeProcessed.attachments;
                        if(attachmentLstTobeProcessed != null && attachmentLstTobeProcessed.size() == 1){
                            Attachment selectedAttachment = attachmentLstTobeProcessed[0];
                            if(Map_AttachmentId_Record != null && !Map_AttachmentId_Record.isEmpty() && Map_AttachmentId_Record.containskey(selectedAttachment.Id)){
                                String XMLFile =  Map_AttachmentId_Record.get(selectedAttachment.Id).Body.tostring();   
                                H_Customer_WS2.isBatchProcessing = true;
                                message = H_Customer_WS2.parseXMLFile(XMLFile);
                            }
                        }
                        
                        if(String.isNotBlank(message) && message.length() > 255)
                        ErrorLogRecToBeProcessed.BatchResult__c = message.substring(0,255);
                        else
                        ErrorLogRecToBeProcessed.BatchResult__c = message; 
                        
                    }
                    ErrorLogRecToBeProcessed.IsBatchProcessed__c = true;
                    ErrorLogRecToBeProcessed.RequesterName__c = 'H_ErrorLogsBatch';
                } 
                
                database.update(lstErrorLogRecords,false);
               
            } 
            
            
       }
       catch(exception e){
            system.debug('in catch---'+e.getMessage());
        }
          
    }   
    
    /**         
    * Finish method of batch 
    */  
    global void finish(Database.BatchableContext BC){  
        
           /**
            * Call batch for the next object record to processed
            */
            H_ErrorLogsBatch errorLogBatch = new H_ErrorLogsBatch();
            // Check if there exist any ErrorLog record
            List<ErrorLog__c> ErrorbatchRecordList  = getErrorLogRecords();
            
            
            if(ErrorbatchRecordList != null && !ErrorbatchRecordList.isEmpty()){
                 /**
                 * check count of running batches for the next time
                 */
                 Integer MAX_BATCHES = 5;
                 Integer runningBatchJobs = [ select count()
                                              from AsyncApexJob
                                              where JobType = 'BatchApex'
                                              and status in ('Queued','Processing','Preparing')
                                             ];
                    
                /**
                * if count is less than max, start batch for the next object
                */        
                 if(runningBatchJobs < MAX_BATCHES){
                       Database.executeBatch(errorLogBatch,1); 
                 }
                /**
                 * schedule the batch again in 5 mins.
                 */
                  else{
                    //schedule this same schedulable class again in 5 mins
                     Datetime dt = Datetime.now();
                     dt = dt.addSeconds(300);
                     String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
                     Id schedId = System.Schedule('ErrorLogsBatch'+timeForScheduler,timeForScheduler,errorLogBatch); 
                  } 
            } 
             
        }
        /**        
        * Execute method of Schedulable
        */      
        global void execute(SchedulableContext sc) {
        
            /**
             * Check count of same name batch jobs
             */ 
            Integer pastRecordsBatch = [   select count()
                                           from AsyncApexJob
                                           where JobType = 'BatchApex'
                                           and status in ('Queued','Processing','Preparing')
                                           and ApexClass.Name = 'H_ErrorLogsBatch' 
                                       ];   
             
            /**
             * Call batch for the next object to processed
             */
             H_ErrorLogsBatch errorLogBatch = new H_ErrorLogsBatch();
             if(pastRecordsBatch == 0){                         
                    
                    Integer MAX_BATCHES = 5;
                    Integer runningBatchJobs = [  select count()
                                                  from AsyncApexJob
                                                  where JobType = 'BatchApex'
                                                  and status in ('Queued','Processing','Preparing')
                                               ];
                       
                     /**
                     * if count is less than max, start batch for the next object
                     */                         
                     if(runningBatchJobs < MAX_BATCHES ){           
                          Database.executeBatch(errorLogBatch,1); 
                     }
                     /**
                     * schedule the batch again in 5 mins.
                     */
                      else{
                           
                          //schedule this same schedulable class again in 5 mins
                          
                           Datetime dt = Datetime.now();
                           dt = dt.addSeconds(300);
                           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
                           Id schedId = System.Schedule('ErrorLogsBatch'+timeForScheduler,timeForScheduler,errorLogBatch); 
                      }  
             } 
         }
}