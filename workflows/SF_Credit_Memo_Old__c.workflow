<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Credit_Memo_Entered_For_Approval</fullName>
        <description>Credit Memo Entered For Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Credit_Memo_Entered_for_Approval</template>
    </alerts>
    <alerts>
        <fullName>Credit_Memo_Rejected</fullName>
        <description>Credit Memo Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vickydarbouze@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Credit_Memo_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Old_Credit_Memo_Created</fullName>
        <description>Old Credit Memo - Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>vickydarbouze@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Old_Credit_Memo_Created</template>
    </alerts>
    <fieldUpdates>
        <fullName>Complete</fullName>
        <field>Complete__c</field>
        <literalValue>1</literalValue>
        <name>Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_by_Finance</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Finance</literalValue>
        <name>Status to Approved by Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_by_Partner</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Partner</literalValue>
        <name>Status to Approved by Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Old Credit Memo - Created</fullName>
        <actions>
            <name>Old_Credit_Memo_Created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SF_Credit_Memo_Old__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>7/13/2015</value>
        </criteriaItems>
        <description>This rule will be used to notify SF/Finance management that a SF credit memo has been created using the old process.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
