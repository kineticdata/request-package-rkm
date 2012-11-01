jQuery(document).ready(function() {
    jQuery("#searchTerms").submit(function() {
        jQuery("#results tbody").empty();
        jQuery.ajax({
            url: BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",
            data: jQuery(this).serialize(),
            success: function(data) {
                var results = jQuery.parseJSON(data);
                for (var i in results) {
                    var row = jQuery("<tr>");
                    var article = jQuery("<td>");
                    var anchor = jQuery("<a>");
                    anchor.attr("href", results[i]["Article URL"]);
                    anchor.text(results[i]["Article Title"]);
                    article.append(anchor);
                    row.append(article);
                    row.append("<td>" + results[i]["Summary"] + "</td>");
                    row.append("<td>" + results[i]["Source"] + "</td>");
                    row.append("<td>" + results[i]["Modified Date"] + "</td>");
                    jQuery("#results").append(row);    
                }
            }
        });
        return false; // This will cancel the default form submit action.
    });
});