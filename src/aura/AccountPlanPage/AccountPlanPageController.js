({
    myAction : function(component, event, helper) {
        console.log("main script loaded");
        $('.slds').removeClass('preload');
        AppMain.init();
        $('html,body').animate({
            scrollTop: 0,
            scrollLeft: 0
        }, 100, function(){
            $('html,body').clearQueue();
        });
     },
    doInit : function(component, event, helper) {
        /*if(component.get("v.accId") == null || component.get("v.accId") == 'null'){
            alert('controller;');
            var action = component.get("c.getAccountId");
            action.setParams({
                recordId: component.get("v.recordId")
            });
            // Register the callback function
            action.setCallback(this, function(response) {
                component.set("v.accId", response.getReturnValue());
            });
            $A.enqueueAction(action);
        }
        var action = component.get('c.AccountPlanDashboard');
        action.setCallback(component, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS'){
                $A.get('e.force:refreshView').fire();
            } else {
                //do something
            }
        }
                          );
        $A.enqueueAction(action);*/
    }
})