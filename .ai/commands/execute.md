---
name: execute
description: Implement a specific stage of an approved task plan. Checks off items in checklist.md, logs findings, runs quality gates, and updates tracker. Pass task ID and stage name (e.g. /execute BOS-4300 "Stage 1 — Core Step").
---

## Live context
- Modified Java files: !`git diff --name-only | grep "\.java$" | head -10`
- Recent commits: !`git log --oneline -3`

## Role: Developer

For this skill you adopt the Developer role — clean Java 21 / Quarkus / JAX-RS / CDI implementation following project conventions.

**Developer focus:**
- Use Java 21 idioms: `record`, `sealed interface`, `Optional` chains, text blocks.
- Respect the three-layer boundary: Resource → Service → Store.
- `@ApplicationScoped` beans must use `ConcurrentHashMap` — never plain `HashMap`.
- Update `checklist.md` as you go; log unexpected discoveries in `findings.md`.

## Instructions

### Before implementing — load context for what you're touching

| If you're touching... | Read this first |
|---|---|
| Any Java class | `.ai/context/java-standards.md` |
| Any test class | `.ai/context/testing.md` |
| Domain model or architecture questions | `.ai/context/architecture.md` |

### Your job

1. Load all task folder files from `.ai/tasks/[TASK-ID]/`.
2. Identify which stage we are implementing.
3. Read the relevant checklist items for that stage.
4. Implement the changes.
5. Check off each item in `checklist.md` as completed.
6. If a new concern emerges mid-stage, add a new Stage to `checklist.md`.
7. Log anything unexpected in `findings.md`.

### Hard rules

- **NEVER** create an interface with only one implementation
- **NEVER** skip the Resource → Service → Store layer boundary
- **NEVER** use plain `HashMap` in `@ApplicationScoped` beans — use `ConcurrentHashMap`
- **NEVER** use `put()` after `get()` on shared state — use `ConcurrentHashMap.replace()`
- **NEVER** use `eq()` matchers in Mockito — use raw values
- **NEVER** add setters to `record` types — use `with*()` helper methods
- **ALWAYS** place `@Path("/search")` before `@Path("/{id}")` in the same resource class

### Quality gates — run at the end of each stage

```bash
sdk use java 21.0.5-zulu && .ai/hooks/verify-build.sh
.ai/hooks/check-style.sh
```

Task ID and stage to execute:
$ARGUMENTS
