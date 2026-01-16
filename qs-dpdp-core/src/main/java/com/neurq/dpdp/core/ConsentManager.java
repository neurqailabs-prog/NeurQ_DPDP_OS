package com.neurq.dpdp.core;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Consent Lifecycle Management (DPDP Act Section 6-7)
 */
public class ConsentManager {
    private final ConsentRepository repository;
    
    public ConsentManager(ConsentRepository repository) {
        this.repository = repository;
    }
    
    /**
     * Record consent from data principal
     */
    public Consent recordConsent(String dataPrincipalId, String purpose, 
                                String dataCategory, ConsentType type) {
        Consent consent = new Consent();
        consent.setId(UUID.randomUUID().toString());
        consent.setDataPrincipalId(dataPrincipalId);
        consent.setPurpose(purpose);
        consent.setDataCategory(dataCategory);
        consent.setType(type);
        consent.setStatus(ConsentStatus.ACTIVE);
        consent.setGivenAt(LocalDateTime.now());
        consent.setExpiryDate(calculateExpiryDate(type));
        
        repository.save(consent);
        return consent;
    }
    
    /**
     * Withdraw consent (Section 7)
     */
    public void withdrawConsent(String consentId, String dataPrincipalId) {
        Consent consent = repository.findById(consentId);
        if (consent == null || !consent.getDataPrincipalId().equals(dataPrincipalId)) {
            throw new IllegalArgumentException("Consent not found or unauthorized");
        }
        
        consent.setStatus(ConsentStatus.WITHDRAWN);
        consent.setWithdrawnAt(LocalDateTime.now());
        repository.update(consent);
        
        // Trigger data deletion workflow
        triggerDataDeletion(consent);
    }
    
    /**
     * Verify consent validity
     */
    public boolean isConsentValid(String dataPrincipalId, String purpose, String dataCategory) {
        List<Consent> consents = repository.findActiveByDataPrincipal(dataPrincipalId);
        return consents.stream()
            .anyMatch(c -> c.getPurpose().equals(purpose) && 
                          c.getDataCategory().equals(dataCategory) &&
                          c.getStatus() == ConsentStatus.ACTIVE &&
                          (c.getExpiryDate() == null || c.getExpiryDate().isAfter(LocalDateTime.now())));
    }
    
    /**
     * Get all consents for a data principal
     */
    public List<Consent> getConsents(String dataPrincipalId) {
        return repository.findByDataPrincipal(dataPrincipalId);
    }
    
    /**
     * Check for expired consents
     */
    public List<Consent> checkExpiredConsents() {
        List<Consent> allConsents = repository.findAll();
        LocalDateTime now = LocalDateTime.now();
        return allConsents.stream()
            .filter(c -> c.getStatus() == ConsentStatus.ACTIVE && 
                        c.getExpiryDate() != null && 
                        c.getExpiryDate().isBefore(now))
            .collect(Collectors.toList());
    }
    
    /**
     * Expire consent
     */
    public void expireConsent(String consentId) {
        Consent consent = repository.findById(consentId);
        if (consent != null) {
            consent.setStatus(ConsentStatus.EXPIRED);
            repository.update(consent);
            triggerDataDeletion(consent);
        }
    }
    
    private LocalDateTime calculateExpiryDate(ConsentType type) {
        switch (type) {
            case ONE_TIME:
                return LocalDateTime.now().plusDays(1);
            case SHORT_TERM:
                return LocalDateTime.now().plusMonths(6);
            case LONG_TERM:
                return LocalDateTime.now().plusYears(5);
            case PERPETUAL:
                return null;
            default:
                return LocalDateTime.now().plusYears(1);
        }
    }
    
    private void triggerDataDeletion(Consent consent) {
        // Trigger DLP and PII Scanner to delete data
        // This would integrate with QS-DLP and QS-PII-Scanner modules
        System.out.println("Triggering data deletion for consent: " + consent.getId());
    }
    
    public enum ConsentType {
        ONE_TIME, SHORT_TERM, LONG_TERM, PERPETUAL
    }
    
    public enum ConsentStatus {
        ACTIVE, WITHDRAWN, EXPIRED, REVOKED
    }
    
    public static class Consent {
        private String id;
        private String dataPrincipalId;
        private String purpose;
        private String dataCategory;
        private ConsentType type;
        private ConsentStatus status;
        private LocalDateTime givenAt;
        private LocalDateTime expiryDate;
        private LocalDateTime withdrawnAt;
        
        // Getters and setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getDataPrincipalId() { return dataPrincipalId; }
        public void setDataPrincipalId(String dataPrincipalId) { this.dataPrincipalId = dataPrincipalId; }
        public String getPurpose() { return purpose; }
        public void setPurpose(String purpose) { this.purpose = purpose; }
        public String getDataCategory() { return dataCategory; }
        public void setDataCategory(String dataCategory) { this.dataCategory = dataCategory; }
        public ConsentType getType() { return type; }
        public void setType(ConsentType type) { this.type = type; }
        public ConsentStatus getStatus() { return status; }
        public void setStatus(ConsentStatus status) { this.status = status; }
        public LocalDateTime getGivenAt() { return givenAt; }
        public void setGivenAt(LocalDateTime givenAt) { this.givenAt = givenAt; }
        public LocalDateTime getExpiryDate() { return expiryDate; }
        public void setExpiryDate(LocalDateTime expiryDate) { this.expiryDate = expiryDate; }
        public LocalDateTime getWithdrawnAt() { return withdrawnAt; }
        public void setWithdrawnAt(LocalDateTime withdrawnAt) { this.withdrawnAt = withdrawnAt; }
    }
    
    public interface ConsentRepository {
        void save(Consent consent);
        Consent findById(String id);
        List<Consent> findActiveByDataPrincipal(String dataPrincipalId);
        List<Consent> findByDataPrincipal(String dataPrincipalId);
        List<Consent> findAll();
        void update(Consent consent);
    }
}
