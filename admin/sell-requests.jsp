<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="sell" class="bike.sellRequestBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Sell Requests - LoopBikes Admin");
String ctx = request.getContextPath();
Integer statusFilter = request.getParameter("status") != null && !request.getParameter("status").isEmpty() ? Integer.parseInt(request.getParameter("status")) : null;
Vector requests = sell.getAllRequests(statusFilter, 0, 50);
String[] statusLabels = {"Pending","Under Review","Approved","Rejected","Contacted"};
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Sell Requests</h1><a href="<%= ctx %>/admin/dashboard" class="text-white small">Back to Dashboard</a></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <form class="mb-3 row g-2" method="get">
        <div class="col-auto"><select name="status" class="form-select"><option value="">All Status</option>
            <% for (int s = 0; s < 5; s++) { %><option value="<%= s %>" <%= statusFilter != null && statusFilter == s ? "selected" : "" %>><%= statusLabels[s] %></option><% } %>
        </select></div>
        <div class="col-auto"><button class="btn btn-gold">Filter</button></div>
    </form>
    <div class="lb-form-card p-0 overflow-hidden">
        <table class="table table-lb mb-0">
            <thead><tr><th>ID</th><th>Name</th><th>Phone</th><th>Bike</th><th>Reg</th><th>Price</th><th>Status</th><th>Action</th></tr></thead>
            <tbody>
            <% for (int i = 0; i < requests.size(); i++) { Vector r = (Vector) requests.get(i); int st = Integer.parseInt(r.get(7).toString()); %>
            <tr>
                <td><%= r.get(0) %></td><td><%= r.get(1) %></td><td><%= r.get(2) %></td>
                <td><%= r.get(3) %> <%= r.get(4) %></td><td><%= r.get(5) %></td>
                <td>&#8377;<%= String.format("%,.0f", Double.parseDouble(r.get(6).toString())) %></td>
                <td><span class="status-chip status-<%= st %>"><%= statusLabels[st] %></span></td>
                <td>
                    <form action="<%= ctx %>/admin/updateSellStatus" method="post" class="d-inline">
                        <input type="hidden" name="requestId" value="<%= r.get(0) %>">
                        <select name="status" class="form-select form-select-sm d-inline-block" style="width:auto">
                            <% for (int s = 0; s < 5; s++) { %><option value="<%= s %>" <%= st==s?"selected":"" %>><%= statusLabels[s] %></option><% } %>
                        </select>
                        <button class="btn btn-sm btn-gold">Update</button>
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
