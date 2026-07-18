<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<%
String ctx = request.getContextPath();
long id = Long.parseLong(request.getParameter("id"));
if ("1".equals(request.getParameter("delete"))) {
    bike.deleteBike(id);
} else {
    int status = Integer.parseInt(request.getParameter("status"));
    bike.updateBikeStatus(id, status, null, null, null);
}
response.sendRedirect(ctx + "/admin/bike-report?msg=Updated");
%>
