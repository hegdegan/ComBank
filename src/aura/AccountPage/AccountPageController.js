({
	myAction : function(component, event, helper) {
        $('.slds').removeClass('preload');
        AppMain.init();
	},
    doInit : function(component, event, helper) {
        var action = component.get("c.getProfileName");
        action.setParams({ });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.profileName", response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})