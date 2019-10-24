<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>uniquespotTEST</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Spot_Data__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
