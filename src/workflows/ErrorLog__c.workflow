<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Webservice_Error_Log_Notification</fullName>
        <description>Webservice Error Log Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>christine_zhou@ch.honda.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ErrorLog_Templates/Webservice_Error_Log_Notification</template>
    </alerts>
    <rules>
        <fullName>ErrorLog Notification</fullName>
        <actions>
            <name>Webservice_Error_Log_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ErrorLog__c.Type__c</field>
            <operation>equals</operation>
            <value>Webservice (MDM) - Inbound,Webservice (MDM) - Outbound</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
