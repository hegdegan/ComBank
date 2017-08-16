({
	helperMethod : function() {
		
	},
    
    formatDataArr : function(arr){
        var allValues = arr ? arr[0] : "";
        var allValuesObj = allValues.split(",");
        var newArr = [];
        for(var i=0, iLen = allValuesObj.length; i < iLen; i++){
            newArr.push(parseInt(allValuesObj[i]));
        }
        return newArr;
    }
})