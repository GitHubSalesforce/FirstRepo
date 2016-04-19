<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_UCID</fullName>
        <field>UCID__c</field>
        <formula>Contact__r.UCID__c</formula>
        <name>Contact UCID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ContactMethGroupLastUpdateUser</fullName>
        <field>ContactMethodGroupLastUpdateUser__c</field>
        <formula>LastModifiedBy.Federation_Id__c</formula>
        <name>Set ContactMethGroupLastUpdateUser</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SourceIdentifier</fullName>
        <field>SourceIdentifierValue__c</field>
        <literalValue>SFSD</literalValue>
        <name>Update SourceIdentifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Contact_Method_Changes</fullName>
        <apiVersion>34.0</apiVersion>
        <description>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</description>
        <endpointUrl>https://sfsdsys1:H0nda2015@csg-dev.services.honda.ca/services/salesforce/NotificationService</endpointUrl>
        <fields>ContactMethodType__c</fields>
        <fields>ContactMethodUsageValue__c</fields>
        <fields>ContactMethodValue__c</fields>
        <fields>Contact__c</fields>
        <fields>Correlation_Id__c</fields>
        <fields>CreatedById</fields>
        <fields>CreatedDate</fields>
        <fields>EndDate__c</fields>
        <fields>Id</fields>
        <fields>IsDeleted</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Name</fields>
        <fields>ReferenceNumber__c</fields>
        <fields>SourceIdentifierValue__c</fields>
        <fields>StartDate__c</fields>
        <fields>SystemModstamp</fields>
        <fields>UCID__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>Contact Method Changes</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ContactMethod - LastUpdateUser</fullName>
        <actions>
            <name>Set_ContactMethGroupLastUpdateUser</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate LastUpdateUser fields with the LastModifiedBy user&apos;s federation Id</description>
        <formula>NOT(BEGINS($Profile.Name, &quot;API -&quot;)) &amp;&amp; ISCHANGED(LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fire WF Outbound Message - Contact Method</fullName>
        <actions>
            <name>Contact_Method_Changes</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends Contact Method object to CSG to pass on to MDM.
Rule:Do not send Primary emails and phones</description>
        <formula>AND(   NOT( LastModifiedBy.Do_Not_Fire_Workflows__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update UCID Contact Method</fullName>
        <actions>
            <name>Contact_UCID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_SourceIdentifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>if(BEGINS(LastModifiedBy.Profile.Name,&quot;API -&quot;),false,true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
