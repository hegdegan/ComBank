({
	/*myAction : function(component, event, helper) {
        var accessToken = "f70466a874da49d9a8bb635c4f1f9089";
		var baseUrl = "https://api.api.ai/v1/";
        var accountid = component.get("v.recordId");
       
		var recognition;

		function startRecognition() {
			recognition = new webkitSpeechRecognition();
			console.log("1..."+recognition)
			recognition.onstart = function(event) {
				updateRec();
			};
			recognition.onresult = function(event) {
			    console.log("6..."+recognition);
				var text = "";
			    for (var i = event.resultIndex; i < event.results.length; ++i) {
			    	text += event.results[i][0].transcript;
			    }
			    setInput(text);
				stopRecognition();
			};
			recognition.onend = function() {
			    console.log("7..."+recognition);
				stopRecognition();
			};
			recognition.lang = "en-US";
			recognition.start();
			console.log("2..."+recognition)
		}
	
		function stopRecognition() {
		console.log("3..."+recognition)
			if (recognition) {
				recognition.stop();
				recognition = null;
				console.log("4..."+recognition)
			}
			updateRec();
		}

		function switchRecognition() {
			if (recognition) {
				stopRecognition();
			} else {
				startRecognition();
			}
		}

		function setInput(text) {
			$("#input").val(text);
			send();
		}

		function updateRec() {
		console.log("5..."+recognition)
			$("#rec").text(recognition ? "Stop" : "Speak");
		}

		function send() {
			var text = $("#input").val();
			$.ajax({
				type: "POST",
				url: baseUrl + "query?v=20150910",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				headers: {
					"Authorization": "Bearer " + accessToken
				},
				data: JSON.stringify({ query: text, lang: "en", sessionId: "somerandomthing" }),

				success: function(data) {
					//setResponse(JSON.stringify(data, undefined, 2));
					var resText = data["result"]["fulfillment"]["speech"];
					if(resText=="Mention accountId"){
					    var temptext = accountid;
						$.ajax({
							type: "POST",
							url: baseUrl + "query?v=20150910",
							contentType: "application/json; charset=utf-8",
							dataType: "json",
							headers: {
								"Authorization": "Bearer " + accessToken
							},
							data: JSON.stringify({ query: temptext, lang: "en", sessionId: "somerandomthing" }),

							success: function(data) {
								//console.log("Account Id Sent....");
								setResponse(data["result"]["fulfillment"]["speech"]);
								responsiveVoice.speak(data["result"]["fulfillment"]["speech"]);
							},
							error: function() {
								//setResponse("Internal Server Error");
								console.log("Error encountered while setting account id.....");
							}
						});
						
					}else{
					    setResponse(data["result"]["fulfillment"]["speech"]);
						responsiveVoice.speak(data["result"]["fulfillment"]["speech"]);
					}
					
					
				},
				error: function() {
					setResponse("Internal Server Error");
				}
			});
			setResponse("Loading...");
		}

		function setResponse(val) {
			$("#response").text(val);
		}
        
        
        (function($){
            $(document).ready(function() {
                $("#input").keypress(function(event) {
                    if (event.which == 13) {
                        event.preventDefault();
                        send();
                    }
                });
                $("#rec").click(function(event) {
                    switchRecognition();
                });
            });
        })(jQuery);
	}
    */
    myAction :function(component, event, helper){
    var accessToken = "f70466a874da49d9a8bb635c4f1f9089";
    var baseUrl = "https://api.api.ai/v1/";
    var accountid = component.get("v.recordId");//"0016300000KZm66AAD";
    $(document).ready(function() {
        $("#input").keypress(function(event) {
            if (event.which == 13) {
                event.preventDefault();
                send();
            }
        });
        $("#rec").click(function(event) {
            switchRecognition();
        });
        
        $(".chat-minimize").on("click", function(){
        	$(".chat-bot-container").toggleClass("minimize-it");
        });
        
        $(".smart_bot").on("click", function(){
            $(".chat_type_handle").removeClass("selected");
            $(this).addClass("selected");
            $(".chat_panel").addClass("slds-hide");
        	$(".chat-bot-conversation-panel").removeClass("slds-hide");
            $(".chat-bot-messaging-panel").removeClass("slds-hide");
            
            $(".chat-bot-container").removeClass("minimize-it");
        });
        
        $(".sfdc_chat").on("click", function(){
            $(".chat_type_handle").removeClass("selected");
            $(this).addClass("selected");
        	$(".chat_panel").addClass("slds-hide");
        	$(".chat-bot-conversation-panel-sfdc").removeClass("slds-hide");
            $(".chat-bot-messaging-panel").addClass("slds-hide");
            
            $(".chat-bot-container").removeClass("minimize-it");
        });
    });
    
    var recognition;
    
    function startRecognition() {
        recognition = new webkitSpeechRecognition();
        console.log("1..."+recognition)
        recognition.onstart = function(event) {
            updateRec();
        };
        recognition.onresult = function(event) {
            console.log("6..."+recognition);
            var text = "";
            for (var i = event.resultIndex; i < event.results.length; ++i) {
                text += event.results[i][0].transcript;
            }
            setInput(text);
            stopRecognition();
        };
        recognition.onend = function() {
            console.log("7..."+recognition);
            stopRecognition();
        };
        recognition.lang = "en-US";
        recognition.start();
        console.log("2..."+recognition)
    }
    
    function stopRecognition() {
        console.log("3..."+recognition)
        if (recognition) {
            recognition.stop();
            recognition = null;
            console.log("4..."+recognition)
        }
        updateRec();
    }
    
    function switchRecognition() {
        if (recognition) {
            $("#rec").removeClass("speaking");
            stopRecognition();
        } else {
            $("#rec").addClass("speaking");
            startRecognition();
        }
    }
    
    function setInput(text) {
        $("#input").val(text);
        send();
    }
    
    function updateRec() {
        console.log("5..."+recognition)
        //$("#rec").text(recognition ? "Stop" : "Speak");
    }
    
    function send() {
        var text = $("#input").val();
        $("#rec").removeClass("speaking");
        
        $.ajax({
            type: "POST",
            url: baseUrl + "query?v=20150910",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            headers: {
                "Authorization": "Bearer " + accessToken
            },
            data: JSON.stringify({ query: text, lang: "en", sessionId: "somerandomthing" }),
            
            success: function(data) {
                //setResponse(JSON.stringify(data, undefined, 2));
                var resText = data["result"]["fulfillment"]["speech"];
                if(resText=="Mention accountId"){
                    var temptext = accountid;
                    $.ajax({
                        type: "POST",
                        url: baseUrl + "query?v=20150910",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        headers: {
                            "Authorization": "Bearer " + accessToken
                        },
                        data: JSON.stringify({ query: temptext, lang: "en", sessionId: "somerandomthing" }),
                        
                        success: function(data) {
                            //console.log("Account Id Sent....");
                            setResponse(data["result"]["fulfillment"]["speech"]);
                            responsiveVoice.speak(data["result"]["fulfillment"]["speech"]);
                        },
                        error: function() {
                            //setResponse("Internal Server Error");
                            console.log("Error encountered while setting account id.....");
                        }
                    });
                    
                }else{
                    setResponse(data["result"]["fulfillment"]["speech"]);
                    responsiveVoice.speak(data["result"]["fulfillment"]["speech"]);
                }
                
                
            },
            error: function() {
                setResponse("Internal Server Error");
            }
        });
        
        //setResponse("Loading...");
        
        $("#input").val("");
        setResponse(text, "user");
    }
    
    function setResponse(val, msgFrom) {
        var cssClassName = msgFrom === "user" ? "from-user" : "from-bot";
        var userName = msgFrom === "user" ? "<span class='your-name'>You :</span>" : "<span class='bot-name'>Bot :</span>";
        $("#response").append('<div class="slds-clearfix"><div class="'+cssClassName+'">'+val+'</div></div>');
        $("#response").animate({ scrollTop: $(this).height() }, "fast");
    }
    function setResponseInfo(val) {
        $("#response").text(val);
    }
}
})