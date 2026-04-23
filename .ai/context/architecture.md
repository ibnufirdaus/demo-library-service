### Architecture Context: library-service

#### Request Flow

```
HTTP Request
  └─► api/LibraryResource.java        [JAX-RS, CDI]
        └─► service/LibraryService.java  [CDI, @ApplicationScoped]
              └─► store/LibraryStore.java [CDI, @ApplicationScoped, ConcurrentHashMap]
```

#### Domain Model

```
Book (record)
  id:        String  — UUID, generated on creation
  title:     String
  author:    String
  isbn:      String
  available: boolean — false while on loan

Loan (record)
  loanId:      String    — UUID
  bookId:      String    — FK to Book.id
  memberName:  String
  borrowedOn:  LocalDate
  returnedOn:  LocalDate — null while active

  isActive()    → returnedOn == null
  withReturn()  → returns new Loan with returnedOn set
```

#### Current API Surface

```
GET  /api/books          → list all books
POST /api/books          → add a book { title, author, isbn }
GET  /api/books/{id}     → get book by ID
```

#### Planned Additions (task-gated)

```
POST /api/books/{id}/borrow        → TASK-001
POST /api/loans/{id}/return        → TASK-001
GET  /api/books/search?q=<query>   → TASK-002
```

#### Invariants
- A book with `available=false` cannot be borrowed again
- A loan with `returnedOn != null` cannot be returned again
- `LibraryResource` never touches `LibraryStore` directly
