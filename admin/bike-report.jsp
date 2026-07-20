<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Bike Report - LoopBikes Admin");
String ctx = request.getContextPath();
Integer statusFilter = request.getParameter("status") != null && !request.getParameter("status").isEmpty() ? Integer.parseInt(request.getParameter("status")) : null;
Vector bikes = bike.getAllBikesAdmin(statusFilter, 0, 50);
String[] statusLabels = {"Available","Reserved","Sold","Damaged"};
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Bike Inventory Report</h1></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <form class="mb-3 row g-2" method="get">
        <div class="col-auto"><select name="status" class="form-select"><option value="">All</option>
            <% for (int s = 0; s < 4; s++) { %><option value="<%= s %>" <%= statusFilter!=null&&statusFilter==s?"selected":"" %>><%= statusLabels[s] %></option><% } %>
        </select></div>
        <div class="col-auto"><button class="btn btn-gold">Filter</button></div>
    </form>
    <div class="lb-form-card p-0 admin-table-wrap">
        <table class="table table-lb mb-0">
            <thead><tr><th>ID</th><th>Bike</th><th>Reg</th><th>Year</th><th>KM</th><th>Price</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < bikes.size(); i++) { Vector b = (Vector) bikes.get(i); int st = Integer.parseInt(b.get(7).toString()); %>
            <tr>
                <td><%= b.get(0) %></td>
                <td><%= b.get(1) %> <%= b.get(2) %></td>
                <td><%= b.get(3) %></td><td><%= b.get(4) %></td><td><%= b.get(5) %></td>
                <td>&#8377;<%= String.format("%,.0f", Double.parseDouble(b.get(6).toString())) %></td>
                <td><span class="status-chip status-<%= st %>"><%= statusLabels[st] %></span></td>
                <td>
                    <a href="<%= ctx %>/bikes/detail?id=<%= b.get(0) %>" class="btn btn-sm btn-navy">View</a>
                    <% if (st == 0) { %>
                    <a href="<%= ctx %>/admin/updateBikeStatus?id=<%= b.get(0) %>&status=1" class="btn btn-sm btn-warning">Reserve</a>
                    <a href="<%= ctx %>/admin/updateBikeStatus?id=<%= b.get(0) %>&status=2" class="btn btn-sm btn-success">Sold</a>
                    <% } %>
                    <a href="<%= ctx %>/admin/updateBikeStatus?id=<%= b.get(0) %>&status=3" class="btn btn-sm btn-secondary">Damage</a>
                    <a href="<%= ctx %>/admin/updateBikeStatus?id=<%= b.get(0) %>&delete=1" class="btn btn-sm btn-danger" onclick="return confirm('Delete?')">Del</a>
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
