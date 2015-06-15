<%-- Include the package initialization file. --%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%-- Include the bundle js config initialization. --%>
<%@include file="../../../../core/interface/fragments/packageJsInitialization.jspf" %>
<%
    RKMResultType resultType = RKMResultType.getByValue( request.getParameter("resultType") );
    Boolean hasQuery = request.getParameter("q") == null ? false : true;
    String query = request.getParameter("q") != null ? request.getParameter("q") : "";
%>
<script type="text/javascript">
    var resultType = "<%=resultType.valueOf()%>";
    var queryParameterExists = <%=hasQuery%>;
    var queryParameter = "<%=query%>";
</script>
<!-- Page Stylesheets -->
<link rel="stylesheet" href="<%= bundle.packagePath()%>assets/css/package.css" type="text/css" />
<!-- Page Javascript -->
<script defer type="text/javascript" src="<%=bundle.packagePath()%>assets/js/package.js"></script>

<%=resultType.equals(RKMResultType.CONTAINER) ? "<section id=\"rkm-section\">" : ""%>
    <%=resultType.equals(RKMResultType.CONTAINER) ? "<div class=\"container\">" : ""%>
        <% if (!resultType.equals(RKMResultType.RESULT)){ %>
	        <div class="rkm-data">
		        <div class="rkm-title">
		            <%=themeLocalizer.getString("Remedy Knowledge Management")%>
		        </div>
		        <div class="rkm-search">
		            <form id="rkm-search-form">
			            <div class="input-group input-group-sm">
			                <input type="text" class="form-control" value="<%=query%>" placeholder="<%=themeLocalizer.getString("Search Remedy Knowledge Management")%>" name="q">
                            <span class="input-group-addon rkm-message hide"></span>
                            <span class="input-group-addon rkm-error hide"></span>
			                <span class="input-group-btn">
			                    <button class="btn btn-primary" type="submit"><i class="fa fa-search"></i></button>
			                </span>
			            </div>
			        </form>
		        </div>
		        <div class="rkm-results"></div>
		    </div>
        <% } else { %>
            <div class="rkm-message"></div>
            <div class="rkm-results"></div>
        <% } %>        
    <%=resultType.equals(RKMResultType.CONTAINER) ? "</div>" : ""%>
<%=resultType.equals(RKMResultType.CONTAINER) ? "</section>" : ""%>



