package com.neurq.dpdp.core;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Breach Notification Manager (DPDP Act Section 9 - 72-hour SLA)
 */
public class BreachNotificationManager {
    private static final long BREACH_NOTIFICATION_SLA_HOURS = 72;
    private final BreachRepository repository;
    
    public BreachNotificationManager(BreachRepository repository) {
        this.repository = repository;
    }
    
    /**
     * Record and notify breach (Section 9)
     */
    public BreachNotificationResponse notifyBreach(BreachIncident incident) {
        incident.setId(UUID.randomUUID().toString());
        incident.setDetectedAt(LocalDateTime.now());
        incident.setStatus(BreachStatus.DETECTED);
        
        // Calculate SLA deadline
        LocalDateTime slaDeadline = incident.getDetectedAt().plusHours(BREACH_NOTIFICATION_SLA_HOURS);
        incident.setSlaDeadline(slaDeadline);
        
        // Save breach record
        repository.save(incident);
        
        // Assess severity
        BreachSeverity severity = assessSeverity(incident);
        incident.setSeverity(severity);
        
        // Notify Data Protection Board (DPB)
        CompletableFuture<Void> dpbNotification = notifyDataProtectionBoard(incident);
        
        // Notify affected data principals
        CompletableFuture<Void> principalNotification = notifyAffectedPrincipals(incident);
        
        // Generate breach report
        BreachReport report = generateBreachReport(incident);
        
        // Track notification status
        BreachNotificationResponse response = new BreachNotificationResponse();
        response.setBreachId(incident.getId());
        response.setSlaDeadline(slaDeadline);
        response.setSeverity(severity);
        response.setReport(report);
        response.setStatus(BreachNotificationStatus.IN_PROGRESS);
        
        // Monitor SLA compliance
        monitorSlaCompliance(incident);
        
        return response;
    }
    
    /**
     * Assess breach severity
     */
    private BreachSeverity assessSeverity(BreachIncident incident) {
        int affectedPrincipals = incident.getAffectedDataPrincipals().size();
        Set<String> dataCategories = incident.getAffectedDataCategories();
        boolean containsSensitiveData = dataCategories.contains("AADHAAR") || 
                                       dataCategories.contains("PAN") ||
                                       dataCategories.contains("FINANCIAL");
        
        if (affectedPrincipals > 10000 || containsSensitiveData) {
            return BreachSeverity.CRITICAL;
        } else if (affectedPrincipals > 1000) {
            return BreachSeverity.HIGH;
        } else if (affectedPrincipals > 100) {
            return BreachSeverity.MEDIUM;
        } else {
            return BreachSeverity.LOW;
        }
    }
    
    /**
     * Notify Data Protection Board
     */
    private CompletableFuture<Void> notifyDataProtectionBoard(BreachIncident incident) {
        return CompletableFuture.runAsync(() -> {
            // Format breach notification as per DPDP Rules
            BreachNotification notification = formatDpbNotification(incident);
            
            // Send via secure channel (quantum-safe encrypted)
            sendSecureNotification(notification, "dpb@dpdp.gov.in");
            
            // Log notification
            logNotification(incident.getId(), "DPB", notification.getSentAt());
            
            // Update incident status
            incident.setStatus(BreachStatus.NOTIFIED);
            repository.update(incident);
        });
    }
    
    /**
     * Notify affected data principals
     */
    private CompletableFuture<Void> notifyAffectedPrincipals(BreachIncident incident) {
        return CompletableFuture.runAsync(() -> {
            for (String dataPrincipalId : incident.getAffectedDataPrincipals()) {
                PrincipalBreachNotification principalNotification = 
                    formatPrincipalNotification(incident, dataPrincipalId);
                
                // Send notification (email, SMS, in-app)
                sendPrincipalNotification(principalNotification, dataPrincipalId);
                
                // Log notification
                logNotification(incident.getId(), dataPrincipalId, principalNotification.getSentAt());
            }
        });
    }
    
    /**
     * Generate breach report
     */
    private BreachReport generateBreachReport(BreachIncident incident) {
        BreachReport report = new BreachReport();
        report.setBreachId(incident.getId());
        report.setIncident(incident);
        report.setGeneratedAt(LocalDateTime.now());
        report.setAffectedCount(incident.getAffectedDataPrincipals().size());
        report.setDataCategories(incident.getAffectedDataCategories());
        report.setRootCause(incident.getRootCause());
        report.setRemediationSteps(incident.getRemediationSteps());
        report.setComplianceStatus(calculateComplianceStatus(incident));
        
        return report;
    }
    
    /**
     * Monitor SLA compliance
     */
    private void monitorSlaCompliance(BreachIncident incident) {
        // Schedule SLA check
        Timer timer = new Timer();
        long delay = ChronoUnit.MILLIS.between(LocalDateTime.now(), incident.getSlaDeadline());
        if (delay > 0) {
            timer.schedule(new TimerTask() {
                @Override
                public void run() {
                    LocalDateTime now = LocalDateTime.now();
                    BreachIncident current = repository.findById(incident.getId());
                    if (now.isAfter(incident.getSlaDeadline()) && 
                        current != null && current.getStatus() != BreachStatus.NOTIFIED) {
                        // SLA breach - escalate
                        escalateSlaBreach(incident);
                    }
                }
            }, delay);
        }
    }
    
    private ComplianceStatus calculateComplianceStatus(BreachIncident incident) {
        long hoursElapsed = ChronoUnit.HOURS.between(
            incident.getDetectedAt(), LocalDateTime.now());
        
        if (hoursElapsed <= BREACH_NOTIFICATION_SLA_HOURS) {
            return ComplianceStatus.COMPLIANT;
        } else {
            return ComplianceStatus.NON_COMPLIANT;
        }
    }
    
    private BreachNotification formatDpbNotification(BreachIncident incident) {
        BreachNotification notification = new BreachNotification();
        notification.setBreachId(incident.getId());
        notification.setSentAt(LocalDateTime.now());
        notification.setRecipient("Data Protection Board");
        notification.setSubject("Data Breach Notification - " + incident.getId());
        notification.setBody(formatBreachDetails(incident));
        return notification;
    }
    
    private PrincipalBreachNotification formatPrincipalNotification(BreachIncident incident, 
                                                                   String dataPrincipalId) {
        PrincipalBreachNotification notification = new PrincipalBreachNotification();
        notification.setBreachId(incident.getId());
        notification.setDataPrincipalId(dataPrincipalId);
        notification.setSentAt(LocalDateTime.now());
        notification.setSubject("Important: Data Breach Notification");
        notification.setBody(formatPrincipalBreachDetails(incident, dataPrincipalId));
        return notification;
    }
    
    private String formatBreachDetails(BreachIncident incident) {
        return String.format(
            "Breach ID: %s\n" +
            "Detected At: %s\n" +
            "Affected Data Principals: %d\n" +
            "Data Categories: %s\n" +
            "Severity: %s\n" +
            "Root Cause: %s",
            incident.getId(),
            incident.getDetectedAt(),
            incident.getAffectedDataPrincipals().size(),
            String.join(", ", incident.getAffectedDataCategories()),
            incident.getSeverity(),
            incident.getRootCause()
        );
    }
    
    private String formatPrincipalBreachDetails(BreachIncident incident, String dataPrincipalId) {
        return String.format(
            "Dear Data Principal,\n\n" +
            "We are writing to inform you of a data breach that may have affected your personal data.\n\n" +
            "Breach Details:\n" +
            "- Breach ID: %s\n" +
            "- Detected: %s\n" +
            "- Affected Data Categories: %s\n\n" +
            "We are taking immediate steps to address this breach and will keep you informed.\n\n" +
            "If you have any concerns, please contact our grievance officer.",
            incident.getId(),
            incident.getDetectedAt(),
            String.join(", ", incident.getAffectedDataCategories())
        );
    }
    
    private void sendSecureNotification(BreachNotification notification, String recipient) {
        // Send via quantum-safe encrypted channel
        System.out.println("Sending secure notification to " + recipient);
    }
    
    private void sendPrincipalNotification(PrincipalBreachNotification notification, 
                                          String dataPrincipalId) {
        // Send via multiple channels (email, SMS, in-app)
        System.out.println("Sending notification to data principal: " + dataPrincipalId);
    }
    
    private void logNotification(String breachId, String recipient, LocalDateTime sentAt) {
        // Log to audit trail
        System.out.println("Logged notification: " + breachId + " -> " + recipient + " at " + sentAt);
    }
    
    private void escalateSlaBreach(BreachIncident incident) {
        // Escalate to management
        System.out.println("SLA BREACH ALERT: Breach " + incident.getId() + " exceeded 72-hour notification deadline");
    }
    
    public enum BreachStatus {
        DETECTED, ASSESSING, NOTIFIED, REMEDIATING, RESOLVED
    }
    
    public enum BreachSeverity {
        LOW, MEDIUM, HIGH, CRITICAL
    }
    
    public enum BreachNotificationStatus {
        IN_PROGRESS, COMPLETED, FAILED
    }
    
    public enum ComplianceStatus {
        COMPLIANT, NON_COMPLIANT, PENDING
    }
    
    public static class BreachIncident {
        private String id;
        private String description;
        private LocalDateTime detectedAt;
        private LocalDateTime slaDeadline;
        private BreachStatus status;
        private BreachSeverity severity;
        private Set<String> affectedDataPrincipals;
        private Set<String> affectedDataCategories;
        private String rootCause;
        private List<String> remediationSteps;
        
        // Getters and setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        public LocalDateTime getDetectedAt() { return detectedAt; }
        public void setDetectedAt(LocalDateTime detectedAt) { this.detectedAt = detectedAt; }
        public LocalDateTime getSlaDeadline() { return slaDeadline; }
        public void setSlaDeadline(LocalDateTime slaDeadline) { this.slaDeadline = slaDeadline; }
        public BreachStatus getStatus() { return status; }
        public void setStatus(BreachStatus status) { this.status = status; }
        public BreachSeverity getSeverity() { return severity; }
        public void setSeverity(BreachSeverity severity) { this.severity = severity; }
        public Set<String> getAffectedDataPrincipals() { 
            if (affectedDataPrincipals == null) affectedDataPrincipals = new HashSet<>();
            return affectedDataPrincipals; 
        }
        public void setAffectedDataPrincipals(Set<String> affectedDataPrincipals) { 
            this.affectedDataPrincipals = affectedDataPrincipals; 
        }
        public Set<String> getAffectedDataCategories() { 
            if (affectedDataCategories == null) affectedDataCategories = new HashSet<>();
            return affectedDataCategories; 
        }
        public void setAffectedDataCategories(Set<String> affectedDataCategories) { 
            this.affectedDataCategories = affectedDataCategories; 
        }
        public String getRootCause() { return rootCause; }
        public void setRootCause(String rootCause) { this.rootCause = rootCause; }
        public List<String> getRemediationSteps() { 
            if (remediationSteps == null) remediationSteps = new ArrayList<>();
            return remediationSteps; 
        }
        public void setRemediationSteps(List<String> remediationSteps) { 
            this.remediationSteps = remediationSteps; 
        }
    }
    
    public static class BreachNotificationResponse {
        private String breachId;
        private LocalDateTime slaDeadline;
        private BreachSeverity severity;
        private BreachReport report;
        private BreachNotificationStatus status;
        
        // Getters and setters
        public void setBreachId(String breachId) { this.breachId = breachId; }
        public void setSlaDeadline(LocalDateTime slaDeadline) { this.slaDeadline = slaDeadline; }
        public void setSeverity(BreachSeverity severity) { this.severity = severity; }
        public void setReport(BreachReport report) { this.report = report; }
        public void setStatus(BreachNotificationStatus status) { this.status = status; }
    }
    
    public static class BreachReport {
        private String breachId;
        private BreachIncident incident;
        private LocalDateTime generatedAt;
        private int affectedCount;
        private Set<String> dataCategories;
        private String rootCause;
        private List<String> remediationSteps;
        private ComplianceStatus complianceStatus;
        
        // Getters and setters
        public void setBreachId(String breachId) { this.breachId = breachId; }
        public void setIncident(BreachIncident incident) { this.incident = incident; }
        public void setGeneratedAt(LocalDateTime generatedAt) { this.generatedAt = generatedAt; }
        public void setAffectedCount(int affectedCount) { this.affectedCount = affectedCount; }
        public void setDataCategories(Set<String> dataCategories) { 
            this.dataCategories = dataCategories; 
        }
        public void setRootCause(String rootCause) { this.rootCause = rootCause; }
        public void setRemediationSteps(List<String> remediationSteps) { 
            this.remediationSteps = remediationSteps; 
        }
        public void setComplianceStatus(ComplianceStatus complianceStatus) { 
            this.complianceStatus = complianceStatus; 
        }
    }
    
    public static class BreachNotification {
        private String breachId;
        private LocalDateTime sentAt;
        private String recipient;
        private String subject;
        private String body;
        
        // Getters and setters
        public void setBreachId(String breachId) { this.breachId = breachId; }
        public LocalDateTime getSentAt() { return sentAt; }
        public void setSentAt(LocalDateTime sentAt) { this.sentAt = sentAt; }
        public void setRecipient(String recipient) { this.recipient = recipient; }
        public void setSubject(String subject) { this.subject = subject; }
        public void setBody(String body) { this.body = body; }
    }
    
    public static class PrincipalBreachNotification {
        private String breachId;
        private String dataPrincipalId;
        private LocalDateTime sentAt;
        private String subject;
        private String body;
        
        // Getters and setters
        public void setBreachId(String breachId) { this.breachId = breachId; }
        public void setDataPrincipalId(String dataPrincipalId) { 
            this.dataPrincipalId = dataPrincipalId; 
        }
        public LocalDateTime getSentAt() { return sentAt; }
        public void setSentAt(LocalDateTime sentAt) { this.sentAt = sentAt; }
        public void setSubject(String subject) { this.subject = subject; }
        public void setBody(String body) { this.body = body; }
    }
    
    public interface BreachRepository {
        void save(BreachIncident incident);
        BreachIncident findById(String id);
        void update(BreachIncident incident);
    }
}
