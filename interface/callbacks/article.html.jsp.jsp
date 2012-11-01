<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        try {
            String mustHaveTerms = request.getParameter("mustHave");
            String mayHaveTerms = request.getParameter("mayHave");
            String mustNotHaveTerms = request.getParameter("mustNotHave");

            // Instantiate the mfs object
            MultiFormSearch mfs = new MultiFormSearch();

            if (mustHaveTerms != null) {
                mfs.setMustHave(mustHaveTerms);
            }
            if (mayHaveTerms != null) {
                mfs.setMayHave(mayHaveTerms);
            }
            if (mustNotHaveTerms != null) {
                mfs.setMustNotHave(mustNotHaveTerms);
            }

            String jsonData;
            try {
                jsonData = mfs.search();
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