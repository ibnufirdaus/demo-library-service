#!/bin/bash
# verify-build.sh: A quality gate to run full build and tests.
# Ensure Java 21 is used (Mandatory: `sdk use java 21`)
# Usage: Run this before submitting a task.

echo "[Quality Gate] Verifying Java environment..."
JAVA_VER=$(java -version 2>&1 | head -n 1)
if [[ $JAVA_VER != *"21"* ]]; then
    echo "[Error] Java version 21 is mandatory. Current: $JAVA_VER"
    echo "Please run: sdk use java 21"
    exit 1
fi

echo "[Quality Gate] Running clean build and tests..."
# Use gradle directly since gradlew is missing
gradle clean build --profile --stacktrace

if [ $? -eq 0 ]; then
    echo "[Success] Build and tests passed!"
    exit 0
else
    echo "[Failure] Build or tests failed. Check the logs."
    exit 1
fi
