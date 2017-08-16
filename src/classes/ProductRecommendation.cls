/**************************************************************************************************   
Apex Controller Name :  
Version              :  1.0                                                                          
Created Date         :  March 09, 2017                                                              
Function             :  Controller class for 
Description          :  
Story                :                                                                               
Work Task            :                                                                               
Modification Log     :                                                                               
*--------------------------------------------------------------------------------------------------  
* Developer                         Date                   Description                                     
* -------------------------------------------------------------------------------------------------  
* Premkumar Mohandass               03/09/2017             First Iteration            
***************************************************************************************************/
global class ProductRecommendation 
{
    public List<RecommendedPlans> rpList{get;set;}
    public String selectedProdId { get; set; }
    public String accPlanId1 {get; set; }
    
    public ProductRecommendation(ApexPages.StandardController std)
    {
        rpList = getProductRecommendation(95);
        
    }
    
    /* 
@AuraEnabled 
public static String fetchProductRecommendation()
{
List<RecommendedPlans> getRecommendedPlansList = new List<RecommendedPlans>();

getRecommendedPlansList = getProductRecommendation(50);
String productRecommendationStr = JSON.serialize(getRecommendedPlansList);

system.debug('productRecommendationStr' +productRecommendationStr);
return productRecommendationStr;
}
*/
    /******************************************************************************************************
* @Description: 
* @Parameter: None
* @Return: Returns the page reference for forwarding the request to Personal Detail page
* @Usage: Used for navigating to the personal detail page.
*******************************************************************************************************/
    public static List<RecommendedPlans> getProductRecommendation(Integer memberID)
        
    {
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
                            system.debug('recommended plans ' +rp);
                            //Recommended_Product_Details__c rpd = Recommended_Product_Details__c.getInstance(rp.name);
                            if(rpdMap.get(rp.recommendedPlanID) != null)
                            {
                                rp.planName = rpdMap.get(rp.recommendedPlanID).Plan_Name__c;
                                rp.planDescription = rpdMap.get(rp.recommendedPlanID).Plan_Description__c;
                                rp.minimumPolicyCost = rpdMap.get(rp.recommendedPlanID).Minimum_Policy_Cost__c;
                                rp.planImageURL = rpdMap.get(rp.recommendedPlanID).Image_URL__c;
                                rp.sourcePlanName = rpdMap.get(rp.sourcePlanID).Plan_Name__c;
                                rp.discussedWithClient = rpdMap.get(rp.recommendedPlanID).Discussed_with_client__c;
                                rp.opportunityExits = rpdMap.get(rp.recommendedPlanID).Opportunity_Exits__c ;
                            }
                            else
                            {
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
        
        
        //String endPoint = 'http://104.196.216.101:8080/ea/services/member/'+memberID+'/recommendations';
        //String endPoint = 'http://104.196.216.101:8080/ea/services/member/123/recommendations';
        String endPoint = 'http://104.196.216.101:8080/cb/services/member/'+memberID+'/recommendations';
        
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setHeader('apiKey', 'Q29uc3VtZXJAVWhHX1NGOTY=');
        
        try
        {
            res = http.send(req);
        }
        catch(Exception e)
        {system.debug(e);}
        
        return res;
    }
    
    //Inner class used for Serialization by readValueas() method.
    global class RecommendedPlans implements comparable
    {
        public String description{get;set;}
        public String recommendedPlanID{get;set;}
        public String imageUrl{get;set;}
        public String sourcePlanID{get;set;}
        public String matchPercentage{get;set;}
        public String planDescription{get;set;}
        public String planName{get;set;}
        public String minimumPolicyCost{get;set;}
        public String planImageURL{get;set;}
        public String sourcePlanName{get;set;}
        public boolean discussedWithClient {get;set;}
        public boolean opportunityExits {get;set;}
        //public Recommended_Plan_Details__c rpd{}
        
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
    
    public void createAnalysis(){
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
                
                if(rp.opportunityExits == true && rp.discussedWithClient == true && !String.isEmpty(accPlanId1)){
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
    }
}