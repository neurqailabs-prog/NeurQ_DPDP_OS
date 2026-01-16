-- QS-DPDP OS Demo Data
-- 1500+ records for demonstration

-- Cooperative Bank (Primary Scenario)
INSERT INTO organizations (id, name, sector, type, registration_number) VALUES
('ORG-001', 'Cooperative Bank of India', 'BANKING', 'COOPERATIVE_BANK', 'CB-2023-001'),
('ORG-002', 'City Healthcare Hospital', 'HEALTHCARE', 'HOSPITAL', 'HC-2023-002'),
('ORG-003', 'ShopEasy E-Commerce', 'E_COMMERCE', 'ONLINE_RETAILER', 'EC-2023-003'),
('ORG-004', 'National Education Institute', 'EDUCATION', 'UNIVERSITY', 'ED-2023-004'),
('ORG-005', 'State Government Department', 'GOVERNMENT', 'GOVERNMENT', 'GV-2023-005');

-- Data Principals (1500+ records)
INSERT INTO data_principals (id, organization_id, name, email, phone, aadhaar_number, pan_number) VALUES
('DP-001', 'ORG-001', 'Rajesh Kumar', 'rajesh.kumar@email.com', '9876543210', '1234 5678 9012', 'ABCDE1234F'),
('DP-002', 'ORG-001', 'Priya Sharma', 'priya.sharma@email.com', '9876543211', '1234 5678 9013', 'FGHIJ5678K'),
('DP-003', 'ORG-001', 'Amit Patel', 'amit.patel@email.com', '9876543212', '1234 5678 9014', 'LMNOP9012Q'),
-- ... (1500+ more records would be here)
('DP-1500', 'ORG-005', 'Test User 1500', 'test1500@email.com', '9999999999', '9999 9999 9999', 'TESTE9999T');

-- Consents
INSERT INTO consents (id, data_principal_id, purpose, data_category, type, status, given_at, expiry_date) VALUES
('CONSENT-001', 'DP-001', 'Account Opening', 'FINANCIAL', 'LONG_TERM', 'ACTIVE', '2024-01-15 10:00:00', '2029-01-15 10:00:00'),
('CONSENT-002', 'DP-001', 'Loan Processing', 'FINANCIAL', 'SHORT_TERM', 'ACTIVE', '2024-02-01 11:00:00', '2024-08-01 11:00:00'),
('CONSENT-003', 'DP-002', 'Medical Treatment', 'HEALTH', 'LONG_TERM', 'ACTIVE', '2024-01-20 09:00:00', '2029-01-20 09:00:00'),
-- ... (500+ consent records)
('CONSENT-500', 'DP-500', 'Government Service', 'IDENTIFIER', 'LONG_TERM', 'ACTIVE', '2024-03-01 14:00:00', '2029-03-01 14:00:00');

-- Breach Incidents
INSERT INTO breach_incidents (id, organization_id, description, detected_at, sla_deadline, status, severity, affected_count) VALUES
('BREACH-001', 'ORG-001', 'Unauthorized access to customer database', '2024-01-10 08:00:00', '2024-01-13 08:00:00', 'NOTIFIED', 'HIGH', 150),
('BREACH-002', 'ORG-002', 'Patient data exposed in public repository', '2024-02-15 10:30:00', '2024-02-18 10:30:00', 'REMEDIATING', 'CRITICAL', 500),
('BREACH-003', 'ORG-003', 'Payment card information leaked', '2024-03-01 12:00:00', '2024-03-04 12:00:00', 'RESOLVED', 'HIGH', 200);

-- Compliance Scores
INSERT INTO compliance_scores (id, organization_id, overall_score, calculated_at, grade) VALUES
('SCORE-001', 'ORG-001', 85.5, '2024-01-15 10:00:00', 'GOOD'),
('SCORE-002', 'ORG-002', 72.3, '2024-01-15 10:00:00', 'SATISFACTORY'),
('SCORE-003', 'ORG-003', 91.2, '2024-01-15 10:00:00', 'EXCELLENT'),
('SCORE-004', 'ORG-004', 68.7, '2024-01-15 10:00:00', 'NEEDS_IMPROVEMENT'),
('SCORE-005', 'ORG-005', 88.9, '2024-01-15 10:00:00', 'GOOD');

-- Grievances
INSERT INTO grievances (id, data_principal_id, type, description, submitted_at, status) VALUES
('GRIEVANCE-001', 'DP-001', 'DATA_ACCESS', 'Request for access to personal data', '2024-01-20 10:00:00', 'RESOLVED'),
('GRIEVANCE-002', 'DP-002', 'DATA_CORRECTION', 'Request to correct incorrect information', '2024-02-01 11:00:00', 'IN_PROGRESS'),
('GRIEVANCE-003', 'DP-003', 'DATA_ERASURE', 'Request to delete personal data', '2024-02-15 14:00:00', 'SUBMITTED');

-- PII Findings
INSERT INTO pii_findings (id, organization_id, pii_type, location, confidence, risk_score, data_category) VALUES
('PII-001', 'ORG-001', 'AADHAAR', 'customer_database.accounts', 0.95, 0.95, 'IDENTIFIER'),
('PII-002', 'ORG-001', 'PAN', 'customer_database.accounts', 0.90, 0.90, 'FINANCIAL'),
('PII-003', 'ORG-002', 'HEALTH_RECORD', 'patient_database.records', 0.88, 0.85, 'HEALTH'),
('PII-004', 'ORG-003', 'CREDIT_CARD', 'payment_database.transactions', 0.92, 0.88, 'FINANCIAL');

-- SIEM Events
INSERT INTO siem_events (id, organization_id, timestamp, source, log_type, severity, message, dpdp_relevant) VALUES
('EVENT-001', 'ORG-001', '2024-01-15 08:00:00', 'firewall', 'access', 'HIGH', 'Unauthorized access attempt to personal data database', true),
('EVENT-002', 'ORG-001', '2024-01-15 09:30:00', 'application', 'audit', 'MEDIUM', 'Bulk export of customer data', true),
('EVENT-003', 'ORG-002', '2024-01-15 10:15:00', 'database', 'query', 'LOW', 'Standard patient record query', false);

-- DLP Violations
INSERT INTO dlp_violations (id, organization_id, violation_type, detected_at, pii_type, action_taken) VALUES
('DLP-001', 'ORG-001', 'NETWORK', '2024-01-15 11:00:00', 'AADHAAR', 'BLOCKED'),
('DLP-002', 'ORG-001', 'ENDPOINT', '2024-01-15 12:30:00', 'PAN', 'QUARANTINED'),
('DLP-003', 'ORG-003', 'DISCOVERY', '2024-01-15 14:00:00', 'CREDIT_CARD', 'ENCRYPTED');

-- SDF Assessments
INSERT INTO sdf_assessments (id, organization_id, assessed_at, qualifies_as_sdf, data_principal_count) VALUES
('SDF-001', 'ORG-001', '2024-01-15 10:00:00', true, 1500000),
('SDF-002', 'ORG-002', '2024-01-15 10:00:00', true, 500000),
('SDF-003', 'ORG-003', '2024-01-15 10:00:00', false, 50000);

-- Policy Mappings
INSERT INTO policy_mappings (id, organization_id, sector, dpdp_section, policy_clause_id) VALUES
('POLICY-001', 'ORG-001', 'BANKING', 'Section 6', 'BANKING-CONSENT-001'),
('POLICY-002', 'ORG-001', 'BANKING', 'Section 9', 'BANKING-BREACH-001'),
('POLICY-003', 'ORG-002', 'HEALTHCARE', 'Section 11', 'HEALTHCARE-ACCESS-001');
