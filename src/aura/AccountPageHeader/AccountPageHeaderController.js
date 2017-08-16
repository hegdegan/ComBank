({
    doInit : function(component, event, helper) {
        var action = component.get("c.getAccountDetails");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.accountDetails", response.getReturnValue());
        });
        var curr = component.find("comAmount");
        curr.set("v.format", '$#,###');
        var curr = component.find("aum");
        curr.set("v.format", '$#,###');
        var curr = component.find("outstandingOppty");
        curr.set("v.format", '$#,###');
        
        var curr = component.find("annualRevenue");
        curr.set("v.format", '$#,### M');
        // Invoke the service
        $A.enqueueAction(action);
    }
})