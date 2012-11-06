<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title><%= bundle.getProperty("companyName") + " " + bundle.getProperty("catalogName")%></title>

        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/headContent.jspf"%>

        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/rkm.css" type="text/css" />

        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/rkm.js"></script>
    </head>

    <body>
        <div id="bodyContainer">
            <%@include file="../../common/interface/fragments/contentHeader.jspf"%>
            <div id="contentBody">
                        <div class="title">Remedy Knowledge Management</div>
                        <div class="search">
                            <form id="searchTerms">
                                <input type="search" name="mustHave" id="mustHave" value="" />
                                <input type="submit" id="searchButton" value="Search" />
                            </form>
                        </div>
                        <div class="clear"></div>
                        <table id="results">
                        <thead>
                            <tr>
                                <th>Article</th>
                                <th>Summary</th>
                                <th>Source</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
            </div>
            <%@include file="../../common/interface/fragments/contentFooter.jspf"%>
        </div>
    </body>
</html> 