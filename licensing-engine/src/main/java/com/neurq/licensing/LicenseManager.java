package com.neurq.licensing;

import com.neurq.common.crypto.QuantumSafeCrypto;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.JsonNode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.Base64;

/**
 * Oracle-Style Licensing & Pricing Engine
 */
public class LicenseManager {
    private static final String LICENSE_FILE = "license.neurq";
    private static final String PRICING_POLICY_FILE = "pricing-policy.json";
    private static final String PRICING_HISTORY_DIR = "pricing-history";
    private static final byte[] NEURQ_ROOT_PUBLIC_KEY = loadRootPublicKey();
    
    public enum LicenseType {
        TRIAL(14, "Trial License - 14 days"),
        COMMERCIAL(365, "Commercial License - 1 year"),
        ENTERPRISE_SUITE(365, "Enterprise Suite License - 1 year"),
        GOVERNMENT_PSU(365, "Government/PSU License - 1 year"),
        AIR_GAPPED(-1, "Air-Gapped License - Perpetual");
        
        private final int validityDays;
        private final String description;
        
        LicenseType(int validityDays, String description) {
            this.validityDays = validityDays;
            this.description = description;
        }
        
        public int getValidityDays() { return validityDays; }
        public String getDescription() { return description; }
    }
    
    public enum PricingModel {
        PER_USER("Per User"),
        PER_DATA_PRINCIPAL("Per Data Principal"),
        PER_ENDPOINT("Per Endpoint"),
        PER_GB_PER_DAY("Per GB/day (SIEM)"),
        PER_TB_SCANNED("Per TB scanned (PII Scanner)"),
        FLAT_ENTERPRISE("Flat Enterprise");
        
        private final String displayName;
        
        PricingModel(String displayName) {
            this.displayName = displayName;
        }
        
        public String getDisplayName() { return displayName; }
    }
    
    private License currentLicense;
    private PricingPolicy currentPricingPolicy;
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    public LicenseManager() {
        loadLicense();
        loadPricingPolicy();
    }
    
    /**
     * Validate current license
     */
    public LicenseValidationResult validateLicense() {
        if (currentLicense == null) {
            return new LicenseValidationResult(false, "No license found", null);
        }
        
        // Verify cryptographic signature
        if (!verifyLicenseSignature(currentLicense)) {
            return new LicenseValidationResult(false, "License signature verification failed", null);
        }
        
        // Check expiration
        if (currentLicense.getType() != LicenseType.AIR_GAPPED) {
            if (currentLicense.getExpiryDate() != null && 
                currentLicense.getExpiryDate().isBefore(LocalDateTime.now())) {
                return new LicenseValidationResult(false, "License expired", currentLicense);
            }
        }
        
        // Check product activation
        if (!currentLicense.isProductActivated()) {
            return new LicenseValidationResult(false, "Product not activated", currentLicense);
        }
        
        return new LicenseValidationResult(true, "License valid", currentLicense);
    }
    
    /**
     * Calculate pricing based on usage metrics
     */
    public PricingCalculation calculatePricing(String productId, UsageMetrics metrics) {
        if (currentPricingPolicy == null) {
            throw new IllegalStateException("Pricing policy not loaded");
        }
        
        ProductPricing productPricing = currentPricingPolicy.getProductPricing(productId);
        if (productPricing == null) {
            throw new IllegalArgumentException("No pricing found for product: " + productId);
        }
        
        double basePrice = productPricing.getBasePrice();
        PricingModel model = productPricing.getModel();
        
        double totalPrice = 0.0;
        
        switch (model) {
            case PER_USER:
                totalPrice = basePrice * metrics.getUserCount();
                break;
            case PER_DATA_PRINCIPAL:
                totalPrice = basePrice * metrics.getDataPrincipalCount();
                break;
            case PER_ENDPOINT:
                totalPrice = basePrice * metrics.getEndpointCount();
                break;
            case PER_GB_PER_DAY:
                totalPrice = basePrice * metrics.getGbPerDay();
                break;
            case PER_TB_SCANNED:
                totalPrice = basePrice * metrics.getTbScanned();
                break;
            case FLAT_ENTERPRISE:
                totalPrice = basePrice;
                break;
        }
        
        // Apply discounts
        double discount = calculateDiscount(productPricing, metrics);
        double finalPrice = totalPrice * (1 - discount);
        
        return new PricingCalculation(totalPrice, discount, finalPrice, model, metrics);
    }
    
    /**
     * Load pricing policy (only accessible to NEURQ_SUPER_ADMIN)
     */
    public void loadPricingPolicy() {
        try {
            if (!Files.exists(Paths.get(PRICING_POLICY_FILE))) {
                currentPricingPolicy = createDefaultPricingPolicy();
                savePricingPolicy(currentPricingPolicy, "SYSTEM");
                return;
            }
            
            byte[] policyBytes = Files.readAllBytes(Paths.get(PRICING_POLICY_FILE));
            JsonNode policyJson = objectMapper.readTree(policyBytes);
            
            // Verify signature
            byte[] signature = Base64.getDecoder().decode(policyJson.get("signature").asText());
            byte[] policyData = objectMapper.writeValueAsBytes(policyJson.get("policy"));
            
            if (!QuantumSafeCrypto.verify(policyData, signature, NEURQ_ROOT_PUBLIC_KEY)) {
                throw new SecurityException("Pricing policy signature verification failed");
            }
            
            currentPricingPolicy = objectMapper.treeToValue(policyJson.get("policy"), PricingPolicy.class);
        } catch (Exception e) {
            throw new RuntimeException("Failed to load pricing policy", e);
        }
    }
    
    /**
     * Save pricing policy (only by NEURQ_SUPER_ADMIN)
     */
    public void savePricingPolicy(PricingPolicy policy, String adminRole) {
        if (!"NEURQ_SUPER_ADMIN".equals(adminRole) && !"SYSTEM".equals(adminRole)) {
            throw new SecurityException("Only NEURQ_SUPER_ADMIN can modify pricing policy");
        }
        
        try {
            // Sign the policy
            byte[] policyBytes = objectMapper.writeValueAsBytes(policy);
            byte[] signature = QuantumSafeCrypto.sign(policyBytes, loadRootPrivateKey());
            
            Map<String, Object> signedPolicy = new HashMap<>();
            signedPolicy.put("policy", policy);
            signedPolicy.put("signature", Base64.getEncoder().encodeToString(signature));
            signedPolicy.put("version", policy.getVersion());
            signedPolicy.put("effectiveDate", policy.getEffectiveDate().toString());
            signedPolicy.put("lastModified", LocalDateTime.now().toString());
            signedPolicy.put("modifiedBy", adminRole);
            
            // Save to versioned history
            savePricingPolicyHistory(signedPolicy);
            
            // Save current
            Files.write(Paths.get(PRICING_POLICY_FILE), 
                objectMapper.writeValueAsBytes(signedPolicy),
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING);
            
            currentPricingPolicy = policy;
        } catch (Exception e) {
            throw new RuntimeException("Failed to save pricing policy", e);
        }
    }
    
    /**
     * Simulation mode for demos
     */
    public PricingCalculation simulatePricing(String productId, UsageMetrics metrics) {
        return calculatePricing(productId, metrics);
    }
    
    private boolean verifyLicenseSignature(License license) {
        try {
            byte[] licenseData = objectMapper.writeValueAsBytes(license.getLicenseData());
            byte[] signature = license.getSignature();
            return QuantumSafeCrypto.verify(licenseData, signature, NEURQ_ROOT_PUBLIC_KEY);
        } catch (Exception e) {
            return false;
        }
    }
    
    private double calculateDiscount(ProductPricing pricing, UsageMetrics metrics) {
        // Volume discounts, enterprise discounts, etc.
        if (metrics.getUserCount() > 1000) {
            return 0.15; // 15% discount for 1000+ users
        }
        if (metrics.getDataPrincipalCount() > 100000) {
            return 0.20; // 20% discount for 100K+ data principals
        }
        return 0.0;
    }
    
    private PricingPolicy createDefaultPricingPolicy() {
        PricingPolicy policy = new PricingPolicy();
        policy.setVersion("1.0.0");
        policy.setEffectiveDate(LocalDateTime.now());
        
        // QS-DPDP Core pricing
        ProductPricing dpdpPricing = new ProductPricing();
        dpdpPricing.setProductId("QS-DPDP-CORE");
        dpdpPricing.setModel(PricingModel.PER_DATA_PRINCIPAL);
        dpdpPricing.setBasePrice(0.50); // ₹0.50 per data principal
        policy.addProductPricing(dpdpPricing);
        
        // QS-SIEM pricing
        ProductPricing siemPricing = new ProductPricing();
        siemPricing.setProductId("QS-SIEM");
        siemPricing.setModel(PricingModel.PER_GB_PER_DAY);
        siemPricing.setBasePrice(100.0); // ₹100 per GB/day
        policy.addProductPricing(siemPricing);
        
        // QS-DLP pricing
        ProductPricing dlpPricing = new ProductPricing();
        dlpPricing.setProductId("QS-DLP");
        dlpPricing.setModel(PricingModel.PER_ENDPOINT);
        dlpPricing.setBasePrice(5000.0); // ₹5000 per endpoint
        policy.addProductPricing(dlpPricing);
        
        // QS-PII Scanner pricing
        ProductPricing piiPricing = new ProductPricing();
        piiPricing.setProductId("QS-PII-SCANNER");
        piiPricing.setModel(PricingModel.PER_TB_SCANNED);
        piiPricing.setBasePrice(500.0); // ₹500 per TB scanned
        policy.addProductPricing(piiPricing);
        
        // Policy Engine pricing
        ProductPricing policyPricing = new ProductPricing();
        policyPricing.setProductId("POLICY-ENGINE");
        policyPricing.setModel(PricingModel.FLAT_ENTERPRISE);
        policyPricing.setBasePrice(500000.0); // ₹5L flat
        policy.addProductPricing(policyPricing);
        
        return policy;
    }
    
    private void loadLicense() {
        try {
            if (Files.exists(Paths.get(LICENSE_FILE))) {
                byte[] licenseBytes = Files.readAllBytes(Paths.get(LICENSE_FILE));
                currentLicense = objectMapper.readValue(licenseBytes, License.class);
            } else {
                // Create trial license
                currentLicense = createTrialLicense();
            }
        } catch (Exception e) {
            System.err.println("Failed to load license: " + e.getMessage());
            currentLicense = createTrialLicense();
        }
    }
    
    private License createTrialLicense() {
        License license = new License();
        license.setType(LicenseType.TRIAL);
        license.setIssueDate(LocalDateTime.now());
        license.setExpiryDate(LocalDateTime.now().plusDays(14));
        license.setProductId("QS-DPDP-OS");
        license.setProductActivated(true);
        license.setLicenseData(new HashMap<>());
        license.setSignature(new byte[0]); // Placeholder
        return license;
    }
    
    private static byte[] loadRootPublicKey() {
        // Load NeurQ root public key (embedded in application)
        // In production, this would be loaded from secure storage
        return new byte[1024]; // Placeholder - actual key would be 1024+ bytes
    }
    
    private byte[] loadRootPrivateKey() {
        // Load NeurQ root private key (only on NeurQ servers)
        // This should NEVER be in client code
        return new byte[1024]; // Placeholder
    }
    
    private void savePricingPolicyHistory(Map<String, Object> signedPolicy) {
        try {
            Files.createDirectories(Paths.get(PRICING_HISTORY_DIR));
            String version = (String) signedPolicy.get("version");
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
            String historyFile = String.format("%s/pricing-policy-v%s-%s.json", 
                PRICING_HISTORY_DIR, version, timestamp);
            Files.write(Paths.get(historyFile), 
                objectMapper.writeValueAsBytes(signedPolicy));
        } catch (Exception e) {
            System.err.println("Failed to save pricing history: " + e.getMessage());
        }
    }
    
    // Inner classes
    public static class License {
        private LicenseType type;
        private LocalDateTime issueDate;
        private LocalDateTime expiryDate;
        private String productId;
        private boolean productActivated;
        private byte[] signature;
        private Map<String, Object> licenseData;
        
        // Getters and setters
        public LicenseType getType() { return type; }
        public void setType(LicenseType type) { this.type = type; }
        public LocalDateTime getExpiryDate() { return expiryDate; }
        public void setExpiryDate(LocalDateTime expiryDate) { this.expiryDate = expiryDate; }
        public boolean isProductActivated() { return productActivated; }
        public void setProductActivated(boolean productActivated) { this.productActivated = productActivated; }
        public byte[] getSignature() { return signature; }
        public void setSignature(byte[] signature) { this.signature = signature; }
        public Map<String, Object> getLicenseData() { return licenseData; }
        public void setLicenseData(Map<String, Object> licenseData) { this.licenseData = licenseData; }
        public LocalDateTime getIssueDate() { return issueDate; }
        public void setIssueDate(LocalDateTime issueDate) { this.issueDate = issueDate; }
        public String getProductId() { return productId; }
        public void setProductId(String productId) { this.productId = productId; }
    }
    
    public static class LicenseValidationResult {
        private final boolean valid;
        private final String message;
        private final License license;
        
        public LicenseValidationResult(boolean valid, String message, License license) {
            this.valid = valid;
            this.message = message;
            this.license = license;
        }
        
        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
        public License getLicense() { return license; }
    }
    
    public static class PricingPolicy {
        private String version;
        private LocalDateTime effectiveDate;
        private Map<String, ProductPricing> productPricings = new HashMap<>();
        
        public void addProductPricing(ProductPricing pricing) {
            productPricings.put(pricing.getProductId(), pricing);
        }
        
        public ProductPricing getProductPricing(String productId) {
            return productPricings.get(productId);
        }
        
        // Getters and setters
        public String getVersion() { return version; }
        public void setVersion(String version) { this.version = version; }
        public LocalDateTime getEffectiveDate() { return effectiveDate; }
        public void setEffectiveDate(LocalDateTime effectiveDate) { this.effectiveDate = effectiveDate; }
    }
    
    public static class ProductPricing {
        private String productId;
        private PricingModel model;
        private double basePrice;
        
        // Getters and setters
        public String getProductId() { return productId; }
        public void setProductId(String productId) { this.productId = productId; }
        public PricingModel getModel() { return model; }
        public void setModel(PricingModel model) { this.model = model; }
        public double getBasePrice() { return basePrice; }
        public void setBasePrice(double basePrice) { this.basePrice = basePrice; }
    }
    
    public static class UsageMetrics {
        private int userCount;
        private int dataPrincipalCount;
        private int endpointCount;
        private double gbPerDay;
        private double tbScanned;
        
        // Getters and setters
        public int getUserCount() { return userCount; }
        public void setUserCount(int userCount) { this.userCount = userCount; }
        public int getDataPrincipalCount() { return dataPrincipalCount; }
        public void setDataPrincipalCount(int dataPrincipalCount) { this.dataPrincipalCount = dataPrincipalCount; }
        public int getEndpointCount() { return endpointCount; }
        public void setEndpointCount(int endpointCount) { this.endpointCount = endpointCount; }
        public double getGbPerDay() { return gbPerDay; }
        public void setGbPerDay(double gbPerDay) { this.gbPerDay = gbPerDay; }
        public double getTbScanned() { return tbScanned; }
        public void setTbScanned(double tbScanned) { this.tbScanned = tbScanned; }
    }
    
    public static class PricingCalculation {
        private final double basePrice;
        private final double discount;
        private final double finalPrice;
        private final PricingModel model;
        private final UsageMetrics metrics;
        
        public PricingCalculation(double basePrice, double discount, double finalPrice, 
                                 PricingModel model, UsageMetrics metrics) {
            this.basePrice = basePrice;
            this.discount = discount;
            this.finalPrice = finalPrice;
            this.model = model;
            this.metrics = metrics;
        }
        
        // Getters
        public double getBasePrice() { return basePrice; }
        public double getDiscount() { return discount; }
        public double getFinalPrice() { return finalPrice; }
        public PricingModel getModel() { return model; }
        public UsageMetrics getMetrics() { return metrics; }
    }
}
