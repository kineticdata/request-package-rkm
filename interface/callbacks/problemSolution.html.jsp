<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            ProblemSolution problemSolution = ProblemSolution.findById(otherContext, articleId);
%>
<div>
    <div><%= problemSolution.getTitle()%></div>
    <div><%= problemSolution.getAuthor()%></div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>