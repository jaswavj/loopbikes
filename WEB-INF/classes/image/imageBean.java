package image;

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.*;
import java.sql.*;
import java.util.UUID;
import javax.imageio.ImageIO;
import util.AppConfig;
import util.DBConnectionManager;

public class imageBean {

    private static final int MAX_WIDTH = 1920;
    private static final int MAX_HEIGHT = 1080;

    public String uploadBikeImages(long bikeId, File[] files) throws Exception {
        return uploadImages("bike", bikeId, files, 10);
    }

    public String uploadSellRequestImages(long sellRequestId, File[] files) throws Exception {
        return uploadImages("sell_request", sellRequestId, files, 5);
    }

    private String uploadImages(String refType, long refId, File[] files, int maxCount) throws Exception {
        if (files == null || files.length == 0) return "ERROR: No files";
        Connection con = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            int existing = countExisting(con, refType, refId);
            if (existing + files.length > maxCount) return "ERROR: Max " + maxCount + " images allowed";

            java.util.Calendar cal = java.util.Calendar.getInstance();
            String year = String.valueOf(cal.get(java.util.Calendar.YEAR));
            String month = String.format("%02d", cal.get(java.util.Calendar.MONTH) + 1);
            File dir = new File(AppConfig.UPLOAD_DIR, "bike-images/" + year + "/" + month);
            if (!dir.exists()) dir.mkdirs();

            int order = existing + 1;
            for (File src : files) {
                if (src == null || !src.exists()) continue;
                String uuid = UUID.randomUUID().toString();
                String fileName = uuid + ".jpg";
                String relativePath = "bike-images/" + year + "/" + month + "/" + fileName;
                File dest = new File(AppConfig.UPLOAD_DIR, relativePath);

                resizeAndSave(src, dest);
                saveImageRecord(con, refType, refId, relativePath, src.getName(), order, existing == 0 && order == 1);
                order++;
            }
            con.commit();
            return "SUCCESS";
        } catch (Exception e) {
            if (con != null) con.rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            if (con != null) con.close();
        }
    }

    private int countExisting(Connection con, String refType, long refId) throws SQLException {
        PreparedStatement pt = con.prepareStatement("SELECT COUNT(*) FROM bike_images WHERE reference_type=? AND reference_id=?");
        pt.setString(1, refType);
        pt.setLong(2, refId);
        ResultSet rs = pt.executeQuery();
        int c = 0;
        if (rs.next()) c = rs.getInt(1);
        rs.close();
        pt.close();
        return c;
    }

    private void saveImageRecord(Connection con, String refType, long refId, String path, String origName, int order, boolean primary) throws SQLException {
        PreparedStatement pt = con.prepareStatement(
            "INSERT INTO bike_images (reference_type, reference_id, image_path, image_url, original_filename, is_primary, display_order) VALUES (?,?,?,?,?,?,?)");
        pt.setString(1, refType);
        pt.setLong(2, refId);
        pt.setString(3, path);
        pt.setString(4, path);
        pt.setString(5, origName);
        pt.setInt(6, primary ? 1 : 0);
        pt.setInt(7, order);
        pt.executeUpdate();
        pt.close();
    }

    private void resizeAndSave(File src, File dest) throws IOException {
        BufferedImage img = ImageIO.read(src);
        if (img == null) throw new IOException("Invalid image");
        int w = img.getWidth(), h = img.getHeight();
        if (w > MAX_WIDTH || h > MAX_HEIGHT) {
            double ratio = Math.min((double) MAX_WIDTH / w, (double) MAX_HEIGHT / h);
            w = (int) (w * ratio);
            h = (int) (h * ratio);
            Image scaled = img.getScaledInstance(w, h, Image.SCALE_SMOOTH);
            BufferedImage out = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = out.createGraphics();
            g.drawImage(scaled, 0, 0, null);
            g.dispose();
            img = out;
        }
        ImageIO.write(img, "jpg", dest);
    }
}
