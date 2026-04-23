# Java Standards — library-service

Load when writing or reviewing any Java class.

## Stack

- **Java**: 21
- **Framework**: Quarkus 3.x (JAX-RS, CDI, Jackson)
- **Build**: Gradle 8

## Modern Java 21

- Use `record` for data carriers with no mutable state — use `with*()` helpers for state transitions
- Use `sealed interface` for closed type hierarchies
- Use `Optional` chains instead of null checks
- Use text blocks for multi-line strings (JSON test fixtures, SQL)
- Use `switch` expressions with type patterns over `instanceof` chains

## Naming conventions

| Suffix | Role |
|---|---|
| `*Resource` | JAX-RS endpoint classes |
| `*Service` | CDI business logic (`@ApplicationScoped`) |
| `*Store` | CDI data access layer (`@ApplicationScoped`) |
| `*Request` / `*Response` | API payload records |

## CDI layer rules

- `*Resource` classes: JAX-RS only — delegate everything to `*Service`
- `*Service` classes: business logic, inject `*Store` — no JAX-RS annotations
- `*Store` classes: data access only — no business rules, no JAX-RS
- **NEVER skip layers**: Resource → Service → Store

## Concurrency rules

- **NEVER** use plain `HashMap` in `@ApplicationScoped` beans — **ALWAYS** use `ConcurrentHashMap`
- Check-then-act on shared state: **ALWAYS** use `ConcurrentHashMap.replace(key, expected, new)` — never plain `put()` after `get()`

## JAX-RS path ordering

- `@Path("/search")` must appear **before** `@Path("/{id}")` in the same resource class — otherwise `search` is treated as an ID

## Logging

```java
private static final Logger LOG = Logger.getLogger(Foo.class);
```
- `WARN` for skipped or no-op operations
- `ERROR` only for unexpected exceptions
