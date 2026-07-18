<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<%
request.setAttribute("pageTitle", "LoopBikes - Buy Sell Finance Second Hand Bikes | Nagercoil, Tirunelveli, Tuticorin");
request.setAttribute("pageDesc", "Best second hand bikes in Nagercoil, Tirunelveli, Tuticorin & Kanyakumari. Buy quality pre-owned bikes, sell your bike at best price, easy bike finance available.");
request.setAttribute("pageKeywords", "second hand bike Nagercoil, used bike Tirunelveli, resale bike Tuticorin, bike finance, pre owned scooter, used motorcycle Kanyakumari");
Vector bikes = bike.getBikesList(0, 10, null, null, null, null, null, false);
String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <%@ include file="/assets/common/head.jsp" %>
</head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<main>
    <section class="hero-section">
        <div class="hero-bg" aria-hidden="true"></div>
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 hero-content">
                    <h1 class="hero-title">Your Trusted Platform for <span class="hero-highlight">Second Hand Bikes</span></h1>
                    <p class="hero-subtitle">Buy, Sell or Finance quality pre-owned bikes in Nagercoil, Tirunelveli, Tuticorin &amp; nearby areas</p>
                    <div class="hero-actions">
                        <a href="<%= ctx %>/bikes/browse" class="btn btn-gold btn-lg me-2"><i class="fas fa-shopping-cart me-2"></i>Browse Bikes</a>
                        <a href="<%= ctx %>/sell-bike" class="btn btn-navy btn-lg"><i class="fas fa-tag me-2"></i>Sell Your Bike</a>
                    </div>
                </div>
            </div>
            <div class="feature-cards">
                <a href="<%= ctx %>/bikes/browse" class="feature-card text-decoration-none">
                    <i class="fas fa-shopping-cart"></i>
                    <h5>Buy</h5>
                    <small>Quality verified bikes</small>
                </a>
                <a href="<%= ctx %>/sell-bike" class="feature-card text-decoration-none">
                    <i class="fas fa-hand-holding-usd"></i>
                    <h5>Sell</h5>
                    <small>Best resale value</small>
                </a>
                <a href="<%= ctx %>/finance" class="feature-card text-decoration-none">
                    <i class="fas fa-credit-card"></i>
                    <h5>Finance</h5>
                    <small>Easy EMI options</small>
                </a>
            </div>
        </div>
    </section>

    <section class="container py-5">
        <h2 class="section-title">Latest Bikes for Sale</h2>
        <p class="section-sub">Fresh resale bikes in Nagercoil, Tirunelveli &amp; Tuticorin region</p>
        <% if (bikes.isEmpty()) { %>
            <div class="text-center py-5 text-muted"><i class="fas fa-motorcycle fa-3x mb-3"></i><p>No bikes listed yet. Check back soon!</p></div>
        <% } else { %>
        <div class="bike-grid">
            <% for (int i = 0; i < bikes.size(); i++) {
                Vector b = (Vector) bikes.get(i);
                String imgUrl = b.get(15) != null ? ctx + "/uploadImages/" + b.get(15) : ctx + "/assets/img/no-bike.jpg";
                String slug = b.get(11) != null ? b.get(11).toString() : b.get(0).toString();
            %>
            <a href="<%= ctx %>/bikes/detail?id=<%= b.get(0) %>" class="bike-card text-decoration-none">
                <div class="bike-card-img">
                    <img src="<%= imgUrl %>" alt="<%= b.get(1) %> <%= b.get(2) %> second hand bike" loading="lazy" onerror="this.src='<%= ctx %>/assets/img/placeholder.svg'">
                </div>
                <div class="bike-card-body">
                    <h5 class="mb-1 text-dark"><%= b.get(1) %> <%= b.get(2) %></h5>
                    <div class="bike-price">&#8377;<%= String.format("%,.0f", Double.parseDouble(b.get(8).toString())) %></div>
                    <div class="bike-meta">
                        <span class="badge-lb"><%= b.get(4) %></span>
                        <span class="badge-lb"><%= b.get(5) %> km</span>
                        <span class="badge-lb"><%= b.get(6) %></span>
                    </div>
                </div>
            </a>
            <% } %>
        </div>
        <div class="text-center mt-4">
            <a href="<%= ctx %>/bikes/browse" class="btn btn-gold">View All Bikes <i class="fas fa-arrow-right ms-1"></i></a>
        </div>
        <% } %>
    </section>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
