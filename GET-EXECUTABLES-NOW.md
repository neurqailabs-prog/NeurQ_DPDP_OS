# 🚀 Get QS-DPDP OS Executables - Quick Guide

## ✅ Ready to Generate Executables

All the code and build scripts are ready! Here's how to get your executables:

## 📝 Simple 3-Step Process

### Step 1: Open Command Prompt
Open Windows Command Prompt (cmd.exe) in the project directory:
```
d:\NeurQ_DPDP_Cursor_15012026
```

### Step 2: Run the Build Script
```batch
build-all.bat
```
This builds all modules (Java, Rust, Python).

### Step 3: Create Executables
```batch
create-executables.bat
```
This creates the executables!

## 📦 What You'll Get

After running `create-executables.bat`, you'll find:

### In `dist\executables\` folder:

1. **qs-dpdp-core.exe** (or .jar)
   - Main QS-DPDP OS application
   - Double-click to run!

2. **installer-wizard.exe** (or .jar)
   - Installation wizard
   - Run this to install the system

3. **launch.bat**
   - Quick launcher script
   - Double-click to start the app

4. **install.bat**
   - Installer launcher
   - Double-click to start installer

### Portable Package:

**`dist\QS-DPDP-OS-Executables.zip`**
- Complete portable package
- Extract anywhere and run!
- Share with others easily

## 🎯 Quick Start Commands

```batch
REM Build everything
build-all.bat

REM Create executables
create-executables.bat

REM Run the application
dist\executables\launch.bat
```

## ⚙️ Requirements

### Minimum (JAR Executables):
- ✅ Java 21+ installed
- ✅ That's it!

### Recommended (Native .exe):
- ✅ GraalVM 23.1.0+
- ✅ Set `GRAALVM_HOME` environment variable
- ✅ Faster startup, no Java needed

## 🔍 Where Are My Executables?

After running `create-executables.bat`:

**Location:** `dist\executables\`

**Files:**
- `qs-dpdp-core.exe` or `qs-dpdp-core.jar`
- `installer-wizard.exe` or `installer-wizard.jar`
- `launch.bat`
- `install.bat`

**Package:**
- `dist\QS-DPDP-OS-Executables.zip`

## 🚀 Run the Application

### Option 1: Double-Click
Navigate to `dist\executables\` and double-click:
- `launch.bat` - to run the app
- `install.bat` - to run the installer

### Option 2: Command Line
```batch
cd dist\executables
launch.bat
```

### Option 3: Direct Execution
```batch
dist\executables\qs-dpdp-core.exe
```

## 📋 Complete File Structure

```
NeurQ_DPDP_Cursor_15012026/
├── build-all.bat              ← Run this first
├── create-executables.bat     ← Run this to create .exe files
├── run.bat                    ← Quick launcher
│
├── dist/                      ← Output directory
│   ├── executables/           ← Your executables are here!
│   │   ├── qs-dpdp-core.exe
│   │   ├── installer-wizard.exe
│   │   ├── launch.bat
│   │   └── install.bat
│   └── QS-DPDP-OS-Executables.zip
│
├── qs-dpdp-core/              ← Main application code
├── qs-siem/                   ← SIEM module
├── qs-dlp/                    ← DLP module
├── qs-pii-scanner/            ← PII Scanner
├── policy-engine/              ← Policy Engine
├── licensing-engine/          ← Licensing system
└── installers/                ← Installer configurations
```

## 🎁 Share the Application

To share with others:

1. Run `create-executables.bat`
2. Share `dist\QS-DPDP-OS-Executables.zip`
3. Recipients extract and run `launch.bat`

## ❓ Troubleshooting

### "Maven not found"
- Install Maven: https://maven.apache.org/download.cgi
- Add to PATH

### "Java not found"
- Install Java 21+: https://adoptium.net/
- Set JAVA_HOME

### "GraalVM not found"
- That's OK! Script will create JAR files instead
- JAR files work the same, just need Java

### Executables not created?
- Check `dist\executables\` folder
- Look for `.jar` files if `.exe` not available
- Both work the same!

## 📚 More Information

- **Detailed Guide:** See `EXECUTABLES.md`
- **Build Process:** See `HOW-TO-GET-EXECUTABLES.md`
- **Main README:** See `README.md`

## ✨ You're Ready!

Everything is set up. Just run:

```batch
create-executables.bat
```

And your executables will be ready in `dist\executables\`!

---

**Need help?** Check the documentation files or review the build scripts.
