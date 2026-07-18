<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
response.sendRedirect(request.getContextPath() + "/upload?action=uploadBike&" + request.getQueryString());
%>
