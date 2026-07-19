package util;

import java.io.File;
import jakarta.servlet.ServletContext;

public final class AppConfig {
    private static String uploadDir;

    public static final String SITE_NAME = "LoopBikes";
    public static final String SITE_TAGLINE = "Buy, Sell & Finance Second Hand Bikes";
    public static final String SEO_KEYWORDS = "second hand bike, resale bike, used bike, Nagercoil, Tirunelveli, Tuticorin, Kanyakumari, bike finance, pre owned bike, two wheeler";
    public static final String SEO_LOCATIONS = "Nagercoil, Tirunelveli, Tuticorin, Kanyakumari, Marthandam, Tenkasi, Kovilpatti";

    private AppConfig() {}

    public static void init(ServletContext ctx) {
        String configured = ctx.getInitParameter("uploadDir");
        File dir;

        if (configured != null && configured.trim().length() > 0) {
            dir = new File(configured.trim());
            if (!dir.isAbsolute()) {
                String realPath = ctx.getRealPath("/");
                if (realPath != null) {
                    dir = new File(new File(realPath).getParentFile(), configured.trim());
                }
            }
        } else {
            String realPath = ctx.getRealPath("/");
            if (realPath == null) {
                throw new IllegalStateException("Cannot resolve webapp path for uploadImages folder.");
            }
            dir = new File(new File(realPath).getParentFile(), "uploadImages");
        }

        uploadDir = dir.getAbsolutePath();
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    public static String getUploadDir() {
        if (uploadDir == null) {
            throw new IllegalStateException("Upload directory not initialized. Restart the application.");
        }
        return uploadDir;
    }
}
