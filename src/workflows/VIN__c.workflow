<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_ProductValue</fullName>
        <description>MDM needs the ProductValue but ODS does not pass it so we are just pulling it from the Product ourselves.</description>
        <field>ProductValue__c</field>
        <formula>TEXT(Product__r.Product_Line__c)</formula>
        <name>Update ProductValue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VIN - ProductValue</fullName>
        <actions>
            <name>Update_ProductValue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>VIN__c.ProductValue__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>MDM needs the product value but ODS does not provide this in the VIN feed.  It is on the product though.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
