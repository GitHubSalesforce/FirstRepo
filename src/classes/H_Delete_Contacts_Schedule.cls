/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 10/06/2015
        @description  : This Schedule class is to run Batch class that handles the deletion of the Contact that is in past or To Be Deleted checkbox checked.
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
            Piyush (Deloitte)                              10/06/2015           Original Version
*/
global with sharing class H_Delete_Contacts_Schedule implements Schedulable {
     /**        
    * Execute method of Scehdule class
    */     
    global void execute(SchedulableContext SC){
        //batch class to be scheduled
        H_Delete_Contacts_Batch contactDeleteBatch = new H_Delete_Contacts_Batch();
        
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(contactDeleteBatch,200);
    }
}