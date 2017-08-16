public with sharing class RelatedListController {
    
    @AuraEnabled 
    public static List<Account> getAccounts(){
        //Check for ownerId for Custom : Relationship Manager profile
        if(UserInfo.getProfileId().containsIgnoreCase(Label.RM_profile_id)){
            return [SELECT Id, Name,Phone,Assets_Under_Management__c, risk_factor__c, Industry,Retention_Risk__c,AnnualRevenue,Total_AUM__c FROM Account where ownerId = :UserInfo.getUserId() ORDER BY Total_AUM__c DESC LIMIT 4];
        }else{
            return [SELECT Id, Name,Phone,Assets_Under_Management__c, risk_factor__c, Industry,Retention_Risk__c,AnnualRevenue,Total_AUM__c FROM Account ORDER BY Total_AUM__c DESC LIMIT 4];
        }
    }
    @AuraEnabled 
    public static List<Opportunity> getTopOpportunities(){
        //Check for ownerId for Custom : Relationship Manager profile
        if(UserInfo.getProfileId().containsIgnoreCase(Label.RM_profile_id))
            return [SELECT Id, Name, Account.Name, Amount,Amount__c, StageName, CloseDate FROM Opportunity where StageName !='Closed Won' AND StageName !='Closed Lost' AND Account.ownerId = :UserInfo.getUserId() ORDER BY Amount__c DESC LIMIT 3];
        else
            return [SELECT Id, Name, Account.Name, Amount,Amount__c, StageName, CloseDate FROM Opportunity where StageName !='Closed Won' AND StageName !='Closed Lost' ORDER BY Amount__c DESC LIMIT 3];
    }
    
    @AuraEnabled 
    public static List<Account> getGrowthClientList(){
        //Check for ownerId for Custom : Relationship Manager profile
       if(UserInfo.getProfileId().containsIgnoreCase(Label.RM_profile_id))
            return [SELECT Id, Name,Phone,Assets_Under_Management__c,Total_AUM__c,Retention_Risk__c,Risk_Factor__c FROM Account where Retention_Risk__c='High' AND ownerId = :UserInfo.getUserId() ORDER BY Total_AUM__c DESC LIMIT 3];
        else
            return [SELECT Id, Name,Phone,Assets_Under_Management__c,Total_AUM__c, Retention_Risk__c,Risk_Factor__c FROM Account where Retention_Risk__c='High' ORDER BY Total_AUM__c DESC LIMIT 3];
    }
    
    @AuraEnabled
    public static List<ListView> getListViews() {
        List<ListView> listviews =  [SELECT Id, Name FROM ListView WHERE SobjectType = 'Account' and Name='Top Accounts'];
        return listviews;
    }
    
    @AuraEnabled
    public static List<ListView> getOpptyListViews() {
        List<ListView> listviews =  [SELECT Id, Name FROM ListView WHERE SobjectType = 'Opportunity' and Name='Top Opportunities'];
        return listviews;
    }
    
    @AuraEnabled 
    public static List<OpportunityLineItem> getTopProducts(){
        return [SELECT Id, Product2Id, Product2.Name, Opportunity.name, Type__c, Opportunity.Amount,Opportunity.Amount__c, Fee__c FROM OpportunityLineItem where Type__c != null AND Fee__c != null ORDER BY Opportunity.Amount__c DESC LIMIT 3];
    }
    
     @AuraEnabled 
    public static List<Opportunity> getTopOpportunitiesForService(){
        //owner is hardcoded to Bruce Edwards
        return [SELECT Id, Name, Account.Name, Amount,Amount__c, StageName, CloseDate FROM Opportunity where StageName ='Closed Won' AND (Insurance_Certificate__c = false OR Property_Reports__c = false 
                OR Tax_Assessment__c= false OR Capital_Allocation_and_Approvals__c = false OR Business_Tax_Returns__c = false)  AND Account.OwnerId =: UserInfo.getUserId() ORDER BY Amount DESC LIMIT 3];
    }
    
    @AuraEnabled
    public static User getCurrentUser() {
      User user = [SELECT Id, FirstName, LastName, Role__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
      return user;
  }
  }