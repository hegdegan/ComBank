({
    doInit : function(component, event, helper) {
        var action = component.get("c.getOpportunityList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.opportunities", response.getReturnValue());
        });
        //var curr = component.find("annualRevenue");
        //curr.set("v.format", '$#,###M');
        // Invoke the service
        $A.enqueueAction(action);
        var getProfile = component.get("c.getProfileName");
        getProfile.setParams({ });
        // Register the callback function
        getProfile.setCallback(this, function(response) {
            component.set("v.profileName", response.getReturnValue());
        });
        $A.enqueueAction(getProfile);
    },
    
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Opportunity",
            "defaultFieldValues" : {'AccountId' : component.get("v.recordId")}
        });
        createRecordEvent.fire();
    },
    showChecklist : function (component, event, helper) {
        var idx = event.target.value;
        console.log("idx====",idx);
        var componentEvent = $A.get("e.c:SendOpportunityId");
        componentEvent.setParams({oppId : idx});
        componentEvent.fire();
        $('html,body').animate({
            scrollTop: $(document).height(),
            scrollLeft: 0
        }, 800, function(){
            $('html,body').clearQueue();
        });
    },
    
    handleRefreshComponents: function (component, event, helper) {
        console.log("event received ====================");
        //this.doInit(component, event, helper);
    }
})