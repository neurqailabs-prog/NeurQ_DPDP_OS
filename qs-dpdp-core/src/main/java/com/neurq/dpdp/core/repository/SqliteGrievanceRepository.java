package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.DataPrincipalRightsManager;
import java.sql.*;

/**
 * SQLite implementation of GrievanceRepository
 */
public class SqliteGrievanceRepository implements DataPrincipalRightsManager.GrievanceRepository {
    private final Connection connection;
    
    public SqliteGrievanceRepository(Connection connection) {
        this.connection = connection;
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            String sql = "CREATE TABLE IF NOT EXISTS grievances (" +
                "id TEXT PRIMARY KEY, " +
                "data_principal_id TEXT NOT NULL, " +
                "type TEXT NOT NULL, " +
                "description TEXT NOT NULL, " +
                "submitted_at TIMESTAMP NOT NULL, " +
                "status TEXT NOT NULL, " +
                "assigned_officer TEXT" +
                ")";
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize grievance schema", e);
        }
    }
    
    @Override
    public void save(DataPrincipalRightsManager.Grievance grievance) {
        String sql = "INSERT OR REPLACE INTO grievances " +
            "(id, data_principal_id, type, description, submitted_at, status, assigned_officer) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, grievance.getId());
            pstmt.setString(2, grievance.getDataPrincipalId());
            pstmt.setString(3, grievance.getType());
            pstmt.setString(4, grievance.getDescription());
            pstmt.setTimestamp(5, Timestamp.valueOf(grievance.getSubmittedAt()));
            pstmt.setString(6, grievance.getStatus().name());
            pstmt.setString(7, grievance.getAssignedOfficer());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save grievance", e);
        }
    }
    
    @Override
    public void update(DataPrincipalRightsManager.Grievance grievance) {
        save(grievance); // SQLite uses INSERT OR REPLACE
    }
}
