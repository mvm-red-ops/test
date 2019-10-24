<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Antenna_Logs_Complete</fullName>
        <description>Antenna Logs Complete</description>
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
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Antenna_Prelogs_Complete</template>
    </alerts>
    <alerts>
        <fullName>Antenna_Prelogs_Late</fullName>
        <description>Antenna Prelogs Late</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Antenna_Prelogs_Late</template>
    </alerts>
    <alerts>
        <fullName>Capping_Past_Due</fullName>
        <description>Capping Past Due</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Capping_Past_Due</template>
    </alerts>
    <alerts>
        <fullName>Justice_Logs_Complete</fullName>
        <description>Justice Logs Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>elizabethkeller@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>josuelreynoso@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Justice_Prelogs_Complete</template>
    </alerts>
    <alerts>
        <fullName>Justice_Prelogs_Late</fullName>
        <description>Justice Prelogs Late</description>
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
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>josuelreynoso@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Justice_Prelogs_Late</template>
    </alerts>
    <alerts>
        <fullName>Sends_out_Postlog_Checklist_when_task_is_complete</fullName>
        <description>Sends out Postlog Checklist when task is complete.</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_Manager_Postlog_Complete</template>
    </alerts>
    <alerts>
        <fullName>Task_Manager_Postlogs_Late</fullName>
        <description>Task Manager: Postlogs Late</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_Manager_Postlogs_Late</template>
    </alerts>
    <alerts>
        <fullName>Task_Manager_Prelog_Complete</fullName>
        <description>Sends out Prelog Checklist when task is complete.</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_Manager_Prelog_Complete</template>
    </alerts>
    <alerts>
        <fullName>Task_Manager_Prelog_Complete_Laff</fullName>
        <description>Sends out Prelog Checklist when task is complete. [LAFF ONLY]</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>addiakhursheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>ahmedelsayed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kemarnimunroe@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lindsaymaiello@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_Manager_Prelog_Complete</template>
    </alerts>
    <alerts>
        <fullName>Task_Manager_Prelogs_Late</fullName>
        <description>Task Manager: Prelogs Late</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Task_Manager_Prelogs_Late</template>
    </alerts>
    <alerts>
        <fullName>ThisTV_Logs_Complete</fullName>
        <description>ThisTV Logs Complete</description>
        <protected>false</protected>
        <recipients>
            <recipient>chengyang@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>faronerasheed@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jillianbenanti@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ThisTV_Prelogs_Complete</template>
    </alerts>
    <fieldUpdates>
        <fullName>Close_Task</fullName>
        <description>Marks task status as complete.</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Close Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Antenna Prelogs Complete</fullName>
        <actions>
            <name>Antenna_Logs_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends notification to team and Ops manager that logs are complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;), CONTAINS(Subject, &quot;[*Antenna*]&quot;), WhatId=&quot;a06C000000jmYxZ&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Antenna Prelogs Late</fullName>
        <active>false</active>
        <description>Warning to Ops Manager that Antenna Logs have not been completed by the Reminder Time.</description>
        <formula>AND(CONTAINS(Subject, &quot;*] Prelog Week&quot;),NOT(ISPICKVAL(Status, &quot;Completed&quot;)), WhatId = &quot;a06C000000jmYxZ&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Antenna_Prelogs_Late</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Capping Not Complete</fullName>
        <active>true</active>
        <description>Warning to P&amp;P Manager that Capping have not been completed by the Reminder Time.</description>
        <formula>AND(OR(CONTAINS(Subject, &quot;]}, Capping&quot;),CONTAINS(Subject, &quot;Assistant Capping&quot;)),NOT(ISPICKVAL(Status, &quot;Completed&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Capping_Past_Due</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Close Task</fullName>
        <actions>
            <name>Close_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Close_Task__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates Task Status to &quot;Complete&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Justice Prelogs Complete</fullName>
        <actions>
            <name>Justice_Logs_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends notification to team and Ops manager that logs are complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;), WhatId=&quot;a06C000001EZXFQ&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Justice Prelogs Late</fullName>
        <active>false</active>
        <description>Warning to Ops Manager that Justice Logs have not been completed by the Reminder Time.</description>
        <formula>AND(CONTAINS(Subject, &quot;*] Prelog Week&quot;),NOT(ISPICKVAL(Status, &quot;Completed&quot;)), WhatId = &quot;a06C000001EZXFQ&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Justice_Prelogs_Late</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TEST</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.OwnerId</field>
            <operation>notContain</operation>
        </criteriaItems>
        <description>TEST</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task Manager - Postlog Complete</fullName>
        <actions>
            <name>Sends_out_Postlog_Checklist_when_task_is_complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends out Prelog Checklist when task is complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;),CONTAINS(Subject, &quot;*] Postlog&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Manager - Prelog Complete</fullName>
        <actions>
            <name>Task_Manager_Prelog_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends out Prelog Checklist when task is complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;),CONTAINS(Subject, &quot;*] Prelog Week&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Manager - Prelog Complete %28Laff%29</fullName>
        <actions>
            <name>Task_Manager_Prelog_Complete_Laff</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends out Prelog Checklist when task is complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;),CONTAINS(Subject, &quot;Laff*] Prelog Week&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Task Manager%3A Postlogs Late</fullName>
        <active>true</active>
        <description>Warning to Ops Manager that Postlogs have not been completed by the Reminder Time.</description>
        <formula>AND(CONTAINS(Subject, &quot;*] Postlog&quot;),NOT(ISPICKVAL(Status, &quot;Completed&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Task_Manager_Postlogs_Late</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Task Manager%3A Prelogs Late</fullName>
        <active>true</active>
        <description>Warning to Ops Manager that Logs have not been completed by the Reminder Time.</description>
        <formula>AND(CONTAINS(Subject, &quot;*] Prelog Week&quot;),NOT(ISPICKVAL(Status, &quot;Completed&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Task_Manager_Prelogs_Late</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Task.ReminderDateTime</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ThisTV Prelogs Complete</fullName>
        <actions>
            <name>ThisTV_Logs_Complete</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends notification to team and Ops manager that logs are complete.</description>
        <formula>AND(ISCHANGED(Status),ISPICKVAL(Status, &quot;Completed&quot;), WhatId=&quot;a068000000JJ0Rp&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
