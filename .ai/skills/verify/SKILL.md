---
name: verify
description: Formal verification phase — runs hooks, captures evidence, and updates the harness.
---

## Instructions

Run this skill after the `[CODE]` phase to ensure correctness and harness alignment.

### 1. Automated Verification
- Run all relevant hooks in `.ai/hooks/`.
- Run unit tests using `./gradlew test`.
- Capture logs or test output as evidence of success.

### 2. Harness Feedback Loop
- If verification fails:
    - Analyze why the `[CODE]` phase failed.
    - Analyze why the `[PLAN]` or `[RESEARCH]` phase didn't catch the issue earlier.
    - **Switch to `[HARNESS]` mode**: Update `.ai/knowledge.md` or create a new hook to catch this class of error in the future.
- If verification succeeds:
    - Document the evidence in `summary.md`.

### 3. Evidence Collection
- Attach relevant snippets of logs or test results to the task's `summary.md`.
- Ensure all checklist items in `checklist.md` are marked as complete.
