({
    doInit : function(component, event, helper) {
        var action = component.get("c.getRPList");
        action.setParams({
            
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.rpList", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(action);
        
        var accPlanAction = component.get("c.getAccountPlan");
        accPlanAction.setParams({
            accPlanId: component.get("v.recordId")
        });
        accPlanAction.setCallback(this, function(response){
            component.set("v.accPlan", response.getReturnValue());
            var dashboardObj = response.getReturnValue();
            //var drWhatWeKnw = dashboardObj["Results_What_we_know__c"];
            //CKEDITOR.instances["dr_whatweknow"].destroy();
            
            setTimeout(function(){
                var instances = CKEDITOR.instances ? CKEDITOR.instances : {};
                helper.destroyAllCKInstances(component, instances);
                $(".ckeditor").ckeditor();
                
                CKEDITOR.instances["dr_whatweknow"].setData(dashboardObj["Results_What_we_know__c"]);
                CKEDITOR.instances["dr_needtoknow"].setData(dashboardObj["Results_What_we_Need_to_Know__c"]);
                CKEDITOR.instances["o_whatweknow"].setData(dashboardObj["Obstacles_What_We_Know__c"]);
                CKEDITOR.instances["o_needtoknow"].setData(dashboardObj["Obstacles_What_we_Need_to_Know__c"]);
                CKEDITOR.instances["ar_whatweknow"].setData(dashboardObj["Execution_What_we_Know__c"]);
                CKEDITOR.instances["ar_needtoknow"].setData(dashboardObj["Execution_What_we_Need_to_Know__c"]);
            }, 500);
        });
        $A.enqueueAction(accPlanAction);
    },
    getInput : function(cmp, event, helper) { 
        var currCB = $(event.getSource().elements[0]);
        var discussedWithClientCB = currCB.parents("tr").find("td[data-label='Discussed with Client?'] input[type='checkbox']");
        var oppExistsCB = currCB.parents("tr").find("td[data-label='Opportunity Exists?'] input[type='checkbox']");
        
        console.log(discussedWithClientCB, oppExistsCB);
        
        if(discussedWithClientCB.is(":checked") && oppExistsCB.is(":checked") ){
            var planName = currCB.parents("tr").find("th[data-label='Name']").text();
            helper.createAnalysisFromProducts(cmp,planName);
        }
    },
    saveAccPlan : function(component, event, helper) {
        var callNoteCreateAction = component.get("c.saveAccountPlan");
        component.set("v.accPlan.Results_What_we_know__c", CKEDITOR.instances["dr_whatweknow"].getData());
        component.set("v.accPlan.Results_What_we_Need_to_Know__c", CKEDITOR.instances["dr_needtoknow"].getData());
        component.set("v.accPlan.Obstacles_What_We_Know__c", CKEDITOR.instances["o_whatweknow"].getData());
        component.set("v.accPlan.Obstacles_What_we_Need_to_Know__c", CKEDITOR.instances["o_needtoknow"].getData());
        component.set("v.accPlan.Execution_What_we_Know__c", CKEDITOR.instances["ar_whatweknow"].getData());
        component.set("v.accPlan.Execution_What_we_Need_to_Know__c", CKEDITOR.instances["ar_needtoknow"].getData());
        callNoteCreateAction.setParams({ "accPlanId" : component.get("v.recordId"),
                                        "accPlan" : component.get("v.accPlan")
                                       });
        
        callNoteCreateAction.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        
        $A.enqueueAction(callNoteCreateAction);
    }
    
})