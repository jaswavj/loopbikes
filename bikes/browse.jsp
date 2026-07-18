<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<jsp:useBean id="brand" class="bike.brandBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Buy Second Hand Bikes - Nagercoil, Tirunelveli, Tuticorin | LoopBikes");
request.setAttribute("pageDesc", "Browse quality used bikes for sale in Nagercoil, Tirunelveli, Tuticorin. Honda, Hero, TVS, Royal Enfield and more at best prices.");
String ctx = request.getContextPath();
String search = request.getParameter("search");
Integer brandId = request.getParameter("brandId") != null && !request.getParameter("brandId").isEmpty() ? Integer.parseInt(request.getParameter("brandId")) : null;
int pageNum = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 0;
Vector bikes = bike.getBikesList(pageNum, 12, search, brandId, null, null, null, false);
Vector brands = brand.getActiveBrands();
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Buy Second Hand Bikes</h1><p>Quality pre-owned bikes in Nagercoil, Tirunelveli, Tuticorin &amp; Kanyakumari</p></div></div>
<main class="container pb-5">
    <div class="row mb-4">
        <div class="col-md-8">
            <form class="row g-2" method="get">
                <div class="col-md-5"><input type="text" name="search" class="form-control" placeholder="Search brand, model..." value="<%= search != null ? search : "" %>"></div>
                <div class="col-md-4">
                    <select name="brandId" class="form-select">
                        <option value="">All Brands</option>
                        <% for (int i = 0; i < brands.size(); i++) { Vector br = (Vector) brands.get(i); %>
                        <option value="<%= br.get(0) %>" <%= brandId != null && brandId == Integer.parseInt(br.get(0).toString()) ? "selected" : "" %>><%= br.get(1) %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3"><button type="submit" class="btn btn-gold w-100"><i class="fas fa-search me-1"></i> Search</button></div>
            </form>
        </div>
    </div>
    <% if (bikes.isEmpty()) { %>
        <div class="text-center py-5"><p class="text-muted">No bikes found. Try different search.</p></div>
    <% } else { %>
    <div class="bike-grid">
        <% for (int i = 0; i < bikes.size(); i++) {
            Vector b = (Vector) bikes.get(i);
            String imgUrl = b.get(15) != null ? ctx + "/uploadImages/" + b.get(15) : ctx + "/assets/img/placeholder.svg";
        %>
        <a href="<%= ctx %>/bikes/detail?id=<%= b.get(0) %>" class="bike-card text-decoration-none">
            <div class="bike-card-img"><img src="<%= imgUrl %>" alt="<%= b.get(1) %> <%= b.get(2) %> used bike <%= b.get(4) %>" loading="lazy" onerror="this.src='<%= ctx %>/assets/img/placeholder.svg'"></div>
            <div class="bike-card-body">
                <h5 class="text-dark"><%= b.get(1) %> <%= b.get(2) %></h5>
                <div class="bike-price">&#8377;<%= String.format("%,.0f", Double.parseDouble(b.get(8).toString())) %></div>
                <div class="bike-meta">
                    <span class="badge-lb"><%= b.get(4) %></span>
                    <span class="badge-lb"><%= b.get(5) %> km</span>
                    <span class="badge-lb"><%= b.get(7) %></span>
                </div>
            </div>
        </a>
        <% } %>
    </div>
    <div class="d-flex justify-content-center gap-2 mt-4">
        <% if (pageNum > 0) { %><a href="?page=<%= pageNum-1 %>&search=<%= search != null ? search : "" %>&brandId=<%= brandId != null ? brandId : "" %>" class="btn btn-navy">Previous</a><% } %>
        <a href="?page=<%= pageNum+1 %>&search=<%= search != null ? search : "" %>&brandId=<%= brandId != null ? brandId : "" %>" class="btn btn-gold">Next</a>
    </div>
    <% } %>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
