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
6. Create the task folder at `.ai/tasks/[TASK-ID]/` using templates from `.ai/templates/task/`.

Standard files to always create:
- `context.md`
- `checklist.md`
- `findings.md`
- `tracker.md`
- `task-plan.md`
- `summary.md`

For `context.md`, seed with:
- Summary, Background, Requirements, Relevant Files, and References from the ticket/research.

For `checklist.md`, always seed the first stage:
```
## Stage 0: Context Gathering
- [x] Fetch Jira ticket [TASK-ID]
- [x] Read linked Confluence pages
- [x] Identify affected source files
```

For `tracker.md`, seed with current date and status.

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
