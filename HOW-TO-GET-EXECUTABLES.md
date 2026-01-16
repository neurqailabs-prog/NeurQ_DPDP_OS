# How to Get QS-DPDP OS Executables

## 🎯 Quick Answer

Run this command to generate all executables:

```batch
create-executables.bat
```

## 📋 Step-by-Step Instructions

### Step 1: Build the Project

First, ensure all modules are built:

```batch
build-all.bat
```

This will:
- Build all Java modules (Maven)
- Build Rust components (Cargo)
- Build Python components
- Create JAR files

### Step 2: Create Executables

Run the executable creation script:

```batch
create-executables.bat
```

### Step 3: Find Your Executables

After running the script, executables will be in:

**Location:** `dist\executables\`

**Files created:**
- `qs-dpdp-core.exe` (or `.jar` if GraalVM not available)
- `policy-engine.exe` (or `.jar`)
- `installer-wizard.exe` (or `.jar`)
- `launch.bat` - Quick launcher
- `install.bat` - Installer launcher

### Step 4: Portable Package

A ZIP package is automatically created:

**Location:** `dist\QS-DPDP-OS-Executables.zip`

Extract this ZIP anywhere and run the executables!

## 🔧 Requirements

### For Native Executables (.exe)

1. **GraalVM 23.1.0+**
   - Download: https://www.graalvm.org/downloads/
   - Set environment variable: `GRAALVM_HOME`
   - Example: `set GRAALVM_HOME=C:\graalvm-jdk-21`

2. **Install Native Image:**
   ```batch
   %GRAALVM_HOME%\bin\gu install native-image
   ```

### For JAR Executables

- **Java 21+** (JRE or JDK)
- No additional setup needed

## 🚀 Usage

### Run Application

**Option 1: Native Executable**
```batch
dist\executables\qs-dpdp-core.exe
```

**Option 2: JAR Executable**
```batch
java -jar dist\executables\qs-dpdp-core.jar
```

**Option 3: Launcher Script**
```batch
dist\executables\launch.bat
```

### Run Installer

```batch
dist\executables\installer-wizard.exe
```

or

```batch
dist\executables\install.bat
```

## 📦 What Gets Created

### Native Executables (if GraalVM available)

- **qs-dpdp-core.exe** - Main application (standalone, no JVM needed)
- **policy-engine.exe** - Policy Engine (standalone)
- **installer-wizard.exe** - Installer (standalone)

### JAR Executables (fallback)

- **qs-dpdp-core.jar** - Main application (requires Java)
- **policy-engine.jar** - Policy Engine (requires Java)
- **installer-wizard.jar** - Installer (requires Java)

### Helper Scripts

- **launch.bat** - Auto-detects and launches the best available executable
- **install.bat** - Launches the installer wizard

## 🔍 Troubleshooting

### "GraalVM not found"

**Solution:** The script will automatically create JAR executables instead. These work the same but require Java to be installed.

### "Java not found"

**Solution:** Install Java 21+ from https://adoptium.net/

### "Build failed"

**Solution:** 
1. Run `mvn clean install` first
2. Check that all prerequisites are installed
3. Review error messages in the console

## 📝 Notes

- **Native executables** are faster to start and don't require Java
- **JAR executables** are more portable and work on any system with Java
- Both types provide the same functionality
- The script automatically chooses the best option based on available tools

## 🎁 Distribution

To share the application:

1. Run `create-executables.bat`
2. Share the `dist\QS-DPDP-OS-Executables.zip` file
3. Recipients extract and run `launch.bat`

---

**Need Help?** Check `EXECUTABLES.md` for detailed documentation.
