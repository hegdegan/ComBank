public class CaseTriggerHandler {
    public static void afterReview(List<Case> listCase){
        Set<Id> setOppId = new Set<Id>();
        
        for(Case cases : listcase){
            setOppId.add(cases.Opportunity__c);
        }
        
        List<Opportunity> listOpportunity = [select Id, StageName from Opportunity where Id in : setOppId];
        for(Opportunity opportunity : listOpportunity){
            opportunity.StageName = 'Account Setup';
        }
        update listOpportunity;
    }
    
    public static void afterSetup(List<Case> listCase){
        Set<Id> setOppId = new Set<Id>();
        
        for(Case cases : listcase){
            setOppId.add(cases.Opportunity__c);
        }
        List<Opportunity> listOpportunity = [select Id, StageName from Opportunity where Id in : setOppId];
        for(Opportunity opportunity : listOpportunity){
            opportunity.StageName = 'Closed Won';
        }
        update listOpportunity;
    }
}