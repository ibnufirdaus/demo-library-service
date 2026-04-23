## Summary
Add borrow and return functionality to the library API — members should be able to borrow an available book and return it when done.

## Background
The initial catalog API (list, add, get by ID) is in place. The next core capability is the lending lifecycle: check out a book to a member, track active loans, and accept returns.

## Requirements
- `POST /api/books/{id}/borrow` — borrow a book
  - Body: `{ "memberName": "Alice" }`
  - Returns the created `Loan` record
  - Returns 409 Conflict if the book is not available
  - Returns 404 if the book does not exist
- `POST /api/loans/{id}/return` — return a book
  - Returns the updated `Loan` record
  - Returns 409 Conflict if the loan is already returned
  - Returns 404 if the loan does not exist
- Returning a book must set `available=true` on the corresponding `Book`
- New `LoanResource` for loan endpoints (separate from `LibraryResource`)

## Relevant Files
- `domain/model/Book.java` — add availability update logic (already has `withAvailable()`)
- `domain/model/Loan.java` — already defined; confirm all fields satisfy requirements
- `store/LibraryStore.java` — add `saveLoan()`, `findLoan()`, `allLoans()` (already scaffolded)
- `service/LibraryService.java` — add `borrowBook()`, `returnBook()` methods
- `api/LibraryResource.java` — add `POST /{id}/borrow` endpoint
- `api/LoanResource.java` — new: `POST /api/loans/{id}/return`

## References
- Architecture context: `.ai/context/architecture.md` — borrow race condition pattern
- Concurrent gotcha: `.ai/knowledge.md` — check-then-act race on availability
