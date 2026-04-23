# Testing Standards — library-service

Load when writing or reviewing any test class.

## Stack

- JUnit 5 + Mockito + AssertJ
- Run tests: `./gradlew test`

## Unit testing style

- Follow `Given-When-Then` structure with comments
- One behavior per test method
- Descriptive method names: `shouldReturnEmpty_whenBookNotFound()`

## Mockito patterns

- **NEVER** use `eq()` matchers — use raw values directly
- Prefer `argThat(predicate)` over `any()` when the argument structure matters
- Use `@ExtendWith(MockitoExtension.class)`

## Domain Records

- Every new `record` domain model **MUST** have a JSON deserialization test
- Test both the happy path and `@JsonIgnoreProperties` (unknown fields must not throw)
- Place tests in `src/test/java/...domain/model/`

## Coverage requirements

- New `*Service` class: all public methods, at least one error/empty path per method
- New `*Store` class: save + find + collection operations
