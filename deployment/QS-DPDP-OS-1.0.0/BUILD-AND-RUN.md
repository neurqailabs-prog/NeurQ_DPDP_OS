# 🚀 Build and Run QS-DPDP OS

## Quick Start

### Step 1: Verify Prerequisites

Check if you have:
- ✅ Java 21+ (`java -version`)
- ✅ Maven 3.8+ (`mvn -version`)
- ✅ Rust 1.75+ (`rustc --version`) - Optional
- ✅ Python 3.11+ (`python --version`) - Optional

### Step 2: Verify Project

```batch
verify-project.bat
```

This will check that all files are present.

### Step 3: Build Project

```batch
build-all.bat
```

This will:
1. Build all Java modules (Maven)
2. Build Rust components (Cargo)
3. Build Python components
4. Create JAR files

### Step 4: Create Executables

```batch
create-executables.bat
```

This will:
1. Create native executables (if GraalVM available)
2. Create JAR executables (fallback)
3. Package everything into ZIP

### Step 5: Run Application

```batch
dist\executables\launch.bat
```

Or directly:
```batch
dist\executables\qs-dpdp-core.exe
```

---

## Installation

### Run Installer

```batch
dist\executables\install.bat
```

Or:
```batch
dist\executables\installer-wizard.exe
```

---

## Troubleshooting

### Maven Not Found
- Install Maven from: https://maven.apache.org/download.cgi
- Add to PATH

### Java Not Found
- Install Java 21+ from: https://adoptium.net/
- Set JAVA_HOME

### Build Fails
- Check error messages
- Ensure all prerequisites installed
- Run `verify-project.bat` to check files

### Executables Not Created
- Check `dist/executables/` folder
- Look for `.jar` files if `.exe` not available
- Both work the same way

---

## Output Locations

- **JAR files:** `*/target/*.jar`
- **Executables:** `dist/executables/`
- **Package:** `dist/QS-DPDP-OS-Executables.zip`

---

## Success Indicators

✅ Build completes without errors  
✅ JAR files created in `target/` folders  
✅ Executables in `dist/executables/`  
✅ ZIP package created  
✅ Application launches successfully  

---

**Ready to build!** 🎉
