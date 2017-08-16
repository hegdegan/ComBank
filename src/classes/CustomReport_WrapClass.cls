public class CustomReport_WrapClass {

     @AuraEnabled
    public string name;
    @AuraEnabled
    public decimal y;
    
    public CustomReport_WrapClass(string sVal,decimal iVal){
        name = sVal;
        y = iVal;
    }
}