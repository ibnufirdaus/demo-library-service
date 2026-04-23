## Findings: TASK-001 — Borrow and Return

### Codebase Observations

**`LibraryStore` already has loan scaffolding** — `saveLoan()`, `findLoan()`, `allLoans()` exist but are not yet called. The store is ready; the work is in the service and resource layers.

**`Book.withAvailable()` exists** — the domain model is already set up for the availability flip. No record changes needed.

**`Loan.withReturn()` exists** — returning a loan is a `withReturn(LocalDate.now())` call followed by `store.saveLoan(updated)`. No record changes needed.

**`LoanResource` needs to be a new class** — loan endpoints (`/api/loans`) should live in their own resource, not on `LibraryResource`.

### Risks

**⚠️ Check-then-act race on borrow (from knowledge.md)**
The naive implementation — `findBook()` → check `available` → `saveBook(withAvailable(false))` — is not atomic. Two concurrent requests for the same book can both pass the availability check before either writes the update.

**Fix**: Use `ConcurrentHashMap.replace(id, currentBook, updatedBook)` in `LibraryStore` for the availability flip. If `replace()` returns false, another thread won the race — respond with 409 Conflict.

A new `tryBorrow(String bookId)` method in `LibraryStore` should encapsulate this:
```java
// Returns Optional.empty() if book not found or not available
// Returns Optional<Book> (updated) if the atomic flip succeeded
public Optional<Book> tryBorrow(String bookId) { ... }
```

### Constraints
- Availability update and loan creation are **not** in a transaction — if `saveLoan()` throws after `tryBorrow()` succeeds, the book will be marked unavailable with no active loan. Log this scenario as a known limitation in `techdebt.md`.
- `LoanResource` must be at `/api/loans` — not nested under `/api/books`
- Return date should be `LocalDate.now()` at the time of the return call — not `LocalDate.now()` at loan creation

### Ready to plan
→ Run `/build-plan TASK-001` to generate `task-plan.md` and `checklist.md`.
