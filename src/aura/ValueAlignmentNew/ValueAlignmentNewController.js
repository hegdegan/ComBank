({
	 doInit : function(component, event, helper) {
        var action = component.get("c.getValueAlignmentList");
        action.setParams({
            accPlanId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.valueAlignment", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(action);
    },
    addValue : function(component, event, helper) {
        localStorage.setItem("CB_ReloadFlag", "false");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Value_Alignment__c",
            "defaultFieldValues": { 'Value_Name__c' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    }
})