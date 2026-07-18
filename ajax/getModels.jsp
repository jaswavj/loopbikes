<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="brand" class="bike.brandBean" scope="page"/>
<%
response.setHeader("Cache-Control", "no-cache");
String brandId = request.getParameter("brandId");
if (brandId == null) { out.print("[]"); return; }
Vector models = brand.getModelsByBrand(Integer.parseInt(brandId));
StringBuilder json = new StringBuilder("[");
for (int i = 0; i < models.size(); i++) {
    Vector m = (Vector) models.get(i);
    if (i > 0) json.append(",");
    json.append("{\"id\":").append(m.get(0)).append(",\"name\":\"").append(m.get(1)).append("\"}");
}
json.append("]");
out.print(json.toString());
%>
