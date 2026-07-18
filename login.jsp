<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setAttribute("pageTitle", "Login / Register - LoopBikes");
request.setAttribute("pageDesc", "Login to LoopBikes to sell your bike, save wishlist and track sell requests in Nagercoil, Tirunelveli, Tuticorin.");
String ctx = request.getContextPath();
String msg = request.getParameter("msg");
if (session.getAttribute("userId") != null) { response.sendRedirect(ctx + "/"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="lb-form-card">
                <h2 class="section-title">Login / Register</h2>
                <% if (msg != null) { %><div class="alert alert-info"><%= msg %></div><% } %>
                <form action="<%= ctx %>/loginAction" method="post">
                    <div class="mb-3">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" name="phone" class="form-control" pattern="[0-9]{10}" maxlength="10" required placeholder="10 digit mobile">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required minlength="6">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Name (for new registration)</label>
                        <input type="text" name="name" class="form-control" placeholder="Your name">
                    </div>
                    <button type="submit" class="btn btn-gold w-100">Login / Register</button>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
