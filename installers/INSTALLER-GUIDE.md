# 🪟 QS-DPDP OS - Windows Installer Guide

## 📦 Available Installers

### Individual Product Installers

Each product has its own Windows installer that creates a standalone desktop application:

1. **QS-DPDP Core** - `installers/Setup-QS-DPDP-Core.bat`
2. **QS-SIEM** - `installers/Setup-QS-SIEM.bat`
3. **QS-DLP** - `installers/Setup-QS-DLP.bat`
4. **QS-PII Scanner** - `installers/Setup-QS-PII-Scanner.bat`
5. **Policy Engine** - `installers/Setup-Policy-Engine.bat`

### Complete Suite Installer

**QS-DPDP OS Complete Suite** - `installers/Setup-QS-DPDP-OS-Complete.bat`

This installer installs ALL products as an integrated holistic solution.

---

## 🚀 How to Use

### Install Individual Product

1. Navigate to `installers` folder
2. Double-click the product installer (e.g., `Setup-QS-SIEM.bat`)
3. Follow the installation wizard
4. Product will be installed with its own desktop icon and splash screen

### Install Complete Suite

1. Navigate to `installers` folder
2. Double-click `Setup-QS-DPDP-OS-Complete.bat`
3. Follow the installation wizard
4. All products will be installed as integrated suite
5. Main desktop icon launches integrated application
6. Individual products also available in Start Menu

---

## ✨ Features

### Each Installer Provides:

✅ **Proper Windows Setup**
- Installation wizard interface
- Progress indicators
- Error handling
- Component selection

✅ **Desktop Integration**
- Desktop shortcut with custom icon
- Start Menu entry
- Windows registry registration
- Appears in Add/Remove Programs

✅ **Product-Specific**
- Custom splash screen for each product
- Product-specific icon
- Individual launcher
- Isolated installation directory

✅ **Desktop-Based Applications**
- All products launch as JavaFX desktop applications
- NOT browser-based
- Native Windows integration
- Professional enterprise UI

---

## 📁 Installation Locations

### Individual Products

- **QS-DPDP Core**: `%LOCALAPPDATA%\NeurQ\QS-DPDP-Core`
- **QS-SIEM**: `%LOCALAPPDATA%\NeurQ\QS-SIEM`
- **QS-DLP**: `%LOCALAPPDATA%\NeurQ\QS-DLP`
- **QS-PII Scanner**: `%LOCALAPPDATA%\NeurQ\QS-PII-Scanner`
- **Policy Engine**: `%LOCALAPPDATA%\NeurQ\Policy-Engine`

### Complete Suite

- **QS-DPDP OS**: `%LOCALAPPDATA%\NeurQ\QS-DPDP-OS`
  - `core\` - QS-DPDP Core files
  - `siem\` - QS-SIEM files
  - `dlp\` - QS-DLP files
  - `pii-scanner\` - QS-PII Scanner files
  - `policy-engine\` - Policy Engine files

---

## 🎯 Desktop Icons

Each product installer creates:

1. **Desktop Shortcut** - Direct access from desktop
2. **Start Menu Entry** - Under "NeurQ" folder
3. **Custom Icon** - Product-specific icon
4. **Splash Screen** - Product-specific splash on launch

---

## 🔧 Technical Details

### Application Type

All products are **desktop-based JavaFX applications**:
- NOT browser-based
- Native Windows integration
- Professional enterprise UI
- Offline capable
- Air-gapped deployment ready

### Launcher Behavior

Each launcher:
1. Shows product-specific splash screen
2. Launches JavaFX desktop application
3. Integrates with Windows
4. Provides native desktop experience

### Complete Suite Integration

When installing the complete suite:
- All products installed in one location
- Integrated launcher launches unified application
- Individual products still accessible separately
- Holistic DPDP compliance solution

---

## 🗑️ Uninstallation

### Individual Product

Run: `%INSTALL_DIR%\uninstall.bat`

Or use: Control Panel → Programs → Uninstall

### Complete Suite

Run: `%LOCALAPPDATA%\NeurQ\QS-DPDP-OS\uninstall.bat`

This removes all integrated products.

---

## 📋 Quick Reference

| Product | Installer File | Desktop Icon | Splash Screen |
|---------|---------------|--------------|--------------|
| QS-DPDP Core | `Setup-QS-DPDP-Core.bat` | ✅ | ✅ |
| QS-SIEM | `Setup-QS-SIEM.bat` | ✅ | ✅ |
| QS-DLP | `Setup-QS-DLP.bat` | ✅ | ✅ |
| QS-PII Scanner | `Setup-QS-PII-Scanner.bat` | ✅ | ✅ |
| Policy Engine | `Setup-Policy-Engine.bat` | ✅ | ✅ |
| **Complete Suite** | `Setup-QS-DPDP-OS-Complete.bat` | ✅ | ✅ |

---

## ✅ Installation Checklist

After running any installer, verify:

- [ ] Installation directory created
- [ ] Desktop shortcut exists with custom icon
- [ ] Start Menu entry exists
- [ ] Application files copied
- [ ] Splash screen present
- [ ] Launcher created
- [ ] Configuration file created
- [ ] Uninstaller created
- [ ] Registered in Windows

---

**All installers create proper Windows desktop applications - NOT browser-based!**

*Created: January 15, 2026*  
*Version: 1.0.0*
