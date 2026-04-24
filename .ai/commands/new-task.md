---
name: new-task
description: Initialize a task folder for a new Jira ticket. Fetches the ticket and linked Confluence docs, scans the codebase, and creates all standard task files in .ai/tasks/[TASK-ID]/. Pass the Jira ticket ID as argument (e.g. /new-task BOS-4300).
---

## Live context
- Existing task folders: !`ls .ai/tasks/ 2>/dev/null | sort`
- Repo status: !`git status --short | head -8`
- Recent commits: !`git log --oneline -3`

## Instructions

We are initializing a new task folder for a Jira ticket.

Your job:
1. Fetch the Jira ticket using the Atlassian MCP tool.
2. Fetch any Confluence pages linked in the ticket or provided in the input.
3. Search the codebase for areas likely affected by this work.
4. Detect task type: is this a spike (investigation/design), a feature, a bug fix, or a data/query change?
5. If important information is missing or ambiguous, ask targeted follow-up questions before creating files.
6. Create the task folder at `.ai/tasks/[TASK-ID]/` with the standard files (see below).

Standard files to always create:
- `context.md` — requirements, background, relevant files, all reference links
- `checklist.md` — seed with context-gathering steps already checked off, then leave implementation steps as TBD
- `findings.md` — non-obvious constraints and codebase observations from this init pass
- `tracker.md` — status, owner, Jira link, current stage
- `task-plan.md` — leave blank; filled during `build-plan`

Additional files to create when applicable:
- `jira_drafts.md` — create a placeholder if this is a spike; the output of a spike is follow-up ticket drafts

For `context.md`, use this minimal structure:
```
## Summary
[1–2 sentence plain description of what this task does]

## Background
[Why this task exists — parent ticket, feature context, or business driver]

## Requirements
[Bullet list from the Jira ticket — verbatim or lightly cleaned up]

## Relevant Files
[Class names and paths identified in the codebase]

## References
[Jira link, Confluence URLs, Metabase links, Slack threads, design docs — anything provided or found in the ticket]
```

For `checklist.md`, always seed the first stage as already-completed context gathering:
```
## Stage 0: Context Gathering (Context Step)
- [x] Fetch Jira ticket BOS-XXXX
- [x] Read linked Confluence pages
- [x] Identify affected source files
```
Then leave Stage 1 onward as TBD — to be filled by `build-plan`.

For `tracker.md`, seed with:
- Status: 🔴 Not Started
- Owner: (from ticket assignee or ask)
- Jira link
- Current stage: Pre-planning

For `findings.md`, include anything non-obvious discovered during initialization:
- Relevant patterns from `.ai/knowledge.md` that apply to this task
- Technical debt items from `.ai/techdebt.md` that this task touches
- CDI or threading constraints that are likely relevant
- Whether new metric events, domain Records, or AWS adapters will be needed

Rules:
- Do not invent requirements not present in the ticket or docs.
- Do not start planning or implementation — this phase is context capture only.
- Capture scope ambiguities as open questions in `findings.md`, not in `context.md`.
- If the ticket references Slack threads, Metabase queries, or design docs — include those links in `context.md` References.

After creating files, summarize:
- Task type (spike / feature / bug / data change)
- What files were created
- Open questions that must be resolved before planning

Input (Jira ticket ID / URL, plus any Confluence, Slack, or Metabase links):
$ARGUMENTS

## Recommended Usage

- Run at the very start of any new ticket before touching code.
- The seeded Stage 0 checklist prevents the "who did the research?" question mid-task.
- For spike tasks, the `jira_drafts.md` placeholder signals that ticket creation is a required output.
- Follow with `pre-flight` once clarifications are in hand.
