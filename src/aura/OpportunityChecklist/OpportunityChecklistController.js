({
    doInit : function(component, event) {
        var action = component.get("c.getTopOpportunitiesForService");
        action.setCallback(this, function(a) {
            component.set("v.opportunities", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    "gotoOpportunityList" : function (component, event, helper) {
        var action1 = component.get("c.getOpptyListViews");
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
           
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": "00B63000000tBmFEAU",
                    "listViewName": null,
                    "scope": "Opportunity"
                });
                navEvent.fire();
            }
            
        });
       $A.enqueueAction(action1); 
    }
})