# AGENTS.md — library-service

This file is the entry point for all AI agents. It defines the canonical set of resources in `.ai/`, when each must be loaded, and which skills are available.

---

## Architecture Quick Reference

- **Stack**: Java 21, Quarkus 3.x (JAX-RS, CDI, Jackson), Gradle 8
- **Build**: `./gradlew clean build test`
- **Dev mode**: `./gradlew quarkusDev` (live reload on :8080)
- **Layer boundary**: `LibraryResource` → `LibraryService` → `LibraryStore` — **NEVER skip layers**
- **Concurrency**: `@ApplicationScoped` beans must use `ConcurrentHashMap` — never plain `HashMap`
- **Race condition**: Use `ConcurrentHashMap.replace(key, expected, new)` for check-then-act — never `put()` after `get()`
- **JAX-RS path order**: `@Path("/search")` must appear before `@Path("/{id}")` in the same resource

---

## Resource Registry

### Always-Load Files

| File | What it contains |
|---|---|
| `.ai/knowledge.md` | Non-obvious constraints, gotchas, architectural decisions |
| `.ai/techdebt.md` | Open and resolved tech debt |
| `.ai/context/stack.md` | SDK setup, build commands, local execution |

### Conditional Context Files

| File | Load when... |
|---|---|
| `.ai/context/java-standards.md` | Writing or reviewing any Java class — naming, CDI rules, Java 21 idioms, concurrency |
| `.ai/context/testing.md` | Writing or reviewing any test class |
| `.ai/context/architecture.md` | Understanding domain model, data flow, or the full service structure |

### Hooks

| Hook | What it enforces | When to run |
|---|---|---|
| `.ai/hooks/verify-build.sh` | Full Gradle build + tests | End of every stage |
| `.ai/hooks/check-style.sh` | Mockito `eq()` ban, single-impl rule | End of every stage |
| `.ai/hooks/check-task-health.sh` | Task folder integrity: tracker.md, checklist.md, findings.md, summary.md | At task close |

---

## Skills Registry

All skills follow the [agentskills.io](https://agentskills.io) standard. They live in `.ai/skills/` and are wired as slash commands via `bash .ai/setup.sh`.

### Workflow Skills

| Skill | Role embedded | Invoke | When |
|---|---|---|---|
| `new-task` | — | `/new-task BOS-XXXX` | Start of every ticket |
| `pre-flight` | — | `/pre-flight BOS-XXXX` | After new-task, before planning |
| `build-plan` | Architect | `/build-plan BOS-XXXX` | After pre-flight — produces `task-plan.md` and `checklist.md` |
| `execute` | Developer | `/execute BOS-XXXX "Stage N"` | For each stage in the approved plan |
| `close-task` | QA Engineer | `/close-task BOS-XXXX` | Final audit — runs hooks, promotes findings, writes summary.md |

**Standard workflow**: `/new-task` → `/pre-flight` → `/build-plan` → `/execute` (per stage) → `/close-task`

### Utility Skills

| Skill | Invoke | When |
|---|---|---|
| `critique` | `/critique BOS-XXXX` | After any execute stage |

---

## Task Folder Structure

Every non-trivial task gets a folder at `.ai/tasks/[TASK-ID]/`:

| File | Role |
|---|---|
| `context.md` | Requirements, background, reference links (static after kickoff) |
| `task-plan.md` | Phases, decisions, files to touch |
| `checklist.md` | Executable steps with checkboxes, grouped by stage |
| `findings.md` | Append-only discoveries and gotchas |
| `tracker.md` | Status, owner, Jira link, current focus |
| `summary.md` | Written at task close — what was built, key decisions |

Task not closed until: `summary.md` written + findings promoted to `knowledge.md`.
Completed task folders are archived to `.ai/tasks/archive/[TASK-ID]/` after `close-task`.

---

## Harness Engineering Principles

1. **Harness-First**: When an error is found, update a hook or context file to prevent it automatically.
2. **Reproduction-First**: For bug fixes, create a failing test before writing the fix.
3. **Knowledge Lifecycle**: Promote non-obvious gotchas from `findings.md` to `.ai/knowledge.md` at `close-task`.
