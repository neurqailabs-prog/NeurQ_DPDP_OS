package com.neurq.dpdp.core;

import java.time.LocalDateTime;
import java.util.*;

/**
 * Significant Data Fiduciary (SDF) Assessment Manager (DPDP Act Section 10)
 */
public class SdfAssessmentManager {
    
    /**
     * Assess if organization qualifies as SDF
     */
    public SdfAssessmentResult assessSdfStatus(String organizationId, SdfCriteria criteria) {
        SdfAssessmentResult result = new SdfAssessmentResult();
        result.setOrganizationId(organizationId);
        result.setAssessedAt(LocalDateTime.now());
        
        // Check SDF criteria
        boolean qualifiesAsSdf = checkSdfCriteria(criteria);
        result.setQualifiesAsSdf(qualifiesAsSdf);
        
        if (qualifiesAsSdf) {
            result.setObligations(generateSdfObligations());
            result.setRecommendations(generateSdfRecommendations(criteria));
        }
        
        return result;
    }
    
    private boolean checkSdfCriteria(SdfCriteria criteria) {
        // Check volume of personal data processed
        if (criteria.getDataPrincipalCount() > 1000000) {
            return true;
        }
        
        // Check sensitivity of data
        if (criteria.getSensitiveDataCategories().contains("AADHAAR") ||
            criteria.getSensitiveDataCategories().contains("FINANCIAL")) {
            return true;
        }
        
        // Check processing activities
        if (criteria.getProcessingActivities().size() > 10) {
            return true;
        }
        
        return false;
    }
    
    private List<String> generateSdfObligations() {
        List<String> obligations = new ArrayList<>();
        obligations.add("Appoint Data Protection Officer (DPO)");
        obligations.add("Conduct regular data audits");
        obligations.add("Perform Data Protection Impact Assessment (DPIA)");
        obligations.add("Maintain detailed records of processing activities");
        obligations.add("Implement enhanced security measures");
        return obligations;
    }
    
    private List<String> generateSdfRecommendations(SdfCriteria criteria) {
        List<String> recommendations = new ArrayList<>();
        if (criteria.getDataPrincipalCount() > 1000000) {
            recommendations.add("Consider appointing a dedicated DPO");
        }
        if (criteria.getSensitiveDataCategories().contains("AADHAAR")) {
            recommendations.add("Implement Aadhaar-specific security controls");
        }
        return recommendations;
    }
    
    public static class SdfCriteria {
        private long dataPrincipalCount;
        private Set<String> sensitiveDataCategories;
        private List<String> processingActivities;
        
        // Getters and setters
        public long getDataPrincipalCount() { return dataPrincipalCount; }
        public void setDataPrincipalCount(long dataPrincipalCount) { 
            this.dataPrincipalCount = dataPrincipalCount; 
        }
        public Set<String> getSensitiveDataCategories() { 
            if (sensitiveDataCategories == null) sensitiveDataCategories = new HashSet<>();
            return sensitiveDataCategories; 
        }
        public void setSensitiveDataCategories(Set<String> sensitiveDataCategories) { 
            this.sensitiveDataCategories = sensitiveDataCategories; 
        }
        public List<String> getProcessingActivities() { 
            if (processingActivities == null) processingActivities = new ArrayList<>();
            return processingActivities; 
        }
        public void setProcessingActivities(List<String> processingActivities) { 
            this.processingActivities = processingActivities; 
        }
    }
    
    public static class SdfAssessmentResult {
        private String organizationId;
        private LocalDateTime assessedAt;
        private boolean qualifiesAsSdf;
        private List<String> obligations;
        private List<String> recommendations;
        
        // Getters and setters
        public void setOrganizationId(String organizationId) { 
            this.organizationId = organizationId; 
        }
        public void setAssessedAt(LocalDateTime assessedAt) { 
            this.assessedAt = assessedAt; 
        }
        public void setQualifiesAsSdf(boolean qualifiesAsSdf) { 
            this.qualifiesAsSdf = qualifiesAsSdf; 
        }
        public void setObligations(List<String> obligations) { 
            this.obligations = obligations; 
        }
        public void setRecommendations(List<String> recommendations) { 
            this.recommendations = recommendations; 
        }
    }
}
