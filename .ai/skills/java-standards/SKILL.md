---
name: java-standards
description: Enforces Java 21, Quarkus 3.x, and project-specific coding standards (CDI, naming, concurrency, JAX-RS path ordering).
---

## Usage
Load this skill when writing or reviewing any Java class in this project.

## Instructions
- Use Java 21 idioms: `record`, `sealed interface`, `Optional` chains, text blocks.
- Respect the three-layer boundary: Resource → Service → Store. Never skip layers.
- `@ApplicationScoped` beans must use `ConcurrentHashMap` — never plain `HashMap`.
- For shared state mutations: use `ConcurrentHashMap.replace()` — never `put()` after `get()`.
- No single-implementation interfaces.
- Follow naming conventions: `*Resource`, `*Service`, `*Store`, `*Request`, `*Response`.
- `@Path("/search")` must appear before `@Path("/{id}")` in the same resource class.
- Refer to `.ai/context/java-standards.md` for full details.
