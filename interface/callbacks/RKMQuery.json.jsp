<%-- Include the package initialization file. --%>
<%--
    RKMQuery.json.jsp - searches RKM
    Parameters:
        q: The search term(s) *Required*
        return: [html/json] Do you want HTML of JSON returned (Default=json) *Optional*
        count: [true/false] If returning HTML, do you want count div to be visible (Default=false) *Optional*
 --%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    // Set the page content type, ensuring that UTF-8 is used
    response.setContentType("application/json; charset=UTF-8");
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            // Retrieve the search terms from the request parameters.
            String mustHave = request.getParameter("q"); //request.getParameter("mustHave");
            String mayHave = ""; //request.getParameter("mayHave");
            String mustNotHave = ""; //request.getParameter("mustNotHave");

            // Should we return formatted HTML
            Boolean validRequest = request.getParameter("q") != null && request.getParameter("q").length() > 0 ? true : false;
            // Should we return formatted HTML
            Boolean returnHTML = request.getParameter("return") != null && request.getParameter("return").equalsIgnoreCase("html") ? true : false;
            // Should we show the count
            Boolean showCount = request.getParameter("count") != null && request.getParameter("count").equalsIgnoreCase("true") ? true : false;
            
            // Perform the multi form search and write the result to the out
            // stream.
            MultiFormSearch mfs = new MultiFormSearch(mustHave, mayHave, mustNotHave, systemUser);
            if (returnHTML){
%>
                <div class="panel panel-default rkm-message-container hide">
                    <div class="panel-heading rkm-message"></div>
                </div>
<%            	
                if (validRequest){
	                ArrayList<LinkedHashMap> data = mfs.searchData(serverUser);
	                int rkmCount = 0;
	
	                for (LinkedHashMap a : data){
	                    if (a.get("Source") != null){
	                    	String sourceCallback = a.get("Source").toString().replaceAll("\\s","");
	                    	sourceCallback = sourceCallback.substring(0, 1).toLowerCase() + sourceCallback.substring(1);
	                        rkmCount++;
%>
	                        <div class="panel panel-default rkm-article" id="article-<%=a.get("Article ID")%>">
	                            <div class="panel-heading rkm-article-title" data-rkm-article-source="<%=sourceCallback%>" data-rkm-article-id="<%=a.get("Article ID")%>">
	                                <span><%=a.get("Article Title")%></span> <i class="fa fa-plus-square"></i>
	                            </div>
	                            <div class="panel-body rkm-article-details">
	                                <div class="rkm-article-summary">
	                                    <span><%=a.get("Summary")%></span>
	                                </div>
	                                <div class="col-sm-6 rkm-article-id">
	                                    <%=getIconForSource(a.get("Source").toString())%> <span><%=a.get("Article ID")%></span>
	                                </div>
	                                <div class="col-sm-6 rkm-article-date">
	                                    <i class="fa fa-clock-o" data-description="<%=a.get("Created Date")%>"></i> <span><%=a.get("Created Ago") + " ago"%></span>
	                                </div>
	                            </div>
	                            <div class="panel-body rkm-article-text hide">
	                                <i class="fa fa-spinner fa-spin"></i> Loading Article
	                            </div>
	                        </div>
<%
	                    }
	                }
%>
	                <div class="rkm-count hide" data-rkm-count="<%=rkmCount%>"></div>
	                <style type="text/css">
	                    .rkm-message-container,
						.rkm-article {
						    margin: 5px 0;
						    border-color: #cccccc;
						    color: #292929;
						}
						.rkm-message-container > div,
						.rkm-article > div {
						    padding: 5px;
						}
						.rkm-message-container .rkm-message {
						    position: relative;
	                        font-weight: bold;
	                        padding-right: 20px;
	                        border: none;
						}
						.rkm-article .rkm-article-title {
						    position: relative;
						    cursor: pointer;
						    font-weight: bold;
						    padding-right: 20px;
	                        border-color: #cccccc;
						}
						.rkm-article .rkm-article-title i {
						    position: absolute;
						    top: 7px;
						    right: 5px;
						}
						.rkm-article div[class^="col-"] {
						    padding: 0;
						    margin: 0;
						}
						.rkm-article .rkm-article-text {
						    border-top-style: solid;
						    border-top-width: 1px;
						    border-top-color: inherit;
						    background-color: #fafafa !important;
						}
	                    .rkm-article .rkm-article-text * {
	                        font-size: 12px !important;
	                        color: #292929 !important;
	                        background-color: transparent !important;
	                        border: none !important;
	                        margin: 0 !important;
	                    }
	                    .rkm-article .rkm-article-text div.article a {
	                        color: #0000AA !important;
	                    }
	                    .rkm-article .rkm-article-text div.article sup {
	                        font-size: 70% !important;
	                        position: relative !important;
	                    }
	                    .rkm-article .rkm-article-text .article div.label {
	                        font-weight: bold !important;
	                        text-decoration: underline !important;
	                    }
	                    .rkm-article .rkm-article-text .article div.value {
	                        margin: 5px 0 !important;
	                    }
	                </style>
	                <script type="text/javascript">
	                    $('div.rkm-message').text("<%=rkmCount%> Result" + ("<%=rkmCount%>" != "1" ? "s" : ""));
	                    <%=showCount ? "$('div.rkm-message-container').removeClass('hide');" : ""%>
	                    var qtipOptions = {
	                        content: { attr:'data-description' },
	                        style: { classes:'qtip-tipsy qtip-shadow', tip: { corner: true } },
	                        position: { my:'left center', at:'right middle' } 
	                    };
	                    $('div.rkm-article-id i, div.rkm-article-date i').qtip(qtipOptions).qtip('api');
	                    $('div.rkm-article-title').on('click', function(e){
	                    	var $article = $(this).closest('.rkm-article'); 
	                    	var dataLoaded = $article.data('rkm-article-loaded') ? true : false;
	                        $article.find('div.rkm-article-text').stop(true, true).slideToggle(300);
	                        $(this).find('i').toggleClass('fa-plus-square fa-minus-square');
	                    	if (!dataLoaded){
	                    		$article.data('rkm-article-loaded', true);
	                    		var $articleText = $article.find('.rkm-article-text');
	                   		
	                    		BUNDLE.ajax({
	                                url: '<%=bundle.getProperty("rkmUrl")%>' + '&callback=' + $(this).data('rkm-article-source'),
	                                data: { articleId: $(this).data('rkm-article-id')},
	                                success: function(data) {
	                                    // Article Data
	                                    $articleText.html(data);
	                        
	                                    // Images through Kinetic
	                                    $articleText.find("img").each(function(){
	                                      var arattid, arentryid, arschema;
	                                        arattid = $(this).attr("arattid");
	                                        ($(this).attr("arschema") && $(this).attr("arschema").length > 0) ? arschema = $(this).attr("arschema") : arschema = articleForm;
	                                        ($(this).attr("arentryid") && $(this).attr("arentryid").length > 0) ? arentryid = $(this).attr("arentryid") : arentryid = articleRequestId.replace(/(KBA\w+)/,"").replace('|',"");
	                                        $(this).attr("src", "DownloadAttachment/" + arschema + "/" + arattid + "/" + arentryid);
	                                    });
	                        
	                                    // Document attachments through Kinetic
	                                    $articleText.find("a[path*='sharedresources']").each(function(){
	                                      var path = $(this).attr('path').replace(/\?(.*)/,"");
	                                      var urlParsed = path.split("/");
	                                      $(this).attr("href", "DownloadAttachment/" + urlParsed[2] + "/" + urlParsed[3] + "/" + urlParsed[4]);
	                                    });
	                        
	                                    // Keywords
	                                    var strKeywords = $articleText.find('.article .field .value.keywords').text();
	                                    var keywords = strKeywords.replace(/[\n\r]/g,"").split(" ");
	                                    $articleText.find('.article .field .value.keywords').empty();
	                                    $.each(keywords, function(index,val){
	                                      if(val != ""){
	                                    	  $articleText.find('.article .field .value.keywords').append('<span>'+val+'</span>');
	                                      }
	                                    });
	                                }
	                            });
	                    	}
	                    });
	                </script>
<%
	            }
	            else {
%>
                    <script type="text/javascript">
                        $('div.rkm-message').text("Invalid search criteria.");
                        $('div.rkm-message-container').removeClass('hide');
                    </script>
<%
	            }
            }
            else {
                String jsonData = mfs.search(serverUser);
                out.println(jsonData);
            }
        } catch (Exception e) {
            // Write the exception to the kslog and re-throw it
            logger.error("Exception in RKMQuery.json.jsp", e);
            throw e;
        }
    }
%>
<%!
    private static String getIconForSource(String source){
        if (source == null){
            return "";
        }
        else if (source.equalsIgnoreCase("Decision Tree")){
            return "<i class='fa fa-filter' data-description='Decision Tree'></i> ";
        }
        else if (source.equalsIgnoreCase("How To")){
            return "<i class='fa fa-info-circle' data-description='How To'></i> ";
        }
        else if (source.equalsIgnoreCase("Known Error")){
            return "<i class='fa fa-exclamation-triangle' data-description='Known Error'></i> ";
        }
        else if (source.equalsIgnoreCase("Problem Solution")){
            return "<i class='fa fa-question-circle' data-description='Problem Solution'></i> ";
        }
        else if (source.equalsIgnoreCase("Reference")){
            return "<i class='fa fa-archive' data-description='Reference'></i> ";
        }
        else {
            return "";
        }
    }
%>