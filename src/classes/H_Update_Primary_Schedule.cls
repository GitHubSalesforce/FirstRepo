/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 10/28/2015
        @description  : This Schedule class is to run Batch class that handles the updation of primary Email and Phone.
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
            Piyush (Deloitte)                              10/28/2015           Original Version
*/
global with sharing class H_Update_Primary_Schedule implements Schedulable {
     /**        
    * Execute method of Scehdule class
    */     
    global void execute(SchedulableContext SC){
        //batch class to be scheduled
        H_Update_Primary_Batch updatePrimary = new H_Update_Primary_Batch();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(updatePrimary,200);
    }
}