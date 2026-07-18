<%
String currentPage = request.getRequestURI();
String cp = request.getContextPath();
boolean isHome = currentPage.equals(cp) || currentPage.equals(cp + "/");
Long sessionUserId = (Long) session.getAttribute("userId");
String sessionUserName = (String) session.getAttribute("userName");
String sessionRole = (String) session.getAttribute("userRole");
boolean isAdmin = "ADMIN".equals(sessionRole) || "1".equals(String.valueOf(session.getAttribute("isSuperAdmin")));
%>
<nav class="navbar navbar-expand-lg lb-navbar">
    <div class="container">
        <a class="navbar-brand" href="<%= request.getContextPath() %>/"><i class="fas fa-motorcycle me-2"></i>LoopBikes</a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#lbNav">
            <i class="fas fa-bars text-white"></i>
        </button>
        <div class="collapse navbar-collapse" id="lbNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link <%= isHome ? "active" : "" %>" href="<%= request.getContextPath() %>/">Home</a></li>
                <li class="nav-item"><a class="nav-link <%= currentPage.contains("/bikes/") ? "active" : "" %>" href="<%= request.getContextPath() %>/bikes/browse">Buy Bikes</a></li>
                <li class="nav-item"><a class="nav-link <%= currentPage.contains("sell-bike") ? "active" : "" %>" href="<%= request.getContextPath() %>/sell-bike">Sell Bike</a></li>
                <li class="nav-item"><a class="nav-link <%= currentPage.contains("finance") ? "active" : "" %>" href="<%= request.getContextPath() %>/finance">Finance</a></li>
                <li class="nav-item"><a class="nav-link <%= currentPage.contains("about") ? "active" : "" %>" href="<%= request.getContextPath() %>/about">About</a></li>
            </ul>
            <form class="d-flex me-3" action="<%= request.getContextPath() %>/bikes/browse" method="get">
                <input class="lb-search" type="search" name="search" placeholder="Search bikes..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            </form>
            <ul class="navbar-nav">
                <% if (sessionUserId != null) { %>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"><i class="fas fa-user-circle me-1"></i><%= sessionUserName %></a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/user/my-requests">My Sell Requests</a></li>
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/user/wishlist">Wishlist</a></li>
                            <% if (isAdmin) { %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/admin/dashboard"><i class="fas fa-cog me-1"></i> Admin Panel</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout">Logout</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/login"><i class="fas fa-sign-in-alt me-1"></i> Login</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
<div class="seo-locations">
    <span><i class="fas fa-map-marker-alt"></i> Serving:</span>
    <span>Nagercoil</span> | <span>Tirunelveli</span> | <span>Tuticorin</span> | <span>Kanyakumari</span> | <span>Marthandam</span> | <span>Tenkasi</span>
</div>
