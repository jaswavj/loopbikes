<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="_guard.jsp" %>
<jsp:useBean id="bike" class="bike.bikeBean" scope="page"/>
<jsp:useBean id="brand" class="bike.brandBean" scope="page"/>
<%
request.setAttribute("pageTitle", "Upload Bike - LoopBikes Admin");
String ctx = request.getContextPath();
Vector brands = brand.getActiveBrands();
String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head><%@ include file="/assets/common/head.jsp" %></head>
<body>
<%@ include file="/assets/common/navbar.jsp" %>
<div class="page-header-bar"><div class="container"><h1>Upload Bike Listing</h1></div></div>
<main class="container pb-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="lb-form-card">
                <% if (msg != null) { %><div class="alert alert-info"><%= msg %></div><% } %>
                <form id="uploadBikeForm" action="<%= ctx %>/upload" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="uploadBike">
                    <div class="row g-3">
                        <div class="col-md-6"><label class="form-label">Brand *</label>
                            <select name="brandId" id="brandId" class="form-select" required onchange="loadModels()">
                                <option value="">Select Brand</option>
                                <% for (int i = 0; i < brands.size(); i++) { Vector br = (Vector) brands.get(i); %>
                                <option value="<%= br.get(0) %>"><%= br.get(1) %></option><% } %>
                            </select>
                        </div>
                        <div class="col-md-6"><label class="form-label">Model *</label><select name="modelId" id="modelId" class="form-select" required><option value="">Select Brand First</option></select></div>
                        <div class="col-md-6"><label class="form-label">Registration No *</label><input type="text" name="registrationNumber" class="form-control" required></div>
                        <div class="col-md-3"><label class="form-label">Year *</label><input type="number" name="year" class="form-control" required></div>
                        <div class="col-md-3"><label class="form-label">KM *</label><input type="number" name="kmDriven" class="form-control" required></div>
                        <div class="col-md-4"><label class="form-label">Fuel</label><select name="fuelType" class="form-select"><option value="petrol">Petrol</option><option value="diesel">Diesel</option><option value="electric">Electric</option></select></div>
                        <div class="col-md-4"><label class="form-label">Condition</label><select name="bikeCondition" class="form-select"><option value="excellent">Excellent</option><option value="good" selected>Good</option><option value="average">Average</option></select></div>
                        <div class="col-md-4"><label class="form-label">Price *</label><input type="number" name="price" class="form-control" required></div>
                        <div class="col-12"><label class="form-label">Description</label><textarea name="description" class="form-control" rows="2"></textarea></div>
                        <div class="col-md-6"><label class="form-label">Featured</label><select name="featured" class="form-select"><option value="0">No</option><option value="1">Yes</option></select></div>
                        <div class="col-md-6"><label class="form-label">Images (max 10) *</label><input type="file" name="images" id="bikeImages" class="form-control" accept="image/*" multiple required></div>
                    </div>
                    <button type="submit" class="btn btn-gold w-100 mt-4">Upload Bike</button>
                </form>
            </div>
        </div>
    </div>
</main>
<script>
document.getElementById('uploadBikeForm').addEventListener('submit', function(e) {
    var files = document.getElementById('bikeImages').files;
    if (!files || files.length === 0) {
        e.preventDefault();
        alert('Please upload at least one image.');
    }
});
function loadModels(){
    var brandId=document.getElementById('brandId').value;
    var sel=document.getElementById('modelId');
    sel.innerHTML='<option value="">Loading...</option>';
    if(!brandId){sel.innerHTML='<option value="">Select Brand First</option>';return;}
    fetch('<%= ctx %>/ajax/getModels?brandId='+brandId).then(r=>r.json()).then(data=>{
        sel.innerHTML='<option value="">Select Model</option>';
        data.forEach(m=>{var o=document.createElement('option');o.value=m.id;o.text=m.name;sel.add(o);});
    });
}
</script>
<%@ include file="/assets/common/footer.jsp" %>
</body>
</html>
