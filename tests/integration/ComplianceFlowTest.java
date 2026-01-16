package com.neurq.dpdp.core;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Integration tests for complete compliance flow
 */
public class ComplianceFlowTest {
    
    @Test
    void testCompleteComplianceFlow() {
        // 1. Record consent
        ConsentManager consentManager = new ConsentManager(new MockConsentRepository());
        ConsentManager.Consent consent = consentManager.recordConsent(
            "DP001", "Account Management", "FINANCIAL", 
            ConsentManager.ConsentType.LONG_TERM
        );
        assertNotNull(consent);
        
        // 2. Verify consent validity
        boolean valid = consentManager.isConsentValid(
            "DP001", "Account Management", "FINANCIAL"
        );
        assertTrue(valid);
        
        // 3. Report breach
        BreachNotificationManager breachManager = 
            new BreachNotificationManager(new MockBreachRepository());
        
        BreachNotificationManager.BreachIncident incident = 
            new BreachNotificationManager.BreachIncident();
        incident.setDescription("Test breach");
        incident.getAffectedDataPrincipals().add("DP001");
        incident.getAffectedDataCategories().add("FINANCIAL");
        incident.setRootCause("Test");
        incident.getRemediationSteps().add("Fix applied");
        
        BreachNotificationManager.BreachNotificationResponse response = 
            breachManager.notifyBreach(incident);
        
        assertNotNull(response);
        assertNotNull(response.getSlaDeadline());
        
        // 4. Calculate compliance score
        ComplianceScoringEngine scoringEngine = 
            new ComplianceScoringEngine(new MockComplianceRepository());
        
        ComplianceScoringEngine.ComplianceScore score = 
            scoringEngine.calculateComplianceScore("ORG001");
        
        assertNotNull(score);
        assertTrue(score.getOverallScore() >= 0 && score.getOverallScore() <= 100);
    }
    
    // Mock repositories (simplified)
    private static class MockConsentRepository implements ConsentManager.ConsentRepository {
        private java.util.Map<String, ConsentManager.Consent> consents = new java.util.HashMap<>();
        
        @Override
        public void save(ConsentManager.Consent consent) {
            consents.put(consent.getId(), consent);
        }
        
        @Override
        public ConsentManager.Consent findById(String id) {
            return consents.get(id);
        }
        
        @Override
        public java.util.List<ConsentManager.Consent> findActiveByDataPrincipal(String dataPrincipalId) {
            return consents.values().stream()
                .filter(c -> c.getDataPrincipalId().equals(dataPrincipalId))
                .collect(java.util.stream.Collectors.toList());
        }
        
        @Override
        public java.util.List<ConsentManager.Consent> findByDataPrincipal(String dataPrincipalId) {
            return findActiveByDataPrincipal(dataPrincipalId);
        }
        
        @Override
        public java.util.List<ConsentManager.Consent> findAll() {
            return new java.util.ArrayList<>(consents.values());
        }
        
        @Override
        public void update(ConsentManager.Consent consent) {
            consents.put(consent.getId(), consent);
        }
    }
    
    private static class MockBreachRepository implements BreachNotificationManager.BreachRepository {
        private java.util.Map<String, BreachNotificationManager.BreachIncident> incidents = 
            new java.util.HashMap<>();
        
        @Override
        public void save(BreachNotificationManager.BreachIncident incident) {
            incidents.put(incident.getId(), incident);
        }
        
        @Override
        public BreachNotificationManager.BreachIncident findById(String id) {
            return incidents.get(id);
        }
        
        @Override
        public void update(BreachNotificationManager.BreachIncident incident) {
            incidents.put(incident.getId(), incident);
        }
    }
    
    private static class MockComplianceRepository implements ComplianceScoringEngine.ComplianceRepository {
        @Override
        public boolean hasConsentRecorded(String orgId) { return true; }
        @Override
        public boolean hasWithdrawalMechanism(String orgId) { return true; }
        @Override
        public boolean hasExpiryManagement(String orgId) { return true; }
        @Override
        public boolean hasConsentAuditTrail(String orgId) { return true; }
        @Override
        public boolean hasPurposeLimitation(String orgId) { return true; }
        @Override
        public boolean hasDataMinimization(String orgId) { return true; }
        @Override
        public boolean hasStorageLimitation(String orgId) { return true; }
        @Override
        public boolean hasBreachDetection(String orgId) { return true; }
        @Override
        public boolean has72HourNotification(String orgId) { return true; }
        @Override
        public boolean hasBreachRemediation(String orgId) { return true; }
        @Override
        public boolean hasAccessRight(String orgId) { return true; }
        @Override
        public boolean hasCorrectionRight(String orgId) { return true; }
        @Override
        public boolean hasErasureRight(String orgId) { return true; }
        @Override
        public boolean hasGrievanceRight(String orgId) { return true; }
        @Override
        public boolean hasPortabilityRight(String orgId) { return true; }
        @Override
        public boolean hasSdfIdentification(String orgId) { return true; }
        @Override
        public boolean hasDpo(String orgId) { return true; }
        @Override
        public boolean hasDataAudit(String orgId) { return true; }
        @Override
        public boolean hasImpactAssessment(String orgId) { return true; }
    }
}
