---
name: critique
description: Review a task or stage for code quality, styling, naming, consistency, scope fit, and plan alignment. Updates findings.md with prioritized critique notes without implementing fixes.
---

## Live context
- Modified Java files: !`git diff --name-only | grep "\.java$" | head -15`
- Recent commits: !`git log --oneline -5`
- Task folders: !`ls .ai/tasks/ 2>/dev/null | sort`

## Instructions

We are doing a critique pass on an in-flight or recently completed task.

Your job:
1. Load `.ai/tasks/[TASK-ID]/`.
2. If a stage is specified, focus on that stage first, then note cross-stage spillover.
3. Read `context.md`, `task-plan.md`, `checklist.md`, `tracker.md`, and `findings.md`.
4. Review the current code and config against:
   - `.ai/knowledge.md`
   - `.ai/context/*.md`
   - repo naming and packaging rules
   - user clarifications already recorded in the task
5. Update `findings.md` with a critique section that covers:
   - prioritized findings with file references
   - stage completeness status: `complete`, `partial`, or `drifting`
   - inconsistencies between code, docs, checklist state, and actual implementation
   - missing tests, dead code, unused config, or scope drift
   - style, naming, and package-structure issues
6. Do not implement fixes unless explicitly requested after the critique.

What to critique:
- Goal alignment with the approved task scope
- Naming quality and package clarity
- Consistency between event layer, service layer, repository layer, and task docs
- Unused abstractions, config, or dependencies
- Build and verification alignment with the repo standard
- Schema and persistence alignment with repo rules
- Test strategy alignment with the repo requirement for both unit and integration coverage
- Stale checklist items, stale findings, or stale task-tracker state
- Small polish issues that will create confusion later if left unaddressed

Output requirements:
- Findings come first, ordered by severity
- Every finding should name the affected file or package
- Explicitly say whether the reviewed stage is complete, partial, or drifting
- If there are no findings, say so and mention residual risks or remaining verification gaps

Task ID and optional stage:
$ARGUMENTS

## Recommended Usage

- Run after each `execute` stage to catch drift before it compounds across stages.
- Run before `close-task` as a final consistency check — especially for tasks spanning more than two stages.
- Run when scope creep is suspected: extra abstractions appeared, checklist items were skipped, or implementation diverged from `task-plan.md`.
- Pass a stage name to focus the review: `/critique BOS-4300 "Stage 2"`. Omit the stage to review the whole task.
- Does not implement fixes — use `execute` to act on findings once you've reviewed and prioritized them.
