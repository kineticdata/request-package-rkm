<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            Reference reference = Reference.findById(serverUser, articleId);
%>
<div class="article reference">
    <div class="field">
        <div class="label">Title</div>
        <div class="value"><%= reference.getTitle() %></div>
    </div>
    <div class="field">
        <div class="label">Author</div>
        <div class="value"><%= reference.getAuthor() %></div>
    </div>
    <div class="field">
        <div class="label">Reference</div>
        <div class="value"><%= reference.getReference() %></div>
    </div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>