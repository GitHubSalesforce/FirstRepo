/**
    *      @author       : Piyush Rathor(Deloitte)
    *      @date         : 01/10/2015
        @description  : Helper class to update Primary Address to Contact for Trigger - H_addresstrigger
            Modification Log:
            ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
            ------------------------------------------------------------------------------------------
            Piyush Rathor                                   01/10/2015         Trigger to update Primary Address to Contact
            Piyush Rathor                                   27/10/2015         Trigger to check multiple Primary Address and Deletion changes
    */    
public with sharing class H_addresstriggerHelper{
    //Throwing Custom Exception from Trigger
    public class H_addressException extends Exception{}
        /*
        *  @author           Piyush Rathor (Deloitte) 
        *  @description      update Primary Address to Contact
        *  @param            List of Address Object and Map of Address Id and Address Object and clear contact primary address when address is deleted
        *                    
        *  @return           Void
        */
    public static void updatePrimaryAddress(list<Address__c>lstAddress,map<Id,Address__c>mapOldAddress){
        map<Id,Address__c>mapAddress = new map<Id,Address__c>();
        set<Id>setClearAddress = new set<Id>();
        for(Address__c addressRecord : lstAddress){
            if(mapOldAddress != null){
                if(addressRecord.Contact__c != null && addressRecord.AddressUsageValue__c != null && addressRecord.AddressUsageValue__c != '' && (addressRecord.EndDate__c == null || addressRecord.EndDate__c >= date.today()) && addressRecord.AddressUsageValue__c.equalsIgnoreCase(H_Constants.addressUsageVal) && !addressRecord.Created_from_New_contact_Page__c){
                    mapAddress.put(addressRecord.Contact__c,addressRecord);
                }
                if(addressRecord.Contact__c != null && (mapOldAddress.get(addressRecord.Id).EndDate__c == null || mapOldAddress.get(addressRecord.Id).EndDate__c >= date.today()) && mapOldAddress.get(addressRecord.Id).AddressUsageValue__c != null && addressRecord.AddressUsageValue__c != null && mapOldAddress.get(addressRecord.Id).AddressUsageValue__c.equalsIgnoreCase(H_Constants.addressUsageVal) && mapOldAddress.get(addressRecord.Id).AddressUsageValue__c != addressRecord.AddressUsageValue__c && !addressRecord.Created_from_New_contact_Page__c){
                    setClearAddress.add(addressRecord.Contact__c);
                }
            }
            else{
                if(addressRecord.Contact__c != null && addressRecord.AddressUsageValue__c != null && addressRecord.AddressUsageValue__c != '' && (addressRecord.EndDate__c == null || addressRecord.EndDate__c >= date.today()) && addressRecord.AddressUsageValue__c.equalsIgnoreCase(H_Constants.addressUsageVal) && !addressRecord.Created_from_New_contact_Page__c)
                    mapAddress.put(addressRecord.Contact__c,addressRecord);
            }
        }
        set<string>setMultiPrimaryCon = new set<string>();
        if(!setClearAddress.isEmpty()){
            list<contact>lstCon = [select id,Mailingstreet,MailingCity,MailingState,MailingCountry,MailingPostalCode from contact where Id IN : setClearAddress];
            for(contact conVal : lstCon){
                conVal.Mailingstreet = null;
                conVal.MailingCity = null;
                conVal.MailingState = null;
                conVal.MailingCountry = null;
                conVal.MailingPostalCode = null;
            }
            if(!lstCon.isEmpty()){
                try{
                    update lstCon;
                }
                catch(exception e){
                    throw new H_addressException(e.getMessage());
                }
            }
        }
        if(!mapAddress.isEmpty()){
            string userProfile ='';
            list<profile>lstUserProfile = [select id,name from profile where id =: userInfo.getProfileId()];            
            userProfile = lstUserProfile[0].name;            
            
            if(userProfile != null && userProfile != '' && (!userProfile.startsWithIgnoreCase('API -'))){
                list<Address__c>lstAdd = [select id,Contact__c,AddressUsageValue__c,EndDate__c from Address__c where contact__c IN : mapAddress.keySet()];
                if(!lstAdd.isEmpty()){
                    map<string,Integer>mapPrimaryAdd = new map<string,Integer>();
                    for(Address__c addressVal : lstAdd){
                        if(addressVal.contact__c != null && addressVal.AddressUsageValue__c != null && addressVal.AddressUsageValue__c != '' && addressVal.AddressUsageValue__c.equalsIgnoreCase(H_Constants.addressUsageVal) && (addressVal.EndDate__c == null || addressVal.EndDate__c >= date.today())){
                           
                            if(mapPrimaryAdd != null && !mapPrimaryAdd.isEmpty() && mapPrimaryAdd.containskey(addressVal.Contact__c)){
                                setMultiPrimaryCon.add(addressVal.Contact__c);
                            }
                            else{
                                mapPrimaryAdd.put(addressVal.Contact__c,1);
                            }
                        }
                    }
                }
            }
            
            if(setMultiPrimaryCon.isEmpty()){
                list<contact>lstContact = [select id,Mailingstreet,MailingCity,MailingState,MailingCountry,MailingPostalCode from contact where Id IN : mapAddress.keySet()];
                
                for(contact con : lstContact){
                    string addressVal ='';
                    if(mapAddress.get(con.Id).AddressLineOne__c != null && mapAddress.get(con.Id).AddressLineOne__c != '')
                    addressVal = mapAddress.get(con.Id).AddressLineOne__c;
                    if(mapAddress.get(con.Id).AddressLineTwo__c != null && mapAddress.get(con.Id).AddressLineTwo__c != '')
                    addressVal = addressVal+' '+mapAddress.get(con.Id).AddressLineTwo__c;
                    if(mapAddress.get(con.Id).AddressLineThree__c != null && mapAddress.get(con.Id).AddressLineThree__c != '')
                    addressVal = addressVal+' '+mapAddress.get(con.Id).AddressLineThree__c;
                    if(addressVal != null && addressVal != '')
                    con.Mailingstreet = addressVal;
                    if(mapAddress.get(con.Id).City__c != null && mapAddress.get(con.Id).City__c != '')
                    con.MailingCity = mapAddress.get(con.Id).City__c;
                    if(mapAddress.get(con.Id).ProvinceStateValue__c != null && mapAddress.get(con.Id).ProvinceStateValue__c != '')
                        con.MailingState = mapAddress.get(con.Id).ProvinceStateValue__c;                    
                    if(mapAddress.get(con.Id).CountryValue__c != null && mapAddress.get(con.Id).CountryValue__c !='')
                     con.MailingCountry = mapAddress.get(con.Id).CountryValue__c;
                    if(mapAddress.get(con.Id).ZipPostalCode__c != null && mapAddress.get(con.Id).ZipPostalCode__c !='')
                    con.MailingPostalCode = mapAddress.get(con.Id).ZipPostalCode__c;
                } 
                if(!lstContact.isEmpty()){
                    try{
                        update lstContact;
                    }
                    catch(exception e){
                        throw new H_addressException(e.getMessage());
                    }
                }
            }
            else{
                for(Address__c addVal : lstAddress){
                    if(setMultiPrimaryCon.contains(addVal.contact__c)){
                        addVal.addError(H_Constants.MultiplePrimaryAddress);
                    }
                }
            }
        }
    }
    /*
        *  @author           Piyush Rathor (Deloitte) 
        *  @description      clear contact primary address when address is deleted
        *  @param            Map of Address Id and Address Object
        *                    
        *  @return           Void
        */
    public static void clearPrimaryAddress(map<Id,Address__c>mapOldAddress){
        set<Id>setContactId = new set<Id>();
        for(Address__c addVal : mapOldAddress.values()){
            if(addVal.AddressUsageValue__c != null && addVal.AddressUsageValue__c != '' && (addVal.EndDate__c == null || addVal.EndDate__c >= date.today()) && addVal.AddressUsageValue__c.equalsIgnoreCase(H_Constants.addressUsageVal)){
                setContactId.add(addVal.contact__c);
            }
        }
        if(!setContactId.isEmpty()){
            list<contact>lstCon = [select id,Mailingstreet,MailingCity,MailingState,MailingCountry,MailingPostalCode from contact where Id IN : setContactId];
            for(contact conVal : lstCon){
                conVal.Mailingstreet = null;
                conVal.MailingCity = null;
                conVal.MailingState = null;
                conVal.MailingCountry = null;
                conVal.MailingPostalCode = null;
            }
            if(!lstCon.isEmpty()){
                try{
                    update lstCon;
                }
                catch(exception e){
                    throw new H_addressException(e.getMessage());
                }
            }
        }
    }
}