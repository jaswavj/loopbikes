<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Redirects multipart POST to UploadServlet
// Form should post directly to /upload?action=...
response.sendRedirect(request.getContextPath() + "/sell-bike?msg=Use+form+submit");
%>
