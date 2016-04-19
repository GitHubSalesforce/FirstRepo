<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Address_AddressUsag</fullName>
        <field>MDM_Primary_Address_AddressUsageValue__c</field>
        <formula>IF( AND(  
ISBLANK(MailingCity), 
ISBLANK(MailingCountry), 
ISBLANK(MailingState), 
ISBLANK(MailingPostalCode), 
ISBLANK(MailingStreet) 
),
&quot;&quot;, 
&quot;Primary Residence&quot;)</formula>
        <name>Contact MDM Primary Address AddressUsag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Address_Start_Date</fullName>
        <field>MDM_Primary_Address_Start_Date__c</field>
        <formula>IF( AND(  
ISBLANK(MailingCity), 
ISBLANK(MailingCountry), 
ISBLANK(MailingState), 
ISBLANK(MailingPostalCode), 
ISBLANK(MailingStreet) 
),
null, 
NOW())</formula>
        <name>Contact MDM Primary Address Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Email_ContactMethodU</fullName>
        <field>MDM_Primary_Email_ContactMethodUsageValu__c</field>
        <formula>IF(ISBLANK(Email), null, &quot;Primary Email&quot;)</formula>
        <name>Contact MDM Primary Email ContactMethodU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Email_ContactMethodV</fullName>
        <field>MDM_Primary_Email_ContactMethodValue__c</field>
        <formula>IF(ISBLANK(Email), null, &quot;Email Address&quot;)</formula>
        <name>Contact MDM Primary Email ContactMethodV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Email_Start_Date</fullName>
        <field>MDM_Primary_Email_Start_Date__c</field>
        <formula>IF(ISBLANK(Email), null, Now())</formula>
        <name>Contact MDM Primary Email Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Phone_ContactMethodU</fullName>
        <field>MDM_Primary_Phone_ContactMethodUsageValu__c</field>
        <formula>IF(ISBLANK(Phone), null, &quot;Primary Phone&quot;)</formula>
        <name>Contact MDM Primary Phone ContactMethodU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Phone_ContactMethodV</fullName>
        <field>MDM_Primary_Phone_ContactMethodValue__c</field>
        <formula>IF(ISBLANK(Phone), null, &quot;Telephone Number&quot;)</formula>
        <name>Contact MDM Primary Phone ContactMethodV</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_MDM_Primary_Phone_Start_Date</fullName>
        <field>MDM_Primary_Phone_Start_Date__c</field>
        <formula>IF(ISBLANK(Phone), null, Now())</formula>
        <name>Contact MDM Primary Phone Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PartyLastUpdateUser_Field</fullName>
        <field>PartyLastUpdateUser__c</field>
        <formula>LastModifiedBy.Federation_Id__c</formula>
        <name>Set PartyLastUpdateUser Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Party_Type</fullName>
        <description>Party Type field is populated based on the contact record type</description>
        <field>PartyType__c</field>
        <formula>IF( RecordType.DeveloperName = &apos;Organization&apos;, &apos;O&apos;,&apos;P&apos;)</formula>
        <name>Set Party Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PersonLastUpdateUser_Field</fullName>
        <field>PersonLastUpdateUser__c</field>
        <formula>LastModifiedBy.Federation_Id__c</formula>
        <name>Set PersonLastUpdateUser Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Email</fullName>
        <field>HC_Email__c</field>
        <literalValue>NO</literalValue>
        <name>Update CH Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Mail</fullName>
        <field>HC_Mail__c</field>
        <literalValue>NO</literalValue>
        <name>Update CH Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Phone_Text</fullName>
        <field>HC_Phone_Text__c</field>
        <literalValue>NO</literalValue>
        <name>Update CH Phone Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Phone_Voice</fullName>
        <field>HC_Phone_Voice__c</field>
        <literalValue>NO</literalValue>
        <name>Update CH Phone Voice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CH_Social_Media</fullName>
        <field>HC_Social_Media__c</field>
        <literalValue>NO</literalValue>
        <name>Update CH Social Media</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Email</fullName>
        <field>DLR_Email__c</field>
        <literalValue>NO</literalValue>
        <name>Update Dealer Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Mail</fullName>
        <field>DLR_Mail__c</field>
        <literalValue>NO</literalValue>
        <name>Update Dealer Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Phone_Text</fullName>
        <field>DLR_Phone_Text__c</field>
        <literalValue>NO</literalValue>
        <name>Update Dealer Phone Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Phone_Voice</fullName>
        <field>DLR_Phone_Voice__c</field>
        <literalValue>NO</literalValue>
        <name>Update Dealer Phone Voice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dealer_Social_Media</fullName>
        <field>DLR_Social_Media__c</field>
        <literalValue>NO</literalValue>
        <name>Update Dealer Social Media</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HFS_Email</fullName>
        <field>HFS_Email__c</field>
        <literalValue>NO</literalValue>
        <name>Update HFS Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HFS_Mail</fullName>
        <field>HFS_Mail__c</field>
        <literalValue>NO</literalValue>
        <name>Update HFS Mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HFS_Phone_Text</fullName>
        <field>HFS_Phone_Text__c</field>
        <literalValue>NO</literalValue>
        <name>Update HFS Phone Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HFS_Phone_Voice</fullName>
        <field>HFS_Phone_Voice__c</field>
        <literalValue>NO</literalValue>
        <name>Update HFS Phone Voice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_HFS_Social_Media</fullName>
        <field>HFS_Social_Media__c</field>
        <literalValue>NO</literalValue>
        <name>Update HFS Social Media</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Contact_New_From_MDM</fullName>
        <apiVersion>36.0</apiVersion>
        <description>To stop cyclical updates we normally do not update MDM after they update SF.  Contacts that were created from a system other than SF are the exception because we need to send MDM back the SF Id.</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>Id</fields>
        <fields>UCID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Contact New From MDM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Contact_New_From_SF</fullName>
        <apiVersion>35.0</apiVersion>
        <description>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>AccountId</fields>
        <fields>AdminSystemType__c</fields>
        <fields>AdminSystemValue__c</fields>
        <fields>AssistantName</fields>
        <fields>AssistantPhone</fields>
        <fields>Birthdate</fields>
        <fields>Collapsed_UCIDs__c</fields>
        <fields>Correlation_Id__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>CustomerLoyaltyScore__c</fields>
        <fields>DLR_Email__c</fields>
        <fields>DLR_Mail__c</fields>
        <fields>DLR_Phone_Text__c</fields>
        <fields>DLR_Phone_Voice__c</fields>
        <fields>DLR_Social_Media__c</fields>
        <fields>Dealer_Look_up_Postal_Code__c</fields>
        <fields>Department</fields>
        <fields>Description</fields>
        <fields>DoNotCall</fields>
        <fields>Email</fields>
        <fields>EmailBouncedDate</fields>
        <fields>EmailBouncedReason</fields>
        <fields>Employee_Status__c</fields>
        <fields>Fax</fields>
        <fields>Finance_Dealer_Name__c</fields>
        <fields>Finance_dealer__c</fields>
        <fields>FirstName</fields>
        <fields>Gender__c</fields>
        <fields>HC_Email__c</fields>
        <fields>HC_Mail__c</fields>
        <fields>HC_Phone_Text__c</fields>
        <fields>HC_Phone_Voice__c</fields>
        <fields>HC_Social_Media__c</fields>
        <fields>HFS_Email__c</fields>
        <fields>HFS_Mail__c</fields>
        <fields>HFS_Phone_Text__c</fields>
        <fields>HFS_Phone_Voice__c</fields>
        <fields>HFS_Social_Media__c</fields>
        <fields>HasOptedOutOfEmail</fields>
        <fields>HasOptedOutOfFax</fields>
        <fields>HomePhone</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>IsEmailBounced</fields>
        <fields>Jigsaw</fields>
        <fields>JigsawContactId</fields>
        <fields>Job_Title_Current__c</fields>
        <fields>Job_Title_Previous__c</fields>
        <fields>Language_Code__c</fields>
        <fields>LastActivityDate</fields>
        <fields>LastCURequestDate</fields>
        <fields>LastCUUpdateDate</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>LastName</fields>
        <fields>LastReferencedDate</fields>
        <fields>LastViewedDate</fields>
        <fields>LeadSource</fields>
        <fields>LegalGivenNameOne__c</fields>
        <fields>LegalGivenNameTwo__c</fields>
        <fields>LegalSalutation__c</fields>
        <fields>Legal_Name__c</fields>
        <fields>MDM_Primary_Address_AddressUsageValue__c</fields>
        <fields>MDM_Primary_Address_Start_Date__c</fields>
        <fields>MDM_Primary_Email_ContactMethodUsageValu__c</fields>
        <fields>MDM_Primary_Email_ContactMethodValue__c</fields>
        <fields>MDM_Primary_Email_Start_Date__c</fields>
        <fields>MDM_Primary_Phone_ContactMethodUsageValu__c</fields>
        <fields>MDM_Primary_Phone_ContactMethodValue__c</fields>
        <fields>MDM_Primary_Phone_Start_Date__c</fields>
        <fields>MailingCity</fields>
        <fields>MailingCountry</fields>
        <fields>MailingGeocodeAccuracy</fields>
        <fields>MailingLatitude</fields>
        <fields>MailingLongitude</fields>
        <fields>MailingPostalCode</fields>
        <fields>MailingState</fields>
        <fields>MailingStreet</fields>
        <fields>MaritalStatusValue__c</fields>
        <fields>MasterRecordId</fields>
        <fields>MiddleName</fields>
        <fields>MobilePhone</fields>
        <fields>OrganizationName__c</fields>
        <fields>OrganizationValue__c</fields>
        <fields>OtherCity</fields>
        <fields>OtherCountry</fields>
        <fields>OtherGeocodeAccuracy</fields>
        <fields>OtherLatitude</fields>
        <fields>OtherLongitude</fields>
        <fields>OtherPhone</fields>
        <fields>OtherPostalCode</fields>
        <fields>OtherState</fields>
        <fields>OtherStreet</fields>
        <fields>OwnerId</fields>
        <fields>PartyType__c</fields>
        <fields>Phone</fields>
        <fields>PhotoUrl</fields>
        <fields>PreferredDealerValue__c</fields>
        <fields>PreferredLanguage__c</fields>
        <fields>PrefixValue__c</fields>
        <fields>Product_Line__c</fields>
        <fields>RecordTypeId</fields>
        <fields>ReportsToId</fields>
        <fields>Retail_Dealer_Name__c</fields>
        <fields>Retail_dealer__c</fields>
        <fields>Salutation</fields>
        <fields>Secondary_Email__c</fields>
        <fields>Service_Dealer_Name__c</fields>
        <fields>Service_dealer__c</fields>
        <fields>SolicitationIndicator__c</fields>
        <fields>SourceIdentifierValue__c</fields>
        <fields>Split_UCID__c</fields>
        <fields>Start_Date_Dealer__c</fields>
        <fields>Start_Date_Honda__c</fields>
        <fields>Student_Id__c</fields>
        <fields>SystemModstamp</fields>
        <fields>Termination_Date__c</fields>
        <fields>Title</fields>
        <fields>ToBeDeleted__c</fields>
        <fields>UCID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Contact New From SF</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Contact_Update</fullName>
        <apiVersion>36.0</apiVersion>
        <description>https://sfsdsys1:H0nda2015@csg-qa.services.honda.ca/services/salesforce/NotificationService</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>AccountId</fields>
        <fields>AdminSystemType__c</fields>
        <fields>AdminSystemValue__c</fields>
        <fields>AssistantName</fields>
        <fields>AssistantPhone</fields>
        <fields>Birthdate</fields>
        <fields>Collapsed_UCIDs__c</fields>
        <fields>Correlation_Id__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>CustomerLoyaltyScore__c</fields>
        <fields>DLR_Email__c</fields>
        <fields>DLR_Mail__c</fields>
        <fields>DLR_Phone_Text__c</fields>
        <fields>DLR_Phone_Voice__c</fields>
        <fields>DLR_Social_Media__c</fields>
        <fields>Dealer_Look_up_Postal_Code__c</fields>
        <fields>Department</fields>
        <fields>Description</fields>
        <fields>DoNotCall</fields>
        <fields>EmailBouncedDate</fields>
        <fields>EmailBouncedReason</fields>
        <fields>Employee_Status__c</fields>
        <fields>Fax</fields>
        <fields>Finance_Dealer_Name__c</fields>
        <fields>Finance_dealer__c</fields>
        <fields>FirstName</fields>
        <fields>Gender__c</fields>
        <fields>HC_Email__c</fields>
        <fields>HC_Mail__c</fields>
        <fields>HC_Phone_Text__c</fields>
        <fields>HC_Phone_Voice__c</fields>
        <fields>HC_Social_Media__c</fields>
        <fields>HFS_Email__c</fields>
        <fields>HFS_Mail__c</fields>
        <fields>HFS_Phone_Text__c</fields>
        <fields>HFS_Phone_Voice__c</fields>
        <fields>HFS_Social_Media__c</fields>
        <fields>HasOptedOutOfEmail</fields>
        <fields>HasOptedOutOfFax</fields>
        <fields>HomePhone</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>IsEmailBounced</fields>
        <fields>Jigsaw</fields>
        <fields>JigsawContactId</fields>
        <fields>Job_Title_Current__c</fields>
        <fields>Job_Title_Previous__c</fields>
        <fields>Language_Code__c</fields>
        <fields>LastActivityDate</fields>
        <fields>LastCURequestDate</fields>
        <fields>LastCUUpdateDate</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>LastName</fields>
        <fields>LastReferencedDate</fields>
        <fields>LastViewedDate</fields>
        <fields>LeadSource</fields>
        <fields>LegalGivenNameOne__c</fields>
        <fields>LegalGivenNameTwo__c</fields>
        <fields>LegalSalutation__c</fields>
        <fields>Legal_Name__c</fields>
        <fields>MaritalStatusValue__c</fields>
        <fields>MasterRecordId</fields>
        <fields>MiddleName</fields>
        <fields>MobilePhone</fields>
        <fields>OrganizationName__c</fields>
        <fields>OrganizationValue__c</fields>
        <fields>OtherCity</fields>
        <fields>OtherCountry</fields>
        <fields>OtherGeocodeAccuracy</fields>
        <fields>OtherLatitude</fields>
        <fields>OtherLongitude</fields>
        <fields>OtherPhone</fields>
        <fields>OtherPostalCode</fields>
        <fields>OtherState</fields>
        <fields>OtherStreet</fields>
        <fields>OwnerId</fields>
        <fields>PartyType__c</fields>
        <fields>PhotoUrl</fields>
        <fields>PreferredDealerValue__c</fields>
        <fields>PreferredLanguage__c</fields>
        <fields>PrefixValue__c</fields>
        <fields>Product_Line__c</fields>
        <fields>RecordTypeId</fields>
        <fields>ReportsToId</fields>
        <fields>Retail_Dealer_Name__c</fields>
        <fields>Retail_dealer__c</fields>
        <fields>Salutation</fields>
        <fields>Secondary_Email__c</fields>
        <fields>Service_Dealer_Name__c</fields>
        <fields>Service_dealer__c</fields>
        <fields>SolicitationIndicator__c</fields>
        <fields>SourceIdentifierValue__c</fields>
        <fields>Split_UCID__c</fields>
        <fields>Start_Date_Dealer__c</fields>
        <fields>Start_Date_Honda__c</fields>
        <fields>Student_Id__c</fields>
        <fields>SystemModstamp</fields>
        <fields>Termination_Date__c</fields>
        <fields>Title</fields>
        <fields>ToBeDeleted__c</fields>
        <fields>UCID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Contact Update</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Contact - LastUpdateUser</fullName>
        <actions>
            <name>Set_PartyLastUpdateUser_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_PersonLastUpdateUser_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate LastUpdateUser fields with the LastModifiedBy user&apos;s federation Id.</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp;  ISCHANGED(LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Contact New From MDM</fullName>
        <actions>
            <name>Contact_New_From_MDM</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends SF Contact Id if it originates from MDM to CSG to pass to MDM.

Rule1: If LastModified is not a user with Do Not Send Workflows checked. 
OR
Rule2: If contact is a new record and it was created by user with a last name starting with “API - MDM”</description>
        <formula>AND(   NOT(ISBLANK(UCID__c)),   BEGINS( CreatedBy.LastName, &quot;API - MDM&quot;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Contact New From SF</fullName>
        <actions>
            <name>Contact_New_From_SF</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends SF Contact when it originates from SF to CSG to pass on to MDM. 
Rule1: If LastModified is not a user with Do Not Send Workflows checked. 
OR 
Rule2: If contact is a new record and it was created by user with a last name starting with “API - MDM”</description>
        <formula>OR(  AND(    NOT(ISBLANK(MailingCity)),   NOT(ISBLANK(MailingCountry)),   NOT(ISBLANK(MailingState)),   NOT(ISBLANK(MailingPostalCode)),   NOT(ISBLANK(MailingStreet)),   NOT(LastModifiedBy.Do_Not_Fire_Workflows__c)  ),    NOT(ISBLANK(Collapsed_UCIDs__c)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Contact Update</fullName>
        <actions>
            <name>Contact_Update</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends Contact object to CSG to pass on to MDM.

Rule1: If LastModified is not a user with Do Not Send Workflows checked. 
OR
Rule2: If contact is a new record and it was created by user with a last name starting with “API - MDM”</description>
        <formula>AND(   NOT( ISNEW() ),   NOT( LastModifiedBy.Do_Not_Fire_Workflows__c )	    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MDM - Always Run These Field Updates</fullName>
        <actions>
            <name>Contact_MDM_Primary_Address_AddressUsag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Address_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Email_ContactMethodU</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Email_ContactMethodV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Email_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Phone_ContactMethodU</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Phone_ContactMethodV</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_MDM_Primary_Phone_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sets the static field for CSG if the related primary fields are populated otherwise leaves the static field blank so it is ommited by the WF OB message.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Party Type</fullName>
        <actions>
            <name>Set_Party_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Populates Party Type based on the Record Type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PopulateGranularFields</fullName>
        <actions>
            <name>Update_CH_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CH_Mail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CH_Phone_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CH_Phone_Voice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_CH_Social_Media</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Mail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Phone_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Phone_Voice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Dealer_Social_Media</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Solicitication Indicator is set to N, sets all the granular fields to NO.</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp;   ISPICKVAL( SolicitationIndicator__c , &apos;N&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PopulateHFSGranularFields</fullName>
        <actions>
            <name>Update_HFS_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_HFS_Mail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_HFS_Phone_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_HFS_Phone_Voice</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_HFS_Social_Media</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Solicitication Indicator is set to N, sets all the granular fields to NO.</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp;   ISPICKVAL( SolicitationIndicator__c , &apos;N&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
