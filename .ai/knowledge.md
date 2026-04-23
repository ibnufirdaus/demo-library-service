### Project Knowledge: library-service

Architectural decisions, tribal knowledge, and non-obvious constraints for `library-service`.

#### Context & Purpose
- **Purpose**: REST API for a public library — catalog management, borrowing, and returns.
- **Data layer**: In-memory `ConcurrentHashMap` via `LibraryStore` (`@ApplicationScoped`).
- **Scope**: Single-node, no persistence. Designed to be extended (see tech debt tracker).

#### Architectural Patterns

**Service + Store separation**
`LibraryResource` (JAX-RS) → `LibraryService` (business logic, CDI) → `LibraryStore` (data, CDI).
The resource layer must not call `LibraryStore` directly — all business logic lives in `LibraryService`.

**Domain records are immutable**
`Book` and `Loan` are `record` types. To update a field, use the `with*()` helper methods — do not introduce mutable setters.

#### Threading ⚠️ Non-obvious

**ConcurrentHashMap, not HashMap**
JAX-RS worker threads are managed by the container — multiple requests run concurrently. `LibraryStore` uses `ConcurrentHashMap` for both `books` and `loans`. Never replace these with plain `HashMap` — it causes silent data corruption under concurrent load (no exception, just wrong state).

**Check-then-act race on borrow**
`isAvailable()` + `markUnavailable()` is not atomic. Under concurrent load, two requests for the same book can both pass the availability check before either marks it unavailable — resulting in the same book being lent twice. Mitigation: use `ConcurrentHashMap.replace(key, expectedValue, newValue)` for the availability flip. See TASK-001 findings for details.

#### JAX-RS Gotcha: `/search` vs `/{id}` path collision
`GET /api/books/search` and `GET /api/books/{id}` will conflict if `search` is not declared before `{id}` in the resource class, depending on the JAX-RS implementation. To avoid ambiguity, put `@Path("/search")` as a separate method above the `@Path("/{id}")` method, or use a dedicated sub-resource class. See TASK-002.

#### ID Generation
`UUID.randomUUID()` is used for all entity IDs. IDs are opaque strings — never parse or sort them. If sequential IDs are ever needed, use an `AtomicLong` counter in `LibraryStore`, not a global static.


#### Integration
- **Claude Code**: `CLAUDE.md` loaded at session start; skills wired via `.claude/skills/` symlinks (run `bash .ai/setup.sh`)
- **Junie**: `.ai/skills/` contains skill definitions; run `bash .ai/setup.sh` to wire them as native IDE commands.

