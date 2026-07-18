<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="user" class="user.userBean" scope="page"/>
<%
request.setAttribute("pageTitle", "User Management - LoopBikes Admin");
String ctx = request.getContextPath();
boolean isSuper = "1".equals(String.valueOf(session.getAttribute("isSuperAdmin")));
Vector users = user.getAllUsers(0, 50, null);
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>User Management</h1></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <% if (!isSuper) { %><div class="alert alert-warning">Only super admin can grant/revoke admin roles.</div><% } %>
    <div class="lb-form-card p-0 overflow-hidden">
        <table class="table table-lb mb-0">
            <thead><tr><th>ID</th><th>Phone</th><th>Name</th><th>Email</th><th>Role</th><th>Super Admin</th><th>Joined</th><th>Action</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < users.size(); i++) { Vector u = (Vector) users.get(i); %>
            <tr>
                <td><%= u.get(0) %></td><td><%= u.get(1) %></td><td><%= u.get(2) %></td><td><%= u.get(3) != null ? u.get(3) : "-" %></td>
                <td><%= u.get(4) %></td><td><%= "1".equals(u.get(5).toString()) ? "Yes" : "No" %></td><td><%= u.get(6) %></td>
                <td>
                    <% if (isSuper && !"1".equals(u.get(5).toString())) { %>
                        <% if ("ADMIN".equals(u.get(4))) { %>
                        <a href="<%= ctx %>/admin/updateUser?userId=<%= u.get(0) %>&action=revoke" class="btn btn-sm btn-warning">Revoke Admin</a>
                        <% } else { %>
                        <a href="<%= ctx %>/admin/updateUser?userId=<%= u.get(0) %>&action=grant" class="btn btn-sm btn-gold">Grant Admin</a>
                        <% } %>
                    <% } %>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
