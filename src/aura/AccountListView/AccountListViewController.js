({
    doInit : function(component, event) {
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(a) {
            component.set("v.accounts", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    "gotoList" : function (component, event, helper) {
        var action1 = component.get("c.getListViews");
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": "00B63000000tBkOEAU",
                    "listViewName": null,
                    "scope": "Account"
                });
                navEvent.fire();
            }
            
        });
       $A.enqueueAction(action1); 
    }
})