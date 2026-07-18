<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="user" class="user.userBean" scope="page"/>
<%
String ctx = request.getContextPath();
String phone = request.getParameter("phone");
String password = request.getParameter("password");
String name = request.getParameter("name");

if (phone == null || password == null) { response.sendRedirect(ctx + "/login?msg=Invalid+request"); return; }

Vector existing = user.getUserByPhone(phone);
if (existing.isEmpty()) {
    if (name == null || name.trim().isEmpty()) {
        response.sendRedirect(ctx + "/login?msg=Name+required+for+registration");
        return;
    }
    String result = user.register(phone, password, name.trim());
    if (!result.startsWith("SUCCESS")) {
        response.sendRedirect(ctx + "/login?msg=" + java.net.URLEncoder.encode(result, "UTF-8"));
        return;
    }
    existing = user.getUserByPhone(phone);
}

if (!user.login(phone, password)) {
    response.sendRedirect(ctx + "/login?msg=Invalid+phone+or+password");
    return;
}

session.setAttribute("userId", Long.parseLong(existing.get(0).toString()));
session.setAttribute("userName", existing.get(3).toString());
session.setAttribute("userRole", existing.get(5).toString());
session.setAttribute("isSuperAdmin", existing.get(6).toString());
response.sendRedirect(ctx + "/");
%>
