<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            Reference reference = Reference.findById(otherContext, articleId);
%>
<div>
    <div><%= reference.getTitle()%></div>
    <div><%= reference.getAuthor()%></div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>