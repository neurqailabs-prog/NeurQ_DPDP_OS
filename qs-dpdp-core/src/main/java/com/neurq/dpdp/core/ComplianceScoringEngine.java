package com.neurq.dpdp.core;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Compliance Scoring Engine (0-100%)
 */
public class ComplianceScoringEngine {
    private final ComplianceRepository repository;
    
    public ComplianceScoringEngine(ComplianceRepository repository) {
        this.repository = repository;
    }
    
    /**
     * Calculate overall compliance score
     */
    public ComplianceScore calculateComplianceScore(String organizationId) {
        ComplianceScore score = new ComplianceScore();
        score.setOrganizationId(organizationId);
        score.setCalculatedAt(java.time.LocalDateTime.now());
        
        // Section-wise scoring
        Map<String, Double> sectionScores = new HashMap<>();
        
        // Section 6-7: Consent Management
        sectionScores.put("CONSENT_MANAGEMENT", scoreConsentManagement(organizationId));
        
        // Section 8: Data Fiduciary Obligations
        sectionScores.put("DATA_FIDUCIARY_OBLIGATIONS", scoreDataFiduciaryObligations(organizationId));
        
        // Section 9: Breach Notification
        sectionScores.put("BREACH_NOTIFICATION", scoreBreachNotification(organizationId));
        
        // Section 11-15: Data Principal Rights
        sectionScores.put("DATA_PRINCIPAL_RIGHTS", scoreDataPrincipalRights(organizationId));
        
        // Section 10: Significant Data Fiduciary
        sectionScores.put("SDF_ASSESSMENT", scoreSdfAssessment(organizationId));
        
        // Calculate weighted average
        double overallScore = calculateWeightedAverage(sectionScores);
        score.setOverallScore(overallScore);
        score.setSectionScores(sectionScores);
        score.setGrade(determineGrade(overallScore));
        score.setRecommendations(generateRecommendations(sectionScores));
        
        return score;
    }
    
    private double scoreConsentManagement(String organizationId) {
        // Check consent recording, withdrawal, expiry management
        double score = 0.0;
        
        // Consent recorded: 30%
        if (hasConsentRecorded(organizationId)) {
            score += 30.0;
        }
        
        // Consent withdrawal mechanism: 25%
        if (hasWithdrawalMechanism(organizationId)) {
            score += 25.0;
        }
        
        // Consent expiry management: 20%
        if (hasExpiryManagement(organizationId)) {
            score += 20.0;
        }
        
        // Consent audit trail: 25%
        if (hasConsentAuditTrail(organizationId)) {
            score += 25.0;
        }
        
        return score;
    }
    
    private double scoreDataFiduciaryObligations(String organizationId) {
        // Check purpose limitation, data minimization, storage limitation
        double score = 0.0;
        
        // Purpose limitation: 35%
        if (hasPurposeLimitation(organizationId)) {
            score += 35.0;
        }
        
        // Data minimization: 30%
        if (hasDataMinimization(organizationId)) {
            score += 30.0;
        }
        
        // Storage limitation: 35%
        if (hasStorageLimitation(organizationId)) {
            score += 35.0;
        }
        
        return score;
    }
    
    private double scoreBreachNotification(String organizationId) {
        // Check 72-hour SLA compliance
        double score = 0.0;
        
        // Breach detection: 30%
        if (hasBreachDetection(organizationId)) {
            score += 30.0;
        }
        
        // 72-hour notification: 40%
        if (has72HourNotification(organizationId)) {
            score += 40.0;
        }
        
        // Breach remediation: 30%
        if (hasBreachRemediation(organizationId)) {
            score += 30.0;
        }
        
        return score;
    }
    
    private double scoreDataPrincipalRights(String organizationId) {
        // Check rights implementation
        double score = 0.0;
        
        // Right to access: 20%
        if (hasAccessRight(organizationId)) {
            score += 20.0;
        }
        
        // Right to correction: 20%
        if (hasCorrectionRight(organizationId)) {
            score += 20.0;
        }
        
        // Right to erasure: 20%
        if (hasErasureRight(organizationId)) {
            score += 20.0;
        }
        
        // Right to grievance: 20%
        if (hasGrievanceRight(organizationId)) {
            score += 20.0;
        }
        
        // Right to portability: 20%
        if (hasPortabilityRight(organizationId)) {
            score += 20.0;
        }
        
        return score;
    }
    
    private double scoreSdfAssessment(String organizationId) {
        // Check SDF criteria and obligations
        double score = 0.0;
        
        // SDF identification: 25%
        if (hasSdfIdentification(organizationId)) {
            score += 25.0;
        }
        
        // Data Protection Officer: 25%
        if (hasDpo(organizationId)) {
            score += 25.0;
        }
        
        // Data audit: 25%
        if (hasDataAudit(organizationId)) {
            score += 25.0;
        }
        
        // Impact assessment: 25%
        if (hasImpactAssessment(organizationId)) {
            score += 25.0;
        }
        
        return score;
    }
    
    private double calculateWeightedAverage(Map<String, Double> sectionScores) {
        // Weighted average (all sections equally weighted for now)
        return sectionScores.values().stream()
            .mapToDouble(Double::doubleValue)
            .average()
            .orElse(0.0);
    }
    
    private ComplianceGrade determineGrade(double score) {
        if (score >= 90) return ComplianceGrade.EXCELLENT;
        if (score >= 75) return ComplianceGrade.GOOD;
        if (score >= 60) return ComplianceGrade.SATISFACTORY;
        if (score >= 40) return ComplianceGrade.NEEDS_IMPROVEMENT;
        return ComplianceGrade.NON_COMPLIANT;
    }
    
    private List<String> generateRecommendations(Map<String, Double> sectionScores) {
        List<String> recommendations = new ArrayList<>();
        
        sectionScores.forEach((section, score) -> {
            if (score < 60) {
                recommendations.add(String.format(
                    "Improve %s compliance (current: %.1f%%)", section, score));
            }
        });
        
        return recommendations;
    }
    
    // Compliance check methods - would query actual data
    private boolean hasConsentRecorded(String orgId) {
        return repository.hasConsentRecorded(orgId);
    }
    
    private boolean hasWithdrawalMechanism(String orgId) {
        return repository.hasWithdrawalMechanism(orgId);
    }
    
    private boolean hasExpiryManagement(String orgId) {
        return repository.hasExpiryManagement(orgId);
    }
    
    private boolean hasConsentAuditTrail(String orgId) {
        return repository.hasConsentAuditTrail(orgId);
    }
    
    private boolean hasPurposeLimitation(String orgId) {
        return repository.hasPurposeLimitation(orgId);
    }
    
    private boolean hasDataMinimization(String orgId) {
        return repository.hasDataMinimization(orgId);
    }
    
    private boolean hasStorageLimitation(String orgId) {
        return repository.hasStorageLimitation(orgId);
    }
    
    private boolean hasBreachDetection(String orgId) {
        return repository.hasBreachDetection(orgId);
    }
    
    private boolean has72HourNotification(String orgId) {
        return repository.has72HourNotification(orgId);
    }
    
    private boolean hasBreachRemediation(String orgId) {
        return repository.hasBreachRemediation(orgId);
    }
    
    private boolean hasAccessRight(String orgId) {
        return repository.hasAccessRight(orgId);
    }
    
    private boolean hasCorrectionRight(String orgId) {
        return repository.hasCorrectionRight(orgId);
    }
    
    private boolean hasErasureRight(String orgId) {
        return repository.hasErasureRight(orgId);
    }
    
    private boolean hasGrievanceRight(String orgId) {
        return repository.hasGrievanceRight(orgId);
    }
    
    private boolean hasPortabilityRight(String orgId) {
        return repository.hasPortabilityRight(orgId);
    }
    
    private boolean hasSdfIdentification(String orgId) {
        return repository.hasSdfIdentification(orgId);
    }
    
    private boolean hasDpo(String orgId) {
        return repository.hasDpo(orgId);
    }
    
    private boolean hasDataAudit(String orgId) {
        return repository.hasDataAudit(orgId);
    }
    
    private boolean hasImpactAssessment(String orgId) {
        return repository.hasImpactAssessment(orgId);
    }
    
    public enum ComplianceGrade {
        EXCELLENT, GOOD, SATISFACTORY, NEEDS_IMPROVEMENT, NON_COMPLIANT
    }
    
    public static class ComplianceScore {
        private String organizationId;
        private java.time.LocalDateTime calculatedAt;
        private double overallScore;
        private Map<String, Double> sectionScores;
        private ComplianceGrade grade;
        private List<String> recommendations;
        
        // Getters and setters
        public void setOrganizationId(String organizationId) { 
            this.organizationId = organizationId; 
        }
        public void setCalculatedAt(java.time.LocalDateTime calculatedAt) { 
            this.calculatedAt = calculatedAt; 
        }
        public double getOverallScore() { return overallScore; }
        public void setOverallScore(double overallScore) { 
            this.overallScore = overallScore; 
        }
        public void setSectionScores(Map<String, Double> sectionScores) { 
            this.sectionScores = sectionScores; 
        }
        public void setGrade(ComplianceGrade grade) { this.grade = grade; }
        public void setRecommendations(List<String> recommendations) { 
            this.recommendations = recommendations; 
        }
    }
    
    public interface ComplianceRepository {
        boolean hasConsentRecorded(String orgId);
        boolean hasWithdrawalMechanism(String orgId);
        boolean hasExpiryManagement(String orgId);
        boolean hasConsentAuditTrail(String orgId);
        boolean hasPurposeLimitation(String orgId);
        boolean hasDataMinimization(String orgId);
        boolean hasStorageLimitation(String orgId);
        boolean hasBreachDetection(String orgId);
        boolean has72HourNotification(String orgId);
        boolean hasBreachRemediation(String orgId);
        boolean hasAccessRight(String orgId);
        boolean hasCorrectionRight(String orgId);
        boolean hasErasureRight(String orgId);
        boolean hasGrievanceRight(String orgId);
        boolean hasPortabilityRight(String orgId);
        boolean hasSdfIdentification(String orgId);
        boolean hasDpo(String orgId);
        boolean hasDataAudit(String orgId);
        boolean hasImpactAssessment(String orgId);
    }
}
