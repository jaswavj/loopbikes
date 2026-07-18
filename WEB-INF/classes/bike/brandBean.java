package bike;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;

public class brandBean {

    public Vector getActiveBrands() throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id, brand_name, logo_url FROM config_bike_brands WHERE is_active=1 ORDER BY display_order, brand_name");
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("logo_url"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public Vector getModelsByBrand(int brandId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id, model_name, engine_cc, fuel_type FROM config_bike_models WHERE brand_id=? AND is_active=1 ORDER BY model_name");
            pt.setInt(1, brandId);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("engine_cc"));
                row.add(rs.getString("fuel_type"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public Vector getBrandById(int id) throws Exception {
        return getSingle("SELECT id, brand_name FROM config_bike_brands WHERE id=?", id);
    }

    public Vector getModelById(int id) throws Exception {
        return getSingle("SELECT id, brand_id, model_name FROM config_bike_models WHERE id=?", id);
    }

    private Vector getSingle(String sql, int id) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector row = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement(sql);
            pt.setInt(1, id);
            rs = pt.executeQuery();
            while (rs.next()) {
                for (int i = 1; i <= rs.getMetaData().getColumnCount(); i++)
                    row.add(rs.getString(i));
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return row;
    }

    public Vector getAllBrandsAdmin() throws Exception {
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            st = con.createStatement();
            rs = st.executeQuery("SELECT id, brand_name, is_active, display_order FROM config_bike_brands ORDER BY display_order, brand_name");
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("is_active"));
                row.add(rs.getString("display_order"));
                data.add(row);
            }
            con.commit();
        } finally {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return data;
    }

    public Vector getAllModelsAdmin(Integer brandId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            String sql = "SELECT m.id, m.brand_id, cb.brand_name, m.model_name, m.engine_cc, m.is_active FROM config_bike_models m JOIN config_bike_brands cb ON m.brand_id=cb.id";
            if (brandId != null) sql += " WHERE m.brand_id=?";
            sql += " ORDER BY cb.brand_name, m.model_name";
            pt = con.prepareStatement(sql);
            if (brandId != null) pt.setInt(1, brandId);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("engine_cc"));
                row.add(rs.getString("is_active"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public String saveBrand(String name, int displayOrder) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("INSERT INTO config_bike_brands (brand_name, display_order) VALUES (?,?)");
            pt.setString(1, name);
            pt.setInt(2, displayOrder);
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

    public String saveModel(int brandId, String modelName, String engineCc) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("INSERT INTO config_bike_models (brand_id, model_name, engine_cc) VALUES (?,?,?)");
            pt.setInt(1, brandId);
            pt.setString(2, modelName);
            pt.setString(3, engineCc);
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

    public String toggleBrandActive(int brandId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("UPDATE config_bike_brands SET is_active = IF(is_active=1,0,1) WHERE id=?");
            pt.setInt(1, brandId);
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

    public String toggleModelActive(int modelId) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("UPDATE config_bike_models SET is_active = IF(is_active=1,0,1) WHERE id=?");
            pt.setInt(1, modelId);
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

    private void close(ResultSet rs, PreparedStatement pt, Connection con) throws SQLException {
        if (rs != null) rs.close();
        if (pt != null) pt.close();
        if (con != null) con.close();
    }
}
