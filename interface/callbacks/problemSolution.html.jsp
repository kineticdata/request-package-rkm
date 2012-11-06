<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String articleId = request.getParameter("articleId");
            ProblemSolution problemSolution = ProblemSolution.findById(serverUser, articleId);
%>
<div class="article problemSolution">
    <div class="field">
        <div class="label">Title</div>
        <div class="value"><%= problemSolution.getTitle() %></div>
    </div>
    <div class="field">
        <div class="label">Author</div>
        <div class="value"><%= problemSolution.getAuthor() %></div>
    </div>
    <div class="field">
        <div class="label">Problem</div>
        <div class="value"><%= problemSolution.getProblem() %></div>
    </div>
    <div class="field">
        <div class="label">Solution</div>
        <div class="value"><%= problemSolution.getSolution() %></div>
    </div>
    <div class="field">
        <div class="label">Technical Notes</div>
        <div class="value"><%= problemSolution.getTechnicalNotes() %></div>
    </div>
</div>
<%
        } catch (Throwable t) {
            System.out.println(t.toString());
        }
   }
%>