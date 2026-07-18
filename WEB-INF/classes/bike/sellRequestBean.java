package bike;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;

public class sellRequestBean {

    public String submitRequest(long userId, String name, String phone, String aadhar, String email, String address,
                                String brandName, String modelName, String regNo, int year, int km, String fuel,
                                String condition, double askingPrice, String ownerType, int accidentHistory, String desc) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet keys = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement(
                "INSERT INTO user_bike_sell_requests (user_id, name, phone_number, aadhar_number, email, address, brand_name, model_name, registration_number, registration_year, km_driven, fuel_type, bike_condition, asking_price, owner_type, has_accident_history, description) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS);
            pt.setLong(1, userId);
            pt.setString(2, name);
            pt.setString(3, phone);
            pt.setString(4, aadhar);
            pt.setString(5, email);
            pt.setString(6, address);
            pt.setString(7, brandName);
            pt.setString(8, modelName);
            pt.setString(9, regNo.toUpperCase());
            pt.setInt(10, year);
            pt.setInt(11, km);
            pt.setString(12, fuel);
            pt.setString(13, condition);
            pt.setDouble(14, askingPrice);
            pt.setString(15, ownerType);
            pt.setInt(16, accidentHistory);
            pt.setString(17, desc);
            pt.executeUpdate();
            keys = pt.getGeneratedKeys();
            String id = "0";
            if (keys.next()) id = keys.getString(1);
            con.commit();
            return "SUCCESS:" + id;
        } catch (Exception e) {
            if (con != null) con.rollback();
            return "ERROR: " + e.getMessage();
        } finally {
            if (keys != null) keys.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }

    public Vector getMyRequests(long userId, int page, int size) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id, brand_name, model_name, registration_number, registration_year, asking_price, status, created_at FROM user_bike_sell_requests WHERE user_id=? ORDER BY created_at DESC LIMIT ? OFFSET ?");
            pt.setLong(1, userId);
            pt.setInt(2, size);
            pt.setInt(3, page * size);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("registration_number"));
                row.add(rs.getString("registration_year"));
                row.add(rs.getString("asking_price"));
                row.add(rs.getString("status"));
                row.add(rs.getString("created_at"));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public Vector getAllRequests(Integer statusFilter, int page, int size) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            String sql = "SELECT id, name, phone_number, brand_name, model_name, registration_number, asking_price, status, created_at FROM user_bike_sell_requests ";
            if (statusFilter != null) sql += "WHERE status=? ";
            sql += "ORDER BY created_at DESC LIMIT ? OFFSET ?";
            pt = con.prepareStatement(sql);
            int idx = 1;
            if (statusFilter != null) pt.setInt(idx++, statusFilter);
            pt.setInt(idx++, size);
            pt.setInt(idx, page * size);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                for (int i = 1; i <= 9; i++) row.add(rs.getString(i));
                data.add(row);
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return data;
    }

    public Vector getRequestById(long id) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector row = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT * FROM user_bike_sell_requests WHERE id=?");
            pt.setLong(1, id);
            rs = pt.executeQuery();
            if (rs.next()) {
                row.add(rs.getString("id"));
                row.add(rs.getString("name"));
                row.add(rs.getString("phone_number"));
                row.add(rs.getString("brand_name"));
                row.add(rs.getString("model_name"));
                row.add(rs.getString("registration_number"));
                row.add(rs.getString("registration_year"));
                row.add(rs.getString("km_driven"));
                row.add(rs.getString("asking_price"));
                row.add(rs.getString("status"));
                row.add(rs.getString("admin_notes"));
                row.add(rs.getString("negotiated_price"));
                row.add(rs.getString("description"));
            }
            con.commit();
        } finally {
            close(rs, pt, con);
        }
        return row;
    }

    public String updateStatus(long requestId, int status, long adminId, String adminNotes, String rejectionReason, Double negotiatedPrice, int purchased) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("UPDATE user_bike_sell_requests SET status=?, admin_notes=?, rejection_reason=?, negotiated_price=?, is_bike_purchased=?, reviewed_by=?, reviewed_at=NOW() WHERE id=?");
            pt.setInt(1, status);
            pt.setString(2, adminNotes);
            pt.setString(3, rejectionReason);
            if (negotiatedPrice != null) pt.setDouble(4, negotiatedPrice); else pt.setNull(4, Types.DECIMAL);
            pt.setInt(5, purchased);
            pt.setLong(6, adminId);
            pt.setLong(7, requestId);
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
