package bike;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;

public class wishlistBean {

    public String addToWishlist(long userId, long bikeId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("INSERT IGNORE INTO buyer_wishlist (user_id, bike_id) VALUES (?,?)");
            pt.setLong(1, userId);
            pt.setLong(2, bikeId);
            pt.executeUpdate();
            con.commit();
            return "SUCCESS";
        } catch (Exception e) {
            if (con != null) con.rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }

    public String removeFromWishlist(long userId, long bikeId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("DELETE FROM buyer_wishlist WHERE user_id=? AND bike_id=?");
            pt.setLong(1, userId);
            pt.setLong(2, bikeId);
            pt.executeUpdate();
            con.commit();
            return "SUCCESS";
        } catch (Exception e) {
            if (con != null) con.rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }

    public boolean isInWishlist(long userId, long bikeId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id FROM buyer_wishlist WHERE user_id=? AND bike_id=?");
            pt.setLong(1, userId);
            pt.setLong(2, bikeId);
            rs = pt.executeQuery();
            boolean found = rs.next();
            con.commit();
            return found;
        } finally {
            if (rs != null) rs.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }

    public Vector getWishlist(long userId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement(
                "SELECT b.id, cb.brand_name, cm.model_name, b.year, b.price, b.slug, b.status, " +
                "(SELECT image_url FROM bike_images WHERE reference_type='bike' AND reference_id=b.id AND is_primary=1 LIMIT 1) AS img " +
                "FROM buyer_wishlist w JOIN bikes b ON w.bike_id=b.id " +
                "JOIN config_bike_brands cb ON b.brand_id=cb.id " +
                "JOIN config_bike_models cm ON b.model_id=cm.id " +
                "WHERE w.user_id=? ORDER BY w.added_at DESC");
            pt.setLong(1, userId);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("year"));
                row.add(rs.getString("price"));
                row.add(rs.getString("slug"));
                row.add(rs.getString("status"));
                row.add(rs.getString("img"));
                data.add(row);
            }
            con.commit();
        } finally {
            if (rs != null) rs.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
        return data;
    }
}
