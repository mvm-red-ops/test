<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Agency_Change_INACTIVE</fullName>
        <description>Agency ChangeINACTIVE</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Agency_Change</template>
    </alerts>
    <alerts>
        <fullName>Brand_Approved</fullName>
        <description>Brand Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brand_Approved</template>
    </alerts>
    <alerts>
        <fullName>Brand_Not_Approved</fullName>
        <description>Brand Not Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brand_Not_Approved</template>
    </alerts>
    <alerts>
        <fullName>Brand_Submitted_for_Approval</fullName>
        <description>Brand Submitted for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>michaelpollack@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Brand_Submitted_For_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Duplicate_Brand_Prevention</fullName>
        <field>Unique_Brand_Identifer__c</field>
        <formula>Brands_Advertisers__c</formula>
        <name>Duplicate Brand Prevention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Brand_Approved</fullName>
        <field>Approved_Duplicate__c</field>
        <literalValue>Approved</literalValue>
        <name>New Brand Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Brand_Pending</fullName>
        <field>Approved_Duplicate__c</field>
        <literalValue>Not Approved</literalValue>
        <name>New Brand Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Agency is Changed</fullName>
        <actions>
            <name>Agency_Change_INACTIVE</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Account__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate Brand Prevention</fullName>
        <actions>
            <name>Duplicate_Brand_Prevention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Brands__c.X28_30__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Prevents Brands from being created with exact names.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
