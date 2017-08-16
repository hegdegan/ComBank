public class Account360Controller {
    public Account account{get;set;}
    public List<Case> listCase{get;set;}
    public List<Event> listMeeting{get;set;}
    public List<Task> listTask{get;set;}
    public List<OpportunityWrapper> listOpportunity{get;set;}
    public List<Account_Plan__c> listAccountPlan{get;set;}
    public List<Contact> listContact{get;set;}
    public List<Customer_Need_Analysis__c> listNeedAnalysis{get;set;}
    public List<Value_Alignment__c> listValueAlignment{get;set;}
    public List<Action_Plan__c> listActionPlan{get;set;}
    public List<AccountTeamMember> listAccountTeamMember{get;set;}
    public List<Obligation__c> listLoan{get;set;}
    public List<Deposit__c> listDeposit{get;set;}
    public List<Obligation__c> listDerivative{get;set;}
    public List<Obligation__c> listFX{get;set;}
    public List<Obligation__c> listCreditCard{get;set;}
    public List<Call_Notes__c> listCallNotes{get;set;}
    public List<Next_Best_Product__c> listNextBestProduct{get;set;}
    public List<RecentlyViewed> ListRecentActivity {get;set;}
    public String parentMeetingId{get;set;}
    public Call_Notes__c callNote{get;set;}
    public String meetingName{get;set;}
    public String meetingDateTime{get;set;}
    public Id accPlanId{get;set;}
    public double committmentAmount{get;set;}
    public double averageOutStanding{get;set;}
    public double annualR{get;set;}
    public double allInDrawnSpread{get;set;}
    public double roec{get;set;}
    public double rorc{get;set;}
    
    public string data1{get;set;}
    public string data2{get;set;}
    public string data3{get;set;}
    public string data4{get;set;}
    public string data5{get;set;}
    public string data6{get;set;}
    
    public string companyName {get;set;}
    public string competitorName1 {get;set;}
    public string competitorName2 {get;set;}
    
    
    public double annualrevenue {get;set;}
    public string CompanyGrowthIndicator {get;set;}
    public string AccountgrowthIndicator {get;set;}
    
    public string address{get;set;}
    public String userRole { get; set; }
    public Boolean showChecklist { get; set; }
    public String selectedOpp {get; set; }
    public Opportunity oppty {get; set; }
    public List<recentCreatedWrapper> wrapperList {get;set;}
    
    public List<contact> contactCreatedList {get;set;}
    public List<Opportunity> opportunityList {get;set;}
    public List<Account_Plan__c> accountPlanCreatedList {get;set;}
    public List<Customer_Need_Analysis__c> cnaCreatedList { get; set; }
    
    public List<String> companyNameList {get;set;}
    
    public class OpportunityWrapper{
        public Opportunity opp{get;set;}
        public string trend{get;set;}
    }
    
    public class recentCreatedWrapper {
        public string activityName {get;set;}
        public datetime createdTime {get;set;}
        public id recordId {get;set;}
        public recentCreatedWrapper (string activityName ,datetime createdTime,id recordId){ 
            this.activityName = activityName ;
            this.createdTime = createdTime ;
            this.recordId    = recordId   ;
        
        }
    }
    Id id;
    public Account360Controller(ApexPages.StandardController std){
        wrapperList = new List<recentCreatedWrapper>();
        companyNameList  = new List<String>();
        id = std.getId();
        account = [SELECT Id,Name,Region__c,Industry,Tenure__c,AnnualRevenue,Parent.Name, CreatedDate,retention_risk__c, risk_factor__c,
                   Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                    BillingCountry,Website, account.owner.FirstName,Company_Growth_Indicator__c,Account_growth_Indicator__c
                   from Account where Id=: id]; 
        userRole = 'All';
        Map<String,String> userRoleAndProductMap = new Map<String,String>();
        userRoleAndProductMap.put('Product Manager - Commercial Real Estate','Loan');
        userRoleAndProductMap.put('Product Manager - Money Market Investment','Deposit');
        userRoleAndProductMap.put('Product Manager - Commercial Lines of Credit','Loan');
        userRoleAndProductMap.put('Product Manager - Commercial Term Loans','Loan');
        List<AccountTeamMember> atmList = [select UserId, TeamMemberRole from AccountTeammember where accountid = :id AND UserId = :UserInfo.getUserId() LIMIT 1];
        //system.debug('atmList[0].TeamMemberRole===='+atmList[0].TeamMemberRole);
        if(atmList.size() > 0 && userRoleAndProductMap.containsKey(atmList[0].TeamMemberRole)){
            userRole = userRoleAndProductMap.get(atmList[0].TeamMemberRole);
        }
        system.debug('userRole==='+userRole);
        address = ' ' + account.BillingStreet + ', ' + 
                                            account.BillingCity+', ' + account.BillingState + ' ' +account.BillingPostalCode;
        listContact = [select Id,Name, Salutation, FirstName, LastName, Phone, Email, Title FROM contact where AccountId =: id
                      order by LastName asc];
        listCase = [select Id, Subject, Priority,CaseNumber,Status from Case where AccountId =: id order by createddate desc];
        listMeeting = [select Id, Subject, StartDateTime,ActivityDateTime,Description,DurationInMinutes,
                       Call_Notes__c from Event where WhatId =: id and StartDateTime >= Today
                       order by StartDateTime desc];
        listTask = [select Id, Subject, Status,ActivityDate from Task where WhatId =: id and ActivityDate >= today order by ActivityDate asc];
        List<Opportunity> listOpportunities = [select Id, Name, Amount,Amount__c, StageName,ExpectedRevenue,End_date__c,CloseDate,CreatedDate,LastModifiedDate,Age__c,Overall_Age__c, Opportunity_Age__c from Opportunity where AccountId =: id
                          order by CloseDate desc];
        ListRecentActivity =[SELECT Id, Name FROM RecentlyViewed WHERE Type IN ('Opportunity') ORDER BY LastViewedDate DESC]; 
        
        contactCreatedList =[SELECT id,name,CreatedDate,LastModifiedDate,accountid FROM contact WHERE accountid =:id and CreatedDate=TODAY LIMIT 3 ]  ;
        opportunityList =[SELECT id,name,CreatedDate,LastModifieddate,accountid FROM Opportunity WHERE accountid =:id and CreatedDate=TODAY LIMIT 3 ]  ;
        accountPlanCreatedList = [SELECT id,name,CreatedDate,LastModifieddate,Account__c FROM Account_Plan__c WHERE Account__c =:id and CreatedDate=TODAY LIMIT 3] ;
        //cnaCreatedList = [select id, name, createddate from Customer_Need_Analysis__c where ]
        for(Account_Plan__c  accplan : accountPlanCreatedList  ) {
            wrapperList.add(new recentCreatedWrapper ('Account Plan -' + accplan.name + ' was created' ,accplan.createdDate , accplan.id));
        }
        
        for(opportunity opp : opportunityList ) {
            wrapperList.add(new recentCreatedWrapper ('Opportunity - ' + opp.name +  ' was created' ,opp.createdDate , opp.id));
        }
        
        
        for(contact con : contactCreatedList  ) {
            wrapperList.add(new recentCreatedWrapper ('Contact - '+ con.name + ' was created' ,con.createdDate , con.id));
        }
        
       
                    
        
        listOpportunity = new List<OpportunityWrapper>();
        for(Opportunity opp : listOpportunities){
            OpportunityWrapper OpportunityWrapper = new OpportunityWrapper();
            OpportunityWrapper.opp = opp;
            
            if(opp.createddate <= system.today() + 30 && (opp.StageName == 'Prospecting' || opp.StageName == 'Qualification'
                                                         || opp.StageName == 'Needs Analysis'  || opp.StageName == 'Value Proposition')){
                OpportunityWrapper.trend = 'Down';
            }
            else if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost'){
                OpportunityWrapper.trend = 'Up';
            }
            else if(opp.StageName == 'Closed Won'){
                OpportunityWrapper.trend = 'Won';
            }
            else{
                OpportunityWrapper.trend = 'Lost';
            }
            listOpportunity.add(OpportunityWrapper);
        }
        listAccountPlan = [select Id, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                           RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                           Commitment_Amount__c from Account_Plan__c where Account__c =: id and Status__c = 'Active'];
        if(listAccountPlan!=null && listAccountPlan.size() >0)
            accPlanId = listAccountPlan[0].Id;
        listNeedAnalysis = [select Id, Name, Product_Name_X__r.Name, Service_Provider__c, Services_Used__c,
                            Actual_Revenue__c, Future_Opportunity__c, Share_of_Wallet_estimate__c, RM_Estimate__c, Comments__c from 
                            Customer_Need_Analysis__c where Product_Name_X__c in : listAccountPlan];
        
        listValueAlignment = [select  Id,Name,Corp_Finance_M_A__c, Global_Markets_FX_IRD__c, Price__c, Structure__c,Competitor__c,
                            Treasury__c, Value_Name__c, Business_Checking_Savings__c,Business_Loans__c,High_yield_account__c,Money_Market_Accounts__c, Mortgage_Loans__c from Value_Alignment__c where  Value_Name__c in : listAccountPlan];
        
        listNextBestProduct = [select Id, Name, Proposed_Date_of_Offer__c, Status__c from Next_Best_Product__c where 
                              Account_Name__c =: id];
        data1 = '';
        data2 = '';
        data3 = '';
        data4 = '';
        data5 = '';
        data6 = '';
        annualR= 0;
        CompanyGrowthIndicator  ='';
        AccountgrowthIndicator ='';
        
        
        // Adding company name to list 
        for(Value_Alignment__c  value : listValueAlignment ) {
            if(value.name!=null) {
                companyNameList.add(value.name);    
            }
        }
        if(account.AnnualRevenue !=null) {
            annualR= (account.AnnualRevenue)/1000000;
        }
        if(account.Company_Growth_Indicator__c !=null) {    
            CompanyGrowthIndicator  = account.Company_Growth_Indicator__c;
        }
        if(account.Account_growth_Indicator__c !=null) {    
            AccountgrowthIndicator = account.Account_growth_Indicator__c;
        }    
        
        
        if(listValueAlignment.size() > 0){
            data1 = listValueAlignment[0].Treasury__c + ',' + listValueAlignment[0].Price__c + ',' + listValueAlignment[0].Structure__c + ',' + listValueAlignment[0].Corp_Finance_M_A__c + ',' + listValueAlignment[0].Global_Markets_FX_IRD__c;
            data3 = listValueAlignment[0].Mortgage_Loans__c + ',' + listValueAlignment[0].Money_Market_Accounts__c + ',' + listValueAlignment[0].Business_Loans__c + ',' + listValueAlignment[0].High_yield_account__c + ',' + listValueAlignment[0].Business_Checking_Savings__c;
            companyName = listValueAlignment[0].name;
            if(listValueAlignment.size() > 1)
            {
                data2 = listValueAlignment[1].Treasury__c + ',' + listValueAlignment[1].Price__c + ',' + listValueAlignment[1].Structure__c + ',' + listValueAlignment[1].Corp_Finance_M_A__c + ',' + listValueAlignment[1].Global_Markets_FX_IRD__c;
                data4 = listValueAlignment[1].Mortgage_Loans__c + ',' + listValueAlignment[1].Money_Market_Accounts__c + ',' + listValueAlignment[1].Business_Loans__c + ',' + listValueAlignment[1].High_yield_account__c + ',' + listValueAlignment[1].Business_Checking_Savings__c;
                competitorName1 = listValueAlignment[1].name;
            }
        }
        
if(listValueAlignment.size() > 2)
            {
                data5 = listValueAlignment[2].Treasury__c + ',' + listValueAlignment[2].Price__c + ',' + listValueAlignment[2].Structure__c + ',' + listValueAlignment[2].Corp_Finance_M_A__c + ',' + listValueAlignment[2].Global_Markets_FX_IRD__c;
                data6 = listValueAlignment[2].Mortgage_Loans__c + ',' + listValueAlignment[2].Money_Market_Accounts__c + ',' + listValueAlignment[2].Business_Loans__c + ',' + listValueAlignment[2].High_yield_account__c + ',' + listValueAlignment[2].Business_Checking_Savings__c;
                competitorName2 = listValueAlignment[2].name;
            }        
        
        
        listActionPlan = [select  Id, Responsible_Team_Member__c, Timing__c from Action_Plan__c where  Account_Plan_NameX__c in : listAccountPlan];
        
        listAccountTeamMember = [select Id, TeamMemberRole, User.Name, User.Username,User.Email, User.SmallPhotoUrl from AccountTeamMember where AccountId =: id];
        
        listDeposit = [select Id, Name, X12_month_Balance__c, Current_Balance__c, Deposit_Type__c, Interest_Rate__c,
                      Revenue__c,Product_Name__c, Duration__c  from Deposit__c where Account_Name__c =: id];
        
        List<Obligation__c> listObligation = [select Id, Name, Availability__c, Credit_Limit__c, Maturity_date__c, Obligation_ID__c,
                                              Loan_Balance__c,Derivative_Balance__c,FX_Balance__c,Card_Balance__c,Card_Due_Date__c,
                                              Loan_Fee__c,Derivative_Fee__c,FX_Fee__c,
                      Origination_Balance__c,Product_Type__c,Product_Name__c,Loan_Availbility__c from Obligation__c where Account__c =: id];
        
        listDerivative = new List<Obligation__c>();
        listFX = new List<Obligation__c>();
        listCreditCard = new List<Obligation__c>();
        listLoan = new List<Obligation__c>();
        
        for(Obligation__c obligation : listObligation){
            if(obligation.Product_Type__c == 'Derivative'){
                listDerivative.add(obligation);
            }
            else if(obligation.Product_Type__c == 'Letter of Credit' || obligation.Product_Type__c == 'Term Loan' || obligation.Product_Type__c == 'Commercial Loan' || obligation.Product_Type__c == 'Loan'){
                listLoan.add(obligation);
            }
            else if(obligation.Product_Type__c == 'FX'){
                listFX.add(obligation);
            }
            else if(obligation.Product_Type__c == 'Credit Card'){
                listCreditCard.add(obligation);
            }
        }
        Set<Id> setNotes = new Set<Id>();
        
        for(Event event : listMeeting){
            setNotes.add(event.Id);
        }
        
        listCallNotes = [select Id, Name, Action_Items__c, Comments__c, Summary_of_Competitor__c, Summary_of_Opportunity__c, CreatedDate from
                        Call_Notes__c where Activity_Id__c in : setNotes];
        
        committmentAmount = 0;
        averageOutStanding = 0;
        annualRevenue = 0;
        allInDrawnSpread = 0;
        roec = 0;
        rorc = 0;
        
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
        
        for(OpportunityWrapper ow : listOpportunity){
            if(ow.Opp.StageName == 'Closed Won')
                averageOutStanding += ow.Opp.Amount__c; 
            if(ow.Opp.StageName != 'Closed Won' && ow.Opp.StageName != 'Closed Lost')
                annualRevenue +=ow.Opp.Amount__c; 
        }
    }
    
    
    public void showCallNoteModal()
    {
        callNote = new Call_Notes__c();
        callNote.Activity_Id__c = parentMeetingId;
        //Datetime dt = Datetime.parse(meetingDateTime);
        //callNote.meeting_Date__c = Date.valueOf(dt);
        //callNote.Meeting_Time__c = 
     }
    public void createCallNote()
    {
        try{
            insert callNote;
            Call_Notes__c[] tempNOtes = [select Id, Name, Action_Items__c, Comments__c, Summary_of_Competitor__c, Summary_of_Opportunity__c, CreatedDate from
                                         Call_Notes__c where Activity_Id__c =:parentMeetingId ORDER BY CreatedDate DESC LIMIT 1];
            if(tempNOtes.size()>0)
                listCallNotes.add(tempNOtes[0]);
        }catch(Exception e){
            
        }
    }
    
    public void refreshCheckList(){
        oppty = new Opportunity();
        oppty = [select id, Insurance_Certificate__c,
Property_Reports__c, Tax_Assessment__c, Capital_Allocation_and_Approvals__c, Business_Tax_Returns__c from Opportunity where id = :selectedOpp];
        system.debug('=================refresh');
        showChecklist = true;
    }
    
    public void updateOppty(){
        system.debug('update========');
    update oppty;
    }
    
    /* public void createAnalysis(){
        Map<String,String> prodNames = new Map<String,String>();
        prodNames.put('Forward transactions', 'Bank Cash Back Plus World Mastercard');
        prodNames.put('Spot transactions', 'Freddie Mac Loans');
        prodNames.put('Business term loans','Commercial Term Loans');
        prodNames.put('Line of credit', 'Commercial Lines of Credit');
        Map<String,String> serviceprovider = new Map<String,String>();
        serviceprovider.put('Forward transactions', 'Citigroup');
        serviceprovider.put('Spot transactions', 'Capital One FC');
        serviceprovider.put('Business term loans','Goldman Sachs');
        serviceprovider.put('Line of credit', 'Wells Fargo');
        Map<String,Integer> opptyRevenue = new Map<String,Integer>();
        opptyRevenue.put('Forward transactions', 1600000);
        opptyRevenue.put('Spot transactions', 2100000);
        opptyRevenue.put('Business term loans',3400000);
        opptyRevenue.put('Line of credit', 1900000);
        
        
        for(RecommendedPlans rp : rpList){
            System.debug(rp.recommendedPlanID+'='+selectedProdId);
            if(rp.recommendedPlanID == selectedProdId){
                Recommended_Plan_Details__c rpd = [select id, Discussed_With_Client__c, Opportunity_Exits__c from Recommended_Plan_Details__c where Name = :selectedProdId LIMIT 1];
                rpd.Discussed_With_Client__c = rp.discussedWithClient;
                rpd.Opportunity_Exits__c = rp.opportunityExits;
                //update rpd;
                
                if(rp.opportunityExits == true && rp.discussedWithClient == true){
                    Customer_Need_Analysis__c cna = new Customer_Need_Analysis__c();
                    cna.Name = prodNames.get(rp.planName);
                    cna.Service_Provider__c = serviceprovider.get(rp.planName);
                    cna.Actual_Revenue__c = opptyRevenue.get(rp.planName);
                    cna.Product_Name_X__c = accPlanId1;
                    insert cna;
                   // Account360Controller ac = new Account360Controller();
                   // ac.getlistNeedAnalysis().add(cna);
                }
            }
            
        }
    }  */
   
        
    @AuraEnabled
    public static Account getAccountDetails(Id accountId){
        System.debug('AccountId================='+accountId);
        Account acc = [select Name from Account where id = :accountId];
        return acc;
    }
    
}