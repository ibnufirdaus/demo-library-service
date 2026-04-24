---
name: architecture
description: library-service architecture context — three-layer flow, domain model (Book, Loan), and current API surface.
---

## Usage
Load this skill when answering architecture questions or designing changes to the domain model or request flow.

## Instructions
- The request flow is: HTTP → `LibraryResource` → `LibraryService` → `LibraryStore`.
- Domain model: `Book` (record — id, title, author, isbn, available) and `Loan` (record — loanId, bookId, memberName, borrowedOn, returnedOn).
- `Loan.isActive()` returns `returnedOn == null`. State transitions use `Loan.withReturn()`.
- Refer to `.ai/context/architecture.md` for the full domain model and current API surface.
