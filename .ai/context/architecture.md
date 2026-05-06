### Architecture Context: library-service

#### Stack (Ground Truth)
- **Runtime**: Quarkus (latest stable)
- **Language**: Java 25 (utilizing Records, Sealed Classes)
- **CDI**: Managed beans with `@ApplicationScoped` and `@RequestScoped`.
- **Concurrency**: `LibraryStore` uses `ConcurrentHashMap`. Note that CDI context propagation requires `ManagedExecutor` if using async.

#### Request Flow
```
HTTP Request
  └─► api/LibraryResource.java        [JAX-RS, CDI]
        └─► service/LibraryService.java  [CDI, @ApplicationScoped]
              └─► store/LibraryStore.java [CDI, @ApplicationScoped, ConcurrentHashMap]
```

#### Domain Model (Records)
- **Book**: `id` (UUID), `title`, `author`, `isbn`, `available` (boolean).
- **Loan**: `loanId` (UUID), `bookId`, `memberName`, `borrowedOn`, `returnedOn` (nullable).
  - `isActive()`: `returnedOn == null`
  - `withReturn()`: Returns a new instance with `returnedOn` set.

#### Invariants
- `LibraryResource` never touches `LibraryStore` directly.
- Domain models are immutable (Records). State changes return new instances.
- Borrowing a book requires `available=true`.
- Returning a loan requires `returnedOn=null`.

#### API Surface
- `GET  /api/books`
- `POST /api/books`
- `GET  /api/books/{id}`
- `POST /api/books/{id}/borrow` (TASK-001)
- `POST /api/loans/{id}/return` (TASK-001)
- `GET  /api/books/search?q=<query>` (TASK-002)
