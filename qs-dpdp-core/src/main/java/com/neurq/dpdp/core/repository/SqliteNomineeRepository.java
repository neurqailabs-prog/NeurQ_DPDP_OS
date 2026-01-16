package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.DataPrincipalRightsManager;
import java.sql.*;

/**
 * SQLite implementation of NomineeRepository
 */
public class SqliteNomineeRepository implements DataPrincipalRightsManager.NomineeRepository {
    private final Connection connection;
    
    public SqliteNomineeRepository(Connection connection) {
        this.connection = connection;
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            String sql = "CREATE TABLE IF NOT EXISTS nominees (" +
                "id TEXT PRIMARY KEY, " +
                "data_principal_id TEXT NOT NULL, " +
                "nominee_name TEXT NOT NULL, " +
                "nominee_contact TEXT NOT NULL, " +
                "nominated_at TIMESTAMP NOT NULL, " +
                "status TEXT NOT NULL" +
                ")";
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize nominee schema", e);
        }
    }
    
    @Override
    public void save(DataPrincipalRightsManager.Nominee nominee) {
        String sql = "INSERT OR REPLACE INTO nominees " +
            "(id, data_principal_id, nominee_name, nominee_contact, nominated_at, status) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, nominee.getId());
            pstmt.setString(2, nominee.getDataPrincipalId());
            pstmt.setString(3, nominee.getNomineeName());
            pstmt.setString(4, nominee.getNomineeContact());
            pstmt.setTimestamp(5, Timestamp.valueOf(nominee.getNominatedAt()));
            pstmt.setString(6, nominee.getStatus().name());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save nominee", e);
        }
    }
}
