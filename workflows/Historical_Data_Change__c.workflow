<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Historical_Data_Change</fullName>
        <description>Historical Data Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sabrymohideen@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Historical_Data_Change</template>
    </alerts>
    <alerts>
        <fullName>Historical_Data_Change_Approved</fullName>
        <description>Historical Data Change Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Historical_Data_Change_Approved</template>
    </alerts>
    <alerts>
        <fullName>Historical_Data_Change_Rejected</fullName>
        <description>Historical Data Change Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Historical_Data_Change_Rejected</template>
    </alerts>
</Workflow>
