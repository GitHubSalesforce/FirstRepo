/**
 *      @author       : Piyush Rathor(Deloitte)
 *      @date         : 10/28/2015
        @description  : This Batch class handles to update contact whenever endDate of contact passes 
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Piyush (Deloitte)                            10/28/2015           Original Version
*/
global with sharing class H_Update_Primary_Batch implements Database.Batchable<SObject>{
     /**        
    * Start method of batch
    */ 
    global Database.querylocator start(Database.BatchableContext BC){
           /**
            * Get list of all Contact Method records whose
            * end date is Today 
            */
            return Database.getQueryLocator([ select Id,
                                                     Contact__c,
                                                     ContactMethodUsageValue__c,
                                                    EndDate__c,
                                                    ReferenceNumber__c
                                              from ContactMethod__c where  EndDate__c =: system.today() AND (ContactMethodUsageValue__c =: H_Constants.contactMethodUsageValuePhone OR ContactMethodUsageValue__c =: H_Constants.contactMethodUsageValue)]);  
    } 
    
    /**        
    * Execute method of batch, delete list of address records.
    */      
    global void execute(Database.BatchableContext BC, List<ContactMethod__c> lstContactMethod){
        try{
            set<Id>setPrimaryEmail = new set<Id>();
            set<Id>setPrimaryPhone = new set<Id>();
            for(ContactMethod__c conMethod : lstContactMethod){
                if(conMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone)){
                    setPrimaryPhone.add(conMethod.Contact__c);
                }
                if(conMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue)){
                    setPrimaryEmail.add(conMethod.Contact__c);
                }
            }
            
            if(!setPrimaryPhone.isEmpty() || !setPrimaryEmail.isEmpty()){
                list<contact>lstCon = [select id,email,phone from contact where Id IN : setPrimaryEmail OR Id IN : setPrimaryPhone];
                if(!lstCon.isEmpty()){
                    for(contact con : lstCon){
                        if(setPrimaryPhone.contains(con.Id))
                            con.phone = null;
                        if(setPrimaryEmail.contains(con.Id))
                            con.email = null;
                    }
                    Database.update(lstCon,false);     
                }
            }
        }
        catch(exception e){
            H_Logger.error(e.getMessage(), 'H_Update_Primary_Batch '+ ' : '+ 'execute','ERROR');
        }       
    }
    
    /**         
    * Finish method of batch 
    */  
    global void finish(Database.BatchableContext BC){ 

    }
}