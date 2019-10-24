<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Approved</fullName>
        <description>Contact Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>vickydarbouze@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Emails/Contact_Approved</template>
    </alerts>
    <alerts>
        <fullName>Contact_Not_Approved</fullName>
        <description>Contact Not Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>vickydarbouze@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Emails/Contact_Not_Approved</template>
    </alerts>
    <alerts>
        <fullName>New_Buyer_Contact_Notify_AEs_SF</fullName>
        <description>New Buyer Contact - Notify AEs SF</description>
        <protected>false</protected>
        <recipients>
            <recipient>AEs</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Buyer_Contact_Notify_AEs_SF</template>
    </alerts>
    <fieldUpdates>
        <fullName>Call_Cycle_to_30</fullName>
        <description>Changes the Call Cycle to 30</description>
        <field>Call_Cycle__c</field>
        <literalValue>30</literalValue>
        <name>Call Cycle to 30</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Fallow_Date</fullName>
        <description>Updates whenever a Lead Type is set to Fallow.  This allows for sorting by most aged Contacts.</description>
        <field>Fallow_Date__c</field>
        <formula>TODAY ()</formula>
        <name>Contact Fallow Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_History_Clear_AE</fullName>
        <description>Clears all Team AE fields when a contact Type.History</description>
        <field>Blue_AE__c</field>
        <name>Contact History Clear AE - Blue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_History_Clear_AE_Green</fullName>
        <field>Green_AE__c</field>
        <name>Contact History Clear AE Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_History_Clear_AE_Red</fullName>
        <field>Red_AE__c</field>
        <name>Contact History Clear AE Red</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_History_Clear_AE_Yellow</fullName>
        <description>Clears Yellow AE</description>
        <field>Yellow_AE__c</field>
        <name>Contact History Clear AE Yellow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Contact_Approved</fullName>
        <field>Duplicate_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>New Contact Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Contact_Pending</fullName>
        <field>Duplicate_Approval__c</field>
        <literalValue>Not Approved</literalValue>
        <name>New Contact Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Call Cycle to 30 - New AE</fullName>
        <actions>
            <name>Call_Cycle_to_30</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changes the Call Cycle to 30 if the call cycle is currently blank and if any of the Team AE Assignment Fields is changed</description>
        <formula>AND( ISPICKVAL( Call_Cycle__c,&quot;&quot;),  OR( ISCHANGED( Green_AE__c ),  ISCHANGED( Blue_AE__c ) , ISCHANGED( Red_AE__c ) , ISCHANGED( Silver_AE__c ) , ISCHANGED( Yellow_AE__c )))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Details</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>11/4/2015</value>
        </criteriaItems>
        <description>This validation rule will be used to ensure that all necessary contact info is included when creating new contacts.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact Fallow Date</fullName>
        <actions>
            <name>Contact_Fallow_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Lead_Type__c</field>
            <operation>equals</operation>
            <value>Fallow</value>
        </criteriaItems>
        <description>Updates Contact.Fallow Date with TODAY whenever Lead Type is set to Fallow to allow for sorting based on aging of Contacts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>History</fullName>
        <actions>
            <name>Contact_History_Clear_AE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_History_Clear_AE_Green</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_History_Clear_AE_Red</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_History_Clear_AE_Yellow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Type__c</field>
            <operation>equals</operation>
            <value>History</value>
        </criteriaItems>
        <description>Rule Triggers when a contact is changed to Type.History.  Removes all names from the Team AE fields</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Buyer Contact - Notify AEs SF</fullName>
        <actions>
            <name>New_Buyer_Contact_Notify_AEs_SF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Type__c</field>
            <operation>equals</operation>
            <value>Buyer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.LF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notifies new AEs of short form contacts that are entered into the system as new buyers</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
