({
    doInit : function(component, event) {
        var action = component.get("c.getTopProducts");
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    "gotoOpptyList" : function (component, event, helper) {
        var action1 = component.get("c.getOpptyListViews");
        action1.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
           
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": "00B63000000xwAiEAI",
                    "listViewName": null,
                    "scope": "Product2"
                });
                navEvent.fire();
            }
            
        });
       $A.enqueueAction(action1); 
    }
})