/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 10/05/2015
        @description  : This Batch class handles to delete the Contact that is in past or To Be Deleted checkbox checked 
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              10/05/2015           Original Version
                Piyush (Deloitte)                              10/06/2015           Modified for Object Changes
*/
global with sharing class H_Delete_Contacts_Batch implements Database.Batchable<SObject>{
     /**        
    * Start method of batch
    */ 
    global Database.querylocator start(Database.BatchableContext BC){
           /**
            * Get list of all Contact records whose
            * end date is in past or where To Be Deleted checkbox is checked 
            */
            return Database.getQueryLocator([ select Id,
                                                     ToBeDeleted__c,
                                                     UCID__c,name,(select id from cases)                                                    
                                              from Contact
                                              where ToBeDeleted__c = true
                                              and UCID__c != null]);  
        
        
    } 
    
    /**        
    * Execute method of batch, delete list of address records.
    */      
    global void execute(Database.BatchableContext BC, List<Contact> lstContact){
        try{
            list<Contact>lstUpdateContact = new list<contact>();
            if(!lstContact.isEmpty()){
                
                Set<String> ucidSet = new Set<String>();
                for(Contact tempConObj : lstContact){                    
                    ucidSet.add(tempConObj.UCID__c);                    
                    if(tempConObj.cases.isEmpty()){
                        lstUpdateContact.add(tempConObj);                        
                    }
                    else{
                        H_Logger.error(tempConObj.name+' has related Cases. Please Reparent and delete the contact.', 'H_Delete_Contacts_Batch '+ ' : '+ 'execute','ERROR');
                    }
                }
                
                //delete existing Address and Contact Method record if exist
                if(!ucidSet.isEmpty()){
                    for(string ObjVal : H_Constants.deletedObject.split(',')){
                       H_Customer_WS2.deleteRec(ucidSet, ObjVal);
                    }
                }
                if(!lstUpdateContact.isEmpty())
                    Database.Delete(lstUpdateContact,false);                
            }    
        }
        catch(exception e){
            H_Logger.error(e.getMessage(), 'H_Delete_Contacts_Batch '+ ' : '+ 'execute','ERROR');
        }       
    }
    
    /**         
    * Finish method of batch 
    */  
    global void finish(Database.BatchableContext BC){ 

    }
}