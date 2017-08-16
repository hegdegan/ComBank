({
	doInit : function(component, event, helper) {
    var action = component.get("c.getAccountName");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            component.set("v.accountName", response.getReturnValue());
            /*var name = response.getReturnValue();
            console.log("acc name==>",name);
            var filter='{"datasets": {"RM_Wave_Datset": [{"fields": ["Account"],"filter": {"operator": "matches","values": ["J.M. Soft"]}}]}}';
            
            //console.log("filter====>",JSON.parse(filter));
            component.set("v.filter",filter);*/
        });
        $A.enqueueAction(action);
    }
})