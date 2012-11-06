jQuery(document).ready(function() {
    jQuery("form#searchTerms input#mustHave").focus();
    jQuery("form#searchTerms").submit(function() {
        jQuery("table#results tbody").empty();
        jQuery.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",
            data: jQuery(this).serialize(),
            success: function(data) {
                var results = jQuery.parseJSON(data);
                for (var i in results) {
                    var row = jQuery("<tr>");
                    var zebra;
                    if (i % 2 === 1) {
                        zebra = "odd";
                    } else {
                        zebra = "even";
                    }
                    row.addClass(zebra);
                    row.data("article-id", results[i]["Article ID"]);
                    row.data("article-type", results[i]["Source"]);
                    row.append("<td>" + results[i]["Article Title"] + "</td>");
                    row.append("<td>" + results[i]["Summary"] + "</td>");
                    row.append("<td>" + results[i]["Source"] + "</td>");
                    row.hover(function() {
                        jQuery(this).addClass("highlight");
                    }, function() {
                        jQuery(this).removeClass("highlight");
                    });
                    jQuery("table#results tbody").append(row);
                    row.click(rowClickHandler);


                    jQuery("table#results").show();
                }
            }
        });
        return false; // This will cancel the default form submit action.
    });
});

var loaded = [];

function rowClickHandler() {
    var articleType = jQuery(this).data("article-type");
    var articleId = jQuery(this).data("article-id");

    if (jQuery.inArray(this, loaded) === -1) {
        var jspMap = {
            "Decision Tree": "decisionTree.html.jsp",
            "How To": "howTo.html.jsp",
            "Known Error": "knownError.html.jsp",
            "Problem Solution": "problemSolution.html.jsp",
            "Reference": "reference.html.jsp"
        };
    
        var clickedRow = this;
        jQuery.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/" + jspMap[articleType],
            data: { articleId: articleId },
            success: function(data) {
                var articleRow = jQuery("<tr></tr>");
                articleRow.addClass("articleRow");
                if (jQuery(clickedRow).hasClass("odd"))
                    articleRow.addClass("odd");
                if (jQuery(clickedRow).hasClass("even"))
                    articleRow.addClass("even");
                var articleCell = jQuery("<td></td>");
                articleCell.attr("colspan", "4");
                var articleContainer = jQuery("<div></div>");
                articleContainer.addClass("articleContainer");
                articleContainer.html(data);
                articleCell.append(articleContainer);
                articleRow.append(articleCell);
                jQuery(clickedRow).after(articleRow);
                articleContainer.slideDown();
                loaded.push(clickedRow);
            }
        });
    } else {
        jQuery(this).next("tr.articleRow").find("td .articleContainer").slideToggle();
    }
}