<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="fin" class="finance.financeBean" scope="page"/>
<%
fin.updateEnquiry(
    Integer.parseInt(request.getParameter("id")),
    Integer.parseInt(request.getParameter("status")),
    1, 0
);
response.sendRedirect(request.getContextPath() + "/admin/finance-enquiry?msg=Updated");
%>
