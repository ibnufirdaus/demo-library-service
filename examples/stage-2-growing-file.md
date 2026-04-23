# Stage 2 — The Guidelines File After It Grows

After a few months of active development, the single CLAUDE.md has been updated
with testing rules, task workflow instructions, role-specific behavior, new gotchas,
coding conventions, and architectural decisions.

It now looks like this — and this is the problem.

---

```markdown
# library-service

## Build & Run
./gradlew clean build
./gradlew quarkusDev

## Stack
Java 21 · Quarkus 3 · JAX-RS · CDI · Jackson · Gradle 8

## Architecture
LibraryResource → LibraryService → LibraryStore (ConcurrentHashMap)

## Coding Standards
- Java 21: records, Optional chains, text blocks, switch expressions
- NEVER use plain HashMap — always ConcurrentHashMap in @ApplicationScoped beans
- NEVER skip layers: Resource → Service → Store
- NEVER add setters to records — use with*() helpers
- Use JBoss Logging, not SLF4J or java.util.logging
- Log WARN for skipped/no-op operations, ERROR only for unexpected exceptions
- Use @ExtendWith(MockitoExtension.class) not @RunWith
- Use argThat() not eq() in Mockito verify/when calls
- Add @JsonIgnoreProperties(ignoreUnknown = true) to all records used in deserialization
- Use text blocks for multi-line JSON in tests

## Testing Standards
- Given-When-Then structure with comments
- One behavior per test method
- Descriptive names: shouldReturnEmpty_whenBookNotFound()
- New records MUST have deserialization test: happy path + unknown fields ignored
- New service methods: test both success and empty/error path
- New store methods: test save + find + collection

## Known Gotchas
- ConcurrentHashMap.replace() for availability flip (race condition)
- JAX-RS /search must appear before /{id}
- Loan.withReturn() takes LocalDate — use LocalDate.now() at the time of return call, not at creation
- LibraryStore.allLoans() returns a snapshot view — modifications to the collection during iteration are safe
- UUID.randomUUID() IDs are opaque — never parse or sort them

## Task Workflow
When starting a new task:
1. Create .ai/tasks/[TASK-ID]/ folder
2. Write context.md with requirements and relevant files
3. Write checklist.md with Stage 0 already checked off
4. Write findings.md with pre-flight analysis
5. Write tracker.md with Current Focus and Active Role
6. Leave task-plan.md blank for /build-plan

When implementing:
- Load tracker.md, checklist.md, findings.md
- Check off items as you complete them
- Add new stages if scope expands
- Run .ai/hooks/verify-build.sh after each stage

When closing:
- Audit all checklist items
- Run quality gate
- Write summary.md
- Flush to knowledge.md and techdebt.md
- Draft PR description

## Roles
As Architect: focus on task-plan.md, domain model design, risk identification.
  Ensure Resource → Service → Store boundary. Flag concurrency risks early.
  Records must be forward-compatible with @JsonIgnoreProperties.

As Developer: implement exactly what the plan says. No gold-plating.
  Follow all coding standards above. Run quality gate after each stage.
  Update tracker.md Current Focus at end of every session.

As QA: verify all checklist items. Run ./gradlew clean build test.
  Confirm deserialization tests exist for new records.
  Check no eq() matchers in Mockito calls.

## Workflow Prompts
/new-task [ID] [description]
  → parse description, scan codebase, create task folder with all 6 standard files

/pre-flight [ID]
  → trace method chains, cross-check knowledge, update findings.md
  → output: "Ready to plan" or "Blocked by: [questions]"

/build-plan [ID]
  → read findings.md, design staged plan, write task-plan.md + checklist.md
  → pause for confirmation before any implementation

/execute [ID] "Stage N"
  → implement one stage, check off items, run quality gate

/close-task [ID]
  → audit checklist, run quality gate, write summary.md, flush, draft PR

## Tech Debt
- LibraryStore is in-memory — state lost on restart
- Borrow check-then-act is not fully atomic (see techdebt.md)
- addBook() accepts raw Map — no input validation
- No search capability yet (TASK-002)
```

---

## The problems with this file

**Token waste**: Every session loads all ~150 lines regardless of what you're doing.
Fixing a bug in LibraryService doesn't need the task workflow instructions or role definitions.

**Hard to maintain**: One file changed by many sessions. Merge conflicts when two tasks
both update the coding standards section. No clear ownership of each section.

**Stale sections**: The tech debt list is now out of date — TASK-002 was completed but
nobody updated this file. Nobody remembers which section to update for which kind of change.

**Not reusable**: These testing standards and role definitions are identical across
three other repos, but they're copy-pasted into each one.

---

## The solution
See `CLAUDE.md` (the actual file in this repo) — it's 20 lines.
All the content above lives in focused files under `.ai/`, loaded on demand.
