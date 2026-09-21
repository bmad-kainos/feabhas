---
name: create-zephyr-tests
description: "Generate and create a single Zephyr Test issue per Jira story, with all ACs as structured test steps inside it, then link it back to the parent Story and post a testing progress comment. Use when: a story is In Test and needs test cases creating; starting test design for a new ticket; scaffolding Zephyr tests before writing automated test code. Trigger phrases: 'create test cases for PROJ-XXXX', 'create Zephyr tests', 'add test cases to ticket', 'scaffold tests for story'."
argument-hint: "Provide a Jira story key (e.g. PROJ-123) and I will create one Zephyr Test issue covering all ACs as steps, link it to the story, and post a testing progress comment"
---

# Create Zephyr Test Issues from Jira Story

## Purpose

Given one or more Jira story keys, automatically:
1. Fetch the story's Acceptance Criteria and Testing Notes
2. Create **one** Zephyr `Test` issue per story, with all ACs as structured test steps inside it
3. Link the Test back to the parent Story ("is a test for" / "is tested by")
4. Post a testing progress comment on the Story

This approach conserves Jira issue numbers (Jira Server has a ~10,000 issue hard limit per project) while maintaining full AC traceability through Zephyr's step structure.

> **Why one Test per Story?**
> Creating one Test issue per AC burns through the issue counter quickly on Jira Server. One Test per Story with per-AC steps gives the same traceability at a fraction of the issue count.

## Choose a creation method

| Method | When to use |
|--------|------------|
| **Excel import** (preferred) | One or more stories at once; ZAPI auth is unavailable; faster and requires no password |
| **ZAPI script** | Single story with rich manually-crafted step content; ZAPI credentials available |

Determine which method applies from the user's context or available credentials.

- If using the Excel method, load and follow [method-excel.md](./method-excel.md)
- If using the ZAPI method, load and follow [method-zapi.md](./method-zapi.md)

If an error is encountered during either method, load [error-handling.md](./error-handling.md) for the error reference table and environment requirements.

---

## When to Use

- A story has been moved to "In Test" and needs test cases
- Starting test design for a sprint ticket
- Any request mentioning "create test cases", "add tests to Jira", "Zephyr tests for", "scaffold test issues"

---

## Related skills

- `api-tests` — Scaffold the automated test file and link test markers back to Zephyr
- `jira-testing-analysis` — Analyse whether a story is ready for test before creating test cases
