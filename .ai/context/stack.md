### Stack Context: library-service

#### Tech Stack
- Java 21
- Quarkus 3.x — REST (JAX-RS), CDI, Jackson
- Gradle 8
- JUnit 5 + Mockito + AssertJ

#### Local Setup

> **sdkman offline fallback**: `sdk use java` silently fails when sdkman cannot reach the internet. If it reports "java is not a valid candidate", use:
> ```bash
> export JAVA_HOME=$HOME/.sdkman/candidates/java/21.0.5-zulu
> export PATH=$JAVA_HOME/bin:$PATH
> ```
> Verify with `java -version` before running any build or test command.

#### Build & Run

```bash
# Build and test
./gradlew clean build

# Run locally (Quarkus dev mode — live reload)
./gradlew quarkusDev

# Curl examples
curl http://localhost:8080/api/books
curl -X POST http://localhost:8080/api/books \
  -H "Content-Type: application/json" \
  -d '{"title":"Clean Code","author":"Robert C. Martin","isbn":"978-0132350884"}'
```

#### Key Dependency Boundaries
- `LibraryResource` is a JAX-RS resource — CDI-managed, but do not put business logic here
- `LibraryService` is the CDI business logic layer — inject `LibraryStore`, nothing else
- `LibraryStore` is the data layer — only raw CRUD operations, no business rules
