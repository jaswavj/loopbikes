<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="brand" class="bike.brandBean" scope="page"/>
<%
String ctx = request.getContextPath();
if (request.getParameter("toggleBrand") != null) {
    brand.toggleBrandActive(Integer.parseInt(request.getParameter("toggleBrand")));
} else if (request.getParameter("toggleModel") != null) {
    brand.toggleModelActive(Integer.parseInt(request.getParameter("toggleModel")));
} else if ("brand".equals(request.getParameter("type"))) {
    brand.saveBrand(request.getParameter("brandName"), Integer.parseInt(request.getParameter("displayOrder")));
} else if ("model".equals(request.getParameter("type"))) {
    brand.saveModel(Integer.parseInt(request.getParameter("brandId")), request.getParameter("modelName"), request.getParameter("engineCc"));
}
response.sendRedirect(ctx + "/admin/brand-model?msg=Saved");
%>
