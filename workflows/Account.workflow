<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Credit_Limit_Review</fullName>
        <description>Credit Limit Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Credit_Limit_Review</template>
    </alerts>
    <alerts>
        <fullName>Credit_Limit_Review_RISK</fullName>
        <description>Credit Limit Review RISK</description>
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
        <template>unfiled$public/Credit_Limit_Review_RISK</template>
    </alerts>
    <alerts>
        <fullName>LOG_with_Expiration_Date</fullName>
        <description>LOG with Expiration Date</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melissaviellot@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LOG_with_Expiration_Date</template>
    </alerts>
    <alerts>
        <fullName>New_Account_Financial_Info_Request</fullName>
        <description>New Account Financial Info Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peterbrazill@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Account_Financial_Request</template>
    </alerts>
    <alerts>
        <fullName>New_Account_Needs_to_Be_Synced_to_Intacct</fullName>
        <description>New Account Needs to Be Synced to Intacct</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hasanmorshed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Account_Sync_to_Intacct</template>
    </alerts>
    <alerts>
        <fullName>W9_Required_for_all_NEW_Vendors</fullName>
        <description>W9 Required for all NEW Vendors</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>peterbrazill@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/W9_Required_for_all_NEW_Vendors</template>
    </alerts>
    <fieldUpdates>
        <fullName>Region_Caifornia</fullName>
        <field>Region__c</field>
        <formula>&quot;California&quot;</formula>
        <name>Region - Caifornia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_East_South_Central</fullName>
        <field>Region__c</field>
        <formula>&quot;East South Central&quot;</formula>
        <name>Region - East South Central</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_Middle_Atlantic</fullName>
        <field>Region__c</field>
        <formula>&quot;Middle Atlantic&quot;</formula>
        <name>Region - Middle Atlantic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_Midwest</fullName>
        <field>Region__c</field>
        <formula>&quot;Midwest&quot;</formula>
        <name>Region - Midwest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_Mountain_West</fullName>
        <field>Region__c</field>
        <formula>&quot;Mountain West&quot;</formula>
        <name>Region - Mountain West</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_Northeast</fullName>
        <field>Region__c</field>
        <formula>&quot;Northeast&quot;</formula>
        <name>Region - Northeast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_Pacific</fullName>
        <field>Region__c</field>
        <formula>&quot;Pacific&quot;</formula>
        <name>Region - Pacific</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_South</fullName>
        <field>Region__c</field>
        <formula>&quot;South&quot;</formula>
        <name>Region - South</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_South_Atlantic</fullName>
        <field>Region__c</field>
        <formula>&quot;South Atlantic&quot;</formula>
        <name>Region - South Atlantic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Region_West_North_Central</fullName>
        <field>Region__c</field>
        <formula>&quot;West North Central&quot;</formula>
        <name>Region - West North Central</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Credit Limit Review</fullName>
        <actions>
            <name>Credit_Limit_Review</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Balance__c &gt;=( Intacct_Credit_Limit__c *0.70), Intacct_Credit_Limit__c &lt;&gt;0, Balance__c &lt;&gt;0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Limit Review RISK</fullName>
        <actions>
            <name>Credit_Limit_Review_RISK</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(Balance__c &gt;=( Intacct_Credit_Limit__c *0.90), Intacct_Credit_Limit__c &lt;&gt;0, Balance__c &lt;&gt;0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Limit Review RISK2</fullName>
        <active>true</active>
        <formula>AND(Balance__c &gt;=( Intacct_Credit_Limit__c *0.90), Intacct_Credit_Limit__c &lt;&gt;0, Balance__c &lt;&gt;0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Credit_Limit_Review_RISK</name>
                <type>Alert</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Credit Limit Review2</fullName>
        <active>true</active>
        <formula>AND(Balance__c &gt;=( Intacct_Credit_Limit__c *0.70), Intacct_Credit_Limit__c &lt;&gt;0, Balance__c &lt;&gt;0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Credit_Limit_Review</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>LOG with Expiration Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account.LOG_w_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If an agency submits an LOG with an expiration date, Finance will need to follow up with agency two weeks before the LOG expires.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>LOG_with_Expiration_Date</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.LOG_w_Expiration_Date__c</offsetFromField>
            <timeLength>-14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New Account - Billing Info Request %26 Sync to Intacct</fullName>
        <actions>
            <name>New_Account_Financial_Info_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.CIA__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CIA__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If new account is created, sends email to creator and Finance requesting credit references to process a credit check + update EMT Code for electronic invoicing + SYNC to Intacct</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Account Sync to Intacct</fullName>
        <actions>
            <name>New_Account_Needs_to_Be_Synced_to_Intacct</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>if( ISBLANK( IntacctID__c ), true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - California</fullName>
        <actions>
            <name>Region_Caifornia</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>BillingState = &quot;CA&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - East South Central</fullName>
        <actions>
            <name>Region_East_South_Central</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set based on corresponding State for the Account</description>
        <formula>OR(BillingState = &quot;KY&quot;, BillingState = &quot;TN&quot;, BillingState = &quot;MS&quot;, BillingState = &quot;AL&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - Middle Atlantic</fullName>
        <actions>
            <name>Region_Middle_Atlantic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set as Middle Atlantic based on corresponding State</description>
        <formula>OR(BillingState = &quot;VA&quot;, BillingState = &quot;WV&quot;, BillingState = &quot;DC&quot;, BillingState = &quot;MD&quot;, BillingState = &quot;DE&quot;, BillingState = &quot;PA&quot;, BillingState = &quot;NJ&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - Midwest</fullName>
        <actions>
            <name>Region_Midwest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set as Midwest based on corresponding State</description>
        <formula>OR(BillingState = &quot;WI&quot;, BillingState = &quot;IL&quot;, BillingState = &quot;IN&quot;, BillingState = &quot;MI&quot;, BillingState = &quot;OH&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - Mountain West</fullName>
        <actions>
            <name>Region_Mountain_West</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Region as Mountain West for corresponding states</description>
        <formula>OR(  BillingState = &quot;MT&quot;, BillingState = &quot;ID&quot;, BillingState = &quot;WY&quot;, BillingState = &quot;CO&quot;, BillingState = &quot;NM&quot;, BillingState = &quot;AZ&quot;, BillingState = &quot;NV&quot;, BillingState = &quot;UT&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - Northeast</fullName>
        <actions>
            <name>Region_Northeast</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Region as Northeast for the corresponding States</description>
        <formula>OR(BillingState = &quot;NY&quot;, BillingState = &quot;CT&quot;, BillingState = &quot;RI&quot;, BillingState = &quot;MA&quot;, BillingState = &quot;VT&quot;, BillingState = &quot;NH&quot;, BillingState = &quot;ME&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - Pacific</fullName>
        <actions>
            <name>Region_Pacific</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set as Pacific according to the corresponding State</description>
        <formula>OR(BillingState = &quot;AL&quot;, BillingState = &quot;HI&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - South</fullName>
        <actions>
            <name>Region_South</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Region as South for corresponding states</description>
        <formula>OR(BillingState = &quot;OK&quot;, BillingState = &quot;TX&quot;, BillingState = &quot;AR&quot;, BillingState = &quot;LA&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - South Atlantic</fullName>
        <actions>
            <name>Region_South_Atlantic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set as South Atlantic based on corresponding State</description>
        <formula>OR(BillingState = &quot;FL&quot;, BillingState = &quot;GA&quot;, BillingState = &quot;SC&quot;, BillingState = &quot;NC&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Region - West North Central</fullName>
        <actions>
            <name>Region_West_North_Central</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Region set as West North Central based on the corresponding State</description>
        <formula>OR(BillingState = &quot;ND&quot;, BillingState = &quot;SD&quot;, BillingState = &quot;NE&quot;, BillingState = &quot;KS&quot;, BillingState = &quot;MN&quot;, BillingState = &quot;IA&quot;, BillingState = &quot;MO&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>W9 Required for all NEW Vendors</fullName>
        <actions>
            <name>W9_Required_for_all_NEW_Vendors</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>4/27/2016</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
