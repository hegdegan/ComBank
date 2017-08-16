@isTest
Public class ValueAlignmentTriggerTest{
     static testMethod void testValueAlignment() {
         
        Account a = new Account(Name='TestAccount');
            a.Account_Title__c='Test';
            a.Batch_ID__c='Test';
            a.Same_Day_ACH__c='Opt In';
        insert a;
        
        Account_Plan__c ap= new Account_Plan__c();
            ap.Account__c=a.id;
            insert ap;
     
        Value_Alignment__c va= new Value_Alignment__c ();
            va.Value_Name__c=ap.id;
            va.Corp_Finance_M_A__c='1';
            va.Global_Markets_FX_IRD__c='1';
            va.Price__c='1';
            va.Structure__c='1';
            va.Treasury__c='1';
            va.Mortgage_Loans__c='1';
            va.Money_Market_Accounts__c='1';
            va.Business_Loans__c='1';
            va.High_yield_account__c='1';
            va.Business_Checking_Savings__c='1';
        Test.startTest();
            insert va;
        Test.stopTest();
    }

}