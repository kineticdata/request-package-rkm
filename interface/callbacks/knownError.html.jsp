<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            KnownError knownError = KnownError.findById(serverUser, articleId);
%>
<div>
    <div><%= knownError.getTitle()%></div>
    <div><%= knownError.getAuthor()%></div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>