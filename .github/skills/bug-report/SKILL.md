---
name: bug-report
description: "Generate a structured bug report from reproduction steps, a failing test, an error message, or a description of unexpected behaviour. Use when: a bug has been found during testing; a test has failed and needs a ticket raised; a defect needs to be reported in Jira or another tracker. Produces a complete bug report with severity, steps to reproduce, expected vs actual, environment, and supporting evidence."
argument-hint: "[Describe what went wrong, paste the error or failing test output, or provide a ticket key to pull context from]"
user-invocable: true
---

# Skill: Bug Report

Generate a well-structured, actionable bug report from reproduction steps, failing test output, or a plain English description of unexpected behaviour.

---

## When to Use

- A defect has been found during manual or automated testing
- A test has failed and needs a corresponding bug ticket raised
- Unexpected behaviour has been observed in a test environment
- Any request mentioning "raise a bug", "log a defect", "create a bug report", "it broke", "test failed"

---

## Procedure

### Step 1 — Gather information

Collect the following before generating the report. If anything is missing, ask the user:

| Field | Source |
|-------|--------|
| What went wrong | User description, error message, failing test output |
| Steps to reproduce | User description or derivable from test code |
| Expected behaviour | AC on the ticket, API spec, or explicit user statement |
| Actual behaviour | Error message, response body, screenshot, or test assertion failure |
| Environment | Dev / Test / Staging / Production |
| Ticket / feature reference | Branch name, Jira key, or description |
| Supporting evidence | Stack trace, logs, screenshot path, test output |

---

### Step 2 — Classify severity

Assign **one** severity level:

| Severity | Criteria |
|----------|----------|
| **Critical** | System crash, data loss, security vulnerability, complete loss of core functionality |
| **High** | Core feature broken, no workaround available, blocking testing progress |
| **Medium** | Feature partially broken, workaround exists, or non-critical path affected |
| **Low** | Minor cosmetic issue, edge case, or inconvenience with easy workaround |

---

### Step 3 — Generate the bug report

Produce the following structure:

```
## Summary
<One sentence: what is broken and where>

## Severity
<Critical / High / Medium / Low> — <one-line justification>

## Environment
- Environment: <Dev / Test / Staging / Production>
- Branch / version: <branch name or version>
- Related ticket: <PROJ-1234 or N/A>

## Steps to Reproduce
1. <First step>
2. <Second step>
3. <Third step — the one that triggers the bug>

## Expected Behaviour
<What should happen based on the ACs, spec, or requirements>

## Actual Behaviour
<What actually happened — be specific, include values, status codes, error messages>

## Supporting Evidence
<Paste error message, stack trace, failing test output, or note "see attachment">

## Root Cause (if known)
<Optional — only include if the cause is already identified>

## Suggested Fix (if known)
<Optional — only include if a fix is obvious from the evidence>
```

---

### Step 4 — Jira creation (optional)

If the user wants to create the bug in Jira, use the MCP tool:

```
mcp_atlassian_mcp_jira_create_issue(
    project_key="<PROJECT_KEY>",
    summary="<bug summary>",
    description="<full bug report body>",
    issue_type="Bug",
    priority="<Critical|High|Medium|Low>"
)
```

Ask the user to confirm the project key and priority before creating.

If the MCP server is unavailable, output the full report as Markdown for the user to copy into their tracker manually.

---

## Output Format

Present the bug report as clean Markdown, ready to paste into Jira, GitHub Issues, or any other tracker. Do not add preamble — output the report directly.
