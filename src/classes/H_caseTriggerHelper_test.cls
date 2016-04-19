/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 10/09/2015
        @description  : Test Class for H_caseTriggerHelper class
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
           Piyush (Deloitte)                           10/09/2015           Original Version
*/
@istest
public class H_caseTriggerHelper_test{
    //Test method to test scenarios to populate related account
    static testMethod void  testRelatedContact(){
        //Test account Record
        Account objAccount = H_ParsingTestDataUtility.createAccount(1)[0]; 
        if(objAccount != null)
        insert objAccount;
        system.assertnotEquals(objAccount.Id,null);
        
        //Test Contact Record
        list<Contact>lstContact = H_ParsingTestDataUtility.createContact(2);
        integer count = 0;
        for(contact con : lstContact){
            con.UCID__c = '321507531001013'+string.valueOf(count);
            con.AccountId = objAccount.Id;
            con.phone = '1234567890';
            con.email = 'test@test.com';
            con.mailingstreet = 'test';
            count++;
        }
        if(lstContact != null && !lstContact.isEmpty())
        insert lstContact;
        system.assertEquals(lstContact.size(),2);
        
        vin__c vinRecord = H_ParsingTestDataUtility.createVin();
        if(vinRecord != null)
        insert vinRecord;
        system.assertnotEquals(vinRecord.Id,null);
        
        Customer_Role__c  custRoleRecord = H_ParsingTestDataUtility.createCustomerRole(lstContact[0].Id);
        custRoleRecord.vin__c = vinRecord.Id;
        if(custRoleRecord != null)
        insert custRoleRecord;
        system.assertnotEquals(custRoleRecord.Id,null);
        
        //Test Case Record
        list<case>lstCase = H_ParsingTestDataUtility.createCase(3);
        if(!lstContact.isEmpty()){
            for(case cs : lstCase){
                cs.Related_Contact_Name__c = lstContact[0].Id;
            }
        }
        test.startTest();
            //Scenario 1 : When Related contact is populated on case on insert
            if(lstCase != null && !lstCase.isEmpty())
            insert lstCase;
            if(lstCase.size() == 3){
                //Scenario 2 : Related Contact is changed on the case
                lstCase[0].Related_Contact_Name__c = lstContact[1].Id;
                lstCase[0].VIN_Serial_No__c = custRoleRecord.Id;
                lstCase[1].Related_Contact_Name__c = lstContact[1].Id;
                
                //Scenario 3 : Related Contact is emptied on the case
                lstCase[2].Related_Contact_Name__c = null;
            }
            if(lstCase != null && !lstCase.isEmpty())
            update lstCase;
            
             system.assertNotEquals(lstCase.size(),null);
             
             lstCase = [Select Related_Contact_Name__c from Case where Id =: lstCase];
             system.assertEquals(lstCase[0].Related_Contact_Name__c, lstContact[1].Id);
             
        test.stopTest();
    }
    static testMethod void  testcloseDate(){
        //Test Case Record
        list<case>lstCase = H_ParsingTestDataUtility.createCase(14);
        integer i = 0;
        for(case cs : lstCase){
            if(i==0){
                cs.Expected_Close_Date_Investigation_Dealer__c = system.today()-7;
                cs.Expected_Close_Date_Investigation_Factor__c = system.today()-6;
                cs.Expected_Close_Date_Countermeasure_Softw__c = system.today()-5;
                cs.Expected_Close_Date_Inspection_QE__c = system.today()-4;
                cs.Expected_Close_Date_Countermeasure_Part__c = system.today()-3;
                cs.Expected_Close_Date_Inspection_FE__c = system.today()-2;
                cs.Expected_Close_Date_Customer_Relations__c = system.today()-1;
                cs.Expected_Close_Date_DCD__c = system.today();
                cs.Expected_Close_Date_Repair_at_HCI__c = system.today()+1;
                cs.Expected_Close_Date_HFS__c=system.today()+2;
                cs.Expected_Close_Date_Investigation_Tech__c=system.today()+3;
                cs.Expected_Close_Date_Zone__c=system.today()+4;
            }
            if(i==1){
                cs.Expected_Close_Date_Zone__c=system.today()+4;
            }
            if(i==2){               
                cs.Expected_Close_Date_Investigation_Tech__c=system.today()+3;
            }
            if(i==3){
                cs.Expected_Close_Date_HFS__c=system.today()+2;
            }
            if(i==4){
                cs.Expected_Close_Date_Repair_at_HCI__c = system.today()-15;
            }
            if(i==5){
                cs.Expected_Close_Date_DCD__c = system.today()-14;
            }
            if(i==6){
                cs.Expected_Close_Date_Customer_Relations__c = system.today()-13;
            }
            if(i==7){
                cs.Expected_Close_Date_Inspection_FE__c = system.today()-12;
            }
            if(i==8){
                cs.Expected_Close_Date_Countermeasure_Part__c = system.today()-11;
            }
            if(i==9){
                cs.Expected_Close_Date_Inspection_QE__c = system.today()-10;
            }
            if(i==10){
                cs.Expected_Close_Date_Countermeasure_Softw__c = system.today()-9;
            }
            if(i==11){
                cs.Expected_Close_Date_Investigation_Factor__c = system.today()-8;
            }
            if(i==12){
                cs.Expected_Close_Date_Investigation_Dealer__c = system.today()-7;
            }
            if(i==13){
                cs.Expected_Close_Date_Investigation_Dealer__c = system.today()-7;
                cs.Expected_Close_Date_Investigation_Factor__c = system.today()-8;
                cs.Expected_Close_Date_Countermeasure_Softw__c = system.today()-9;
                cs.Expected_Close_Date_Inspection_QE__c = system.today()-10;
                cs.Expected_Close_Date_Countermeasure_Part__c = system.today()-11;
                cs.Expected_Close_Date_Inspection_FE__c = system.today()-12;
                cs.Expected_Close_Date_Customer_Relations__c = system.today()-13;
                cs.Expected_Close_Date_DCD__c = system.today()-14;
                cs.Expected_Close_Date_Repair_at_HCI__c = system.today()-15;
                cs.Expected_Close_Date_HFS__c=system.today()-16;
                cs.Expected_Close_Date_Investigation_Tech__c=system.today()-17;
                cs.Expected_Close_Date_Zone__c=system.today()-18;
            }
            i++;
        }
        test.startTest();
            insert lstCase;
            integer j = 0;
        for(case cs : lstCase){
            if(j==0){
                cs.Expected_Close_Date_Investigation_Dealer__c = system.today()-9;
                cs.Expected_Close_Date_Investigation_Factor__c = system.today()-6;
                cs.Expected_Close_Date_Countermeasure_Softw__c = system.today()-5;
                cs.Expected_Close_Date_Inspection_QE__c = system.today()-4;
                cs.Expected_Close_Date_Countermeasure_Part__c = system.today()-3;
                cs.Expected_Close_Date_Inspection_FE__c = system.today()-2;
                cs.Expected_Close_Date_Customer_Relations__c = system.today()-1;
                cs.Expected_Close_Date_DCD__c = system.today();
                cs.Expected_Close_Date_Repair_at_HCI__c = system.today()+1;
                cs.Expected_Close_Date_HFS__c=system.today()+2;
                cs.Expected_Close_Date_Investigation_Tech__c=system.today()+3;
                cs.Expected_Close_Date_Zone__c=system.today()+4;
            }
            else{
                cs.Expected_Close_Date_Investigation_Dealer__c = system.today()-5;
                cs.Expected_Close_Date_Investigation_Factor__c = system.today()-8;
                cs.Expected_Close_Date_Countermeasure_Softw__c = system.today()-9;
                cs.Expected_Close_Date_Inspection_QE__c = system.today()-10;
                cs.Expected_Close_Date_Countermeasure_Part__c = system.today()-11;
                cs.Expected_Close_Date_Inspection_FE__c = system.today()-12;
                cs.Expected_Close_Date_Customer_Relations__c = system.today()-13;
                cs.Expected_Close_Date_DCD__c = system.today()-14;
                cs.Expected_Close_Date_Repair_at_HCI__c = system.today()-15;
                cs.Expected_Close_Date_HFS__c=system.today()-16;
                cs.Expected_Close_Date_Investigation_Tech__c=system.today()-17;
                cs.Expected_Close_Date_Zone__c=system.today()-18;
            }
            j++;
        }
        update lstCase;
        system.assertNotEquals(lstCase.size(),null);
        test.stopTest();
    }
}