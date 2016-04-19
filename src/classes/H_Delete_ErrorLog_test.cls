/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 27/01/2016
        @description  : Test Class for H_Delete_ErrorLog_Schedule and H_Delete_ErrorLog_Batch class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           27/01/2016          Original Version
*/
@istest(SeeAllData=true)
public class H_Delete_ErrorLog_test{
    //Test method to test scenarios to delete contact and related records
    static testMethod void  testErrorLogDeletion(){         
        
        test.startTest();
            H_Delete_ErrorLog_Schedule errorLogDeleteSchedule = new H_Delete_ErrorLog_Schedule();
            String sch = '0 0 23 * * ?'; 
            system.schedule('Test DeleteErrorLog', sch, errorLogDeleteSchedule); 
        test.stopTest();
    }
}