<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>unique spots</fullName>
        <active>true</active>
        <criteriaItems>
            <field>SpotDataMirror__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Test for unique spots for spot data mirrors</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
