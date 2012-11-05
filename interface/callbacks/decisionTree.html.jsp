<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            DecisionTree decisionTree = DecisionTree.findById(serverUser, articleId);
%>
<div>
    <div><%= decisionTree.getTitle()%></div>
    <div><%= decisionTree.getAuthor()%></div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>