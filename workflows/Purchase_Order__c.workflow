<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Purchase_Order_Approved</fullName>
        <description>Purchase Order Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_Purchase_Order_Approved</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Rejected</fullName>
        <description>Purchase Order Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>jesusburgos@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_Purchase_Order_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Order_Submitted</fullName>
        <description>Purchase Order Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>adrianpichardo@mvmediasales.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_Purchase_Order</template>
    </alerts>
</Workflow>
