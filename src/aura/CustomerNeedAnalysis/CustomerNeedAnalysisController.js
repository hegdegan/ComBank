({
	 doInit : function(component, event, helper) {
        var action = component.get("c.getNeedAnalysisList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.needAnalysis", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(action);
    },
    addAnalysis : function(component, event, helper) {
         var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Customer_Need_Analysis__c",
            "defaultFieldValues": { 'Product_Name_X__c' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    },
    handleRefreshNeedAnalysis :  function(component, event, helper) {
        localStorage.setItem("CB_ReloadFlag", "false");
        var action = component.get("c.getNeedAnalysisList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.needAnalysis", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(action);
    }
})