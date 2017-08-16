@RestResource(urlMapping='/createOpportunity/*')
global with sharing class CreateRecordFromBot {

    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        return UserInfo.getSessionId();
    }
  
    @HttpPost
    global static String doPost(String accountId, String productName, String endDate, Integer amount) {
        try{
            Account acc  = [select Name from Account where Id = :accountId];
            Opportunity oppty = new Opportunity(
                Name = acc.Name +' - '+productName +' - FY 17',
                AccountId = accountId,
                closeDate = Date.valueOf(endDate),
                Start_Date__c = Date.valueOf(endDate).addDays(30),
                End_date__c = Date.valueOf(endDate).addDays(395),
                Product__c = 'Loans',
                stageName = 'Prospecting',
            Amount__c = Decimal.valueOf(amount));
            insert oppty;
            return 'Opportunity has been created. Name: '+oppty.Name;
        }catch(Exception ex){
            return 'Error while creating an Opportunity. Error Message: '+ex.getMessage();
        }
        return 'Error in rest call';
    }
}