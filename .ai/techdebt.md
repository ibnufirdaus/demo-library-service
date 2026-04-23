### Technical Debt Tracker: library-service

| Category | Description | Impact | Priority | Detected |
|---|---|---|---|---|
| Persistence | `LibraryStore` is in-memory only — state is lost on restart | Correctness | High | 2026-04-12 |
| Concurrency | Borrow availability check is not atomic — race condition under load | Correctness | High | 2026-04-12 |
| Validation | `LibraryResource.addBook()` accepts a raw `Map` — no input validation on title/author/isbn | Correctness | Medium | 2026-04-12 |
| Search | No search capability — clients must fetch all books and filter client-side | UX | Medium | 2026-04-12 |

### Recently Resolved
_(none yet)_
