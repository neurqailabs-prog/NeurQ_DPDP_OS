# QS-DPDP Operating System

**Quantum-Safe DPDP Compliance Operating System**

A complete, production-grade, desktop-based compliance operating system for the Digital Personal Data Protection Act 2023 (India) with quantum-safe cryptography.

## 🎯 Overview

QS-DPDP OS is a comprehensive suite of modular products designed to ensure 100% compliance with the DPDP Act 2023 and its associated rules. The system operates fully offline, supports air-gapped deployments, and implements NIST Post-Quantum Cryptography standards.

## 📦 Products

1. **QS-DPDP Core** (Java 21, GraalVM) - Core compliance engine
2. **QS-SIEM** (Rust 70%, Java 30%) - Security Information and Event Management
3. **QS-DLP** (Rust 60%, Java 40%) - Data Loss Prevention
4. **QS-PII Scanner** (Rust + Python + Java) - PII discovery and classification
5. **Policy Engine** (Java 21) - Sector-wise DPDP policy management

## 🚀 Quick Start

### Prerequisites

- Java 21 or higher
- Maven 3.8+
- Rust 1.75+ (for SIEM and DLP)
- Python 3.11+ (for PII Scanner)
- GraalVM 23.1.0+ (for native executables, optional)

### Build

**Windows:**
```batch
build-all.bat
```

**Linux/macOS:**
```bash
./build.sh
```

### Run

**Windows:**
```batch
run.bat
```

**Linux/macOS:**
```bash
./run.sh
```

## 📋 Installation

### Installer Wizard

Launch the installer wizard:
```batch
java -jar installer-wizard/target/installer-wizard-1.0.0.jar
```

The wizard supports:
- Trial (14 days) or Licensed installation
- Database selection (SQLite, Oracle, PostgreSQL, SQL Server, MySQL)
- Sector policy selection (12 sectors)
- Demo data loading (1500+ records)

### Manual Installation

1. Extract the portable ZIP package
2. Configure `config.properties`
3. Run the application

## 🔐 Licensing

The system includes a comprehensive licensing engine with:

- **License Types:** Trial, Commercial, Enterprise Suite, Government/PSU, Air-Gapped
- **Pricing Models:** Per User, Per Data Principal, Per Endpoint, Per GB/day, Per TB scanned, Flat Enterprise
- **Access Control:** Pricing UI restricted to `NEURQ_SUPER_ADMIN` role

## 🌐 Multilingual Support

Supports all 22 Indian languages:
Hindi, English, Bengali, Telugu, Marathi, Tamil, Urdu, Gujarati, Kannada, Odia, Punjabi, Malayalam, Assamese, Nepali, Maithili, Sanskrit, Sindhi, Kashmiri, Konkani, Manipuri, Dogri, Santali

## 🔒 Security Features

- **Quantum-Safe Cryptography:** NIST PQC (Kyber-768, Dilithium-3)
- **OWASP ASVS Level 2** compliance
- **CERT-In, STQC, DSCI** ready
- **ISO 27001/27701** mappings

## 📚 Documentation

- **User Guide:** `docs/user/README.md`
- **Admin Guide:** `docs/admin/README.md`
- **API Documentation:** `docs/api/README.md`
- **Licensing Guide:** `LICENSING.md`

## 🧪 Demo Data

The installer includes demo data for:
- Cooperative Bank (primary scenario)
- Healthcare Organization
- E-Commerce Platform
- Educational Institution
- Government Department

## 🏗️ Architecture

```
qs-dpdp-os/
├── qs-dpdp-core/          # Core compliance engine
├── qs-siem/               # SIEM with 500+ log sources
├── qs-dlp/                # DLP with Indian language OCR
├── qs-pii-scanner/        # ML-based PII discovery
├── policy-engine/         # Sector-wise policy management
├── licensing-engine/      # Licensing & pricing
├── common/                # Shared libraries
├── installers/            # MSI, DMG, DEB, RPM
└── demo-data/             # Demo databases
```

## 🔧 Configuration

Edit `config.properties`:

```properties
# Database
db.type=SQLite
db.path=./qsdpdp.db

# License
license.type=TRIAL
license.key=

# Language
i18n.locale=en

# Quantum-Safe Crypto
crypto.algorithm=KYBER-768
```

## 📊 Compliance Features

- ✅ Consent lifecycle management (Sections 6-7)
- ✅ Data Principal Rights (Sections 11-15)
- ✅ Breach notification (72-hour SLA, Section 9)
- ✅ SDF assessment (Section 10)
- ✅ Compliance scoring (0-100%)
- ✅ RAG-based predictive risk analysis

## 🤖 AI Features

- **RAG System:** DPDP Act + Rules corpus, sectoral guidelines
- **AI Chatbot:** Accessible via Help menu
- **Predictive Compliance Scoring:** ML-based risk analysis

## 📞 Support

For support, licensing, and commercial inquiries, contact NeurQ.

## 📄 License

Proprietary - NeurQ Technologies

---

**Version:** 1.0.0  
**Build Date:** 2025-01-15  
**Certification Status:** Certification-Ready
