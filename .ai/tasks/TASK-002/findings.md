## Findings: TASK-002 — Book Search

### Open Questions
- Should search return books that are currently unavailable (on loan)? Assume yes — search the full catalog.
- Should the `q` parameter support multiple terms (e.g. "clean code")? Assume yes — match if any term matches title or author.

### Constraints
- ⚠️ `@Path("/search")` must be declared BEFORE `@Path("/{id}")` in `LibraryResource` — see knowledge.md for the JAX-RS path collision gotcha.

### Pre-flight
_(Run `/pre-flight TASK-002` to complete.)_
