/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 08/01/2016
    @description  : Class for H_ContactInsert Visualforce Page and for custom contact creation
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
        Piyush Rathor                                   08/01/2016         Class for H_ContactInsert Visualforce Page and for custom contact creation
        Piyush Rathor                                   27/01/2016         Changes based on the comments on User Story
        Piyush Rathor                                   2/02/2016          Province State value picklist
        Piyush Rathor                                   8/02/2016          Future Method for Address and Contact Method Insertion
*/    
public with sharing class H_ContactInsertController {

    public contact contactRecord{get;set;}
    public string contactType{get;set;}
    public string selectedProvince{get;set;}
    public string selectedCountry{get;set;}
    
    public H_ContactInsertController(ApexPages.StandardController controller) {
        selectedProvince = '';
        selectedCountry = '';
        string recTypeVal = apexpages.currentpage().getparameters().get('RecordType');
        contactType = '';
        list<recordtype>lstRecordType = [select id,DeveloperName from recordtype where id =: recTypeVal and SobjectType = 'contact'];
        if(!lstRecordType.isEmpty())
        contactType = lstRecordType[0].DeveloperName;  
            
        contactRecord = (contact)controller.getRecord();
        //Id customerRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get(contactType).getRecordTypeId();
        //contactRecord.HFS_Email__c = 'YES';
        if(recTypeVal != null && recTypeVal != '')
        contactRecord.recordtypeId = recTypeVal;
        
    }
    
    public pagereference saveRec(){
        try{
            string errorMsg ='';
            boolean requiredFieldsFilled = false;
            boolean AddressFieldsFilled = false;
            /*
            if(contactRecord.mailingStreet != null && contactRecord.mailingStreet != '' ){
                requiredFieldsFilled = true;
            }
            else
            errorMsg = errorMsg+'Primary Street,';
            if(contactRecord.mailingcity != null && contactRecord.mailingcity != '' ){
                requiredFieldsFilled = true;
            }
            else
                errorMsg = errorMsg+' Primary City,';
            */
            if(selectedProvince != null && selectedProvince != ''){
                
                contactRecord.MailingState = selectedProvince;
            }
            else{
                errorMsg = errorMsg+' Primary State/Province,';
                AddressFieldsFilled = true;
            }
            if(selectedCountry != null && selectedCountry != ''){
                contactRecord.MailingCountry = selectedCountry;
            }
            else{
                errorMsg = errorMsg+' Primary Country,';
                AddressFieldsFilled = true;
            }
           
            if(AddressFieldsFilled && errorMsg != null && errorMsg != ''){
                errorMsg = errorMsg.substringBeforeLast(',');
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,errorMsg +' : You must enter a value'));
                return null;
            }
            else{
                requiredFieldsFilled = true;
            }
            if(contactRecord.Phone != null && contactRecord.Phone != ''){
                requiredFieldsFilled = true;
            }
            if(contactRecord.Email != null && contactRecord.Email != ''){
                requiredFieldsFilled = true;
            }
            if(!requiredFieldsFilled){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.Contact_Insert_Error1));
                return null;
            }
            if(contactRecord.OrganizationName__c != null && contactRecord.OrganizationName__c != ''){
                contactRecord.lastName = contactRecord.OrganizationName__c;
            }
            
            insert contactRecord;
            
            if(contactRecord.Id != null){
                insertRelatedRecords(contactRecord.Id);
            }
            
            pagereference pg = new pagereference('/'+contactRecord.Id);
            return pg;          
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }
    @future
    public static void insertRelatedRecords(Id contactId){
        list<contact>lstContact = [Select id,mailingStreet,mailingcity,MailingState,MailingPostalCode,mailingcountry,Phone,Email from contact where Id =: contactId];
        list<ContactMethod__c>lstConMethod = new List<ContactMethod__c>();
        
        if(!lstContact.isEmpty()){
            Address__c addressRecord = new Address__c();
            addressRecord.AddressLineOne__c = lstContact[0].mailingStreet;
            addressRecord.City__c = lstContact[0].mailingcity;
            addressRecord.ProvinceStateValue__c = lstContact[0].MailingState ;
            addressRecord.Contact__c = lstContact[0].Id;
            addressRecord.ZipPostalCode__c = lstContact[0].MailingPostalCode;
            addressRecord.CountryValue__c = lstContact[0].mailingcountry;
            addressRecord.AddressUsageValue__c = H_Constants.addressUsageVal;
            addressRecord.StartDate__c = system.now();
            addressRecord.Created_from_New_contact_Page__c = true;
            if(lstContact[0].Phone  != null){
                ContactMethod__c conMethod = new ContactMethod__c();
                conMethod.Contact__c = lstContact[0].Id;
                conMethod.ReferenceNumber__c = lstContact[0].Phone;
                conMethod.ContactMethodValue__c = H_Constants.contactMethodValuePhone;
                conMethod.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValuePhone;
                conMethod.StartDate__c = system.now();
                conMethod.Created_from_New_contact_Page__c = true;
                lstConMethod.add(conMethod);
            }
            if(lstContact[0].Email != null &&  lstContact[0].Email != ''){
                ContactMethod__c conMethod1 = new ContactMethod__c();
                conMethod1.Contact__c = lstContact[0].Id;
                conMethod1.ReferenceNumber__c = lstContact[0].Email;
                conMethod1.ContactMethodValue__c = H_Constants.contactMethodValue;
                conMethod1.ContactMethodUsageValue__c = H_Constants.contactMethodUsageValue;
                conMethod1.StartDate__c = system.now();
                conMethod1.Created_from_New_contact_Page__c = true;
                lstConMethod.add(conMethod1);
            }
            try{
                insert addressRecord;
                
                if(!lstConMethod.isEmpty())
                    insert lstConMethod;
            }
            catch(exception e){
                H_Logger.error(e.getMessage(), 'H_ContactInsertController '+ ' : '+ 'Address Insert','ERROR');
            }
        }
    }
    
    public List<SelectOption>getProvince() {
        List<SelectOption> options = new List<SelectOption>();
        String provinceVal = H_Constants.provinceValue;
        options.add(new SelectOption('','--None--'));
        list<string>lstProvince = new list<string>();
        lstProvince = provinceVal.split(',');
        lstProvince.sort();
        for(string s : lstProvince){
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    public List<SelectOption>getCountry() {
        List<SelectOption> options = new List<SelectOption>();
        String countryVal = H_Constants.countryValue;
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Canada','Canada'));
        options.add(new SelectOption('United States of America','United States of America'));       
        list<string>lstCountry = new list<string>();
        lstCountry = countryVal.split(',');
        lstCountry.sort();
        for(string s : lstCountry){
            if(!(s.containsIgnoreCase('Canada') || s.containsIgnoreCase('United States of America')))
            options.add(new SelectOption(s,s));
        }
        return options;
    }
    
    public pagereference cancelRec(){
        pagereference pg = new pagereference('/003/o');
        return pg;
    }
}