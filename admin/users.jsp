<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="user" class="user.userBean" scope="page"/>
<%
request.setAttribute("pageTitle", "User Management - LoopBikes Admin");
String ctx = request.getContextPath();

String tab = request.getParameter("tab");
if (tab == null || tab.isEmpty()) tab = "normal";
boolean superTab = "super".equals(tab);

String roleFilter = request.getParameter("role");
if (roleFilter == null) roleFilter = "";
String search = request.getParameter("search");
if (search == null) search = "";

int pageNum = 0;
try { if (request.getParameter("page") != null) pageNum = Integer.parseInt(request.getParameter("page")); } catch (Exception e) {}

Vector users = user.getAllUsers(pageNum, 100, roleFilter, search, superTab);
int normalCount = user.getUserCount(roleFilter, search, false);
int superCount = user.getUserCount(roleFilter, search, true);
String msg = request.getParameter("msg");

String baseQuery = "tab=" + tab;
if (!roleFilter.isEmpty()) baseQuery += "&role=" + java.net.URLEncoder.encode(roleFilter, "UTF-8");
if (!search.isEmpty()) baseQuery += "&search=" + java.net.URLEncoder.encode(search, "UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar">
    <div class="container d-flex justify-content-between align-items-center flex-wrap gap-2">
        <div>
            <h1>User Management</h1>
            <p class="mb-0">Manage users, admins and super admins</p>
        </div>
        <a href="<%= ctx %>/admin/dashboard" class="btn btn-gold btn-sm"><i class="fas fa-arrow-left me-1"></i> Dashboard</a>
    </div>
</div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg.replace("+", " ") %></div><% } %>
    <% if (!isSuper) { %>
        <div class="alert alert-warning">Only super admin can manage users.</div>
    <% } else { %>

    <div class="lb-form-card mb-4">
        <form method="get" class="row g-2 align-items-end">
            <input type="hidden" name="tab" value="<%= tab %>">
            <div class="col-md-4">
                <label class="form-label">Search</label>
                <input type="text" name="search" class="form-control" placeholder="Phone, name or email" value="<%= search %>">
            </div>
            <div class="col-md-3">
                <label class="form-label">Role</label>
                <select name="role" class="form-select">
                    <option value="">All Roles</option>
                    <option value="USER" <%= "USER".equals(roleFilter) ? "selected" : "" %>>USER</option>
                    <option value="ADMIN" <%= "ADMIN".equals(roleFilter) ? "selected" : "" %>>ADMIN</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-gold w-100"><i class="fas fa-search me-1"></i> Filter</button>
            </div>
            <div class="col-md-2">
                <a href="<%= ctx %>/admin/users?tab=<%= tab %>" class="btn btn-navy w-100">Clear</a>
            </div>
        </form>
    </div>

    <ul class="nav nav-tabs mb-3" role="tablist">
        <li class="nav-item">
            <a class="nav-link <%= !superTab ? "active" : "" %>" href="<%= ctx %>/admin/users?tab=normal<%= !roleFilter.isEmpty() ? "&role="+roleFilter : "" %><%= !search.isEmpty() ? "&search="+java.net.URLEncoder.encode(search,"UTF-8") : "" %>">
                <i class="fas fa-users me-1"></i> Normal Users <span class="badge bg-secondary"><%= normalCount %></span>
            </a>
        </li>
        <li class="nav-item">
            <a class="nav-link <%= superTab ? "active" : "" %>" href="<%= ctx %>/admin/users?tab=super<%= !roleFilter.isEmpty() ? "&role="+roleFilter : "" %><%= !search.isEmpty() ? "&search="+java.net.URLEncoder.encode(search,"UTF-8") : "" %>">
                <i class="fas fa-user-shield me-1"></i> Super Admins <span class="badge bg-warning text-dark"><%= superCount %></span>
            </a>
        </li>
    </ul>

    <div class="lb-form-card p-0 admin-table-wrap">
        <table class="table table-lb mb-0">
            <thead>
                <tr>
                    <th>ID</th><th>Phone</th><th>Name</th><th>Email</th><th>Role</th><th>Joined</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <% if (users.isEmpty()) { %>
                <tr><td colspan="7" class="text-center py-4 text-muted">No users found</td></tr>
            <% } else {
                for (int i = 0; i < users.size(); i++) {
                    Vector u = (Vector) users.get(i);
                    long uid = Long.parseLong(u.get(0).toString());
                    boolean isSelf = userId != null && userId.longValue() == uid;
                    String actionBase = ctx + "/admin/updateUser?userId=" + uid + "&tab=" + tab;
                    if (!roleFilter.isEmpty()) actionBase += "&role=" + roleFilter;
                    if (!search.isEmpty()) actionBase += "&search=" + java.net.URLEncoder.encode(search, "UTF-8");
            %>
            <tr>
                <td><%= u.get(0) %></td>
                <td><%= u.get(1) %></td>
                <td><%= u.get(2) %><% if (isSelf) { %> <span class="badge-lb">You</span><% } %></td>
                <td><%= u.get(3) != null && !u.get(3).toString().isEmpty() ? u.get(3) : "-" %></td>
                <td><span class="status-chip status-<%= "ADMIN".equals(u.get(4)) ? "2" : "0" %>"><%= u.get(4) %></span></td>
                <td><%= u.get(6) %></td>
                <td class="text-nowrap">
                    <% if (superTab) { %>
                        <% if (!isSelf) { %>
                        <a href="<%= actionBase %>&action=revokeSuper" class="btn btn-sm btn-warning" onclick="return confirm('Remove super admin access?')">
                            <i class="fas fa-user-minus me-1"></i>Revoke Super Admin
                        </a>
                        <% } else { %>
                        <span class="text-muted small">Current account</span>
                        <% } %>
                    <% } else { %>
                        <% if (!isSelf) { %>
                            <% if ("ADMIN".equals(u.get(4))) { %>
                            <a href="<%= actionBase %>&action=revoke" class="btn btn-sm btn-outline-secondary me-1" onclick="return confirm('Revoke admin role?')">Revoke Admin</a>
                            <% } else { %>
                            <a href="<%= actionBase %>&action=grant" class="btn btn-sm btn-navy me-1">Grant Admin</a>
                            <% } %>
                            <a href="<%= actionBase %>&action=makeSuper" class="btn btn-sm btn-gold" onclick="return confirm('Make this user super admin?')">
                                <i class="fas fa-crown me-1"></i>Make Super Admin
                            </a>
                        <% } else { %>
                        <span class="text-muted small">Current account</span>
                        <% } %>
                    <% } %>
                </td>
            </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
    <% } %>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
