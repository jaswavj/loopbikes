<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
Long userId = (Long) session.getAttribute("userId");
String role = (String) session.getAttribute("userRole");
boolean isSuper = "1".equals(String.valueOf(session.getAttribute("isSuperAdmin")));
if (userId == null || (!"ADMIN".equals(role) && !isSuper)) {
    response.sendRedirect(request.getContextPath() + "/login?msg=Admin+access+required");
    return;
}
%>
