<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_PartyProductRoleLastUpdateUser</fullName>
        <field>PartyProductRoleLastUpdateUser__c</field>
        <formula>LastModifiedBy.Federation_Id__c</formula>
        <name>Set PartyProductRoleLastUpdateUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Role_Value</fullName>
        <field>Role_Value_search__c</field>
        <formula>TEXT(RoleValue__c)</formula>
        <name>Set Role Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Customer_Role_Changes2</fullName>
        <apiVersion>35.0</apiVersion>
        <description>https://sfsdsys1:H0nda2015@csg-qa.services.honda.ca/services/salesforce/NotificationService</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>Contact__c</fields>
        <fields>Correlation_Id__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>EffectiveEndDate__c</fields>
        <fields>EffectiveStartDate__c</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Model_Group_search__c</fields>
        <fields>Model_Year_search__c</fields>
        <fields>Name</fields>
        <fields>ProductValue__c</fields>
        <fields>Product_Line__c</fields>
        <fields>Product_Line_search__c</fields>
        <fields>RoleValue__c</fields>
        <fields>Role_Value_search__c</fields>
        <fields>SystemModstamp</fields>
        <fields>UCID__c</fields>
        <fields>VIN_Serial_No__c</fields>
        <fields>VIN_Serial_No_search__c</fields>
        <fields>VIN__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Customer Role Changes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Customer Role - Always on Create or Edit</fullName>
        <actions>
            <name>Set_Role_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CustomerRole - LastUpdateUser</fullName>
        <actions>
            <name>Set_PartyProductRoleLastUpdateUser</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate LastUpdateUser fields with the LastModifiedBy user&apos;s federation Id</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp; ISCHANGED(LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Customer Role</fullName>
        <actions>
            <name>Customer_Role_Changes2</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends Customer Role object to CSG to pass on to MDM.</description>
        <formula>AND(   NOT( LastModifiedBy.Do_Not_Fire_Workflows__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
