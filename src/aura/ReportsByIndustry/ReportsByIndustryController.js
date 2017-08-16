({
	myAction : function(component, event, helper) {
       		 (function($) {
            $(function() {
				Highcharts.setOptions({
                    lang: {
                        thousandsSep: ','
                    }
                });
                
                var action1 = component.get("c.getAUMVal");
                action1.setParams({});
                action1.setCallback(this, function(actionResult) {
                    var dataAUM = JSON.parse(actionResult.getReturnValue());
                    Highcharts.setOptions({
                        colors: ['#2b908f', '#90ee7e', '#f45b5b', '#7798BF', '#aaeeee', '#ff0066', '#eeaaee','#55BF3B', '#DF5353', '#7798BF', '#aaeeee', '#DDDF0D', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee', '#ff0066', '#eeaaee', '#55BF3B', '#DF5353', '#7798BF', '#aaeeee']
                    });
                    
                    Highcharts.chart('bar-chart1', {
                        chart: {
                            plotBackgroundColor: null,
                            plotBorderWidth: null,
                            plotShadow: false,
                            type: 'pie',
                            events: {
                                load: function(event) {
                                    var total = 0; // get total of data
                                    for (var i = 0, len = this.series[0].yData.length; i < len; i++) {
                                        total += this.series[0].yData[i];
                                    }
                                    total = Math.round(total / 10000) / 100;
                                    var text = this.renderer.text(
                                        'Total: $' + total + 'M'  ,
                                        this.plotLeft + 30,
                                        this.plotTop + 20
                                    ).attr({
                                        zIndex: 5,
                                        padding: 5
                                    }).add()
                                }
                            }
                        },
                        title: {
                            text: 'My Book of Business (AUM)'
                        },
                        tooltip: {
                            pointFormat: '{series.name}: <b>${point.y}</b> ({point.percentage:.1f}%)'
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: true,
                                cursor: 'pointer',
                                dataLabels: {
                                    enabled: false,
                                    formatter: function() {
                                        return 'Total: ' + this.total;
                                    }
                                },
                                showInLegend: true
                            }
                        },
                        series: [{
                            name: 'Industry',
                            colorByPoint: true,
                            data: dataAUM
                        }]
                    });
                });
                
                var action2 = component.get("c.getLoanVal");
                action2.setParams({});
                action2.setCallback(this, function(actionResult) {
                    var dataAUM = JSON.parse(actionResult.getReturnValue());
                    Highcharts.chart('bar-chart2', {
                        chart: {
                            type: 'bar'
                        },
                        title: {
                            text: 'Outstanding Loans by Account'
                        },
                        xAxis: {
                            categories: dataAUM.stringLst,
                            crosshair: true
                        },
                        yAxis: {
                            min: 0,
                            title: {
                                text: 'Account Name'
                            }
                        },
                        tooltip: {
                            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                            '<td style="padding:0"><b>${point.y}</b></td></tr>',
                            footerFormat: '</table>',
                            shared: true,
                            useHTML: true
                        },
                        plotOptions: {
                            column: {
                                pointPadding: 0.2,
                                borderWidth: 0
                            }
                        },
                        series: [{
                            name: 'Sum of Loan Amount',
                            data: dataAUM.valLst,
                            showInLegend: false
                        }]
                    });
                });
                
                var action3 = component.get("c.getTotRevenue");
                action3.setParams({});
                action3.setCallback(this, function(actionResult) {
                    
                    /*var gaugeOptions = {
                                chart: {
                                    type: 'solidgauge'
                                },
                                title: null,
                                pane: {
                                    center: ['50%', '85%'],
                                    size: '140%',
                                    startAngle: -90,
                                    endAngle: 90,
                                    background: {
                                        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
                                        innerRadius: '60%',
                                        outerRadius: '100%',
                                        shape: 'arc'
                                    }
                                },
                                tooltip: {
                                    enabled: false
                                },
                                // the value axis
                                yAxis: {
                                    stops: [
                                        [0.1, '#55BF3B'], // green
                                        [0.5, '#DDDF0D'], // yellow
                                        [0.9, '#DF5353'] // red
                                    ],
                                    lineWidth: 0,
                                    minorTickInterval: null,
                                    tickAmount: 2,
                                    title: {
                                        y: -70
                                    },
                                    labels: {
                                        y: 16
                                    }
                                },
                        
                                plotOptions: {
                                    solidgauge: {
                                        dataLabels: {
                                            y: 5,
                                            borderWidth: 0,
                                            useHTML: true
                                        }
                                    }
                                }
                            };
                            
                            // The speed gauge
                            var chartSpeed = Highcharts.chart('container-speed', Highcharts.merge(gaugeOptions, {
                                yAxis: {
                                    min: 0,
                                    max: 200,
                                    title: {
                                        text: 'Speed'
                                    }
                                },
                        
                                credits: {
                                    enabled: false
                                },
                        
                                series: [{
                                    name: 'Speed',
                                    data: [80.332323],
                                    dataLabels: {
                                        format: '<div style="text-align:center"><span style="font-size:25px;color:' +
                                        ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y}</span><br/>' +
                                        '<span style="font-size:12px;color:silver">km/h</span></div>'
                                    },
                                    tooltip: {
                                        valueSuffix: ' km/h'
                                    }
                                }]
                        
                            }));*/
                            
                            var dataAUM = JSON.parse(actionResult.getReturnValue());
                            Highcharts.chart('bar-chart3', {
                                chart: {
                                    type: 'column'
                                },
                                title: {
                                    text: 'Revenue by Account'
                                },
                                xAxis: {
                                    categories: dataAUM.stringLst,
                                    crosshair: true
                                },
                                yAxis: {
                                    min: 0,
                                    title: {
                                        text: 'Revenue'
                                    }
                                },
                                tooltip: {
                                    headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                                    pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                                    '<td style="padding:0"><b>$ {point.y:.1f}</b></td></tr>',
                                    footerFormat: '</table>',
                                    shared: true,
                                    useHTML: true
                                },
                                plotOptions: {
                                    column: {
                                        pointPadding: 0.2,
                                        borderWidth: 0
                                    }
                                },
                                series: [{
                                    name: 'Account Name',
                                    data: dataAUM.valLst
                                    
                                }]
                            });
                        });
                
                $A.enqueueAction(action1);
                $A.enqueueAction(action2);
                //$A.enqueueAction(action3); 
            });
        })(jQuery)
	}
});