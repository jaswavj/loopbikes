<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="brand" class="bike.brandBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Brands & Models - LoopBikes Admin");
String ctx = request.getContextPath();
Vector brands = brand.getAllBrandsAdmin();
Vector models = brand.getAllModelsAdmin(null);
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Brands & Models</h1></div></div>
<main class="container pb-5">
    <% if (msg != null) { %><div class="alert alert-success"><%= msg %></div><% } %>
    <div class="row g-4">
        <div class="col-md-5">
            <div class="lb-form-card">
                <h5>Add Brand</h5>
                <form action="<%= ctx %>/admin/saveBrandModel" method="post" class="row g-2">
                    <input type="hidden" name="type" value="brand">
                    <div class="col-8"><input type="text" name="brandName" class="form-control" placeholder="Brand name" required></div>
                    <div class="col-4"><input type="number" name="displayOrder" class="form-control" value="0"></div>
                    <div class="col-12"><button class="btn btn-gold w-100">Add Brand</button></div>
                </form>
                <hr>
                <h5>Brands</h5>
                <div class="admin-table-wrap">
                <table class="table table-sm"><thead><tr><th>Name</th><th>Active</th><th>Action</th></tr></thead>
                <tbody><% for (int i=0;i<brands.size();i++){ Vector b=(Vector)brands.get(i); %>
                <tr><td><%= b.get(1) %></td><td><%= "1".equals(b.get(2).toString())?"Yes":"No" %></td>
                <td><a href="<%= ctx %>/admin/saveBrandModel?toggleBrand=<%= b.get(0) %>" class="btn btn-sm btn-navy">Toggle</a></td></tr>
                <% } %></tbody></table>
                </div>
            </div>
        </div>
        <div class="col-md-7">
            <div class="lb-form-card">
                <h5>Add Model</h5>
                <form action="<%= ctx %>/admin/saveBrandModel" method="post" class="row g-2">
                    <input type="hidden" name="type" value="model">
                    <div class="col-md-5"><select name="brandId" class="form-select" required><option value="">Brand</option>
                        <% for (int i=0;i<brands.size();i++){ Vector b=(Vector)brands.get(i); %><option value="<%= b.get(0) %>"><%= b.get(1) %></option><% } %>
                    </select></div>
                    <div class="col-md-4"><input type="text" name="modelName" class="form-control" placeholder="Model" required></div>
                    <div class="col-md-3"><input type="text" name="engineCc" class="form-control" placeholder="CC"></div>
                    <div class="col-12"><button class="btn btn-gold w-100">Add Model</button></div>
                </form>
                <hr>
                <h5>Models</h5>
                <div class="admin-table-wrap">
                <table class="table table-sm table-lb"><thead><tr><th>Brand</th><th>Model</th><th>CC</th><th>Active</th><th>Action</th></tr></thead>
                <tbody><% for (int i=0;i<models.size();i++){ Vector m=(Vector)models.get(i); %>
                <tr><td><%= m.get(2) %></td><td><%= m.get(3) %></td><td><%= m.get(4) %></td>
                <td><%= "1".equals(m.get(5).toString())?"Yes":"No" %></td>
                <td><a href="<%= ctx %>/admin/saveBrandModel?toggleModel=<%= m.get(0) %>" class="btn btn-sm btn-navy">Toggle</a></td></tr>
                <% } %></tbody></table>
                </div>
            </div>
        </div>
    </div>
</main>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
