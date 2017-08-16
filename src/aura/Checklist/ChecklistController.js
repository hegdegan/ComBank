({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpportunityChecklist");
        action.setParams({
            opptyId: "00663000006t4tBAAQ"//component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.oppty", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    updateOppty : function(component, event, helper) {
        var updateAction = component.get("c.updateOpportunityCheckList");
        updateAction.setParams({ "oppty" : component.get("v.oppty")});
        
        updateAction.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                console.log("updated--------");
            } 
            else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        
        $A.enqueueAction(updateAction);
        
        // var componentEvent = $A.get("e.c:RefreshNeedAnalysis");
        //componentEvent.fire();
    },
    getOpportunityId :function(component, event, helper) {
        console.log('here',event.getParam("oppId"));
        var action = component.get("c.getOpportunityChecklist");
        action.setParams({
            opptyId: event.getParam("oppId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.oppty", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})