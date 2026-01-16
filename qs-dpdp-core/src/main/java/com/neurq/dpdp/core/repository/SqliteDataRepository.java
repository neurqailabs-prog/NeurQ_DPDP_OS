package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.DataPrincipalRightsManager;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * SQLite implementation of DataRepository
 */
public class SqliteDataRepository implements DataPrincipalRightsManager.DataRepository {
    private final Connection connection;
    private final ObjectMapper objectMapper;
    
    public SqliteDataRepository(Connection connection) {
        this.connection = connection;
        this.objectMapper = new ObjectMapper();
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            String sql = "CREATE TABLE IF NOT EXISTS personal_data_records (" +
                "id TEXT PRIMARY KEY, " +
                "data_principal_id TEXT NOT NULL, " +
                "data TEXT NOT NULL, " +
                "collected_at TIMESTAMP NOT NULL, " +
                "last_modified TIMESTAMP, " +
                "modified_by TEXT, " +
                "purpose TEXT, " +
                "data_category TEXT, " +
                "deleted BOOLEAN DEFAULT 0, " +
                "deleted_at TIMESTAMP" +
                ")";
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize data schema", e);
        }
    }
    
    @Override
    public List<DataPrincipalRightsManager.PersonalDataRecord> findByDataPrincipalId(String dataPrincipalId) {
        String sql = "SELECT * FROM personal_data_records WHERE data_principal_id = ? AND deleted = 0";
        List<DataPrincipalRightsManager.PersonalDataRecord> records = new ArrayList<>();
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, dataPrincipalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    records.add(mapRowToRecord(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find records", e);
        }
        return records;
    }
    
    @Override
    public DataPrincipalRightsManager.PersonalDataRecord findById(String id) {
        String sql = "SELECT * FROM personal_data_records WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToRecord(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find record", e);
        }
        return null;
    }
    
    @Override
    public void save(DataPrincipalRightsManager.PersonalDataRecord record) {
        String sql = "INSERT OR REPLACE INTO personal_data_records " +
            "(id, data_principal_id, data, collected_at, last_modified, modified_by, purpose, data_category, deleted, deleted_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, record.getId());
            pstmt.setString(2, record.getDataPrincipalId());
            pstmt.setString(3, objectMapper.writeValueAsString(record.getData()));
            pstmt.setTimestamp(4, record.getCollectedAt() != null ? 
                Timestamp.valueOf(record.getCollectedAt()) : Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setTimestamp(5, record.getLastModified() != null ? 
                Timestamp.valueOf(record.getLastModified()) : null);
            pstmt.setString(6, record.getModifiedBy());
            pstmt.setString(7, record.getPurpose());
            pstmt.setString(8, record.getDataCategory());
            pstmt.setBoolean(9, record.isDeleted());
            pstmt.setTimestamp(10, record.getDeletedAt() != null ? 
                Timestamp.valueOf(record.getDeletedAt()) : null);
            pstmt.executeUpdate();
        } catch (Exception e) {
            throw new RuntimeException("Failed to save record", e);
        }
    }
    
    private DataPrincipalRightsManager.PersonalDataRecord mapRowToRecord(ResultSet rs) throws SQLException {
        DataPrincipalRightsManager.PersonalDataRecord record = new DataPrincipalRightsManager.PersonalDataRecord();
        record.setId(rs.getString("id"));
        record.setDataPrincipalId(rs.getString("data_principal_id"));
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> data = objectMapper.readValue(rs.getString("data"), Map.class);
            record.setData(data);
        } catch (Exception e) {
            record.setData(new HashMap<>());
        }
        Timestamp collected = rs.getTimestamp("collected_at");
        if (collected != null) record.setCollectedAt(collected.toLocalDateTime());
        Timestamp modified = rs.getTimestamp("last_modified");
        if (modified != null) record.setLastModified(modified.toLocalDateTime());
        record.setModifiedBy(rs.getString("modified_by"));
        record.setPurpose(rs.getString("purpose"));
        record.setDataCategory(rs.getString("data_category"));
        record.setDeleted(rs.getBoolean("deleted"));
        Timestamp deleted = rs.getTimestamp("deleted_at");
        if (deleted != null) record.setDeletedAt(deleted.toLocalDateTime());
        return record;
    }
}
