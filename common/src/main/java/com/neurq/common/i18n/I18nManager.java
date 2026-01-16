package com.neurq.common.i18n;

import java.util.*;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.text.MessageFormat;
import java.util.PropertyResourceBundle;

/**
 * Multilingual Support for 22 Indian Languages
 */
public class I18nManager {
    private static final String[] INDIAN_LANGUAGES = {
        "hi", "en", "bn", "te", "mr", "ta", "ur", "gu", "kn", "or", 
        "pa", "ml", "as", "ne", "mai", "sa", "sd", "ks", "kok", "mni", "doi", "sat"
    };
    
    private static final Map<String, ResourceBundle> bundles = new HashMap<>();
    private static Locale currentLocale = Locale.ENGLISH;
    
    static {
        loadBundles();
    }
    
    private static void loadBundles() {
        for (String lang : INDIAN_LANGUAGES) {
            try {
                Locale locale = new Locale(lang);
                ResourceBundle bundle = ResourceBundle.getBundle("messages", locale, 
                    new ResourceBundle.Control() {
                        @Override
                        public ResourceBundle newBundle(String baseName, Locale locale, 
                                String format, ClassLoader loader, boolean reload) 
                                throws IllegalAccessException, InstantiationException, 
                                java.io.IOException {
                            String bundleName = toBundleName(baseName, locale);
                            String resourceName = toResourceName(bundleName, "properties");
                            InputStream stream = loader.getResourceAsStream(resourceName);
                            if (stream != null) {
                                try (InputStreamReader reader = new InputStreamReader(stream, StandardCharsets.UTF_8)) {
                                    return new PropertyResourceBundle(reader);
                                }
                            }
                            return null;
                        }
                    });
                bundles.put(lang, bundle);
            } catch (Exception e) {
                System.err.println("Failed to load bundle for " + lang + ": " + e.getMessage());
            }
        }
    }
    
    public static void setLocale(String languageCode) {
        currentLocale = new Locale(languageCode);
    }
    
    public static String translate(String key, Object... args) {
        String lang = currentLocale.getLanguage();
        ResourceBundle bundle = bundles.getOrDefault(lang, bundles.get("en"));
        
        if (bundle == null) {
            return key;
        }
        
        try {
            String pattern = bundle.getString(key);
            return args.length > 0 ? MessageFormat.format(pattern, args) : pattern;
        } catch (MissingResourceException e) {
            return key;
        }
    }
    
    public static String[] getSupportedLanguages() {
        return INDIAN_LANGUAGES.clone();
    }
    
    public static Locale getCurrentLocale() {
        return currentLocale;
    }
}
