---
name: confluence-test-plan
description: "Generate and publish a structured test plan page to Confluence from a Jira sprint's tickets. Use when: starting a new sprint and needing a test plan; creating test strategy documentation; documenting test coverage for a set of Jira tickets; publishing a test plan to Confluence automatically from sprint contents."
argument-hint: "Provide a Jira project key (e.g. 'PROJ'), a JQL query (e.g. sprint = 'Sprint 25'), a sprint name, or a list of Jira ticket keys"
---

# Confluence Test Plan Generator

## Purpose

Generate a structured, professional test plan page in Confluence automatically from a sprint's Jira tickets.

As lead test engineer in a separate test repository, you need to produce test plan artefacts independently of the implementation team. This skill:
1. Fetches all tickets from a sprint via Jira MCP
2. Analyses each ticket for test level, scenarios, and prerequisites
3. Generates a formatted test plan document
4. Publishes it directly to Confluence via Confluence MCP

---

## When to Use

- Sprint planning starts and you need a test plan page
- Test strategy documentation is required for a feature or epic
- Producing evidence of test coverage for a sprint review
- Any request mentioning "test plan", "test strategy", "Confluence", "publish", "document coverage"

---

## Procedure

### Step 1 — Fetch sprint tickets from Jira

If no project key has been provided, ask the user for it before running the query.

Use the Jira MCP tool with the provided JQL or sprint name:

```
mcp_atlassian_mcp_jira_search(
    jql="project = <PROJECT_KEY> AND sprint = 'Sprint 25' ORDER BY updated DESC",
    fields="key,summary,description,issuetype,status,assignee,labels"
)
```

If only a sprint name is given, construct the JQL automatically:
```
project = <PROJECT_KEY> AND sprint = "<sprint name>" ORDER BY updated DESC
```

---

### Step 2 — Analyse each ticket

For each ticket, determine (using the same logic as `jira-testing-analysis`):

| Field | How to determine |
|-------|-----------------|
| Test level | Unit / Integration / E2E — from AC complexity and external dependencies |
| Test scenarios | One per AC, plus edge cases, negative, boundary, security |
| Prerequisites | Environments, credentials, dependent tickets |
| Automated? | Yes / Manual / Blocked |
| Estimated effort | Quick (<4h) / Medium (4-12h) / High (12h+) |

---

### Step 3 — Generate the Confluence page content

Produce a page with the following structure:

```
# Test Plan — <Sprint Name>

**Author:** <current user>
**Date:** <today>
**Project:** <Project Name> (<PROJECT_KEY>)
**Sprint:** <sprint name>
**Status:** Draft

---

## 1. Scope

This test plan covers the following stories in <Sprint Name>:
[list of ticket keys and summaries]

Out of scope: [list any tickets explicitly noted as out-of-scope for testing]

---

## 2. Test Approach

| Ticket | Summary | Test Level | Automated | Effort |
|--------|---------|-----------|-----------|--------|
| PROJ-001 | Example story one | Unit | ✅ Yes | Quick |
| PROJ-002 | Example story two | E2E | ✅ Yes | High |
...

---

## 3. Test Scenarios per Ticket

### PROJ-001 — Example story one

**Test level:** Unit
**Automated:** Yes

| # | Scenario | Category | Expected outcome |
|---|----------|----------|------------------|
| 1 | Happy path input succeeds | AC / Happy path | Pass |
| 2 | Required field missing returns error | Negative | Fail |
| 3 | Boundary value at minimum accepted | Edge case | Pass |
| 4 | Invalid input type rejected | Negative | Fail |

**Prerequisites:** None — unit tests, no environment required

---

[repeat per ticket]
| 8 | Forged signature rejected | Security | Fail |

**Prerequisites:** None — unit tests, no environment required

---

[repeat per ticket]

---

## 4. Prerequisites and Dependencies

| Requirement | Needed for | Status |
|------------|-----------|--------|
| Test environment access | Multiple tickets | TBC |
| External service credentials | Integration tickets | TBC |
| Zephyr test cycle created | All | ⬜ To do |

---

## 5. Risks and Assumptions

- List any explicit out-of-scope items from individual tickets
- Note any E2E tests that are blocked on prerequisite tickets completing first
- Flag any test payloads or data that require security or governance review before use

---

## 6. Test Effort Summary

| Category | Tickets | Estimated hours |
|----------|---------|----------------|
| Quick (unit) | PROJ-001, PROJ-002 | 4-6h |
| Medium (integration) | PROJ-003, PROJ-004 | 8-14h |
| High (E2E) | PROJ-005, PROJ-006 | 36-50h |
| Manual only | PROJ-007 | — |
| **Total** | | **~48-70h** |
```

---

### Step 4 — Find or create the target Confluence page

1. Search for an existing test plan space/parent page:
   ```
    mcp_atlassian_mcp_confluence_search(
       query="Test Plans <PROJECT_KEY> sprint",
       space_key="<PROJECT_KEY>"
   )
   ```

2. If a parent "Test Plans" page exists, create the new page as a child:
   ```
    mcp_atlassian_mcp_confluence_create_page(
       space_key="<PROJECT_KEY>",
       title="Test Plan — Sprint 25",
       content=<generated_content>,
       parent_id=<parent_page_id>
   )
   ```

3. If no parent page exists, create under the space root and note the URL to the user.

---

### Step 5 — Output to user

After publishing, confirm:
- Confluence page URL
- Number of tickets covered
- Total estimated test effort
- Any tickets flagged as blocked or manual-only

---

## Confluence Page Conventions

- Title format: `Test Plan — <Sprint Name>` (e.g. `Test Plan — Sprint 25`)
- Labels: `test-plan`, `<project-key-lowercase>`, `<sprint-name-slugified>`
- Parent page: `<PROJECT_KEY> / Test Plans /` (create the hierarchy if it doesn't exist)
- Status macro at top: `Draft` → update to `Final` once reviewed

---

## Related skills

- `jira-testing-analysis` — Detailed per-ticket test level analysis
- `api-tests` — Scaffold the actual test files
