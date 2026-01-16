# QS-DPDP OS - User Guide

## Introduction

Welcome to the QS-DPDP Operating System User Guide. This guide will help you navigate and use all features of the system.

## Getting Started

### Installation

1. Run the installer for your platform (MSI for Windows, DMG for macOS, DEB/RPM for Linux)
2. Choose between Trial (14 days) or Licensed installation
3. Select database type (SQLite default, or Oracle/PostgreSQL/SQL Server/MySQL)
4. Load sector-specific policies
5. Optionally load demo data (1500+ records)

### First Launch

1. Launch QS-DPDP OS
2. License validation will occur automatically
3. Select your organization's sector
4. Configure initial settings

## Core Features

### Consent Management

**Recording Consent:**
1. Navigate to Consent Management
2. Click "Record New Consent"
3. Enter Data Principal ID, Purpose, Data Category
4. Select Consent Type (One-Time, Short-Term, Long-Term, Perpetual)
5. Save

**Withdrawing Consent:**
1. Find the consent record
2. Click "Withdraw Consent"
3. Confirm withdrawal
4. System will trigger data deletion workflow

### Data Principal Rights

**Right to Access:**
1. Navigate to Data Principal Rights
2. Select "Access Information"
3. Enter Data Principal ID
4. View all personal data records

**Right to Correction:**
1. Select "Correction and Erasure"
2. Enter Record ID and corrections
3. Submit corrections
4. System notifies all data processors

**Right to Grievance:**
1. Select "Submit Grievance"
2. Fill grievance form
3. Submit
4. Track grievance status

**Right to Data Portability:**
1. Select "Export Data"
2. Choose format (JSON, XML, CSV)
3. Download exported data

### Breach Notification

**Reporting a Breach:**
1. Navigate to Breach Management
2. Click "Report Breach"
3. Fill breach details:
   - Description
   - Affected Data Principals
   - Affected Data Categories
   - Root Cause
   - Remediation Steps
4. Submit
5. System automatically:
   - Notifies Data Protection Board (72-hour SLA)
   - Notifies affected data principals
   - Generates breach report

### Compliance Scoring

**View Compliance Score:**
1. Navigate to Compliance Dashboard
2. View overall compliance score (0-100%)
3. Review section-wise scores:
   - Consent Management
   - Data Fiduciary Obligations
   - Breach Notification
   - Data Principal Rights
   - SDF Assessment
4. View recommendations for improvement

### AI Chatbot

**Using the Help Chatbot:**
1. Click Help menu
2. Select "AI Assistant"
3. Ask questions about:
   - DPDP Act compliance
   - Sector-specific requirements
   - Best practices
   - Policy interpretation
4. Get AI-powered responses with citations

## Multilingual Support

**Changing Language:**
1. Go to Settings
2. Select "Language"
3. Choose from 22 Indian languages
4. Interface updates immediately

## Keyboard Shortcuts

- `Ctrl+N`: New Consent
- `Ctrl+B`: Report Breach
- `Ctrl+R`: View Rights
- `Ctrl+C`: Compliance Dashboard
- `F1`: Help

## Troubleshooting

**License Issues:**
- Check license file exists
- Verify license hasn't expired
- Contact support for renewal

**Database Connection:**
- Verify database credentials
- Check network connectivity (if using remote DB)
- Review database logs

**Performance:**
- Clear cache
- Optimize database
- Check system resources

## Support

For additional support:
- Email: support@neurq.com
- Documentation: See Admin Guide and API Documentation
- AI Assistant: Available in Help menu
