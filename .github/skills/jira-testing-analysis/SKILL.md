---
name: jira-testing-analysis
description: "Analyse Jira tickets from a Lead Test Engineer perspective during refinement. Use when: reviewing sprint or backlog tickets for QA readiness; determining if a ticket is ready for development; scoring tickets for requirements clarity, testability, and automation readiness; identifying observability gaps; blocking tickets that are not ready; producing a refinement summary with QA action breakdown."
argument-hint: "Provide a project key (e.g. 'PROJ'), a sprint bucket name (e.g. 'Ready for Refinement'), a sprint name (e.g. 'Sprint 25'), or a full JQL override. Required: project key must be supplied on first use."
---

# Jira Testing Analysis

## Overview

Analyses Jira tickets from a Lead Test Engineer perspective.

The goal is not simply to determine test levels, but to answer:

- Is this ticket ready for development?
- Are the requirements testable?
- Does QA need to do anything?
- What level of validation is appropriate?
- Are there gaps that should be addressed during refinement?
- Is additional automation required?

This skill is intended for **refinement sessions**, sprint planning, backlog grooming, and QA triage.

---

## When to Use

**Perfect for:**
- Sprint refinement (live, in the room)
- Backlog review
- Sprint planning
- QA readiness assessments
- Identifying requirement gaps
- Prioritising QA effort
- Determining automation requirements
- Identifying stories that should not enter development

**Not suitable for:**
- Writing detailed test cases
- Generating pytest tests
- Reviewing existing automation
- Debugging test failures

Use the `api-tests` skill for implementation.

---

## Tooling

This skill uses `mcp_atlassian_mcp_jira_search` to fetch tickets. The Atlassian MCP server must be running.

**If the tool is unavailable:** Inform the user that the `mcp-atlassian` server needs to be started, then retry once active.

---

## Input Format

**Required:** A Jira project key (e.g. `PROJ`, `ABC`) must be provided. Once given, it is used as the default for the remainder of the session.

**Default query pattern:** `project = <PROJECT_KEY> AND sprint = "Ready for Refinement"`

### How to Query

The input can be one of three forms:

**1. Sprint bucket name (most common)**
A named backlog bucket or board swimlane used in Jira (e.g. a sprint named after a workflow stage).

```
Ready for Refinement
```
→ Translates to: `project = <PROJECT_KEY> AND sprint = "Ready for Refinement"`

**2. Sprint name**
A specific active or historical sprint.

```
Sprint 25
```
→ Translates to: `project = <PROJECT_KEY> AND sprint = "Sprint 25"`

**3. Full JQL override**
Provide a complete JQL query for full control.

```
project = PROJ AND sprint = "Sprint 26" AND issuetype = Story
project = PROJ AND fixVersion = "1.0"
project = PROJ AND status = "To Do" AND labels = "qa-required"
```

**Resolution rule:** If the input contains `project =` treat it as a full JQL override. Otherwise, wrap it as `project = <PROJECT_KEY> AND sprint = "<input>"` and pass that to `mcp_atlassian_mcp_jira_search`.

> **Note:** Jira sprint names are matched as strings — ensure the name matches exactly (case-sensitive). If no results are returned, inform the user and ask them to confirm the sprint name.

---

## Core Analysis Framework

For each ticket assess all six dimensions and score 1–5.

### 1. Requirements Clarity (1–5)
- Is the objective clear?
- Is expected behaviour defined?
- Are assumptions documented?
- Are edge cases described?

### 2. Acceptance Criteria Quality (1–5)
- Are ACs measurable?
- Are outcomes verifiable?
- Are success and failure paths covered?
- Can testing be performed without further clarification?

### 3. Testability (1–5)
- Can behaviour be verified?
- Are test environments available?
- Is expected behaviour observable?
- Is validation practical?

### 4. Automation Readiness (1–5)
- Can automation be written immediately?
- Are inputs and outputs clear?
- Are dependencies manageable?
- Is automation worthwhile?

### 5. Observability (1–5)
- Are logs required?
- Are metrics required?
- Are audit events required?
- Are monitoring expectations defined?

### 6. QA Confidence (1–5)
- Would QA be confident testing this today?
- Are requirements sufficient?
- Are major unknowns resolved?

---

## QA Readiness — RAG Status

Assign one of three statuses to every ticket:

| Status | Meaning |
|---|---|
| 🟢 **Green** | QA is confident to test this now. Requirements are clear, ACs are measurable, test environment is available or not needed. |
| 🟡 **Amber** | QA can test this but with caveats. One or more items need clarification, a dependency is outstanding, or observability is incomplete — but the ticket can still proceed with those items tracked. |
| 🔴 **Red** | QA cannot test this. Requirements are too vague, ACs are missing or unmeasurable, or the design is untestable as written. **Block this ticket until resolved.** |

---

## QA Ownership Classification

Every ticket must be assigned **one** category.

**Developer Validation Only** — QA Action: No
Examples: refactoring, internal code cleanup, validation extraction, helper methods, build script updates, dependency updates, internal configuration changes.

**QA Review Only** — QA Action: Review only
Examples: logging additions, monitoring improvements, feature flags, low-risk configuration changes. Manual verification may be sufficient.

**Integration Coverage Required** — QA Action: Yes
Examples: API changes, service interactions, contract changes, database interactions. Integration automation should be considered.

**E2E Coverage Required** — QA Action: Yes
Examples: customer journeys, multi-system workflows, authentication flows, business-critical functionality. E2E automation should be considered.

**Not Ready For Development** — QA Action: Block refinement outcome
Examples: missing requirements, unclear ACs, significant unknowns, untestable design.

---

## QA Recommendation

Output **exactly one** recommendation per ticket:

- ✅ No QA Action Required
- ✅ Manual Verification Only
- ✅ Integration Test Required
- ✅ E2E Test Required
- 🚫 Not Ready For Development

---

## Test Level Pattern Matching

Use these patterns when classifying QA ownership from the ticket description.

**Signals → Developer Validation Only:**
- "Extract / refactor / move X"
- "Add helper / utility function"
- "Update dependency version"
- "Internal configuration change"

**Signals → Integration Coverage Required:**
- "The X workflow should trigger on Y" → integration test with mock events
- "Build should fail when Z is missing" → integration test validating build process
- "Pipeline should authenticate with service Y" → integration with mocked credentials
- "API endpoint should return X for input Y"
- "Service should call downstream service"

**Signals → E2E Coverage Required:**
- "User / consumer should be able to call the API via the gateway" → full auth + routing flow
- "WAF should block malicious requests" → actual payloads against WAF
- "Proxy should route to backend" → end-to-end from gateway to backend
- "Certificate should be trusted by" → full mTLS chain validation
- "Authentication flow should succeed / fail when"

**Signals → Manual Verification Only:**
- One-time setup or migration tasks
- External partner integrations with limited test access
- Initial infrastructure provisioning

---

## Observability Review

For every ticket assess:

- **Logging Required?** Yes / No
- **Metrics Required?** Yes / No
- **Audit Events Required?** Yes / No
- **Coverage Status:** Complete / Partial / Missing

Highlight any missing observability requirements explicitly — these are often forgotten during refinement and expensive to retrofit.

---

## Testing Prerequisites

For every ticket that requires QA action, identify what is needed before tests can be written or run:

**Environment and Access:**
- [ ] Test environment access
- [ ] External service access (API gateway, OAuth provider, etc.)
- [ ] Credentials and secrets (API keys, OAuth clients, etc.)
- [ ] Any required tooling or CLIs

**Test Data:**
- [ ] Fixtures or test profiles relevant to the domain
- [ ] Any seed data or known-good inputs required by the test environment
- [ ] Certificate fixtures (if testing mTLS or cert validation)

**Dependencies:**
- [ ] Dependent tickets that must be completed first
- [ ] Dependent infrastructure that must exist

**Mocking Strategy:**
- [ ] Can external calls be mocked, or do real systems need to be up?
- [ ] Is a test environment available, or will this be blocked?

Flag any prerequisites that are unresolved as **blockers** in the ticket output.

---

## Automation Impact

Classify the automation effort required — do not estimate hours. For hour estimates, load [EFFORT_ESTIMATION.md](./EFFORT_ESTIMATION.md).

| Level | Meaning |
|---|---|
| **None** | Existing coverage is sufficient. No new automation needed. |
| **Low** | Small additions to existing test files or fixtures. |
| **Medium** | New test scenarios required — new file or new test class. |
| **High** | Significant automation effort or framework work required (new fixture types, new helpers, new conftest patterns). |

---

## Ticket Output Format

```
PROJ-1234 — Example Story

QA Recommendation:    ✅ Integration Test Required
QA Ownership:         Integration Coverage Required
QA Readiness:         🟡 Amber

Scores:
  Requirements Clarity:    4/5
  Acceptance Criteria:     3/5
  Testability:             4/5
  Automation Readiness:    4/5
  Observability:           2/5
  QA Confidence:           3/5

Key Concerns:
  - Error handling not defined
  - Logging requirements missing
  - Edge cases not documented

Questions for Refinement:
  - What should happen when validation fails?
  - Should audit logs be generated?
  - Are retries expected?

Observability Review:
  Logging Required:       Yes
  Metrics Required:       No
  Audit Events Required:  Yes
  Coverage Status:        Missing

Testing Prerequisites:
  - [ ] Test environment access confirmed
  - [ ] AWS credentials available in CI
  - [ ] Dependent ticket must complete first (reference any known blocked dependencies)

Automation Impact:    Medium

Suggested Coverage:
  - Validate successful workflow
  - Validate failure scenarios
  - Validate service interaction behaviour
```

---

## Sprint / Queue Summary

After all tickets are analysed, provide:

### Refinement Summary

```
Tickets Reviewed:          X
Ready For Development:     X
Needs Clarification:       X
Not Ready For Development: X
```

### QA Action Summary

```
No QA Action Required:    X
Manual Verification Only: X
Integration Coverage:     X
E2E Coverage:             X
```

### Highest Priority Refinement Items

List tickets requiring immediate discussion before the sprint can proceed.

### Common Requirement Gaps

Identify recurring issues across the sprint. Examples:
- Missing negative scenarios
- Missing observability requirements
- Missing error handling definitions
- Missing acceptance criteria
- Missing automation strategy

---

## Important Guidance

Do not assume every ticket requires QA automation. It is acceptable — and encouraged — to recommend **"✅ No QA Action Required"** when:

- Developer-owned unit tests provide sufficient coverage
- The change is internal only with no customer-facing behaviour changes
- Existing integration / E2E coverage is unaffected

Avoid recommending automation that provides little value or increases maintenance burden.

Focus on **risk, coverage gaps, and refinement quality** rather than maximising test count.

The primary goal is helping the team make good refinement decisions and focus QA effort where it delivers the most value.

---

## Related skills

- `api-tests` — Implement the automated tests identified here
- `confluence-test-plan` — Publish a test plan after refinement
