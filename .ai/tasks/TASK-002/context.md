## Summary
Add book search functionality — members should be able to search the catalog by title or author with a single query string.

## Background
The catalog currently requires fetching all books and filtering client-side. For a library with hundreds of titles, server-side search is necessary. This is the first read-optimisation feature on top of the HashMap data layer.

## Requirements
- `GET /api/books/search?q=<query>` — search books by title or author
  - Case-insensitive partial match on both `title` and `author`
  - Returns a (possibly empty) list of matching books
  - Returns 400 Bad Request if `q` is blank

## Relevant Files
- `service/LibraryService.java` — add `search(String query)` method
- `api/LibraryResource.java` — add `GET /search` endpoint
  - ⚠️ Path ordering: `@Path("/search")` must appear before `@Path("/{id}")` — see knowledge.md

## References
- Architecture context: `.ai/context/architecture.md`
- Blocked by: TASK-001 should be merged first (no hard dependency, but the demo flows better)
