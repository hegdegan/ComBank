({
    myAction : function(component, event, helper) {
    },
    
    navigateToTask : function(component, event, helper){
         var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Task",
            "defaultFieldValues" : {'WhatId' : component.get("v.recordId")}
        });
        createRecordEvent.fire();
    }
})