package servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AppConfig;

public class ImageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            resp.sendError(404);
            return;
        }
        String relativePath = pathInfo.substring(1);
        File file = new File(AppConfig.getUploadDir(), relativePath);
        if (!file.exists() || !file.isFile()) {
            resp.sendError(404);
            return;
        }
        String name = file.getName().toLowerCase();
        if (name.endsWith(".png")) resp.setContentType("image/png");
        else if (name.endsWith(".webp")) resp.setContentType("image/webp");
        else resp.setContentType("image/jpeg");

        resp.setHeader("Cache-Control", "public, max-age=86400");
        FileInputStream in = new FileInputStream(file);
        OutputStream out = resp.getOutputStream();
        byte[] buf = new byte[8192];
        int len;
        while ((len = in.read(buf)) > 0) out.write(buf, 0, len);
        in.close();
        out.flush();
    }
}
