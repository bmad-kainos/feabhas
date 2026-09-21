---
name: test-coverage-gap
description: "Analyse a codebase to identify untested code paths, missing test levels, and coverage gaps. Use when: assessing test coverage before a release; reviewing a new feature for missing tests; identifying which parts of the codebase have no automated tests; producing a coverage gap report for a team or stakeholder. Works without requiring a coverage tool — analysis is based on code structure and test file inventory."
argument-hint: "[Provide a directory path, file, module name, or describe the area to analyse. Optionally paste a coverage report.]"
user-invocable: true
---

# Skill: Test Coverage Gap Analysis

Analyse a codebase to identify untested paths, missing test levels, and coverage gaps. Produces a structured gap report with actionable recommendations.

---

## When to Use

- Assessing test coverage before a release or sprint review
- Reviewing a new feature to check what tests are missing
- Identifying high-risk untested areas
- Producing a coverage gap report for a test manager or lead engineer
- Any request mentioning "coverage gaps", "what's not tested", "missing tests", "coverage analysis"

---

## Procedure

### Step 1 — Scope the analysis

Determine what to analyse:

- If the user provides a specific file, module, or directory → scope to that area
- If no scope is given → analyse the whole codebase, starting from the top-level source directory
- If a coverage report (e.g. pytest `--cov` output, Istanbul JSON) is provided → use it as the primary source

---

### Step 2 — Build the source inventory

Scan the source directory (typically `src/`, `app/`, `lib/`, or similar) and list:

- All modules / files
- Key public functions, classes, and methods per file
- Any notable branches (try/except, if/else chains, conditional imports)

---

### Step 3 — Build the test inventory

Scan the test directory (typically `tests/`, `__tests__/`, `spec/`) and list:

- All test files and what source module they appear to cover
- Test levels present: unit / integration / e2e
- Any obvious naming mismatches between source files and test files

---

### Step 4 — Identify gaps

Cross-reference the two inventories and flag:

| Gap type | Description |
|----------|-------------|
| **No tests** | Source file or module has no corresponding test file |
| **Missing test level** | Integration tests exist but no unit tests (or vice versa) |
| **Untested function** | Public function/method has no test covering it |
| **Untested error path** | Exception handling or error branches with no negative test |
| **Untested boundary** | Numeric or enum field with no boundary/edge case tests |
| **Happy path only** | Tests exist but only cover the success case |

---

### Step 5 — Produce the gap report

Output the following structure:

```
## Test Coverage Gap Report
Generated: <date>
Scope: <directory or module analysed>

---

## Summary

| Metric | Value |
|--------|-------|
| Source files analysed | N |
| Source files with no tests | N |
| Test files found | N |
| Test levels present | Unit / Integration / E2E |
| High-risk gaps identified | N |

---

## Coverage Gaps

### 🔴 High Risk — No Tests

| File / Module | Gap | Recommendation |
|---------------|-----|---------------|
| `src/payments/processor.py` | No test file found | Add unit tests for `process_payment()` and `validate_card()` |
| `src/auth/token.py` | No test file found | Add unit tests for token generation and expiry logic |

### 🟡 Medium Risk — Missing Test Level

| File / Module | Present | Missing | Recommendation |
|---------------|---------|---------|---------------|
| `src/orders/api.py` | Integration | Unit | Add unit tests for validation logic in `validate_order()` |
| `src/notifications/email.py` | Unit | Integration | Add integration test for actual email dispatch path |

### 🟢 Low Risk — Happy Path Only

| File / Module | Gap |
|---------------|-----|
| `src/users/registration.py` | Tests exist but no negative cases for duplicate email or invalid format |

---

## Recommended Next Steps

1. <Highest priority gap — most critical untested code>
2. <Second priority>
3. <Third priority>

---

## Out of Scope

- <Any areas explicitly excluded or not analysed>
```

---

### Step 6 — Optional: use coverage tool output

If a coverage report is provided (pytest-cov, Istanbul, Jacoco, etc.), parse it to identify:

- Files with 0% coverage
- Files below a threshold (ask user for threshold, default 80%)
- Functions listed as not covered

Merge this data with the structural analysis from Steps 2–4 for a more complete picture.

---

## Notes

- Focus analysis on production code — do not flag gaps in test helpers, fixtures, or `conftest.py`
- Prioritise gaps in code that handles: money/billing, auth/security, data persistence, or public APIs
- A missing test file is higher risk than a missing edge case in an otherwise well-tested module
