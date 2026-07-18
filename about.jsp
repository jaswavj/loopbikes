<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
request.setAttribute("pageTitle", "About LoopBikes - Second Hand Bike Dealer Nagercoil, Tirunelveli, Tuticorin");
request.setAttribute("pageDesc", "LoopBikes is your trusted partner for buying, selling and financing second hand bikes in Nagercoil, Tirunelveli, Tuticorin and Kanyakumari district.");
String ctx = request.getContextPath();
String supportPhone = new finance.financeBean().getContactPhone();
request.setAttribute("supportPhone", supportPhone);
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>About LoopBikes</h1><p>Trusted second hand bike marketplace in South Tamil Nadu</p></div></div>
<main class="container pb-5">
    <div class="row g-4">
        <div class="col-lg-8">
            <div class="lb-form-card">
                <h3 style="color:var(--navy)">Who We Are</h3>
                <p>LoopBikes is a leading platform for <strong>second hand bikes in Nagercoil, Tirunelveli, Tuticorin</strong> and surrounding areas. We connect buyers and sellers with verified, quality pre-owned two wheelers at fair prices.</p>
                <h4 style="color:var(--navy)" class="mt-4">Our Services</h4>
                <ul>
                    <li><strong>Buy</strong> - Browse verified resale bikes with transparent pricing</li>
                    <li><strong>Sell</strong> - Get best value for your used bike with quick evaluation</li>
                    <li><strong>Finance</strong> - Easy EMI options for pre-owned bikes</li>
                </ul>
                <h4 style="color:var(--navy)" class="mt-4">Service Areas</h4>
                <p>Nagercoil, Tirunelveli, Tuticorin (Thoothukudi), Kanyakumari, Marthandam, Tenkasi, Kovilpatti and nearby towns.</p>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="lb-form-card">
                <h5 style="color:var(--navy)">Contact Us</h5>
                <p><i class="fas fa-phone text-warning me-2"></i><%= supportPhone %></p>
                <p><i class="fas fa-envelope text-warning me-2"></i>info@loopbikes.in</p>
                <p><i class="fas fa-map-marker-alt text-warning me-2"></i>Nagercoil, Tamil Nadu 629001</p>
                <p><i class="fas fa-clock text-warning me-2"></i>Mon-Sat: 9AM - 7PM</p>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
