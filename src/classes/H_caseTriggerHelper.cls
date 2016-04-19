/**
*      @author       : Piyush Rathor(Deloitte)
*      @date         : 10/09/2015
    @description  : Helper class for H_caseTrigger Apex Trigger
        Modification Log:
        ------------------------------------------------------------------------------------------
            Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
        Piyush (Deloitte)                           09/09/2015           Original Version
        Piyush (Deloitte)                           14/10/2015           Modified based on Defect
        Piyush (Deloitte)                           23/10/2015           Changes for US-0530
        Piyush (Deloitte)                           16/12/2015           Changes for US-0530
        
*/
public with sharing class H_caseTriggerHelper{    
    public static void updateRelatedAccount(list<case>lstCase,map<Id,case>mapOldCase){
        map<Id,set<Id>>mapContactIdCaseId = new map<Id,set<Id>>();
        for(case caseRecord : lstCase){
            //Check if the related contact name is blank
            if(caseRecord.Related_Contact_Name__c != null){
                if(mapOldCase == null){
                    //populate a map of contact Id and set of related case Id when record is inserted
                    if(caseRecord.Related_Account_Name__c == null){
                        if(mapContactIdCaseId.containsKey(caseRecord.Related_Contact_Name__c)){
                            set<Id>setCaseId = mapContactIdCaseId.get(caseRecord.Related_Contact_Name__c);
                            setCaseId.add(caseRecord.Id);
                            mapContactIdCaseId.put(caseRecord.Related_Contact_Name__c,setCaseId);
                        }
                        else{
                            mapContactIdCaseId.put(caseRecord.Related_Contact_Name__c,new set<Id>{caseRecord.Id});
                        }
                    }
                }
                else{
                    //populate a map of contact Id and set of related case Id when record is updated
                    if(caseRecord.Related_Contact_Name__c != null && mapOldCase.get(caseRecord.Id).Related_Contact_Name__c != caseRecord.Related_Contact_Name__c){
                        if(mapContactIdCaseId.containsKey(caseRecord.Related_Contact_Name__c)){
                            set<Id>setCaseId = mapContactIdCaseId.get(caseRecord.Related_Contact_Name__c);
                            setCaseId.add(caseRecord.Id);
                            mapContactIdCaseId.put(caseRecord.Related_Contact_Name__c,setCaseId);
                        }
                        else{
                            mapContactIdCaseId.put(caseRecord.Related_Contact_Name__c,new set<Id>{caseRecord.Id});
                        }
                    }
                }
            }
            
        }
        map<Id,Id>mapCaseAccount = new map<Id,Id>();
        if(!mapContactIdCaseId.isEmpty()){
            //Get list of contact related to case 
            list<contact>lstContact = [select id,accountId from contact where Id IN : mapContactIdCaseId.keyset()];
            if(!lstContact.isEmpty()){
                for(contact con : lstContact){
                    if(mapContactIdCaseId.containsKey(con.Id)){
                        for(Id caseId : mapContactIdCaseId.get(con.Id)){
                            mapCaseAccount.put(caseId,con.accountId);
                        }
                    }
                }
            }
            //update the related account based on the contact account
            if(!mapCaseAccount.isEmpty()){
                for(case caseRec : lstCase){
                    caseRec.Related_Account_Name__c = mapCaseAccount.get(caseRec.Id);
                }
            }
        }
    }
    public static void populateVin(list<case>lstCase,map<Id,case>mapOldCase){
        set<string>setCustRole = new set<string>();
        for(case caseRecord : lstCase){
            if(caseRecord.VIN_Serial_No__c != null){
                if(mapOldCase == null){
                    setCustRole.add(caseRecord.VIN_Serial_No__c);
                }
                else{
                    setCustRole.add(caseRecord.VIN_Serial_No__c);
                }
            }
            /*else{
                caseRecord.VIN_Serial_No_Direct__c = null;
            }*/
        }
        map<string,string>mapCustRoleVin = new map<string,string>();
        if(!setCustRole.isEmpty()){
            list<Customer_Role__c>lstCustRole = [select id,VIN__c from Customer_Role__c where ID IN : setCustRole];
            for(Customer_Role__c custRole : lstCustRole){
                mapCustRoleVin.put(custRole.Id,custRole.VIN__c);
            }
            if(!mapCustRoleVin.isEmpty()){
                for(case cs : lstCase){
                    if(mapCustRoleVin.containsKey(cs.VIN_Serial_No__c))
                    cs.VIN_Serial_No_Direct__c = mapCustRoleVin.get(cs.VIN_Serial_No__c);
                }
            }
        }
    }
    public static void updateLatestDate(list<case>lstCase,map<Id,case>mapOldCase){
        for(case cs : lstCase){
            if(mapOldCase == null || (mapOldCase != null && mapOldCase.get(cs.Id).Expected_Close_Date_Investigation_Dealer__c != cs.Expected_Close_Date_Investigation_Dealer__c || mapOldCase.get(cs.Id).Expected_Close_Date_Investigation_Factor__c != cs.Expected_Close_Date_Investigation_Factor__c || mapOldCase.get(cs.Id).Expected_Close_Date_Countermeasure_Softw__c != cs.Expected_Close_Date_Countermeasure_Softw__c || mapOldCase.get(cs.Id).Expected_Close_Date_Inspection_QE__c != cs.Expected_Close_Date_Inspection_QE__c || mapOldCase.get(cs.Id).Expected_Close_Date_Countermeasure_Part__c != cs.Expected_Close_Date_Countermeasure_Part__c || mapOldCase.get(cs.Id).Expected_Close_Date_Inspection_FE__c != cs.Expected_Close_Date_Inspection_FE__c || mapOldCase.get(cs.Id).Expected_Close_Date_Customer_Relations__c != cs.Expected_Close_Date_Customer_Relations__c || mapOldCase.get(cs.Id).Expected_Close_Date_DCD__c != cs.Expected_Close_Date_DCD__c || mapOldCase.get(cs.Id).Expected_Close_Date_Repair_at_HCI__c != cs.Expected_Close_Date_Repair_at_HCI__c || mapOldCase.get(cs.Id).Expected_Close_Date_HFS__c != cs.Expected_Close_Date_HFS__c || mapOldCase.get(cs.Id).Expected_Close_Date_Investigation_Tech__c != cs.Expected_Close_Date_Investigation_Tech__c || mapOldCase.get(cs.Id).Expected_Close_Date_Zone__c != cs.Expected_Close_Date_Zone__c || mapOldCase.get(cs.Id).Actual_Close_Date_Investigation_Dealer__c != cs.Actual_Close_Date_Investigation_Dealer__c || mapOldCase.get(cs.Id).Actual_Close_Date_Investigation_Factor__c != cs.Actual_Close_Date_Investigation_Factor__c || mapOldCase.get(cs.Id).Actual_Close_Date_Countermeasure_Softwar__c != cs.Actual_Close_Date_Countermeasure_Softwar__c || mapOldCase.get(cs.Id).Actual_Close_Date_Countermeasure_Part__c != cs.Actual_Close_Date_Countermeasure_Part__c || mapOldCase.get(cs.Id).Actual_Close_Date_Inspection_FE__c != cs.Actual_Close_Date_Inspection_FE__c || mapOldCase.get(cs.Id).Actual_Close_Date_Customer_Relations__c != cs.Actual_Close_Date_Customer_Relations__c || mapOldCase.get(cs.Id).Actual_Close_Date_DCD__c != cs.Actual_Close_Date_DCD__c || mapOldCase.get(cs.Id).Actual_Close_Date_Repair_at_HCI__c != cs.Actual_Close_Date_Repair_at_HCI__c || mapOldCase.get(cs.Id).Actual_Close_Date_HFS__c != cs.Actual_Close_Date_HFS__c || mapOldCase.get(cs.Id).Actual_Close_Date_Investigation_Tech__c != cs.Actual_Close_Date_Investigation_Tech__c || mapOldCase.get(cs.Id).Actual_Close_Date_Zone__c != cs.Actual_Close_Date_Zone__c)){
                date earliestdate;
                date latestDate;
                cs.Latest_Expected_Close_Date__c = null;
                cs.Earliest_Expected_Close_Date__c = null;

                if(cs.Actual_Close_Date_Investigation_Dealer__c == null && cs.Expected_Close_Date_Investigation_Dealer__c != null){
                    earliestdate = cs.Expected_Close_Date_Investigation_Dealer__c;
                    latestDate = cs.Expected_Close_Date_Investigation_Dealer__c;
                }   
                if(cs.Actual_Close_Date_Investigation_Factor__c == null && cs.Expected_Close_Date_Investigation_Factor__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Investigation_Factor__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Investigation_Factor__c){
                            earliestdate = cs.Expected_Close_Date_Investigation_Factor__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Investigation_Factor__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Investigation_Factor__c){
                            latestDate = cs.Expected_Close_Date_Investigation_Factor__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Countermeasure_Softwar__c == null && cs.Expected_Close_Date_Countermeasure_Softw__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Countermeasure_Softw__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Countermeasure_Softw__c){
                            earliestdate = cs.Expected_Close_Date_Countermeasure_Softw__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Countermeasure_Softw__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Countermeasure_Softw__c){
                            latestDate = cs.Expected_Close_Date_Countermeasure_Softw__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Inspection_QE__c == null && cs.Expected_Close_Date_Inspection_QE__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Inspection_QE__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Inspection_QE__c){
                            earliestdate = cs.Expected_Close_Date_Inspection_QE__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Inspection_QE__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Inspection_QE__c){
                            latestDate = cs.Expected_Close_Date_Inspection_QE__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Countermeasure_Part__c == null && cs.Expected_Close_Date_Countermeasure_Part__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Countermeasure_Part__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Countermeasure_Part__c){
                            earliestdate = cs.Expected_Close_Date_Countermeasure_Part__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Countermeasure_Part__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Countermeasure_Part__c){
                            latestDate = cs.Expected_Close_Date_Countermeasure_Part__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Inspection_FE__c == null && cs.Expected_Close_Date_Inspection_FE__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Inspection_FE__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Inspection_FE__c){
                            earliestdate = cs.Expected_Close_Date_Inspection_FE__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Inspection_FE__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Inspection_FE__c){
                            latestDate = cs.Expected_Close_Date_Inspection_FE__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Customer_Relations__c == null && cs.Expected_Close_Date_Customer_Relations__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Customer_Relations__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Customer_Relations__c){
                            earliestdate = cs.Expected_Close_Date_Customer_Relations__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Customer_Relations__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Customer_Relations__c){
                            latestDate = cs.Expected_Close_Date_Customer_Relations__c;
                        }
                    }
                }

                if(cs.Actual_Close_Date_DCD__c == null && cs.Expected_Close_Date_DCD__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_DCD__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_DCD__c){
                            earliestdate = cs.Expected_Close_Date_DCD__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_DCD__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_DCD__c){
                            latestDate = cs.Expected_Close_Date_DCD__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Repair_at_HCI__c == null && cs.Expected_Close_Date_Repair_at_HCI__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Repair_at_HCI__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Repair_at_HCI__c){
                            earliestdate = cs.Expected_Close_Date_Repair_at_HCI__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Repair_at_HCI__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Repair_at_HCI__c){
                            latestDate = cs.Expected_Close_Date_Repair_at_HCI__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_HFS__c == null && cs.Expected_Close_Date_HFS__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_HFS__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_HFS__c){
                            earliestdate = cs.Expected_Close_Date_HFS__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_HFS__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_HFS__c){
                            latestDate = cs.Expected_Close_Date_HFS__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Investigation_Tech__c == null && cs.Expected_Close_Date_Investigation_Tech__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Investigation_Tech__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Investigation_Tech__c){
                            earliestdate = cs.Expected_Close_Date_Investigation_Tech__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Investigation_Tech__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Investigation_Tech__c){
                            latestDate = cs.Expected_Close_Date_Investigation_Tech__c;
                        }
                    }
                }
                if(cs.Actual_Close_Date_Zone__c == null && cs.Expected_Close_Date_Zone__c != null){
                    if(earliestdate == null){
                        earliestdate = cs.Expected_Close_Date_Zone__c;
                    }
                    else{
                        if(earliestdate > cs.Expected_Close_Date_Zone__c){
                            earliestdate = cs.Expected_Close_Date_Zone__c;
                        }
                    }
                    if(latestDate == null){
                        latestDate = cs.Expected_Close_Date_Zone__c;
                    }
                    else{
                        if(latestDate < cs.Expected_Close_Date_Zone__c){
                            latestDate = cs.Expected_Close_Date_Zone__c;
                        }
                    }
                }
                if(latestDate != null)
                cs.Latest_Expected_Close_Date__c = latestDate;
                if(earliestdate != null)
                cs.Earliest_Expected_Close_Date__c = earliestdate;
            }
        }
    }
}