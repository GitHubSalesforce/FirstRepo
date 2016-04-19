/**
*   @author       : Piyush Rathor(Deloitte)
*   @date         : 09/10/2015
    @description  : For showing case comment related to all cases of customer
    Modification Log:
    ------------------------------------------------------------------------------------------
    Developer               User story            Date                Description
    ------------------------------------------------------------------------------------------
    Piyush (Deloitte)                           09/10/2015          Original Version
*/
public with sharing class H_RelatedCaseCommentController {
    //List of case comments
    public list<CaseComment>lstCaseComment{get;set;}
    
    //Constructor
    public H_RelatedCaseCommentController(){
        lstCaseComment = new list<CaseComment>();
        //Id of the Contact
        string contactIdVal = ApexPages.currentPage().getParameters().get('id');
        if(contactIdVal != null && contactIdVal != ''){
            //Case related to the contact
            list<case>lstCase = [select id from case where contactId =: contactIdVal];
            if(!lstCase.isEmpty()){
                lstCaseComment = [select id,CommentBody,ParentId,parent.casenumber from CaseComment where parentId =: lstCase];
            }
        }
    }
}