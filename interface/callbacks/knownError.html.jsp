<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        String articleId = request.getParameter("articleId");
        KnownError knownError = KnownError.findById(serverUser, articleId);
%>
<div class="article knownError">
    <div class="field">
        <div class="label">Title</div>
        <div class="value"><%= knownError.getTitle() %></div>
    </div>
    <div class="field">
        <div class="label">Author</div>
        <div class="value"><%= knownError.getAuthor() %></div>
    </div>
    <div class="field">
        <div class="label">Error</div>
        <div class="value"><%= knownError.getError() %></div>
    </div>
    <div class="field">
        <div class="label">Root Cause</div>
        <div class="value"><%= knownError.getRootCause() %></div>
    </div>
    <div class="field">
        <div class="label">Work Around/Fix</div>
        <div class="value"><%= knownError.getWorkAroundFix() %></div>
    </div>
    <div class="field">
        <div class="label">Technical Notes</div>
        <div class="value"><%= knownError.getTechnicalNotes() %></div>
    </div>
</div>
<%
   }
%>