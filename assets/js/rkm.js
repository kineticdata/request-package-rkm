$(document).ready(function() {
    // This object maps the source type returned by the multi query jsp to a
    // camel-case version used in css classes and jsp names.
    var sourceMap = {
        "Decision Tree": "<i class='fa fa-filter' data-description='Decision Tree'></i>",
        "How To": "<i class='fa fa-info-circle' data-description='How To'></i>",
        "Known Error": "<i class='fa fa-exclamation-triangle' data-description='Known Error'></i>",
        "Problem Solution": "<i class='fa fa-question-circle' data-description='Problem Solution'></i>",
        "Reference": "<i class='fa fa-archive' data-description='Reference'></i>"
    };
    
    // Here we set the focus to the input box that gathers the search terms
    $("form#searchTerms input#mustHave").focus();
    
    // On submit of the search terms form we call the RKMQuery jsp which returns
    // a json result that represents the matching articles.  We use this json
    // result to generate an html table.  Each row in the table has a clicked
    // handler bound to it that retrieves the article (defined below).
    $("form#searchTerms").submit(function() {
        if ( $(this).find("input#mustHave").val() === "" ) {
            $("#messages").html('<div class="message">Please enter search terms.</div>');
        } else {
        	BUNDLE.ajax({
	        	type: 'get',
	            url: BUNDLE.config.rkmUrl + '&callback=rkm',
	            data: $(this).serialize(),
	            beforeSend: function(jqXHR, settings) {
	            	$("#messages").html('<div class="message"><i class="fa fa-spinner"></i> Searching...</div>');
                },
	            success: function(data, textStatus, jqXHR) {
	            	var qtipOptions = {
                        content: {
                            attr: 'data-description'
                        },
                        style: {
                            classes: 'qtip-tipsy qtip-shadow',
                            tip: {
                                corner: true
                            }
                        },
                        position: {
                            my: 'right center',
                            at: 'left middle'
                        }
                    };
	                var results = data;
                  var resultCount = 0;
	                $("#results").empty();
	                for (var i in results) {
                    if (results[i]["Source"] == null){continue;}
                    
	                	var articleSource = results[i]["Source"].substring(0, 1).toLowerCase() + results[i]["Source"].substring(1).replace(/ /g,"");

	                    var resultDiv = $('<div class="result"></div>');
	                    
	                    var titleDiv = $('<div class="clearfix"></div>');
	                    titleDiv.append('<div class="titleText col-xs-10"><a>' + results[i]["Article Title"] + '</a></div>');
	                    (function(articleSource, articleId){
	                    	$(titleDiv).find('div.titleText a').on('click', function(){
	                    		loadArticle(articleSource, articleId);
	                    	});
	                    })(articleSource, results[i]["Article ID"]);
	                    
	                    titleDiv.append('<div class="icon col-xs-2" title="' + results[i]["Source"] + '">' + sourceMap[results[i]["Source"]] + '</div>');
	                    $(titleDiv).find('div.icon i').qtip(qtipOptions).qtip('api');
	                    resultDiv.append(titleDiv);
	                    
	                    resultDiv.append('<div class="summary">' + results[i]["Summary"] + '</div>');
	                    
	                    var attrDiv = $('<div class="clearfix"></div>');
	                    attrDiv.append('<div class="article-attribute col-xs-6">ID: ' + results[i]["Article ID"] + '</div>');
	                    attrDiv.append('<div class="article-attribute col-xs-6">Created ' + results[i]["Created Ago"] + '</div>');
	                    resultDiv.append(attrDiv);
	                    
	                    resultDiv.append('<div class="article-content hide" id="article-' + results[i]["Article ID"] + '"></div>');


	                    $("#results").append(resultDiv);
                      resultCount++;
	                }                  
	                $("#messages").html('<div class="message">Your search returned ' + resultCount + ' results.</div>');
	            },
	            error: function(data) {
	                $("#messages").html('<div class="message error">An error occurred during the search.</div>');
	            }
        });
        }
        return false;
    });
});

function loadArticle(articleSource, articleId){
	var closeOnly = $('div#article-' + articleId).hasClass('selected-article');
	$('div.selected-article.show').empty().toggleClass('selected-article show');

	if (!closeOnly){
	    BUNDLE.ajax({
	        url: BUNDLE.config.rkmUrl + '&callback=' + articleSource,
	        data: {articleId: articleId},
	        beforeSend: function(jqXHR, settings) {
	        	$('#article-' + articleId).html('<div><i class="fa fa-spinner"></i> Loading...</div>').toggleClass('selected-article show');
            },
	        success: function(data) {
	            // Article Data
	            $('#article-' + articleId).html(data);
	
	            // Images through Kinetic
	            $('#article-' + articleId).find("img").each(function(){
	              var arattid, arentryid, arschema;
	                arattid = $(this).attr("arattid");
	                ($(this).attr("arschema") && $(this).attr("arschema").length > 0) ? arschema = $(this).attr("arschema") : arschema = articleForm;
	                ($(this).attr("arentryid") && $(this).attr("arentryid").length > 0) ? arentryid = $(this).attr("arentryid") : arentryid = articleRequestId.replace(/(KBA\w+)/,"").replace('|',"");
	                $(this).attr("src", "DownloadAttachment/" + arschema + "/" + arattid + "/" + arentryid);
	            });
	
	            // Document attachments through Kinetic
	            $('#article-' + articleId).find("a[path*='sharedresources']").each(function(){
	              var path = $(this).attr('path').replace(/\?(.*)/,"");
	              var urlParsed = path.split("/");
	              $(this).attr("href", "DownloadAttachment/" + urlParsed[2] + "/" + urlParsed[3] + "/" + urlParsed[4]);
	            });
	
	            // Keywords
	            var strKeywords = $('#article-' + articleId + ' .article .field .value.keywords').text();
	            var keywords = strKeywords.replace(/[\n\r]/g,"").split(" ");
	            $('#article-' + articleId + ' .article .field .value.keywords').empty();
	            $.each(keywords, function(index,val){
	              if(val != ""){
	                $('#article-' + articleId + ' .article .field .value.keywords').append('<span>'+val+'</span>');
	              }
	            });
	        }
	    });
	}
}