# QS-DPDP OS Executables Guide

This guide explains how to generate and use executables for the QS-DPDP Operating System.

## 🚀 Quick Start - Generate Executables

### Windows

```batch
create-executables.bat
```

This script will:
1. Build all Java modules
2. Create native executables using GraalVM (if available)
3. Create JAR executables as fallback
4. Package everything into a portable ZIP

### Output Location

All executables are created in: `dist\executables\`

## 📦 Generated Files

### Native Executables (GraalVM)

If GraalVM is installed and `GRAALVM_HOME` is set:

- **qs-dpdp-core.exe** - Main application executable
- **policy-engine.exe** - Policy Engine executable
- **installer-wizard.exe** - Installation wizard executable

### JAR Executables (Fallback)

If GraalVM is not available:

- **qs-dpdp-core.jar** - Main application JAR
- **policy-engine.jar** - Policy Engine JAR
- **installer-wizard.jar** - Installation wizard JAR

### Launcher Scripts

- **launch.bat** - Launches the main application
- **install.bat** - Launches the installer wizard

## 🔧 Prerequisites

### For Native Executables

1. **GraalVM 23.1.0+**
   - Download from: https://www.graalvm.org/
   - Set `GRAALVM_HOME` environment variable
   - Example: `set GRAALVM_HOME=C:\graalvm-jdk-21`

2. **Native Image Tool**
   ```batch
   %GRAALVM_HOME%\bin\gu install native-image
   ```

### For JAR Executables

- Java 21+ (JRE or JDK)
- No additional setup required

## 📋 Usage

### Run Main Application

**Native executable:**
```batch
dist\executables\qs-dpdp-core.exe
```

**JAR executable:**
```batch
java -jar dist\executables\qs-dpdp-core.jar
```

**Using launcher:**
```batch
dist\executables\launch.bat
```

### Run Installer

**Native executable:**
```batch
dist\executables\installer-wizard.exe
```

**JAR executable:**
```batch
java -jar dist\executables\installer-wizard.jar
```

**Using launcher:**
```batch
dist\executables\install.bat
```

## 📦 Portable Package

A portable ZIP package is automatically created:

**Location:** `dist\QS-DPDP-OS-Executables.zip`

This package contains:
- All executables
- Launcher scripts
- Required libraries
- Configuration templates

### Extract and Run

1. Extract `QS-DPDP-OS-Executables.zip` to any location
2. Run `launch.bat` to start the application
3. Run `install.bat` to start the installer

## 🔨 Build Process

The `create-executables.bat` script performs:

1. **Maven Build** - Compiles all Java modules
2. **Native Image** - Creates native executables (if GraalVM available)
3. **JAR Fallback** - Creates JAR executables if native image fails
4. **Packaging** - Creates portable ZIP package

## ⚙️ Configuration

### Environment Variables

- `GRAALVM_HOME` - Path to GraalVM installation (for native executables)
- `JAVA_HOME` - Path to Java installation (for JAR executables)

### Build Options

Edit `create-executables.bat` to customize:

- Output directory
- Native image options
- Included resources
- JVM arguments

## 🐛 Troubleshooting

### Native Image Fails

**Problem:** Native image creation fails

**Solution:**
- Check GraalVM installation
- Verify `GRAALVM_HOME` is set correctly
- Install native-image: `gu install native-image`
- Script will automatically fall back to JAR executables

### JAR Executables Don't Run

**Problem:** `java -jar` fails

**Solution:**
- Verify Java 21+ is installed: `java -version`
- Check `JAVA_HOME` environment variable
- Ensure JAR files are not corrupted

### Missing Dependencies

**Problem:** Application fails to start

**Solution:**
- Run `mvn clean install` first
- Check that all modules built successfully
- Verify `lib\` directory contains required JARs

## 📝 Notes

- Native executables are platform-specific (Windows .exe)
- JAR executables are cross-platform
- Native executables start faster but require GraalVM
- JAR executables are more portable but require Java runtime

## 🔄 Updates

To update executables:

1. Make code changes
2. Run `create-executables.bat` again
3. New executables will be created in `dist\executables\`

---

**Last Updated:** 2025-01-15
