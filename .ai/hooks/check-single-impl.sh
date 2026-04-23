#!/bin/bash
# check-single-impl.sh: A quality gate to enforce "no interface for single implementation".
# Searches for files ending in ServiceImpl.java and counts their corresponding interfaces.

echo "[Harness] Checking for single-implementation interfaces..."

# We search for classes ending in *ServiceImpl.java and then check if the interface is only implemented once.
# This is a heuristic approach.
IMPLS=$(find src/main/java -name "*ServiceImpl.java" 2>/dev/null)

if [ -z "$IMPLS" ]; then
    echo "[Harness] No *ServiceImpl.java files found."
    exit 0
fi

VIOLATIONS=0
for IMPL in $IMPLS; do
    # Get the interface name from the implementation file name (e.g., MyServiceImpl -> MyService)
    INTERFACE=$(basename $IMPL | sed "s/Impl.java//")
    
    # Count how many implementations exist for this interface
    # (Searching for the interface name in files)
    COUNT=$(grep -r "implements $INTERFACE" src/main/java 2>/dev/null | wc -l)
    
    if [ "$COUNT" -eq 1 ]; then
        echo "[Warning] Interface "$INTERFACE" has only one implementation ($IMPL)."
        echo "          Consider merging the interface into a single class."
        VIOLATIONS=$((VIOLATIONS + 1))
    fi
done

if [ "$VIOLATIONS" -gt 0 ]; then
    echo "[Harness] Found $VIOLATIONS potential single-implementation interface violation(s)."
    # We exit 0 because it's a "Warning/Guideline" rather than a hard build error.
    # The human should review these.
    exit 0
fi

echo "[Harness] No single-implementation interface violations found."
