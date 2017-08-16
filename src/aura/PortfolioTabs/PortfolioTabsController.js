({
    doInit : function(component, event, helper) {
        var loanAction = component.get("c.getLoanList");
        var depositAction = component.get("c.getDepositList");
        var derivativeAction = component.get("c.getDerivativeList");
        var fxAction = component.get("c.getFXList");
        var cardAction = component.get("c.getCardList");
        loanAction.setParams({
            accountId: component.get("v.recordId")
        });
        depositAction.setParams({
            accountId: component.get("v.recordId")
        });
        derivativeAction.setParams({
            accountId: component.get("v.recordId")
        });
        fxAction.setParams({
            accountId: component.get("v.recordId")
        });
        cardAction.setParams({
            accountId: component.get("v.recordId")
        });
        // Register the callback function
        loanAction.setCallback(this, function(response) {
            component.set("v.loans", response.getReturnValue());
        });
        depositAction.setCallback(this, function(response) {
            component.set("v.deposits", response.getReturnValue());
        });
        derivativeAction.setCallback(this, function(response) {
            component.set("v.derivatives", response.getReturnValue());
        });
        fxAction.setCallback(this, function(response) {
            component.set("v.fx", response.getReturnValue());
        });
        cardAction.setCallback(this, function(response) {
            component.set("v.cards", response.getReturnValue());
        });
        // Invoke the service
        $A.enqueueAction(loanAction);
        $A.enqueueAction(depositAction);
        $A.enqueueAction(derivativeAction);
        $A.enqueueAction(fxAction);
        $A.enqueueAction(cardAction);
        
        var userRole = component.get("c.getUserRole");
        userRole.setParams({
            accountId: component.get("v.recordId")
        });
        userRole.setCallback(this, function(response) {
            component.set("v.userRole", response.getReturnValue());
            $(".main-content-tabs").show();
            setTimeout(function(){
                var allTabs = $("ul[role='tablist']:not([auto-init='false'])");
                
                for (var i = 0, iLen = allTabs.length; i < iLen; i++) {
                    var tabInstance = $(allTabs[i]);
                    
                    (function (currTabList) {
                        currTabList.find("li.slds-tabs_default__item").on("click", function () {
                            var tabToShow = $(this).find("a").attr("aria-controls");
                            
                            currTabList.find("li.slds-tabs_default__item").removeClass("slds-is-active");
                            $(this).addClass("slds-is-active");
                            
                            currTabList.parent().children("div[role='tabpanel']").removeClass("slds-show").addClass("slds-hide");
                            currTabList.parent().children("div[role='tabpanel'][id='" + tabToShow + "']").removeClass("slds-hide").addClass("slds-show");
                        });
                    })(tabInstance);
                }
                
                $("ul[role='tablist'] > li:first-child").trigger("click");
            }, 500);
        });
        $A.enqueueAction(userRole);
    },
    myAction : function(component, event, helper) {
        
    },
})