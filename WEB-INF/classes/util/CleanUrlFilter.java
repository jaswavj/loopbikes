package util;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CleanUrlFilter implements Filter {

    public void init(FilterConfig config) {}

    public void destroy() {}

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.length() > contextPath.length()
                ? uri.substring(contextPath.length())
                : "/";
        if (path.isEmpty()) path = "/";

        String qs = request.getQueryString();
        String query = qs != null && qs.length() > 0 ? "?" + qs : "";

        if (isExcluded(path)) {
            chain.doFilter(req, res);
            return;
        }

        if (path.endsWith(".jsp") && isRedirectMethod(request.getMethod())) {
            String clean = path.substring(0, path.length() - 4);
            if (clean.equals("/index") || clean.length() == 0) clean = "/";
            response.sendRedirect(contextPath + clean + query);
            return;
        }

        if (!path.contains(".")) {
            String jspPath = toJspPath(path);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        chain.doFilter(req, res);
    }

    private boolean isRedirectMethod(String method) {
        return "GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method);
    }

    private boolean isExcluded(String path) {
        return path.startsWith("/assets/")
                || path.startsWith("/uploadImages/")
                || path.equals("/upload")
                || path.startsWith("/WEB-INF/")
                || path.equals("/robots.txt");
    }

    private String toJspPath(String path) {
        if (path.equals("/") || path.equals("/index")) return "/index.jsp";
        return path + ".jsp";
    }
}
