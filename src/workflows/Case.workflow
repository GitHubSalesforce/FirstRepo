<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_case_owner</fullName>
        <description>Email case owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Automatic_Email_Templates/Internal_Email_Case_status_changed_for_you</template>
    </alerts>
    <alerts>
        <fullName>Loss_of_Life_Legal</fullName>
        <description>Loss of Life - Legal</description>
        <protected>false</protected>
        <recipients>
            <recipient>Legal_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Automatic_Email_Templates/Honda_Layout_A_Rank_Loss_of_Life_EN</template>
    </alerts>
    <alerts>
        <fullName>MCPE_Notification_Buy_Back_Resolution_Alert</fullName>
        <description>MCPE Notification - Buy Back Resolution Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>MCPE_Tech_Line_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Tech_Line_and_Warranty_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>MCPE_Templates/Honda_Layout_Resolution_Alert_EN</template>
    </alerts>
    <alerts>
        <fullName>MCPE_Notification_Buy_Back_for_Quality_Engineering_Alert</fullName>
        <description>MCPE Notification - Buy Back for Quality Engineering Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>MCPE_Tech_Line_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Quality_Engineering_Manager</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Tech_Line_and_Warranty_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>MCPE_Templates/Honda_Layout_Resolution_Alert_EN</template>
    </alerts>
    <alerts>
        <fullName>MCPE_Notification_Sent_to_CH_for_repair_Alert</fullName>
        <description>MCPE Notification - Sent to CH for repair Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>MCPE_Tech_Line_Supervisor</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Tech_Line_and_Warranty_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>MCPE_Templates/Honda_Layout_Resolution_Alert_EN</template>
    </alerts>
    <alerts>
        <fullName>Related_Case_Closed</fullName>
        <description>Related Case Closed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Automatic_Email_Templates/Internal_Email_Related_Case_Closed</template>
    </alerts>
    <fieldUpdates>
        <fullName>CRM_Report_Decline_Approved</fullName>
        <field>CRM_Report_Decline_Status__c</field>
        <literalValue>Decline Approved</literalValue>
        <name>CRM Report Decline Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Report_Decline_Open</fullName>
        <field>CRM_Report_Decline_Status__c</field>
        <literalValue>Open</literalValue>
        <name>CRM Report Decline Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Report_Decline_Pending</fullName>
        <field>CRM_Report_Decline_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>CRM Report Decline Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRM_Report_Decline_Rejected</fullName>
        <field>CRM_Report_Decline_Status__c</field>
        <literalValue>Decline Rejected</literalValue>
        <name>CRM Report Decline Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Open</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Case Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_CQC_Manager</fullName>
        <description>CCG Goodwill Gas Card post approval case tansfer</description>
        <field>OwnerId</field>
        <lookupValue>Customer_Quality_Centre_Managers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to CQC Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_to_Customer_Accounting</fullName>
        <description>CCG Goodwill, post approval, case transfer to accounting</description>
        <field>OwnerId</field>
        <lookupValue>Customer_Accounting_Analysts</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Owner to Customer Accounting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Collection_Case_Origin_Email</fullName>
        <field>Origin</field>
        <literalValue>Email - Collections</literalValue>
        <name>Collection Case Origin Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Subject_to_Summary</fullName>
        <field>Case_Summary__c</field>
        <formula>LEFT(Subject, 50)</formula>
        <name>Copy Subject to Summary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lease_Extension_Approved</fullName>
        <field>Lease_Extension_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Lease Extension Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lease_Extension_Declined</fullName>
        <field>Lease_Extension_Approval_Status__c</field>
        <literalValue>Declined</literalValue>
        <name>Lease Extension Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lease_Extension_Open</fullName>
        <field>Lease_Extension_Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Lease Extension Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lease_Extension_Pending</fullName>
        <field>Lease_Extension_Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Lease Extension Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Process Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Declined</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Declined</literalValue>
        <name>Process Declined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Open</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Open</literalValue>
        <name>Process Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Process Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Auto_Tech_Line_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Auto Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Auto_Tech_Line</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Auto Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CCG_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_CCG_Goodwill_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CCG Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CCG_Goodwill_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_CCG_Goodwill</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CCG Goodwill Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CRC_ACS_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Customer_Retention_Centre_and_Acura_Concierge_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CRC/ACS Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CRC_ACS_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Customer_Retention_Centre_and_Acura_Concierge</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CRC/ACS Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CRM_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_CRM_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CRM Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CRM_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_CRM</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CRM Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Alt_Transp_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Alternative_Transportation_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Alt Transp Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Alt_Transp_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Alternative_Transportation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Alt Transp Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Campaign_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Campaign_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Campaign Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Campaign_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Campaign</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Campaign Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Escalation_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Escalation_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Escalation Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Escalation_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Escalation</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Escalation Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Feedback_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Feedback_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Feedback Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Feedback_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Feedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Feedback Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Finan_Assist_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Financial_Assistance_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Finan Assist Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Finan_Assist_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Financial_Assistance</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Finan Assist Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Inquiry_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Inquiry_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Inquiry Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Inquiry_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Inquiry</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Inquiry Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Technical_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Technical_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Technical Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Technical_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Technical</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Technical Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Update_Info_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Update_Information_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Update Info Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CR_Update_Info_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Customer_Relations_Update_Information</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set CR Update Info Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Coll_Recov_Reso_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Collections_Recovery_and_Resolution_Centre_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Coll Recov Reso Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Coll_Recov_Resol_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Collections_Recovery_and_Resolution_Centre</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Coll Recov Resol Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Created_By_Group_Role</fullName>
        <field>Created_By_Group_Role__c</field>
        <formula>$UserRole.Name</formula>
        <name>Set Created By Group &amp; Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Customer_Servic_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Customer_Service_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Customer Servic Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Customer_Service_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Customer_Service</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Customer Service Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DCD_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_DCD_Parts_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set DCD Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DCD_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_DCD_Parts</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set DCD Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DFS_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Dealer_Financial_Services_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set DFS Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DFS_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>HFS_Dealer_Financial_Services</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set DFS Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Acura_Concierge</fullName>
        <field>Group__c</field>
        <literalValue>Acura Concierge</literalValue>
        <name>Set Group to Acura Concierge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Auto_Tech_Line</fullName>
        <field>Group__c</field>
        <literalValue>Auto Tech Line</literalValue>
        <name>Set Group to Auto Tech Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_CRM</fullName>
        <field>Group__c</field>
        <literalValue>CRM</literalValue>
        <name>Set Group to CRM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Collections</fullName>
        <field>Group__c</field>
        <literalValue>Collections</literalValue>
        <name>Set Group to Collections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Customer_Relations</fullName>
        <field>Group__c</field>
        <literalValue>Customer Relations</literalValue>
        <name>Set Group to Customer Relations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Customer_Service</fullName>
        <field>Group__c</field>
        <literalValue>Customer Service</literalValue>
        <name>Set Group to Customer Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_DCD</fullName>
        <field>Group__c</field>
        <literalValue>DCD Parts</literalValue>
        <name>Set Group to DCD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_DFS</fullName>
        <field>Group__c</field>
        <literalValue>Dealer Financial Services</literalValue>
        <name>Set Group to DFS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_MCPE_Tech_Line</fullName>
        <field>Group__c</field>
        <literalValue>MCPE Tech Line</literalValue>
        <name>Set Group to MCPE Tech Line</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Recovery</fullName>
        <field>Group__c</field>
        <literalValue>Recovery Centre</literalValue>
        <name>Set Group to Recovery</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Resolution</fullName>
        <field>Group__c</field>
        <literalValue>Resolution Centre</literalValue>
        <name>Set Group to Resolution</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Retention</fullName>
        <field>Group__c</field>
        <literalValue>Customer Retention Centre (CRC)</literalValue>
        <name>Set Group to Retention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Group_to_Warranty_Plus</fullName>
        <field>Group__c</field>
        <literalValue>Warranty Plus</literalValue>
        <name>Set Group to Warranty Plus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MCPE_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_MCPE_Tech_Line_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set MCPE Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MCPE_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_MCPE_Tech_Line</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set MCPE Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rank_to_A</fullName>
        <field>Tech_Rank__c</field>
        <literalValue>A - Safety Concern</literalValue>
        <name>Set Rank to A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Warranty_Case_Closed_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Warranty_Plus_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Warranty Case Closed Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Warranty_Case_Open_Rec_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CH_Warranty_Plus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Warranty Case Open Rec Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>B_S_Case_New_OB_Message</fullName>
        <apiVersion>35.0</apiVersion>
        <description>Outbound Message for newly created Case objects
https://routing-dev.services.honda.ca/Case</description>
        <endpointUrl>https://routing-dev.services.honda.ca/Case</endpointUrl>
        <fields>CaseNumber</fields>
        <fields>Id</fields>
        <fields>Origin</fields>
        <fields>OwnerId</fields>
        <fields>Status</fields>
        <fields>Subject</fields>
        <fields>SuppliedEmail</fields>
        <fields>SuppliedName</fields>
        <fields>Type</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>api.mdm@ch.honda.com</integrationUser>
        <name>B+S Case New OB Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Auto - A Rank category</fullName>
        <actions>
            <name>Set_Rank_to_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c, &quot;Auto Tech Line&quot;) &amp;&amp; ISPICKVAL( Category_Level_1__c , &quot;A Rank&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>B%2BS Case New</fullName>
        <actions>
            <name>B_S_Case_New_OB_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>startsWith</operation>
            <value>Email -</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Acura Concierge Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Acura_Concierge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Acura Concierge</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Always On Create</fullName>
        <actions>
            <name>Set_Created_By_Group_Role</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Auto Tech Line Closed</fullName>
        <actions>
            <name>Set_Auto_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Auto_Tech_Line&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Auto Tech Line Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Auto_Tech_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Honda Auto Tech Line</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Auto Tech Line Reopened</fullName>
        <actions>
            <name>Set_Auto_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Auto_Tech_Line_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CCG Goodwill Closed</fullName>
        <actions>
            <name>Set_CCG_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp;  RecordType.DeveloperName == &quot;HFS_CCG_Goodwill&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CCG Goodwill Reopened</fullName>
        <actions>
            <name>Set_CCG_Goodwill_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_CCG_Goodwill_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Alt Transp Closed</fullName>
        <actions>
            <name>Set_CR_Alt_Transp_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; ISPICKVAL(Group__c, &quot;Customer Relations&quot;) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Alternative_Transportation&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Alt Transp Reopened</fullName>
        <actions>
            <name>Set_CR_Alt_Transp_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; ISPICKVAL(Group__c, &quot;Customer Relations&quot;) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Alternative_Transportation_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Campaign Closed</fullName>
        <actions>
            <name>Set_CR_Campaign_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Campaign&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Campaign Reopened</fullName>
        <actions>
            <name>Set_CR_Campaign_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Campaign_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Customer_Relations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Honda Canada CUSTR,Email - Acura Canada Client Services,Email - CR Rental Support,Email - CR Goodwill Request,Email - Second Level Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Escalation Closed</fullName>
        <actions>
            <name>Set_CR_Escalation_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Escalation&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Escalation Reopened</fullName>
        <actions>
            <name>Set_CR_Escalation_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Escalation_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Feedback Closed</fullName>
        <actions>
            <name>Set_CR_Feedback_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Feedback&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Feedback Reopened</fullName>
        <actions>
            <name>Set_CR_Feedback_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Feedback_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Finan Assist Closed</fullName>
        <actions>
            <name>Set_CR_Finan_Assist_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Financial_Assistance&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Finan Assist Reopened</fullName>
        <actions>
            <name>Set_CR_Finan_Assist_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Financial_Assistance_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Inquiry Closed</fullName>
        <actions>
            <name>Set_CR_Inquiry_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Inquiry&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Inquiry Reopened</fullName>
        <actions>
            <name>Set_CR_Inquiry_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Inquiry_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Technical Closed</fullName>
        <actions>
            <name>Set_CR_Technical_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Technical&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Technical Reopened</fullName>
        <actions>
            <name>Set_CR_Technical_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Technical_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Update Info Closed</fullName>
        <actions>
            <name>Set_CR_Update_Info_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Update_Information&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CR Update Info Reopened</fullName>
        <actions>
            <name>Set_CR_Update_Info_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Update_Information_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CRC%2FACS Closed</fullName>
        <actions>
            <name>Set_CRC_ACS_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp;  RecordType.DeveloperName == &quot;HFS_Customer_Retention_Centre_and_Acura_Concierge&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CRC%2FACS Reopened</fullName>
        <actions>
            <name>Set_CRC_ACS_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_Customer_Retention_Centre_and_Acura_Concierge_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CRM Closed</fullName>
        <actions>
            <name>Set_CRM_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_CRM&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - CRM Email to Case</fullName>
        <actions>
            <name>Set_Group_to_CRM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Customer Experience</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - CRM Reopened</fullName>
        <actions>
            <name>Set_CRM_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_CRM_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Collaboration Case Closed</fullName>
        <actions>
            <name>Related_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(ISPICKVAL( Status, &quot;Closed&quot;) || ISPICKVAL( Status,&quot;Cancelled&quot;)) &amp;&amp; ( (NOT(ISBLANK(ParentId)) &amp;&amp; ($User.Id != Parent.OwnerId) )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Collections Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Collections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Collections</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Collections Recovery Resolution Closed</fullName>
        <actions>
            <name>Set_Coll_Recov_Reso_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp;  RecordType.DeveloperName == &quot;HFS_Collections_Recovery_and_Resolution_Centre&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Collections Recovery Resolution Reopened</fullName>
        <actions>
            <name>Set_Coll_Recov_Resol_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_Collections_Recovery_and_Resolution_Centre_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Customer Service Closed</fullName>
        <actions>
            <name>Set_Customer_Servic_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp;  RecordType.DeveloperName == &quot;HFS_Customer_Service&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Customer Service Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Customer_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Customer Service,Email - Customer Service Internal</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Customer Service Reopened</fullName>
        <actions>
            <name>Set_Customer_Service_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_Customer_Service_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - DCD Email to Case</fullName>
        <actions>
            <name>Set_Group_to_DCD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - CH DCD,Email - Special Order Parts,Email - USA SRS</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - DCD Parts Closed</fullName>
        <actions>
            <name>Set_DCD_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_DCD_Parts&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - DCD Parts Reopened</fullName>
        <actions>
            <name>Set_DCD_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_DCD_Parts_Closed&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Open&quot;) || ISPICKVAL(Status, &quot;Pending for Dealer&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - DFS Closed</fullName>
        <actions>
            <name>Set_DFS_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_Dealer_Financial_Services&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - DFS Email to Case</fullName>
        <actions>
            <name>Set_Group_to_DFS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Dealer Financial Services</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - DFS Reopened</fullName>
        <actions>
            <name>Set_DFS_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;HFS_Dealer_Financial_Services_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Loss of Life</fullName>
        <actions>
            <name>Loss_of_Life_Legal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(ISPICKVAL(Group__c, &quot;Auto Tech Line&quot;) || ISPICKVAL(Group__c, &quot;MCPE Tech Line&quot;) || ISPICKVAL(Group__c, &quot;Customer Relations&quot;) ) &amp;&amp; INCLUDES(Case_Contention__c, &quot;Loss of Life&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - MCPE Tech Line Closed</fullName>
        <actions>
            <name>Set_MCPE_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_MCPE_Tech_Line&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - MCPE Tech Line Email to Case</fullName>
        <actions>
            <name>Set_Group_to_MCPE_Tech_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Honda MCPE</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - MCPE Tech Line Reopened</fullName>
        <actions>
            <name>Set_MCPE_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_MCPE_Tech_Line_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Recovery Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Recovery</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - National Recovery Centre</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Resolution Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Resolution</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Insurance Tracking</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Retention Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Retention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Customer Retention</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Status Changed%2C Not Owner</fullName>
        <actions>
            <name>Email_case_owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW()) &amp;&amp; ISCHANGED(Status) &amp;&amp; ($User.Id &lt;&gt;  OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Warranty Plus Closed</fullName>
        <actions>
            <name>Set_Warranty_Case_Closed_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Warranty_Plus&quot; &amp;&amp; (ISPICKVAL(Status, &quot;Closed&quot;) || ISPICKVAL(Status, &quot;Cancelled&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case - Warranty Plus Email to Case</fullName>
        <actions>
            <name>Set_Group_to_Warranty_Plus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Honda Acura Plus,Email - Warranty</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case - Warranty Plus Reopened</fullName>
        <actions>
            <name>Set_Warranty_Case_Open_Rec_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status) &amp;&amp; RecordType.DeveloperName == &quot;CH_Warranty_Plus_Closed&quot; &amp;&amp; ISPICKVAL(Status, &quot;Open&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Approval - CCG Goodwill Reset Status</fullName>
        <actions>
            <name>Process_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName == &quot;HFS_CCG_Goodwill&quot; &amp;&amp; (ISPICKVAL(Approval_Status__c, &quot;Declined&quot;) || ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)) &amp;&amp; ISCHANGED(Goodwill_Amount__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Approval - CRM Report Approval Reset Status</fullName>
        <actions>
            <name>CRM_Report_Decline_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c , &quot;CRM&quot;) &amp;&amp; RecordType.DeveloperName == &quot;CH_CRM&quot; &amp;&amp; (ISPICKVAL(CRM_Report_Decline_Status__c, &quot;Decline Approved&quot;) || ISPICKVAL(CRM_Report_Decline_Status__c, &quot;Decline Rejected&quot;)) &amp;&amp; ISCHANGED(Resolution_Level_1__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Approval - Campaign Reset Status</fullName>
        <actions>
            <name>Process_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c , &quot;Customer Relations&quot;) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Campaign&quot; &amp;&amp; (ISPICKVAL(Approval_Status__c, &quot;Declined&quot;) || ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)) &amp;&amp; ISCHANGED(Total_Amount__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Approval - End of Term Waiver Reset Status</fullName>
        <actions>
            <name>Process_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.DeveloperName == &quot;HFS_Customer_Retention_Centre_and_Acura_Concierge&quot; &amp;&amp; (ISPICKVAL(Approval_Status__c, &quot;Declined&quot;) || ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)) &amp;&amp; (ISCHANGED(Loyalty_Waiver__c) || ISCHANGED(Long_Term_Loyalty_Waiver__c) || ISCHANGED(Low_Kilometer_Waiver__c) || ISCHANGED(Goodwill_Waiver__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Approval - Financial Assistance Reset Status</fullName>
        <actions>
            <name>Process_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c , &quot;Customer Relations&quot;) &amp;&amp; RecordType.DeveloperName == &quot;CH_Customer_Relations_Financial_Assistance&quot; &amp;&amp; (ISPICKVAL(Approval_Status__c, &quot;Declined&quot;) || ISPICKVAL(Approval_Status__c, &quot;Approved&quot;)) &amp;&amp; (ISCHANGED(Total_Honda_Canada_Contribution__c) || ISCHANGED(Sales_Credit__c) || ISCHANGED(Service_Credit__c) || ISCHANGED(Reimbursement__c) || ISCHANGED(Buy_Back__c) || ISCHANGED(Trade_Assist__c) || ISCHANGED(Judgment__c) || ISCHANGED(Settlement__c) || ISCHANGED(Honda_Acura__c) || ISCHANGED(Other_Contribution__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Origin Change to Email</fullName>
        <actions>
            <name>Collection_Case_Origin_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email - Collections</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email to Case - Subject and Knowledge Search</fullName>
        <actions>
            <name>Copy_Subject_to_Summary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>startsWith</operation>
            <value>Email -</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>MCPE - Buy Back - Repair Exceeds Unit Value notification</fullName>
        <actions>
            <name>MCPE_Notification_Buy_Back_Resolution_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c, &quot;MCPE Tech Line&quot;) &amp;&amp; INCLUDES(Tech_Line_Resolution__c, &quot;BuyBack - Repair Exceeds Unit Value&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MCPE - Buy Back for Quality Engineering notification</fullName>
        <actions>
            <name>MCPE_Notification_Buy_Back_for_Quality_Engineering_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c, &quot;MCPE Tech Line&quot;) &amp;&amp; INCLUDES(Tech_Line_Resolution__c, &quot;Buy Back for Quality Engineering&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MCPE - Sent to CH for repair notification</fullName>
        <actions>
            <name>MCPE_Notification_Sent_to_CH_for_repair_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Group__c, &quot;MCPE Tech Line&quot;) &amp;&amp; INCLUDES(Tech_Line_Resolution__c, &quot;Product sent to CH for repair&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>testWorkflowRule</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
