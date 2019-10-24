<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Brand_Does_Not_Have_Credit</fullName>
        <description>ALERT: Brand Does Not Have Credit for Fox Syndication</description>
        <protected>false</protected>
        <recipients>
            <recipient>arunnaraj@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karenjohnson@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sabrymohideen@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ALERT_Brand_Does_Not_Have_Credit_for_Fox_Syndication</template>
    </alerts>
    <alerts>
        <fullName>Credit_Risk_Alert</fullName>
        <description>Credit Risk Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jakebrenner@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karenjohnson@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sabrymohideen@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Credit_Risk_Alert</template>
    </alerts>
    <alerts>
        <fullName>Katz_Hybrid_Update</fullName>
        <description>Katz Hybrid Update</description>
        <protected>false</protected>
        <recipients>
            <recipient>taniabonetti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Katz_Hybrid_Update</template>
    </alerts>
    <alerts>
        <fullName>Missing_Network_Deal_Number</fullName>
        <description>Missing Network Deal Number</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>adrianlo@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Missing_Network_Deal_Number</template>
    </alerts>
    <alerts>
        <fullName>New_Deal_Contact_History</fullName>
        <description>New Deal Contact.History</description>
        <protected>false</protected>
        <recipients>
            <recipient>dianehyden@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>logs@mvmediasales.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Expired_Contact</template>
    </alerts>
    <fieldUpdates>
        <fullName>Bundle_Revision_Update</fullName>
        <field>Bundle_Action__c</field>
        <name>Bundle Revision Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_OwnerCW</fullName>
        <field>OwnerId</field>
        <lookupValue>caseywunsch@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner -CW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_AA</fullName>
        <field>OwnerId</field>
        <lookupValue>andrewangeles@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - AA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_BL</fullName>
        <field>OwnerId</field>
        <lookupValue>brettlaflamme@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - BL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_CJ</fullName>
        <field>OwnerId</field>
        <lookupValue>coryjenkins@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner -CJ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_CW</fullName>
        <field>OwnerId</field>
        <lookupValue>caseywunsch@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - CW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_EO</fullName>
        <field>OwnerId</field>
        <lookupValue>erikocasio@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - EO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_EO_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>erikocasio@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - EO - Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_GC</fullName>
        <field>OwnerId</field>
        <lookupValue>ginacubile@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - GC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_GC_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>ginacubile@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - GC - Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_JF</fullName>
        <field>OwnerId</field>
        <lookupValue>jamesonfinch@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - JF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_LC</fullName>
        <field>OwnerId</field>
        <lookupValue>adrianpichardo@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - LC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_MA_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>michaelauerbach@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - MA - Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_MP_Team</fullName>
        <field>OwnerId</field>
        <lookupValue>michaelpichardo@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - MP - Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_TB</fullName>
        <field>OwnerId</field>
        <lookupValue>taniabonetti@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - TB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Owner_TL</fullName>
        <field>OwnerId</field>
        <lookupValue>theolopez@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Deal Owner - TL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SF_Deal_Owner_Update</fullName>
        <description>Updates Deal Owner to Sarah Fee if she is set as the Team AE on the Contact Page</description>
        <field>OwnerId</field>
        <lookupValue>sarahfee@mvmediasales.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>SF Deal Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Add Network Deal Number</fullName>
        <active>true</active>
        <description>for w.o. networks to enter deal numbers on the Deal Object</description>
        <formula>AND(OR(Program__c = &quot;BounceTV&quot;,Program__c = &quot;BounceTV = Local&quot;), ISBLANK( Network_Deal_Number__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Missing_Network_Deal_Number</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Deal__c.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Bundle Revision Update</fullName>
        <actions>
            <name>Bundle_Revision_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(Program__c=&quot;Retro Raycom&quot;,Program__c=&quot;Raycom Bounce Locals&quot;),ISCHANGED(Sum_of_Total_Dollars__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact History</fullName>
        <actions>
            <name>New_Deal_Contact_History</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Rule triggers when a Deal has been created for a Contact with Type.History.  Since many buyers move agencies, history is used to denote a previous position for a buyer.  New Deals should only be assigned to their current Contact Record.</description>
        <formula>ispickval(Contact__r.Type__c, &quot;History&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Risk Alert</fullName>
        <actions>
            <name>Credit_Risk_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends an alert if an order is booked for an agency that is a credit risk</description>
        <formula>Contact__r.Account.Credit_Risk__c =True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - AA - Team</fullName>
        <actions>
            <name>Deal_Owner_AA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Andrew Angeles AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000003X1li&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000003X1li&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;AA&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000003X1li&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C0000003X1li&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000003X1li&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000003X1li&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000003X1li&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000003X1li&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000003X1li&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - BL - Team</fullName>
        <actions>
            <name>Deal_Owner_BL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Brett Laflamme AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;BL&quot;), 
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C000000AHTS7&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C000000AHTS7&quot;), AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C000000AHTS7&quot;), 
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C000000AHTS7&quot;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - CJ - Team</fullName>
        <actions>
            <name>Deal_Owner_CJ</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Cory Jenkins AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C000000AqeZ0&quot;),
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C000000AqeZ0&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;CJ&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C000000AqeZ0&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C000000AqeZ0&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C000000AqeZ0&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C000000AqeZ0&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C000000AqeZ0&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C000000AqeZ0&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C000000AqeZ0&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - CW - Team</fullName>
        <actions>
            <name>Deal_OwnerCW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Casey Wunsch AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000009kW0p&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000009kW0p&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;CG&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000009kW0p&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C0000009kW0p&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000009kW0p&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000009kW0p&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000009kW0p&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000009kW0p&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000009kW0p&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - EO - Team</fullName>
        <actions>
            <name>Deal_Owner_EO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Erik Ocasio AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C000000ArDhA&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C000000ArDhA&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C000000ArDhA&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C000000ArDhA&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C000000ArDhA&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C000000ArDhA&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C000000ArDhA&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C000000ArDhA&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C000000ArDhA&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C000000ArDhA&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - GC - Team</fullName>
        <actions>
            <name>Deal_Owner_GC_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Gina Cubile AE Deal Owner Update</description>
        <formula>OR(
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000006ox5x&quot;),AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000006ox5x&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000006ox5x&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000006ox5x&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000006ox5x&quot;) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - JF - Team</fullName>
        <actions>
            <name>Deal_Owner_JF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Jameson Finch AE Deal Owner Update</description>
        <formula>OR(
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;JF&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000009qBC3&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000009qBC3&quot;), AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000009qBC3&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000009qBC3&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - KO - Team</fullName>
        <active>false</active>
        <description>Krystina Orellano AE Deal Owner Update</description>
        <formula>OR(  
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000004vGfC&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000004vGfC&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000004vGfC&quot;) , 
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000004vGfC&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000004vGfC&quot;),
AND(Program__r.Team__c = &quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000004vGfC&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000004vGfC&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000004vGfC&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000004vGfC&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000004vGfC&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - MA - Team</fullName>
        <actions>
            <name>Deal_Owner_MA_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Michael Auerbach - AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000006qCbQ&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000006qCbQ&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000006qCbQ&quot;) , 
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000006qCbQ&quot;), 
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C0000006qCbQ&quot;),
AND(Program__r.Team__c = &quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000006qCbQ&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000006qCbQ&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000006qCbQ&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000006qCbQ&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000006qCbQ&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - MP - Team</fullName>
        <actions>
            <name>Deal_Owner_MP_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Michael Pichardo AE Deal Owner Update</description>
        <formula>OR(
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000009poUi&quot;),AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000009poUi&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000009poUi&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000009poUi&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000009poUi&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - SF - Team</fullName>
        <actions>
            <name>SF_Deal_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Sarah Fee AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000006n1oh&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000006n1oh&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000006n1oh&quot;) , 
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000006n1oh&quot;), 
AND(Program__r.Team__c = &quot;Onyx&quot;, Contact__r.Onyx_AE__r.Id =&quot;005C0000006n1oh&quot;),
AND(Program__r.Team__c = &quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000006n1oh&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000006n1oh&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000006n1oh&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000006n1oh&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000006n1oh&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - TB - Team</fullName>
        <actions>
            <name>Deal_Owner_TB</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Tania Bonetti AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000004vNZX&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000004vNZX&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , AE_initials__c = &quot;TB&quot;) , AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000004vNZX&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000004vNZX&quot;), 
AND( Program__r.Team__c =&quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000004vNZX&quot;), AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__r.Id= &quot;005C0000004vNZX&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000004vNZX&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000004vNZX&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000004vNZX&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - TD - Team</fullName>
        <active>false</active>
        <description>Thomas Dowling AE Deal Owner Update</description>
        <formula>OR( 
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000003WYAa&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000003WYAa&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000003WYAa&quot;) , 
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000003WYAa&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000003WYAa&quot;),
AND(Program__r.Team__c = &quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id =&quot;005C0000003WYAa&quot;),
AND ( Program__r.Team__c = &quot;Emerald&quot; , Contact__r.Emerald_AE__c = &quot;005C0000003WYAa&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000003WYAa&quot;),
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000003WYAa&quot;),
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000003WYAa&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Owner - TL - Team</fullName>
        <actions>
            <name>Deal_Owner_TL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Theo Lopez AE Deal Owner Update</description>
        <formula>OR(  
AND(Program__r.Team__c = &quot;Green&quot; , Contact__r.Green_AE__r.Id= &quot;005C0000006noYU&quot;), 
AND(Program__r.Team__c = &quot;Blue&quot; , Contact__r.Blue_AE__r.Id= &quot;005C0000006noYU&quot;), 
AND(Program__r.Team__c = &quot;Fire&quot; , Contact__r.Red_AE__r.Id= &quot;005C0000006noYU&quot;),
AND(Program__r.Team__c = &quot;Yellow&quot;, Contact__r.Yellow_AE__r.Id= &quot;005C0000006noYU&quot;),
AND(Program__r.Team__c = &quot;Onyx&quot;,  Contact__r.Onyx_AE__r.Id =&quot;005C0000006noYU&quot;),
AND(Program__r.Team__c = &quot;Yellow Syndication&quot;, Contact__r.Yellow_Syndication_AE__r.Id  =&quot;005C0000006noYU&quot;), AND(Program__r.Team__c = &quot;Emerald&quot; ,  Contact__r.Emerald_AE__c = &quot;005C0000006noYU&quot;),
AND(Program__r.Team__c = &quot;Maple&quot; , Contact__r.Maple_AE__c= &quot;005C0000006noYU&quot;), 
AND(Program__r.Team__c = &quot;Pine&quot; , Contact__r.Pine_AE__c= &quot;005C0000006noYU&quot;), 
AND(Program__r.Team__c = &quot;Oak&quot; , Contact__r.Oak_AE__c= &quot;005C0000006noYU&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Fox Syndication Not Approved</fullName>
        <actions>
            <name>Brand_Does_Not_Have_Credit</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends Email Alert for Fox Syndication Deals if they do not have credit</description>
        <formula>AND(

NOT(Brands__r.Name = &quot;Availability&quot;),

OR(Program__r.Name  = &quot;Burn Notice&quot;,Program__r.Name  = &quot;White Collar&quot;, Program__r.Name  = &quot;It&apos;s Always Sunny in Philadelphia (m-f)&quot;, Program__r.Name  = &quot;It&apos;s Always Sunny in Philadelphia (wknd)&quot;)

/*
OR(ISPICKVAL( Client_Account__r.Fox_Syndication_Credit_Terms__c  , &quot;&quot;),  
NOT(INCLUDES( Client_Account__r.Credit_Approved__c  , &quot;21st Century Fox Syndication&quot;)

))*/
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Katz Hybrid Update</fullName>
        <actions>
            <name>Katz_Hybrid_Update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>IF(AND( ISPICKVAL( Katz_Hybrid__c , &quot;Hybrid&quot;), OR (  Program__r.Name = &quot;EscapeTV&quot;,Program__r.Name = &quot;GritTV&quot;)),True,False)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Priority Deals Uncheck</fullName>
        <active>false</active>
        <formula>Priority__c =true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
