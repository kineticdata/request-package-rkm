<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        String articleId = request.getParameter("articleId");
        HowTo howTo = HowTo.findById(serverUser, articleId);
%>
<div class="article howTo">
    <div class="field">
        <div class="label">Question</div>
        <div class="value"><%= howTo.getQuestion() %></div>
    </div>
    <div class="field">
        <div class="label">Answer</div>
        <div class="value"><%= howTo.getAnswer() %></div>
    </div>
    <div class="field">
        <div class="label">Technical Notes</div>
        <div class="value"><%= howTo.getTechnicalNotes() %></div>
    </div>
</div>
<%
   }
%>