<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="wish" class="bike.wishlistBean" scope="page"/>
<%
String ctx = request.getContextPath();
Long userId = (Long) session.getAttribute("userId");
if (userId == null) { response.sendRedirect(ctx + "/login"); return; }
String bikeId = request.getParameter("bikeId");
String action = request.getParameter("action");
String referer = request.getHeader("Referer");
if ("add".equals(action)) wish.addToWishlist(userId, Long.parseLong(bikeId));
else wish.removeFromWishlist(userId, Long.parseLong(bikeId));
response.sendRedirect(referer != null ? referer : ctx + "/user/wishlist");
%>
