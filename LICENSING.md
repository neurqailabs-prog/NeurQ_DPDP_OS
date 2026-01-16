# QS-DPDP OS - Licensing & Pricing Documentation

## License Types

### 1. Trial License
- **Duration**: 14 days
- **Features**: Full feature access
- **Purpose**: Evaluation and testing
- **Auto-expires**: After 14 days

### 2. Commercial License
- **Duration**: 1 year
- **Features**: Per product licensing
- **Renewal**: Annual renewal required
- **Support**: Standard support included

### 3. Enterprise Suite License
- **Duration**: 1 year
- **Features**: All products included
- **Renewal**: Annual renewal required
- **Support**: Premium support included

### 4. Government / PSU License
- **Duration**: 1 year
- **Features**: All products, special pricing
- **Renewal**: Annual renewal required
- **Support**: Dedicated support channel

### 5. Air-Gapped License
- **Duration**: Perpetual
- **Features**: All products, offline operation
- **Renewal**: Not required
- **Support**: Email support only

## Pricing Models

### Per User
- **Base Price**: Configurable (default: ₹X per user)
- **Calculation**: Base Price × Number of Users
- **Use Case**: Organizations with defined user base

### Per Data Principal
- **Base Price**: Configurable (default: ₹0.50 per data principal)
- **Calculation**: Base Price × Number of Data Principals
- **Use Case**: QS-DPDP Core

### Per Endpoint
- **Base Price**: Configurable (default: ₹5,000 per endpoint)
- **Calculation**: Base Price × Number of Endpoints
- **Use Case**: QS-DLP

### Per GB/day (SIEM)
- **Base Price**: Configurable (default: ₹100 per GB/day)
- **Calculation**: Base Price × GB processed per day
- **Use Case**: QS-SIEM

### Per TB Scanned (PII Scanner)
- **Base Price**: Configurable (default: ₹500 per TB)
- **Calculation**: Base Price × TB scanned
- **Use Case**: QS-PII Scanner

### Flat Enterprise
- **Base Price**: Configurable (default: ₹5,00,000)
- **Calculation**: Fixed price
- **Use Case**: Policy Engine, Enterprise deployments

## Default Pricing (Example)

| Product | Pricing Model | Base Price |
|---------|--------------|------------|
| QS-DPDP Core | Per Data Principal | ₹0.50 |
| QS-SIEM | Per GB/day | ₹100 |
| QS-DLP | Per Endpoint | ₹5,000 |
| QS-PII Scanner | Per TB Scanned | ₹500 |
| Policy Engine | Flat Enterprise | ₹5,00,000 |

## Volume Discounts

- **1000+ Users**: 15% discount
- **100,000+ Data Principals**: 20% discount
- **Enterprise Suite**: Additional 10% discount

## Pricing Governance

### Access Control
- Only users with role `NEURQ_SUPER_ADMIN` can modify pricing
- All pricing changes are cryptographically signed
- Tamper detection enabled

### Versioning
- All pricing policies are versioned
- Complete history maintained
- Effective date enforcement

### Audit Trail
- Every pricing change is logged
- Includes: timestamp, user, changes, signature
- Immutable audit log

## Simulation Mode

- Available for demos and proposals
- Calculate pricing without commitment
- Export pricing calculations
- Share with stakeholders

## License Installation

1. Obtain license file from NeurQ
2. Place `license.neurq` in installation directory
3. System validates on startup
4. Verify in Settings → License

## License Renewal

1. Contact NeurQ before expiration
2. Obtain new license file
3. Replace existing license file
4. System validates automatically

## Support

For licensing inquiries:
- Email: licensing@neurq.com
- Phone: [Contact Number]
- Portal: [License Portal URL]

## Terms & Conditions

- License is non-transferable
- Usage must comply with license terms
- Unauthorized use is prohibited
- Audit rights reserved by NeurQ
