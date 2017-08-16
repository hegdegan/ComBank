public with sharing class HandlerTopOpportunities implements BotHandler {
    
    public BotResponse handle(String utterance, String[] params, Map<String, String> session) {
        Integer qty = Integer.valueof(params[0]);
        String accountId;
        if(params != null && params.size()>1){
        	accountId = params[1];
        }
        System.debug('accountid======>'+accountId);
        List<Opportunity> opportunities = 
            [SELECT Id, Name, Amount__c, Probability, StageName, CloseDate FROM Opportunity where isClosed=false AND accountid= :accountId ORDER BY amount__c DESC LIMIT :qty];
        
        List<BotRecord> records = new List<BotRecord>();
        
        for (Opportunity o : opportunities) {
            List<BotField> fields = new List<BotField>();
            fields.add(new BotField('Name', o.Name, '#/sObject/' + o.Id + '/view'));
            fields.add(new BotField('Amount', '$' + o.Amount__c));
            System.debug('o.Amount__c==='+o.Amount__c);
            fields.add(new BotField('Probability', '' + o.Probability + '%'));
            fields.add(new BotField('Stage', o.StageName));
            records.add(new BotRecord(fields));
        }
        return new BotResponse(new BotMessage('Bot', 'Here are your top ' + params[0] + ' opportunities:', records));
        
    }
    
}