#!/bin/bash
echo "[Harness] Checking CDI boundaries..."
# We search in the domain model specifically for record types
# which are supposed to be POJOs, not CDI beans.
VIOLATIONS=$(grep -r "@Inject" src/main/java/com/example/library/domain/model/ | grep ".java")
if [ ! -z "$VIOLATIONS" ]; then
    echo "[Error] CDI Boundary Violation: @Inject found in domain models (POJOs)."
    echo "$VIOLATIONS"
    exit 1
fi
echo "[Harness] CDI boundaries look good."
