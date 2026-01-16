# 🪟 QS-DPDP OS - Windows Installer Setup Guide

## ✅ Proper Windows Installer Created

A Windows-style installer has been created that works like standard Windows software.

---

## 📦 Installer Files

### 1. Enhanced Batch Installer (Works Now)
**File:** `create-enhanced-installer.bat` or `QS-DPDP-OS-Installer.bat`

**Features:**
- ✅ Installation wizard interface
- ✅ License agreement screen
- ✅ Component selection
- ✅ Installation directory selection
- ✅ Progress indicators
- ✅ Proper error handling
- ✅ Desktop shortcut creation
- ✅ Start Menu entry
- ✅ Uninstaller creation
- ✅ Registry registration

### 2. NSIS Installer (Professional - Requires NSIS)
**File:** `installer/NSIS-Installer.nsi`

**To create:**
1. Install NSIS from: https://nsis.sourceforge.io/
2. Run: `installer/create-windows-installer.bat`
3. Creates: `QS-DPDP-OS-Setup.exe`

### 3. Inno Setup Installer (Professional - Requires Inno Setup)
**File:** `installer/Inno-Installer.iss`

**To create:**
1. Install Inno Setup from: https://jrsoftware.org/isinfo.php
2. Run: `installer/create-windows-installer.bat`
3. Creates: `QS-DPDP-OS-Setup.exe`

---

## 🚀 How to Use

### Method 1: Enhanced Batch Installer (Recommended - Works Now)

**Run:**
```
create-enhanced-installer.bat
```

**Or:**
```
QS-DPDP-OS-Installer.bat
```

**Steps:**
1. Welcome screen appears
2. Accept license agreement
3. Choose installation directory (or use default)
4. Select components (Desktop shortcut, Start Menu)
5. Installation proceeds with progress
6. Completion screen

### Method 2: Professional Installer (Requires Tools)

**For NSIS:**
1. Install NSIS
2. Run: `installer/create-windows-installer.bat`
3. Get: `QS-DPDP-OS-Setup.exe`

**For Inno Setup:**
1. Install Inno Setup
2. Run: `installer/create-windows-installer.bat`
3. Get: `QS-DPDP-OS-Setup.exe`

---

## ✅ What the Installer Does

1. **Creates Installation Directory**
   - Default: `%LOCALAPPDATA%\NeurQ\QS-DPDP-OS`
   - User can change location

2. **Copies All Files**
   - Application files
   - Splash screen
   - Icon file
   - Documentation

3. **Creates Shortcuts**
   - Desktop shortcut (with custom icon)
   - Start Menu entry
   - Both with proper icons

4. **Creates Configuration**
   - config.properties file
   - Installation metadata

5. **Creates Uninstaller**
   - uninstall.bat in installation directory
   - Removes all files and shortcuts

6. **Registers Application**
   - Windows registry entries
   - Appears in Add/Remove Programs

---

## 📋 Installation Process

### Step-by-Step:

1. **Welcome Screen**
   - Product information
   - Click Next

2. **License Agreement**
   - Read license
   - Accept to continue

3. **Installation Directory**
   - Default location shown
   - Option to change

4. **Component Selection**
   - Desktop shortcut (default: Yes)
   - Start Menu entry (default: Yes)

5. **Installation**
   - Progress shown
   - Files copied
   - Shortcuts created

6. **Completion**
   - Success message
   - Option to launch
   - Installation directory opened

---

## 🔧 Troubleshooting

### If Installation Fails:

1. **Check Permissions**
   - Ensure write access to installation directory
   - Try different directory if needed

2. **Check Files**
   - Verify all source files exist
   - Check file paths

3. **Run as Administrator** (if needed)
   - Right-click installer → Run as administrator

4. **Check Logs**
   - Installation errors shown on screen
   - Review error messages

---

## 📁 Installation Locations

**Application:**
```
C:\Users\[Username]\AppData\Local\NeurQ\QS-DPDP-OS
```

**Desktop Shortcut:**
```
C:\Users\[Username]\Desktop\QS-DPDP OS.lnk
```

**Start Menu:**
```
C:\Users\[Username]\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\NeurQ\QS-DPDP OS.lnk
```

---

## 🗑️ Uninstallation

**Method 1: Using Uninstaller**
```
C:\Users\[Username]\AppData\Local\NeurQ\QS-DPDP-OS\uninstall.bat
```

**Method 2: Control Panel**
- Control Panel → Programs → Uninstall
- Find "QS-DPDP OS"
- Click Uninstall

---

## ✨ Features

✅ **Proper Windows Installer**
- Wizard interface
- Progress indicators
- Error handling
- Component selection

✅ **Complete Installation**
- All files copied
- Shortcuts created
- Configuration set
- Registry entries

✅ **Professional Appearance**
- Modern interface
- Clear instructions
- User-friendly

---

**Status:** ✅ **ENHANCED INSTALLER READY**

Run `create-enhanced-installer.bat` for a proper Windows-style installation!

---

*Created: January 15, 2026*  
*Version: 1.0.0*
