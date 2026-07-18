<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="user" class="user.userBean" scope="page"/>
<%
boolean isSuper = "1".equals(String.valueOf(session.getAttribute("isSuperAdmin")));
if (!isSuper) { response.sendRedirect(request.getContextPath() + "/admin/users?msg=Super+admin+only"); return; }
long userId = Long.parseLong(request.getParameter("userId"));
if ("grant".equals(request.getParameter("action"))) user.grantAdmin(userId);
else user.revokeAdmin(userId);
response.sendRedirect(request.getContextPath() + "/admin/users?msg=Updated");
%>
