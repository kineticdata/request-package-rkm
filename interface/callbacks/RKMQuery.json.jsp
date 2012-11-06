<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String mustHave = request.getParameter("mustHave");
            String mayHave = request.getParameter("mayHave");
            String mustNotHave = request.getParameter("mustNotHave");

            MultiFormSearch mfs = new MultiFormSearch(mustHave, mayHave, mustNotHave);

            String jsonData;
            try {
                jsonData = mfs.search(serverUser);
            } catch (Exception e) {
                jsonData = e.toString();
            }

            out.print(jsonData);
            out.flush();
        } catch (Throwable t) {
            out.print(t.toString());
        }
    }
%>