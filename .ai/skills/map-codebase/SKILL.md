---
name: map-codebase
description: LLM-centric symbol mapping — maintains .ai/symbols.txt for instant navigation.
---

## Instructions

Use this skill to navigate the codebase efficiently and keep the symbol map up to date.

### 1. Symbol Search
- Instead of global `grep` calls, read `.ai/symbols.txt` first to find where a class or method is defined.
- This provides instant mapping of symbols to files.

### 2. Automated Refresh
- Run `.ai/scripts/refresh-symbols.sh` after any `[CODE]` phase that adds or renames classes/methods.
- This ensures the `[RESEARCH]` mode always has accurate "Ground Truth" about the codebase structure.

### 3. Usage in Research
- In `[RESEARCH]` mode, use the map to quickly identify the "Blast Radius" of a change.
- Trace dependencies by looking up methods in the map and then reading the corresponding files.
