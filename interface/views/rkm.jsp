<%-- Include the package initialization file. --%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc)
    catalog.preload(context);
%>
<%-- Include the bundle js config initialization. --%>
<%@include file="../../../../core/interface/fragments/packageJsInitialization.jspf" %>
<!-- Page Stylesheets -->
<link rel="stylesheet" href="<%= bundle.packagePath()%>assets/css/rkm.css" type="text/css" />
<!-- Page Javascript -->
<script type="text/javascript" src="<%=bundle.packagePath()%>assets/js/rkm.js"></script>

<section id="service-section">
    <div class="container">
        <div id="title" class="col-xs-12">
            <h2 class="color-primary">Remedy Knowledge Management</h2>
        </div>
        <div id="search" class="col-xs-12">
            <form id="searchTerms" class="rkm-search">
                <label class="hide" for="mustHave"></label>
	            <input class="form-control" type="text" name="mustHave" id="mustHave" value="" autofocus="autofocus" />
	            <span>
                    <button class="btn btn-primary fa fa-search" type="submit" id="searchButton"></button>
                </span>
            </form>
        </div>
        <div id="messages" class="col-xs-12">
        </div>
        <div id="results" class="col-xs-12">
        </div>
    </div>
</section>
