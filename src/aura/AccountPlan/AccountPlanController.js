({
    doInit : function(component, event, helper) {
        var action = component.get("c.getNeedAnalysisList");
        var callNotesAction = component.get("c.getCallNoteList");
        var accTeamMemberAction = component.get("c.getAccountTeamMembers");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        callNotesAction.setParams({
            accountId: component.get("v.recordId")
        });
        accTeamMemberAction.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.needAnalysis", response.getReturnValue());
        });
        callNotesAction.setCallback(this, function(response) {
            component.set("v.callNotes", response.getReturnValue());
        });
        accTeamMemberAction.setCallback(this, function(response) {
            component.set("v.accountTeamMembers", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(action);
        $A.enqueueAction(callNotesAction);
        $A.enqueueAction(accTeamMemberAction);
        
        helper.getAccPlanId(component);
    },
    handlerefreshCallNotes : function(component, event, helper) {
         var callNotesAction = component.get("c.getCallNoteList");
        callNotesAction.setParams({
            accountId: component.get("v.recordId")
        });
        callNotesAction.setCallback(this, function(response) {
            component.set("v.callNotes", response.getReturnValue());
        });
        $A.enqueueAction(callNotesAction);
    },
    
    openAccountPlan : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:AccountPlanPage",
            componentAttributes: {
                accId: component.get("v.recordId"),
                recordId: component.get("v.accPlanId")
            }
            });
        evt.fire();
    },
    createAccountPlan : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account_Plan__c",
            "defaultFieldValues": { 'Account__c' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    }
})