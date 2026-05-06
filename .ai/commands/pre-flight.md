---
name: pre-flight
description: Deep codebase analysis before planning or implementation. Run after new-task and before build-plan.
---

## Live context
- Mode: [RESEARCH] / [PLAN] / [CODE] / [VERIFY] / [HARNESS]
- Modified files: !`git diff --name-only | head -10`
- Recent commits: !`git log --oneline -3`
- Task folders: !`ls .ai/tasks/ 2>/dev/null | sort`

## Instructions

Before planning or modifying code, you MUST perform a pre-flight analysis.

### 1. Mode Selection (Mandatory)
- Explicitly state which mode you are operating in (e.g., `[RESEARCH]`).
- Ensure all tool calls align with the constraints of that mode (e.g., no edits in `[RESEARCH]`).

### 2. Pattern Matching
- Find and read existing code of the same type (e.g., if adding a new JAX-RS endpoint, read `LibraryResource.java`).
- Document the established style, naming conventions, and architectural patterns in `findings.md`.
- Ensure the proposed work matches these patterns exactly.

### 3. Codebase Analysis
- Trace the actual method call chain affected by this task.
- Identify all classes that will need to change and what specific change each requires.
- Identify potential side effects on downstream modules.

### 4. Knowledge Cross-check
- Read relevant `AGENTS.md` sections and `.ai/knowledge.md`.
- Identify existing patterns and constraints that MUST be followed.
- Check `.ai/techdebt.md` for related open issues.

### 5. Reproduction-First (Mandatory for Bugs)
- Create an automated reproduction test or script that fails *before* implementing the fix.
- Document the reproduction step in `findings.md` under `## Reproduction`.

### 6. Output
Include a `## Pre-flight Analysis` section in your task context or first status update. Update `findings.md` with codebase observations and pattern matching results.

Task ID (optional):
$ARGUMENTS
