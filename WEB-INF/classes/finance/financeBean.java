package finance;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;

public class financeBean {

    public String saveEnquiry(String name, String phone, String aadhar, String brand, String model,
                              String regNo, int year, double amount) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("INSERT INTO finance (name, phone_number, aadhar_number, bike_brand, bike_model, registration_number, year, finance_amount) VALUES (?,?,?,?,?,?,?,?)");
            pt.setString(1, name);
            pt.setString(2, phone);
            pt.setString(3, aadhar);
            pt.setString(4, brand);
            pt.setString(5, model);
            pt.setString(6, regNo.toUpperCase());
            pt.setInt(7, year);
            pt.setDouble(8, amount);
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

    public Vector getAllEnquiries(Integer statusFilter, String search, int page, int size) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            StringBuilder sql = new StringBuilder("SELECT id, name, phone_number, bike_brand, bike_model, registration_number, year, finance_amount, status, is_called, call_answered, created_at FROM finance WHERE 1=1 ");
            if (statusFilter != null) sql.append("AND status=? ");
            if (search != null && !search.trim().isEmpty()) sql.append("AND (name LIKE ? OR phone_number LIKE ? OR registration_number LIKE ?) ");
            sql.append("ORDER BY created_at DESC LIMIT ? OFFSET ?");
            pt = con.prepareStatement(sql.toString());
            int idx = 1;
            if (statusFilter != null) pt.setInt(idx++, statusFilter);
            if (search != null && !search.trim().isEmpty()) {
                String q = "%" + search.trim() + "%";
                pt.setString(idx++, q); pt.setString(idx++, q); pt.setString(idx++, q);
            }
            pt.setInt(idx++, size);
            pt.setInt(idx, page * size);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                for (int i = 1; i <= 12; i++) row.add(rs.getString(i));
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

    public String updateEnquiry(int id, int status, Integer isCalled, Integer callAnswered) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("UPDATE finance SET status=?, is_called=?, call_answered=? WHERE id=?");
            pt.setInt(1, status);
            if (isCalled != null) pt.setInt(2, isCalled); else pt.setNull(2, Types.INTEGER);
            if (callAnswered != null) pt.setInt(3, callAnswered); else pt.setInt(3, 0);
            pt.setInt(4, id);
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

    public String getContactPhone() throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT config_value FROM contact_config WHERE config_key='customer_support_phone' AND is_active=1 LIMIT 1");
            rs = pt.executeQuery();
            String phone = "";
            if (rs.next() && rs.getString(1) != null) phone = rs.getString(1);
            con.commit();
            return phone;
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
    }
}
