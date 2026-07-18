<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<jsp:useBean id="wish" class="bike.wishlistBean" scope="page"/>
<jsp:useBean id="fin" class="finance.financeBean" scope="page"/>
<%
String ctx = request.getContextPath();
String idParam = request.getParameter("id");
String slugParam = request.getParameter("slug");
Vector b = new Vector();
if (slugParam != null && !slugParam.isEmpty()) b = bike.getBikeBySlug(slugParam);
else if (idParam != null) b = bike.getBikeById(Long.parseLong(idParam));
if (b.isEmpty()) { response.sendRedirect(ctx + "/bikes/browse"); return; }

Long userId = (Long) session.getAttribute("userId");
boolean inWishlist = userId != null && wish.isInWishlist(userId, Long.parseLong(b.get(0).toString()));
Vector images = bike.getBikeImages(Long.parseLong(b.get(0).toString()));
String phone = fin.getContactPhone();
String title = b.get(1) + " " + b.get(2) + " " + b.get(4) + " - Second Hand Bike for Sale";
request.setAttribute("pageTitle", title + " | LoopBikes Nagercoil");
request.setAttribute("pageDesc", "Buy " + b.get(1) + " " + b.get(2) + " (" + b.get(4) + ") second hand bike at Rs." + b.get(8) + " in Nagercoil, Tirunelveli, Tuticorin. " + b.get(5) + " km, " + b.get(6) + " fuel.");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<main class="container py-4">
    <nav aria-label="breadcrumb"><ol class="breadcrumb"><li class="breadcrumb-item"><a href="<%= ctx %>/bikes/browse">Bikes</a></li><li class="breadcrumb-item active"><%= b.get(1) %> <%= b.get(2) %></li></ol></nav>
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="lb-form-card p-0 overflow-hidden">
                <% if (!images.isEmpty()) {
                    Vector img0 = (Vector) images.get(0);
                    String mainImg = ctx + "/uploadImages/" + img0.get(1);
                %>
                <img src="<%= mainImg %>" class="w-100" style="max-height:450px;object-fit:cover" alt="<%= b.get(1) %> <%= b.get(2) %> resale bike" onerror="this.src='<%= ctx %>/assets/img/placeholder.svg'">
                <% if (images.size() > 1) { %>
                <div class="d-flex gap-2 p-3 flex-wrap">
                    <% for (int i = 0; i < images.size(); i++) { Vector im = (Vector) images.get(i); %>
                    <img src="<%= ctx %>/uploadImages/<%= im.get(1) %>" style="width:80px;height:60px;object-fit:cover;border-radius:8px;cursor:pointer" onclick="this.parentElement.previousElementSibling.src=this.src">
                    <% } %>
                </div>
                <% } %>
                <% } else { %>
                <img src="<%= ctx %>/assets/img/placeholder.svg" class="w-100" alt="No image">
                <% } %>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="lb-form-card">
                <h1 class="h3 fw-bold" style="color:var(--navy)"><%= b.get(1) %> <%= b.get(2) %></h1>
                <div class="bike-price mb-3">&#8377;<%= String.format("%,.0f", Double.parseDouble(b.get(8).toString())) %>
                    <% if ("1".equals(String.valueOf(b.get(9)))) { %><small class="text-muted"> (Negotiable)</small><% } %>
                </div>
                <div class="bike-meta mb-3">
                    <span class="badge-lb"><i class="fas fa-calendar me-1"></i><%= b.get(4) %></span>
                    <span class="badge-lb"><i class="fas fa-tachometer-alt me-1"></i><%= b.get(5) %> km</span>
                    <span class="badge-lb"><i class="fas fa-gas-pump me-1"></i><%= b.get(6) %></span>
                    <span class="badge-lb"><i class="fas fa-star me-1"></i><%= b.get(7) %></span>
                </div>
                <p class="text-muted small">Reg: <%= b.get(3) %> | Views: <%= b.get(13) != null ? b.get(13) : "0" %></p>
                <% if (b.get(12) != null && !b.get(12).toString().isEmpty()) { %><p><%= b.get(12) %></p><% } %>
                <div class="d-grid gap-2 mt-3">
                    <a href="tel:<%= phone.replaceAll("[^0-9+]", "") %>" class="btn btn-gold btn-lg"><i class="fas fa-phone me-2"></i>Call Now: <%= phone %></a>
                    <% if (userId != null) { %>
                    <a href="<%= ctx %>/ajax/toggleWishlist?bikeId=<%= b.get(0) %>&action=<%= inWishlist ? "remove" : "add" %>" class="btn btn-navy"><i class="fas fa-heart me-2"></i><%= inWishlist ? "Remove from Wishlist" : "Add to Wishlist" %></a>
                    <% } else { %>
                    <a href="<%= ctx %>/login" class="btn btn-navy"><i class="fas fa-heart me-2"></i>Login to Save</a>
                    <% } %>
                    <a href="<%= ctx %>/finance" class="btn btn-outline-secondary">Apply for Finance</a>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
