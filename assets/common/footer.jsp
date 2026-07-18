<jsp:useBean id="fin" class="finance.financeBean" scope="page"/>
<%
String supportPhone = fin.getContactPhone();
%>
<footer class="lb-footer">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-4">
                <h5><i class="fas fa-motorcycle me-2"></i>LoopBikes</h5>
                <p>Your trusted platform for buying, selling and financing second hand bikes across South Tamil Nadu.</p>
            </div>
            <div class="col-md-2">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="<%= request.getContextPath() %>/bikes/browse">Buy Bikes</a></li>
                    <li><a href="<%= request.getContextPath() %>/sell-bike">Sell Your Bike</a></li>
                    <li><a href="<%= request.getContextPath() %>/finance">Bike Finance</a></li>
                    <li><a href="<%= request.getContextPath() %>/about">About Us</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Service Areas</h5>
                <ul class="list-unstyled">
                    <li>Second Hand Bikes in Nagercoil</li>
                    <li>Resale Bikes in Tirunelveli</li>
                    <li>Used Bikes in Tuticorin</li>
                    <li>Bike Finance in Kanyakumari</li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Contact</h5>
                <p><i class="fas fa-phone me-2"></i><%= supportPhone %></p>
                <p><i class="fas fa-envelope me-2"></i>info@loopbikes.in</p>
                <p><i class="fas fa-map-marker-alt me-2"></i>Nagercoil, Tamil Nadu</p>
            </div>
        </div>
        <div class="lb-footer-bottom">
            &copy; <%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %> LoopBikes. All rights reserved. | Buy Sell Finance Second Hand Bikes
        </div>
    </div>
</footer>
