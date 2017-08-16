trigger UpdateContactIDAndInsertOpportunityTeam on Opportunity (before update, after insert,after update) 
{
    
    Map<ID, OpportunityContactRole> oppContactRoleMap = new Map<ID, OpportunityContactRole>();
    
    List<Opportunity> updateOppList = new List<Opportunity>();
    if(trigger.isbefore)
    {
        if(trigger.isUpdate)
        {    
            system.debug(trigger.newMap.keyset());
            system.debug('BBBB');
            List<OpportunityContactRole> oppContactRoleList = [SELECT ContactId,Id,OpportunityId,Role FROM OpportunityContactRole where OpportunityID IN: trigger.newMap.keyset() and isPrimary = true];    
        
            system.debug(oppContactRoleList.size());
            for(OpportunityContactRole ocr : oppContactRoleList)
            {   
                oppContactRoleMap.put(ocr.OpportunityID, ocr);
            }       
            
            if(oppContactRoleMap.size() != 0)
            {    
                for(Opportunity opp : trigger.new)
                {   
                    if(oppContactRoleMap.get(opp.Id) != null)
                    	opp.Primary_Contact__c = oppContactRoleMap.get(opp.Id).ContactID;
                }
            }    
        }    
     
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {    
            UpdateAccountTeamOnOpp uato = new UpdateAccountTeamOnOpp();
            uato.insertOpportunityTeam(trigger.new);
            // Added to create deposite and obligation iff opportunity stage is closed won
            // Opportunity_Helper.opportunityStageWoncheck(trigger.newMap);
        } 
        
        if(trigger.isUpdate) {
            // Added to create deposite and obligation iff opportunity stage is closed won
            if(Opportunity_Helper.runOnce()) {
                system.debug('Count====>');
                Opportunity_Helper.opportunityStageWoncheck(trigger.newMap,trigger.oldMap);
                Opportunity_Helper.taskcreattionchech(trigger.newMap,trigger.oldMap);
            }
        }   
    }    
    
}