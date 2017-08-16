public class UpdateAccountTeamOnOpp 
{
    Set<ID> accountIDSet = new Set<ID>();
	Map<String,String> RMAcctTeamMap = new Map<String,String>();
	List<OpportunityTeamMember> oppTeamMembersList = new List<OpportunityTeamMember>();
   
	public void insertOpportunityTeam(List<Opportunity> oppList)
    {
        for(Opportunity opp : oppList)
        {
            accountIDSet.add(opp.accountID);
        }
        
        List<AccountTeamMember> AccountTeamMemberList = [Select a.UserId,a.User.Name,a.TeamMemberRole, a.Id, a.AccountId, a.OpportunityAccessLevel From AccountTeamMember a where  a.AccountId in :accountIDSet];
        
        system.debug('AccountTeamMemberList.size() ' +AccountTeamMemberList.size());

   		for(Opportunity o : oppList)
        {
            for(AccountTeamMember atm : AccountTeamMemberList)
            {
                if(atm.AccountId == o.AccountId)
                {    
       				OpportunityTeamMember otm = new OpportunityTeamMember();
           			otm.UserId = atm.UserId;
           			otm.TeamMemberRole = atm.TeamMemberRole;
           			otm.OpportunityAccessLevel = atm.OpportunityAccessLevel;
                    otm.OpportunityId = o.ID;
           			oppTeamMembersList.add(otm);
                }
            }
   		}
        
        system.debug('oppTeamMembersList.size() ' +oppTeamMembersList.size());
        
        if(oppTeamMembersList.size()!=0)
        {
            insert oppTeamMembersList; 
        }
	}
	
}