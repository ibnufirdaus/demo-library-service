#!/bin/bash
# check-style.sh: A quality gate to check code compliance.
# Usage: Run this to verify code style and standards.

echo "[Quality Gate] Checking for non-compliant patterns..."

# Check for Mockito eq() usage in tests
echo "1. Checking for Mockito 'eq()' usage in src/test..."
grep -r "eq(" src/test/java | grep -v "Assertions.assertEquals"

if [ $? -eq 0 ]; then
    echo "[Warning] Found usage of 'eq()' in Mockito. Prefer raw values."
else
    echo "[Success] No 'eq()' Mockito usage found."
fi

# Check for interface and implementation separation (single-impl rule)
# This is hard to automate perfectly, but we can look for *ServiceImpl.java files
echo "2. Checking for potential single-implementation interfaces (*ServiceImpl.java)..."
find src/main/java -name "*ServiceImpl.java"

if [ $? -eq 0 ]; then
    echo "[Guideline Reminder] Ensure these 'ServiceImpl' classes have more than one implementation, otherwise merge into a single class without an interface."
else
    echo "[Success] No suspicious 'ServiceImpl' files found."
fi

echo "[Quality Gate] Style check finished."
