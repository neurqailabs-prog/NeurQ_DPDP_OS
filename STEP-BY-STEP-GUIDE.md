# Step-by-Step Testing Guide

## If Shortcuts Still Don't Work - Follow This Guide

This guide will help you test each product one by one to identify exactly where the issue is.

---

## Step 1: Test Basic Shortcut Functionality

### Test 1.1: Check if Windows Shortcuts Work at All

1. **Right-click on your desktop** → **New** → **Shortcut**
2. In the location box, type: `notepad.exe`
3. Click **Next**
4. Name it: `Test Notepad`
5. Click **Finish**
6. **Double-click "Test Notepad"**
   - ✅ **If Notepad opens**: Windows shortcuts work! Continue to Step 2.
   - ❌ **If nothing happens**: Windows shortcut execution is blocked. Check antivirus/security settings.

---

## Step 2: Test QS-DPDP Core (First Product)

### Step 2.1: Check if Launcher File Exists

1. Press **Windows Key + R**
2. Type: `%LOCALAPPDATA%\NeurQ\QS-DPDP-Core`
3. Press **Enter**
4. Look for `launch.bat` file
   - ✅ **If found**: Continue to Step 2.2
   - ❌ **If not found**: The installation didn't complete. Run the installer again.

### Step 2.2: Test Launcher Directly (Without Shortcut)

1. In the folder from Step 2.1, **double-click `launch.bat`**
   - ✅ **If console window opens**: Launcher works! The issue is with shortcuts.
   - ❌ **If nothing happens**: Launcher has an error. Check the launcher file.

### Step 2.3: Create Shortcut Manually

1. In the folder from Step 2.1, **right-click `launch.bat`**
2. Select **Send to** → **Desktop (create shortcut)**
3. Go to desktop, find the new shortcut
4. **Right-click the shortcut** → **Properties**
5. Check **Target** field - should show: `C:\Users\HP\AppData\Local\NeurQ\QS-DPDP-Core\launch.bat`
6. Click **OK**
7. **Double-click the shortcut**
   - ✅ **If console window opens**: Manual shortcut works! Continue to Step 3.
   - ❌ **If nothing happens**: Windows is blocking batch file execution.

---

## Step 3: Test QS-SIEM (Second Product)

Repeat Steps 2.1, 2.2, and 2.3 for QS-SIEM:
- Folder: `%LOCALAPPDATA%\NeurQ\QS-SIEM`
- Launcher: `launch.bat`

---

## Step 4: Test QS-DLP (Third Product)

Repeat Steps 2.1, 2.2, and 2.3 for QS-DLP:
- Folder: `%LOCALAPPDATA%\NeurQ\QS-DLP`
- Launcher: `launch.bat`

---

## Step 5: Test QS-PII Scanner (Fourth Product)

Repeat Steps 2.1, 2.2, and 2.3 for QS-PII Scanner:
- Folder: `%LOCALAPPDATA%\NeurQ\QS-PII-Scanner`
- Launcher: `launch.bat`

---

## Step 6: Test Policy Engine (Fifth Product)

Repeat Steps 2.1, 2.2, and 2.3 for Policy Engine:
- Folder: `%LOCALAPPDATA%\NeurQ\Policy-Engine`
- Launcher: `launch.bat`

---

## Step 7: Test QS-DPDP OS (Complete Suite)

Repeat Steps 2.1, 2.2, and 2.3 for QS-DPDP OS:
- Folder: `%LOCALAPPDATA%\NeurQ\QS-DPDP-OS`
- Launcher: `launch.bat`

---

## Troubleshooting Common Issues

### Issue 1: "Nothing Happens" When Clicking Shortcut

**Possible Causes:**
1. Windows security blocking execution
2. Antivirus blocking batch files
3. File association issue

**Solutions:**
- **Solution A**: Right-click shortcut → **Run as Administrator**
- **Solution B**: Check Windows Defender/Antivirus exclusions
- **Solution C**: Open Command Prompt, navigate to folder, run `launch.bat` manually

### Issue 2: "Windows cannot find the file"

**Possible Causes:**
1. File path is incorrect
2. File was moved or deleted

**Solutions:**
- Check that `launch.bat` exists in the installation folder
- Verify the shortcut's Target path is correct
- Recreate the shortcut manually

### Issue 3: Console Window Opens But Closes Immediately

**Possible Causes:**
1. Error in launcher script
2. Missing dependencies

**Solutions:**
- Add `pause` at the end of launcher to see error messages
- Check if Java is installed: Open Command Prompt, type `java -version`

### Issue 4: "Access Denied" or "Permission Denied"

**Possible Causes:**
1. Insufficient permissions
2. Files in protected location

**Solutions:**
- Run as Administrator
- Move installation to user folder (already done: `%LOCALAPPDATA%`)

---

## What to Report Back

After testing, please tell me:

1. **Which products worked?** (List them)
2. **Which products didn't work?** (List them)
3. **What happened when you clicked?** (Nothing, error message, etc.)
4. **Did manual shortcuts work?** (Yes/No)
5. **Did direct launcher execution work?** (Yes/No)

This will help me identify the exact issue and fix it.

---

## Quick Test Script

I've also created individual test scripts for each product. Run them one by one:

1. `test-qs-dpdp-core.bat`
2. `test-qs-siem.bat`
3. `test-qs-dlp.bat`
4. `test-qs-pii-scanner.bat`
5. `test-policy-engine.bat`
6. `test-qs-dpdp-os.bat`

Each script will:
- Check if launcher exists
- Test launcher directly
- Create a manual shortcut
- Report results

---

*Guide created: January 16, 2026*  
*Use this if automated fixes don't work*
