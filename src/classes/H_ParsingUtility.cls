/**
 *      @author       : Shilpa Menghani(Deloitte)
 *      @date         : 07/07/2015
        @description  : For parsing XML and inserting info
        Modification Log:
        ------------------------------------------------------------------------------------------
                Developer               User story            Date                Description
        ------------------------------------------------------------------------------------------
                Shilpa (Deloitte)                              07/07/2015           Original Version
                Piyush (Deloitte)                              12/08/2015           Made changes for Object Name changes
*/
public without sharing class H_ParsingUtility {
  
    //To store sObject instances
    public static Map<String,sObject> sobjType_sObjMap = new Map<String,sObject>();
    public static List<sObject> lstSobject = new List<sObject>();
    public static sObject sObj ;
    
    // To store ContactUCID values
    public static Set<String> UCIDSet = new Set<String>();
    public static String previousUCIDs = '';
    
    // To check if IdentificationValue is UCID or not
    public static Boolean isUCID = false; 
    
    //To check if any error has been log or not
    public static Boolean isErrorLog = false;
    
    //To check if End date is in past or not
    public static Boolean isPastEndDate = false; 
     public static Boolean isLastUpdateDate = false; 
    
    // To check if NameUsageType is 4 and NameUsageValue is ALSO KNOWN AS or not
    public static Boolean isAKAName = false;
    // To check if NameUsageType is 1 and NameUsageValue is LEGAL or not
    public static Boolean isLegalName = false;
    public static Boolean isProcess = true; 
    
    //To process ChildMapped records
    public static Integer ChildCount = 0;    
    public static Set<String> ChildMappedTagSet = new Set<String>();
    public static Map<Integer,Map<String,String>> Map_childCount_fieldValue = new Map<Integer,Map<String,String>>();
    
    // To check if process node is ToBeBObj or not
    public static Boolean isToBeBObj = false; 
    
    // To store todays date 
    public static Date todaysDate = Date.today();
    
    public static Set<String> objectToBeAdded = new Set<String>();
    
    // To store contact Ids 
    public static Set<String> contactIdSet = new Set<String>();
    
    // To store Preferred Dealer Category Type and PreferredDealerCode
    public static Map<String,String> Map_DealerCatType_DealerCode = new Map<String,String>();
    
    // To store Preferred Dealer Code and DealerValue
    public static Map<String,String> Map_DealerCode_DealerValue = new Map<String,String>();
    
    // To store if previous instnace has been removed or not
    public static Boolean isRemoved = false;
    
    // To store previous LastUpdate date 
    public static Date prevLastUpdateDate;
    public static Date LegalStartDate;
    
   // To store Preferred Dealer Category Type , Dealer Code and PreferredDealerValue
    public static String preferredDealerCatType = '';
    public static String preferredDealerValue = '';
     public static String preferredDealerCode = '';
    
    // To store Dealers Effective End Date
    public static Date DealerEffEndate = null;
    
    //To store Privacy Preferences Value
    public static String PrivPrefValue = '';
    public static String PrivPrefCatValue = '';
    public static String PrivPrefActionValue = '';
    
    
    // Notification  Constants
    public static final String XML_TAG_MAPPING_STATUS_NOTMAPPED = 'NotMapped';
    public static final String XML_TAG_MAPPING_STATUS_CHILDMAPPED = 'ChildMapped';
    
    public static Map<String,XML_Structure__c> mapnotificationHierarchy = 
                           new Map<String,XML_Structure__c>();
                           
    public static Map<String,Map<String,Schema.DescribeFieldResult>> objectFieldDescribrMap = 
                               new Map<String,Map<String,Schema.DescribeFieldResult>>();
       
   /* Use custom setting "XML_Structure__c" to retrieve the mapping of XML tags
    *  to Contact/Address/ContactMethod fields and then push data from XML to sobject record
    */
    public static void mapObjectFields(Dom.XMLNode currentNode) {
        if(currentNode == null ||currentNode.getName() == null) {
            return;
        }
        String mappingKey = currentNode.getName().trim(); 
                                     
        if(mappingKey.equalsIgnoreCase(H_Constants.TCRMAdminContEquivBObj)){ 
          // map if tag is present in child nodes
                if( currentNode.getChildElement(H_Constants.AdminSystemValue, H_Customer_WS2.maintainNamespace) != NULL) { 
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                           if(childNode.getName() == H_Constants.AdminSystemValue){
                              if(String.isNotBlank(childNode.getText())){
                                     String adminSystemValue = childNode.getText().trim();
                                     
                                      //If AdminSystemValue is SFSD, fetch custom setting record with name as TCRMAdminContEquivBObj
                                      // Not for Collapse Notification file
                                    if(!H_Customer_WS2.notificationType.equalsIgnoreCase(H_Constants.CollapseParty_Transaction_type) && adminSystemValue.equalsIgnoreCase(H_Constants.AdminSystemValue_SFSD)){
                                       mappingKey = H_Constants.TCRMAdminContEquivBObj;  
                                     }
                                     else{
                                        mappingKey = '';
                                        return;
                                     }
                                }
                           }
                     }
                }
        }
        if(mappingKey.equalsIgnoreCase(H_Constants.TCRMExtension)){
              // map if tag is present in child nodes
              if(currentNode.getChildElement(H_Constants.XContEquivBObjExt, H_Customer_WS2.maintainNamespace) != NULL) {
                  mappingKey = H_Constants.XContEquivBObjExt;
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                     if(childNode.getName() == H_Constants.XContEquivBObjExt){
                        currentNode = childNode;
                     } 
                     
                  }
              }
         }
         
         if(mappingKey.equalsIgnoreCase(H_Constants.TCRMPersonNameBObj)){
          // map if tag is present in child nodes
                if(currentNode.getChildElement(H_Constants.NameUsageValue, H_Customer_WS2.maintainNamespace) != NULL) { 
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                           if(childNode.getName() == H_Constants.NameUsageValue){
                              if(String.isNotBlank(childNode.getText())){
                                     String nameUsageValue = childNode.getText().trim();
                                     //Store the legal name on the contact
                                     if(nameUsageValue.equalsIgnoreCase(H_Constants.NameUsageValue_Legal)){
                                       mappingKey = H_Constants.NameUsageValue_Legal;
                                     }
                                     //Store the Also Known As on the contact
                                     else if(!H_Customer_WS2.isTypeOrganaization && nameUsageValue.equalsIgnoreCase(H_Constants.NameUsageValue_AKA)){
                                       mappingKey = H_Constants.TCRMPersonNameBObj;  
                                     }
                                     else{
                                        mappingKey = '';
                                        return;
                                     }
                                }
                           }
                     }
                }
        }
        if(mappingKey.equalsIgnoreCase(H_Constants.TCRMOrganizationNameBObj)){ 
          // map if tag is present in child nodes
                if(currentNode.getChildElement(H_Constants.NameUsageValue, H_Customer_WS2.maintainNamespace) != NULL) { 
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                           if(childNode.getName() == H_Constants.NameUsageValue){
                              if(String.isNotBlank(childNode.getText())){
                                     String nameUsageValue = childNode.getText().trim();
                                      //Store the legal name on the contact
                                     if(nameUsageValue.equalsIgnoreCase(H_Constants.NameUsageValue_Legal)){
                                       mappingKey = H_Constants.NameUsageValue_Legal;
                                     }
                                     ///Store the Doing Business As on the contact
                                     else if(H_Customer_WS2.isTypeOrganaization && nameUsageValue.equalsIgnoreCase(H_Constants.OrgNameUsageValue_DBS)){
                                       mappingKey = H_Constants.TCRMOrganizationNameBObj;  
                                     }
                                     else{
                                        mappingKey = '';
                                        return;
                                     }
                                }
                           }
                     }
                }
        }
        if(mappingKey.equalsIgnoreCase(H_Constants.TCRMPartyGroupingBObj)){
          // map if tag is present in child nodes
                if(currentNode.getChildElement(H_Constants.PartyGroupingValue, H_Customer_WS2.maintainNamespace) != NULL) { 
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                           if(childNode.getName() == H_Constants.PartyGroupingValue){
                              if(String.isNotBlank(childNode.getText())){
                                     String partyGroupValue = childNode.getText().trim();
                                      //Store the HouseHold information
                                     if(!partyGroupValue.equalsIgnoreCase(H_Constants.HouseHold)){
                                        isProcess = false;
                                        return;
                                     }
                                     else{
                                        break;
                                     }
                                }
                           }
                     }
                }
        }
        
        if(mappingKey.equalsIgnoreCase(H_Constants.XPartyProductRoleBObj)){
          // map if tag is present in child nodes
                if(currentNode.getChildElement(H_Constants.RoleValue, H_Customer_WS2.maintainNamespace) != NULL) {  
                  for(dom.Xmlnode childNode : currentNode.getChildElements()){
                           if(childNode.getName() == H_Constants.RoleValue){
                              if(String.isNotBlank(childNode.getText())){
                                     String RoleValue = childNode.getText().trim();
                                     //Check If RoleValue is valid or not
                                     if(checkValidRoleValues(RoleValue)){
                                     	break;
                                     }
                                     else{
                                        isProcess = false;
                                        return;
                                     }
                                }
                           }
                     }
                }
        }
        
        if(mappingKey.equalsIgnoreCase(H_Constants.XPartyDealerPreferenceBObj)){
               // map if tag is present in child nodes
                if(currentNode.getChildElement(H_Constants.PreferredDealerCode, H_Customer_WS2.maintainNamespace) == NULL) { 
                          isProcess = false;
                          return;
                 }
        }
        // Get custom setting record from XML structure 
        XML_Structure__c notificationHierarchy = getMapping(mappingKey); 
        
        if(notificationHierarchy == null) {
           if(!H_Customer_WS2.isBatchProcessing)	
           H_Logger.log('Custom setting XML structure record not present for '+mappingKey ,'ERROR','statusCode','Webservice (MDM) - Inbound');
           isErrorLog = true;
            return;
        }
          
        sObj = mapFields(currentNode, notificationHierarchy);
        
        // add new object instance 
        if(notificationHierarchy != null && notificationHierarchy.Create_New_Instance__c && sObj != null){
            
             if(ChildCount > 1 && isToBeBObj){
               
               if(notificationHierarchy.Mapped_Object__c.equalsIgnoreCase('Contact')){
                 
                for(Integer i=2;i<=ChildCount;i++){
                     if(Map_childCount_fieldValue != null && !Map_childCount_fieldValue.isEmpty() && Map_childCount_fieldValue.containsKey(i)){
                         Map<String,String> Map_fieldApi_fieldValue = Map_childCount_fieldValue.get(i);
                         mapsObjectField(sObj,i);
                     }
                }
                lstSobject.add(sObj);
                 
              }
               else{  
                   //create object instances on basis of count
                   for(Integer i=2;i<=ChildCount;i++){
                     if(Map_childCount_fieldValue != null && !Map_childCount_fieldValue.isEmpty() && Map_childCount_fieldValue.containsKey(i)){
                         Map<String,String> Map_fieldApi_fieldValue = Map_childCount_fieldValue.get(i);
                        
                         if(!Map_fieldApi_fieldValue.isEmpty()){
                             sObject sObjIn = sObj.clone();
                             lstSobject.add(mapsObjectField(sObjIn,i));
                         }
                         else{
                            lstSobject.add(sObj);
                         }
                     }
                   }
               }               
                 //release instances
                 ChildCount = 0;
                 Map_childCount_fieldValue.clear();
                 ChildMappedTagSet.clear();
             }
             else{
                lstSobject.add(sObj);
              }
             //release instances
                 ChildCount = 0;
                 Map_childCount_fieldValue.clear();
                 ChildMappedTagSet.clear();
                 
                 //set to collect object to be processed
                 objectToBeAdded.add(String.valueOf(sObj.getSobjectType()));
        }
        isErrorLog = false;
        isProcess = true;
        
         
    }
    /**
    * Method to set value in related field 
    */
    public static void processFields(Dom.XMLNode currentNode, Map<String,String> fieldMapping, Sobject sObjectI, String tag,Dom.XMLNode childNode){
            // Get object type
            String currentObjectName = String.valueOf(sObjectI.getSObjectType());
            
            // Check if IdentificationValue is equal to UCID
            if(tag.equalsIgnoreCase('IdentificationValue')){
              if(String.isNotBlank(childNode.getText())){
                 String idValue = childNode.getText();
                 if(idValue.equalsIgnoreCase('UCID')){
                   isUCID = true;
                 }
              }
            }  
            // Check if NameUsageType is equal to 1
           else if(isToBeBObj && tag.equalsIgnoreCase('NameUsageType')){
                 if(String.isNotBlank(childNode.getText())){
                   String nameUsageType = childNode.getText();
                   if(!H_Customer_WS2.isTypeOrganaization && nameUsageType.equals('4')){
                     isAKAName = true;
                     isLegalName = false;
                   }
                   else if(nameUsageType.equals('1')){
                     isLegalName = true;
                     isAKAName = false;
                   }
                   else if(H_Customer_WS2.isTypeOrganaization && nameUsageType.equals('2')){
                     isAKAName = true;
                   }
                   else{
                     isProcess = false;
                     isAKAName = false;
                     isLegalName = false;
                   }
                 }
            } 
            else if((isAKAName || isLegalName ) && isToBeBObj && (tag.equalsIgnoreCase('EndDate'))){
                    Date endDate = Date.valueOf(childNode.getText());
                    isPastEndDate = checkEndDateToBeInPast(endDate,todaysDate);
                    if(isPastEndDate){
                     isProcess = false;
                     Map_childCount_fieldValue.remove(ChildCount);
                     ChildCount--;
                    }
            } 
            
            // Check if tag is PreferredDealerCatType
           else if(isToBeBObj && tag.equalsIgnoreCase('PreferredDealerCatType')){
               if(String.isNotBlank(childNode.getText())){
                 preferredDealerCatType = childNode.getText();
                  
                 //If multiple are in the notification then the one that does not have an EffectiveEndDate will be used.
                 if(String.isNotBlank(preferredDealerValue) && String.isNotBlank(preferredDealerCode)){
	                 if(Map_DealerCatType_DealerCode != null && !Map_DealerCatType_DealerCode.isEmpty() && Map_DealerCatType_DealerCode.containsKey(preferredDealerCatType)){
	                    if(DealerEffEndate == null){
	                    	Map_DealerCatType_DealerCode.put(preferredDealerCatType,preferredDealerCode);
	                    	Map_DealerCode_DealerValue.put(preferredDealerCode,preferredDealerValue);
	                    }
	                 }
	                 else{
	                     Map_DealerCatType_DealerCode.put(preferredDealerCatType,preferredDealerCode);
	                     Map_DealerCode_DealerValue.put(preferredDealerCode,preferredDealerValue);
	                 }
                 }
                 
               }
               
            } 
             // Check if tag is PreferredDealerValue
           else if(isToBeBObj && tag.equalsIgnoreCase('PreferredDealerValue')){
               if(String.isNotBlank(childNode.getText())){
                  preferredDealerValue = childNode.getText().trim();
                }
            } 
            // Check if tag is PreferredDealerCode
           else if(isToBeBObj && tag.equalsIgnoreCase('PreferredDealerCode')){
               if(String.isNotBlank(childNode.getText())){
                  preferredDealerCode = childNode.getText().trim();
               }
            } 
             // Check if tag is PreferredDealerCatType
            else if(isToBeBObj && currentNode.getName() == H_Constants.XPartyDealerPreferenceBObj && tag.equalsIgnoreCase('EffectiveEndDate')){
                   DealerEffEndate = String.isNotBlank(childNode.getText()) ? Date.valueOf(childNode.getText()) : null; 
             }
             // Check if tag is PrivPrefEntity
           else if(isToBeBObj && tag.equalsIgnoreCase('PrivPrefValue')){
                PrivPrefValue = '';
               if(String.isNotBlank(childNode.getText())){
                  PrivPrefValue = childNode.getText().trim();
                  if(String.isNotBlank(PrivPrefActionValue) && String.isNotBlank(PrivPrefValue) && String.isNotBlank(PrivPrefCatValue)){
                     updateContactPrivPrefFields(sObjectI,PrivPrefValue,PrivPrefCatValue,PrivPrefActionValue);
                  }
               }
            }
            // Check if tag is PrivPrefEntity
           else if(isToBeBObj && tag.equalsIgnoreCase('PrivPrefCatValue')){
               PrivPrefCatValue = '';
               if(String.isNotBlank(childNode.getText())){
                  PrivPrefCatValue = childNode.getText().trim();
               }
            }
            // Check if tag is PrivPrefEntity
           else if(isToBeBObj && tag.equalsIgnoreCase('PrivPrefActionValue')){
               PrivPrefActionValue = '';
               if(String.isNotBlank(childNode.getText())){
                  PrivPrefActionValue = childNode.getText().trim();
               }
            }
            //Code for ChildMapped Tag
            else if(isToBeBObj && ChildMappedTagSet != null && !ChildMappedTagSet.isEmpty() && ChildMappedTagSet.contains(currentNode.getName())){
               //Check if StartDate is in past for AKA
               if(isAKAName && (tag.equalsIgnoreCase('StartDate'))){
                    Date LastUpdateDate = Date.valueOf(childNode.getText());
                    if(prevLastUpdateDate != null)
                    isLastUpdateDate = checkEndDateToBeInPast(LastUpdateDate,prevLastUpdateDate);
                    
                   //Copy current node end date to todays date for latest to be saved 
                   if(!isLastUpdateDate)
                   prevLastUpdateDate = LastUpdateDate;
               } 
               //Check if StartDate is in past for Legal
               else if(isLegalName && (tag.equalsIgnoreCase('StartDate'))){
                    Date LastUpdateDate = Date.valueOf(childNode.getText());
                    if(LegalStartDate != null)
                    isLastUpdateDate = checkEndDateToBeInPast(LastUpdateDate,LegalStartDate);
                    
                   //Copy current node end date to todays date for latest to be saved 
                   if(!isLastUpdateDate)
                   LegalStartDate = LastUpdateDate;
               } 
               
              //Copy current node value 
                if(!isPastEndDate && (!tag.equalsIgnoreCase('EndDate') && !tag.equalsIgnoreCase('StartDate')) && Map_childCount_fieldValue != null && !Map_childCount_fieldValue.isEmpty() && Map_childCount_fieldValue.containsKey(ChildCount)){
                  
                    // Release previous node value
                    for(String tagValue : fieldMapping.keySet()){
                        
                        String fieldType = getFieldType(currentObjectName,fieldMapping.get(tagValue));
                        if(String.isNotBlank(fieldType)){
                          sObjectI.put(fieldMapping.get(tagValue),null);
                        }
                    }
                   
                    Map<String,String> Map_fieldApi_fieldValue = Map_childCount_fieldValue.get(ChildCount);
                    String fieldApiName =  fieldMapping.get(tag);
                    
                    if(String.isNotBlank(fieldApiName)){
                        Map_fieldApi_fieldValue.put(fieldApiName,childNode.getText());
                        Map_childCount_fieldValue.put(ChildCount,Map_fieldApi_fieldValue);
                    }
                    
                }
                //Decrease the count and remove previous instance from Map
                else if(isPastEndDate && isLastUpdateDate && !isRemoved){
                  Map_childCount_fieldValue.remove(ChildCount);
                  ChildCount--;
                  isRemoved = true;
                }
        
             }
            else{
            	//Get the Field type and set value in related field
                 String fieldType = getFieldType(currentObjectName,fieldMapping.get(tag));
                   
                    if(String.isNotBlank(fieldType)){
                      if(String.isNotBlank(childNode.getText())){
                        String nodeText = childNode.getText();
                        
                        if(fieldType != null && fieldType == Schema.DisplayType.Integer.name()) {
                            sObjectI.put(fieldMapping.get(tag),Integer.valueOf(nodeText));
                        } else if(fieldType != null && fieldType == Schema.DisplayType.Double.name()) {
                            sObjectI.put(fieldMapping.get(tag),Double.valueOf(nodeText));
                        }else if(fieldType != null && fieldType == Schema.DisplayType.Boolean.name()) {
                            if(nodeText.equalsIgnoreCase('Y'))
                            sObjectI.put(fieldMapping.get(tag),true);
                        }else if(fieldType != null && fieldType == Schema.DisplayType.Id.name()) {
                            if(nodeText.startsWithIgnoreCase('003')){
                               sObjectI.put(fieldMapping.get(tag),Id.valueOf(nodeText));
                               contactIdSet.add(nodeText); 
                            }
                        }
                        else if(fieldType != null && fieldType == Schema.DisplayType.Date.name()) {
                          sObjectI.put(fieldMapping.get(tag),Date.valueOf(childNode.getText()));
                        }else if(fieldType != null && fieldType == Schema.DisplayType.DateTime.name()) {
                          sObjectI.put(fieldMapping.get(tag),DateTime.valueOf(childNode.getText()));
                        } else if(fieldType != null && fieldType == Schema.DisplayType.String.name() || fieldType == Schema.DisplayType.TextArea.name()){
                            String text = nodeText;
                            
                            Integer fieldLength = getFieldLength(currentObjectName, fieldMapping.get(tag));
                            if(text != null && fieldLength > 0 && text.length() > fieldLength){
                                if(fieldLength == 1){
                                   text = text.substring(0, fieldLength);
                                }
                                else{
                                    text = text.substring(0, fieldLength - 1);
                                }
                             }
                            
                            sObjectI.put(fieldMapping.get(tag), text);
                        }else {
                          sObjectI.put(fieldMapping.get(tag), nodeText);
                        }
                      }
                      else{
                        sObjectI.put(fieldMapping.get(tag),null);
                      }
                    }
            
                    if(isUCID && tag.equalsIgnoreCase('IdentificationNumber')){
                       if(String.isNotBlank(childNode.getText())){
                         String ChildNodeText = childNode.getText();
                           
                          UCIDSet.add(ChildNodeText);
                          //Store AsIsBeObj UCIDs
                          if(!isToBeBObj){
                            if(String.isNotBlank(previousUCIDs))previousUCIDs +=',';
                            previousUCIDs += ChildNodeText;
                          }
                       }
                    }
                    
            }
        
        sobjType_sObjMap.put(currentObjectName,sobjectI);
             
    }
    
    public static String trimString(String str){
        return str != null ? str.trim() : null;
    }
    
    /**
    * Method to process fields mentioned in custom setting 
    */
    public static sObject mapFields(Dom.XMLNode currentNode, XML_Structure__c notificationHierarchy){
      
       //return if all custom settings fields are null or blank
        if((!isNotNullOrBlank(notificationHierarchy.SubTags__c) && !isNotNullOrBlank(notificationHierarchy.SubTags2__c) && !isNotNullOrBlank(notificationHierarchy.SubTags3__c))  
           || (!isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields__c) && !isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields2__c)  
           && !isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields3__c)) || (!isNotNullOrBlank(notificationHierarchy.Mapped_Object__c))){
            return sobj;
        }
        Boolean isAdded = false;
        // get value of tags and mapped field 
        Map<String,String> fieldMapping = new Map<String,String>();
        List<String> lstTags = new List<String>();
        List<String> lstMappedField = new List<String>();
        
        if(isNotNullOrBlank(notificationHierarchy.SubTags__c)){
           lstTags = notificationHierarchy.SubTags__c.split(',');
        }
        if(isNotNullOrBlank(notificationHierarchy.SubTags2__c)){
            lstTags.addAll(notificationHierarchy.SubTags2__c.split(','));
        }
        if(isNotNullOrBlank(notificationHierarchy.SubTags3__c)){
          lstTags.addAll(notificationHierarchy.SubTags3__c.split(','));
        }
        
        if(isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields__c)){
           lstMappedField = notificationHierarchy.Mapped_to_Object_Fields__c.split(',');
        }
        if(isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields2__c)){
          lstMappedField.addAll(notificationHierarchy.Mapped_to_Object_Fields2__c.split(','));
        }
        if(isNotNullOrBlank(notificationHierarchy.Mapped_to_Object_Fields3__c)){
          lstMappedField.addAll(notificationHierarchy.Mapped_to_Object_Fields3__c.split(','));
        }
        
        // Important notice : notificationHierarchy custom setting must have mapping for all the tags
        // In case field is not present for any tag use "NotMapped" for that tag
        // Number of child tags must be equal to number of mapped fields.
        for(integer i = 0 ; i < lstTags.size() ; i++) {            
            fieldMapping.put(trimString(lstTags[i]),trimString(lstMappedField[i]));
        }
        
        // Loop through the tags and retrieve corresponding mapped fields and populate mapped
        // field with data in the XML for that tag
        
        // Get Mapped Object from notificationHierarchy
        String currentObjectName = notificationHierarchy.Mapped_Object__c;
        
        //sObject Instance
        if(currentObjectName == 'Contact' && sobjType_sObjMap != null && !sobjType_sObjMap.isEmpty() && sobjType_sObjMap.containsKey(currentObjectName)){
          sobj = sobjType_sObjMap.get(currentObjectName);
        }
        else{
           if(notificationHierarchy.Create_New_Instance__c)
            sobj= Schema.getGlobalDescribe().get(currentObjectName).newSObject() ;
        }
                
       // iterate on each sub tag               
        for(String tag : fieldMapping.keySet()) {
            if(!isUCID  && isProcess && !tag.equalsIgnoreCase('IdentificationNumber')){
                 //map if tag is current node
                if(tag == currentNode.getName()){
                  if(sobj != null)
                    processFields(currentNode, fieldMapping, sobj, tag, currentNode);
                }
                // map if tag is present in child nodes
                if(currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace) != NULL) { 
                     
                    //ChildMapped nodes
                    if(isToBeBObj && fieldMapping.get(tag) == XML_TAG_MAPPING_STATUS_CHILDMAPPED){
                        ChildCount++;
                        Map_childCount_fieldValue.put(ChildCount,new Map<String,String>());
                        
                        ChildMappedTagSet.add(tag);
                        for(Dom.XMLNode child : currentNode.getChildElements()) {
                            if(child.getName() == tag){
                                mapObjectFields(child);
                            }
                        }
                        
                    }
                    // Parse childs of currentNode
                    //  In case mapping of a child node is neither "NotMapped" nor "ChildMapped"   
                    else if(fieldMapping.get(tag) != XML_TAG_MAPPING_STATUS_NOTMAPPED &&  fieldMapping.get(tag) != XML_TAG_MAPPING_STATUS_CHILDMAPPED) {
                        
                        if(!isAdded && isToBeBObj && ChildMappedTagSet != null && !ChildMappedTagSet.isEmpty() && ChildMappedTagSet.contains(currentNode.getName())){
                            ChildCount++;
                            Map_childCount_fieldValue.put(ChildCount,new Map<String,String>());
                            
                            isAdded = true;
                            isRemoved = false;
                        }
                       
                        if(sobj != null)
                        processFields(currentNode, fieldMapping, sobj, tag, currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace));
                    } 
                    else { // Parse childs of currentNode
                        // In case mapping of a child node is "NotMapped" then called this method again 
                        // to check if current node is parent node and childs of current node are parsed
                        if(notificationHierarchy.Multiple_Children__c){
                           for(dom.Xmlnode childNode : currentNode.getChildElements()){
                               if(childNode.getName() == tag){
                                mapObjectFields(childNode);
                               }
                            }
                        }else{
                           mapObjectFields(currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace));
                        }
            
                    }
                    
                }
              
            }
            //To check TCRMIdentificationBObj EndDate to be in past
            else if(isUCID  && tag.equalsIgnoreCase('EndDate')){
                
                //map if tag is current node
                if(tag == currentNode.getName()){
                  if(sobj != null){
                    Date endDate = Date.valueOf(currentNode.getText());
                    isPastEndDate = checkEndDateToBeInPast(endDate,Date.today());
                  }
                }
                // map if tag is present in child nodes
                if( currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace) != NULL) { 
                    Date endDate = Date.valueOf(currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace).getText());
                    isPastEndDate = checkEndDateToBeInPast(endDate,Date.today());
                } 
            }
            // Set UCID value on Contact
            else if(isUCID && !isPastEndDate && tag.equalsIgnoreCase('IdentificationNumber')){
                
                // map if tag is present in child nodes
                if( currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace) != NULL) { 
                   
                    if(fieldMapping.get(tag) != XML_TAG_MAPPING_STATUS_NOTMAPPED) {
                     if(sobj != null)
                     processFields(currentNode, fieldMapping, sobj, tag, currentNode.getChildElement(tag, H_Customer_WS2.maintainNamespace));
                    } 
                } 
            }
            
        }
        isUCID = false;
        isPastEndDate = false;
        isErrorLog = false;
        isAdded = false;
        isLastUpdateDate = false;
        preferredDealerValue = '';
        preferredDealerCatType = '';
        
        return sobj;
    }
    
    
    
    /* 
    * Methods will return the DescribeFieldResult of the field
    */ 
    public static Schema.DescribeFieldResult getField(String objectName, String fieldName) {
        
        if(!objectFieldDescribrMap.containsKey(objectName)) { 
            Schema.DescribeSObjectResult r = Schema.getGlobalDescribe().get(objectName).getDescribe();
            Map<String,Schema.DescribeFieldResult> fieldMap = new Map<String,Schema.DescribeFieldResult>();
            for(String fieldNameApi : r.fields.getMap().keySet()) {
                fieldMap.put(fieldNameApi,r.fields.getMap().get(fieldNameApi).getDescribe());
            }
            objectFieldDescribrMap.put(objectName,fieldMap);
        }
        
        Schema.DescribeFieldResult field = objectFieldDescribrMap.get(objectName).get(fieldName.toLowerCase());
        
        return field;
    }
    
    /* 
    * Methods will return the Datatype of the field mapped to xml tag
    */ 
    public static String getFieldType(String objectName , String fieldName) {
            String fieldType = '';
            Schema.DescribeFieldResult fieldResult = getField(objectName, fieldName); 
            if(fieldResult != null){
              fieldType = fieldResult.getType().name();
            }
            
        return fieldType;
    }
    
    /* 
    * Methods will return the Field Length of the field mapped to xml tag
    */ 
    public static Integer getFieldLength(String objectName , String fieldName) {
        return getField(objectName, fieldName).getLength();
    }
    
    /* 
    * Methods will return the Label of the field mapped to xml tag
    */ 
    public static String getFieldLabel(String objectName , String fieldName) {
        return getField(objectName, fieldName).getLabel();
    }
    
     
    /* 
    * Methods will return the Datatype of the field mapped to xml tag
    */ 
    public static XML_Structure__c getMapping(String tags) {
        if(!mapnotificationHierarchy.containsKey(tags)) {
            for(XML_Structure__c hierarchy : XML_Structure__c.getall().values()) {
                mapnotificationHierarchy.put(hierarchy.Name,hierarchy);
            }
        }
        return mapnotificationHierarchy.get(tags);
    }
    
    
    // Check String is null of blank
    public static Boolean isNotNullOrBlank(String str){
        if(str != null && str.trim() != '' ){
          return true;
        }
        return false;
    }
    
    /**
    * Method to check if TCRMPartyIdentificationBObj EndDate is in past
    */
    public static boolean checkEndDateToBeInPast(Date currentDate,Date previousDate){
        isPastEndDate = false;
        Integer numberDaysDue = previousDate.daysBetween(currentDate);
      
        if(numberDaysDue <= 0){
            isPastEndDate = true;
        }
        
        return isPastEndDate;
    }
    
    
    /**
    * Method to map field's value in related object
    */
    public static sObject mapsObjectField(sObject sobjI,Integer childCountValue){
        
        if(isToBeBObj && sobjI != null && childCountValue > 0 && ChildMappedTagSet != null && !ChildMappedTagSet.isEmpty()){
             if(Map_childCount_fieldValue != null && !Map_childCount_fieldValue.isEmpty() && Map_childCount_fieldValue.containsKey(childCountValue)){
                Map<String,String> Map_fieldApi_fieldValue = Map_childCount_fieldValue.get(childCountValue);
                
                // Get object type
                String currentObjectName = String.valueOf(sobjI.getSObjectType()); 
                
                for(String fieldAPIName : Map_fieldApi_fieldValue.keySet()){
                  if(String.isNotBlank(fieldAPIName)){
                  	  
                       String fieldType = getFieldType(currentObjectName,fieldAPIName);
                       String fieldValue = Map_fieldApi_fieldValue.get(fieldAPIName);
                       
                      if(String.isNotBlank(fieldType)){ 
                        if(String.isNotBlank(fieldValue)){
                          
                          if(fieldType == Schema.DisplayType.Integer.name()) {
                              sobjI.put(fieldAPIName,Integer.valueOf(fieldValue));
                          } else if(fieldType == Schema.DisplayType.Double.name()) {
                              sobjI.put(fieldAPIName,Double.valueOf(fieldValue));
                          }else if(fieldType == Schema.DisplayType.Boolean.name()) {
                              sobjI.put(fieldAPIName,Boolean.valueOf(fieldValue));
                          }else if(fieldType == Schema.DisplayType.Date.name()) {
                            sobjI.put(fieldAPIName,Date.valueOf(fieldValue));
                          }else if(fieldType == Schema.DisplayType.DateTime.name()) {
                            sobjI.put(fieldAPIName,DateTime.valueOf(fieldValue));
                          } else if(fieldType == Schema.DisplayType.String.name() || fieldType == Schema.DisplayType.TextArea.name()){
                              String text = fieldValue;
                             Integer fieldLength = getFieldLength(currentObjectName, fieldAPIName);
                              if(text != null && fieldLength > 0 && text.length() > fieldLength){
                                  text = text.substring(0, fieldLength - 1);
                              }
                              sobjI.put(fieldAPIName, text);
                          }else {
                              sobjI.put(fieldAPIName, fieldValue);
                          } 
                          
                       }
                       else{
                           sobjI.put(fieldAPIName, '');
                       }
                      }
                  }
            
                }
             }
          }
           
         return sObjI;
                
    }
    
    /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To update related privacy preferences information on Contact 
    *  @param            Contact , PrivacyPreference record
    *                    
    *  @return           none
    */
    public static void updateContactPrivPrefFields(sObject sobjI,String PrefValue,String PrefCatValue,String PrefActionValue){
      
       //HFS 
        if(PrefValue.containsIgnoreCase(H_Constants.ContactbyEmail) && PrefCatValue.equalsIgnoreCase(H_Constants.HFS)){
             sobjI.put('HFS_Email__c',PrefActionValue);
        }
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneVoice) && PrefCatValue.equalsIgnoreCase(H_Constants.HFS)){
             sobjI.put('HFS_Phone_Voice__c',PrefActionValue);
        }
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyMail) && PrefCatValue.equalsIgnoreCase(H_Constants.HFS)){
             sobjI.put('HFS_Mail__c',PrefActionValue); 
        }
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbySocialMedia) && PrefCatValue.equalsIgnoreCase(H_Constants.HFS)){
             sobjI.put('HFS_Social_Media__c',PrefActionValue);
        }
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneText) && PrefCatValue.equalsIgnoreCase(H_Constants.HFS)){
             sobjI.put('HFS_Phone_Text__c',PrefActionValue);
        }
        
        //Dealer
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyEmail) && PrefCatValue.equalsIgnoreCase(H_Constants.Dealer)){
             sobjI.put('DLR_Email__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneVoice) && PrefCatValue.equalsIgnoreCase(H_Constants.Dealer)){
             sobjI.put('DLR_Phone_Voice__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyMail) && PrefCatValue.equalsIgnoreCase(H_Constants.Dealer)){
             sobjI.put('DLR_Mail__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbySocialMedia) && PrefCatValue.equalsIgnoreCase(H_Constants.Dealer)){
             sobjI.put('DLR_Social_Media__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneText) && PrefCatValue.equalsIgnoreCase(H_Constants.Dealer)){
             sobjI.put('DLR_Phone_Text__c',PrefActionValue);
        }
        
        //HC
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyEmail) && PrefCatValue.equalsIgnoreCase(H_Constants.HC)){
             sobjI.put('HC_Email__c',PrefActionValue);
        }
        else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneVoice) && PrefCatValue.equalsIgnoreCase(H_Constants.HC)){
             sobjI.put('HC_Phone_Voice__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyMail) && PrefCatValue.equalsIgnoreCase(H_Constants.HC)){
             sobjI.put('HC_Mail__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbySocialMedia) && PrefCatValue.equalsIgnoreCase(H_Constants.HC)){
             sobjI.put('HC_Social_Media__c',PrefActionValue);
        }
         else if(PrefValue.containsIgnoreCase(H_Constants.ContactbyPhoneText) && PrefCatValue.equalsIgnoreCase(H_Constants.HC)){
             sobjI.put('HC_Phone_Text__c',PrefActionValue);
        }
     }
     /*
    *  @author           Shilpa Menghani (Deloitte) 
    *  @description      To check valid RoleValue 
    *  @param            RoleValue
    *                    
    *  @return           Boolean
    */
    public static Boolean checkValidRoleValues(String RoleValue){
    	Set<String> validRoleValueSet = new Set<String>();
    	validRoleValueSet.add(H_Constants.Lesse);
    	validRoleValueSet.add(H_Constants.Colesse);
    	validRoleValueSet.add(H_Constants.Buyer);
    	validRoleValueSet.add(H_Constants.Cobuyer);
    	validRoleValueSet.add(H_Constants.Guarantor);
    	validRoleValueSet.add(H_Constants.Subscriber);
    	validRoleValueSet.add(H_Constants.Owner);
    	validRoleValueSet.add(H_Constants.Coowner);
    	validRoleValueSet.add(H_Constants.Warrantee);
    	validRoleValueSet.add(H_Constants.Servicer);
    	Boolean isValidRole = false;
    	
    	if(String.isNotBlank(RoleValue) && validRoleValueSet != null && !validRoleValueSet.isEmpty() && validRoleValueSet.contains(RoleValue)){
    		isValidRole = true;
    	}
    	return isValidRole;
    }
      
}