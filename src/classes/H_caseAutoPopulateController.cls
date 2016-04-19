/**
*   @author       : Piyush Rathor(Deloitte)
*   @date         : 15/09/2015
    @description  : Controller for H_caseAutoPopulate Page and overriding standard case page to prepopulate Contact Centre Company and Group
    Modification Log:
    ------------------------------------------------------------------------------------------
    Developer               User story            Date                Description
    ------------------------------------------------------------------------------------------
    Piyush (Deloitte)                           18/08/2015          Original Version
*/
public with sharing class H_caseAutoPopulateController {
    //Constructor
    public H_caseAutoPopulateController(ApexPages.StandardController controller) {        
    }
    /*
        *  @author       Piyush Rathor (Deloitte) 
        *  @description  For Redirecting the VF Page based on Role values.
        *  @param        none                    
        *  @return       none
        
    */  
    public pageReference redirectToPage(){
        list<UserRole>lstUserRole = new list<UserRole>();
    	if(String.isNotBlank(userInfo.getUserRoleId())){
           lstUserRole = [select id,name from UserRole where Id =: userInfo.getUserRoleId() limit 1];
    	}
        string recordTypeVal ='';
        string urlParam ='&nooverride=1';
        if(ApexPages.currentPage().getParameters().get('def_account_id') != null && ApexPages.currentPage().getParameters().get('def_account_id') != '')
            urlParam = urlParam+'&def_account_id='+ApexPages.currentPage().getParameters().get('def_account_id');
        if(ApexPages.currentPage().getParameters().get('def_contact_id') != null && ApexPages.currentPage().getParameters().get('def_contact_id') != '')
            urlParam = urlParam+'&def_contact_id='+ApexPages.currentPage().getParameters().get('def_contact_id');
        if(ApexPages.currentPage().getParameters().get(Label.Vin_field) != null && ApexPages.currentPage().getParameters().get(Label.Vin_field) != '')
            urlParam = urlParam+'&'+Label.Vin_field+'='+ApexPages.currentPage().getParameters().get(Label.Vin_field);
        if(ApexPages.currentPage().getParameters().get(Label.Vin_field+'_lkid') != null && ApexPages.currentPage().getParameters().get(Label.Vin_field+'_lkid') != '')
            urlParam = urlParam+'&'+Label.Vin_field+'_lkid='+ApexPages.currentPage().getParameters().get(Label.Vin_field+'_lkid');
        if(ApexPages.currentPage().getParameters().get('RecordType') != null && ApexPages.currentPage().getParameters().get('RecordType') != '')
            urlParam = urlParam+'&RecordType='+ApexPages.currentPage().getParameters().get('RecordType');
        urlParam = urlParam+'&nooverride=1';
        string pageRedirect = '';
        if(recordTypeVal != null && recordTypeVal != '')
            pageRedirect = '500/e?retURL=%2F500'+urlParam;
        else
            pageRedirect = '500/e?retURL=%2F500'+urlParam;
        if(!lstUserRole.isEmpty()){
            //Get All Values of Role Mapping Custom Setting
            Map<String, role_mapping__c>mapRoleMapping = role_mapping__c.getAll();
            if(!mapRoleMapping.isEmpty()){
                for(string roleVal : mapRoleMapping.keySet()){
                    //If user Role Contains the custom setting Name
                    if(lstUserRole[0].name.contains(roleVal)){
                        if(recordTypeVal != null && recordTypeVal != '')
                        pageRedirect= '500/e?'+Label.Contact_Center_Company+'='+mapRoleMapping.get(roleVal).Contact_Center_Company__c+'&'+Label.group+'='+mapRoleMapping.get(roleVal).Group__c+'&retURL=%2F500%2Fo'+urlParam;
                        else
                            pageRedirect= '500/e?'+Label.Contact_Center_Company+'='+mapRoleMapping.get(roleVal).Contact_Center_Company__c+'&'+Label.group+'='+mapRoleMapping.get(roleVal).Group__c+'&retURL=%2F500%2Fo'+urlParam;
                    }
                }
            }
        }
        pageReference pg = new pageReference('/'+pageRedirect);
        pg.setRedirect(false);
        return pg;
    }
}