/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 22/06/2015
        @description  : For parsing XML and inserting info
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              22/06/2015           Original Version
                Piyush (Deloitte)                              12/08/2015           Modified changes for object name change
*/
@RestResource(urlMapping='/ContactMapping/*')  
global without sharing class H_Customer_WS2{  
    
    public static Map<String,List<Address__c>> Map_UCID_AddressList;
    public static Map<String,List<ContactMethod__c>> Map_UCID_ConMethodList;
    public static Map<String,Account> Map_UCID_Account;
    public static Map<String,List<Customer_Role__c>> Map_UCID_CusRoleList;
    public static Map<String,List<Customer_Role__c>> Map_ProductSerialNum_CusRoleList;
   
    public static Map<String,Map<String,String>> Map_UCID_DealerCatType_Value;
    public static List<VIN__c> VINLst; 
    public static Set<String> productSerialNumSet = new Set<String>();
    public static Map<String,VIN__c> Map_productSerialNum_VIN = new Map<String,VIN__c>();
    public static Map<Id,String> Map_conId_UCID = new Map<Id,String>();
        
    public static List<sObject> clonedCasesObjects = new List<sObject>();
    public static List<sObject> clonedAlertObjects = new List<sObject>();
    public static List<sObject> clonedPinObjects = new List<sObject>();
       
    public static List<Contact> AsIscontactsToBeDeleted = new List<Contact>();
    
    public static String notificationType = '';
    public static String maintainNamespace = ''; 
    
    public static Set<String> Set_DealerAccountName = new Set<String>();
    public static Set<String> Set_AccountName = new Set<String>();
    
    public static String NotificationXMLContent = '';
    
    public static Boolean isTypeOrganaization = false;
    public static Boolean isBatchProcessing = false;
    public static String errorMessage = '';
    public static Map<String,String> Map_UCID_HHId = new Map<String,String>();
    
    public static Boolean isLogAllMDMNotifications = false;
    
    //HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
    @HttpPost  
    global static String doPost() { 
         
        System.Savepoint savePoint = DataBase.setSavepoint();
        
      try{
            //Returns the RestRequest object for our Apex REST method.  
            RestRequest request = RestContext.request;

            //Returns the RestResponse for our Apex REST method.  
            RestResponse response = RestContext.response;  

            NotificationXMLContent = request.requestBody.toString().trim(); 
            
            String message = parseXMLFile(NotificationXMLContent);
            return message;
                 
      }
      catch(Exception e){
         DataBase.rollback(savePoint);
         if(!isBatchProcessing)
         H_Logger.log('Error - '+e.getMessage() ,'ERROR','statusCode','Webservice (MDM) - Inbound',NotificationXMLContent,null,null,false);          
         return e.getMessage();
      }
     
    }
    //HttpPost method is used to capture a HttpPost request has been sent to our rest apex class.  
   
    public static String parseXMLFile(String XMLFile) { 
         
        System.Savepoint savePoint = DataBase.setSavepoint();
        
      try{
            String ContactId = '';
            if(String.isNotBlank(XMLFile)){
                
                NotificationXMLContent = XMLFile; 
                
                Set<String> ucidSet = new Set<String>();
                Set<String> contactObjIdSet = new Set<String>();
                
                //Check if checkbox is true for Current User
               isLogAllMDMNotifications =  checkUserLogPermission();
              
                //Get notification Type
                notificationType = parseXMLNotificationType(NotificationXMLContent);
                
                // Get TCRMPersonBObj from AsIsBObj to iterate
                List<Dom.XMLNode> personObjectLst = parseXMLPersonBObj('AsIsBObj',NotificationXMLContent,new List<Contact>(),new Set<String>(),new Set<String>()); 
                                   
                // iterate on list of TCRMPersonBObj nodes to process
                if(personObjectLst != null && !personObjectLst.isEmpty()){
                    
                    for(Dom.XMLNode personObject : personObjectLst ){
                        // Pass node to get list of sObject
                    H_ParsingUtility.mapObjectFields(personObject);
                        // clear sobject list for next node
                    H_ParsingUtility.lstSobject.clear();
                    H_ParsingUtility.sobjType_sObjMap = new Map<String,sObject>();
                        
                    ucidSet.addAll(H_ParsingUtility.UCIDSet);
                    H_ParsingUtility.UCIDSet.clear();
                        
                    contactObjIdSet.addAll(H_ParsingUtility.contactIdSet);
                    H_ParsingUtility.contactIdSet.clear();
    
                    if(H_ParsingUtility.isErrorLog){
                            break;
                        }
                    }
                    
                    //Process only if no error has been log
                if(!H_ParsingUtility.isErrorLog){
                	
                	   // Get list of contacts to be deleted under AsIsBObj node
                	   if(ucidSet != null && !ucidSet.isEmpty()){
                        AsIscontactsToBeDeleted = getContactsToBeDeleted(ucidSet);
                	   }
                       
                       //Get list of sObjects to be associated in case of collapse
                        if(notificationType.equalsIgnoreCase(H_Constants.CollapseParty_Transaction_type) && AsIscontactsToBeDeleted != null && !AsIscontactsToBeDeleted.isEmpty()){
                          
                          List<Case> CaseObjectListToBeAssociated = getCasesLst(ucidSet);
                          List<Alert__c> AlertObjectListToBeAssociated = getAlertLst(ucidSet);
                          
                          List<PIN__c> PinObjectListToBeAssociated = getPinLst(AsIscontactsToBeDeleted);
                          
                          //using  schema object definitions to clone Salesforce object including all field values
                          List<sObject> originalSObjects = new List<sObject>();
                          //Cloning Case Object
                          originalSObjects.addAll((List<sObject>)(CaseObjectListToBeAssociated));
                            clonedCasesObjects = cloneObjects(
                                                          originalSobjects,
                                                          Case.sObjectType);
                           //Cloning Alert Object                               
                            originalSObjects.clear();                               
                            originalSObjects.addAll((List<sObject>)(AlertObjectListToBeAssociated));
                             clonedAlertObjects = cloneObjects(
                                                          originalSobjects,
                                                          Alert__c.sObjectType);
                            //Cloning PIN Object                                 
                            originalSObjects.clear();                               
                            originalSObjects.addAll((List<sObject>)(PinObjectListToBeAssociated));
                             clonedPinObjects = cloneObjects(
                                                          originalSobjects,
                                                          PIN__c.sObjectType);
                                                   
                            // delete existing cases 
                            Database.DeleteResult[] deleteResult_Case;
                            Database.DeleteResult[] deleteResult_Alert;
                            Database.DeleteResult[] deleteResult_Share;
                            Database.DeleteResult[] deleteResult_Pin;
                            Database.EmptyRecycleBinResult[] emptyRecycleResult;
                            
                            deleteResult_Case = H_DBFunctions.doDelete(CaseObjectListToBeAssociated,'createSobjectRecords','delete',true);
                            if(!isBatchProcessing)
                            H_Logger.error(deleteResult_Case, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Case',ContactId);   
                            else
                            {
                                String msg = H_Logger.getDMLErrorMsg(deleteResult_Case);
                                if(!String.isBlank(msg)){
                                    if(String.isNotBlank(errorMessage))errorMessage +=';';
                                    errorMessage += msg;
                                }
                                
                            }  
                            if(CaseObjectListToBeAssociated != null && !CaseObjectListToBeAssociated.isEmpty())
                            emptyRecycleResult = Database.emptyRecycleBin(CaseObjectListToBeAssociated);
            				 
                            // delete existing alert 
                            deleteResult_Alert = H_DBFunctions.doDelete(AlertObjectListToBeAssociated,'createSobjectRecords','delete',true);
                             if(!isBatchProcessing)
                             H_Logger.error(deleteResult_Alert, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Alert',ContactId); 
                              else
                                {
                                    String msg = H_Logger.getDMLErrorMsg(deleteResult_Alert);
                                    if(!String.isBlank(msg)){
                                         if(String.isNotBlank(errorMessage))errorMessage +=';';
                                         errorMessage += msg;
                                    }
                                } 
                                
                            if(AlertObjectListToBeAssociated != null && !AlertObjectListToBeAssociated.isEmpty())
                            emptyRecycleResult = Database.emptyRecycleBin(AlertObjectListToBeAssociated);
            				
            				
            				
            				//delete existing Pin
            				deleteResult_Pin = H_DBFunctions.doDelete(PinObjectListToBeAssociated,'createSobjectRecords','delete',true);
                            if(!isBatchProcessing)
                            H_Logger.error(deleteResult_Pin, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Pin',ContactId);   
                            else
                            {
                                String msg = H_Logger.getDMLErrorMsg(deleteResult_Pin);
                                if(!String.isBlank(msg)){
                                    if(String.isNotBlank(errorMessage))errorMessage +=';';
                                    errorMessage += msg;
                                }
                                
                            }  
                            if(PinObjectListToBeAssociated != null && !PinObjectListToBeAssociated.isEmpty())
                            emptyRecycleResult = Database.emptyRecycleBin(PinObjectListToBeAssociated);
                        }
                    } 
                }
               
                // Get TCRMPersonBObj from ToBeBobj to iterate
                Map_UCID_AddressList = new Map<String,List<Address__c>>(); 
                Map_UCID_ConMethodList = new Map<String,List<ContactMethod__c>>();
                Map_UCID_Account = new Map<String,Account>();
                Map_UCID_CusRoleList = new Map<String,List<Customer_Role__c>>(); 
                Map_ProductSerialNum_CusRoleList = new Map<String,List<Customer_Role__c>>();  
                
                Map_UCID_DealerCatType_Value = new  Map<String,Map<String,String>>();
                
                VINLst = new List<VIN__c>();
                
                contactObjIdSet.clear();
                ucidSet.clear();
                
                
                // Pass ToBeBObj nodes and insert object records
            if(!H_ParsingUtility.isErrorLog){
                    ContactId = getContactsToBeUpserted(NotificationXMLContent,ucidSet,contactObjIdSet);
                }
             }
             // Return contact Id
            if(String.isNotBlank(ContactId)){
                if(!isBatchProcessing && isLogAllMDMNotifications) 
                H_Logger.log('Successfully Inserted','DEBUG','H_Customer_WS2 : Contact','Webservice (MDM) - Inbound',NotificationXMLContent,'Contact',ContactId,true);
                       
                return ContactId;  
            }
            else{
                if(isBatchProcessing && String.isNotBlank(errorMessage))
                  return errorMessage;
                else
                return 'Contact not inserted successfully';
            } 
       }
      catch(Exception e){
         DataBase.rollback(savePoint);
         
         if(!isBatchProcessing)
         H_Logger.log('Error - '+e.getMessage() ,'ERROR','statusCode','Webservice (MDM) - Inbound',NotificationXMLContent,null,null,false);          
         return e.getMessage();
      }

    }
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      For parsing through the available services
    *  @param            xmlContent
    *                    
    *  @return           String
    */
    public static String parseXMLNotificationType(String xmlContent){
        String transactionType = '';
        Dom.Document doc = new Dom.Document();
        doc.load(xmlContent);
        //retrieve the root element for this xml
        Dom.XMLNode tcrmNotification = doc.getRootElement();

        for(Dom.XMLNode child : tcrmNotification.getChildElements()){
            if (child.getname() == 'NotificationHeader') {
                for (Dom.XmlNode subChild : child.getChildren()){
                    if (subChild.getname()== 'NotificationType' ){
                        transactionType = subChild.getText();
                    }
                }
            }
        }
        return transactionType;
    }
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      For parsing through the available services
    *  @param            xmlContent,notificationtype
    *                    
    *  @return           Dom.XMLNode
    */
    public static List<Dom.XMLNode> parseXMLPersonBObj(String type,String xmlContent,List<Contact> contactsToBeInserted,Set<String> ucidSet,Set<String> contactObjIdSet){
        Dom.Document domDoc = new Dom.Document();
        domDoc.load(xmlContent);
        Dom.XMLNode tcrmNotification = domDoc.getRootElement();
       
        List<Dom.XMLNode> personBObjLst = new List<Dom.XMLNode>();

        for(Dom.XMLNode tcrmNotify : tcrmNotification.getChildElements()){
            if (tcrmNotify.getname() == 'NotificationBody') {
                for (Dom.XmlNode maintainNotiObj : tcrmNotify.getChildren()){
                    
                    if(maintainNotiObj.getname() != null && maintainNotiObj.getname().startsWith('MaintainNotificationBObj')){
                        maintainNamespace = maintainNotiObj.getNamespace();
                        if(String.isBlank(maintainNamespace)){
                            maintainNamespace = null;
                        }
                        //Iterating on XML 
                        for(Dom.XMLNode BObj : maintainNotiObj.getChildren()){ 
                           
                            if(BObj.getname() != null && BObj.getname() == type){
                              
                                for (Dom.XmlNode tobeObj : BObj.getChildren()){
                                 
                                    if(tobeObj.getname() != null && tobeObj.getname() == 'XHondaPartyBObj'){
                                        
                                        List<Dom.XMLNode> tempPersonBObjLst = new List<Dom.XMLNode>();
                                        for (Dom.XmlNode personObj : tobeObj.getChildren()){
                                           //Get complete TCRMPersonBObj parent node from XML
                                           if(personObj.getname() == 'TCRMPersonBObj'){
                                               tempPersonBObjLst.add(personObj);
                                            }
                                            //Get complete TCRMOrganizationBObj parent node from XML
                                            else if(personObj.getname() == 'TCRMOrganizationBObj'){
                                               tempPersonBObjLst.add(personObj);
                                               isTypeOrganaization = true;
                                            }
                                            //Get complete TCRMPartyGroupingBObj parent node from XML
                                            else if(personObj.getname() == 'TCRMPartyGroupingBObj'){
                                               tempPersonBObjLst.add(personObj);
                                            }
                                            //Get complete XPartyProductRoleBObj parent node from XML
                                            else if(personObj.getname() == 'XPartyProductRoleBObj'){
                                               tempPersonBObjLst.add(personObj);
                                            }
                                            //Get complete XPartyDealerPreferenceBObj parent node from XML
                                            else if(personObj.getname() == 'XPartyDealerPreferenceBObj'){
                                               tempPersonBObjLst.add(personObj);
                                            }
                                        }
                                        if(type.equalsIgnoreCase('ToBeBObj')){
                                            contactsToBeInserted.addAll(parseXMLNodesLst(tempPersonBObjLst,ucidSet,contactObjIdSet));
                                        }
                                        personBObjLst.addAll(tempPersonBObjLst);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return personBObjLst;
   }

   
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      For deleting contact records
    *  @param            UCID set, objectAPI
    *                    
    *  @return           none
    */
    public static List<Contact> getContactsToBeDeleted(Set<String> ucidSet){

        //Query to get list of contact records related to UCID 
        List<Contact> contactObjList = [Select Id,UCID__c,AccountId from Contact where UCID__c in: ucidSet];
        return contactObjList;
    }

    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      Dynamic Query for deleting sobjects records
    *  @param            UCID set, objectAPI
    *                    
    *  @return           none
    */
    public static void deleteRec(Set<String> UCIDSet, String objectApi){
        String objApi = String.escapeSingleQuotes(objectApi);
        String deleteQuery = 'Select Id' +
        ' from '+objApi+
        ' where Contact__r.UCID__c =: UCIDSet'+
        ' or Contact__r.Id =: UCIDSet';
       
        List<sObject> sobjList = DataBase.query(deleteQuery); 
        
        if(sobjList != null && !sobjList.isEmpty()){
            // delete 
            Database.DeleteResult[] deleteResult;
            deleteResult = H_DBFunctions.doDelete(sobjList,'createSobjectRecords','delete',true);  
            if(!isBatchProcessing)
            H_Logger.error(deleteResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,objectApi,'');
            else{
                String msg = H_Logger.getDMLErrorMsg(deleteResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=',';
                     errorMessage += msg;
                }
            }
            
            Database.EmptyRecycleBinResult[] emptyResult = Database.emptyRecycleBin(sobjList);
            
          }
    }
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      For parsing through ToBeBObj node
    *  @param            xmlContent,UCID set
    *                    
    *  @return           ContactId
    */
    public static String getContactsToBeUpserted(String xmlContent,Set<String> ucidSet,Set<String> contactObjIdSet){

        String tempContactId = '';
        List<Contact> contactsToBeInserted = new List<Contact>();
        
        // Get TCRMPersonBObj from ToBeBObj to iterate   
        List<Dom.XMLNode> personObjectLst = parseXMLPersonBObj('ToBeBObj',xmlContent,contactsToBeInserted,ucidSet,contactObjIdSet);
        
        // iterate on TCRMPartyGroupingBObj xml nodes
        tempContactId = createSobjectRecords(contactsToBeInserted,ucidSet,contactObjIdSet); 
        return tempContactId;
    }
   /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To parse list of xml nodes and return list of sObjects to be inserted
    *  @param            list of xmlNodes
    *                    
    *  @return           Contact list
    */
    public static List<Contact> parseXMLNodesLst(List<Dom.XMLNode> nodeListToBeParsed,Set<String> ucidSet,Set<String> contactObjIdSet){

        List<Contact> contactsToBeProcessed = new List<Contact>();
        List<RecordType>  Account_Rectypelist = new List<RecordType>();
        List<RecordType>  Contact_Rectypelist = new List<RecordType>(); 
        
        H_ParsingUtility.Map_DealerCatType_DealerCode = new Map<String,String>();
        // Call mapObjectFields method to return list of sobject 
        if(nodeListToBeParsed != null && !nodeListToBeParsed.isEmpty()){
            Account_Rectypelist = setObjRecordType('HouseHold','Account');
            Contact_Rectypelist = setObjRecordType('Customer','Contact');
            
            // iterate on xml nodes
            for(Dom.XMLNode nodeObject : nodeListToBeParsed ){
                
                H_ParsingUtility.isToBeBObj = true;
                H_ParsingUtility.isProcess = true;
                H_ParsingUtility.DealerEffEndate = null;
                
                // call utility method to parse xml node and return list of sObject
                H_ParsingUtility.mapObjectFields(nodeObject);
                
                contactObjIdSet.addAll(H_ParsingUtility.contactIdSet);
                ucidSet.addAll(H_ParsingUtility.UCIDSet); 
                
                H_ParsingUtility.contactIdSet.clear();
                H_ParsingUtility.UCIDSet.clear(); 
                
                         
                //iterate on list of sObject returned after parsing 
                if(H_ParsingUtility.lstSobject != null && !H_ParsingUtility.lstSobject.isEmpty()){
                    List<sObject> lstSobjectToBeIterated = H_ParsingUtility.lstSobject;
                 
                    //To add sObject that are not not added in list
                    for(String objType : H_ParsingUtility.sobjType_sObjMap.keySet()){
                        if(!H_ParsingUtility.objectToBeAdded.contains(objType)){
                            lstSobjectToBeIterated.add(H_ParsingUtility.sobjType_sObjMap.get(objType));
                        }
                    }
                  
                    //iterate on list of sobjects
                    if(lstSobjectToBeIterated != null && !lstSobjectToBeIterated.isEmpty()){
                        Contact  newConObj = new Contact();
                        List<Address__c> addressLst = new List<Address__c>();
                        List<ContactMethod__c> conMethodLst = new List<ContactMethod__c>();
                        List<Customer_Role__c> cusRoleLst = new List<Customer_Role__c>();
                        
                        Account newAccObj; 
                        VIN__c TempVINObj;
                        
                        for(sObject tempsObj : lstSobjectToBeIterated){
                            SObjectType sObjectType = tempsObj.getSobjectType();
                            if(sObjectType == Contact.sObjectType){
                                newConObj =(Contact)tempsObj;
                                newConObj.Split_UCID__c = null;
                                newConObj.Collapsed_UCIDs__c = null;
                                //set record type id in contact 
                                if(Contact_Rectypelist != null && Contact_Rectypelist.size()== 1)
                                newConObj.recordtypeid = Contact_Rectypelist[0].Id;
                                
                                //set previous UCID in contact 
                                //For Collapse
                                if(notificationType.equalsIgnoreCase(H_Constants.CollapseParty_Transaction_type)){
                                    if(H_ParsingUtility.previousUCIDs.length() > 255)
                                         newConObj.Collapsed_UCIDs__c = H_ParsingUtility.previousUCIDs.substring(0,255); 
                                    else
                                         newConObj.Collapsed_UCIDs__c = H_ParsingUtility.previousUCIDs;
                                    
                                    newConObj.Split_UCID__c = null;
                                }
                                //For Split
                                if(notificationType.equalsIgnoreCase(H_Constants.SplitParty_Notification_type)){
                                     
                                    if(H_ParsingUtility.previousUCIDs.length() > 255)
                                         newConObj.Split_UCID__c = H_ParsingUtility.previousUCIDs.substring(0,255); 
                                    else
                                         newConObj.Split_UCID__c = H_ParsingUtility.previousUCIDs;
                                    newConObj.Collapsed_UCIDs__c = null; 
                                }
                                
                                //set Last name in contact in case of organization
                                if(newConObj.OrganizationName__c != null){
                                    if(newConObj.OrganizationName__c.length() > 80)
                                         newConObj.LastName = newConObj.OrganizationName__c.substring(0,80); 
                                    else
                                         newConObj.LastName = newConObj.OrganizationName__c;
                                }
                                
                                contactsToBeProcessed.add(newConObj);
                                
                            }
                            if(sObjectType == Address__c.sObjectType){
                             addressLst.add((Address__c)tempsObj) ;
                            }
                            if(sObjectType == ContactMethod__c.sObjectType){
                             conMethodLst.add((ContactMethod__c)tempsObj) ;
                            }
                                                       
                            if(sObjectType == Account.sObjectType){
                              newAccObj = (Account)tempsObj ;
                              
                              //HouseHold Record type
                              if(Account_Rectypelist != null && !Account_Rectypelist.isEmpty())
                                newAccObj.recordtypeid = Account_Rectypelist[0].Id;
                                
                                
                            }
                            if(sObjectType == VIN__c.sObjectType){
                            	
                                 TempVINObj = (VIN__c)tempsObj;
                                // To avoid duplicate VIN records on basis of serial number
                                if(TempVINObj.ProductSerialNumber__c != null && (Map_productSerialNum_VIN.isEmpty() || (Map_productSerialNum_VIN != null && !Map_productSerialNum_VIN.isEmpty() &&
                                    !Map_productSerialNum_VIN.containsKey(TempVINObj.ProductSerialNumber__c.touppercase())))){
                                       
                                        TempVINObj.isVINUpdated__c = true;
                                        Map_productSerialNum_VIN.put(TempVINObj.ProductSerialNumber__c.toUppercase(),TempVINObj);
                                        
                                }
                                 
                            } 
                            
                            if(sObjectType == Customer_Role__c.sObjectType){
                               Customer_Role__c cusRoleRecord = (Customer_Role__c)tempsObj;
                               cusRoleLst.add(cusRoleRecord) ;
                               
                               // iterate on VIN list 
                               if(TempVINObj.ProductSerialNumber__c != null && Map_ProductSerialNum_CusRoleList != null && !Map_ProductSerialNum_CusRoleList.isEmpty() && Map_ProductSerialNum_CusRoleList.containsKey(TempVINObj.ProductSerialNumber__c.toUppercase())){
                                    List<Customer_Role__c> tempCusRoleLst = Map_ProductSerialNum_CusRoleList.get(TempVINObj.ProductSerialNumber__c.toUppercase());
                                    tempCusRoleLst.add(cusRoleRecord);
                                    Map_ProductSerialNum_CusRoleList.put(TempVINObj.ProductSerialNumber__c.toUppercase(),tempCusRoleLst);
                               }
                               else{
                                    Map_ProductSerialNum_CusRoleList.put(TempVINObj.ProductSerialNumber__c.toUppercase(),new List<Customer_Role__c>{cusRoleRecord});
                               }
                               
                            }
                        }
                        
                        if(String.isNotBlank((String)newConObj.get('UCID__c'))){
    
                          // Map to store Contact UCID and related address list
                          if(addressLst != null && !addressLst.isEmpty())
                          Map_UCID_AddressList.put((String)newConObj.get('UCID__c'),addressLst);
                          
                          // Map to store Contact UCID and related contact method list
                          if(conMethodLst != null && !conMethodLst.isEmpty())
                          Map_UCID_ConMethodList.put((String)newConObj.get('UCID__c'),conMethodLst);
                          
                                                     
                        }
                        // Map to store Contact UCID and related group list
                        if(contactsToBeProcessed != null && !contactsToBeProcessed.isEmpty() && String.isNotBlank((String)contactsToBeProcessed[0].get('UCID__c'))){
                            
                            // Map to store contact UCID and related Account
                            if(newAccObj != null){
                             Map_UCID_Account.put((String)contactsToBeProcessed[0].get('UCID__c'),newAccObj);
                             Set_AccountName.add(newAccObj.Name);
                            }
                            
                            // Map to store Contact UCID and related customer role list
                            if(Map_UCID_CusRoleList != null && !Map_UCID_CusRoleList.isEmpty() && Map_UCID_CusRoleList.containsKey((String)contactsToBeProcessed[0].get('UCID__c'))){
                                List<Customer_Role__c> TempcusRoleLst = Map_UCID_CusRoleList.get((String)contactsToBeProcessed[0].get('UCID__c'));
                                TempcusRoleLst.addAll(cusRoleLst);
                                Map_UCID_CusRoleList.put((String)contactsToBeProcessed[0].get('UCID__c'),TempcusRoleLst);
                            }
                            else{
                                Map_UCID_CusRoleList.put((String)contactsToBeProcessed[0].get('UCID__c'),cusRoleLst);
                            }
                         }
                    }
                }
                
                //clear list and map for next node
                H_ParsingUtility.lstSobject.clear();
                H_ParsingUtility.objectToBeAdded.clear();
                H_ParsingUtility.sobjType_sObjMap = new Map<String,sObject>();
                
                
            }
        }
        if(H_ParsingUtility.Map_DealerCatType_DealerCode != null && !H_ParsingUtility.Map_DealerCatType_DealerCode.isEmpty()){
              Set_AccountName.addAll(H_ParsingUtility.Map_DealerCode_DealerValue.keySet());
              Map_UCID_DealerCatType_Value.put((String)contactsToBeProcessed[0].get('UCID__c'),H_ParsingUtility.Map_DealerCatType_DealerCode);
        }
           
        return contactsToBeProcessed; 
    }
     /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      For parsing through the available services
    *  @param            sObject List
    *                    
    *  @return           Contact
    */
    public static String createSobjectRecords(List<Contact> contactsToBeInserted,Set<String> ucidSet,Set<String> contactObjIdSet){
        // Object Instances
        String newContactId = '';
        List<Address__c> addressLstToBeInserted = new List<Address__c>();
        List<ContactMethod__c> conMethodToBeInserted = new List<ContactMethod__c>(); 
        List<Customer_Role__c> cusRoleLstToBeInserted = new List<Customer_Role__c>();
        List<Alert__c> alertToBeInserted = new List<Alert__c>();
        List<Case> casesToBeInserted = new List<Case>();
        List<PIN__c> pinToBeInserted = new List<PIN__c>();
        
        List<Account> dealerAccountToBeInserted = new List<Account>();
        
        Database.SaveResult[] insertResult;
        Database.UpsertResult[] ContactUpsertResult;
        Database.UpsertResult[] upsertResult;
        Database.UpsertResult[] AccUpsertResult;
        
        Map<String,Id> Map_UCID_accountId = new Map<String,Id>();
        Map_UCID_HHId = new Map<String,String>();
        List<Account> accountToBeInserted = new List<Account>();
        Map<String,Account> Map_AccName_AccountObj = new Map<String,Account>();
        List<User> APIUserRecordLst = new List<User>();
        
        
        // get account records
        if((ucidSet != null && !ucidSet.isEmpty() ) || (contactObjIdSet != null && !contactObjIdSet.isEmpty())){
           Map_UCID_accountId = getAccountId(ucidSet,contactObjIdSet);
           APIUserRecordLst = [Select Id from User where profile.Name = 'API - MDM - Real Time' and isActive = true];
        }
        
        // Get account with matching name
        if(!Set_AccountName.isEmpty())
        Map_AccName_AccountObj = getAccountRec(Set_AccountName);
                
        //upsert account record
        if(Map_UCID_Account != null && !Map_UCID_Account.isEmpty()){
            Set<Id> accountIdAlreadyAdded = new Set<Id>();
            Boolean isHHIDPresent = false;
            for(String UCID : Map_UCID_Account.keySet()){
                Account tempAccRec = Map_UCID_Account.get(UCID);
                if(Map_UCID_accountId != null && !Map_UCID_accountId.isEmpty() && Map_UCID_accountId.containsKey(UCID)){
                    tempAccRec.Id = Map_UCID_accountId.get(UCID);
                 }
                if(Map_AccName_AccountObj != null && !Map_AccName_AccountObj.isEmpty() && Map_AccName_AccountObj.containsKey(tempAccRec.name)){
                    tempAccRec.Id = Map_AccName_AccountObj.get(tempAccRec.name).Id;
                }
                
                if(Map_UCID_HHId != null && !Map_UCID_HHId.isEmpty() && Map_UCID_HHId.containsKey(UCID)){
                    tempAccRec.HH_Id__c = Map_UCID_HHId.get(UCID);
                    
                }
                if(Map_AccName_AccountObj != null && !Map_AccName_AccountObj.isEmpty() && Map_AccName_AccountObj.containsKey(tempAccRec.name)){
                    tempAccRec.HH_Id__c = Map_AccName_AccountObj.get(tempAccRec.name).HH_Id__c;
                }
                if(tempAccRec.HH_Id__c != null){
                    isHHIDPresent = true;
                }
                else { 
                    tempAccRec.HH_Id__c = tempAccRec.name;
                    isHHIDPresent = false;
                }
                if(accountIdAlreadyAdded.isEmpty() || !accountIdAlreadyAdded.contains(tempAccRec.Id)){ 
                        accountToBeInserted.add(tempAccRec);
                        accountIdAlreadyAdded.add(tempAccRec.Id);
                }
                
            }
          
           // upsert account record 
            if(isHHIDPresent) 
            AccUpsertResult = H_DBFunctions.doUpsert(accountToBeInserted,Account.Fields.HH_Id__c,'Account', 'createSobjectRecords', true); 
            else
            // upsert account record  
            AccUpsertResult = H_DBFunctions.doUpsert(accountToBeInserted,'createSobjectRecords','insert',true);
            
            if(!isBatchProcessing) 
            H_Logger.error(AccUpsertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Account',newContactId);
            else{
                String msg = H_Logger.getDMLErrorMsg(AccUpsertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }  
            
            //set account id in contact 
            for(Contact tempConObj : contactsToBeInserted){
                if(tempConObj.UCID__c != null && Map_UCID_Account.containsKey(tempConObj.UCID__c)){
                    Account accObj = Map_UCID_Account.get(tempConObj.UCID__c);
                    tempConObj.AccountId  = accObj.Id;
                }
                else if(tempConObj.Id != null && Map_UCID_Account.containsKey(tempConObj.Id)){
                    Account accObj = Map_UCID_Account.get(tempConObj.Id);
                    tempConObj.AccountId  = accObj.Id;
                }
            }
                
        }
               
        // Code to set related Dealer type
        if(Map_AccName_AccountObj != null && !Map_AccName_AccountObj.isEmpty()){
             for(Contact tempConObj : contactsToBeInserted){
                 // Set Dealer lookup fields as null 
                 tempConObj.Retail_Dealer__c = null;
                 tempConObj.Service_Dealer__c = null;
                 tempConObj.Finance_Dealer__c = null;
                 
                 if(tempConObj.UCID__c != null && Map_UCID_DealerCatType_Value != null && !Map_UCID_DealerCatType_Value.isEmpty() && Map_UCID_DealerCatType_Value.containsKey(tempConObj.UCID__c)){
                     // get related dealer category type and code map
                     Map<String,String> Map_DealerCatType_Code = Map_UCID_DealerCatType_Value.get(tempConObj.UCID__c);
                     if(Map_DealerCatType_Code != null && !Map_DealerCatType_Code.isEmpty()){
                            // iterate on each dealer cat type and get dealer value
                            for(String dealerCatType : Map_DealerCatType_Code.keySet()){
                                String DealerCode = Map_DealerCatType_Code.get(dealerCatType);
                                
                                // Check if there exist any matching Account
                                if(String.isNotBlank(DealerCode) && Map_AccName_AccountObj.containsKey(DealerCode)){
                                      Account DealerAccount = Map_AccName_AccountObj.get(DealerCode);
                                      
                                      //Populate related dealer lookup fields based on category type
                                      if(dealerCatType == '100001'){
                                        tempConObj.Retail_Dealer__c = DealerAccount.Id;
                                      }
                                      else if(dealerCatType == '100002'){
                                        tempConObj.Service_Dealer__c = DealerAccount.Id;
                                      } 
                                      else if(dealerCatType == '100003'){
                                        tempConObj.Finance_Dealer__c = DealerAccount.Id; 
                                      }
                                }
                            }
                      }
                 }
             }
        }
           
       if(!(notificationType.equalsIgnoreCase(H_Constants.CollapseParty_Transaction_type))&& contactObjIdSet != null && !contactObjIdSet.isEmpty()){
                 
           // upsert contact on basis of ID external field     
           ContactUpsertResult = H_DBFunctions.doUpsert(contactsToBeInserted,Contact.Fields.ID,'Contact', 'createSobjectRecords', true);  
           
           if(!isBatchProcessing)
           H_Logger.error(ContactUpsertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Contact',newContactId); 
           else{
                String msg = H_Logger.getDMLErrorMsg(ContactUpsertResult);
                 
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                     H_Logger.isContactFailed = true;
                }
            }
            
        }
        else if(ucidSet != null && !ucidSet.isEmpty()){
          //Code to set ToBeDeleted__c as true for AsIs Contact
          if(notificationType.equalsIgnoreCase(H_Constants.CollapseParty_Transaction_type) && AsIscontactsToBeDeleted != null && !AsIscontactsToBeDeleted.isEmpty()){
              
             for(Contact AsIsConObj : AsIscontactsToBeDeleted){
               if(AsIsConObj.UCID__c != null && !ucidSet.contains(AsIsConObj.UCID__c)){
	                AsIsConObj.ToBeDeleted__c = true;
	                
	                if(APIUserRecordLst != NULL && !APIUserRecordLst.isEmpty()){
	                    AsIsConObj.OwnerId = APIUserRecordLst[0].Id; 
	                }
	                
	                AsIsConObj.AccountId = null;                
                	contactsToBeInserted.add(AsIsConObj); 
              } 
            }
          }
           
          // upsert contact on basis of UCID external field 
            ContactUpsertResult = H_DBFunctions.doUpsert(contactsToBeInserted,Contact.Fields.UCID__c,'Contact', 'createSobjectRecords', true);  
            
            if(!isBatchProcessing){
             H_Logger.error(ContactUpsertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Contact',newContactId);
            }
            else{
                String msg = H_Logger.getDMLErrorMsg(ContactUpsertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                     H_Logger.isContactFailed = true;
                }
            }
            
        }
       
        if(!H_Logger.isContactFailed){
            
             
            //delete existing Address and Contact Method record if exist
            if(ucidSet != null && !ucidSet.isEmpty()){
                deleteRec(ucidSet, 'ContactMethod__c');
                deleteRec(ucidSet, 'Address__c');
                deleteRec(ucidSet, 'Customer_Role__c');
                
                
            }
            else if(contactObjIdSet != null && !contactObjIdSet.isEmpty()){
                deleteRec(contactObjIdSet, 'ContactMethod__c');
                deleteRec(contactObjIdSet, 'Address__c');
                deleteRec(contactObjIdSet, 'Customer_Role__c');  
                
            }
            List<ContactShare> ContachShareListToBeDeleted = getContactShareLst(AsIscontactsToBeDeleted);
            Database.DeleteResult[] deleteResult_Share = H_DBFunctions.doDelete(ContachShareListToBeDeleted,'createSobjectRecords','delete',true);
            
            if(!isBatchProcessing)
            H_Logger.error(deleteResult_Share, 'Webservice (MDM) - Inbound',NotificationXMLContent,'ContactShare',newContactId);   
            else
            {
                String msg = H_Logger.getDMLErrorMsg(deleteResult_Share);
                if(!String.isBlank(msg)){
                    if(String.isNotBlank(errorMessage))errorMessage +=';';
                    errorMessage += msg;
                }
                
            }  
            if(ContachShareListToBeDeleted != null && !ContachShareListToBeDeleted.isEmpty()) 
            Database.EmptyRecycleBinResult[] emptyShareRecycleResult = Database.emptyRecycleBin(ContachShareListToBeDeleted);
            
            // get sObject list to be inserted
            for(Contact tempConObj : contactsToBeInserted){
                if(tempConObj.Id != null && tempConObj.UCID__c != null && !tempConObj.ToBeDeleted__c){
                  
                    Map_conId_UCID.put(tempConObj.Id,tempConObj.UCID__c);
                     //populate contact id and UCID on Address
                    if(Map_UCID_AddressList != null && !Map_UCID_AddressList.isEmpty() && Map_UCID_AddressList.containsKey(tempConObj.UCID__c)){
                        List<Address__c> relatedAddressLst = Map_UCID_AddressList.get(tempConObj.UCID__c);
                        for(Integer i=0;i<relatedAddressLst.size();i++){
                            Address__c tempAddObj = relatedAddressLst[i];
                                tempAddObj.Contact__c = tempConObj.Id;
                                tempAddObj.UCID__c = tempConObj.UCID__c;
                                addressLstToBeInserted.add(tempAddObj);
                            
                        }
                    }
                    
                     // populate Contact id and UCID on Contact Method
                    if(Map_UCID_ConMethodList != null && !Map_UCID_ConMethodList.isEmpty() && Map_UCID_ConMethodList.containsKey(tempConObj.UCID__c)){
                        List<ContactMethod__c> relatedConMethodLst = Map_UCID_ConMethodList.get(tempConObj.UCID__c);
                        for(Integer i=0;i<relatedConMethodLst.size();i++){
                             ContactMethod__c tempconMethodObj = relatedConMethodLst[i];
                                tempconMethodObj.Contact__c = tempConObj.Id;
                                tempconMethodObj.UCID__c = tempConObj.UCID__c;
                                conMethodToBeInserted.add(tempconMethodObj);
                            
                        }
                    }
                   
                    //populate contact id and UCID on Customer Role
                    if(Map_UCID_CusRoleList != null && !Map_UCID_CusRoleList.isEmpty() && Map_UCID_CusRoleList.containsKey(tempConObj.UCID__c)){
                        List<Customer_Role__c> relatedCusRoleLst = Map_UCID_CusRoleList.get(tempConObj.UCID__c);
                        for(Customer_Role__c tempCusRoleObj : relatedCusRoleLst){
                            tempCusRoleObj.Contact__c = tempConObj.Id;
                        }
                    }
                    //populate contact id on cases
                    if(clonedCasesObjects != null && !clonedCasesObjects.isEmpty()){
                      for(sObject tempCaseObj : clonedCasesObjects){
                        SObjectType sObjectType = tempCaseObj.getSobjectType();
                         if(sObjectType == Case.sObjectType){
                          Case caseObj = (Case)tempCaseObj;
                          caseObj.ContactId = tempConObj.Id;
                          caseObj.AccountId = tempConObj.AccountId;
                          casesToBeInserted.add(caseObj);
                         }
                      }
                    }
                    //populate contact id on Alert
                    if(clonedAlertObjects != null && !clonedAlertObjects.isEmpty()){
                      for(sObject tempAlertObj : clonedAlertObjects){
                         SObjectType sObjectType = tempAlertObj.getSobjectType();
                        if(sObjectType == Alert__c.sObjectType){
                          Alert__c alertObj = (Alert__c)tempAlertObj;
                          alertObj.Contact__c = tempConObj.Id;
                          alertToBeInserted.add(alertObj);
                        }
                      }
                    }
                    //populate contact id on PIN
                    if(clonedPinObjects != null && !clonedPinObjects.isEmpty()){
                      for(sObject tempPinObj : clonedPinObjects){
                         SObjectType sObjectType = tempPinObj.getSobjectType();
                        if(sObjectType == PIN__c.sObjectType){
                          PIN__c PINObj = (PIN__c)tempPinObj;
                          PINObj.Customer__c = tempConObj.Id;
                          pinToBeInserted.add(PINObj);
                        }
                      }
                    }
                    
                                        
                }
            }    
            // Iterate over the upsert result and get successfully create Contact Id
            if(ContactUpsertResult != null && !ContactUpsertResult.isEmpty()){
                for(Integer i=0;i<ContactUpsertResult.size();i++){
                    if (ContactUpsertResult.get(i).isSuccess()){
                        
                       if(Map_conId_UCID != null && !Map_conId_UCID.isEmpty() && Map_conId_UCID.containsKey(ContactUpsertResult.get(i).getId())){
                          if(String.isNotBlank(newContactId))newContactId +=',';
                          newContactId += ContactUpsertResult.get(i).getId()+'-'+Map_conId_UCID.get(ContactUpsertResult.get(i).getId());
                       }
                    }
                }
            }
            
            // insert new Address record
            insertResult = H_DBFunctions.doInsert(addressLstToBeInserted,'createSobjectRecords','insert',true);  
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Address',newContactId);   
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
            
            // insert new Contact Method record
            insertResult = H_DBFunctions.doInsert(conMethodToBeInserted,'createSobjectRecords','insert',true);  
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'ContactMethod',newContactId);   
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
                   
            //insert new case record
            insertResult = H_DBFunctions.doInsert(casesToBeInserted,'createSobjectRecords','update',true);
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Case',newContactId);   
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
             
            //insert new Alert record
            insertResult = H_DBFunctions.doInsert(alertToBeInserted,'createSobjectRecords','update',true);
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Alert',newContactId);   
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
            
            //insert new PIN record
            insertResult = H_DBFunctions.doInsert(pinToBeInserted,'createSobjectRecords','update',true);
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'PIN',newContactId);   
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
                         
            List<VIN__c> LstVinToBeRemoved = new List<VIN__c>();
            //Remove existing VIN record from List
            if(Map_productSerialNum_VIN != null && !Map_productSerialNum_VIN.isEmpty()){
                LstVinToBeRemoved = [Select Id,ProductSerialNumber__c,isVINUpdated__c from VIN__c where ProductSerialNumber__c != null and ProductSerialNumber__c in: Map_productSerialNum_VIN.keySet() and isVINUpdated__c = true];
                
                if(LstVinToBeRemoved != null && !LstVinToBeRemoved.isEmpty()){
                    for(VIN__c tempVINObj : LstVinToBeRemoved){
                        if(tempVINObj.ProductSerialNumber__c != null && Map_productSerialNum_VIN.containsKey(tempVINObj.ProductSerialNumber__c.toUppercase())){
                            Map_productSerialNum_VIN.remove(tempVINObj.ProductSerialNumber__c.toUppercase());
                        }
                    }
                }
            }
            //Get new VIN List record 
            if(!Map_productSerialNum_VIN.isEmpty())
            VINLst = Map_productSerialNum_VIN.values(); 
           
            //upsert VIN on basis of Product serial number external field
            upsertResult = H_DBFunctions.doUpsert(VINLst,VIN__c.Fields.ProductSerialNumber__c,'VIN', 'createSobjectRecords', true);  
            if(!isBatchProcessing)
            H_Logger.error(upsertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'VIN',newContactId); 
            else{
                String msg = H_Logger.getDMLErrorMsg(upsertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
            
            if(LstVinToBeRemoved != null && !LstVinToBeRemoved.isEmpty()){
                VINLst.addAll(LstVinToBeRemoved);
            }  
            
            //iterate on product list
            for(VIN__c tempProd : VINLst){
                if(tempProd.Id != null && tempProd.ProductSerialNumber__c != null){
                    if(Map_ProductSerialNum_CusRoleList != null && !Map_ProductSerialNum_CusRoleList.isEmpty() && Map_ProductSerialNum_CusRoleList.containsKey(tempProd.ProductSerialNumber__c.toUppercase())){
                        List<Customer_Role__c> relatedCusRoleLst = Map_ProductSerialNum_CusRoleList.get(tempProd.ProductSerialNumber__c.toUppercase());
                        //populate VIN id on Customer Role
                        for(Customer_Role__c tempCusRoleObj : relatedCusRoleLst){
                           tempCusRoleObj.VIN__c = tempProd.Id;
                           if(tempCusRoleObj.Contact__c != null)
                           cusRoleLstToBeInserted.add(tempCusRoleObj);
                        }
                        
                    }
                }
            }
            
            // insert new Customer Role record
            insertResult = H_DBFunctions.doInsert(cusRoleLstToBeInserted,'createSobjectRecords','insert',true); 
            if(!isBatchProcessing)
            H_Logger.error(insertResult, 'Webservice (MDM) - Inbound',NotificationXMLContent,'Customer Role',newContactId); 
            else{
                String msg = H_Logger.getDMLErrorMsg(insertResult);
                if(!String.isBlank(msg)){
                     if(String.isNotBlank(errorMessage))errorMessage +=';';
                     errorMessage += msg;
                }
            }
        }           
        //return inserted contacts record Id
        return newContactId ;
    }
    
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To get account Id from contact record
    *  @param            Contact List
    *                    
    *  @return           Map
    */
    public static Map<String,Id> getAccountId(Set<String> UCIDSet,Set<String> contactObjIdSet){
        
        Map<String,Id> Map_UCID_accountId = new Map<String,Id>();
        
        List<Contact> contactLst = [Select Id,UCID__c,
                                           AccountId,
                                           Account.HH_Id__c 
                                    from Contact 
                                    where UCID__c = : UCIDSet 
                                    or Id =: contactObjIdSet];
        
        if(contactLst != null && !contactLst.isEmpty()){
            for(Contact tempCon : contactLst){
              if(UCIDSet != null && !UCIDSet.isEmpty()){
                  Map_UCID_accountId.put(tempCon.UCID__c,tempCon.AccountId);
                  if(tempCon.Account.HH_Id__c != null)
                  Map_UCID_HHId.put(tempCon.UCID__c,tempCon.Account.HH_Id__c);
              }
                else if(contactObjIdSet != null && !contactObjIdSet.isEmpty()){
                 Map_UCID_accountId.put(tempCon.Id,tempCon.AccountId); 
                 if(tempCon.Account.HH_Id__c != null) 
                 Map_UCID_HHId.put(tempCon.Id,tempCon.Account.HH_Id__c);
                }
            }
        }

        
        return Map_UCID_accountId;
    }
    public static List<Case> getCasesLst(Set<String> UCIDSet){
   
      return [Select Id,ContactId from Case where Contact.UCID__c =: UCIDSet]; 
        
    }
    public static List<Alert__c> getAlertLst(Set<String> UCIDSet){
   
      return [Select Id from Alert__c where Contact__r.UCID__c =: UCIDSet]; 
        
    }
    public static List<ContactShare> getContactShareLst(List<Contact> AsIsContactLst){
      
      return [Select Id from ContactShare where ContactId in: AsIsContactLst and RowCause != 'Owner' and RowCause !='Rule']; 
        
    }
     public static List<PIN__c> getPinLst(List<Contact> AsIsContactLst){
   
      return [Select Id,Customer__c,Customer__r.Id from PIN__c where Customer__r.Id in: AsIsContactLst]; 
        
    }
    // Clone a list of objects to a particular object type
  // Parameters 
  // - List<sObject> sObjects - the list of objects to be cloned 
  // - Schema.SobjectType objectType - the type of object to be cloned.
  // The sObjects you pass in must include the ID field, 
  // and the object must exist already in the database, 
  // otherwise the method will not work.
  public static List<sObject> cloneObjects(List<sObject> sObjects,
                                        Schema.SObjectType objectType){
    
    // A list of IDs representing the objects to clone
    List<Id> sObjectIds = new List<Id>{};
    // A list of fields for the sObject being cloned
    List<String> sObjectFields = new List<String>{};
    // A list of new cloned sObjects
    List<sObject> clonedSObjects = new List<sObject>{};
    
    // Get all the fields from the selected object type using 
    // the get describe method on the object type.
    if(objectType != null){
      sObjectFields.addAll(
        objectType.getDescribe().fields.getMap().keySet());
    }
    
    // If there are no objects sent into the method, 
    // then return an empty list
    if (sObjects != null && 
        !sObjects.isEmpty() && 
        !sObjectFields.isEmpty()){
    
      // Strip down the objects to just a list of Ids.
      for (sObject objectInstance: sObjects){
        sObjectIds.add(objectInstance.Id);
      }

      /* Using the list of sObject IDs and the object type, 
         we can construct a string based SOQL query 
         to retrieve the field values of all the objects.*/
    
      String allSObjectFieldsQuery = 'SELECT ' + sObjectFields.get(0); 
    
      for (Integer i=1 ; i < sObjectFields.size() ; i++){
        allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
      }
    
      allSObjectFieldsQuery += ' FROM ' + 
                               objectType.getDescribe().getName() + 
                               ' WHERE ID IN (\'' + sObjectIds.get(0) + 
                               '\'';

      for (Integer i=1 ; i < sObjectIds.size() ; i++){
        allSObjectFieldsQuery += ', \'' + sObjectIds.get(i) + '\'';
      }
    
      allSObjectFieldsQuery += ')';
    
      try{
      
        // Execute the query. For every result returned, 
        // use the clone method on the generic sObject 
        // and add to the collection of cloned objects
        for (SObject sObjectFromDatabase:
             Database.query(allSObjectFieldsQuery)){
          clonedSObjects.add(sObjectFromDatabase.clone(false,true));  
        }
    
      } catch (exception e){
        // Write exception capture method 
        // relevant to your organisation. 
        // Debug message, Apex page message or 
        // generated email are all recommended options.
           if(!isBatchProcessing) 
           H_Logger.log('Error - '+e.getMessage() ,'ERROR','statusCode','Webservice (MDM) - Inbound',NotificationXMLContent,null,null,false);
       }
    }    
    
    // return the cloned sObject collection.
    return clonedSObjects;
  }
  /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To get dealer account 
    *  @param            Account name
    *                    
    *  @return           Account record
    */
    public static Map<String,Account> getAccountRec(Set<String> setAccName){
        Map<String,Account> Map_Name_Account = new Map<String,Account>(); 
        List<Account> accountList = [Select Id,Name,
                                            HH_ID__c,
                                            Dealer_Code__c
                                           from Account 
                                           where Name in : setAccName
                                           or Dealer_Code__c in : setAccName
                                           for update
                                    ];
                                    
        if(accountList != null && !accountList.isEmpty()){
            for(Account tempAcc : accountList){
                if(tempAcc.Dealer_Code__c != null)
                 Map_Name_Account.put(tempAcc.Dealer_Code__c,tempAcc);
                else
                 Map_Name_Account.put(tempAcc.Name,tempAcc);
            }
        }                            
                           
     return Map_Name_Account;
    }
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To set the Record type of given object type 
    *  @param            Recordtype Developer Name and object
    *                    
    *  @return           List of RecordType
    */
    private static List<RecordType> setObjRecordType(String rectypeName,String objectType){ 
         
         List<RecordType> rectypelist = [Select Id from RecordType where DeveloperName like: rectypeName and SobjectType=:objectType];  
         return rectypelist; 
    }
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To check Log_All_MDM_Notifications__c checkbox value of Current User 
    *  @param            None
    *                    
    *  @return           Boolean
    */
    private static Boolean checkUserLogPermission(){ 
         
         return [Select Log_All_MDM_Notifications__c From User Where Id = :UserInfo.getUserId()][0].Log_All_MDM_Notifications__c; 
    } 
    
}