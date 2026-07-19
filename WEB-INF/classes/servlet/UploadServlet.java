package servlet;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import bike.bikeBean;
import image.imageBean;

@MultipartConfig(maxFileSize = 5242880, maxRequestSize = 26214400, fileSizeThreshold = 1048576)
public class UploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ctx = req.getContextPath();
        String action = req.getParameter("action");

        try {
            if ("uploadBike".equals(action)) {
                Long adminId = (Long) req.getSession().getAttribute("userId");
                String role = (String) req.getSession().getAttribute("userRole");
                boolean isSuper = "1".equals(String.valueOf(req.getSession().getAttribute("isSuperAdmin")));
                if (adminId == null || (!"ADMIN".equals(role) && !isSuper)) {
                    resp.sendRedirect(ctx + "/login?msg=Admin+login+required");
                    return;
                }
                if (!hasUploadedImages(req)) {
                    resp.sendRedirect(ctx + "/admin/upload-bike?msg=" + java.net.URLEncoder.encode("Please upload at least one image.", "UTF-8"));
                    return;
                }
                bikeBean bike = new bikeBean();
                String result = bike.uploadBike(
                    adminId,
                    Integer.parseInt(req.getParameter("brandId")),
                    Integer.parseInt(req.getParameter("modelId")),
                    req.getParameter("registrationNumber"),
                    Integer.parseInt(req.getParameter("year")),
                    Integer.parseInt(req.getParameter("kmDriven")),
                    req.getParameter("fuelType"),
                    req.getParameter("bikeCondition"),
                    Double.parseDouble(req.getParameter("price")),
                    req.getParameter("description"),
                    Integer.parseInt(req.getParameter("featured")),
                    null
                );
                if (result.startsWith("SUCCESS")) {
                    String bikeId = result.split(":")[1];
                    uploadParts(req, "bike", Long.parseLong(bikeId));
                    resp.sendRedirect(ctx + "/admin/bike-report?msg=Bike+uploaded+successfully");
                } else {
                    resp.sendRedirect(ctx + "/admin/upload-bike?msg=" + java.net.URLEncoder.encode(result, "UTF-8"));
                }
            } else if ("sellRequest".equals(action)) {
                handleSellRequest(req, resp, ctx);
            } else {
                resp.sendRedirect(ctx + "/sell-bike?msg=Invalid+request");
            }
        } catch (Exception e) {
            String msg = java.net.URLEncoder.encode("Error: " + e.getMessage(), "UTF-8");
            if ("sellRequest".equals(action)) {
                resp.sendRedirect(ctx + "/sell-bike?msg=" + msg);
            } else {
                resp.sendRedirect(ctx + "/admin/upload-bike?msg=" + msg);
            }
        }
    }

    private void handleSellRequest(HttpServletRequest req, HttpServletResponse resp, String ctx) throws Exception {
        Long sessionUserId = (Long) req.getSession().getAttribute("userId");
        long userId = sessionUserId != null ? sessionUserId.longValue() : 0;

        bike.sellRequestBean sell = new bike.sellRequestBean();
        String result = sell.submitRequest(
            userId,
            req.getParameter("name"), req.getParameter("phoneNumber"), req.getParameter("aadharNumber"),
            req.getParameter("email"), req.getParameter("address"), req.getParameter("brandName"),
            req.getParameter("modelName"), req.getParameter("registrationNumber"),
            Integer.parseInt(req.getParameter("year")), Integer.parseInt(req.getParameter("kmDriven")),
            req.getParameter("fuelType"), req.getParameter("bikeCondition"),
            Double.parseDouble(req.getParameter("askingPrice")), req.getParameter("ownerType"),
            Integer.parseInt(req.getParameter("hasAccidentHistory")), req.getParameter("description")
        );

        if (result.startsWith("SUCCESS")) {
            String reqId = result.split(":")[1];
            uploadParts(req, "sell_request", Long.parseLong(reqId));
            String successMsg = "Sell+request+submitted+successfully.+We+will+contact+you+soon.";
            if (sessionUserId != null) {
                resp.sendRedirect(ctx + "/user/my-requests?msg=" + successMsg);
            } else {
                resp.sendRedirect(ctx + "/sell-bike?msg=" + successMsg);
            }
        } else {
            resp.sendRedirect(ctx + "/sell-bike?msg=" + java.net.URLEncoder.encode(result, "UTF-8"));
        }
    }

    private boolean hasUploadedImages(HttpServletRequest req) throws Exception {
        for (Part part : req.getParts()) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                return true;
            }
        }
        return false;
    }

    private void uploadParts(HttpServletRequest req, String type, long refId) throws Exception {
        Collection<Part> parts = req.getParts();
        List<File> files = new ArrayList<File>();
        for (Part part : parts) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                File tmp = File.createTempFile("lb_", ".jpg");
                part.write(tmp.getAbsolutePath());
                files.add(tmp);
            }
        }
        if (!files.isEmpty()) {
            imageBean img = new imageBean();
            if ("bike".equals(type)) img.uploadBikeImages(refId, files.toArray(new File[0]));
            else img.uploadSellRequestImages(refId, files.toArray(new File[0]));
            for (File f : files) f.delete();
        }
    }
}
