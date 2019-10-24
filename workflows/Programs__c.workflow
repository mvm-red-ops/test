<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Assistant_in_Progress</fullName>
        <description>Assistant in Progress</description>
        <protected>false</protected>
        <recipients>
            <field>Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Planner_Capping</template>
    </alerts>
    <alerts>
        <fullName>Capping_Complete</fullName>
        <description>Capping Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>taniabonetti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Assistant_Capping_Complete</template>
    </alerts>
    <alerts>
        <fullName>New_Program_Created_Notify_Finance</fullName>
        <description>New Program Created - Notify Finance</description>
        <protected>false</protected>
        <recipients>
            <recipient>adrianpichardo@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Program</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert</fullName>
        <description>Prelog Version Change Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Exec_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Account_Exec_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assistant__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Antenna</fullName>
        <description>Prelog Version Change Alert-Antenna</description>
        <protected>false</protected>
        <recipients>
            <recipient>brettlaflamme@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>elizabethkeller@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sarahfee@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theolopez@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_BounceTV</fullName>
        <description>Prelog Version Change Alert-BounceTV</description>
        <protected>false</protected>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>andrewangeles@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ericwilson@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jamesonfinch@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karabadette@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Buzzr</fullName>
        <description>Prelog Version Change Alert-Buzzr</description>
        <protected>false</protected>
        <recipients>
            <recipient>karabadette@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michaelpollack@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomasdowling@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_CBS</fullName>
        <description>Prelog Version Change Alert-CBS</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Exec_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Escape</fullName>
        <description>Prelog Version Change Alert-Escape</description>
        <protected>false</protected>
        <recipients>
            <recipient>anairendon@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>andrewangeles@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ericwilson@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jamesonfinch@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>karabadette@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Grit</fullName>
        <description>Prelog Version Change Alert-Grit</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrewangeles@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jaclynpoppe@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jamesonfinch@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Justice</fullName>
        <description>Prelog Version Change Alert-Justice</description>
        <protected>false</protected>
        <recipients>
            <recipient>elizabethkeller@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>josuelreynoso@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sarahfee@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theolopez@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Laff</fullName>
        <description>Prelog Version Change Alert-Laff</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrewangeles@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jaclynpoppe@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jamesonfinch@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kristopherriddick@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_MGM</fullName>
        <description>Prelog Version Change Alert-MGM</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengyang@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>emilyisaac@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ginacubile@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krystinaorellano@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_MLB</fullName>
        <description>Prelog Version Change Alert-MLB</description>
        <protected>false</protected>
        <recipients>
            <recipient>ginacubile@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krystinaorellano@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Mav</fullName>
        <description>Prelog Version Change Alert-Mav</description>
        <protected>false</protected>
        <recipients>
            <recipient>emilyisaac@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ginacubile@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krystinaorellano@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_NHL</fullName>
        <description>Prelog Version Change Alert-NHL</description>
        <protected>false</protected>
        <recipients>
            <recipient>emilyisaac@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ginacubile@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krystinaorellano@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_TVG</fullName>
        <description>Prelog Version Change Alert-TVG</description>
        <protected>false</protected>
        <recipients>
            <field>SF_Entry__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_Tennis</fullName>
        <description>Prelog Version Change Alert-Tennis</description>
        <protected>false</protected>
        <recipients>
            <recipient>ginacubile@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>krystinaorellano@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <alerts>
        <fullName>Prelog_Version_Change_Alert_ThisTV</fullName>
        <description>Prelog Version Change Alert-ThisTV</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengyang@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>cyrerivera@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>michaelpollack@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sarahfee@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>theolopez@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Prelog_Version_Change_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>Canceled_Orders_with_Clearance</fullName>
        <description>Checklist for Prelogs.  Clears all checkboxes after a new version is uploaded.
Used by Operations to check for errors in prelogs and catch before air.</description>
        <field>Prelog_Canceled_Orders_with_Clearance__c</field>
        <literalValue>0</literalValue>
        <name>Canceled Orders with Clearance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clearance_by_Length</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Clearance_by_Length__c</field>
        <literalValue>0</literalValue>
        <name>Clearance by Length</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ghosted_Orders_with_Clearance</fullName>
        <description>Checklist for Prelogs.  Clears all checkboxes after a new version is uploaded.
Used by Operations to check for errors in prelogs and catch before air.</description>
        <field>Prelog_ghosted_Orders_with_Clearance__c</field>
        <literalValue>0</literalValue>
        <name>Ghosted Orders with Clearance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>High_AUR_Low_Clearance</fullName>
        <description>Checklist for Prelogs.  Clears all checkboxes after a new version is uploaded.
Used by Operations to check for errors in prelogs and catch before air.
https://na8.salesforce.com/01QC0000000RYd8</description>
        <field>Prelog_High_AUR_Low_Clearance__c</field>
        <literalValue>0</literalValue>
        <name>High AUR &amp; Low Clearance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Low_Clearance_Levels</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Low_Clearance_Levels__c</field>
        <literalValue>0</literalValue>
        <name>Low Clearance Levels</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Missing_Orders</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Missing_Orders__c</field>
        <literalValue>0</literalValue>
        <name>Missing Orders</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Missing_Stations</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Missing_Stations__c</field>
        <literalValue>0</literalValue>
        <name>Missing Stations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Over_Clearing_Station_Orders</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Over_Clearing_Station_Orders__c</field>
        <name>Over Clearing Station / Orders</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Overbooked_Units</fullName>
        <description>Checklist for Prelogs.  Clears all checkboxes after a new version is uploaded.
Used by Operations to check for errors in prelogs and catch before air.</description>
        <field>Prelog_Overbooked_Units__c</field>
        <literalValue>0</literalValue>
        <name>Overbooked Units</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prelog_Date_Time_Capture</fullName>
        <field>Prelog_Date_Time__c</field>
        <formula>Today_s_Date__c</formula>
        <name>Prelog Date / Time Capture</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prelog_Version_NOW</fullName>
        <field>Version_Time_Stamp__c</field>
        <formula>NOW()</formula>
        <name>Prelog Version = NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Priority_Test_less_than_100</fullName>
        <description>Checklist for Prelogs.  Clears all checkboxes after a new version is uploaded.
Used by Operations to check for errors in prelogs and catch before air.</description>
        <field>Prelog_Priority_Test_less_than_100__c</field>
        <literalValue>0</literalValue>
        <name>Priority/Test less than 100%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Spots_without_Stations</fullName>
        <description>Checklist for Bundles. Clears all checkboxes after a new version is uploaded. 
Used by Operations to check for errors in bundle uploads and correct asap.
https://na8.salesforce.com/01QC0000000IxIW</description>
        <field>Bundle_Spots_without_Stations__c</field>
        <name>Spots without Stations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bundle Checklist</fullName>
        <actions>
            <name>Clearance_by_Length</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Low_Clearance_Levels</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Missing_Orders</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Missing_Stations</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Over_Clearing_Station_Orders</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Spots_without_Stations</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  OR(Name = &quot;Tribune Multicast Connect&quot;,  Name = &quot;Retro Raycom&quot;, Name = &quot;Raycom Bounce Locals&quot;),  ISCHANGED( Reconciled_Week__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Capping Complete</fullName>
        <actions>
            <name>Capping_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Capping_Revisions__c),ISPICKVAL(Capping_Revisions__c,&quot;Inactive&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Capping Status Change</fullName>
        <actions>
            <name>Assistant_in_Progress</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Capping_Revisions__c),ISPICKVAL(Capping_Revisions__c,&quot;SF In Progress&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Program Created</fullName>
        <actions>
            <name>New_Program_Created_Notify_Finance</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Programs__c.CreatedDate</field>
            <operation>greaterOrEqual</operation>
            <value>4/21/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Programs__c.Competitive__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>New Program created - Finance must be notified to prep SF/Intacct for Invoicing/Collections</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Date %2F Time Capture</fullName>
        <actions>
            <name>Prelog_Date_Time_Capture</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates &apos;Prelog Date / Time&apos; field when the version is changed.</description>
        <formula>ISCHANGED( Prelog_Version__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Upload Check</fullName>
        <actions>
            <name>Canceled_Orders_with_Clearance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Ghosted_Orders_with_Clearance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>High_AUR_Low_Clearance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Overbooked_Units</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Priority_Test_less_than_100</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Prelog_Version__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>if(ISCHANGED(Prelog_Version__c), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-BounceTV</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_BounceTV</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(OR(Name =&quot;BounceTV&quot;, Name =&quot;BounceTV - Local&quot; ),ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-CBS</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_CBS</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;CBS Sports&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-Escape</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Escape</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;EscapeTV&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-Grit</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Grit</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;GritTV&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-Justice</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Justice</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;Justice Network&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-Laff</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Laff</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;Laff&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-MGM</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_MGM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;MGM HD&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-MLB</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_MLB</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;MLB Network&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-Mav</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Mav</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;Mav TV&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-NHL</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_NHL</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(OR(Name=&quot;NHL Network&quot;, Name=&quot;NHL Network - Local&quot; ) ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-TVG</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_TVG</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(OR(Name =&quot;TVG&quot;,Name =&quot;TVG2&quot;,Name =&quot;TVG - Local&quot;, Name =&quot;TVG2 - Local&quot;) ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog Version Change Alert-ThisTV</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_ThisTV</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(Name =&quot;ThisTV&quot; ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Prelog_Version_Change_Alert_Antenna</fullName>
        <actions>
            <name>Prelog_Version_Change_Alert_Antenna</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends email alert to AEs and planners / assistants when the prelog version is changed.</description>
        <formula>if(AND(OR(Name =&quot;AntennaTV&quot;, Name = &quot;AntennaTV - Local&quot;) ,ISCHANGED(Prelog_Version__c )), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Version Time Stamp if Changed</fullName>
        <actions>
            <name>Prelog_Version_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Version Time Stamp Field with the last time the version on this program was changed.  Helps to prevent accidentally sending out old prelogs.  Can&apos;t send out logs for programs where time stamp wasn&apos;t changed today....</description>
        <formula>ISCHANGED( Prelog_Version__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
