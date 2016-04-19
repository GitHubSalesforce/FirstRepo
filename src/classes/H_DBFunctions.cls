/**
*      @author Shilpa Menghani
*      @date   22/06/2014
*      @description    A global utility class for all DML Operations
*
*     Modification Log:        
*/

public  class H_DBFunctions{
    
    /**
    *      @author Shilpa Menghani
    *      @date   22/06/2014
    *      @description    Method to pass the failed insert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.SaveResult> doInsert(List<SObject> insertRecords, String className, String operation,boolean boolAllowPartials){
        List<Database.SaveResult> results= Database.insert(insertRecords,!boolAllowPartials);    
        return results;
    }
    
    
    /**
    *      @author  Shilpa Menghani
    *      @date   22/06/2014
    *      @description    Method to pass the failed Update records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.SaveResult> doUpdate(List<SObject> updateRecords, String className, String operation,boolean boolAllowPartials){
        List<Database.SaveResult> results= Database.update(updateRecords,!boolAllowPartials);
        return results;
    }

    
    /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Upsert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.UpsertResult> doUpsert(List<SObject> upsertRecords, String className, String operation,boolean boolAllowPartials){
        List<Database.Upsertresult> results= Database.upsert(upsertRecords,!boolAllowPartials);
        return results;
    }
    /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Upsert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.UpsertResult> doUpsert(List<Account> upsertRecords, Schema.SObjectField externalIDField,String className, String operation,boolean boolAllowPartials){
        List<Database.Upsertresult> results= Database.upsert(upsertRecords,externalIDField,!boolAllowPartials);
        return results;
    }
     /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Upsert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.UpsertResult> doUpsert(List<Contact> upsertRecords, Schema.SObjectField externalIDField,String className, String operation,boolean boolAllowPartials){
        List<Database.Upsertresult> results= Database.upsert(upsertRecords,externalIDField,!boolAllowPartials);
        return results;
    }
    
    /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Upsert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.UpsertResult> doUpsert(List<CASS_No__c> upsertRecords, Schema.SObjectField externalIDField,String className, String operation,boolean boolAllowPartials){
        List<Database.Upsertresult> results= Database.upsert(upsertRecords,externalIDField,!boolAllowPartials);
        return results;
    }
    
    /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Upsert records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.UpsertResult> doUpsert(List<VIN__c> upsertRecords, Schema.SObjectField externalIDField,String className, String operation,boolean boolAllowPartials){
        List<Database.Upsertresult> results= Database.upsert(upsertRecords,externalIDField,!boolAllowPartials);
        return results;
    }
    
    /**
    *      @author  Shilpa Menghani
    *      @date    22/06/2014
    *      @description    Method to pass the failed Delete records for Logger Class
    *      Modification Log:        
    */
    
    public static List<Database.DeleteResult> doDelete(List<SObject> deleteRecords, String className, String operation,boolean boolAllowPartials){
        List<Database.Deleteresult> results= Database.delete(deleteRecords,!boolAllowPartials);
        return results;
  }
}