/**
*   @author       : Piyush Rathor(Deloitte)
*   @date         : 12/10/2015
    @description  : Test class for class - H_RelatedCaseCommentController, showing case comment related to all cases of customer
    Modification Log:
    ------------------------------------------------------------------------------------------
    Developer               User story            Date                Description
    ------------------------------------------------------------------------------------------
    Piyush (Deloitte)                           12/10/2015          Original Version
*/

@istest
public class H_RelatedCaseCommentController_test{
    //Test method to test scenarios to populate related account
    static testMethod void testRelatedComment(){
         Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        if(objAccount != null){
         insert objAccount;
         system.assertnotEquals(objAccount.Id,null);
        }
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(1);
        lstContact[0].UCID__c = '3215079999910136';
        lstContact[0].AccountId = objAccount.Id;
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),1);
        
           //Test Case Record
        list<case>lstCase = H_ParsingTestDataUtility.createCase(1);
        lstCase[0].contactId = lstContact[0].Id;
        if(lstCase != null && !lstCase.isEmpty())
        insert lstCase;
        system.assertEquals(lstCase.size(),1);
        
        caseComment csComment = new caseComment();
        csComment.ParentId = lstCase[0].Id;
        csComment.CommentBody = 'test';
        if(csComment != null)
        insert csComment;
        system.assertNotEquals(csComment,null); 
        
        test.startTest();
            System.currentPageReference().getParameters().put('id', lstContact[0].Id);
            H_RelatedCaseCommentController H_caseComment = new H_RelatedCaseCommentController();
        test.stoptest();
    }
}