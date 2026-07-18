<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="fin" class="finance.financeBean" scope="page"/>
<%
String ctx = request.getContextPath();
try {
    String result = fin.saveEnquiry(
        request.getParameter("name"),
        request.getParameter("phoneNumber"),
        request.getParameter("aadharNumber"),
        request.getParameter("bikeBrand"),
        request.getParameter("bikeModel"),
        request.getParameter("registrationNumber"),
        Integer.parseInt(request.getParameter("year")),
        Double.parseDouble(request.getParameter("financeAmount"))
    );
    String phone = fin.getContactPhone();
    if (result.equals("SUCCESS")) {
        response.sendRedirect(ctx + "/finance?msg=Application+submitted!+We+will+call+you+soon+at+" + phone.replace(" ", "+"));
    } else {
        response.sendRedirect(ctx + "/finance?msg=" + java.net.URLEncoder.encode(result, "UTF-8"));
    }
} catch (Exception e) {
    response.sendRedirect(ctx + "/finance?msg=" + java.net.URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
}
%>
