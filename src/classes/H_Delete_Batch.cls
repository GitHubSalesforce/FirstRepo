global class H_Delete_Batch implements Database.Batchable<sObject>{

   global final String Query;
   global final Boolean hardDelete;
   
   global H_Delete_Batch(String q, Boolean hd){
      Query=q; hardDelete=hd;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(Query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
        
       database.delete(scope, false);
       
        if(hardDelete){
            DataBase.emptyRecycleBin(scope);
        }
    }

   global void finish(Database.BatchableContext BC){
       system.debug(' *** BATCH JOB FINISHED *** ');
   }
}