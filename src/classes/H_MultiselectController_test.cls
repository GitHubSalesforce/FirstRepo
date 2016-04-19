/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 29/09/2015
        @description  : Test Class for H_MultiselectController class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           29/09/2015           Original Version
*/
@istest
public class H_MultiselectController_test{
    //Test method to test scenarios for multi picklist
    static testMethod void  testMultiselect(){
        Test.startTest();
        H_MultiselectController multiSelect = new H_MultiselectController();
        
        multiSelect.leftOptions = new List<SelectOption>();
        multiSelect.rightOptions = new List<SelectOption>();

        multiSelect.leftOptionsHidden = 'A&a&b&b&C&c';
        multiSelect.rightOptionsHidden = '';
        
        System.assertEquals(multiSelect.leftOptions.size(), 3);
        System.assertEquals(multiSelect.rightOptions.size(), 0);
        Test.stopTest();
    }
}