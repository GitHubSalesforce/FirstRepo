/**
 *      @author       : Piyush (Deloitte)
 *      @date         : 24/08/2015
        @description  : Common testdata creation classes with static methods used in testclasses
        @inputs : 
        @testClass    :H_ParsingTestDataUtility 
        Modification Log:
        ------------------------------------------------------------------------------------
                Developer                       Date                Description
        ------------------------------------------------------------------------------------
              Shilpa (Deloitte)            25/08/2015              Original Version
              Piyush (Deloitte)            10/09/2015              Added Logic for creation of test record
              Piyush (Deloitte)            30/09/2015              Added Logic for creation of test record
              Piyush (Deloitte)            01/10/2015              Added Logic for creation of test record
              Piyush (Deloitte)            27/01/2016              Added Logic for creation of test record
 */
public class H_ParsingTestDataUtility {
      /**
        @author       : Shilpa (Deloitte)
        @date         : 24/08/2015
        @description  : static method to create Account
        @params       : intCount - numbers of records to create
        @return       : list of Account records
        */
    public static List<Account> createAccount(Integer intCount){
       List<Account> lstNewAccount =new List<Account>();
             for(Integer i=0;i<intCount;i++){
                Account objAccount = new Account(Name = 'Test Account '+i);
                lstNewAccount.add(objAccount);                                                  
             }
             
          return lstNewAccount;
    }
      /**
        @author       : Shilpa (Deloitte)
        @date         : 24/08/2015
        @description  : static method to create Contact
        @params       : intCount - numbers of records to create
        @return       : list of Account records
        */
    public static List<Contact> createContact(Integer intCount){
       List<Contact> lstNewContact =new List<Contact>();
             for(Integer i=0;i<intCount;i++){
                Contact objContact = new Contact(lastname = 'test'+i,
                                                 firstname = 'SFDC',
                                                 middlename = 'Contact',
                                                 phone = '555-555-5555',
                                                 Email = 'contactemail@testorg.com',mailingCity='test city',mailingCountry='Canada');
                lstNewContact.add(objContact);                                                  
             }
             
          return lstNewContact;
    }
     /**
        @author       : Shilpa (Deloitte)
        @date         : 24/08/2015
        @description  : static method to create Address
        @params       : intCount - numbers of records to create
        @return       : list of Address records
        */
    public static List<Address__c> createAddress(Integer intCount){
       List<Address__c> lstNewAddress =new List<Address__c>();
             for(Integer i=0;i<intCount;i++){
                Address__c objAddress = new Address__c();
                objAddress.AddressLineOne__c = 'test';
                objAddress.AddressLineTwo__c = 'test';
                objAddress.AddressLineThree__c = 'test';
                objAddress.City__c = 'toronto';
                objAddress.ProvinceStateValue__c ='ON';
                objAddress.CountryValue__c ='Canada';
                objAddress.ZipPostalCode__c ='1234';
                lstNewAddress.add(objAddress);                                                  
             }
             
          return lstNewAddress;
    }
    /**
        @author       : Shilpa (Deloitte)
        @date         : 24/08/2015
        @description  : static method to create custom setting XMLStructure record
        @params       : intCount - numbers of records to create
        @return       : list of XMLStructure records
        */
    public static List<XML_Structure__c> generateNotificationHierarchyData() {
        List<XML_Structure__c> lstXMLStructure = new List<XML_Structure__c>();
        
        lstXMLStructure.add(getXMLStructure('TCRMPersonBObj',true,'Contact','PreferredLanguage__c,PartyType__c,SolicitationIndicator__c,Birthdate,Gender__c,MaritalStatusValue__c','NotMapped,NotMapped,NotMapped,NotMapped,NotMapped,NotMapped,ChildMapped','',true,'PreferredLanguageValue,PartyType,SolicitationIndicator,BirthDate,GenderType,MaritalStatusValue','TCRMPartyAddressBObj,TCRMPartyContactMethodBObj,TCRMPartyIdentificationBObj,TCRMAdminContEquivBObj,TCRMPartyPrivPrefBObj,TCRMExtension,TCRMPersonNameBObj',''));
        lstXMLStructure.add(getXMLStructure('TCRMPartyAddressBObj',true,'Address__c','AddressUsageValue__c,StartDate__c,EndDate__c,LocationGroupLastUpdateDate__c,LocationGroupLastUpdateUser__c,ChildMapped','','',false,'AddressUsageValue,StartDate,EndDate,LocationGroupLastUpdateDate,LocationGroupLastUpdateUser,TCRMAddressBObj','',''));                                                         
        lstXMLStructure.add(getXMLStructure('TCRMPartyContactMethodBObj',true,'ContactMethod__c','ContactMethodUsageValue__c,SolicitationIndicator__c, StartDate__c, EndDate__c,ContactMethodGroupLastUpdateDate__c,ChildMapped','','',true,'ContactMethodUsageValue, SolicitationIndicator,StartDate,EndDate,ContactMethodGroupLastUpdateDate,TCRMContactMethodBObj','',''));
        lstXMLStructure.add(getXMLStructure('TCRMPartyIdentificationBObj',false,'Contact','UCID,NotMapped,UCID__c','','',false,'IdentificationValue,EndDate,IdentificationNumber','',''));                                                         
        lstXMLStructure.add(getXMLStructure('TCRMAdminContEquivBObj',false,'Contact','AdminSystemType__c,AdminSystemValue__c,Id','','',false,'AdminSystemType,AdminSystemValue,AdminPartyId','',''));                                                         
        lstXMLStructure.add(getXMLStructure('TCRMPersonNameBObj',false,'Contact','NameUsageType,Salutation,FirstName,EndDate,LastName, MiddleName,PersonNameLastUpdateDate','','',false,'NameUsageType,PrefixValue,GivenNameOne,EndDate,LastName,GivenNameTwo,PersonNameLastUpdateDate','',''));                                                         
        lstXMLStructure.add(getXMLStructure('TCRMAddressBObj',false,'Address__c','AddressLineOne__c, AddressLineTwo__c,AddressLineThree__c,City__c,ProvinceStateValue__c,CountryValue__c,ZipPostalCode__c','','',false,'AddressLineOne, AddressLineTwo, AddressLineThree,City,ProvinceStateValue,CountryValue,ZipPostalCode','',''));                                                         
        lstXMLStructure.add(getXMLStructure('TCRMContactMethodBObj',false,'ContactMethod__c','ReferenceNumber__c,ContactMethodType__c,ContactMethodValue__c','','',false,'ReferenceNumber,ContactMethodType,ContactMethodValue','',''));  
        lstXMLStructure.add(getXMLStructure('TCRMPartyGroupingBObj',true,'Account','PartyGroupingValue__c,Name,PartyGroupingName__c,PartyGroupingDescription__c,PartyGroupingType__c,StartDate__c,NotMapped','','',false,'PartyGroupingValue,PartyGroupingIdPK,PartyGroupingName,PartyGroupingDescription,PartyGroupingType,StartDate,TCRMPartyGroupingAssociationBObj','',''));  
        lstXMLStructure.add(getXMLStructure('TCRMPartyGroupingAssociationBObj',false,'Account','EffectEndDate__c','','',false,'EffectEndDate','',''));  
        lstXMLStructure.add(getXMLStructure('XPartyProductRoleBObj',true,'Customer_Role__c','RoleValue__c,EffectiveStartDate__c,EffectiveEndDate__c,PartyProductRoleLastUpdateDate__c,NotMapped,','','',false,'RoleValue,EffectiveStartDate,EffectiveEndDate,XPartyProductRoleLastUpdateDate,XProductBObj','',''));  
        lstXMLStructure.add(getXMLStructure('XProductBObj',true,'VIN__c','ProductSerialNumber__c,ProductValue__c,ProductLastUpdateDate__c,ProductLastUpdateUser__c','','',false,'ProductSerialNumber,ProductValue,XProductLastUpdateDate,XProductLastUpdateUser','','')); 
        lstXMLStructure.add(getXMLStructure('CASS',true,'CASS_No__c','Cass_No__c,ContEquivLastUpdateDate__c,ContEquivLastUpdateUser__c,NotMapped','','',false,'AdminPartyId,ContEquivLastUpdateDate,ContEquivLastUpdateUser,TCRMExtension','','')); 
        lstXMLStructure.add(getXMLStructure('XPartyDealerPreferenceBObj',false,'Contact','PreferredDealerCode,PreferredDealerValue,EffectiveEndDate,PreferredDealerCatType','','',false,'PreferredDealerCode,PreferredDealerValue,EffectiveEndDate,PreferredDealerCatType','','')); 
        lstXMLStructure.add(getXMLStructure('Legal',false,'Contact','NameUsageType,LegalSalutation__c,LegalGivenNameOne__c,EndDate,Legal_Name__c, LegalGivenNameTwo__c,PersonNameLastUpdateDate','','',false,'NameUsageType,PrefixValue,GivenNameOne,EndDate,LastName,GivenNameTwo,PersonNameLastUpdateDate','','')); 
        lstXMLStructure.add(getXMLStructure('XContEquivBObjExt',false,'CASS_No__c','XEffectiveStartDate__c,XEffectiveEndDate__c','','',false,'XEffectiveStartDate,XEffectiveEndDate','','')); 
        lstXMLStructure.add(getXMLStructure('XPersonBObjExt',false,'Contact','CustomerLoyaltyScore__c','','',false,'XCustomerLoyaltyScore','','')); 
        lstXMLStructure.add(getXMLStructure('TCRMPartyPrivPrefBObj',false,'Contact','PrivPrefEntity,PrivPrefReasonValue,PrivPrefActionValue,PrivPrefCatValue,PrivPrefValue','','PrivPrefCatValue__c,PrivPrefActionValue__c',false,'PrivPrefEntity,PrivPrefReasonValue,PrivPrefActionValue,PrivPrefCatValue,PrivPrefValue','','')); 
        
        insert lstXMLStructure;
        return lstXMLStructure;
    }
        
    /**
    * create XMLHierarchy
    */
    public static XML_Structure__c getXMLStructure(String name,Boolean isNewInstance,String mappedToObject,String mappedToObjectField,String mappedToObjectField2,String mappedToObjectField3,Boolean multipleChildren,String tags,String tags2,String tags3) {
    
        XML_Structure__c XMLStructure = new XML_Structure__c();
        XMLStructure.Name = name;
        XMLStructure.Create_New_Instance__c = isNewInstance;
        XMLStructure.Mapped_Object__c = mappedToObject;
        XMLStructure.Mapped_to_Object_Fields__c = mappedToObjectField;
        XMLStructure.Mapped_to_Object_Fields2__c = mappedToObjectField2;
        XMLStructure.Mapped_to_Object_Fields3__c = mappedToObjectField3;
        XMLStructure.Multiple_Children__c = multipleChildren;
        XMLStructure.SubTags__c = tags;
        XMLStructure.SubTags2__c = tags2;
        XMLStructure.SubTags3__c = tags3;
        
       return XMLStructure;
   }
   /**
   * create String of XML Payload
   */
   public static String getXMLFile(){
      String xmlFile = '<TCRMNotification>';
        xmlFile += '<NotificationHeader>';
        xmlFile += '<NotificationType>CollapsePartyNotification</NotificationType>';
        xmlFile += '</NotificationHeader>';
        xmlFile += '<NotificationBody>';
        xmlFile += '<MaintainNotificationBObj>';
             
                       
        xmlFile += getAsIsBobj();
        xmlFile += getToBeBObj();
        
        xmlFile += '</MaintainNotificationBObj>';  
        xmlFile += '</NotificationBody>';
        xmlFile += '</TCRMNotification>';
        
        return xmlFile;
   }
   
   public static string getAsIsBobj(){
    
      String AsIsBObj = '<AsIsBObj>';
        AsIsBObj += '<ComponentID>1020022</ComponentID>';
        AsIsBObj += '<XHondaPartyBObj>';
        AsIsBObj += '<TCRMPersonBObj>';
        AsIsBObj += '<PreferredLanguageValue>English</PreferredLanguageValue>';
        AsIsBObj += '<DisplayName>PERSON_ADD</DisplayName>';
        AsIsBObj += '<PartyType>P</PartyType>';
        AsIsBObj += '<SolicitationIndicator>N</SolicitationIndicator>';
        AsIsBObj += '<BirthDate>1980-07-17 00:00:00.0</BirthDate>';
        AsIsBObj += '<GenderType>M</GenderType>';
        AsIsBObj += '<MaritalStatusValue>Married</MaritalStatusValue>';
        AsIsBObj += '<TCRMPartyAddressBObj>';
        AsIsBObj += '<AddressUsageValue>Primary Residence</AddressUsageValue>';
        AsIsBObj += '<StartDate>2000-06-11 00:00:00.0</StartDate>';
        AsIsBObj += '<EndDate>2100-12-30 23:59:59.0</EndDate>';
        AsIsBObj += '<LocationGroupLastUpdateDate>2015-07-15 19:36:31.478</LocationGroupLastUpdateDate>';
        AsIsBObj += '<TCRMAddressBObj>';
        AsIsBObj += '<AddressLineOne>40 Warden ADD 111</AddressLineOne>';
        AsIsBObj += '<AddressLineTwo>31 Woodbine ADD 111</AddressLineTwo>';
        AsIsBObj += '<AddressLineThree>9090 Hwy7 111</AddressLineThree>';
        AsIsBObj += '<City>Toronto0</City>';
        AsIsBObj += '<ProvinceStateValue>ON</ProvinceStateValue>';
        AsIsBObj += '<CountryValue>Canada</CountryValue>';
        AsIsBObj += '<ZipPostalCode>M61C4</ZipPostalCode>';
        AsIsBObj += '</TCRMAddressBObj>';
        AsIsBObj += '</TCRMPartyAddressBObj>';
        AsIsBObj += '<TCRMPartyIdentificationBObj>';
        AsIsBObj += '<IdentificationValue>UCID</IdentificationValue>';
        AsIsBObj += '<IdentificationNumber>3215075310010139</IdentificationNumber>';
        AsIsBObj += '</TCRMPartyIdentificationBObj>';
        AsIsBObj += '</TCRMPersonBObj>';
        AsIsBObj += '</XHondaPartyBObj>';
        AsIsBObj += '</AsIsBObj>';
        
        return AsIsBObj;
   }
   
   public static String getToBeBObj(){
    
    String ToBeObj = '<ToBeBObj>';
        ToBeObj += '<XHondaPartyBObj>';
        ToBeObj += '<TCRMPersonBObj>';
        ToBeObj += '<PreferredLanguageValue>English</PreferredLanguageValue>';
        ToBeObj += '<DisplayName>PERSON_ADD_AAAA</DisplayName>';
        ToBeObj += '<PartyType>P</PartyType>';
        ToBeObj += '<SolicitationIndicator>N</SolicitationIndicator>';
        ToBeObj += '<BirthDate>1980-07-17 00:00:00.0</BirthDate>';
        ToBeObj += '<GenderType>M</GenderType>';
        ToBeObj += '<MaritalStatusValue>Married</MaritalStatusValue>';
        ToBeObj += '<TCRMPartyAddressBObj>';
        ToBeObj += '<AddressUsageValue>Primary Residence</AddressUsageValue>';
        ToBeObj += '<StartDate>2000-06-11 00:00:00.0</StartDate>';
        ToBeObj += '<EndDate>2100-12-30 23:59:59.0</EndDate>';
        ToBeObj += '<LocationGroupLastUpdateDate>2015-07-15 19:36:31.478</LocationGroupLastUpdateDate>';
        ToBeObj += '<TCRMAddressBObj>';
        ToBeObj += '<AddressLineOne>PERSON_ADD_AAAA</AddressLineOne>';
        ToBeObj += '<AddressLineTwo>PERSON_ADD_AAAA</AddressLineTwo>';
        ToBeObj += '<AddressLineThree>PERSON_ADD_AAAA</AddressLineThree>';
        ToBeObj += '<City>Toronto0</City>';
        ToBeObj += '<ProvinceStateValue>ON</ProvinceStateValue>';
        ToBeObj += '<CountryValue>Canada</CountryValue>';
        ToBeObj += '<ZipPostalCode>M6GC4</ZipPostalCode>';
        ToBeObj += '</TCRMAddressBObj>';
        ToBeObj += '</TCRMPartyAddressBObj>';
        ToBeObj += '<TCRMPartyContactMethodBObj>';
        ToBeObj += '<ContactMethodUsageValue>PRIMARY EMAIL</ContactMethodUsageValue>';
        ToBeObj += '<SolicitationIndicator>Y</SolicitationIndicator>';
        ToBeObj += '<StartDate>1998-07-07 00:00:00.0</StartDate>';
        ToBeObj += '<EndDate>2100-12-30 23:59:59.0</EndDate>';
        ToBeObj += '<ContactMethodGroupLastUpdateDate>2015-07-15 19:36:31.494</ContactMethodGroupLastUpdateDate>';
        ToBeObj += '<TCRMContactMethodBObj>';
        ToBeObj += '<ReferenceNumber>AAAA@mail.com</ReferenceNumber>';
        ToBeObj += '<ContactMethodType>2</ContactMethodType>';
        ToBeObj += '<ContactMethodValue>Email Address</ContactMethodValue>';
        ToBeObj += '</TCRMContactMethodBObj>';
        ToBeObj += '</TCRMPartyContactMethodBObj>';
        ToBeObj += '<TCRMPartyContactMethodBObj>';
        ToBeObj += '<ContactMethodUsageValue>MOBILE TELEPHONE</ContactMethodUsageValue>';
        ToBeObj += '<SolicitationIndicator>Y</SolicitationIndicator>';
        ToBeObj += '<StartDate>1998-07-07 00:00:00.0</StartDate>';
        ToBeObj += '<EndDate>2100-12-30 23:59:59.0</EndDate>';
        ToBeObj += '<ContactMethodGroupLastUpdateDate>2015-07-15 19:36:31.494</ContactMethodGroupLastUpdateDate>';
        ToBeObj += '<TCRMContactMethodBObj>';
        ToBeObj += '<ReferenceNumber>123456789</ReferenceNumber>';
        ToBeObj += '<ContactMethodType>1</ContactMethodType>';
        ToBeObj += '<ContactMethodValue>TELEPHONE NUMBER</ContactMethodValue>';
        ToBeObj += '</TCRMContactMethodBObj>';
        ToBeObj += '</TCRMPartyContactMethodBObj>';
        ToBeObj += '<TCRMPartyIdentificationBObj>';
        ToBeObj += '<IdentificationValue>UCID</IdentificationValue>';
        ToBeObj += '<IdentificationNumber>3215075310010139</IdentificationNumber>';
        ToBeObj += '</TCRMPartyIdentificationBObj>';
        ToBeObj += '<TCRMAdminContEquivBObj>';
        ToBeObj += '<AdminSystemType>1</AdminSystemType>';
        ToBeObj += '<AdminSystemValue>CASS</AdminSystemValue>';
        ToBeObj += '<AdminPartyId>811437050</AdminPartyId>';
        ToBeObj += '<ContEquivLastUpdateDate>2015-07-16 18:10:03.292</ContEquivLastUpdateDate>';
        ToBeObj += '<ContEquivLastUpdateUser>RO</ContEquivLastUpdateUser>';
        ToBeObj += '<TCRMExtension>';
        ToBeObj += '<XContEquivBObjExt>';
        ToBeObj += '<XEffectiveStartDate>2000-01-01 00:00:00.0</XEffectiveStartDate>';
        ToBeObj += '<XEffectiveEndDate>2000-01-01 00:00:00.0</XEffectiveEndDate>';
        ToBeObj += '</XContEquivBObjExt>';
        ToBeObj += '</TCRMExtension>';
        ToBeObj += '</TCRMAdminContEquivBObj>';
        ToBeObj += '<TCRMPersonNameBObj>';
        ToBeObj += '<NameUsageType>4</NameUsageType>';
        ToBeObj += '<PrefixValue>Mr.</PrefixValue>';
        ToBeObj += '<GivenNameOne>new person</GivenNameOne>';
        ToBeObj += '<EndDate>2174-12-30 23:59:59.0</EndDate>';
        ToBeObj += '<LastName>addition</LastName>';
        ToBeObj += '<PersonNameLastUpdateDate>2176-12-30 23:59:59.0</PersonNameLastUpdateDate>';
        ToBeObj += '</TCRMPersonNameBObj>';
        ToBeObj += '<TCRMPersonNameBObj>';
        ToBeObj += '<NameUsageType>1</NameUsageType>';
        ToBeObj += '<PrefixValue>Mr.</PrefixValue>';
        ToBeObj += '<GivenNameOne>new person</GivenNameOne>';
        ToBeObj += '<EndDate>2174-12-30 23:59:59.0</EndDate>';
        ToBeObj += '<LastName>addition</LastName>';
        ToBeObj += '<PersonNameLastUpdateDate>2176-12-30 23:59:59.0</PersonNameLastUpdateDate>';
        ToBeObj += '</TCRMPersonNameBObj>';
        
        ToBeObj += '<TCRMPartyPrivPrefBObj>';
        ToBeObj += '<PrivPrefEntity>CONTACT</PrivPrefEntity>';
        ToBeObj += '<PrivPrefReasonType>100002</PrivPrefReasonType>';
        ToBeObj += '<PrivPrefReasonValue>Expressed</PrivPrefReasonValue>';
        ToBeObj += '<PrivPrefType>100008</PrivPrefType>';
        ToBeObj += '<PrivPrefValue>Contact by Mail</PrivPrefValue>';
        ToBeObj += '<PrivPrefCatValue>Dealer</PrivPrefCatValue>';
        ToBeObj += '<PrivPrefActionValue>YES</PrivPrefActionValue>';
        ToBeObj += '</TCRMPartyPrivPrefBObj>';
         
        ToBeObj += '</TCRMPersonBObj>';
        ToBeObj += '<XPartyDealerPreferenceBObj>';
        ToBeObj += '<PreferredDealerCode>06142</PreferredDealerCode>';
        ToBeObj += '<PreferredDealerValue>Test Retail Dealer 1</PreferredDealerValue>';
        ToBeObj += '<PreferredDealerCatType>100001</PreferredDealerCatType>';
        ToBeObj += '<PreferredDealerCatValue>Retail Dealer</PreferredDealerCatValue>';
        ToBeObj += '</XPartyDealerPreferenceBObj>';
        ToBeObj += '<XPartyDealerPreferenceBObj>';
        ToBeObj += '<PreferredDealerValue>Test Retail Dealer 2</PreferredDealerValue>';
        ToBeObj += '<PreferredDealerCatType>100001</PreferredDealerCatType>';
        ToBeObj += '<PreferredDealerCode>06142</PreferredDealerCode>'; 
        ToBeObj += '<EffectiveEndDate>2026-02-03 00:00:00.0</EffectiveEndDate>';
        ToBeObj += '<PreferredDealerCatValue>Retail Dealer</PreferredDealerCatValue>';
        ToBeObj += '</XPartyDealerPreferenceBObj>';
        ToBeObj += '<XPartyProductRoleBObj>';
        ToBeObj += '<RoleValue>Warrantee</RoleValue>';
        ToBeObj += '<EffectiveStartDate>1990-02-02 00:00:00.0</EffectiveStartDate>';
        ToBeObj += '<XPartyProductRoleLastUpdateDate>2015-07-15 19:36:31.513</XPartyProductRoleLastUpdateDate>';
        ToBeObj += '<XProductBObj>';
        ToBeObj += '<ProductSerialNumber>567895345</ProductSerialNumber>';
        ToBeObj += '<ProductValue>H</ProductValue>';
        ToBeObj += '<XProductLastUpdateDate>2015-04-23 12:38:25.278</XProductLastUpdateDate>';
        ToBeObj += '</XProductBObj>';
        ToBeObj += '</XPartyProductRoleBObj>';
        ToBeObj += '<TCRMPartyGroupingBObj>';
        ToBeObj += '<PartyGroupingIdPK>954143696919156288</PartyGroupingIdPK>';
        ToBeObj += '<PartyGroupingName>952443696919147763_321</PartyGroupingName>';
        ToBeObj += '<PartyGroupingDescription>2015071510000139</PartyGroupingDescription>';
        ToBeObj += '<PartyGroupingType>100002</PartyGroupingType>';
        ToBeObj += '<PartyGroupingValue>HouseHold</PartyGroupingValue>';
        ToBeObj += '<StartDate>2015-07-15 19:36:31.568</StartDate>';
        ToBeObj += '<TCRMPartyGroupingAssociationBObj>';
        ToBeObj += '<PartyId>953843696919146531</PartyId>';
        ToBeObj += '<PartyGroupingId>954143696919156288</PartyGroupingId>';
        ToBeObj += '<EffectStartDate>2015-07-15 19:36:31.565</EffectStartDate>';
        ToBeObj += '</TCRMPartyGroupingAssociationBObj>';
        ToBeObj += '</TCRMPartyGroupingBObj>';
        ToBeObj += '</XHondaPartyBObj>';
        ToBeObj += '</ToBeBObj>'; 
        
        return ToBeObj;
    
   }
   /**
    @author       : Shilpa (Deloitte)
    @date         : 24/08/2015
    @description  : static method to create Alert
    @params       : intCount - numbers of records to create
    @return       : list of Alert records
    */
    public static List<Alert__c> createAlerts(Integer intCount){
      List<Alert__c> lstNewAlert =new List<Alert__c>();
             for(Integer i=0;i<intCount;i++){
                Alert__c objAlert = new Alert__c(Name = 'Test Alert'+i,Type__c = 'Legal',Details__c='Test');
                lstNewAlert.add(objAlert);                                                  
             }
             
          return lstNewAlert ;
    }
    /**
    @author       : Piyush (Deloitte)
    @date         : 10/09/2015
    @description  : static method to create Case
    @params       : intCount - numbers of records to create
    @return       : list of Case records
    */
    public static List<Case> createCase(Integer intCount){
      List<Case> lstNewCase =new List<Case>();
             for(Integer i=0;i<intCount;i++){
                Case objCase = new Case(Origin = 'Email',Status = 'New',Web_First_Name__c = 'test',Web_Last_Name__c='test',Web_Postal_Code__c='1234',Web_Transaction__c='123456',Web_Phone__c='1234567890');
                lstNewCase.add(objCase);                                                  
             }
             
          return lstNewCase ;
    }
     /**
    @author       : Piyush (Deloitte)
    @date         : 10/09/2015
    @description  : static method to create User
    @params       : profilename - name of profile, alias - user alias, contId - id of contact, roleName - name of role
    @return       : User Record
    */
    public static User initUser(String profilename,String alias, Id contId, String roleName){
        //Create a User Record in Test Class
        Profile p = [SELECT Id FROM Profile WHERE Name=:profilename ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
    User u = new User(  LastName='Testing'+profilename,
                            email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias = uniqueName.substring(18, 23),
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            IsActive = true,
                            profileId = p.Id 
                            );                    
        if(contId <> null)
            u.ContactId = contId;
        
        if(roleName<> null)
        {      
            List<UserRole> rl = [Select id, name from UserRole where Name=:roleName limit 1 ];
            if(!rl.isEmpty()){
                u.UserRoleId = rl[0].Id;
            }   
        }
        return u;
    }
    /**
    @author       : piyush (Deloitte)
    @date         : 29/09/2015
    @description  : static method to create Technical Issue
    @params       : null
    @return       : Technical Issue Record
    */
    public static Technical_Issue__c createTechnicalIssue(){
        Technical_Issue__c techIssue = new Technical_Issue__c(Symptom_Code_Related__c='problem1,problem2,problem3');             
        return techIssue;
    }
    /**
    @author       : piyush (Deloitte)
    @date         : 29/09/2015
    @description  : static method to create VIN
    @params       : null
    @return       : VIN Record
    */
    public static VIN__c createVin(){
        VIN__c vinRecord = new VIN__c(ProductSerialNumber__c='1234567899567888',ProductLastUpdateDate__c = system.now(),ProductLastUpdateUser__c ='test user',ProductValue__c='12323ewdwd323');             
        return vinRecord;
    }
    /**
    @author       : piyush (Deloitte)
    @date         : 30/09/2015
    @description  : static method to create customer role record
    @params       : null
    @return       : customer role Record
    */
    public static Customer_Role__c createCustomerRole(string contactId){
        Customer_Role__c customerRoleRecord = new Customer_Role__c(Contact__c = contactId,EffectiveStartDate__c =system.now());             
        return customerRoleRecord;
    }
    /**
    @author       : piyush (Deloitte)
    @date         : 01/10/2015
    @description  : static method to create Product record
    @params       : null
    @return       : Product Record
    */
    public static Product__c createProduct(){
        Product__c productRecord = new Product__c(MDL_YR_CD__c='12345',Air_Condition__c ='M',Cylinders__c='6',Door_Type__c='2',Drive_Train__c='Y',Immobilizer_Indicator__c='Y',Model_Code__c='999',Model_Grade_Code__c='099',Model_Group__c='099',Model_Group_Code__c='YYZ',Model_Year__c='2012',Motive_Power__c='1',Product_Line__c='M',Telematic_Flag__c='Y',Transmission_Speed__c='5',Wheelbase__c='Y',XMITN_Code__c='Y',XM_Radio__c='N');             
        return productRecord;
    }
    
    /**
    @author       : piyush (Deloitte)
    @date         : 15/10/2015
    @description  : static method to create Contact Method record
    @params       : null
    @return       : Contact Method Record
    */
    public static ContactMethod__c createContactMethod(string conId){
        ContactMethod__c ContactMethodRecord = new ContactMethod__c(ReferenceNumber__c ='test@test.com',ContactMethodUsageValue__c='Primary Email',ContactMethodValue__c ='Email Address',Contact__c = conId,EndDate__c = system.today() + 10);             
        return ContactMethodRecord;
    }
    /**
    @author       : shilpa (Deloitte)
    @date         : 11/18/2015
    @description  : static method to create Task record
    @params       : null
    @return       : Task Record
    */
    public static Task createTask(){
        Task taskRecord = new Task(Priority='Normal',Subject='Test Task',Status='Not Started');             
        return taskRecord; 
    }
}