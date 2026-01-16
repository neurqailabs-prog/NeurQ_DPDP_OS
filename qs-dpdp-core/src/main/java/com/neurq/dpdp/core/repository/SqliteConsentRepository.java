package com.neurq.dpdp.core.repository;

import com.neurq.dpdp.core.ConsentManager;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

/**
 * SQLite implementation of ConsentRepository
 */
public class SqliteConsentRepository implements ConsentManager.ConsentRepository {
    private final Connection connection;
    
    public SqliteConsentRepository(Connection connection) {
        this.connection = connection;
        initializeSchema();
    }
    
    private void initializeSchema() {
        try {
            String sql = "CREATE TABLE IF NOT EXISTS consents (" +
                "id TEXT PRIMARY KEY, " +
                "data_principal_id TEXT NOT NULL, " +
                "purpose TEXT NOT NULL, " +
                "data_category TEXT NOT NULL, " +
                "type TEXT NOT NULL, " +
                "status TEXT NOT NULL, " +
                "given_at TIMESTAMP NOT NULL, " +
                "expiry_date TIMESTAMP, " +
                "withdrawn_at TIMESTAMP" +
                ")";
            try (Statement stmt = connection.createStatement()) {
                stmt.execute(sql);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to initialize consent schema", e);
        }
    }
    
    @Override
    public void save(ConsentManager.Consent consent) {
        String sql = "INSERT OR REPLACE INTO consents " +
            "(id, data_principal_id, purpose, data_category, type, status, given_at, expiry_date, withdrawn_at) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, consent.getId());
            pstmt.setString(2, consent.getDataPrincipalId());
            pstmt.setString(3, consent.getPurpose());
            pstmt.setString(4, consent.getDataCategory());
            pstmt.setString(5, consent.getType().name());
            pstmt.setString(6, consent.getStatus().name());
            pstmt.setTimestamp(7, Timestamp.valueOf(consent.getGivenAt()));
            pstmt.setTimestamp(8, consent.getExpiryDate() != null ? 
                Timestamp.valueOf(consent.getExpiryDate()) : null);
            pstmt.setTimestamp(9, consent.getWithdrawnAt() != null ? 
                Timestamp.valueOf(consent.getWithdrawnAt()) : null);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to save consent", e);
        }
    }
    
    @Override
    public ConsentManager.Consent findById(String id) {
        String sql = "SELECT * FROM consents WHERE id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToConsent(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find consent", e);
        }
        return null;
    }
    
    @Override
    public List<ConsentManager.Consent> findActiveByDataPrincipal(String dataPrincipalId) {
        String sql = "SELECT * FROM consents WHERE data_principal_id = ? AND status = 'ACTIVE'";
        List<ConsentManager.Consent> consents = new ArrayList<>();
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, dataPrincipalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    consents.add(mapRowToConsent(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find active consents", e);
        }
        return consents;
    }
    
    @Override
    public List<ConsentManager.Consent> findByDataPrincipal(String dataPrincipalId) {
        String sql = "SELECT * FROM consents WHERE data_principal_id = ?";
        List<ConsentManager.Consent> consents = new ArrayList<>();
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, dataPrincipalId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    consents.add(mapRowToConsent(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find consents", e);
        }
        return consents;
    }
    
    @Override
    public List<ConsentManager.Consent> findAll() {
        String sql = "SELECT * FROM consents";
        List<ConsentManager.Consent> consents = new ArrayList<>();
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                consents.add(mapRowToConsent(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Failed to find all consents", e);
        }
        return consents;
    }
    
    @Override
    public void update(ConsentManager.Consent consent) {
        save(consent); // SQLite uses INSERT OR REPLACE
    }
    
    private ConsentManager.Consent mapRowToConsent(ResultSet rs) throws SQLException {
        ConsentManager.Consent consent = new ConsentManager.Consent();
        consent.setId(rs.getString("id"));
        consent.setDataPrincipalId(rs.getString("data_principal_id"));
        consent.setPurpose(rs.getString("purpose"));
        consent.setDataCategory(rs.getString("data_category"));
        consent.setType(ConsentManager.ConsentType.valueOf(rs.getString("type")));
        consent.setStatus(ConsentManager.ConsentStatus.valueOf(rs.getString("status")));
        consent.setGivenAt(rs.getTimestamp("given_at").toLocalDateTime());
        Timestamp expiry = rs.getTimestamp("expiry_date");
        if (expiry != null) consent.setExpiryDate(expiry.toLocalDateTime());
        Timestamp withdrawn = rs.getTimestamp("withdrawn_at");
        if (withdrawn != null) consent.setWithdrawnAt(withdrawn.toLocalDateTime());
        return consent;
    }
}
