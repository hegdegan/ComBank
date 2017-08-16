({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCasesList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.cases", response.getReturnValue());
        });
        //var curr = component.find("annualRevenue");
        //curr.set("v.format", '$#,###M');
        // Invoke the service
        $A.enqueueAction(action);
    },
    
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Case",
            "defaultFieldValues": { 'AccountId' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    }
})