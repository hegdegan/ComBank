({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRecentActivityList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.recentActivities", response.getReturnValue());
        });
        //var curr = component.find("annualRevenue");
        //curr.set("v.format", '$#,###M');
        // Invoke the service
        $A.enqueueAction(action);
    }
})