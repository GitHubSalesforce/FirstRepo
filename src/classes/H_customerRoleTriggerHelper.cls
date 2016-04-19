/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 30/09/2015
       @description  : Helper class for Trigger - H_customerRoleTrigger which is used to update customer role fields from Vin
       Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                 30/09/2015         Helper class for Trigger - H_customerRoleTrigger which is used to update customer role fields from Vin
*/  
public with sharing class H_customerRoleTriggerHelper{
    public class H_customerRoleException extends Exception {}
    /*
    *  @author           Piyush Rathor (Deloitte) 
    *  @description      Update customer role fields from Vin
    *  @param            LIst of Customer Role Object and Map of Customer Role Id and Customer Role Object
    *                    
    *  @return           Void
    */
    public static void updateFieldValue(list<Customer_Role__c>lstCustomerRole,map<Id,Customer_Role__c>mapOldValue){
        set<Id>setVinId = new set<Id>();
        for(Customer_Role__c custRole : lstCustomerRole){
            setVinId.add(custRole.VIN__c);
        }
        if(!setVinId.isEmpty()){
            list<VIN__c>listVin=[select id,Product__r.Product_Line_frontend__c,Product__r.Model_Group__c,ProductSerialNumber__c,Product__r.Model_Year__c from VIN__c where Id IN : setVinId];
            map<Id,Vin__c>mapVin = new map<Id,Vin__c>();
            for(VIN__c Vin : listVin){
                mapVin.put(Vin.Id,Vin);
            }
            if(!mapVin.isEmpty()){
                for(Customer_Role__c custRoleRecord : lstCustomerRole){
                    custRoleRecord.Product_Line_search__c = mapVin.get(custRoleRecord.VIN__c).Product__r.Product_Line_frontend__c;
                    custRoleRecord.Model_Group_search__c = mapVin.get(custRoleRecord.VIN__c).Product__r.Model_Group__c;
                    custRoleRecord.VIN_Serial_No_search__c = mapVin.get(custRoleRecord.VIN__c).ProductSerialNumber__c;
                    custRoleRecord.Model_Year_search__c = mapVin.get(custRoleRecord.VIN__c).Product__r.Model_Year__c;
                }
            }
        }
    }
    public static set<string> checkCassError(list<Customer_Role__c>lstCustomerRole){
        map<string,set<string>>mapCustRole = new map<string,set<string>>();
        set<string>setCustRoleId = new set<string>();
        boolean runTrigger = true;
        
        if(userInfo.getUserRoleId() != null && userInfo.getUserRoleId() != ''){
            list<userrole>lstRole = [select id,developername from userrole where Id =: userInfo.getUserRoleId() limit 1];
            if(!lstRole.isEmpty()){
                if(lstRole[0].developername == 'Customer_Service_Business_Process_Agent')
                    runTrigger = false;
            }
        }
        if(runTrigger){
            for(Customer_Role__c custRole : lstCustomerRole){
                if(mapCustRole.containsKey(custRole.Contact__c)){
                    set<string>setRoleId = mapCustRole.get(custRole.Contact__c);
                    setRoleId.add(custRole.Id);
                    mapCustRole.put(custRole.Contact__c,setRoleId);
                }
                else{
                    mapCustRole.put(custRole.Contact__c,new set<string>{custRole.Id});
                }
            }           
            if(!mapCustRole.isEmpty()){
                list<CASS_No__c>lstCass = [select id,Contact__c,XEffectiveEndDate__c from CASS_No__c where contact__c IN : mapCustRole.keySet()];
                if(!lstCass.isEmpty()){
                    for(CASS_No__c cassNo : lstCass){
                        if(mapCustRole.containsKey(cassNo.Contact__c) && (cassNo.XEffectiveEndDate__c > system.today() || cassNo.XEffectiveEndDate__c == null)){
                            setCustRoleId.addall(mapCustRole.get(cassNo.Contact__c));
                        }
                    }
                }
            }
        }
        return setCustRoleId;
    }
    public static void addHFSError(list<Customer_Role__c>lstCustomerRole,map<Id,Customer_Role__c>mapCustomerRole){
        set<string>setHFSRole = new set<string>{H_Constants.Lesse,H_Constants.Colesse,H_Constants.Buyer,H_Constants.Cobuyer,H_Constants.Guarantor};
        set<Id>setContactId = new set<Id>();
        set<Id>setHFSContactId = new set<Id>();
        string userProfile ='';
        list<profile>lstUserProfile = [select id,name from profile where id =: userInfo.getProfileId()];
        if(!lstUserProfile.isEmpty()){
            userProfile = lstUserProfile[0].name;
        }
        if(userProfile != null && userProfile != '' && (!userProfile.startsWithIgnoreCase('API -')) && (!H_constants.customerRoleHFSError)){
            for(Customer_Role__c custRole : lstCustomerRole){                
                setContactId.add(custRole.contact__c);
                if(mapCustomerRole != null && mapCustomerRole.containsKey(custRole.Id) && custRole.RoleValue__c != null && custRole.RoleValue__c != '' && setHFSRole.contains(custRole.RoleValue__c)){
                    setHFSContactId.add(custRole.contact__c);   
                }
            }
            if(!setContactId.isEmpty()){
                list<Customer_Role__c>lstCustHFSRole = [select id,RoleValue__c,EffectiveEndDate__c,contact__c from Customer_Role__c where contact__c IN :setContactId AND RoleValue__c IN : setHFSRole AND (EffectiveEndDate__c > Today OR EffectiveEndDate__c = null)];    
                if(!lstCustHFSRole.isEmpty()){
                    for(Customer_Role__c role : lstCustHFSRole){
                        setHFSContactId.add(role.contact__c);
                        
                    }
                }
            }
            
            H_constants.customerRoleHFSError = true;
            if(!setHFSContactId.isEmpty()){
                for(Customer_Role__c custRole : lstCustomerRole){
                    if(setHFSContactId.contains(custRole.contact__c)){
                        if(!test.isRunningTest()){
                            custRole.addError(label.Active_HFS_Error);                          
                        }
                    }                   
                }
            }
        }
    }
    public static void updateContactHFSAccount(list<Customer_Role__c>lstCustomerRole,map<Id,Customer_Role__c>mapCustomerRole){
        set<Id>setContactId = new set<Id>();
        for(Customer_Role__c custRole : lstCustomerRole){
            if(custRole.RoleValue__c != null && custRole.RoleValue__c != '' && (mapCustomerRole == null && (custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Lesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Colesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Buyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Cobuyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Guarantor))) || (mapCustomerRole != null && mapCustomerRole.get(custRole.Id).RoleValue__c != custRole.RoleValue__c &&  (custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Lesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Colesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Buyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Cobuyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Guarantor)))){
                setContactId.add(custRole.Contact__c);
            }
        }
        if(!setContactId.isEmpty()){
            list<contact>lstContact = [Select id,Has_Active_HFS_Account__c from contact where id IN : setContactId];
            if(!lstContact.isEmpty()){
                for(contact con : lstContact){
                    con.Has_Active_HFS_Account__c = true;
                }
                try{
                    update lstContact;
                }
                catch(exception e){
                    throw new H_customerRoleException(e.getMessage());
                }
            }
        }
    }
    public static void updateContactHFSDelete(list<Customer_Role__c>lstCustomerRole){
        set<Id>setContactId = new set<Id>();
        
        for(Customer_Role__c custRole : lstCustomerRole){
            
            if(custRole.RoleValue__c != null && custRole.RoleValue__c != '' && (custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Lesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Colesse) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Buyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Cobuyer) || custRole.RoleValue__c.equalsIgnoreCase(H_Constants.Guarantor))){
                setContactId.add(custRole.Contact__c);
            }
        }
       
        if(!setContactId.isEmpty()){
            list<contact>lstContact = [Select id,Has_Active_HFS_Account__c,(select id,RoleValue__c from Customer_Roles__r) from contact where id IN : setContactId];
            if(!lstContact.isEmpty()){
                for(contact con : lstContact){
                    boolean activeHFS = false;
                    
                    for(Customer_Role__c custRoleValue : con.Customer_Roles__r){
                        
                        if(custRoleValue.RoleValue__c != null && custRoleValue.RoleValue__c != '' && (custRoleValue.RoleValue__c.equalsIgnoreCase(H_Constants.Lesse) || custRoleValue.RoleValue__c.equalsIgnoreCase(H_Constants.Colesse) || custRoleValue.RoleValue__c.equalsIgnoreCase(H_Constants.Buyer) || custRoleValue.RoleValue__c.equalsIgnoreCase(H_Constants.Cobuyer) || custRoleValue.RoleValue__c.equalsIgnoreCase(H_Constants.Guarantor))){
                            activeHFS = true;
                        }
                    }
                    con.Has_Active_HFS_Account__c = activeHFS;
                }
                try{
                    update lstContact;
                }
                catch(exception e){
                    throw new H_customerRoleException(e.getMessage());
                }
            }
        }
    }
}