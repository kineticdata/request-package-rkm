<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            HowTo howTo = HowTo.findById(serverUser, articleId);
%>
<div>
    <div><%= howTo.getTitle()%></div>
    <div><%= howTo.getAuthor()%></div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>