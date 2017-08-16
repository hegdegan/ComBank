public class Opportunity_Helper {


    public static Map<Id,List<OpportunityLineItem>> opportunityLineItemMap = new Map<Id,List<OpportunityLineItem>>();
    public static Map<Id,List<Opportunity>> accountOpportunityMap = new Map<Id,List<Opportunity>> ();
    public static List<OpportunityLineItem> opplineList = new List<OpportunityLineItem>();
    public static List<Obligation__c> obligationList = new List<Obligation__c>();
    public static List<Deposit__c> depositList = new List<Deposit__c>();
    public static Set<Id> opportunityIdSet = new Set<Id>();
    public static Set<Id> accountIds = new Set<Id>();
    public static List<AccountTeamMember> members = new list<AccountTeamMember>();
    public static Map<Id,List<AccountTeamMember>> accountteammemberMap = new Map<Id,List<AccountTeamMember>>();
    public static Set<String> teamRole = new Set<string> {'Product Manager - Commercial Real Estate','Product Manager - Money Market Investment','Product Manager - Commercial Term Loans','Product Manager - Commercial Lines of Credit'};
    public static Map<Id,Id> userIdmap = new Map<Id,Id>();
    public static id userid;
    Public static List<Task> taksList = new List<Task>();
    Public static map<String ,id> roleMap = new Map<string,id>();
    public static Map<Id,string> teamRoleMap = new Map<Id,string>();
    public static List<ProductManagerMapping__c> customSetting = ProductManagerMapping__c.getall().values();
    Public static Map<string,string> custsettingmap = new Map<string,string>();
    public static string emailUserid;
    
    private static boolean run = true;
    public static boolean runOnce(){
    if(run){
     run=false;
     return true;
    }else{
        return run;
    }
    }
    
    
    public static void opportunityStageWoncheck(Map<Id,opportunity> newMap,Map<Id,opportunity> oldMap) {
        for(opportunity opp :newMap.values()) {
            if((oldMap.get(opp.id).stageName != newMap.get(opp.id).stageName) && newMap.get(opp.id).stagename == 'Closed Won') {
                  insertDepositeObligations(newMap.values());  
            }
        }
    }


    public static void taskcreattionchech(Map<Id,opportunity> newMap,Map<Id,opportunity> oldMap) {
         for(opportunity opp :newMap.values()) {
            if((oldMap.get(opp.id).stageName != newMap.get(opp.id).stageName) && newMap.get(opp.id).stagename == 'Proposal/Price Quote') {
                  createTaskforProductManager(newMap.values());  
            }
        }
    }
    
    public static void insertDepositeObligations(List<Opportunity> oppList) {
   
    
            for(Opportunity opp : oppList) {
                if(opp.id!=null) {
                    opportunityIdSet.add(opp.id);
                }
            }
          
            opplineList = [SELECT id,OpportunityId,name,Product2.name,Type__c,Fee__c FROM OpportunityLineItem WHERE OpportunityId IN:opportunityIdSet ];
            
            if(opplineList.size()>0) { 
            
            for(Opportunity opp : oppList) {
                for(OpportunityLineItem oppLineItem :opplineList ) {
                    if(oppLineItem.Type__c == 'Loan') {
                        Obligation__c oblig = new Obligation__c();
                        oblig.Account__c = opp.AccountId;
                        oblig.Product_Name__c = oppLineItem.Product2.name;  
                        Integer len = 8;
                        String str = string.valueof(Math.abs(Crypto.getRandomLong()));
                        String randomNumber = str.substring(0, len);
                        oblig.Obligation_ID__c = randomNumber;
                        oblig.Opportunity__c = opp.id;
                        oblig.Start_Date__c = opp.Start_Date__c;
                        oblig.End_Date__c = opp.End_date__c;
                        oblig.Loan_Fee__c = oppLineItem .Fee__c;
                        oblig.Loan_Balance__c = opp.Amount__c;
                        oblig.Product_Type__c = 'Term Loan';
                        obligationList.add(oblig); 
                    }
                    
                    if(oppLineItem.Type__c == 'Deposit') {
                        Deposit__c dep = new Deposit__c();
                        dep.Product_Name__c = oppLineItem.Product2.name ;
                        dep.Account_Name__c = opp.AccountId;
                        dep.Current_Balance__c = opp.Amount__c;
                        dep.Revenue__c = (opp.Amount__c) * 0.01; 
                        dep.Interest_Rate__c = opp.Yield_Rate__c;
                        
                        if(opp.End_date__c != null && opp.Start_Date__c!=null) {
                            dep.Duration__c = opp.Start_Date__c.daysBetween(opp.End_date__c);
                        }
                        
                        if(opp.End_date__c== null || opp.Start_Date__c ==null ) {
                            opp.End_date__c = system.today()+200;
                            opp.Start_Date__c = system.today();
                            dep.Duration__c = opp.Start_Date__c.daysBetween(opp.End_date__c);
                        }
                        // dep.X12_month_Balance__c
                        depositList.add(dep);
                    }
                 }
               }   
            }   
            
            if(!obligationList.Isempty()) {
            try{
                insert obligationList;
               }catch(Exception e) {
                    System.debug('ERROR:' + e);
               } 
            }  
                
            if(!depositList.Isempty()) {
            try{
                insert depositList;
               }catch(Exception e) {
                    System.debug('ERROR:' + e);
               } 
            }
      }
    
    public static void createTaskforProductManager (List<Opportunity> oppList) {
    
            for(ProductManagerMapping__c cus:customSetting ) {
                custsettingmap.put(cus.name,cus.Role__c);
            }
    
            for(Opportunity opp : oppList) {
                if(opp.id!=null) {
                    opportunityIdSet.add(opp.id);
                }
                
                if(opp.accountid!=null) {
                    accountIds.add(opp.accountid);
                }
            }
            
            List<OpportunityLineItem > oppLineItemList = [SELECT id,OpportunityId,name,Product2.name,Type__c FROM OpportunityLineItem WHERE OpportunityId IN:opportunityIdSet ]; 
            
           
            
            for(AccountTeamMember accmem : [SELECT id,AccountId,TeamMemberRole,UserId FROM AccountTeamMember WHERE AccountId IN:accountIds]) {
               roleMap.put(accmem.TeamMemberRole,accmem.UserId);
               teamRoleMap.put(accmem.UserId,accmem.TeamMemberRole);
               
            }
            
            if(oppLineItemList.size()>0) {
            
            for(OpportunityLineItem oppLine : oppLineItemList ) {
                if(custsettingmap.containsKey(oppLine.Product2.name)) {
                     userid = roleMap.get(custsettingmap.get(oppLine.Product2.name));
                 if(String.isEmpty(emailUserid )) {
                     emailUserid = userid;
                 } else {
                     emailUserid  += ','+userId;
                 }
                     task tsk = new Task();
                     tsk.Type = 'Email';
                     tsk.Team_Role__c = teamRoleMap.get(userid);
                     tsk.ActivityDate = system.Today();
                     tsk.Subject ='Opportunity product alert';
                     tsk.Description = 'Opportunity product alert'; //string
                     tsk.OwnerId = userid ; //user id
                     tsk.WhatId = oppLine.opportunityId; //record id
                     taksList.add(tsk);
              
               } 
            } 
         }  
           
           if(!taksList.isEmpty()) {
             try{ 
                    Database.insert(taksList,False);
                    sendEmail(emailUserid);  
               }catch(Exception e) {
                    System.debug('ERROR:' + e);
               }
           } 
        }
        
        
        public static void sendEmail(string emailId) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {
                emailId
            };
            mail.setToAddresses(toAddresses);
            mail.setSubject('Task creation alert');
            String body = 'Stage has been changed to Proposal/Price Quote';
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEMailMessage[] {
                mail
            });
        
        }
     }