package com.neurq.dpdp.core;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for ConsentManager
 */
public class ConsentManagerTest {
    private ConsentManager consentManager;
    private MockConsentRepository repository;
    
    @BeforeEach
    void setUp() {
        repository = new MockConsentRepository();
        consentManager = new ConsentManager(repository);
    }
    
    @Test
    void testRecordConsent() {
        Consent consent = consentManager.recordConsent(
            "DP001", "Account Management", "FINANCIAL", 
            ConsentManager.ConsentType.LONG_TERM
        );
        
        assertNotNull(consent);
        assertEquals("DP001", consent.getDataPrincipalId());
        assertEquals(ConsentManager.ConsentStatus.ACTIVE, consent.getStatus());
    }
    
    @Test
    void testWithdrawConsent() {
        Consent consent = consentManager.recordConsent(
            "DP001", "Account Management", "FINANCIAL", 
            ConsentManager.ConsentType.LONG_TERM
        );
        
        consentManager.withdrawConsent(consent.getId(), "DP001");
        
        Consent updated = repository.findById(consent.getId());
        assertEquals(ConsentManager.ConsentStatus.WITHDRAWN, updated.getStatus());
    }
    
    @Test
    void testIsConsentValid() {
        consentManager.recordConsent(
            "DP001", "Account Management", "FINANCIAL", 
            ConsentManager.ConsentType.LONG_TERM
        );
        
        boolean valid = consentManager.isConsentValid(
            "DP001", "Account Management", "FINANCIAL"
        );
        
        assertTrue(valid);
    }
    
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
                .filter(c -> c.getDataPrincipalId().equals(dataPrincipalId) && 
                            c.getStatus() == ConsentManager.ConsentStatus.ACTIVE)
                .collect(java.util.stream.Collectors.toList());
        }
        
        @Override
        public java.util.List<ConsentManager.Consent> findByDataPrincipal(String dataPrincipalId) {
            return consents.values().stream()
                .filter(c -> c.getDataPrincipalId().equals(dataPrincipalId))
                .collect(java.util.stream.Collectors.toList());
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
}
