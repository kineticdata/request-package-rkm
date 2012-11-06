jQuery(document).ready(function() {
    // Here we set the focus to the input box that gathers the search terms
    jQuery("form#searchTerms input#mustHave").focus();
    
    // On submit of the search terms form we call the RKMQuery jsp which returns
    // a json result that represents the matching articles.  We use this json
    // result to generate an html table.  Each row in the table has a clicked
    // handler bound to it that retrieves the article (defined below).
    jQuery("form#searchTerms").submit(function() {
        jQuery("table#results tbody").empty();
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",
            data: jQuery(this).serialize(),
            success: function(data) {
                var results = jQuery.parseJSON(data);
                for (var i in results) {
                    var row = jQuery("<tr>");
                    row.addClass((i % 2 === 1) ? "odd" : "even");
                    row.data("article-id", results[i]["Article ID"]);
                    row.data("article-type", results[i]["Source"]);
                    row.append("<td>" + results[i]["Article Title"] + "</td>");
                    row.append("<td>" + results[i]["Source"] + "</td>");
                    row.append("<td>" + results[i]["Summary"] + "</td>");
                    jQuery("table#results tbody").append(row);
                    row.click(rowClickHandler);
                    jQuery("table#results").show();
                }
            }
        });
        return false;
    });
});

// The loaded array stores the table row dom elements that have been clicked and
// whose articles have already been successfully loaded.  This is used to ensure
// that the article jsp is only retrieved once.
var loaded = [];
function rowClickHandler() {
    // This object maps the source type to the proper jsp to be called.
    var jspMap = {
        "Decision Tree": "decisionTree.html.jsp",
        "How To": "howTo.html.jsp",
        "Known Error": "knownError.html.jsp",
        "Problem Solution": "problemSolution.html.jsp",
        "Reference": "reference.html.jsp"
    };

    // Retrieve parameters used in the call from data attributes of the clicked
    // dom element.
    var articleType = jQuery(this).data("article-type");
    var articleId = jQuery(this).data("article-id");

    // If the loaded array contains the clicked dom element already, its article
    // has already been loaded.  If the article has not been loaded we make an
    // ajax call to the proper jsp and add a now row to the table just below the
    // one clicked and the clicked row is added to the loaded object.  Otherwise
    // we simple call the slide toggle function to hide and show the article.
    if (jQuery.inArray(this, loaded) === -1) {
        var clickedRow = this;
        BUNDLE.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/" + jspMap[articleType],
            data: { articleId: articleId },
            success: function(data) {
                var articleRow = jQuery('<tr class="articleRow"></tr>');
                var articleCell = jQuery('<td colspan="3"></td>');
                var zebra = (jQuery(clickedRow).hasClass("odd")) ? "odd" : "even";
                var articleContainer = jQuery('<div class="hidden articleContainer ' + zebra +'">' + data + '</div>');
                jQuery(clickedRow).after(articleRow.append(articleCell.append(articleContainer)));
                articleContainer.slideDown();
                loaded.push(clickedRow);
            }
        });
    } else {
        jQuery(this).next("tr.articleRow").find("td .articleContainer").slideToggle();
    }
}