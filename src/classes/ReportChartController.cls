public class ReportChartController {
    
    
    @AuraEnabled
    public static string getClientByIndustry(){
        list<CustomReport_WrapClass> lst = new list<CustomReport_WrapClass>();
        AggregateResult[] groupedResults	= [SELECT Industry,COUNT(NAME) FROM Account where Industry!= '' and ownerId =: UserInfo.getUserId() GROUP BY Industry ];
        for (AggregateResult agr:groupedResults){
            lst.add(new CustomReport_WrapClass(string.valueOf(agr.get('Industry')),Decimal.valueOf(string.valueOf(agr.get('expr0')))));
        } 
        return JSON.serialize(lst) ;
    }
    
    @AuraEnabled
    public static string getAUMVal(){
        list<string> stringLst = new list<string>();
        list<decimal> valLst= new list<decimal>();
        list<CustomReport_WrapClass> lst = new list<CustomReport_WrapClass>();
        AggregateResult[] groupedResults	= [SELECT Industry,SUM(Assets_Under_Management__c) FROM Account where Industry!= '' and ownerId =: UserInfo.getUserId() GROUP BY Industry ];
        for (AggregateResult agr:groupedResults){
            lst.add(new CustomReport_WrapClass(string.valueOf(agr.get('Industry')),Decimal.valueOf(string.valueOf(agr.get('expr0')))));
        }
        return JSON.serialize(lst) ;
        
    }
    @AuraEnabled
    public static string getTotRevenue(){
        list<string> stringLst = new list<string>();
        list<decimal> valLst= new list<decimal>();
        List<Account>  groupedResults = [SELECT Name,Revenue_Generated__c FROM Account where Industry!= '' and ownerId =: UserInfo.getUserId()];
        for (Account acc:groupedResults){
            stringLst.add(acc.name);
            valLst.add(acc.Revenue_Generated__c);
        }
        barChart bChart = new barChart(stringLst,valLst);
        return JSON.serialize(bChart) ;
    }
    
    @AuraEnabled
    public static string getLoanVal(){
        list<string> stringLst = new list<string>();
        list<decimal> valLst= new list<decimal>();
        List<Account> groupedResults	= [SELECT Name,Loan_Amount__c FROM Account where Industry!= '' and ownerId =: UserInfo.getUserId() Order By Loan_Amount__c DESC Limit 15];
        for (Account acc :groupedResults){
            stringLst.add(acc.name);
            valLst.add(acc.Loan_Amount__c);
        }
        barChart bChart = new barChart(stringLst,valLst);
        return JSON.serialize(bChart) ;
    }
    
    public class barChart {
        @AuraEnabled
        public list<string> stringLst;
        @AuraEnabled
        public list<decimal> valLst;
        public barChart(list<string> sVal,list<decimal> iVal){
            stringLst = sVal;
            valLst = iVal;
        }  
    }
    public class barChart1 {
        @AuraEnabled
        public list<string> stringLst;
        @AuraEnabled
        public list<decimal> valLst;
        
        public barChart1(list<decimal> iVal,list<string> sVal){
            stringLst = sVal;
            valLst = iVal;
        }
    }
}