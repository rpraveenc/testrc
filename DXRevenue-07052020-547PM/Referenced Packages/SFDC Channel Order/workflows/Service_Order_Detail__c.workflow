<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Fixed_Price</fullName>
        <field>pc_Fixed_Price__c</field>
        <formula>Product_Name__r.Fixed_Price__c</formula>
        <name>Populate Fixed Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Pricing_Type</fullName>
        <field>pc_Pricing_Type__c</field>
        <literalValue>FIXED</literalValue>
        <name>Populate Pricing Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Pricing fields</fullName>
        <actions>
            <name>Populate_Fixed_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Pricing_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(Product_Name__r.Pricing_Type__c, &quot;FIXED&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
