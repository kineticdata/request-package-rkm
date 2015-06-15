(function($, _) {
    /*----------------------------------------------------------------------------------------------
     * DOM MANIPULATION AND EVENT REGISTRATION
     *   This section is executed on page load to register events and otherwise manipulate the DOM.
     *--------------------------------------------------------------------------------------------*/
    $(function() {
    	// If URL contains query parameter, search by that parameter
    	if (queryParameterExists){
    		var params = {
            	"q": queryParameter
            };
            package.getSearchResults(params);
    	}
    	// If URL contains a hash, search by the hash value
    	else if ($(location).attr('hash')){
    		var params = {
            	"q": $(location).attr('hash').substr(1)
            };
    		package.getSearchResults(params);
    	}

        // Set the focus to the search box
        $("form#rkm-search-form input").focus();
        
        // On submit of the search terms form we call the RKMQuery.json.jsp which returns
        // a json result that represents the matching articles.  We use this json
        // result to generate an html table.  Each row in the table has a clicked
        // handler bound to it that retrieves the article (defined below).
        $("form#rkm-search-form").submit(function(e) {
        	e.preventDefault();
        	var $searchInput = $(this).find('input');
        	$searchInput.blur();
        	var params = {
            	"q": $searchInput.val()
            };
            package.getSearchResults(params);
            return false;
        });
    });
    
    /*----------------------------------------------------------------------------------------------
     * PACKAGE INIALIZATION
     *   This code is executed when the Javascript file is loaded
     *--------------------------------------------------------------------------------------------*/
    
    // Ensure the BUNDLE global object exists
    BUNDLE = BUNDLE || {};
    // Create the package namespace
    BUNDLE.package = BUNDLE.package || {};
    // Create a scoped alias to simplify references
    var package = BUNDLE.package;
    
    
    package.getSearchResults = function(parameters) {
        var params = parameters;
        params.return = "html";
        console.log(params);
        var $searchInput = $('.rkm-search input');
        var $searchButtonIcon = $('.rkm-search button i');
        var $searchMessage = $('.rkm-message');
        var $searchError = $('.rkm-error');
        var $searchResults = $('.rkm-results');
        if ($.trim(params.q)){
	        BUNDLE.ajax({
	            type: 'get',
	            url: BUNDLE.config.rkmUrl + '&callback=rkm',
	            data: params,
	            dataType: "html",
	            beforeSend: function(jqXHR, settings) {
	            	$searchButtonIcon.find('button i').removeClass('fa-search').addClass('fa-spinner fa-spin');
	            },
	            success: function(data, textStatus, jqXHR) {
	            	var count = $searchResults.html(data).find('.rkm-count').data('rkm-count');
	            	$searchMessage.html(count + ' Result' + (count != 1 ? 's' : '')).css('display', 'table-cell');
	                $searchButtonIcon.removeClass('fa-spinner fa-spin').addClass('fa-search');
	            },
	            error: function(jqXHR) {
	            	$searchMessage.html('<i class="fa fa-exclamation-triangle"></i> Error').css('display', 'table-cell');
	            	$searchButtonIcon.removeClass('fa-spinner fa-spin').addClass('fa-search');
	            }
	        });
        }
        else {
        	$searchError.text('Required').css('display', 'table-cell');
        	$searchInput.val('').one('keydown', function(event){
        		$searchError.empty().hide();
    		});
        }
    }

    package.loadArticle = function(articleSource, articleId){
    	console.log('loading article');
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
})(jQuery, _);