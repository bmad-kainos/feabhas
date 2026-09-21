---
name: risk-based-test-prioritisation
description: "Rank test cases or stories by risk to prioritise QA effort. Use when: deciding which tests to run first in a time-constrained release; prioritising test design effort across a backlog of tickets; triage of a large test suite to identify what matters most. Combines change impact and criticality to produce a ranked priority list."
argument-hint: "Provide a list of tickets, features, test cases, or areas to analyse — or a Jira sprint/JQL query"
---

# Risk-Based Test Prioritisation

Given a set of tickets, features, or test cases, rank them by risk to help you focus QA effort where it matters most.

---

## When to Use

- Sprint planning — deciding which items need the most test coverage
- Release sign-off — determining which tests must pass before go-live
- Time-boxed testing — choosing what to test when there isn't time for everything
- Backlog grooming — identifying stories that carry high QA risk
- Any request mentioning "prioritise tests", "risk ranking", "what should I test first", "which tickets need most coverage"

---

## Risk Model

Each item is scored on two dimensions:

### 1. Change Impact (1–5)
How much does this change affect the system?

| Score | Meaning |
|-------|---------|
| 5 | Core system path — auth, payments, data writes, primary user journey |
| 4 | Important feature used frequently or by many users |
| 3 | Secondary feature, supporting workflow, or internal tooling |
| 2 | Minor UI change, content update, or low-traffic path |
| 1 | Cosmetic change, documentation update, config tweak |

### 2. Failure Criticality (1–5)
What is the impact if this fails in production?

| Score | Meaning |
|-------|---------|
| 5 | System unavailable, data loss, security breach, regulatory breach |
| 4 | Core feature down, significant user impact, revenue affected |
| 3 | Degraded experience, workaround available |
| 2 | Minor inconvenience, easily recoverable |
| 1 | No user impact if it fails |

### Risk Score
```
Risk Score = Change Impact × Failure Criticality
```

Maximum score: 25 (highest risk). Minimum: 1 (lowest risk).

---

## Procedure

### Step 1 — Gather the items to rank

Accept input in any of these forms:
- A list of ticket keys (fetch from Jira via `mcp_atlassian_mcp_jira_search` if MCP is available)
- A pasted list of feature names or test case names
- A sprint name or JQL query
- A directory of test files to rank by coverage criticality

If ticket keys are provided and the MCP server is available, fetch the ticket summaries and descriptions to score them accurately.

### Step 2 — Score each item

For each item, assign:
- A **Change Impact** score (1–5) with a brief justification
- A **Failure Criticality** score (1–5) with a brief justification
- A **Risk Score** = Change Impact × Failure Criticality

### Step 3 — Apply modifiers (optional)

Adjust the raw risk score for any of the following:

| Modifier | Adjustment |
|----------|-----------|
| Recently changed code with no existing tests | +5 |
| Known flaky area or history of bugs | +3 |
| Dependent on external service or integration | +2 |
| Has existing high-quality automated test coverage | −3 |
| Out of scope for this release | Force to 0 |

### Step 4 — Output the ranked list

```
## Risk-Based Test Priority

Sprint / Scope: <sprint name or scope description>
Generated: <date>

| Priority | Ticket | Summary | Impact | Criticality | Risk Score | Recommended Action |
|----------|--------|---------|--------|-------------|------------|-------------------|
| 1 | PROJ-101 | User login flow | 5 | 5 | 25 | Must test — full E2E |
| 2 | PROJ-089 | Payment processing | 5 | 5 | 25 | Must test — integration + E2E |
| 3 | PROJ-112 | Password reset | 4 | 4 | 16 | Should test — integration |
| 4 | PROJ-098 | Dashboard filters | 3 | 2 | 6 | Should test — manual or smoke |
| 5 | PROJ-115 | Footer link update | 1 | 1 | 1 | Skip — no QA action needed |

---

## QA Effort Recommendation

### Must Test (Risk ≥ 16)
- Full test coverage required before release
- <list items>

### Should Test (Risk 6–15)
- Cover happy path and at least one negative case
- <list items>

### Smoke / Spot Check (Risk 3–5)
- Quick manual check or single integration test sufficient
- <list items>

### Skip (Risk ≤ 2)
- No automated test action required for this release
- <list items>
```

---

## Notes

- When two items have the same risk score, prioritise the one with higher **Failure Criticality**
- Items with no existing test coverage should be bumped one tier up regardless of score
- This model is a starting point — apply domain knowledge to override scores where appropriate
