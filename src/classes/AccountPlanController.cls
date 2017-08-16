public class AccountPlanController {
    public Account account{get;set;}
    public Account_Plan__c accountPlan{get;set;}
    public List<Case> listCase{get;set;}
    public List<Event> listMeeting{get;set;}
    public List<Task> listTask{get;set;}
    public List<Opportunity> listOpportunity{get;set;}
    public List<Account_Plan__c> listAccountPlan{get;set;}
    public List<Contact> listContact{get;set;}
    public List<Customer_Need_Analysis__c> listNeedAnalysis{get;set;}
    public List<Value_Alignment__c> listValueAlignment{get;set;}
    public List<Action_Plan__c> listActionPlan{get;set;}
    public List<AccountTeamMember> listAccountTeamMember{get;set;}
    public List<Next_Best_Product__c> listNextBestProduct{get;set;}
    public List<Deposit__c> listDeposit{get;set;}
    public List<Obligation__c> listDerivative{get;set;}
    public List<Obligation__c> listFX{get;set;}
    public List<Obligation__c> listCreditCard{get;set;}
    public String parentMeetingId{get;set;}
    public Call_Notes__c callNote{get;set;}
    public String meetingName{get;set;}
    public String meetingDateTime{get;set;}
    public List<Call_Notes__c> listCallNotes{get;set;}
    
    public double committmentAmount{get;set;}
    public double averageOutStanding{get;set;}
    public double annualRevenue{get;set;}
    public double allInDrawnSpread{get;set;}
    public double roec{get;set;}
    public double rorc{get;set;}
    public string data1{get;set;}
    public string data2{get;set;}
    String accountId ;
    public Id actPlanId{get;set;}
    public string address{get;set;}
    
    public double annualR {get;set;}
    public string CompanyGrowthIndicator {get;set;}
    public string AccountgrowthIndicator {get;set;}
    
    public class OpportunityWrapper{
        public Opportunity opp{get;set;}
        public string trend{get;set;}
    }
    
    public AccountPlanController(ApexPages.StandardController std){
        String urlString = ApexPages.currentPage().getURL();
        system.debug('urlString==============='+urlString);
        actPlanId = std.getId();
        accountId = ApexPages.currentPage().getParameters().get('accountId');
        //set accountid back after refresh
        if(!String.isEmpty(actPlanId))
            accountId = [select account__c from account_plan__c where id = :actPlanId].account__c;
        if(accountId != null){
            account = [SELECT Id,Name,Region__c,Industry,Tenure__c,AnnualRevenue,Parent.Name, CreatedDate, retention_risk__c, risk_factor__c,
                       Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode,Company_Growth_Indicator__c,Account_growth_Indicator__c,
                       BillingCountry,Website, account.owner.firstName
                       from Account where Id=: accountId]; 
            
            address = ' ' + account.BillingStreet + ', ' + 
                account.BillingCity+', ' + account.BillingState + ' ' +account.BillingPostalCode;
            
            listOpportunity = [select Id, Name, Amount,Amount__c, StageName,ExpectedRevenue,CloseDate,CreatedDate,LastModifiedDate,Age__c,Opportunity_Age__c from Opportunity where AccountId =: accountId
                          order by CloseDate desc];
            listContact = [select Id, Name,Salutation, FirstName, LastName, Phone, Email, Title FROM contact where AccountId =: accountId
                           order by LastName asc];
            listMeeting = [select Id, Subject, StartDateTime,ActivityDateTime,Description,DurationInMinutes,
                           Call_Notes__c from Event where WhatId =: accountId and StartDateTime >= Today
                           order by StartDateTime asc];
            listTask = [select Id, Subject, Status,ActivityDate from Task where WhatId =: accountId and ActivityDate >= today order by ActivityDate asc];
        }
        if(actPlanId != null){
            accountPlan = [select Id, Name , Account__c, Results_What_we_know__c, 
                           Results_What_we_Need_to_Know__c, Obstacles_What_We_Know__c, 
                           Obstacles_What_we_Need_to_Know__c, Execution_What_we_Know__c,
                           Execution_What_we_Need_to_Know__c, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                           RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                           Commitment_Amount__c from Account_Plan__c where Id =: actPlanId limit 1];
            
            listNeedAnalysis = [select Id, Name, Product_Name_X__r.Name, Service_Provider__c, Services_Used__c,
                                Actual_Revenue__c, Future_Opportunity__c, Share_of_Wallet_estimate__c, RM_Estimate__c, Comments__c from 
                                Customer_Need_Analysis__c where Product_Name_X__c =: actPlanId];
            
            listValueAlignment = [select Id, Name , Corp_Finance_M_A__c, Global_Markets_FX_IRD__c, Price__c, Structure__c,Competitor__c,
                                  Treasury__c, Value_Name__c from Value_Alignment__c where  Value_Name__c =: actPlanId];
            listNextBestProduct = [select Id, Name, Proposed_Date_of_Offer__c, Status__c from Next_Best_Product__c where 
                                   Account_Name__c =: accountId ];
            
            data1 = '';
            data2 = '';
            if(listValueAlignment.size() > 0){
                data1 = listValueAlignment[0].Treasury__c + ',' + listValueAlignment[0].Price__c + ',' + listValueAlignment[0].Structure__c + ',' + listValueAlignment[0].Corp_Finance_M_A__c + ',' + listValueAlignment[0].Global_Markets_FX_IRD__c;
                if(listValueAlignment.size() > 1)
                    data2 = listValueAlignment[1].Treasury__c + ',' + listValueAlignment[1].Price__c + ',' + listValueAlignment[1].Structure__c + ',' + listValueAlignment[1].Corp_Finance_M_A__c + ',' + listValueAlignment[1].Global_Markets_FX_IRD__c;
            }
            listActionPlan = [select  Id,Responsible_Team_Member__c, Timing__c from Action_Plan__c where  Account_Plan_NameX__c =: actPlanId];
        }
        else{
            accountPlan = new Account_Plan__c();
            accountPlan.Account__c = accountId;
            listActionPlan = new List<Action_Plan__c>();
            listValueAlignment = new List<Value_Alignment__c>();
            listNeedAnalysis = new List<Customer_Need_Analysis__c>();            
        }
        
        listAccountPlan = [select Id, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                           RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                           Commitment_Amount__c from Account_Plan__c where Account__c =: accountId];
        
        committmentAmount = 0;
        averageOutStanding = 0;
        annualRevenue = 0;
        allInDrawnSpread = 0;
        roec = 0;
        rorc = 0;
        
        annualR= 0;
        CompanyGrowthIndicator  ='';
        AccountgrowthIndicator ='';
        
        
        if(account.AnnualRevenue !=null) {
            annualR= (account.AnnualRevenue)/1000000;
        }
        if(account.Company_Growth_Indicator__c !=null) {    
            CompanyGrowthIndicator  = account.Company_Growth_Indicator__c;
        }
        if(account.Account_growth_Indicator__c !=null) {    
            AccountgrowthIndicator = account.Account_growth_Indicator__c;
        }    
        
        for(Account_Plan__c accountPlan : listAccountPlan){
            if(accountPlan.Commitment_Amount__c > 0)
                committmentAmount += accountPlan.Commitment_Amount__c;
            if(accountPlan.Average_Outstanding__c > 0)
                //averageOutStanding += accountPlan.Average_Outstanding__c;
            if(accountPlan.Annual_Revenue__c > 0)
                //annualRevenue  += accountPlan.Annual_Revenue__c;
            if(accountPlan.All_In_Drawn_Spread_LIBOR_Spread_Faci__c > 0)
                allInDrawnSpread += accountPlan.All_In_Drawn_Spread_LIBOR_Spread_Faci__c;
            if(accountPlan.ROEC_Return_on_Economic_Capital__c > 0)
                roec += accountPlan.ROEC_Return_on_Economic_Capital__c;
            if(accountPlan.RORC_Return_on_Regulatory_Capital__c > 0)
                rorc += accountPlan.RORC_Return_on_Regulatory_Capital__c;
        }
        for(Opportunity opp : listOpportunity){
            if(Opp.StageName == 'Closed Won')
                averageOutStanding += Opp.Amount__c; 
            if(Opp.StageName != 'Closed Won' && Opp.StageName != 'Closed Lost')
            annualRevenue +=Opp.Amount__c; 
        }
    }
    
    public pageReference SaveAccountPlan(){
        upsert accountPlan;
        return new Pagereference('/'+accountId);
    }
    public void showCallNoteModal()
    {
        callNote = new Call_Notes__c();
        callNote.Activity_Id__c = parentMeetingId;
    }
    public void createCallNote()
    {
        insert callNote;
    }
    public pageReference Cancel(){
        return new Pagereference('/'+accountId);
    }
    public void addAnalysisToList(){
        system.debug('added=================');
        listNeedAnalysis = [select Id, Name, Product_Name_X__r.Name, Service_Provider__c, Services_Used__c,
                            Actual_Revenue__c, Future_Opportunity__c, Share_of_Wallet_estimate__c, RM_Estimate__c, Comments__c from 
                            Customer_Need_Analysis__c where Product_Name_X__c =: actPlanId];
    }
}