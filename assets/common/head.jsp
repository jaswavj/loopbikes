<%
String pageTitle = (String) request.getAttribute("pageTitle");
if (pageTitle == null) pageTitle = "LoopBikes - Second Hand Bikes in Nagercoil, Tirunelveli, Tuticorin";
String pageDesc = (String) request.getAttribute("pageDesc");
if (pageDesc == null) pageDesc = "Buy, sell and finance second hand bikes in Nagercoil, Tirunelveli, Tuticorin, Kanyakumari. Best resale bikes with easy finance options.";
String pageKeywords = (String) request.getAttribute("pageKeywords");
if (pageKeywords == null) pageKeywords = "second hand bike Nagercoil, used bike Tirunelveli, resale bike Tuticorin, bike finance Kanyakumari, pre owned two wheeler";
String canonical = request.getRequestURL().toString();
if (request.getQueryString() != null) canonical += "?" + request.getQueryString();
%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="icon" type="image/png" href="<%= request.getContextPath() %>/assets/img/loop.png">
<link rel="shortcut icon" type="image/png" href="<%= request.getContextPath() %>/assets/img/loop.png">
<link rel="apple-touch-icon" href="<%= request.getContextPath() %>/assets/img/loop.png">
<title><%= pageTitle %></title>
<meta name="description" content="<%= pageDesc %>">
<meta name="keywords" content="<%= pageKeywords %>">
<meta name="robots" content="index, follow">
<meta name="author" content="LoopBikes">
<link rel="canonical" href="<%= canonical %>">
<meta property="og:title" content="<%= pageTitle %>">
<meta property="og:description" content="<%= pageDesc %>">
<meta property="og:image" content="<%= request.getContextPath() %>/assets/img/loop.png">
<meta property="og:type" content="website">
<meta property="og:locale" content="en_IN">
<meta name="geo.region" content="IN-TN">
<meta name="geo.placename" content="Nagercoil, Tamil Nadu">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
<link href="<%= request.getContextPath() %>/assets/css/theme.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" defer></script>
