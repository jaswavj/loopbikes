<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="admin" class="admin.adminBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Admin Dashboard - LoopBikes");
String ctx = request.getContextPath();
Vector stats = admin.getDashboardStats();
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Admin Dashboard</h1></div></div>
<main class="container pb-5">
    <div class="row g-3 mb-4">
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(0) %></h3><p>Total Bikes</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(1) %></h3><p>Available</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(2) %></h3><p>Sold</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3>&#8377;<%= String.format("%,.0f", Double.parseDouble(stats.get(6).toString())) %></h3><p>Total Revenue</p></div></div>
    </div>
    <div class="row g-3 mb-4">
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(3) %></h3><p>Pending Sell Requests</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(4) %></h3><p>Approved Requests</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(5) %></h3><p>Finance Pending</p></div></div>
        <div class="col-md-3"><div class="stat-card"><h3><%= stats.get(7) %></h3><p>Sold This Month</p></div></div>
    </div>
    <div class="row g-3">
        <div class="col-md-4"><a href="<%= ctx %>/admin/upload-bike" class="btn btn-gold w-100 py-3"><i class="fas fa-upload me-2"></i>Upload Bike</a></div>
        <div class="col-md-4"><a href="<%= ctx %>/admin/sell-requests" class="btn btn-navy w-100 py-3"><i class="fas fa-list me-2"></i>Sell Requests</a></div>
        <div class="col-md-4"><a href="<%= ctx %>/admin/bike-report" class="btn btn-navy w-100 py-3"><i class="fas fa-motorcycle me-2"></i>Bike Report</a></div>
        <div class="col-md-4"><a href="<%= ctx %>/admin/finance-enquiry" class="btn btn-navy w-100 py-3"><i class="fas fa-money-bill me-2"></i>Finance Enquiries</a></div>
        <div class="col-md-4"><a href="<%= ctx %>/admin/brand-model" class="btn btn-navy w-100 py-3"><i class="fas fa-tags me-2"></i>Brands & Models</a></div>
        <div class="col-md-4"><a href="<%= ctx %>/admin/users" class="btn btn-navy w-100 py-3"><i class="fas fa-users me-2"></i>Users</a></div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
