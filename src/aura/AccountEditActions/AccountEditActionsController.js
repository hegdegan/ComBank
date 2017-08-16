({
    doInit : function(component, event, helper) {
        var action = component.get("c.getAccountPlanName");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.planName", response.getReturnValue());
        });
        $A.enqueueAction(action);
        
        var getAccountId = component.get("c.getAccountId");
        getAccountId.setParams({
            recordId: component.get("v.recordId")
        });
        // Register the callback function
        getAccountId.setCallback(this, function(response) {
            component.set("v.accId", response.getReturnValue());
        });
        $A.enqueueAction(getAccountId);
    },
    saveAccountPlan : function(component, event, helper) {
        var componentEvent = $A.get("e.c:SaveAccountPlanEvent");
        componentEvent.fire();
    },
    goBack : function(component, event, helper) {
        localStorage.setItem("CB_ReloadFlag", "false");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:AccountPage",
            componentAttributes: {
                recordId: component.get("v.accId"),
            }
        });
        evt.fire();
    }
})