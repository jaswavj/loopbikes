package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

public class AppInitListener implements ServletContextListener {
    public void contextInitialized(ServletContextEvent event) {
        AppConfig.init(event.getServletContext());
    }

    public void contextDestroyed(ServletContextEvent event) {
    }
}
