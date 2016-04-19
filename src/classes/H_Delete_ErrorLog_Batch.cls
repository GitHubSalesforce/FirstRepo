/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 27/01/2016
        @description  : This Batch class handles to delete the Error Log older than 3 months
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Piyush (Deloitte)                            27/01/2016           Created
*/
global with sharing class H_Delete_ErrorLog_Batch implements Database.Batchable<SObject>{
     /**        
    * Start method of batch
    */ 
    global Database.querylocator start(Database.BatchableContext BC){
           /**
            * Get list of all Error Log records whose
            * created date is older than 3 months 
            */
            return Database.getQueryLocator([select Id,createdDate                                                               
                                             from ErrorLog__c
                                             where lastModifiedDate < LAST_N_MONTHS:3]); 
    } 
    
    /**        
    * Execute method of batch, delete list of Error Log Records.
    */      
    global void execute(Database.BatchableContext BC, List<ErrorLog__c>lstErrorLog){
        try{
            if(!lstErrorLog.isEmpty())
                Database.Delete(lstErrorLog,false);  
        }
        catch(exception e){
            H_Logger.error(e.getMessage(), 'H_Delete_ErrorLog_Batch '+ ' : '+ 'execute','ERROR');
        }       
    }
    
    /**         
    * Finish method of batch 
    */  
    global void finish(Database.BatchableContext BC){ 

    }
}