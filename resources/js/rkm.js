jQuery(document).ready(function() {
    $("#searchButton").click(function() {
        $.ajax(BUNDLE.packagePath + "interface/callbacks/RKMQuery.json.jsp",{
            data: {
                mustHave: $("#mustHave").val(),
                mayHave: $("#mayHave").val(),
                mustNotHave: $("#mustNotHave").val()
            },
            success: function(data) {
                var results = $.parseJSON(data);
                console.log(results);
                for (var i in results) {
                    var row = $("<tr>");
                    var article = $("<td>");
                    var anchor = $("<a>");
                    anchor.attr("href", results[i]["Article URL"]);
                    anchor.text(results[i]["Article Title"]);
                    article.append(anchor);
                    row.append(article);
                    row.append("<td>" + results[i]["Summary"] + "</td>");
                    row.append("<td>" + results[i]["Source"] + "</td>");
                    row.append("<td>" + results[i]["Modified Date"] + "</td>");
                    $("#results").append(row);
                               
                }
            }
        });
    });
});