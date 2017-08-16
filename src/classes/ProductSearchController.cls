public with sharing class ProductSearchController {    
    public String searchName{get;set;}
    public String searchCode {get;set;}
    public String searchType {get; set;}
    public Opportunity theOpp {get;set;}
    public opportunityLineItem[] oppLineItems {get;set;} 
    public List<wrapper> wraplist{get;set;}    
    public String toSelect {
        get{return toSelect;}
        set{toSelect=value;}
    }
    public String toUnselect {
        get{return toUnselect;}
        set{toUnselect=value;}
    }
    
    private Boolean isCustomFeeType=false;
    private Set<id> existingProdId;
    private static String defaultUserVehicle;
    
    
    //Constructor
    public ProductSearchController (ApexPages.StandardController controller) {
        try {
            
            theOpp = [select Id,Name, Pricebook2Id,PriceBook2.Name,StageName from Opportunity where Id = :String.escapeSingleQuotes(controller.getRecord().Id)];
            if (theOpp != null)
                oppLineItems = [select Id,Name, PricebookEntryId  from opportunityLineItem where (OpportunityId=:theOpp.Id  )];
            searchProduct();
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    
    /**
* @Description : Method is used to search products based on user input
* @Param : N/A
* @return: Nothing
**/
    public void searchProduct (){
        try { 
            String keyword = theOpp.Pricebook2Id;
            existingProdId=getExistingPBEntryId();
            wraplist = new List<wrapper>();  
            System.debug(searchName+'===='+searchCode);
            String query=constructQuery(searchName,searchCode,searchType, keyword);
            System.debug('query:'+query);
            List<PricebookEntry> pList=Database.query(query);                
            for(PricebookEntry pbRec:pList){                  
                if(!existingProdId.contains(pbRec.Id)){    
                    wrapper w= new wrapper();           
                    w.prg=pbRec;       
                    w.Pricebookid=pbRec.Pricebook2.ID;
                    wraplist.add(w); 
                }
            }
            
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
    }
    
    /**
* @Description : Method is used to fetch price book entry id for opportunity line items
* @Param : N/A
* @return: Set<Id>
**/
    
    private Set<id> getExistingPBEntryId()
    {
        Set<id> existingProdIds=new Set<id>();
        try{       
            for(opportunityLineItem oppLIRec:oppLineItems)
            {
                existingProdIds.add(oppLIRec.PricebookEntryId);
            }     
        }
        catch(Exception e)
        {
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
            
        }
        return existingProdIds;
    }
    
    /**
* @Description : Method is used to construct query based on user input
* @Param : Product Name,,Product Vehicle,Product Geography
* @return: String
**/
    
    private  String constructQuery(String productName,String productCode, String productType, String keyword)
    {
        system.debug(keyword);
        String query='Select Id,Name,Product2.Id,ProductCode,Product2.Description,Pricebook2.Id,Product2.Family, Type__c, Product2.Fee__c from PricebookEntry where IsActive=true '; // AND pricebook2Id = :keyword 
        if(!String.isEmpty(productName))
            query=query+ ' AND Name like '+'\'%'+String.escapeSingleQuotes(productName)+ '%\'';
        if(!String.isEmpty(productCode))
            query=query+ '  AND ProductCode like '+'\'%'+String.escapeSingleQuotes(productCode)+ '%\'';
        if(!String.isEmpty(productType) && productType != 'none')
            query=query+ '  AND Type__c like '+'\'%'+String.escapeSingleQuotes(productType)+ '%\'';
        query=query+' AND PriceBook2.isStandard = false AND (Type__c =\'Loan\' OR Type__c =\'Deposit\' OR Type__c =\'Credit Card\') ORDER BY Createddate ASC limit 50'; //Limit is changed to 50 on 01/Feb/2017
        return query;
    }
    /**
* @Description : Method runs when a user hits "remove" on an item in the "Selected Products" section
* @Param : N/A
* @return: Nothing
**/
    
    public void removeFromLineItem(){
        
    }
    /**
* @Description : Method runs when a user hits "select" button next to a product
* @Param : N/A
* @return: Nothing
**/
    
    public Pagereference addToLineItem(){
        Pagereference pr = new Pagereference('/'+theOpp.ID);
        try {
            Integer i=0;
            for(wrapper d : wraplist ){
                System.debug('toSelect:'+toSelect);
                if((String)(d.prg.Name)==toSelect)
                {
                    System.debug('prgName:'+d.prg.Name);
                    OpportunityLineItem addItem = new OpportunityLineItem();
                    addItem.OpportunityId= theopp.Id;
                    addItem.PriceBookEntryId=d.prg.ID; 
                    addItem.Quantity = 1;   
                    addItem.UnitPrice=0;
                    addItem.Type__c = d.prg.Type__c;
                    addItem.Description = d.prg.Product2.Description;
                    addItem.Fee__c = d.prg.Product2.Fee__c;
                    
                    insert addItem;
                    pr.setRedirect(true);
                    return pr;
                    break;
                }                 
                i++;
            }           
            
        }
        catch (exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }
        return pr;
    }
    
    /**
* @Description : Method is used to insert opportunity line items for selected products.
* @Param : N/A
* @return: PageReference
**/
    public PageReference onSave(){
        PageReference pageRef;
        try{
            upsert oppLineItems; 
            if(isCustomFeeType){
                pageRef=    new PageReference('/apex/MFS_ProductApprovalPage?id='+theOpp.ID);
                pageRef.setRedirect(true);
            } else {
                pageRef= new PageReference('/'+theOpp.ID);
            }
        }
        catch(DMLException dexe)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,dexe.getDmlMessage(0)));
            System.debug('Exception Occured:'+dexe.getMessage()+dexe.getLineNumber());
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));  
            System.debug('Exception Occured:'+e.getMessage()+e.getLineNumber());
        }  
        
        // After save return the user to the Opportunity 
        
        return pageRef;
        
    }
    
    /**
* @Description :Cancel method to return user to original opportunity record
* @Param : N/A
* @return: PageReference
**/
    public PageReference onCancel(){
        return new PageReference('/'+ theOpp.ID);
    }
    /**
* @Description :Wrapper class to display data on page
**/
    
    public class wrapper{
        public PricebookEntry prg {get;set;}
        public Id Pricebookid{get;set;}
        
    }
    
    public List<Selectoption> getProductTypeOptions(){
        List<Selectoption>  prodTypes=new List<Selectoption> ();
        prodTypes.add(new SelectOption('None','---None---'));        
        map<String, Schema.SObjectField> fieldMap = Product2.getSObjectType().getDescribe().fields.getMap();
        list<Schema.PicklistEntry> values = fieldMap.get('Type__c').getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : values)
        { 
            prodTypes.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return prodTypes;
    }
}