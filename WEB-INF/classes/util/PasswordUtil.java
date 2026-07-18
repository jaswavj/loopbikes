package util;

public final class PasswordUtil {
    private PasswordUtil() {}

    public static String hashPassword(String password) throws Exception {
        java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-512");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public static boolean verify(String plain, String hashed) throws Exception {
        if (plain == null || hashed == null) return false;
        return hashPassword(plain).equals(hashed);
    }
}
