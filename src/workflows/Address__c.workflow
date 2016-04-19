<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_LocationGroupLastUpdateUser_Field</fullName>
        <field>LocationGroupLastUpdateUser__c</field>
        <formula>LastModifiedBy.Federation_Id__c</formula>
        <name>Set LocationGroupLastUpdateUser Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Address_SourceIdentifier</fullName>
        <field>SourceIdentifierValue__c</field>
        <formula>&quot;SFSD&quot;</formula>
        <name>Update Address SourceIdentifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Address_UCID</fullName>
        <field>UCID__c</field>
        <formula>Contact__r.UCID__c</formula>
        <name>Update Address UCID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Address_Changes</fullName>
        <apiVersion>34.0</apiVersion>
        <description>https://sfsdsys1:H0nda2015@csg-qa.services.honda.ca/services/salesforce/NotificationService</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>AddressLineOne__c</fields>
        <fields>AddressLineThree__c</fields>
        <fields>AddressLineTwo__c</fields>
        <fields>AddressUsageValue__c</fields>
        <fields>City__c</fields>
        <fields>Contact__c</fields>
        <fields>Correlation_Id__c</fields>
        <fields>CountryValue__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>EndDate__c</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Name</fields>
        <fields>OwnerId</fields>
        <fields>ProvinceStateValue__c</fields>
        <fields>SourceIdentifierValue__c</fields>
        <fields>StartDate__c</fields>
        <fields>SystemModstamp</fields>
        <fields>UCID__c</fields>
        <fields>ValueString__c</fields>
        <fields>ZipPostalCode__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Address Changes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Address - LastUpdateUser</fullName>
        <actions>
            <name>Set_LocationGroupLastUpdateUser_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate LastUpdateUser fields with the LastModifiedBy user&apos;s federation Id</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp; ISCHANGED(LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Address</fullName>
        <actions>
            <name>Address_Changes</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends Address object to CSG to pass on to MDM.</description>
        <formula>AND(   NOT( LastModifiedBy.Do_Not_Fire_Workflows__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update UCID Address</fullName>
        <actions>
            <name>Update_Address_SourceIdentifier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Address_UCID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(BEGINS(LastModifiedBy.Profile.Name,&quot;API -&quot;),false,true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
