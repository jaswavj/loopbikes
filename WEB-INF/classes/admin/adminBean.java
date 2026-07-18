package admin;

import java.sql.*;
import java.util.Vector;
import util.DBConnectionManager;

public class adminBean {

    public Vector getDashboardStats() throws Exception {
        Connection con = null;
        Statement st = null;
        ResultSet rs = null;
        Vector stats = new Vector();
        try {
            con = DBConnectionManager.getConnectionFromPool();
            st = con.createStatement();

            stats.add(count(st, "SELECT COUNT(*) FROM bikes"));
            stats.add(count(st, "SELECT COUNT(*) FROM bikes WHERE status=0"));
            stats.add(count(st, "SELECT COUNT(*) FROM bikes WHERE status=2"));
            stats.add(count(st, "SELECT COUNT(*) FROM user_bike_sell_requests WHERE status=0"));
            stats.add(count(st, "SELECT COUNT(*) FROM user_bike_sell_requests WHERE status=2"));
            stats.add(count(st, "SELECT COUNT(*) FROM finance WHERE status=0"));
            stats.add(revenue(st, "SELECT COALESCE(SUM(sold_price),0) FROM bikes WHERE status=2"));
            stats.add(count(st, "SELECT COUNT(*) FROM bikes WHERE status=2 AND MONTH(sold_date)=MONTH(CURRENT_DATE())"));

            con.commit();
        } finally {
            if (rs != null) rs.close();
            if (st != null) st.close();
            if (con != null) con.close();
        }
        return stats;
    }

    private String count(Statement st, String sql) throws SQLException {
        ResultSet rs = st.executeQuery(sql);
        String val = "0";
        if (rs.next()) val = rs.getString(1);
        rs.close();
        return val;
    }

    private String revenue(Statement st, String sql) throws SQLException {
        ResultSet rs = st.executeQuery(sql);
        String val = "0";
        if (rs.next()) val = rs.getString(1);
        rs.close();
        return val;
    }
}
