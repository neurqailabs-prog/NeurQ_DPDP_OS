-- QS-DPDP OS Demo Database Schema (SQLite)

-- Consents Table
CREATE TABLE consents (
    id TEXT PRIMARY KEY,
    data_principal_id TEXT NOT NULL,
    purpose TEXT NOT NULL,
    data_category TEXT NOT NULL,
    type TEXT NOT NULL,
    status TEXT NOT NULL,
    given_at TIMESTAMP NOT NULL,
    expiry_date TIMESTAMP,
    withdrawn_at TIMESTAMP
);

-- Personal Data Records
CREATE TABLE personal_data_records (
    id TEXT PRIMARY KEY,
    data_principal_id TEXT NOT NULL,
    data TEXT NOT NULL, -- JSON
    collected_at TIMESTAMP NOT NULL,
    last_modified TIMESTAMP,
    modified_by TEXT,
    purpose TEXT,
    data_category TEXT,
    deleted BOOLEAN DEFAULT 0,
    deleted_at TIMESTAMP
);

-- Breach Incidents
CREATE TABLE breach_incidents (
    id TEXT PRIMARY KEY,
    description TEXT NOT NULL,
    detected_at TIMESTAMP NOT NULL,
    sla_deadline TIMESTAMP NOT NULL,
    status TEXT NOT NULL,
    severity TEXT NOT NULL,
    root_cause TEXT,
    remediation_steps TEXT -- JSON array
);

-- Affected Data Principals (Many-to-Many)
CREATE TABLE breach_affected_principals (
    breach_id TEXT NOT NULL,
    data_principal_id TEXT NOT NULL,
    PRIMARY KEY (breach_id, data_principal_id),
    FOREIGN KEY (breach_id) REFERENCES breach_incidents(id)
);

-- Affected Data Categories (Many-to-Many)
CREATE TABLE breach_affected_categories (
    breach_id TEXT NOT NULL,
    category TEXT NOT NULL,
    PRIMARY KEY (breach_id, category),
    FOREIGN KEY (breach_id) REFERENCES breach_incidents(id)
);

-- Grievances
CREATE TABLE grievances (
    id TEXT PRIMARY KEY,
    data_principal_id TEXT NOT NULL,
    type TEXT NOT NULL,
    description TEXT NOT NULL,
    submitted_at TIMESTAMP NOT NULL,
    status TEXT NOT NULL,
    assigned_officer TEXT
);

-- Nominees
CREATE TABLE nominees (
    id TEXT PRIMARY KEY,
    data_principal_id TEXT NOT NULL,
    nominee_name TEXT NOT NULL,
    nominee_contact TEXT NOT NULL,
    nominated_at TIMESTAMP NOT NULL,
    status TEXT NOT NULL
);

-- Compliance Scores
CREATE TABLE compliance_scores (
    organization_id TEXT PRIMARY KEY,
    calculated_at TIMESTAMP NOT NULL,
    overall_score REAL NOT NULL,
    section_scores TEXT NOT NULL, -- JSON
    grade TEXT NOT NULL,
    recommendations TEXT -- JSON array
);

-- Demo Data: Cooperative Bank
INSERT INTO consents VALUES 
('CONS-001', 'DP-BANK-001', 'Account Management', 'FINANCIAL', 'LONG_TERM', 'ACTIVE', '2024-01-01 10:00:00', '2029-01-01 10:00:00', NULL),
('CONS-002', 'DP-BANK-002', 'Loan Processing', 'FINANCIAL', 'SHORT_TERM', 'ACTIVE', '2024-01-02 11:00:00', '2024-07-02 11:00:00', NULL);

INSERT INTO personal_data_records VALUES
('REC-001', 'DP-BANK-001', '{"name":"Rajesh Kumar","email":"rajesh@example.com","account":"1234567890"}', '2024-01-01 10:00:00', NULL, NULL, 'Account Management', 'FINANCIAL', 0, NULL),
('REC-002', 'DP-BANK-002', '{"name":"Priya Sharma","phone":"9876543210","loan_amount":500000}', '2024-01-02 11:00:00', NULL, NULL, 'Loan Processing', 'FINANCIAL', 0, NULL);

-- Demo Data: Healthcare
INSERT INTO consents VALUES
('CONS-003', 'DP-HEALTH-001', 'Medical Treatment', 'HEALTH', 'LONG_TERM', 'ACTIVE', '2024-01-03 09:00:00', '2029-01-03 09:00:00', NULL);

INSERT INTO personal_data_records VALUES
('REC-003', 'DP-HEALTH-001', '{"name":"Amit Patel","diagnosis":"Diabetes","medication":"Metformin"}', '2024-01-03 09:00:00', NULL, NULL, 'Medical Treatment', 'HEALTH', 0, NULL);

-- Demo Data: E-Commerce
INSERT INTO consents VALUES
('CONS-004', 'DP-ECOMM-001', 'Order Processing', 'CONTACT', 'SHORT_TERM', 'ACTIVE', '2024-01-04 14:00:00', '2024-07-04 14:00:00', NULL);

INSERT INTO personal_data_records VALUES
('REC-004', 'DP-ECOMM-001', '{"name":"Sneha Reddy","address":"123 Main St","order_id":"ORD-001"}', '2024-01-04 14:00:00', NULL, NULL, 'Order Processing', 'CONTACT', 0, NULL);

-- Demo Data: Education
INSERT INTO consents VALUES
('CONS-005', 'DP-EDU-001', 'Student Records', 'EDUCATION', 'LONG_TERM', 'ACTIVE', '2024-01-05 08:00:00', '2029-01-05 08:00:00', NULL);

INSERT INTO personal_data_records VALUES
('REC-005', 'DP-EDU-001', '{"name":"Vikram Singh","student_id":"STU-001","grades":"A"}', '2024-01-05 08:00:00', NULL, NULL, 'Student Records', 'EDUCATION', 0, NULL);

-- Demo Data: Government
INSERT INTO consents VALUES
('CONS-006', 'DP-GOV-001', 'Citizen Services', 'IDENTIFIER', 'PERPETUAL', 'ACTIVE', '2024-01-06 12:00:00', NULL, NULL);

INSERT INTO personal_data_records VALUES
('REC-006', 'DP-GOV-001', '{"name":"Anjali Desai","aadhaar":"1234 5678 9012","service":"Passport"}', '2024-01-06 12:00:00', NULL, NULL, 'Citizen Services', 'IDENTIFIER', 0, NULL);

-- Sample Breach Incident (for demo)
INSERT INTO breach_incidents VALUES
('BREACH-001', 'Unauthorized access to customer database', '2024-01-10 15:30:00', '2024-01-13 15:30:00', 'NOTIFIED', 'HIGH', 'SQL Injection vulnerability', '["Patch applied", "Access revoked", "Database secured"]');

INSERT INTO breach_affected_principals VALUES
('BREACH-001', 'DP-BANK-001'),
('BREACH-001', 'DP-BANK-002');

INSERT INTO breach_affected_categories VALUES
('BREACH-001', 'FINANCIAL'),
('BREACH-001', 'CONTACT');

-- Sample Compliance Score
INSERT INTO compliance_scores VALUES
('ORG-001', '2024-01-15 10:00:00', 85.5, '{"CONSENT_MANAGEMENT":90.0,"DATA_FIDUCIARY_OBLIGATIONS":85.0,"BREACH_NOTIFICATION":80.0,"DATA_PRINCIPAL_RIGHTS":90.0,"SDF_ASSESSMENT":82.0}', 'GOOD', '["Improve BREACH_NOTIFICATION compliance"]');
