public class AccountController {
    
    @auraEnabled
    public static String getProfileName(){
        return [select Profile.Name from User where id = :UserInfo.getUserId()].Profile.Name;
    }
    @auraEnabled
    public static String getAccountName(Id accountId){
        return [select Name from Account where Id = :accountId].Name;
    }
    //get account details for header
    @auraEnabled
    public static AccountWrapper getAccountDetails(Id accountId){
        System.debug('accountId123=============='+accountId);
        if(accountId != null && accountId.getSObjectType().getDescribe().getName() != 'Account'){
            accountId = AccountController.getAccountId(accountId);
        }
        Decimal commitmentAmount = 0;
        Decimal aum = 0;
        Decimal outstandingOppty = 0;
        Decimal roec = 0;
        String address;
        Decimal annualRevenue = 0;
        Account account = [SELECT Id, Name, Region__c, Industry, Tenure__c, AnnualRevenue, Parent.Name, CreatedDate, Retention_Risk__c,
                           Risk_Factor__c, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry,Website,
                           Account.Owner.FirstName, Company_Growth_Indicator__c, Account_growth_Indicator__c
                           from Account where Id =: accountId]; 
        address = ' ' + account.BillingStreet + ', ' + 
            account.BillingCity+', ' + account.BillingState + ' ' +account.BillingPostalCode;
        if(account.AnnualRevenue !=null) {
            annualRevenue= (account.AnnualRevenue)/1000000;
        }
        List<Account_Plan__c> listAccountPlan = AccountController.getAccountPlanList(accountId);
        for(Account_Plan__c accountPlan : listAccountPlan){
            if(accountPlan.Commitment_Amount__c > 0)
                commitmentAmount += accountPlan.Commitment_Amount__c;
            if(accountPlan.ROEC_Return_on_Economic_Capital__c > 0)
                roec += accountPlan.ROEC_Return_on_Economic_Capital__c;
        }
        List<Opportunity> opportunityList = AccountController.getOpportunityList(accountId);
        for(Opportunity opp : opportunityList){
            if(opp.StageName == 'Closed Won')
                aum += opp.Amount__c; 
            if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost')
                outstandingOppty += opp.Amount__c; 
        }
        AccountWrapper aw = new AccountWrapper(account, commitmentAmount, aum, outstandingOppty, roec, address, annualRevenue);
        return aw;
    }
    
    @auraEnabled
    public static List<Account_Plan__c> getAccountPlanList(Id accountId){
        List<Account_Plan__c> accountPlanList = [select Id, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                                                 RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                                                 Commitment_Amount__c from Account_Plan__c where Account__c =: accountId and Status__c = 'Active'];
        return accountPlanList;
    }
    
    //get all related cotacts
    @auraEnabled
    public static List<Contact> getContactList(Id accountId){
        List<Contact> contactList = [select Id,Name, Salutation, FirstName, LastName, Phone, Email, Title FROM contact where AccountId =: accountId
                                     order by LastName asc];
        return contactlist;
    }
    
    //get all opportunities
    @auraEnabled
    public static List<Opportunity> getOpportunityList(Id accountId){
        List<Opportunity> opptyList = [select Id, Name, Amount,Amount__c, StageName, ExpectedRevenue, End_date__c, CloseDate, CreatedDate,
                                       LastModifiedDate, Age__c, Overall_Age__c, Opportunity_Age__c from Opportunity where AccountId =: accountId
                                       order by CloseDate desc];
        
        return opptyList;
    }
    
    //get all Cases
    @auraEnabled
    public static List<Case> getCasesList(Id accountId){
        List<Case> caseList = [select Id, Subject, Priority, CaseNumber, Status, Type from Case where AccountId =: accountId order by createddate desc];
        return caseList;
    }
    
    //get all meeting details
    @auraEnabled
    public static List<Event> getEventList(Id accountId){
        List<Event> meetingList = [select Id, Subject, StartDateTime, ActivityDateTime, Description, DurationInMinutes, Call_Notes__c from Event
                                   where WhatId =: accountId and StartDateTime = Today order by StartDateTime ASC];
        return meetingList;
    }
    
    //get all task details
    @auraEnabled
    public static List<Task> getTaskList(Id accountId){
        List<Task> taskList = [select Id, Subject, Status,ActivityDate from Task where WhatId =: accountId and ActivityDate = TODAY
                               order by ActivityDate asc];
        return taskList;
    }
    
    @auraEnabled
    public Static List<Obligation__c> getLoanList(Id accountId){
        List<Obligation__c> loanList = [select Id, Name, Availability__c, Credit_Limit__c, Maturity_date__c, Obligation_ID__c,
                                        Loan_Balance__c,Derivative_Balance__c,FX_Balance__c,Card_Balance__c,Card_Due_Date__c,
                                        Loan_Fee__c,Derivative_Fee__c,FX_Fee__c,
                                        Origination_Balance__c,Product_Type__c,Product_Name__c,Loan_Availbility__c from Obligation__c where Account__c =: accountId AND
                                        (Product_Type__c = 'Letter of Credit' OR Product_Type__c = 'Term Loan' OR
                                         Product_Type__c = 'Commercial Loan' OR Product_Type__c = 'Loan')];
        return loanList;
    }
    @auraEnabled
    public Static List<Deposit__c> getDepositList(Id accountId){
        List<Deposit__c> depositList = [select Id, Name, X12_month_Balance__c, Current_Balance__c, Deposit_Type__c, Interest_Rate__c,
                                        Revenue__c,Product_Name__c, Duration__c  from Deposit__c where Account_Name__c =: accountId];
        return depositList;
    }
    
    @auraEnabled
    public Static List<Obligation__c> getDerivativeList(Id accountId){
        List<Obligation__c> derivativeList = [select Id, Name, Availability__c, Credit_Limit__c, Maturity_date__c, Obligation_ID__c,
                                              Loan_Balance__c,Derivative_Balance__c,FX_Balance__c,Card_Balance__c,Card_Due_Date__c,
                                              Loan_Fee__c,Derivative_Fee__c,FX_Fee__c,
                                              Origination_Balance__c,Product_Type__c,Product_Name__c,Loan_Availbility__c from Obligation__c where Account__c =: accountId AND
                                              Product_Type__c = 'Derivative'];
        return derivativeList;
    }
    @auraEnabled
    public Static List<Obligation__c> getFXList(Id accountId){
        List<Obligation__c> fxList = [select Id, Name, Availability__c, Credit_Limit__c, Maturity_date__c, Obligation_ID__c,
                                      Loan_Balance__c,Derivative_Balance__c,FX_Balance__c,Card_Balance__c,Card_Due_Date__c,
                                      Loan_Fee__c,Derivative_Fee__c,FX_Fee__c,
                                      Origination_Balance__c,Product_Type__c,Product_Name__c,Loan_Availbility__c from Obligation__c where Account__c =: accountId AND
                                      Product_Type__c = 'FX'];
        return fxList;
    }
    @auraEnabled
    public Static List<Obligation__c> getCardList(Id accountId){
        List<Obligation__c> cardList = [select Id, Name, Availability__c, Credit_Limit__c, Maturity_date__c, Obligation_ID__c,
                                        Loan_Balance__c,Derivative_Balance__c,FX_Balance__c,Card_Balance__c,Card_Due_Date__c,
                                        Loan_Fee__c,Derivative_Fee__c,FX_Fee__c,
                                        Origination_Balance__c,Product_Type__c,Product_Name__c,Loan_Availbility__c from Obligation__c where Account__c =: accountId AND
                                        Product_Type__c = 'Credit Card'];
        return cardList;
    }
    
    @auraEnabled
    public Static List<RecentActivity> getRecentActivityList(Id accountId){
        List<RecentActivity> recentActivityList = new List<RecentActivity>();
        List<Contact> contactCreatedList =[SELECT id,name,CreatedDate,LastModifiedDate,accountid FROM contact WHERE accountid =: accountId and CreatedDate=TODAY LIMIT 3 ]  ;
        List<Opportunity> opportunityList =[SELECT id,name,CreatedDate,LastModifieddate,accountid FROM Opportunity WHERE accountid =: accountId and CreatedDate=TODAY LIMIT 3 ]  ;
        List<Account_Plan__c> accountPlanCreatedList = [SELECT id,name,CreatedDate,LastModifieddate,Account__c FROM Account_Plan__c WHERE Account__c =: accountId and CreatedDate=TODAY LIMIT 3] ;
        //cnaCreatedList = [select id, name, createddate from Customer_Need_Analysis__c where ]
        for(Account_Plan__c  accplan : accountPlanCreatedList  ) {
            recentActivityList.add(new RecentActivity('Account Plan -' + accplan.name + ' was created' ,accplan.createdDate , accplan.id));
        }
        
        for(opportunity opp : opportunityList ) {
            recentActivityList.add(new RecentActivity('Opportunity - ' + opp.name +  ' was created' ,opp.createdDate , opp.id));
        }
        for(contact con : contactCreatedList  ) {
            recentActivityList.add(new RecentActivity('Contact - '+ con.name + ' was created' ,con.createdDate , con.id));
        }
        return recentActivityList;
    }
    
    @auraEnabled
    public static Call_Notes__c createCallNote(Call_Notes__c callNote, Id parentMeetingId)
    {
        try{
            callNote.Activity_Id__c = parentMeetingId;
            insert callNote;
        }catch(Exception e){
            
        }
        return callNote;
    }
    @auraEnabled
    public static List<Customer_Need_Analysis__c> getNeedAnalysisList(Id accountId) {
        if(accountId != null && accountId.getSObjectType().getDescribe().getName() != 'Account'){
            accountId = AccountController.getAccountId(accountId);
        }
        List<Account_Plan__c> accountPlanList = [select Id, Annual_Revenue__c, Average_Outstanding__c, ROEC_Return_on_Economic_Capital__c,
                                                 RORC_Return_on_Regulatory_Capital__c,All_In_Drawn_Spread_LIBOR_Spread_Faci__c,
                                                 Commitment_Amount__c from Account_Plan__c where Account__c =: accountId and Status__c = 'Active'];
        List<Customer_Need_Analysis__c> needAnalysisList = [select Id, Name, Product_Name_X__r.Name, Service_Provider__c, Services_Used__c,
                                                            Actual_Revenue__c, Future_Opportunity__c, Share_of_Wallet_estimate__c, RM_Estimate__c,
                                                            Comments__c, Opportunity_Created__c from 
                                                            Customer_Need_Analysis__c where Product_Name_X__c in : accountPlanList];
        return needAnalysisList;
    }
    
    @auraEnabled
    public static List<Call_Notes__c> getCallNoteList(Id accountId) {
        Set<Id> callNoteIds = new Set<Id>();
        for(Event ev: AccountController.getEventList(accountId)){
            callNoteIds.add(ev.Id);
        }
        List<Call_Notes__c> listCallNotes = [select Id, Name, Action_Items__c, Comments__c, Summary_of_Competitor__c, Summary_of_Opportunity__c, CreatedDate from
                                             Call_Notes__c where Activity_Id__c in : callNoteIds];
        return listCallNotes;
    }
    
    @auraEnabled
    public static List<AccountTeamMember> getAccountTeamMembers(Id accountId){
        List<AccountTeamMember> accountTeamMemberList = [select Id, TeamMemberRole, User.Name, User.Username,User.Email, User.SmallPhotoUrl
                                                         from AccountTeamMember where AccountId =: accountId];
        return accountTeamMemberList;
    }
    @auraEnabled
    public static void createNeedAnalysis(Id accPlanId, String planName){
        Map<String,String> prodNames = new Map<String,String>();
        prodNames.put('Forward transactions', 'Bank Cash Back Plus World Mastercard');
        prodNames.put('Rate loans', 'Adjustable Rate Loans');
        prodNames.put('Term loans','Commercial Term Loans');
        prodNames.put('Line of credit', 'Commercial Lines of Credit');
        Map<String,String> serviceprovider = new Map<String,String>();
        serviceprovider.put('Forward transactions', 'Citigroup');
        serviceprovider.put('Rate loans', 'Capital One FC');
        serviceprovider.put('Term loans','Bank Of America');
        serviceprovider.put('Line of credit', 'Wells Fargo');
        Map<String,Integer> opptyRevenue = new Map<String,Integer>();
        opptyRevenue.put('Forward transactions', 1600000);
        opptyRevenue.put('Rate loans', 2100000);
        opptyRevenue.put('Term loans',3400000);
        opptyRevenue.put('Line of credit', 1900000);
        
        
        Customer_Need_Analysis__c cna = new Customer_Need_Analysis__c();
        cna.Name = prodNames.get(planName.trim());
        cna.Service_Provider__c = serviceprovider.get(planName.trim());
        cna.Actual_Revenue__c = opptyRevenue.get(planName.trim());
        cna.Product_Name_X__c = accPlanId;
        insert cna;
    }
    
    /***********************************************************
* ACCOUNT PLAN METHODS
* ********************************************************/
    @auraEnabled
    public static Id getAccPlanId(Id accountId){
        List<Account_Plan__c> accPlanList = [select Id from Account_Plan__c where Account__c = :accountId];
        if(accPlanList != null && accPlanList.size() > 0){
            System.debug('accPlanList[0].Id=====>'+accPlanList[0].Id);
            return accPlanList[0].Id;
        }
        return null;
    }
    @auraEnabled
    public static Id getAccountId(Id recordId){
        List<Account_Plan__c> accPlanList = [select id, Account__c from Account_Plan__c where id = :recordId];
        if(accPlanList != null && accPlanList.size() > 0){
            System.debug('accPlanList[0].Id=====>'+accPlanList[0].Account__c);
            return accPlanList[0].Account__c;
        }
        return null;
    }
    @auraEnabled
    public static List<Value_Alignment__c> getValueAlignmentList(Id accPlanId){
        List<Value_Alignment__c> valueAlignmentList = [select Id, Name , Corp_Finance_M_A__c, Global_Markets_FX_IRD__c, Price__c, Structure__c,Competitor__c,
                                                       Treasury__c, Value_Name__c from Value_Alignment__c where  Value_Name__c =: accPlanId];
        return valueAlignmentList;
    }
    
    @auraEnabled
    public static Account_Plan__c getAccountPlan(Id accPlanId){
        return [select Id, Results_What_we_know__c, Results_What_we_Need_to_Know__c, Obstacles_What_We_Know__c, Obstacles_What_we_Need_to_Know__c,
                Execution_What_we_Know__c, Execution_What_we_Need_to_Know__c from Account_Plan__c where Id = :accPlanId];
    }
    
    @auraEnabled
    public static void saveAccountPlan(Id accPlanId, Account_Plan__c accPlan){
        upsert accPlan;
    }
    @auraEnabled
    public static List<RecommendedPlans> getRPList(){
        return getProductRecommendation(95);
    }
    
    @auraEnabled
    public static Opportunity getOpportunityChecklist(Id opptyId){
        System.debug('opptyId=============='+opptyId);
        return [select id, Insurance_Certificate__c, Property_Reports__c, Tax_Assessment__c, Capital_Allocation_and_Approvals__c, 
               Business_Tax_Returns__c from Opportunity where id = :opptyId];
    }
    
    @auraEnabled
    public static void updateOpportunityCheckList(Opportunity oppty){
        update oppty;
    }
    
    @auraEnabled
    public static String getAccountPlanName(Id recordId){
        Account_Plan__c ap = [select Name from Account_Plan__c where id = :recordId];
        return ap.Name;
    }
    public static List<RecommendedPlans> getProductRecommendation(Integer memberID) {
        RecommendedPlans rp;
        List<RecommendedPlans> recommendedPlansList = new List<RecommendedPlans>();
        Map<String, Recommended_Plan_Details__c> rpdMap = new Map<String, Recommended_Plan_Details__c>();
        HttpResponse resp = new HttpResponse();
        
        resp = productRecommendationHttpCallout(memberID);
        if(resp.getStatusCode()==200)
        {
            //fetch Plan details from Salesforce.
            List<Recommended_Plan_Details__c> rpdList = [SELECT Minimum_Policy_Cost__c,Name,Plan_Description__c,Plan_ID__c,Plan_Name__c,Image_URL__c,Discussed_with_client__c,Opportunity_Exits__c FROM Recommended_Plan_Details__c];
            for(Recommended_Plan_Details__c rpObj : rpdList)
            {
                rpdMap.put(rpObj.name, rpObj);
            }
            system.debug('rpdMap : '+rpdMap);
            //creating a JSON parser on the entire JSON response
            JSONParser parser = JSON.createParser(resp.getBody());
            
            While(parser.nextToken() != null)
            {
                system.debug('First While token' +parser.getCurrentToken());
                system.debug('First While value' +parser.getText());
                //Start at the array of Recommendedplans
                if(parser.getCurrentToken() == JSONToken.START_ARRAY)
                {
                    While(parser.nextToken() != null)
                    {    
                        //Advance to the start object marker to find the next RecommendedPlans object
                        if(parser.getCurrentToken() == JSONToken.START_OBJECT)
                        {
                            //Read entire recommendedplans object
                            system.debug('Second While token' +parser.getCurrentToken());
                            system.debug('Second While value' +parser.getText()); 
                            rp = (RecommendedPlans)parser.readValueAs(RecommendedPlans.class);
                            if(rpdMap.get(rp.recommendedPlanID) != null) {
                                rp.planName = rpdMap.get(rp.recommendedPlanID).Plan_Name__c;
                                rp.planDescription = rpdMap.get(rp.recommendedPlanID).Plan_Description__c;
                                rp.minimumPolicyCost = rpdMap.get(rp.recommendedPlanID).Minimum_Policy_Cost__c;
                                rp.planImageURL = rpdMap.get(rp.recommendedPlanID).Image_URL__c;
                                rp.sourcePlanName = rpdMap.get(rp.sourcePlanID).Plan_Name__c;
                                rp.discussedWithClient = rpdMap.get(rp.recommendedPlanID).Discussed_with_client__c;
                                rp.opportunityExits = rpdMap.get(rp.recommendedPlanID).Opportunity_Exits__c ;
                            }
                            else{
                                system.debug('No Plans available in salesforce!!');
                                rp.planName = 'Plan Name' ;
                                rp.planDescription = 'No data exist in Salesforce for this plan '+rp.recommendedPlanID;
                                rp.minimumPolicyCost = 'Minimum Policy Cost';
                                rp.planImageURL = '/resource/productrec/house.png';
                                rp.sourcePlanName = 'Source plan name';
                                rp.discussedWithClient = false;
                                rp.opportunityExits = false;
                            }
                            if(rp.matchPercentage != '' && rp.matchPercentage != null)
                            {
                                rp.matchPercentage = String.valueOf(Math.round(Decimal.valueOf(rp.matchPercentage)*100));
                            }    
                            
                            if(Integer.valueOf(rp.matchPercentage) != 0)
                            {    
                                recommendedPlansList.add(rp);
                            }
                        }
                    }
                }
                
            }
        }
        //system.debug('recommendedPlansList before Sorting : ' +recommendedPlansList);
        recommendedPlansList.sort();
        //system.debug('recommendedPlansList after Sorting : ' +recommendedPlansList);
        return recommendedPlansList;
    }
    
    public static HTTPResponse productRecommendationHttpCallout(Integer memberID) {
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HTTPResponse res = new HTTPResponse();
        String endPoint = 'http://104.196.216.101:8080/cb/services/member/'+memberID+'/recommendations';
        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setHeader('apiKey', 'Q29uc3VtZXJAVWhHX1NGOTY=');
        
        try{
            res = http.send(req);
        }
        catch(Exception e){
            system.debug(e);
        }
        return res;
    }
    
    @auraEnabled
    public static String getUserRole(Id accountId){
        String userRole = 'All';
        Map<String,String> userRoleAndProductMap = new Map<String,String>();
        userRoleAndProductMap.put('Product Manager - Commercial Real Estate','Loan');
        userRoleAndProductMap.put('Product Manager - Money Market Investment','Deposit');
        userRoleAndProductMap.put('Product Manager - Commercial Lines of Credit','Loan');
        userRoleAndProductMap.put('Product Manager - Commercial Term Loans','Loan');
        List<AccountTeamMember> atmList = [select UserId, TeamMemberRole from AccountTeammember where accountid = :accountId AND UserId = :UserInfo.getUserId() LIMIT 1];
        if(atmList.size() > 0 && userRoleAndProductMap.containsKey(atmList[0].TeamMemberRole)){
            userRole = userRoleAndProductMap.get(atmList[0].TeamMemberRole);
        }
        system.debug('userRole==='+userRole);
        return userRole;
    }
    @auraEnabled
    public Static String[] getReportData(Id accPlanId){
        String data1 = '';
        String data2 = '';
        String data3 = '';
        String data4 = '';
        String data5 = '';
        String data6 = '';
        string companyName = '';
        string competitorName1 = '';
        string competitorName2 = '';
        List<Value_Alignment__c> valueAlignmentList = [select  Id,Name,Corp_Finance_M_A__c, Global_Markets_FX_IRD__c, Price__c, Structure__c,Competitor__c,
                                                       Treasury__c, Value_Name__c, Business_Checking_Savings__c,Business_Loans__c,High_yield_account__c,
                                                       Money_Market_Accounts__c, Mortgage_Loans__c from Value_Alignment__c where  Value_Name__c = :accPlanId];
        
        if(valueAlignmentList.size() > 0){
            data1 = valueAlignmentList[0].Treasury__c + ',' + valueAlignmentList[0].Price__c + ',' + valueAlignmentList[0].Structure__c + ',' + valueAlignmentList[0].Corp_Finance_M_A__c + ',' + valueAlignmentList[0].Global_Markets_FX_IRD__c;
            data3 = valueAlignmentList[0].Mortgage_Loans__c + ',' + valueAlignmentList[0].Money_Market_Accounts__c + ',' + valueAlignmentList[0].Business_Loans__c + ',' + valueAlignmentList[0].High_yield_account__c + ',' + valueAlignmentList[0].Business_Checking_Savings__c;
            companyName = valueAlignmentList[0].name;
            if(valueAlignmentList.size() > 1)
            {
                data2 = valueAlignmentList[1].Treasury__c + ',' + valueAlignmentList[1].Price__c + ',' + valueAlignmentList[1].Structure__c + ',' + valueAlignmentList[1].Corp_Finance_M_A__c + ',' + valueAlignmentList[1].Global_Markets_FX_IRD__c;
                data4 = valueAlignmentList[1].Mortgage_Loans__c + ',' + valueAlignmentList[1].Money_Market_Accounts__c + ',' + valueAlignmentList[1].Business_Loans__c + ',' + valueAlignmentList[1].High_yield_account__c + ',' + valueAlignmentList[1].Business_Checking_Savings__c;
                competitorName1 = valueAlignmentList[1].name;
            }
        }
        
        if(valueAlignmentList.size() > 2){
            data5 = valueAlignmentList[2].Treasury__c + ',' + valueAlignmentList[2].Price__c + ',' + valueAlignmentList[2].Structure__c + ',' + valueAlignmentList[2].Corp_Finance_M_A__c + ',' + valueAlignmentList[2].Global_Markets_FX_IRD__c;
            data6 = valueAlignmentList[2].Mortgage_Loans__c + ',' + valueAlignmentList[2].Money_Market_Accounts__c + ',' + valueAlignmentList[2].Business_Loans__c + ',' + valueAlignmentList[2].High_yield_account__c + ',' + valueAlignmentList[2].Business_Checking_Savings__c;
            competitorName2 = valueAlignmentList[2].name;
        }
        String [] arrayOfData = new List<String>(); 
        arrayOfData.add(data1);
        arrayOfData.add(data2);
        arrayOfData.add(data3);
        arrayOfData.add(data4);
        arrayOfData.add(data5);
        arrayOfData.add(data6);
        arrayOfData.add(companyName);
        arrayOfData.add(competitorName1);
        arrayOfData.add(competitorName2);
        System.debug(arrayOfData);
        //JSON.serialize(arrayOfData);
        return arrayOfData;
        
    }
    
    //Inner class used for Serialization by readValueas() method.
    public class RecommendedPlans implements comparable {
        @auraEnabled public String description;
        @auraEnabled public String recommendedPlanID;
        @auraEnabled public String imageUrl;
        @auraEnabled public String sourcePlanID;
        @auraEnabled public String matchPercentage;
        @auraEnabled public String planDescription;
        @auraEnabled public String planName;
        @auraEnabled public String minimumPolicyCost;
        @auraEnabled public String planImageURL;
        @auraEnabled public String sourcePlanName;
        @auraEnabled public boolean discussedWithClient;
        @auraEnabled public boolean opportunityExits;
        
        //Constructor
        public RecommendedPlans(String des, String recommendedPlanID, String imgUrl, String spID,String matchPercent, String planDesc, String planName, String minPolCost, String planImgURL, String srcPlnName,boolean discwithclient,boolean oppexits )
        {
            description = des;
            recommendedPlanID = recommendedPlanID;
            imageUrl = imgUrl;
            sourcePlanID = spID;
            matchPercentage = matchPercent;
            planDescription = planDesc;
            planName = planName;
            minimumPolicyCost = minPolCost;
            planImageURL = planImgURL;
            sourcePlanName = srcPlnName;
            discussedWithClient = discwithclient;
            opportunityExits = oppexits ;
        }
        
        // Implement the compareTo() method for sorting it in Descending order.
        public Integer compareTo(Object compareObj)
        {
            RecommendedPlans rpCmp = (RecommendedPlans)compareObj;
            if(Integer.valueOf(matchPercentage) == Integer.valueOf(rpCmp.matchPercentage))return 0;
            if(Integer.valueOf(matchPercentage) > Integer.valueOf(rpCmp.matchPercentage))return -1;
            return 1;
        }
    }
    public class AccountWrapper{
        @AuraEnabled public Account acc;
        @AuraEnabled public Decimal commitmentAmount;
        @AuraEnabled public Decimal aum;
        @AuraEnabled public Decimal outstandingOppty;
        @AuraEnabled public Decimal roec;
        @auraEnabled public String address;
        @AuraEnabled public Decimal annualRevenue;
        
        public AccountWrapper(Account acc, Decimal commitmentAmount, Decimal aum, Decimal outstandingOppty, Decimal roec, String address, Decimal annualRevenue){
            this.acc = acc;
            this.commitmentAmount = commitmentAmount;
            this.aum = aum;
            this.outstandingOppty = outstandingOppty;
            this.roec = roec;
            this.address = address;
            this.annualRevenue = annualRevenue;
        }
    }
    public class RecentActivity {
        @AuraEnabled public string activityName;
        @AuraEnabled public datetime createdTime;
        @AuraEnabled public id recordId;
        public RecentActivity (string activityName, datetime createdTime, id recordId){ 
            this.activityName = activityName ;
            this.createdTime = createdTime ;
            this.recordId    = recordId   ;
        }
    }
}