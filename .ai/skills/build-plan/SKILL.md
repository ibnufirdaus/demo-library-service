---
name: build-plan
description: Produce the phased implementation plan and detailed checklist after pre-flight is complete. Writes task-plan.md and checklist.md, then asks for confirmation before any implementation begins. Pass the task ID as argument (e.g. /build-plan BOS-4300).
---

## Live context
- Task folders: !`ls .ai/tasks/ 2>/dev/null | sort`
- Recent commits: !`git log --oneline -3`

## Role: Architect

For this skill you adopt the Architect role — high-level analysis, system design, and planning.

**Architect focus:**
- Analyse requirements against the three-layer architecture: Resource → Service → Store.
- Identify blast radius: which Resources, Services, and Stores are affected.
- Ensure concurrency constraints are preserved (`ConcurrentHashMap`, `replace()` pattern).
- New `record` types require a deserialization test — flag this in the plan.
- Record key design decisions and trade-offs in `findings.md`.

## Instructions

We are building the implementation plan for a task. The pre-flight check has been completed.

### Architectural constraints

- **No interface for single implementation** — use a concrete class.
- **Three-layer boundary**: Resource → Service → Store. Never skip layers.
- **ConcurrentHashMap** in all `@ApplicationScoped` beans — no plain `HashMap`.
- **New `record` types** require a JSON deserialization test (mandatory QA Step item).
- **JAX-RS path ordering**: specific paths before parameterised ones in the same class.

### Your job

1. Load all task folder files from `.ai/tasks/[TASK-ID]/`.
2. Read `findings.md` — it contains the codebase analysis from pre-flight.
3. Design a staged implementation plan.
4. Write the plan into `task-plan.md` and the detailed steps into `checklist.md`.
5. Ask me to confirm the plan before implementation begins.

### Checklist — final stage always includes

```
## Stage N: Verification (QA Step)
- [ ] Run `sdk use java 21.0.5-zulu && .ai/hooks/verify-build.sh`
- [ ] Run `.ai/hooks/check-style.sh`
- [ ] Update `tracker.md` to Completed
```

Do not start implementation until I confirm the plan.

Task ID:
$ARGUMENTS
