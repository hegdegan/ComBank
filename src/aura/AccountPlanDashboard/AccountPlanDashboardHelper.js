({
	createAnalysisFromProducts : function(component, planName) {
        var createAnalysis = component.get("c.createNeedAnalysis");
        createAnalysis.setParams({ "accPlanId" : component.get("v.recordId"),
                                        "planName" : planName});
        
        createAnalysis.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                } 
            else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        
        $A.enqueueAction(createAnalysis);
        
        var componentEvent = $A.get("e.c:RefreshNeedAnalysis");
        componentEvent.fire();
    },
    
    destroyAllCKInstances : function(component, instances){
        if(!$.isEmptyObject(instances)){
            for(var key in instances){
                instances[key].destroy();
            }
        }
    }
})