({
    doInit : function(component, event, helper) {
        console.log("chart script loaded");
        console.log("outside", localStorage.getItem("CB_ReloadFlag"));
        
        if(localStorage.getItem("CB_ReloadFlag") !== "true") {
            //window.location = window.location + '#loaded'; 
            console.log("Inside", localStorage.getItem("CB_ReloadFlag"));
            localStorage.setItem("CB_ReloadFlag", "true");
            window.location.reload(); 
        }
        else{
            localStorage.setItem("CB_ReloadFlag", "false");
        }
        
        var getReportData = component.get("c.getReportData");
        
        getReportData.setParams({
            accPlanId: component.get("v.recordId")
        });
        // Register the callback function
        
        getReportData.setCallback(this, function(response) {
            var data1 = helper.formatDataArr([response.getReturnValue()[0]]);
            var data2 = helper.formatDataArr([response.getReturnValue()[1]]);
            var data3 = helper.formatDataArr([response.getReturnValue()[2]]);
            var data4 = helper.formatDataArr([response.getReturnValue()[3]]);
            var data5 = helper.formatDataArr([response.getReturnValue()[4]]);
            var data6 = helper.formatDataArr([response.getReturnValue()[5]]);
            
            console.log(response.getReturnValue()[6], response.getReturnValue()[7],response.getReturnValue()[8]);
            // Value Alignment Highchart implementation.
            
            Highcharts.chart('va-chart', {
                chart: {
                    type: 'line'
                },
                title: {
                    text: 'Services'
                },
                xAxis: {
                    categories: ['Treasury', 'Price', 'Structure', 'Corp Finance/M&A', 'Global Markets/FX/IRD']
                },
                credits: {
                    enabled: false
                },
                series: [{
                    name: response.getReturnValue()[6],
                    color: '#434348',
                    data: data1
                }, {
                    name: response.getReturnValue()[7],
                    color: '#7cb5ec',
                    data: data2
                }, {
                    name: response.getReturnValue()[8],
                    color: '#FF8F33',
                    data: data5
                }]
                
            });    
            
            Highcharts.chart('va-chart1', {
                chart: {
                    type: 'line'
                },
                title: {
                    text: 'Products'
                },
                xAxis: {
                    categories: ['Mortgage Loans', 'Money Market Accounts', 'Business Loans', 'High yield account', 'Business Checking & Savings']
                },
                credits: {
                    enabled: false
                },
                
                series: [{
                    name: response.getReturnValue()[6],
                    color: '#434348',
                    data: data3
                }, {
                    name: response.getReturnValue()[7],
                    color: '#7cb5ec',
                    data: data4
                }, {
                    name: response.getReturnValue()[8],
                    color: '#FF8F33',
                    data: data6
                }]
            });
            
            // Value Alignment Highchart implementation.
            
        });
        $A.enqueueAction(getReportData);
    }
})