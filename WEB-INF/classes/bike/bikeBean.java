package bike;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;
import util.SlugUtil;

public class bikeBean {

    public Vector getFeaturedBikes(int limit) throws Exception {
        return getBikesList(0, limit, null, null, null, null, null, true);
    }

    public Vector getBikesList(int page, int size, String search, Integer brandId, Integer modelId,
                               Double minPrice, Double maxPrice, boolean featuredOnly) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            StringBuilder sql = new StringBuilder(
                "SELECT b.id, b.registration_number, b.year, b.km_driven, b.fuel_type, b.bike_condition, " +
                "b.price, b.is_negotiable, b.status, b.slug, b.featured, b.views_count, b.description, " +
                "cb.brand_name, cm.model_name, " +
                "(SELECT image_url FROM bike_images WHERE reference_type='bike' AND reference_id=b.id AND is_primary=1 LIMIT 1) AS primary_image " +
                "FROM bikes b " +
                "JOIN config_bike_brands cb ON b.brand_id=cb.id " +
                "JOIN config_bike_models cm ON b.model_id=cm.id " +
                "WHERE b.status=0 ");
            if (featuredOnly) sql.append("AND b.featured=1 ");
            if (search != null && !search.trim().isEmpty()) {
                sql.append("AND (cb.brand_name LIKE ? OR cm.model_name LIKE ? OR b.registration_number LIKE ? OR b.slug LIKE ?) ");
            }
            if (brandId != null) sql.append("AND b.brand_id=? ");
            if (modelId != null) sql.append("AND b.model_id=? ");
            if (minPrice != null) sql.append("AND b.price>=? ");
            if (maxPrice != null) sql.append("AND b.price<=? ");
            sql.append("ORDER BY b.created_at DESC LIMIT ? OFFSET ?");

            pt = con.prepareStatement(sql.toString());
            int idx = 1;
            if (search != null && !search.trim().isEmpty()) {
                String q = "%" + search.trim() + "%";
                pt.setString(idx++, q); pt.setString(idx++, q); pt.setString(idx++, q); pt.setString(idx++, q);
            }
            if (brandId != null) pt.setInt(idx++, brandId);
            if (modelId != null) pt.setInt(idx++, modelId);
            if (minPrice != null) pt.setDouble(idx++, minPrice);
            if (maxPrice != null) pt.setDouble(idx++, maxPrice);
            pt.setInt(idx++, size);
            pt.setInt(idx, page * size);
            rs = pt.executeQuery();
            while (rs.next()) data.add(mapBikeRow(rs));
            con.commit();
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public Vector getBikeById(long id) throws Exception {
        return getBikeByField("b.id=?", String.valueOf(id));
    }

    public Vector getBikeBySlug(String slug) throws Exception {
        return getBikeByField("b.slug=?", slug);
    }

    private Vector getBikeByField(String where, String val) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector row = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            String sql = "SELECT b.*, cb.brand_name, cm.model_name FROM bikes b " +
                "JOIN config_bike_brands cb ON b.brand_id=cb.id " +
                "JOIN config_bike_models cm ON b.model_id=cm.id WHERE " + where;
            pt = con.prepareStatement(sql);
            pt.setString(1, val);
            rs = pt.executeQuery();
            if (rs.next()) {
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("registration_number"));
                row.add(rs.getString("year"));
                row.add(rs.getString("km_driven"));
                row.add(rs.getString("fuel_type"));
                row.add(rs.getString("bike_condition"));
                row.add(rs.getString("price"));
                row.add(rs.getString("is_negotiable"));
                row.add(rs.getString("status"));
                row.add(rs.getString("slug"));
                row.add(rs.getString("description"));
                row.add(rs.getString("views_count"));
                row.add(rs.getString("featured"));
                // increment views
                PreparedStatement up = con.prepareStatement("UPDATE bikes SET views_count=views_count+1 WHERE id=?");
                up.setLong(1, rs.getLong("id"));
                up.executeUpdate();
                up.close();
            }
            con.commit();
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            close(rs, pt, con);
        }
        return row;
    }

    public Vector getBikeImages(long bikeId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id, image_url, is_primary, display_order FROM bike_images WHERE reference_type='bike' AND reference_id=? ORDER BY display_order, id");
            pt.setLong(1, bikeId);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("image_url"));
                row.add(rs.getString("is_primary"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public String uploadBike(long adminId, int brandId, int modelId, String regNo, int year, int km,
                             String fuel, String condition, double price, String desc, int featured,
                             Long sellRequestId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet keys = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            Vector brands = new bike.brandBean().getBrandById(brandId);
            Vector models = new bike.brandBean().getModelById(modelId);
            String brandName = brands.size() > 1 ? brands.get(1).toString() : "bike";
            String modelName = models.size() > 1 ? models.get(2).toString() : "model";
            String slug = SlugUtil.createSlug(brandName, modelName, year, regNo);

            pt = con.prepareStatement(
                "INSERT INTO bikes (source_type, sell_request_id, brand_id, model_id, registration_number, year, km_driven, fuel_type, bike_condition, price, uploaded_by, description, slug, featured, status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,0)",
                Statement.RETURN_GENERATED_KEYS);
            pt.setString(1, sellRequestId != null ? "user_submission" : "admin_direct");
            if (sellRequestId != null) pt.setLong(2, sellRequestId); else pt.setNull(2, Types.BIGINT);
            pt.setInt(3, brandId);
            pt.setInt(4, modelId);
            pt.setString(5, regNo.toUpperCase());
            pt.setInt(6, year);
            pt.setInt(7, km);
            pt.setString(8, fuel);
            pt.setString(9, condition);
            pt.setDouble(10, price);
            pt.setLong(11, adminId);
            pt.setString(12, desc);
            pt.setString(13, slug);
            pt.setInt(14, featured);
            pt.executeUpdate();
            keys = pt.getGeneratedKeys();
            String bikeId = "0";
            if (keys.next()) bikeId = keys.getString(1);
            con.commit();
            return "SUCCESS:" + bikeId;
        } catch (Exception e) {
            if (con != null) con.rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            if (keys != null) keys.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }

    public String updateBikeStatus(long bikeId, int status, String buyerName, String buyerPhone, Double soldPrice) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            if (status == 2) {
                pt = con.prepareStatement("UPDATE bikes SET status=?, sold_date=NOW(), sold_to_name=?, sold_to_phone=?, sold_price=? WHERE id=?");
                pt.setInt(1, status);
                pt.setString(2, buyerName);
                pt.setString(3, buyerPhone);
                pt.setDouble(4, soldPrice != null ? soldPrice : 0);
                pt.setLong(5, bikeId);
            } else {
                pt = con.prepareStatement("UPDATE bikes SET status=? WHERE id=?");
                pt.setInt(1, status);
                pt.setLong(2, bikeId);
            }
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

    public String deleteBike(long bikeId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("DELETE FROM bikes WHERE id=?");
            pt.setLong(1, bikeId);
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

    public Vector getAllBikesAdmin(Integer statusFilter, int page, int size) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            String sql = "SELECT b.id, b.registration_number, b.year, b.km_driven, b.price, b.status, b.slug, b.created_at, cb.brand_name, cm.model_name FROM bikes b JOIN config_bike_brands cb ON b.brand_id=cb.id JOIN config_bike_models cm ON b.model_id=cm.id ";
            if (statusFilter != null) sql += "WHERE b.status=? ";
            sql += "ORDER BY b.created_at DESC LIMIT ? OFFSET ?";
            pt = con.prepareStatement(sql);
            int idx = 1;
            if (statusFilter != null) pt.setInt(idx++, statusFilter);
            pt.setInt(idx++, size);
            pt.setInt(idx, page * size);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("registration_number"));
                row.add(rs.getString("year"));
                row.add(rs.getString("km_driven"));
                row.add(rs.getString("price"));
                row.add(rs.getString("status"));
                row.add(rs.getString("slug"));
                row.add(rs.getString("created_at"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    private Vector mapBikeRow(ResultSet rs) throws SQLException {
        Vector row = new Vector();
        row.add(rs.getString("id"));
        row.add(rs.getString("brand_name"));
        row.add(rs.getString("model_name"));
        row.add(rs.getString("registration_number"));
        row.add(rs.getString("year"));
        row.add(rs.getString("km_driven"));
        row.add(rs.getString("fuel_type"));
        row.add(rs.getString("bike_condition"));
        row.add(rs.getString("price"));
        row.add(rs.getString("is_negotiable"));
        row.add(rs.getString("status"));
        row.add(rs.getString("slug"));
        row.add(rs.getString("featured"));
        row.add(rs.getString("views_count"));
        row.add(rs.getString("description"));
        row.add(rs.getString("primary_image"));
        return row;
    }

    private void close(ResultSet rs, PreparedStatement pt, Connection con) throws SQLException {
        if (rs != null) rs.close();
        if (pt != null) pt.close();
        if (con != null) con.close();
    }
}
