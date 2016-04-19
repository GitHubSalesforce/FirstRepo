/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 27/01/2016
        @description  : This Schedule class is to run Batch class that handles the deletion of Error Log older than 3 months
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
            Piyush (Deloitte)                              27/01/2016           Original Version
*/
global with sharing class H_Delete_ErrorLog_Schedule implements Schedulable {
     /**        
    * Execute method of Scehdule class
    */     
    global void execute(SchedulableContext SC){
        //batch class to be scheduled
        H_Delete_ErrorLog_Batch errorLogbatch = new H_Delete_ErrorLog_Batch();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(errorLogbatch,200);
    }
}