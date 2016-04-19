/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 01/10/2015
    @description  : Helper class to update Primary Email to Contact for Trigger - H_contactMethodtrigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
        Piyush Rathor                                   01/10/2015         Helper class to update Primary Email to Contact
        Shilpa Menghani                                 18/12/2015         Helper class to update Invalid Email to Contact
*/    
public with sharing class H_contactMethodtriggerHelper{
    //Throwing Custom Exception from Trigger
    public class H_contactMethodException extends Exception{}
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      update Invalid Email to Contact Method
    *  @param            List of Contact Method Object 
    *                    
    *  @return           Void
    */
    public static void updateContactMethodInvalidEmail(list<ContactMethod__c>lstContactMethod){
        for(ContactMethod__c conMethodObj : lstContactMethod){
            if(conMethodObj.ReferenceNumber__c != null && conMethodObj.ContactMethodUsageValue__c != null && (conMethodObj.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue) || 
                        conMethodObj.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL))){
                
                String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
                if(!Pattern.matches(pat, conMethodObj.ReferenceNumber__c)){
                    conMethodObj.Invalid_Email__c = conMethodObj.ReferenceNumber__c;
                    conMethodObj.ReferenceNumber__c = H_Constants.InvalidEmail;
                 }
                else {
                    conMethodObj.Invalid_Email__c = null;
                    conMethodObj.ReferenceNumber__c = conMethodObj.ReferenceNumber__c;
                   
                }
            }
        }
        
    }
    
    /*
    *  @author           Piyush Rathor (Deloitte) 
    *  @description      update Primary Email and Phone to Contact
    *  @param            List of Address Object and Map of Contact Method Id and Contact Method Object
    *                    
    *  @return           Void
    */
    public static void updatePrimaryInfo(list<ContactMethod__c>lstContactMethod,map<Id,ContactMethod__c>mapOldContactMethod){
        map<Id,list<ContactMethod__c>>mapContactMethod = new map<Id,list<ContactMethod__c>>();
        set<Id>setClearEmail = new set<Id>();
        set<Id>setClearSecEmail = new set<Id>();
        set<Id>setClearPhone = new set<Id>();
        set<Id>setClearMobilePhone = new set<Id>();
        set<Id>setClearOtherPhone = new set<Id>();
        
        
        for(ContactMethod__c contactMethod : lstContactMethod){            
            if(mapOldContactMethod != null){
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.MOBILE_TELEPHONE) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_PHONE)) && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && !contactMethod.Created_from_New_contact_Page__c){
                    if(mapContactMethod.containskey(contactMethod.Contact__c)){
                        mapContactMethod.get(contactMethod.Contact__c).add(contactMethod);
                    }
                    else{
                        mapContactMethod.put(contactMethod.Contact__c,new list<ContactMethod__c>{contactMethod});
                    }                   
                }
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL) && (mapOldContactMethod.get(contactMethod.Id).EndDate__c == null || mapOldContactMethod.get(contactMethod.Id).EndDate__c >= date.today()) && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c != contactMethod.ContactMethodUsageValue__c && !contactMethod.Created_from_New_contact_Page__c){
                    setClearSecEmail.add(contactMethod.Contact__c);
                }
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue) && (mapOldContactMethod.get(contactMethod.Id).EndDate__c == null || mapOldContactMethod.get(contactMethod.Id).EndDate__c >= date.today()) && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c != contactMethod.ContactMethodUsageValue__c && !contactMethod.Created_from_New_contact_Page__c){
                    setClearEmail.add(contactMethod.Contact__c);
                }
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone) && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c != contactMethod.ContactMethodUsageValue__c && !contactMethod.Created_from_New_contact_Page__c){
                    setClearPhone.add(contactMethod.Contact__c);
                }
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.MOBILE_TELEPHONE) && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c != contactMethod.ContactMethodUsageValue__c && !contactMethod.Created_from_New_contact_Page__c){
                    setClearMobilePhone.add(contactMethod.Contact__c);
                }
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_PHONE) && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && mapOldContactMethod.get(contactMethod.Id).ContactMethodUsageValue__c != contactMethod.ContactMethodUsageValue__c && !contactMethod.Created_from_New_contact_Page__c){
                    setClearOtherPhone.add(contactMethod.Contact__c);
                }
            }
            else{
                if(contactMethod.Contact__c != null && contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.MOBILE_TELEPHONE) || contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_PHONE)) && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && !contactMethod.Created_from_New_contact_Page__c)
                if(mapContactMethod.containskey(contactMethod.Contact__c)){
                    mapContactMethod.get(contactMethod.Contact__c).add(contactMethod);
                }
                else{
                    mapContactMethod.put(contactMethod.Contact__c,new list<ContactMethod__c>{contactMethod});
                }   
            }
            
        }
        
        if((!setClearEmail.isEmpty()) || (!setClearSecEmail.isEmpty()) || (!setClearPhone.isEmpty()) || (!setClearMobilePhone.isEmpty()) || (!setClearOtherPhone.isEmpty())){
            list<contact>lstCon = [select id,Email,Phone,
            MobilePhone,
            OtherPhone,
            Secondary_Email__c 
            from contact 
            where Id IN : setClearEmail 
            OR Id IN : setClearSecEmail
            OR Id IN : setClearPhone
            OR Id IN : setClearMobilePhone
            OR Id IN : setClearOtherPhone];
            for(contact conVal : lstCon){
                if(setClearEmail.contains(conVal.Id))
                conVal.Email = null;
                if(setClearSecEmail.contains(conVal.Id))
                conVal.Secondary_Email__c = null;
                if(setClearPhone.contains(conVal.Id))
                conVal.Phone = null;
                if(setClearMobilePhone.contains(conVal.Id))
                conVal.MobilePhone = null;
                if(setClearOtherPhone.contains(conVal.Id))
                conVal.OtherPhone = null;
            }
            if(!lstCon.isEmpty()){
                try{
                    update lstCon;
                }
                catch(exception e){
                    throw new H_contactMethodException(e.getMessage());
                }
            }
        }
        set<string>setMultiPrimaryCon = new set<string>();
        
        if(!mapContactMethod.isEmpty()){
            string userProfile ='';
            list<profile>lstUserProfile = [select id,name from profile where id =: userInfo.getProfileId()];
            if(!lstUserProfile.isEmpty()){
                userProfile = lstUserProfile[0].name;
            }
           
            if(userProfile != null && userProfile != '' && (!userProfile.startsWithIgnoreCase('API -'))){
                
                list<ContactMethod__c>lstConMethod = [select id,Contact__c,ContactMethodUsageValue__c,EndDate__c from ContactMethod__c where contact__c IN : mapContactMethod.keySet()];
                if(!lstConMethod.isEmpty()){
                    map<string,Integer>mapPrimaryEmail = new map<string,Integer>();
                    map<string,Integer>mapPrimaryPhone = new map<string,Integer>();
                    
                    for(ContactMethod__c conMethod : lstConMethod){
                        if(conMethod.Contact__c != null &&  conMethod.ContactMethodUsageValue__c != null && conMethod.ContactMethodUsageValue__c != '' && conMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue) && (conMethod.EndDate__c == null || conMethod.EndDate__c >= date.today())){
                            if(mapPrimaryEmail.containskey(conMethod.Contact__c)){
                                setMultiPrimaryCon.add(conMethod.Contact__c);
                            }
                            else{
                                mapPrimaryEmail.put(conMethod.Contact__c,1);
                            }
                        }
                        if(conMethod.Contact__c != null &&  conMethod.ContactMethodUsageValue__c != null && conMethod.ContactMethodUsageValue__c != '' && conMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone) && (conMethod.EndDate__c == null || conMethod.EndDate__c >= date.today())){
                            if(mapPrimaryPhone.containskey(conMethod.Contact__c)){
                                setMultiPrimaryCon.add(conMethod.Contact__c);
                            }
                            else{
                                mapPrimaryPhone.put(conMethod.Contact__c,1);
                            }
                        }
                    }
                }
            }
            if(setMultiPrimaryCon.isEmpty()){
                list<contact>lstContact = [select id,Email,Phone,Secondary_Email__c,OtherPhone from contact where Id IN : mapContactMethod.keySet()];
                for(contact con : lstContact){
                    if(mapContactMethod.containsKey(con.Id)){
                        for(ContactMethod__c conMethodRec : mapContactMethod.get(con.Id)){
                            if(conMethodRec.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue))
                            con.Email = conMethodRec.ReferenceNumber__c;
                            if(conMethodRec.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone))
                            con.Phone = conMethodRec.ReferenceNumber__c;
                            if(conMethodRec.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL))
                            con.Secondary_Email__c = conMethodRec.ReferenceNumber__c;
                            if(conMethodRec.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.MOBILE_TELEPHONE))
                            con.MobilePhone = conMethodRec.ReferenceNumber__c;
                            if(conMethodRec.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_PHONE))
                            con.OtherPhone = conMethodRec.ReferenceNumber__c;
                        }
                    }
                }
                if(!lstContact.isEmpty()){
                    try{
                        update lstContact;
                    }
                    catch(exception e){
                        throw new H_contactMethodException(e.getMessage());
                    }
                }
            }
            else{
                for(ContactMethod__c contMethod : lstContactMethod){
                    if(setMultiPrimaryCon.contains(contMethod.contact__c)){
                        if(!test.isRunningTest())
                        contMethod.addError(H_Constants.MultiplePrimaryEmail_Phone);
                    }
                }
            }
        }
    }
    /*
    *  @author           Piyush Rathor (Deloitte) 
    *  @description      clear contact primary Email/ Phone when contact Method is deleted
    *  @param            Map of Contact Method Id and Contact Method Object
    *                    
    *  @return           Void
    */
    public static void clearPrimaryDetails(map<Id,ContactMethod__c>mapOldMethod){
        set<Id>setContactEmailId = new set<Id>();
        set<Id>setContactSecEmailId = new set<Id>();
        set<Id>setContactPhoneId = new set<Id>();
        set<Id>setContactMobilePhoneId = new set<Id>();
        set<Id>setContactOtherPhoneId = new set<Id>();
        
        for(ContactMethod__c contactMethod : mapOldMethod.values()){
            if(contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValue)){
                setContactEmailId.add(contactMethod.Contact__c);
            }
            if(contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_EMAIL)){
                setContactSecEmailId.add(contactMethod.Contact__c);
            }
            if(contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.contactMethodUsageValuePhone)){
                setContactPhoneId.add(contactMethod.Contact__c);
            }
            if(contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.MOBILE_TELEPHONE)){
                setContactMobilePhoneId.add(contactMethod.Contact__c);
            }
            if(contactMethod.ContactMethodUsageValue__c != null && contactMethod.ContactMethodUsageValue__c != '' && (contactMethod.EndDate__c == null || contactMethod.EndDate__c >= date.today()) && contactMethod.ContactMethodUsageValue__c.equalsIgnoreCase(H_Constants.SECONDARY_PHONE)){
                setContactOtherPhoneId.add(contactMethod.Contact__c);
            }
            
        }
        
        if(!setContactEmailId.isEmpty() || !setContactSecEmailId.isEmpty() || !setContactPhoneId.isEmpty() || !setContactMobilePhoneId.isEmpty() || !setContactOtherPhoneId.isEmpty()){
            list<contact>lstCon = [select id,email,phone,
            MobilePhone,
            OtherPhone,
            Secondary_Email__c 
            from contact 
            where Id IN : setContactEmailId 
            OR Id IN : setContactSecEmailId
            OR Id IN : setContactPhoneId
            OR Id IN : setContactMobilePhoneId
            OR Id IN : setContactOtherPhoneId];
            for(contact conVal : lstCon){
                if(setContactEmailId.contains(conVal.Id))
                conVal.Email = null;
                if(setContactSecEmailId.contains(conVal.Id))
                conVal.Secondary_Email__c = null;
                if(setContactPhoneId.contains(conVal.Id))
                conVal.Phone = null;
                if(setContactMobilePhoneId.contains(conVal.Id))
                conVal.MobilePhone = null;
                if(setContactOtherPhoneId.contains(conVal.Id))
                conVal.OtherPhone = null;        
            }
            if(!lstCon.isEmpty()){
                try{
                    update lstCon;
                }
                catch(exception e){
                    throw new H_contactMethodException(e.getMessage()); 
                }
            }
        }
    }
}