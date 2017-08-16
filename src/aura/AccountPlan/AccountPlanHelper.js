({
	getAccPlanId : function(component) {
		var action = component.get("c.getAccPlanId");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.accPlanId", response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})