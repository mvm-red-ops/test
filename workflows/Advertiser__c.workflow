<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ADV_LOG_with_Expiration_Date</fullName>
        <description>ADV LOG with Expiration Date</description>
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
        <template>unfiled$public/ADV_LOG_with_Expiration_Date</template>
    </alerts>
    <alerts>
        <fullName>Adv_Credit_Limit_Review</fullName>
        <description>Adv Credit Limit Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Adv_Credit_Limit_Review</template>
    </alerts>
    <alerts>
        <fullName>Adv_Credit_Limit_Review_RISK</fullName>
        <description>Adv Credit Limit Review RISK</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Adv_Credit_Limit_Review_RISK</template>
    </alerts>
    <alerts>
        <fullName>Advertiser_Approved</fullName>
        <description>Advertiser Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/Advertiser_Approved</template>
    </alerts>
    <alerts>
        <fullName>Advertiser_Needs_Commercial_Type</fullName>
        <description>Advertiser Needs Commercial Type</description>
        <protected>false</protected>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Advertiser_Needs_Commercial_Type</template>
    </alerts>
    <alerts>
        <fullName>Advertiser_Not_Approved</fullName>
        <description>Advertiser Not Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Advertiser_Not_Approved</template>
    </alerts>
    <alerts>
        <fullName>Agency_Change</fullName>
        <description>Agency Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Mass_Emails/Agency_Change_EMAIL</template>
    </alerts>
    <alerts>
        <fullName>Credit_Application_or_LOG_Required_for_NEW_ADV</fullName>
        <description>Credit Application or LOG Required for NEW ADV</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
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
        <template>unfiled$public/Credit_Application_or_LOG_Required_for_NEW_ADV</template>
    </alerts>
    <alerts>
        <fullName>New_Advertiser_Created_Credit_Check_Needed</fullName>
        <description>New Advertiser Created - Credit Check Needed</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hiralpatel@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Advertiser_Financial_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>ADV_LOG_has_Expired</fullName>
        <description>Advertiser record will be placed on hold once the LOG has expired</description>
        <field>Hold_Placed_on_Advertiser_Account__c</field>
        <literalValue>1</literalValue>
        <name>ADV LOG has Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Adv_Credit_Limit_Default_Value</fullName>
        <description>All new advertiser credit limits are set to $0 by default until a credit check in processed</description>
        <field>Advertiser_Credit_Limit__c</field>
        <formula>0.00</formula>
        <name>Adv Credit Limit Default Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Advertiser_Approved</fullName>
        <field>Duplicate_Approval__c</field>
        <literalValue>Approved</literalValue>
        <name>Advertiser Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Advertiser_External_ID_Update</fullName>
        <field>Advertiser_External_ID__c</field>
        <formula>Name</formula>
        <name>Advertiser External ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Advertiser_Not_Approved</fullName>
        <field>Duplicate_Approval__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Advertiser Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Not_Approved</fullName>
        <field>Duplicate_Approval__c</field>
        <literalValue>Not Approved</literalValue>
        <name>Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>On_hold_for_credit_review</fullName>
        <field>Hold_Placed_on_Advertiser_Account__c</field>
        <literalValue>1</literalValue>
        <name>On hold for credit review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unique_Advertiser_Identifier</fullName>
        <field>Unique_Advertiser_Identifier__c</field>
        <formula>Name</formula>
        <name>Unique Advertiser Identifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ADV LOG with Expiration Date r2</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Advertiser__c.ADV_LOG_with_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If an agency submits an LOG with an expiration date, Finance will need to follow up with agency (c/o advertiser) one week before the LOG expires.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ADV_LOG_with_Expiration_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Advertiser__c.ADV_LOG_with_Expiration_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Adv Credit Limit Review</fullName>
        <actions>
            <name>Adv_Credit_Limit_Review</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Intacct_Adv_Balance__c &gt;=( Advertiser_Credit_Limit__c  *0.70), Advertiser_Credit_Limit__c &lt;&gt;0, Intacct_Adv_Balance__c &lt;&gt;0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Adv Credit Limit Review RISK</fullName>
        <actions>
            <name>Adv_Credit_Limit_Review_RISK</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(Intacct_Adv_Balance__c &gt;=( Advertiser_Credit_Limit__c  *0.90), Advertiser_Credit_Limit__c &lt;&gt;0, Intacct_Adv_Balance__c &lt;&gt;0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Adv LOG has Expired</fullName>
        <actions>
            <name>ADV_LOG_has_Expired</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow will update the Adv record and place the record on hold once the LOG has expired</description>
        <formula>ADV_LOG_with_Expiration_Date__c &lt; TODAY()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Advertiser External ID</fullName>
        <actions>
            <name>Advertiser_External_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To make advertiser searchable</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Agency%2FAccount Change</fullName>
        <actions>
            <name>Agency_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When an Advertiser is under a new Agency fire this workflow</description>
        <formula>ISCHANGED(Account__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Application or LOG Required for NEW ADV</fullName>
        <actions>
            <name>Credit_Application_or_LOG_Required_for_NEW_ADV</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Advertiser__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>9/23/2016</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Duplicate Advertiser Prevention</fullName>
        <actions>
            <name>Unique_Advertiser_Identifier</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Advertiser__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>1/20/2013</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Advertiser - Commercial Type Update</fullName>
        <actions>
            <name>Advertiser_Needs_Commercial_Type</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Advertiser__c.Advertiser_CIA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Advertiser - Credit Check Needed</fullName>
        <actions>
            <name>New_Advertiser_Created_Credit_Check_Needed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Advertiser__c.Advertiser_CIA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
