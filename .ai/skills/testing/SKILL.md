---
name: testing
description: Enforces JUnit 5 + Mockito + AssertJ testing standards — no eq() matchers, record deserialization tests, Given-When-Then structure.
---

## Usage
Load this skill when writing or reviewing any test class in this project.

## Instructions
- Follow `Given-When-Then` structure with comments.
- One behavior per test method; descriptive names: `shouldReturnEmpty_whenBookNotFound()`.
- **NEVER** use `eq()` matchers in Mockito — use raw values directly.
- Every new `record` domain model **MUST** have a JSON deserialization test.
- New `*Service` class: cover all public methods, at least one error/empty path per method.
- New `*Store` class: cover save + find + collection operations.
- Refer to `.ai/context/testing.md` for full details.
