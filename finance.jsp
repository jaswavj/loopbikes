<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setAttribute("pageTitle", "Bike Finance - Easy EMI for Second Hand Bikes | Nagercoil, Tirunelveli");
request.setAttribute("pageDesc", "Get easy bike finance and EMI for second hand bikes in Nagercoil, Tirunelveli, Tuticorin. Quick approval, low interest. Apply online now.");
String ctx = request.getContextPath();
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Bike Finance</h1><p>Easy EMI options for second hand bikes in Nagercoil, Tirunelveli &amp; Tuticorin</p></div></div>
<main class="container pb-5">
    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="lb-form-card">
                <% if (msg != null) { %>
                <div class="alert <%= msg.startsWith("ERROR") ? "alert-danger" : "alert-success" %>"><i class="fas fa-check-circle me-2"></i><%= msg.replace("+", " ") %></div>
                <% } %>
                <form action="<%= ctx %>/financeSave" method="post">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Full Name *</label><input type="text" name="name" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Phone *</label><input type="tel" name="phoneNumber" class="form-control" pattern="[0-9]{10}" required></div>
                        <div class="col-md-6"><label class="form-label">Aadhar Number *</label><input type="text" name="aadharNumber" class="form-control" pattern="[0-9]{12}" maxlength="12" required></div>
                        <div class="col-md-6"><label class="form-label">Finance Amount *</label><input type="number" name="financeAmount" class="form-control" required min="5000"></div>
                        <div class="col-md-6"><label class="form-label">Bike Brand *</label><input type="text" name="bikeBrand" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Bike Model *</label><input type="text" name="bikeModel" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Registration No *</label><input type="text" name="registrationNumber" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Year *</label><input type="number" name="year" class="form-control" required min="2000" max="2030"></div>
                    </div>
                    <button type="submit" class="btn btn-gold w-100 mt-4"><i class="fas fa-file-invoice-dollar me-2"></i>Apply for Finance</button>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
