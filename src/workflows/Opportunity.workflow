<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_stage_date</fullName>
        <field>Stage_changed_date__c</field>
        <formula>Today()</formula>
        <name>Update stage date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Create a task for on boarding</fullName>
        <actions>
            <name>Checklist_completed_for_opportunity</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(
Insurance_Certificate__c = TRUE,
Property_Reports__c = TRUE,
Tax_Assessment__c = TRUE,
Capital_Allocation_and_Approvals__c  = TRUE,
Business_Tax_Returns__c = TRUE
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create a task when Yield Rate is changed</fullName>
        <actions>
            <name>Changed_Yield_Rate</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>AND(
     ISCHANGED(Yield_Rate__c) ,
     $Profile.Name = &apos;Custom : Product Manager&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CreateTask for Closed won opportunity</fullName>
        <actions>
            <name>Service_Product</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL(StageName,&quot;Closed Won&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CreateTaskForProductConfigRule</fullName>
        <actions>
            <name>Configure_Products</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <formula>AND
(
ischanged(StageName),
Priorvalue(StageName) != &apos;Proposal/Price Quote&apos;,
ISPICKVAL(StageName, &apos;Proposal/Price Quote&apos;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>On board email</fullName>
        <active>false</active>
        <formula>AND(
Insurance_Certificate__c = TRUE,
Property_Reports__c = TRUE,
Tax_Assessment__c = TRUE,
Capital_Allocation_and_Approvals__c = TRUE,
Business_Tax_Returns__c = TRUE
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage changed date</fullName>
        <actions>
            <name>Update_stage_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Changed_Yield_Rate</fullName>
        <assignedTo>bruce.walker@cmbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Yield rate is finalised by the Product Manager, Kindly create a quote and proceed ahead</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Interest Rate Finalised</subject>
    </tasks>
    <tasks>
        <fullName>Checklist_completed_for_opportunity</fullName>
        <assignedTo>bruce.walker@cmbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Checklist completed for Opportunity</subject>
    </tasks>
    <tasks>
        <fullName>Configure_Products</fullName>
        <assignedTo>andrew.joubert@cmbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Configure Products</subject>
    </tasks>
    <tasks>
        <fullName>Service_Product</fullName>
        <assignedTo>trudie.sieberhagen@cmbank.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please start with products servicing.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Commence Products Servicing</subject>
    </tasks>
    <tasks>
        <fullName>Test_Task</fullName>
        <assignedTo>manoj.k.parida@pwc.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Test.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>User.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Test Task</subject>
    </tasks>
</Workflow>
