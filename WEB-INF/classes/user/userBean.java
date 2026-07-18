package user;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;
import util.PasswordUtil;

public class userBean {

    public Vector getUserByPhone(String phone) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector row = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("SELECT id, phone_number, password, name, email, role, is_super_admin FROM users WHERE phone_number=?");
            pt.setString(1, phone);
            rs = pt.executeQuery();
            if (rs.next()) {
                row.add(rs.getString("id"));
                row.add(rs.getString("phone_number"));
                row.add(rs.getString("password"));
                row.add(rs.getString("name"));
                row.add(rs.getString("email"));
                row.add(rs.getString("role"));
                row.add(rs.getString("is_super_admin"));
            }
            con.commit();
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
        return row;
    }

    public boolean login(String phone, String password) throws Exception {
        Vector u = getUserByPhone(phone);
        if (u.isEmpty()) return false;
        return PasswordUtil.verify(password, u.get(2).toString());
    }

    public String register(String phone, String password, String name) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            Vector existing = getUserByPhone(phone);
            if (!existing.isEmpty()) return "Phone already registered";
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("INSERT INTO users (phone_number, password, name, is_phone_verified) VALUES (?,?,?,1)");
            pt.setString(1, phone);
            pt.setString(2, PasswordUtil.hashPassword(password));
            pt.setString(3, name);
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

    public Vector getAllUsers(int page, int size, String roleFilter) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        ResultSet rs = null;
        Vector data = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            String sql = "SELECT id, phone_number, name, email, role, is_super_admin, created_at FROM users";
            if (roleFilter != null && !roleFilter.isEmpty()) sql += " WHERE role=?";
            sql += " ORDER BY id DESC LIMIT ? OFFSET ?";
            pt = con.prepareStatement(sql);
            int idx = 1;
            if (roleFilter != null && !roleFilter.isEmpty()) pt.setString(idx++, roleFilter);
            pt.setInt(idx++, size);
            pt.setInt(idx, page * size);
            rs = pt.executeQuery();
            while (rs.next()) {
                Vector row = new Vector();
                row.add(rs.getString("id"));
                row.add(rs.getString("phone_number"));
                row.add(rs.getString("name"));
                row.add(rs.getString("email"));
                row.add(rs.getString("role"));
                row.add(rs.getString("is_super_admin"));
                row.add(rs.getString("created_at"));
                data.add(row);
            }
            con.commit();
        } catch (Exception e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (pt != null) pt.close();
            if (con != null) con.close();
        }
        return data;
    }

    public String grantAdmin(long userId) throws Exception {
        return updateRole(userId, "ADMIN");
    }

    public String revokeAdmin(long userId) throws Exception {
        return updateRole(userId, "USER");
    }

    private String updateRole(long userId, String role) throws Exception {
        Connection con = null;
        PreparedStatement pt = null;
        try {
            con = DBConnectionManager.getConnectionFromPool();
            pt = con.prepareStatement("UPDATE users SET role=?, is_super_admin=0 WHERE id=?");
            pt.setString(1, role);
            pt.setLong(2, userId);
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
}
