jQuery(document).ready(function() {
    // This object maps the source type returned by the multi query jsp to a
    // camel-case version used in css classes and jsp names.
    var sourceMap = {
        "Decision Tree": "decisionTree",
        "How To": "howTo",
        "Known Error": "knownError",
        "Problem Solution": "problemSolution",
        "Reference": "reference"
    };
    
    // Here we set the focus to the input box that gathers the search terms
    jQuery("form#searchTerms input#mustHave").focus();
    
    // On submit of the search terms form we call the RKMQuery jsp which returns
    // a json result that represents the matching articles.  We use this json
    // result to generate an html table.  Each row in the table has a clicked
    // handler bound to it that retrieves the article (defined below).
    jQuery("form#searchTerms").submit(function() {
        jQuery("#results").empty();
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",
            data: jQuery(this).serialize(),
            success: function(data) {
                var results = jQuery.parseJSON(data);
                for (var i in results) {
                    var resultDiv = jQuery('<div class="result"></div>');
                    resultDiv.data("article-id", results[i]["Article ID"]);
                    resultDiv.data("article-type", sourceMap[results[i]["Source"]]);
                    resultDiv.append('<div class="icon '+ sourceMap[results[i]["Source"]] +
                        '" title="' + results[i]["Source"] + '"></div>');
                    resultDiv.append('<div class="middleCol">' +
                        '<div class="title">' + 
                        '<div class="sprite expand"></div>' +
                        '<div class="sprite contract"></div>' +
                        '<div class="titleText">' + results[i]["Article Title"] + '</div>' +
                        '<div class="clear"></div>' +
                        '</div>' +
                        '<div class="clear"></div>' +
                        '<div class="summary">' + results[i]["Summary"] + '</div></div>');
                    resultDiv.append('<div class="rightCol"><div class="modified"' +
                        'title="' + results[i]["Modified Date"] + '">' +
                        results[i]["Modified Ago"] + ' ago</div></div>');
                    resultDiv.append('<div class="clear"></div>');
                    jQuery(resultDiv).find(".middleCol .title").click(toggleArticle);
                    jQuery("#results").append(resultDiv);
                    
                }
            }
        });
        return false;
    });
});

function toggleArticle() {
    // Retrieve the result dom element that this link refers to.
    var resultDiv = jQuery(this).parents("#results .result");
    
    // Retrieve parameters used in the call from data attributes of the clicked
    // dom element.
    var articleType = resultDiv.data("article-type");
    var articleId = resultDiv.data("article-id");

    // If the article has not been retrieve do an ajax call to retrieve the
    // article partial and append it to the result div, then show it.  Otherwise
    // we simple show the article that is already there.
    if ( resultDiv.find(".article").length === 0 ) {
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/" + articleType + '.html.jsp',
            data: { articleId: articleId },
            success: function(data) {
                resultDiv.find(".middleCol").append(data);
                var articleLinks = jQuery('<div class="links"></div>');
                var commentUrl = BUNDLE.config["commentUrl"] + "&id=" + articleId;
                var commentAnchor = jQuery('<a href="' + commentUrl + '">Comment</a>');
                articleLinks.append(commentAnchor);
                var helpfulAnchor = jQuery('<a href="javascript:void(0);">This Was Helpful</a>');
                helpfulAnchor.click(function() {
                   BUNDLE.ajax({
                       url: BUNDLE.packagePath + 'interface/callbacks/incrementRelevance.jsp',
                       data: {
                           articleId: jQuery(this).parents("#results .result").data("article-id")
                       },
                       success: function(data) {
                           jQuery(helpfulAnchor).hide();
                       }
                   }) 
                });
                articleLinks.append(helpfulAnchor);
                resultDiv.find(".article").append(articleLinks);
                resultDiv.find(".article").slideToggle();
                resultDiv.find(".title .sprite").toggle();
            }
        });
    } else {
        resultDiv.find(".article").slideToggle();
        resultDiv.find(".title .sprite").toggle();
    }
}