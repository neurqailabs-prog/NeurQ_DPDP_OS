# QS-DPDP OS - API Documentation

## Overview

QS-DPDP OS provides comprehensive APIs for programmatic access to all features.

## Base URL

```
http://localhost:8080/api/v1
```

## Authentication

All API requests require authentication via license key:

```
Authorization: Bearer <license-key>
```

## Endpoints

### Consent Management

#### Record Consent
```
POST /consent
Content-Type: application/json

{
  "dataPrincipalId": "DP001",
  "purpose": "Account Management",
  "dataCategory": "FINANCIAL",
  "type": "LONG_TERM"
}
```

#### Withdraw Consent
```
DELETE /consent/{consentId}?dataPrincipalId={dataPrincipalId}
```

#### Get Consents
```
GET /consent?dataPrincipalId={dataPrincipalId}
```

### Data Principal Rights

#### Access Information
```
GET /rights/access?dataPrincipalId={dataPrincipalId}
```

#### Correct Data
```
PUT /rights/correction
Content-Type: application/json

{
  "dataPrincipalId": "DP001",
  "recordId": "REC001",
  "corrections": {
    "email": "newemail@example.com"
  }
}
```

#### Erase Data
```
DELETE /rights/erasure?dataPrincipalId={dataPrincipalId}&recordId={recordId}
```

#### Submit Grievance
```
POST /rights/grievance
Content-Type: application/json

{
  "dataPrincipalId": "DP001",
  "type": "DATA_ACCESS",
  "description": "Unable to access my data"
}
```

#### Export Data
```
GET /rights/portability?dataPrincipalId={dataPrincipalId}&format=JSON
```

### Breach Notification

#### Report Breach
```
POST /breach
Content-Type: application/json

{
  "description": "Unauthorized access detected",
  "affectedDataPrincipals": ["DP001", "DP002"],
  "affectedDataCategories": ["FINANCIAL", "CONTACT"],
  "rootCause": "System vulnerability",
  "remediationSteps": ["Patch applied", "Access revoked"]
}
```

#### Get Breach Status
```
GET /breach/{breachId}
```

### Compliance Scoring

#### Get Compliance Score
```
GET /compliance/score?organizationId={orgId}
```

Response:
```json
{
  "organizationId": "ORG001",
  "overallScore": 85.5,
  "sectionScores": {
    "CONSENT_MANAGEMENT": 90.0,
    "DATA_FIDUCIARY_OBLIGATIONS": 85.0,
    "BREACH_NOTIFICATION": 80.0,
    "DATA_PRINCIPAL_RIGHTS": 90.0,
    "SDF_ASSESSMENT": 82.0
  },
  "grade": "GOOD",
  "recommendations": [
    "Improve BREACH_NOTIFICATION compliance (current: 80.0%)"
  ]
}
```

### SIEM

#### Ingest Log
```
POST /siem/logs
Content-Type: application/json

{
  "id": "evt-001",
  "timestamp": 1705315200,
  "source": "firewall",
  "logType": "access",
  "severity": "HIGH",
  "message": "Unauthorized access attempt",
  "metadata": {}
}
```

#### Query Logs
```
POST /siem/query
Content-Type: application/json

{
  "query": "source=firewall AND severity=High AND dpdp_relevant=true"
}
```

### DLP

#### Scan Network
```
POST /dlp/network/scan
Content-Type: application/octet-stream

<packet-data>
```

#### Scan Endpoint
```
POST /dlp/endpoint/scan
Content-Type: application/json

{
  "filePath": "/path/to/file"
}
```

### PII Scanner

#### Scan File System
```
POST /pii-scanner/filesystem
Content-Type: application/json

{
  "rootPath": "/data"
}
```

#### Scan Database
```
POST /pii-scanner/database
Content-Type: application/json

{
  "connectionString": "jdbc:postgresql://localhost:5432/mydb"
}
```

### Policy Engine

#### Get Sector Policy
```
GET /policy/sector/{sector}
```

#### Generate DPIA
```
POST /policy/dpia
Content-Type: application/json

{
  "organizationId": "ORG001",
  "sector": "BANKING"
}
```

### RAG System

#### Query AI Assistant
```
POST /rag/query
Content-Type: application/json

{
  "question": "What are the consent requirements under DPDP Act?"
}
```

## Error Responses

All errors follow this format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

Common error codes:
- `LICENSE_INVALID`: License validation failed
- `UNAUTHORIZED`: Authentication failed
- `NOT_FOUND`: Resource not found
- `VALIDATION_ERROR`: Request validation failed
- `INTERNAL_ERROR`: Internal server error

## Rate Limiting

- 1000 requests per hour per license
- Rate limit headers included in responses:
  - `X-RateLimit-Limit`: Maximum requests
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset timestamp

## SDKs

Official SDKs available for:
- Java
- Python
- JavaScript/TypeScript
- .NET

Contact support for SDK access.
