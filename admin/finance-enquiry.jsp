<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="fin" class="finance.financeBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Finance Enquiries - LoopBikes Admin");
String ctx = request.getContextPath();
Integer statusFilter = request.getParameter("status") != null && !request.getParameter("status").isEmpty() ? Integer.parseInt(request.getParameter("status")) : null;
String search = request.getParameter("search");
Vector list = fin.getAllEnquiries(statusFilter, search, 0, 50);
String[] statusLabels = {"Pending","Active","Taken","Closed"};
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Finance Enquiries</h1></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <form class="mb-3 row g-2" method="get">
        <div class="col-auto"><input type="text" name="search" class="form-control" placeholder="Search..." value="<%= search != null ? search : "" %>"></div>
        <div class="col-auto"><select name="status" class="form-select"><option value="">All</option>
            <% for (int s = 0; s < 4; s++) { %><option value="<%= s %>" <%= statusFilter!=null&&statusFilter==s?"selected":"" %>><%= statusLabels[s] %></option><% } %>
        </select></div>
        <div class="col-auto"><button class="btn btn-gold">Search</button></div>
    </form>
    <div class="lb-form-card p-0 overflow-hidden">
        <table class="table table-lb mb-0">
            <thead><tr><th>ID</th><th>Name</th><th>Phone</th><th>Bike</th><th>Reg</th><th>Amount</th><th>Status</th><th>Update</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < list.size(); i++) { Vector r = (Vector) list.get(i); int st = Integer.parseInt(r.get(8).toString()); %>
            <tr>
                <td><%= r.get(0) %></td><td><%= r.get(1) %></td><td><%= r.get(2) %></td>
                <td><%= r.get(3) %> <%= r.get(4) %></td><td><%= r.get(5) %></td>
                <td>&#8377;<%= String.format("%,.0f", Double.parseDouble(r.get(7).toString())) %></td>
                <td><span class="status-chip status-<%= st %>"><%= statusLabels[st] %></span></td>
                <td>
                    <form action="<%= ctx %>/admin/updateFinance" method="post" class="d-flex gap-1">
                        <input type="hidden" name="id" value="<%= r.get(0) %>">
                        <select name="status" class="form-select form-select-sm" style="width:auto">
                            <% for (int s = 0; s < 4; s++) { %><option value="<%= s %>" <%= st==s?"selected":"" %>><%= statusLabels[s] %></option><% } %>
                        </select>
                        <button class="btn btn-sm btn-gold">Save</button>
                    </form>
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
