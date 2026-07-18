<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="user" class="user.userBean" scope="page"/>
<%
if (!isSuper) {
    response.sendRedirect(request.getContextPath() + "/admin/users?msg=Super+admin+only");
    return;
}

String ctx = request.getContextPath();
long targetUserId = Long.parseLong(request.getParameter("userId"));
String action = request.getParameter("action");
String tab = request.getParameter("tab") != null ? request.getParameter("tab") : "normal";
String role = request.getParameter("role") != null ? request.getParameter("role") : "";
String search = request.getParameter("search") != null ? request.getParameter("search") : "";

if (userId != null && userId.longValue() == targetUserId
        && ("revoke".equals(action) || "revokeSuper".equals(action))) {
    response.sendRedirect(ctx + "/admin/users?tab=" + tab + "&msg=Cannot+change+your+own+account");
    return;
}

String result = "SUCCESS";
if ("grant".equals(action)) result = user.grantAdmin(targetUserId);
else if ("revoke".equals(action)) result = user.revokeAdmin(targetUserId);
else if ("makeSuper".equals(action)) result = user.grantSuperAdmin(targetUserId);
else if ("revokeSuper".equals(action)) result = user.revokeSuperAdmin(targetUserId);
else result = "ERROR: Invalid action";

String msg = result.startsWith("SUCCESS") ? "User+updated+successfully" : java.net.URLEncoder.encode(result, "UTF-8");
String redirect = ctx + "/admin/users?tab=" + tab;
if (!role.isEmpty()) redirect += "&role=" + java.net.URLEncoder.encode(role, "UTF-8");
if (!search.isEmpty()) redirect += "&search=" + java.net.URLEncoder.encode(search, "UTF-8");
redirect += "&msg=" + msg;
response.sendRedirect(redirect);
%>
