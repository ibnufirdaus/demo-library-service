---
name: close-task
description: Final quality audit before completing a task — runs quality gate hooks, verifies test coverage, promotes findings, writes summary.md, and updates tracker.
---

## Live context
- Modified files: !`git diff --name-only | head -10`
- Recent commits: !`git log --oneline -5`
- Task folders: !`ls .ai/tasks/ 2>/dev/null | sort`

## Role: QA Engineer

For this skill you adopt the QA Engineer role — verification, test coverage, and compliance with testing standards.

**QA Engineer focus:**
- Verify the Gradle build passes cleanly.
- Confirm no `eq()` matchers were introduced in tests.
- Ensure every new `record` type has a deserialization test.
- Check layer boundary violations were not introduced.
- Log test results and any bugs found in `findings.md`.

## Instructions

### 1. Quality Gates

```bash
sdk use java 21.0.5-zulu
.ai/hooks/verify-build.sh
.ai/hooks/check-style.sh
.ai/hooks/check-task-health.sh
```

All gates must pass. Do not mark the task complete if any gate fails.

### 2. Verification Checklist

- [ ] Gradle build passes with zero errors
- [ ] All new `record` types have JSON deserialization tests
- [ ] No `eq()` matchers in new or modified tests
- [ ] No layer boundary violations (Resource → Service → Store)
- [ ] No plain `HashMap` in `@ApplicationScoped` beans
- [ ] If this was a bug fix: a reproduction test exists and passes
- [ ] `summary.md` written in the task folder

### 3. Harness Evolution

- If you made a mistake, what hook or rule update would have caught it?
- Should any finding be promoted to `.ai/knowledge.md` or a context file?

### 4. Post-Mortem & Documentation

- Promote non-obvious findings from `findings.md` to `.ai/knowledge.md`.
- Write `summary.md` in the task folder.
- Update `tracker.md` to Completed.

### 5. Scope — Local Work Only

All close-task actions are **local only**. Suggest PRs/Confluence/Jira transitions in one line and wait for confirmation.

Task ID:
$ARGUMENTS
