<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Request_Confirmation_Email</fullName>
        <description>Request Confirmation Email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>adrianpichardo@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>changliu@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>corneliabatu@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Request_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Request_Updated</fullName>
        <description>Request Updated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Request_Updates</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Equals_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Status Equals New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Request_Status</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Update Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Request Confirmation</fullName>
        <actions>
            <name>Request_Confirmation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Status_Equals_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Subject__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Request Updates</fullName>
        <actions>
            <name>Request_Updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED( Status__c ), ISCHANGED(Reason_for_Decline__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
