# Junie Project Guidelines — library-service

This project uses a vendor-agnostic AI agent configuration located in the `.ai/` folder and `AGENTS.md`.

## Core Guidelines
- **Always follow the instructions in [AGENTS.md](../AGENTS.md)**.
- **Context**: Refer to `.ai/knowledge.md` and documents in `.ai/context/` for architectural and domain knowledge.
- **Skills**: All skills follow the [agentskills.io](https://agentskills.io) standard and live in `.ai/skills/`. Run `bash .ai/setup.sh` to wire them as native slash commands. Refer to `.ai/skills/` for specific technical standards.

## Workflow (Mandatory)
- **Task Management**: Do NOT use `.junie/memory/tasks.md`. Instead, use the task-specific folders in `.ai/tasks/[TASK-ID]/`.
- **Session Resume**: When starting a session for an existing task, always load `tracker.md`, `checklist.md`, and `findings.md` from the corresponding task folder as specified in `AGENTS.md`.
- **Quality Gates**: Before submitting any work, run the scripts in `.ai/hooks/` if they exist.

## Environment Setup
- Refer to `AGENTS.md` for the mandatory environment setup and SDK versions.

## Synchronization
- Ensure that findings and progress are updated in the relevant `.ai/tasks/[TASK-ID]/` files (especially `findings.md` and `tracker.md`) to maintain consistency across different AI agents (Junie, Claude Code, etc.).
