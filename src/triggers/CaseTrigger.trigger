trigger CaseTrigger on Case (after update, before update) {
    if(Trigger.isUpdate && Trigger.IsAfter){
        List<Case> listReviewCase = new List<Case>();
        List<Case> listSetupCase = new List<Case>();
        for(Case cases : trigger.New){            
            if(cases.Status=='Closed' && cases.Account_Setup_Completed__c == true && cases.Type == 'Onboarding'){
                system.debug('2');
                listSetupCase.add(cases);
            }
            else if(cases.Implementation_Review_Completed__c == true && cases.Type == 'Onboarding'){
                system.debug('1');
                listReviewCase.add(cases);
            }
        }
        system.debug('listReviewCase.size' + listReviewCase.size());
        system.debug('listSetupCase.size' + listSetupCase.size());
        if(listReviewCase.size() > 0)
            CaseTriggerHandler.afterReview(listReviewCase);
        if(listSetupCase.size() > 0)
            CaseTriggerHandler.afterSetup(listSetupCase);
    }
    else if(trigger.isUpdate && trigger.isBefore){
        for(Case cases : trigger.New){            
            if(cases.Account_Setup_Completed__c == true && cases.Type == 'Onboarding'){
                system.debug('2');
                cases.Status = 'Closed';
                cases.Reason = 'Setup Completed';
            }
        }
    }
}