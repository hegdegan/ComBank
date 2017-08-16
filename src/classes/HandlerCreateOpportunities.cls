public with sharing class HandlerCreateOpportunities implements BotHandler {
    
    public BotResponse handle(String utterance, String[] params, Map<String, String> session) {
        //Integer qty = Integer.valueof(params[0]);
        String accountId;
        if(params != null && params.size()>0){
            accountId = params[0];
        }
        System.debug('accountid======>'+accountId);
        List<Opportunity> opportunities = new List<Opportunity>();
        if(accountId != null){
            Account acc = [select Name from Account where Id = :accountId];
            List<Account_Plan__c> accountPlanList = [select Id, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                                                     RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                                                     Commitment_Amount__c from Account_Plan__c where Account__c =: accountId and Status__c = 'Active'];
            List<Customer_Need_Analysis__c> needAnalysisList = [select Id, Name, Product_Name_X__r.Name, Service_Provider__c, Services_Used__c,
                                                                Actual_Revenue__c, Future_Opportunity__c, Share_of_Wallet_estimate__c, RM_Estimate__c,
                                                                Comments__c, Opportunity_Created__c from 
                                                                Customer_Need_Analysis__c where Product_Name_X__c in : accountPlanList];
            for(Customer_Need_Analysis__c cna : needAnalysisList){
                if(!cna.Opportunity_Created__c){
                    cna.Opportunity_Created__c = true;
                    Opportunity opp = new Opportunity(Name = acc.Name+' - '+cna.Name+' - FY 17', Amount__c = cna.Actual_Revenue__c,
                                                     AccountId = accountId, closeDate = System.today().addDays(15),
                Start_Date__c = System.today().addDays(30),
                End_date__c = System.today().addDays(395),
                Product__c = 'Loans',
                stageName = 'Prospecting');
                    opportunities.add(opp);
                }
            }
            insert opportunities;
            update needAnalysisList;
        }
        List<BotRecord> records = new List<BotRecord>();
        
        for (Opportunity o : opportunities) {
            List<BotField> fields = new List<BotField>();
            fields.add(new BotField('Name', o.Name, '#/sObject/' + o.Id + '/view'));
            fields.add(new BotField('Amount', '$' + o.Amount__c));
            fields.add(new BotField('Stage', o.StageName));
            records.add(new BotRecord(fields));
        }
        if(opportunities.size() == 0){
             return new BotResponse(new BotMessage('Bot', 'Opportunities have already been created for existing Need Analysis records', records));
        }
        return new BotResponse(new BotMessage('Bot', 'Created ' + opportunities.size() + ' opportunities:', records));
    }
}