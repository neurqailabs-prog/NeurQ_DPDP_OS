#!/bin/bash

# Build script for QS-DPDP OS

set -e

echo "Building QS-DPDP Operating System..."

# Build Java modules
echo "Building Java modules..."
mvn clean install -DskipTests

# Build Rust components
echo "Building Rust components..."

# QS-SIEM Rust
if [ -d "qs-siem/src/main/rust" ]; then
    echo "Building QS-SIEM Rust..."
    cd qs-siem/src/main/rust
    cargo build --release
    cd ../../../../..
fi

# QS-DLP Rust
if [ -d "qs-dlp/src/main/rust" ]; then
    echo "Building QS-DLP Rust..."
    cd qs-dlp/src/main/rust
    cargo build --release
    cd ../../../../..
fi

# Build Python components
echo "Building Python components..."
# Python components are interpreted, no compilation needed

echo "Build completed successfully!"
