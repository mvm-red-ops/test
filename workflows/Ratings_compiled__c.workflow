<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_Cost_Impression</fullName>
        <field>CPM__c</field>
        <formula>AUR__c /  Impressions__c</formula>
        <name>update Cost / Impression</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPM formula</fullName>
        <actions>
            <name>update_Cost_Impression</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Ratings_compiled__c.Impressions__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
