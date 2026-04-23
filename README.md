# library-service

A demo Java/Quarkus REST API for a public library — catalog management, borrowing, and returns.
Used as a presentation demo for AI-assisted engineering workflows.

## What this repo demonstrates

| Pattern | Where to look |
|---|---|
| AGENTS.md as cross-tool canonical | `AGENTS.md` |
| CLAUDE.md as a manifest | `CLAUDE.md` |
| Tribal knowledge + gotchas | `.ai/knowledge.md` |
| Tech debt tracker | `.ai/techdebt.md` |
| Narrow context reference sheets | `.ai/context/` |
| Behavioral skills | `.ai/skills/` |
| Role-based output modes | `.ai/roles/` |
| Reusable workflow prompts | `.ai/prompts/` |
| Task folder — pre-flight done, ready to plan | `.ai/tasks/TASK-001/` |
| Task folder — initial context only | `.ai/tasks/TASK-002/` |
| Quality gate hook | `.ai/hooks/verify-build.sh` |

## Current API

```
GET  /api/books          → list all books
POST /api/books          → add a book { "title", "author", "isbn" }
GET  /api/books/{id}     → get book by ID
```

## Planned (demo additions)

```
POST /api/books/{id}/borrow    → TASK-001: borrow a book
POST /api/loans/{id}/return    → TASK-001: return a book
GET  /api/books/search?q=...   → TASK-002: search by title or author
```

## Running locally

```bash
./gradlew quarkusDev

# Try it
curl http://localhost:8080/api/books

curl -X POST http://localhost:8080/api/books \
  -H "Content-Type: application/json" \
  -d '{"title":"The Pragmatic Programmer","author":"David Thomas","isbn":"978-0135957059"}'
```

## Demo script

1. Open `AGENTS.md` — show the cross-tool canonical pattern (≤150 lines, all non-inferable)
2. Open `.ai/knowledge.md` — point out the ConcurrentHashMap gotcha and the borrow race condition
3. Open `.ai/tasks/TASK-001/` — walk through:
   - `context.md` (requirements, relevant files)
   - `findings.md` (pre-flight complete — race condition documented, ready to plan)
   - `tracker.md` (Current Focus, Active Role, Session Protocol)
4. Live: `/build-plan TASK-001` — watch Claude propose stages, pause for confirmation
5. Live: `/new-task TASK-003 "Add overdue book detection"` — watch Claude create the folder
6. Show: the AI already knows about ConcurrentHashMap, the path ordering gotcha, the layer boundary — it read `knowledge.md`
