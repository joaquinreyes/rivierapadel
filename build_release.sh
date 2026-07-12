#!/bin/bash

# Safe release build script - blocks if pointing to localhost
API_FILE="lib/managers/api_manager.dart"

if grep -q "localhost\|127\.0\.0\.1" "$API_FILE"; then
    echo ""
    echo "=========================================="
    echo "  BUILD BLOCKED!"
    echo "  kBaseURL is pointing to localhost."
    echo "  Switch to production URL before building."
    echo "=========================================="
    echo ""
    exit 1
fi

echo "Base URL check passed - building release AAB..."
flutter build appbundle --release
