# 🔍 Icon Troubleshooting Guide

## If You Can't See the Custom Icon

### Step 1: Verify Icon File Exists

Run this command:
```batch
dir QS-DPDP-OS-Icon.ico
```

If it shows the file, the icon exists. If not, run:
```batch
fix-icon-now.bat
```

### Step 2: Manually Apply Icon to Shortcut

1. **Right-click** the "QS-DPDP OS" shortcut on your desktop
2. Select **"Properties"**
3. Click the **"Change Icon"** button
4. Click **"Browse"**
5. Navigate to: `D:\NeurQ_DPDP_Cursor_15012026`
6. Select: `QS-DPDP-OS-Icon.ico`
7. Click **OK** → **OK**

### Step 3: Refresh Desktop

- Press **F5** on your desktop
- Or right-click desktop → **Refresh**

### Step 4: Check Desktop View Settings

1. Right-click desktop → **View**
2. Make sure **"Show desktop icons"** is checked
3. Try different icon sizes (Large, Medium, Small)

### Step 5: Sort Desktop Icons

1. Right-click desktop → **Sort by** → **Name**
2. This will alphabetically sort icons
3. Look for "QS-DPDP OS"

### Step 6: Check Icon File Location

The icon file should be at:
```
D:\NeurQ_DPDP_Cursor_15012026\QS-DPDP-OS-Icon.ico
```

If it's not there, run:
```batch
create-icon-simple.bat
```

### Step 7: Verify Shortcut Properties

1. Right-click "QS-DPDP OS" shortcut
2. Select **Properties**
3. Check **"Target"** field - should point to launch.bat
4. Check if icon path is shown in properties

### Alternative: Create New Shortcut

If the icon still doesn't work:

1. Navigate to: `C:\Users\HP\AppData\Local\NeurQ\QS-DPDP-OS`
2. Right-click `launch.bat`
3. Select **Send to** → **Desktop (create shortcut)**
4. Right-click the new shortcut → **Properties**
5. Click **Change Icon**
6. Browse to: `D:\NeurQ_DPDP_Cursor_15012026\QS-DPDP-OS-Icon.ico`
7. Click **OK**

### Quick Fix Script

Run this to automatically fix everything:
```batch
fix-icon-now.bat
```

This will:
- Create icon if missing
- Update shortcut
- Refresh desktop
- Open desktop folder

---

## Icon Design Verification

The icon should show:
- ✅ Multi-color "QS" text (Blue Q, multi-color S)
- ✅ "DPDP OS" text at bottom
- ✅ Purple/blue quantum-safe background
- ✅ AI badge in corner

If you can see the icon file when opened, but not on desktop:
- The shortcut needs to be updated
- Use manual method above (Step 2)

---

## Still Not Working?

1. **Check if icon file opens:**
   ```batch
   show-icon-visually.bat
   ```

2. **Recreate everything:**
   ```batch
   FINAL-ICON-SETUP.bat
   ```

3. **Use HTML generator:**
   - Run: `create-icon.bat`
   - Download icon from browser
   - Convert PNG to ICO online
   - Apply manually (Step 2)

---

*Last Updated: January 15, 2026*
