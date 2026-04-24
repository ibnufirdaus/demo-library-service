---
name: pre-flight
description: Deep codebase analysis before planning or implementation — traces method call chains, identifies blast radius, cross-checks knowledge files, and runs repo health checks. Run after new-task and before build-plan on any ticket.
---

## Live context
- Modified files: !`git diff --name-only | head -10`
- Recent commits: !`git log --oneline -3`
- Task folders: !`ls .ai/tasks/ 2>/dev/null | sort`

## Instructions

Before planning or modifying code, you MUST perform a pre-flight analysis to ensure context alignment and risk identification.

### 1. Codebase Analysis
- Trace the actual method call chain affected by this task.
- Identify all classes that will need to change and what specific change each requires.
- Identify potential side effects on downstream modules.

### 2. Knowledge Cross-check
- Read relevant `AGENTS.md` sections and `.ai/knowledge.md`.
- Identify existing patterns and constraints that MUST be followed.
- Check `.ai/techdebt.md` for related open issues.

### 3. Reproduction-First (Mandatory for Bugs)
- If the task is a bug fix or investigation, you MUST create an automated reproduction test or script (`repro-bug.sh` or a unit test) that fails *before* implementing the fix.
- Document the reproduction step in `findings.md` under a new `## Reproduction` section.
- Planning for a bug fix without a failing repro is not allowed.

### 4. Risk & Scope
- Identify the "Blast Radius" — what could break?
- Verify if the task can be completed in small, incremental steps.
- Are there any hidden assumptions that need verification first?

### 5. Output
Include a `## Pre-flight Analysis` section in your task context or first status update, detailing the findings from above. Update `findings.md` with codebase observations.

Task ID (optional):
$ARGUMENTS
