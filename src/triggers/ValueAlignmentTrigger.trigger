trigger ValueAlignmentTrigger on Value_Alignment__c (after insert) {
    
    List<Value_Conversion__c> valConvList = new List<Value_Conversion__c>();
    Value_Conversion__c valConv;
    if(trigger.isInsert){
        if(trigger.isAfter){            
            for(Value_Alignment__c value : trigger.new){
                Value_Conversion__c valConv1 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Business_Checking_Savings__c!=null?value.Business_Checking_Savings__c:'0' ),                        
                                                Service__c='Business Checking & Savings');
                valConvList.add(valConv1);
                Value_Conversion__c valConv2 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Business_Loans__c!=null?value.Business_Loans__c:'0' ),                        
                                                Service__c='Business Loans');
                valConvList.add(valConv2);
                Value_Conversion__c valConv3 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Corp_Finance_M_A__c!=null?value.Corp_Finance_M_A__c:'0' ),                        
                                                Service__c='Corp Finance/M&A');
                valConvList.add(valConv3);
                Value_Conversion__c valConv4 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Global_Markets_FX_IRD__c!=null?value.Global_Markets_FX_IRD__c:'0' ),                        
                                                Service__c='Global Markets/FX/IRD');
                valConvList.add(valConv4);
                Value_Conversion__c valConv5 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.High_yield_account__c!=null?value.High_yield_account__c:'0' ),                        
                                                Service__c='High yield account');
                valConvList.add(valConv5);
                Value_Conversion__c valConv6 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Money_Market_Accounts__c!=null?value.Money_Market_Accounts__c:'0' ),                        
                                                Service__c='Money Market Accounts');
                valConvList.add(valConv6);
                Value_Conversion__c valConv7 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Mortgage_Loans__c!=null?value.Mortgage_Loans__c:'0' ),                        
                                                Service__c='Mortgage Loans');
                valConvList.add(valConv7);
                Value_Conversion__c valConv8 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Price__c!=null?value.Price__c:'0' ),                        
                                                Service__c='Price');
                valConvList.add(valConv8);
                Value_Conversion__c valConv9 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Structure__c!=null?value.Structure__c:'0' ),                        
                                                Service__c='Structure');
                valConvList.add(valConv9);
                Value_Conversion__c valConv10 =  new Value_Conversion__c(Account__c=value.Account_Name__c, 
                                                Bank__c=value.Name, Plan_Name__c=value.Account_Plan_Name__c, 
                                                Rating__c=Decimal.valueOf(value.Treasury__c!=null?value.Treasury__c:'0' ),                        
                                                Service__c='Treasury');
                valConvList.add(valConv10);
            }
            if(valConvList.size() > 0){
                insert valConvList; 
            }
            
        }
        
    }

}