package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.BreachNotificationManager;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * SQLite implementation of BreachRepository
 */
public class SqliteBreachRepository implements BreachNotificationManager.BreachRepository {
    private final Connection connection;
    
    public SqliteBreachRepository(Connection connection) {
        this.connection = connection;
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            // Breach incidents table
            String sql1 = "CREATE TABLE IF NOT EXISTS breach_incidents (" +
                "id TEXT PRIMARY KEY, " +
                "description TEXT NOT NULL, " +
                "detected_at TIMESTAMP NOT NULL, " +
                "sla_deadline TIMESTAMP NOT NULL, " +
                "status TEXT NOT NULL, " +
                "severity TEXT NOT NULL, " +
                "root_cause TEXT, " +
                "remediation_steps TEXT" +
                ")";
            
            // Affected principals
            String sql2 = "CREATE TABLE IF NOT EXISTS breach_affected_principals (" +
                "breach_id TEXT NOT NULL, " +
                "data_principal_id TEXT NOT NULL, " +
                "PRIMARY KEY (breach_id, data_principal_id)" +
                ")";
            
            // Affected categories
            String sql3 = "CREATE TABLE IF NOT EXISTS breach_affected_categories (" +
                "breach_id TEXT NOT NULL, " +
                "category TEXT NOT NULL, " +
                "PRIMARY KEY (breach_id, category)" +
                ")";
            
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql1);
                stmt.execute(sql2);
                stmt.execute(sql3);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize breach schema", e);
        }
    }
    
    @Override
    public void save(BreachNotificationManager.BreachIncident incident) {
        String sql = "INSERT OR REPLACE INTO breach_incidents " +
            "(id, description, detected_at, sla_deadline, status, severity, root_cause, remediation_steps) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, incident.getId());
            pstmt.setString(2, incident.getDescription());
            pstmt.setTimestamp(3, Timestamp.valueOf(incident.getDetectedAt()));
            pstmt.setTimestamp(4, Timestamp.valueOf(incident.getSlaDeadline()));
            pstmt.setString(5, incident.getStatus().name());
            pstmt.setString(6, incident.getSeverity().name());
            pstmt.setString(7, incident.getRootCause());
            pstmt.setString(8, String.join(",", incident.getRemediationSteps()));
            pstmt.executeUpdate();
            
            // Save affected principals
            saveAffectedPrincipals(incident);
            
            // Save affected categories
            saveAffectedCategories(incident);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save breach incident", e);
        }
    }
    
    @Override
    public BreachNotificationManager.BreachIncident findById(String id) {
        String sql = "SELECT * FROM breach_incidents WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    BreachNotificationManager.BreachIncident incident = mapRowToIncident(rs);
                    incident.setAffectedDataPrincipals(findAffectedPrincipals(id));
                    incident.setAffectedDataCategories(findAffectedCategories(id));
                    return incident;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find breach incident", e);
        }
        return null;
    }
    
    @Override
    public void update(BreachNotificationManager.BreachIncident incident) {
        save(incident); // SQLite uses INSERT OR REPLACE
    }
    
    private BreachNotificationManager.BreachIncident mapRowToIncident(ResultSet rs) throws SQLException {
        BreachNotificationManager.BreachIncident incident = new BreachNotificationManager.BreachIncident();
        incident.setId(rs.getString("id"));
        incident.setDescription(rs.getString("description"));
        incident.setDetectedAt(rs.getTimestamp("detected_at").toLocalDateTime());
        incident.setSlaDeadline(rs.getTimestamp("sla_deadline").toLocalDateTime());
        incident.setStatus(BreachNotificationManager.BreachStatus.valueOf(rs.getString("status")));
        incident.setSeverity(BreachNotificationManager.BreachSeverity.valueOf(rs.getString("severity")));
        incident.setRootCause(rs.getString("root_cause"));
        String steps = rs.getString("remediation_steps");
        if (steps != null) {
            incident.setRemediationSteps(new ArrayList<>(Arrays.asList(steps.split(","))));
        }
        return incident;
    }
    
    private void saveAffectedPrincipals(BreachNotificationManager.BreachIncident incident) {
        String deleteSql = "DELETE FROM breach_affected_principals WHERE breach_id = ?";
        String insertSql = "INSERT INTO breach_affected_principals (breach_id, data_principal_id) VALUES (?, ?)";
        try (PreparedStatement deleteStmt = connection.prepareStatement(deleteSql);
             PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
            deleteStmt.setString(1, incident.getId());
            deleteStmt.executeUpdate();
            
            for (String principalId : incident.getAffectedDataPrincipals()) {
                insertStmt.setString(1, incident.getId());
                insertStmt.setString(2, principalId);
                insertStmt.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save affected principals", e);
        }
    }
    
    private void saveAffectedCategories(BreachNotificationManager.BreachIncident incident) {
        String deleteSql = "DELETE FROM breach_affected_categories WHERE breach_id = ?";
        String insertSql = "INSERT INTO breach_affected_categories (breach_id, category) VALUES (?, ?)";
        try (PreparedStatement deleteStmt = connection.prepareStatement(deleteSql);
             PreparedStatement insertStmt = connection.prepareStatement(insertSql)) {
            deleteStmt.setString(1, incident.getId());
            deleteStmt.executeUpdate();
            
            for (String category : incident.getAffectedDataCategories()) {
                insertStmt.setString(1, incident.getId());
                insertStmt.setString(2, category);
                insertStmt.executeUpdate();
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save affected categories", e);
        }
    }
    
    private Set<String> findAffectedPrincipals(String breachId) {
        Set<String> principals = new HashSet<>();
        String sql = "SELECT data_principal_id FROM breach_affected_principals WHERE breach_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, breachId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    principals.add(rs.getString("data_principal_id"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find affected principals", e);
        }
        return principals;
    }
    
    private Set<String> findAffectedCategories(String breachId) {
        Set<String> categories = new HashSet<>();
        String sql = "SELECT category FROM breach_affected_categories WHERE breach_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, breachId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    categories.add(rs.getString("category"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find affected categories", e);
        }
        return categories;
    }
}
