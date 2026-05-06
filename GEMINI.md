# library-service: AI Coding Harness

This file defines the foundational mandates and operational workflows for AI agents working in this repository.

## 1. Interaction Modes
To optimize token usage and accuracy, always operate in one of the following modes. Prefix your status updates or plans with the active mode.

- **`[RESEARCH]`**: Deep dive and evidence gathering. Focus on reading code, tracing call chains, and verifying assumptions. No code changes.
- **`[PLAN]`**: Drafting `task-plan.md` and `checklist.md`. Strategy formulation based on research.
- **`[CODE]`**: Surgical, targeted edits. Use `replace` whenever possible. Follow established patterns.
- **`[VERIFY]`**: Evidence collection and harness feedback. Run tests and hooks. Capture output as proof of correctness.
- **`[HARNESS]`**: Updating `.ai/` files (knowledge, skills, hooks) to encode new learnings or prevent recurring errors.

## 2. Harness-First Recovery
If an error occurs, a bug is found, or a pattern is misunderstood:
1. **Analyze**: Identify the root cause and why the existing harness (hooks, knowledge, skills) didn't catch it.
2. **Update Harness**: Modify `.ai/knowledge.md`, add/update a hook in `.ai/hooks/`, or refine a skill.
3. **Fix Code**: Only after the harness is updated to prevent this class of error forever should you fix the implementation.

## 3. Engineering Standards
- **Stack**: Quarkus (Java 25), JAX-RS, CDI.
- **Concurrency**: `LibraryStore` uses `ConcurrentHashMap`. Be mindful of CDI scope propagation.
- **Immutability**: Prefer Java Records for domain models (`Book`, `Loan`).
- **Surgical Edits**: Prefer `replace` over `write_file` for existing files. Minimize "just-in-case" changes.

## 4. Task Management
Every non-trivial task MUST have a dedicated folder in `.ai/tasks/[TASK-ID]/`.
Use templates from `.ai/templates/task/` to maintain state.
- `tracker.md`: High-level status and ownership.
- `checklist.md`: Step-by-step execution plan.
- `context.md`: Requirements and relevant files.
- `findings.md`: Technical observations and research notes.
- `summary.md`: Final recap of changes and verification.
