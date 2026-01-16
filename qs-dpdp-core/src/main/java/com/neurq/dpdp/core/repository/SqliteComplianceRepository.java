package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.ComplianceScoringEngine;
import java.sql.*;

/**
 * SQLite implementation of ComplianceRepository
 */
public class SqliteComplianceRepository implements ComplianceScoringEngine.ComplianceRepository {
    private final Connection connection;
    
    public SqliteComplianceRepository(Connection connection) {
        this.connection = connection;
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            String sql = "CREATE TABLE IF NOT EXISTS compliance_checks (" +
                "organization_id TEXT NOT NULL, " +
                "check_type TEXT NOT NULL, " +
                "status BOOLEAN NOT NULL, " +
                "checked_at TIMESTAMP NOT NULL, " +
                "PRIMARY KEY (organization_id, check_type)" +
                ")";
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize compliance schema", e);
        }
    }
    
    @Override
    public boolean hasConsentRecorded(String orgId) {
        return checkCompliance(orgId, "CONSENT_RECORDED");
    }
    
    @Override
    public boolean hasWithdrawalMechanism(String orgId) {
        return checkCompliance(orgId, "WITHDRAWAL_MECHANISM");
    }
    
    @Override
    public boolean hasExpiryManagement(String orgId) {
        return checkCompliance(orgId, "EXPIRY_MANAGEMENT");
    }
    
    @Override
    public boolean hasConsentAuditTrail(String orgId) {
        return checkCompliance(orgId, "CONSENT_AUDIT_TRAIL");
    }
    
    @Override
    public boolean hasPurposeLimitation(String orgId) {
        return checkCompliance(orgId, "PURPOSE_LIMITATION");
    }
    
    @Override
    public boolean hasDataMinimization(String orgId) {
        return checkCompliance(orgId, "DATA_MINIMIZATION");
    }
    
    @Override
    public boolean hasStorageLimitation(String orgId) {
        return checkCompliance(orgId, "STORAGE_LIMITATION");
    }
    
    @Override
    public boolean hasBreachDetection(String orgId) {
        return checkCompliance(orgId, "BREACH_DETECTION");
    }
    
    @Override
    public boolean has72HourNotification(String orgId) {
        return checkCompliance(orgId, "72_HOUR_NOTIFICATION");
    }
    
    @Override
    public boolean hasBreachRemediation(String orgId) {
        return checkCompliance(orgId, "BREACH_REMEDIATION");
    }
    
    @Override
    public boolean hasAccessRight(String orgId) {
        return checkCompliance(orgId, "ACCESS_RIGHT");
    }
    
    @Override
    public boolean hasCorrectionRight(String orgId) {
        return checkCompliance(orgId, "CORRECTION_RIGHT");
    }
    
    @Override
    public boolean hasErasureRight(String orgId) {
        return checkCompliance(orgId, "ERASURE_RIGHT");
    }
    
    @Override
    public boolean hasGrievanceRight(String orgId) {
        return checkCompliance(orgId, "GRIEVANCE_RIGHT");
    }
    
    @Override
    public boolean hasPortabilityRight(String orgId) {
        return checkCompliance(orgId, "PORTABILITY_RIGHT");
    }
    
    @Override
    public boolean hasSdfIdentification(String orgId) {
        return checkCompliance(orgId, "SDF_IDENTIFICATION");
    }
    
    @Override
    public boolean hasDpo(String orgId) {
        return checkCompliance(orgId, "DPO");
    }
    
    @Override
    public boolean hasDataAudit(String orgId) {
        return checkCompliance(orgId, "DATA_AUDIT");
    }
    
    @Override
    public boolean hasImpactAssessment(String orgId) {
        return checkCompliance(orgId, "IMPACT_ASSESSMENT");
    }
    
    private boolean checkCompliance(String orgId, String checkType) {
        String sql = "SELECT status FROM compliance_checks WHERE organization_id = ? AND check_type = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, orgId);
            pstmt.setString(2, checkType);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBoolean("status");
                }
            }
        } catch (SQLException e) {
            // If not found, assume false and create default entry
            setCompliance(orgId, checkType, false);
            return false;
        }
        return false;
    }
    
    public void setCompliance(String orgId, String checkType, boolean status) {
        String sql = "INSERT OR REPLACE INTO compliance_checks " +
            "(organization_id, check_type, status, checked_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, orgId);
            pstmt.setString(2, checkType);
            pstmt.setBoolean(3, status);
            pstmt.setTimestamp(4, Timestamp.valueOf(java.time.LocalDateTime.now()));
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to set compliance", e);
        }
    }
}
