#!/bin/bash
set -euo pipefail

# Script: checks that required tools are installed on the system

REQUIRED_TOOLS=("bash" "grep" "awk" "sed" "sort")
MISSING=0

echo "Checking required tools..."

for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "  [OK] $tool found"
    else
        echo "  [MISSING] $tool not found"
        MISSING=1
    fi
done

if [[ "$MISSING" -eq 1 ]]; then
    echo "Some required tools are missing. Please install them."
    exit 1
else
    echo "All required tools are installed."
    exit 0
fi
