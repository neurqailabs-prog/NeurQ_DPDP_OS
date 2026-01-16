# QS-DPDP OS - Administrator Guide

## Introduction

This guide is for system administrators responsible for configuring and managing QS-DPDP OS.

## System Architecture

### Components
- **QS-DPDP Core**: Core compliance engine
- **QS-SIEM**: Security Information and Event Management
- **QS-DLP**: Data Loss Prevention
- **QS-PII Scanner**: PII discovery and classification
- **Policy Engine**: Sector-wise policy management
- **Licensing Engine**: License and pricing management

### Database Configuration

**SQLite (Default):**
- No configuration needed
- File-based database
- Suitable for small deployments

**Oracle/PostgreSQL/SQL Server/MySQL:**
1. Navigate to Database Settings
2. Enter connection details:
   - Host
   - Port
   - Database name
   - Username
   - Password
3. Test connection
4. Save configuration

## License Management

### License Types
- **Trial**: 14 days, full features
- **Commercial**: 1 year, per product
- **Enterprise Suite**: All products, 1 year
- **Government/PSU**: Special pricing, 1 year
- **Air-Gapped**: Perpetual, offline

### Installing License
1. Obtain license file from NeurQ
2. Place license file in installation directory
3. System validates on startup
4. Verify license status in Settings

## Pricing Configuration (NEURQ_SUPER_ADMIN Only)

### Accessing Pricing UI
1. Login as NEURQ_SUPER_ADMIN
2. Navigate to Pricing Management
3. View current pricing policies

### Modifying Pricing
1. Click "Edit Pricing Policy"
2. Select product
3. Update pricing model and base price
4. Sign policy (cryptographic signature)
5. Save (creates versioned history)

### Pricing Models
- **Per User**: Base price × user count
- **Per Data Principal**: Base price × data principal count
- **Per Endpoint**: Base price × endpoint count
- **Per GB/day**: Base price × GB/day (SIEM)
- **Per TB scanned**: Base price × TB scanned (PII Scanner)
- **Flat Enterprise**: Fixed price

### Pricing History
- All pricing changes are versioned
- View history in Pricing Management
- Audit trail for compliance

## Policy Configuration

### Sector Selection
1. Navigate to Policy Engine
2. Select organization sector (12 sectors available)
3. Load sector-specific policies
4. Customize policies as needed

### Editing Policies
1. Select policy clause
2. Click "Edit"
3. Modify content
4. Map to DPDP sections/rules
5. Save

### DPIA Automation
1. Navigate to DPIA Generator
2. Select organization and sector
3. Generate DPIA report
4. Review risk assessment
5. Export report

## SIEM Configuration

### Log Sources
- Configure 500+ log sources
- Add custom log sources
- Set up log ingestion rules

### Query Language
- Use SPL/KQL-like syntax
- Example: `source=firewall AND severity=High AND dpdp_relevant=true`
- Save queries for reuse

### Alerts
- Configure DPDP-specific alerts
- Set alert thresholds
- Configure notification channels

## DLP Configuration

### Network DLP
- Configure network monitoring
- Set up PII detection rules
- Configure blocking/quarantine actions

### Endpoint DLP
- Deploy endpoint agents
- Configure file scanning
- Set up OCR for Indian languages

### Discovery DLP
- Configure data store scanning
- Schedule discovery scans
- Review discovery results

## PII Scanner Configuration

### Scan Targets
- File systems
- Databases
- Cloud storage (AWS, Azure, GCP)

### ML Model
- Load pre-trained ML models
- Customize classification rules
- Configure risk scoring thresholds

## Security Configuration

### Quantum-Safe Cryptography
- System uses NIST PQC by default
- Kyber-768 for encryption
- Dilithium-3 for signatures
- No additional configuration needed

### Access Control
- Configure user roles
- Set permissions
- Enable MFA (if supported)

### Audit Logging
- Enable audit logging
- Configure log retention
- Export audit logs

## Backup and Recovery

### Database Backup
1. Navigate to Backup Settings
2. Configure backup schedule
3. Set backup location
4. Test restore procedure

### Configuration Backup
- Export configuration
- Store securely
- Restore when needed

## Performance Tuning

### Database Optimization
- Run database maintenance
- Optimize indexes
- Review query performance

### Resource Allocation
- Adjust JVM heap size
- Configure thread pools
- Monitor resource usage

## Monitoring

### System Health
- Monitor system metrics
- Check license status
- Review error logs

### Compliance Monitoring
- Track compliance scores
- Monitor breach notifications
- Review audit logs

## Troubleshooting

### Common Issues

**License Validation Failed:**
- Check license file integrity
- Verify system date/time
- Contact support

**Database Connection Issues:**
- Verify credentials
- Check network connectivity
- Review database logs

**Performance Issues:**
- Check system resources
- Review database performance
- Optimize queries

## Support

For administrative support:
- Email: admin-support@neurq.com
- Documentation: See API Documentation
- Training: Contact for training sessions
