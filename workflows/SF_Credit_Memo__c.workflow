<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SFCM_Approved_Process_Adjustment</fullName>
        <description>SFCM Approved - Process Adjustment</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrepereira@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SFCM_Approved</template>
    </alerts>
    <alerts>
        <fullName>SFCM_Assistance_Required</fullName>
        <description>SFCM Assistance Required</description>
        <protected>false</protected>
        <recipients>
            <recipient>charlesliotta@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jakebrenner@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SFCM_Assistance_Required</template>
    </alerts>
    <alerts>
        <fullName>SF_Credit_Memo_Rejected</fullName>
        <description>SF Credit Memo Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_Credit_Memo_Rejected</template>
    </alerts>
    <alerts>
        <fullName>SF_Credit_Memo_for_Approval</fullName>
        <description>SF Credit Memo for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Double_Check__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_Credit_Memo_for_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_by_Partner</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Partner</literalValue>
        <name>Approved by Partner</name>
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
        <fullName>Status_to_Approved_by_Op_s_Task_Force</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Op&apos;s Task Force</literalValue>
        <name>Status to Approved by Op&apos;s Task Force</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_by_Upper_Management</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Upper Management</literalValue>
        <name>Status to Approved by Upper Management</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_Approved_by_VP</fullName>
        <field>Status__c</field>
        <literalValue>Approved by Upper Management</literalValue>
        <name>Status to Approved by VP</name>
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
        <fullName>SFCM Assistance Required</fullName>
        <actions>
            <name>SFCM_Assistance_Required</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SF_Credit_Memo__c.Request_Assistance__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
