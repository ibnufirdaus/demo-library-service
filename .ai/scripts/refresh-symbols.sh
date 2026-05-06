#!/bin/bash
# .ai/scripts/refresh-symbols.sh
# Generates a lightweight .ai/symbols.txt mapping classes and methods to files.

OUTPUT_FILE=".ai/symbols.txt"
echo "# library-service Symbol Map (Generated on $(date))" > "$OUTPUT_FILE"
echo "# Format: SYMBOL | TYPE | FILE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Find Classes (Java)
grep -rE "public (class|record|interface|enum) [A-Za-z0-9_]+" src/main/java \
  | sed -E 's/src\/main\/java\/(.*\.java):.*public (class|record|interface|enum) ([A-Za-z0-9_]+).*/\3 | \2 | \1/' \
  >> "$OUTPUT_FILE"

# Find Methods (heuristic: public/protected/private + return type + method name + opening paren)
# This is a simple heuristic and might need refinement.
grep -rE "(public|protected|private) [A-Za-z0-9_<>]+ [a-z][A-Za-z0-9_]+\(" src/main/java \
  | grep -vE "(class|record|interface|enum)" \
  | sed -E 's/src\/main\/java\/(.*\.java):.*(public|protected|private) [A-Za-z0-9_<>]+ ([a-z][A-Za-z0-9_]+)\(.*/\3 | method | \1/' \
  >> "$OUTPUT_FILE"

echo "Symbols refreshed in $OUTPUT_FILE"
