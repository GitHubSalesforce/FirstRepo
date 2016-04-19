/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 20/12/2015
       @description  : Trigger helper to update name on contact method and address
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
          Piyush Rathor                                   20/12/2015         Trigger helper to update name on contact method and address
          Piyush Rathor                                   05/01/2016         Trigger helper to update Postal code to custom postal code field
*/  
public with sharing class H_contactTriggerHelper{
    /*
    public static void contactNameUpdate(list<contact>lstContact,map<Id,contact>mapOldContact){
        map<Id,string>mapFirstName = new map<Id,string>();
        map<Id,string>mapLastName = new map<Id,string>();
        for(contact con : lstContact){
            if(con.firstname != null && con.firstname != '' && mapOldContact.get(con.Id).firstname != con.firstname){
                mapFirstName.put(con.Id,con.firstname);
            }
            if(mapOldContact.get(con.Id).lastname != con.lastname){
                mapLastName.put(con.Id,con.lastname);
            }
        }
        list<Address__c>lstUpdateAddress = new list<Address__c>();
        list<ContactMethod__c>lstUpdateConMethod = new list<ContactMethod__c>();
        if(mapFirstName.size() >0 || mapLastName.size()>0){
            list<Address__c>lstAddress = [select id,First_Name__c,Last_Name__c,contact__c from Address__c where contact__c IN : mapFirstName.keySet() OR contact__c IN : mapLastName.keySet()];
            if(!lstAddress.isEmpty()){
                for(Address__c address : lstAddress){
                    if(mapFirstName.containsKey(address.contact__c)){
                        address.First_Name__c = mapFirstName.get(address.contact__c);
                    }
                    if(mapLastName.containsKey(address.contact__c)){
                        address.Last_Name__c = mapLastName.get(address.contact__c);
                    }
                    lstUpdateAddress.add(address);
                }
            }
            list<ContactMethod__c>lstConMethod = [select id,First_Name__c,Last_Name__c,contact__c from ContactMethod__c where contact__c IN : mapFirstName.keySet() OR contact__c IN : mapLastName.keySet()];
            if(!lstConMethod.isEmpty()){
                for(ContactMethod__c conMethod : lstConMethod){
                    if(mapFirstName.containsKey(conMethod.contact__c)){
                        conMethod.First_Name__c = mapFirstName.get(conMethod.contact__c);
                    }
                    if(mapLastName.containsKey(conMethod.contact__c)){
                        conMethod.Last_Name__c = mapLastName.get(conMethod.contact__c);
                    }
                    lstUpdateConMethod.add(conMethod);
                }
            }
            if(!lstUpdateConMethod.isEmpty()){
                update lstUpdateConMethod;
            }
            if(!lstUpdateAddress.isEmpty()){
                update lstUpdateAddress;
            }
        }
    }*/
    public static void postalCodeUpdate(list<contact>lstContact){
        for(contact con : lstContact){
            con.Primary_Postal_Code_Look_Up__c = '';
            if(con.MailingPostalCode != null && con.MailingPostalCode != ''){
                con.Primary_Postal_Code_Look_Up__c = con.MailingPostalCode;
            }
        }
    }
}