({
	submit : function(component, utterance, session, callback) {
        var action = component.get("c.submit");
		action.setParams({
      		"utterance": utterance,
            "session": session,
            "accountId":component.get("v.recordId")
    	});
console.log('utterence==>',utterance);
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a.getReturnValue());
                callback(a.getReturnValue());
            } else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {
                var errors = a.getError();
                console.log(errors);
            }
    	});
    	$A.enqueueAction(action);
        if(utterance.toLowerCase() == 'create opportunities'){
            //var componentEvent = $A.get("e.c:RefreshNeedAnalysis");
            //componentEvent.fire();
            
           // var refreshComponents = $A.get("e.c:RefreshComponents");
           // refreshComponents.fire();
            
        }
	},
    
	upload: function(component, file, base64Data, callback) {
        var action = component.get("c.upload"); 
        action.setParams({
            fileName: file.name,
            content: base64Data
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
	            callback(a.getReturnValue());
            } else if (state === 'ERROR') {
	            var errors = a.getError();
                console.log(errors);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            } else if (state === "INCOMPLETE") {
				console.log("Incomplete");
            }

        });
        $A.enqueueAction(action); 
    }

})