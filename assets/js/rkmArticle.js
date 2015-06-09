(function($, _) {
    /*----------------------------------------------------------------------------------------------
     * DOM MANIPULATION AND EVENT REGISTRATION
     *   This section is executed on page load to register events and otherwise manipulate the DOM.
     *--------------------------------------------------------------------------------------------*/
    $(function() {
        var articleSource = BUNDLE.common.getUrlParameters().source.substring(0, 1).toLowerCase() + BUNDLE.common.getUrlParameters().source.substring(1).replace(/ /g,"");

        BUNDLE.ajax({
            url: BUNDLE.config.rkmUrl + '&callback=' + articleSource,
            data: { articleId: BUNDLE.common.getUrlParameters().articleId },
            success: function(data) {
                // Article Data
                $('#article-content').append(data);

                // Images through Kinetic
                $('#article-content').find("img").each(function(){
                  var arattid, arentryid, arschema;
                    arattid = $(this).attr("arattid");
                    ($(this).attr("arschema") && $(this).attr("arschema").length > 0) ? arschema = $(this).attr("arschema") : arschema = articleForm;
                    ($(this).attr("arentryid") && $(this).attr("arentryid").length > 0) ? arentryid = $(this).attr("arentryid") : arentryid = articleRequestId.replace(/(KBA\w+)/,"").replace('|',"");
                    $(this).attr("src", "DownloadAttachment/" + arschema + "/" + arattid + "/" + arentryid);
                });

                // Document attachments through Kinetic
                $('#article-content').find("a[path*='sharedresources']").each(function(){
                  var path = $(this).attr('path').replace(/\?(.*)/,"");
                  var urlParsed = path.split("/");
                  $(this).attr("href", "DownloadAttachment/" + urlParsed[2] + "/" + urlParsed[3] + "/" + urlParsed[4]);
                });

                // Keywords
                var strKeywords = $('#article-content .article .field .value.keywords').text();
                var keywords = strKeywords.replace(/[\n\r]/g,"").split(" ");
                $('#article-content .article .field .value.keywords').empty();
                $.each(keywords, function(index,val){
                  if(val != ""){
                    $('#article-content .article .field .value.keywords').append('<span>'+val+'</span>');
                  }
                });
            }
        });
    });
    
    /*----------------------------------------------------------------------------------------------
     *   This code is executed when the Javascript file is loaded
     *--------------------------------------------------------------------------------------------*/
     
})(jQuery, _);