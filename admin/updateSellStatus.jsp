<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="sell" class="bike.sellRequestBean" scope="page"/>
<%
String ctx = request.getContextPath();
Long adminId = (Long) session.getAttribute("userId");
sell.updateStatus(
    Long.parseLong(request.getParameter("requestId")),
    Integer.parseInt(request.getParameter("status")),
    adminId,
    request.getParameter("adminNotes"),
    request.getParameter("rejectionReason"),
    null,
    0
);
response.sendRedirect(ctx + "/admin/sell-requests?msg=Status+updated");
%>
