<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="sell" class="bike.sellRequestBean" scope="page"/>
<%
String ctx = request.getContextPath();
Long userId = (Long) session.getAttribute("userId");
if (userId == null) { response.sendRedirect(ctx + "/login"); return; }
request.setAttribute("pageTitle", "My Sell Requests - LoopBikes");
Vector requests = sell.getMyRequests(userId, 0, 20);
String msg = request.getParameter("msg");
String[] statusLabels = {"Pending","Under Review","Approved","Rejected","Contacted"};
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>My Sell Requests</h1></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <a href="<%= ctx %>/sell-bike" class="btn btn-gold mb-3"><i class="fas fa-plus me-1"></i> New Sell Request</a>
    <div class="lb-form-card p-0 overflow-hidden">
        <table class="table table-lb mb-0">
            <thead><tr><th>Brand</th><th>Model</th><th>Reg No</th><th>Year</th><th>Price</th><th>Status</th><th>Date</th></tr></thead>
            <tbody>
            <% if (requests.isEmpty()) { %><tr><td colspan="7" class="text-center py-4 text-muted">No sell requests yet</td></tr>
            <% } else { for (int i = 0; i < requests.size(); i++) { Vector r = (Vector) requests.get(i); int st = Integer.parseInt(r.get(6).toString()); %>
            <tr>
                <td><%= r.get(1) %></td><td><%= r.get(2) %></td><td><%= r.get(3) %></td><td><%= r.get(4) %></td>
                <td>&#8377;<%= String.format("%,.0f", Double.parseDouble(r.get(5).toString())) %></td>
                <td><span class="status-chip status-<%= st %>"><%= statusLabels[st] %></span></td>
                <td><%= r.get(7) %></td>
            </tr>
            <% } } %>
            </tbody>
        </table>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
