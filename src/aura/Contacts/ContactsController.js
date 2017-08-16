({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContactList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.contacts", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contact",
            "defaultFieldValues": { 'AccountId' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    }
})