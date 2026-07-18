package util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public final class DBConnectionManager {
    private static DBConnectionManager manager = new DBConnectionManager();
    private DataSource ds;

    private DBConnectionManager() {
        try {
            Context initCtx = new InitialContext();
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            ds = (DataSource) envCtx.lookup("jdbc/loopbikesdb");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnectionFromPool() throws SQLException {
        Connection con = manager.ds.getConnection();
        con.setAutoCommit(false);
        return con;
    }
}
