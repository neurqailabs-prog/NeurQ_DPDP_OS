package com.neurq.licensing;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for LicenseManager
 */
public class LicenseManagerTest {
    
    @Test
    void testValidateLicense() {
        LicenseManager manager = new LicenseManager();
        LicenseManager.LicenseValidationResult result = manager.validateLicense();
        
        // Should have a trial license by default
        assertNotNull(result);
    }
    
    @Test
    void testCalculatePricing() {
        LicenseManager manager = new LicenseManager();
        
        LicenseManager.UsageMetrics metrics = new LicenseManager.UsageMetrics();
        metrics.setDataPrincipalCount(1000);
        
        LicenseManager.PricingCalculation calculation = 
            manager.calculatePricing("QS-DPDP-CORE", metrics);
        
        assertNotNull(calculation);
        assertTrue(calculation.getFinalPrice() > 0);
    }
    
    @Test
    void testSimulatePricing() {
        LicenseManager manager = new LicenseManager();
        
        LicenseManager.UsageMetrics metrics = new LicenseManager.UsageMetrics();
        metrics.setUserCount(500);
        
        LicenseManager.PricingCalculation calculation = 
            manager.simulatePricing("QS-DPDP-CORE", metrics);
        
        assertNotNull(calculation);
    }
}
