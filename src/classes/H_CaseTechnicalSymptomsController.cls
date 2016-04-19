/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 29/09/2015
        @description  : populate technical symptoms on case Detail Page
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           29/09/2015           Original Version
*/
public with sharing class H_CaseTechnicalSymptomsController {
    public case caseRecord{get;set;}
    string caseId;
    public boolean showField{get;set;}
    public boolean inputDetails{get;set;}
    public SelectOption[] selectedIssue { get; set; }
    public SelectOption[] allIssue {get; set;}
    
    public H_CaseTechnicalSymptomsController(ApexPages.StandardController controller){
        caseId = controller.getId();
        showField = true;
        inputDetails = false;
        allIssue = new list<selectoption>();
        selectedIssue = new List<SelectOption>();
        set<string>setSelectedVal = new set<string>();
        if(String.isNotBlank(controller.getId())){
            caseRecord = [select id,Selected_Technical_Issue__c,Technical_Symptoms__c,Technical_Symptoms__r.Symptom_Code_Related__c from case where Id =: controller.getId()];
            if(caseRecord != null && caseRecord.Selected_Technical_Issue__c != null && caseRecord.Selected_Technical_Issue__c != ''){
                for(string str : caseRecord.Selected_Technical_Issue__c.split('; ')){
                    selectedIssue.add(new SelectOption(str,str));
                    setSelectedVal.add(str);
                }
            }
            if(caseRecord != null && caseRecord.Technical_Symptoms__c != null && caseRecord.Technical_Symptoms__r.Symptom_Code_Related__c != null && caseRecord.Technical_Symptoms__r.Symptom_Code_Related__c != ''){
                inputDetails = true;
                list<string>lstSymptomRelated = caseRecord.Technical_Symptoms__r.Symptom_Code_Related__c.split(',');
                for(string s : lstSymptomRelated){
                    if(setSelectedVal.isEmpty() || !setSelectedVal.contains(s))
                        allIssue.add(new SelectOption(s,s));
                }            
            }
        }
    }
    public void saveRecord(){
        string selVal ='';
        for(SelectOption so : selectedIssue){
            selVal = so.getValue() + '; '+selVal;
        }       
        if(selVal != null && selVal != '')
            caseRecord.Selected_Technical_Issue__c = selVal.substring(0,selVal.length()-2);
        else
            caseRecord.Selected_Technical_Issue__c = selVal;
            
        if(caseRecord != null){    
            try{
                update caseRecord;
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            }
        }
        
        showField = true;      
    }
    public pagereference editRecord(){
        showField = false;
        return null;
    }
    public void cancelRecord(){
        showField = true;
    }
}