package util;

public final class SlugUtil {
    private SlugUtil() {}

    public static String createSlug(String brand, String model, int year, String regNo) {
        String slug = (brand + "-" + model + "-" + year + "-" + regNo)
                .toLowerCase()
                .replaceAll("[^a-z0-9]+", "-")
                .replaceAll("^-|-$", "");
        return slug.length() > 190 ? slug.substring(0, 190) : slug;
    }
}
