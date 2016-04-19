<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Expire_PIN</fullName>
        <description>Set the Status to Expired</description>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Expire PIN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Expire_PIN_Auto_Time</fullName>
        <description>Set the PIN status to Expired</description>
        <field>Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Expire PIN Auto Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Expire PIN</fullName>
        <actions>
            <name>Expire_PIN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PIN__c.PIN_Expiry__c</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Set the PIN to expired when the campaign Expire PIN date has passed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expire_PIN_Auto_Time</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>PIN__c.PIN_Expiry__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
