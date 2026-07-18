<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setAttribute("pageTitle", "Sell Your Second Hand Bike - Best Price in Nagercoil, Tirunelveli | LoopBikes");
request.setAttribute("pageDesc", "Sell your used bike at best price in Nagercoil, Tirunelveli, Tuticorin. Easy process, quick evaluation, instant payment. Submit your bike details now.");
String ctx = request.getContextPath();
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Sell Your Bike</h1><p>Get the best resale value for your second hand bike in South Tamil Nadu</p></div></div>
<main class="container pb-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="lb-form-card">
                <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
                <form action="<%= ctx %>/upload" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="sellRequest">
                    <h5 class="mb-3" style="color:var(--navy)">Bike Details</h5>
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Brand *</label><input type="text" name="brandName" class="form-control" required placeholder="Honda, Hero, TVS..."></div>
                        <div class="col-md-6"><label class="form-label">Model *</label><input type="text" name="modelName" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Registration No *</label><input type="text" name="registrationNumber" class="form-control" required></div>
                        <div class="col-md-3"><label class="form-label">Year *</label><input type="number" name="year" class="form-control" required min="1990" max="2030"></div>
                        <div class="col-md-3"><label class="form-label">KM Driven *</label><input type="number" name="kmDriven" class="form-control" required min="0"></div>
                        <div class="col-md-4"><label class="form-label">Fuel Type</label><select name="fuelType" class="form-select"><option value="petrol">Petrol</option><option value="diesel">Diesel</option><option value="electric">Electric</option></select></div>
                        <div class="col-md-4"><label class="form-label">Condition</label><select name="bikeCondition" class="form-select"><option value="excellent">Excellent</option><option value="good" selected>Good</option><option value="average">Average</option><option value="needs_repair">Needs Repair</option></select></div>
                        <div class="col-md-4"><label class="form-label">Asking Price *</label><input type="number" name="askingPrice" class="form-control" required min="1000"></div>
                        <div class="col-md-6"><label class="form-label">Owner Type</label><select name="ownerType" class="form-select"><option value="first">First Owner</option><option value="second">Second Owner</option><option value="third">Third Owner</option></select></div>
                        <div class="col-md-6"><label class="form-label">Accident History</label><select name="hasAccidentHistory" class="form-select"><option value="0">No</option><option value="1">Yes</option></select></div>
                        <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                        <div class="col-12"><label class="form-label">Bike Photos (max 5)</label><input type="file" name="images" class="form-control" accept="image/*" multiple></div>
                    </div>
                    <hr class="my-4">
                    <h5 class="mb-3" style="color:var(--navy)">Your Contact Details</h5>
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Name *</label><input type="text" name="name" class="form-control" required></div>
                        <div class="col-md-6"><label class="form-label">Phone *</label><input type="tel" name="phoneNumber" class="form-control" pattern="[0-9]{10}" required></div>
                        <div class="col-md-6"><label class="form-label">Email</label><input type="email" name="email" class="form-control"></div>
                        <div class="col-md-6"><label class="form-label">Aadhar (optional)</label><input type="text" name="aadharNumber" class="form-control" maxlength="12"></div>
                        <div class="col-12"><label class="form-label">Address</label><textarea name="address" class="form-control" rows="2"></textarea></div>
                    </div>
                    <button type="submit" class="btn btn-gold w-100 mt-4"><i class="fas fa-paper-plane me-2"></i>Submit Sell Request</button>
                </form>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
