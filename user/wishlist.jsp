<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="wish" class="bike.wishlistBean" scope="page"/>
<%
String ctx = request.getContextPath();
Long userId = (Long) session.getAttribute("userId");
if (userId == null) { response.sendRedirect(ctx + "/login"); return; }
request.setAttribute("pageTitle", "My Wishlist - LoopBikes");
Vector list = wish.getWishlist(userId);
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>My Wishlist</h1></div></div>
<main class="container pb-5">
    <% if (list.isEmpty()) { %>
        <div class="text-center py-5"><p class="text-muted">No bikes in wishlist.</p><a href="<%= ctx %>/bikes/browse" class="btn btn-gold">Browse Bikes</a></div>
    <% } else { %>
    <div class="bike-grid">
        <% for (int i = 0; i < list.size(); i++) { Vector b = (Vector) list.get(i);
            String imgUrl = b.get(7) != null ? ctx + "/uploadImages/" + b.get(7) : ctx + "/assets/img/placeholder.svg"; %>
        <div class="bike-card">
            <a href="<%= ctx %>/bikes/detail?id=<%= b.get(0) %>" class="text-decoration-none">
                <div class="bike-card-img"><img src="<%= imgUrl %>" alt="<%= b.get(1) %> <%= b.get(2) %>" loading="lazy"></div>
                <div class="bike-card-body">
                    <h5 class="text-dark"><%= b.get(1) %> <%= b.get(2) %></h5>
                    <div class="bike-price">&#8377;<%= String.format("%,.0f", Double.parseDouble(b.get(4).toString())) %></div>
                </div>
            </a>
            <div class="px-3 pb-3"><a href="<%= ctx %>/ajax/toggleWishlist?bikeId=<%= b.get(0) %>&action=remove" class="btn btn-sm btn-outline-danger w-100">Remove</a></div>
        </div>
        <% } %>
    </div>
    <% } %>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
