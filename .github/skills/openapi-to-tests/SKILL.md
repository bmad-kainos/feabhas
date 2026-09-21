---
name: openapi-to-tests
description: "Generate black-box tests from an OpenAPI/Swagger specification in the project's configured test framework (first-class: Playwright + TypeScript, pytest + Python). Use when: given an OpenAPI spec URL, file, or Confluence page; scaffolding tests for a new API endpoint from its contract alone; generating status code, schema, validation, boundary, and security tests without access to implementation code; ensuring coverage matches the published contract."
argument-hint: "Provide an OpenAPI spec URL, paste the spec content, or give a Confluence page URL/title containing the spec"
---

# OpenAPI to Tests (Black-Box)

## Purpose

Generate a complete black-box test suite from an OpenAPI/Swagger specification.

This skill is intentionally **implementation-agnostic** — it derives every test from the
published API contract only. Tests cover what the API *should* do, not how it is coded. This
is correct for a separate test repository and a lead test engineer working independently of
the implementation team.

## When to Use

- Given an OpenAPI 3.x or Swagger 2.0 spec (URL, file, or Confluence page)
- Scaffolding tests for a new endpoint before or during implementation
- Ensuring your test suite matches the published contract exactly
- Generating regression tests when the spec is updated
- Any request mentioning "spec", "OpenAPI", "Swagger", "contract", "endpoints", "schema tests"

---

## Procedure

### Step 0 — Determine the test framework

Read the **Test framework** field from `.github/copilot-instructions.md` and follow the
matching conventions (same idioms as the `api-tests` skill):

- **Playwright + TypeScript** (or JavaScript) → [../api-tests/references/playwright-ts.md](../api-tests/references/playwright-ts.md)
- **pytest + Python** → [../api-tests/references/pytest.md](../api-tests/references/pytest.md)
- **Anything else, or not set** → ask the user which framework to use, then follow the closest
  bundled conventions.

All generated code MUST follow the loaded conventions. The steps below are framework-neutral.

---

### Step 1 — Obtain the spec

Sources in priority order:

1. **URL provided** — fetch it with the web/fetch tool and parse the YAML/JSON.
2. **Confluence page** — fetch via the Confluence MCP tool, then extract the fenced ` ```yaml ` /
   ` ```json ` block containing `openapi:` or `swagger:`.
3. **Pasted content** — parse directly from the message.
4. **File in repo** — search for `openapi.yaml`, `swagger.yaml`, `*.oas.yaml` in the workspace.

---

### Step 2 — Parse the spec into a test inventory

From the spec, extract for each endpoint: `path`, `method`, `operationId`, `parameters`
(query/path/header, types, required flags, constraints), `requestBody` schema (properties,
required fields, types, enums, min/max), `responses` (each status code + schema), and
`security` schemes.

Build and show the user a test inventory table before writing code:

```
| Test                                      | Endpoint              | Status | Category   |
|-------------------------------------------|-----------------------|--------|------------|
| valid payload returns 200                 | POST /api/v1/orders   | 200    | Happy path |
| response body matches schema              | POST /api/v1/orders   | 200    | Schema     |
| missing required field returns 400        | POST /api/v1/orders   | 400    | Negative   |
| no auth token returns 401                 | POST /api/v1/orders   | 401    | Security   |
| quantity at minimum boundary accepted     | POST /api/v1/orders   | 200    | Boundary   |
| quantity below minimum rejected           | POST /api/v1/orders   | 422    | Boundary   |
```

---

### Step 3 — Generate tests by category

Apply all six categories for every endpoint — do not stop at the happy path. Write each test
using the idioms from the loaded conventions file.

1. **Happy path** — minimal valid payload (required fields only) and a full payload (all
   optional fields) → expect `200`/`201`.
2. **Schema / contract** — validate the response body against the spec's response schema
   (JSON Schema validation, e.g. `jsonschema` in Python or `ajv` in TypeScript).
3. **Negative / validation** — for every `required` field, test its absence (expect `400`/`422`);
   also test wrong types and nulls.
4. **Boundary / equivalence** — for every field with `minimum`, `maximum`, `minLength`,
   `maxLength`, or `enum`, test just-inside and just-outside each edge.
5. **Security** — for every endpoint with a `security` requirement, test missing and invalid
   credentials → expect `401`/`403`.
6. **Content negotiation / headers** — wrong `Content-Type` → `415`; assert the response
   `Content-Type` matches the spec.

For each field/edge, prefer parametrised/data-driven cases (see the conventions file) over
copy-pasted tests.

---

### Step 4 — File placement and naming

Place files per the loaded conventions file's structure, grouped by endpoint concern (one
contract file per resource) and level (integration vs e2e). Extract reusable JSON Schemas to a
shared location so multiple tests can validate against them.

---

### Step 5 — Apply project conventions

- Name tests per the conventions file; one describe/class per endpoint concern.
- Apply a ticket/Zephyr marker only if the project already uses that pattern (check existing tests).
- No hardcoded base URLs — use the framework's base-URL/config mechanism.
- Every non-trivial assertion states expected, received, and (for parametrised cases) the input value.

---

### Step 6 — Keeping tests in sync with the spec

When the spec changes, re-run this skill with the updated spec. The inventory table (Step 2)
makes it easy to diff old vs new:

- New endpoints → new test files
- New required fields → new parametrised rows
- Changed status codes → update assertions
- Removed fields → remove tests (or mark skipped/xfail during transition)

---

## Related skills

- `api-tests` — scaffold tests and shared conventions/fixtures for your framework
- `jira-testing-analysis` — prioritise contract test depth from ticket risk and readiness
