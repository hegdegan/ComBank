({
    doInit : function(component, event, helper) {
        var action = component.get("c.getEventList");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        action.setCallback(this, function(response) {
            console.log(response.getReturnValue());
            component.set("v.meetings", response.getReturnValue());
        });
        //var curr = component.find("annualRevenue");
        //curr.set("v.format", '$#,###M');
        // Invoke the service
        $A.enqueueAction(action);
    },
    
    createRecord : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Event",
            "defaultFieldValues": { 'WhatId' : component.get("v.recordId") }
        });
        createRecordEvent.fire();
    },
    showModal : function(component, event, helper) {
        var idx = event.target.id;
        var subject = event.target.value;
        component.set("v.meetingId", idx);
        component.set("v.meetingSubject", subject);
        document.getElementById("backGroundSectionId").style.display = "block";
        document.getElementById("newAccountSectionId").style.display = "block";
    },
    
    saveCallNote : function(component, event, helper) {
        var callNoteCreateAction = component.get("c.createCallNote");
        callNoteCreateAction.setParams({ "callNote" : component.get("v.callNote"),
                                        "parentMeetingId" : component.get("v.meetingId")});
        
        callNoteCreateAction.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.callNote" ,{ 'sobjectType': 'Call_Notes__c',
                             'Comments__c': '',
                             'Action_Items__c': ''
                             });
                document.getElementById("backGroundSectionId").style.display = "none";
                document.getElementById("newAccountSectionId").style.display = "none";
            } else if (a.getState() === "ERROR") {
                $A.log("Errors", a.getError());
            }
        });
        
        $A.enqueueAction(callNoteCreateAction);
        
        var componentEvent = $A.get("e.c:refreshCallNotes");
        componentEvent.fire();
    },
    
    showModalBox : function(component, event, helper) {
        document.getElementById("backGroundSectionId").style.display = "none";
        document.getElementById("newAccountSectionId").style.display = "none";
    },
    
    refreshCallNote : function(component, event, helper) {
        
    }
})