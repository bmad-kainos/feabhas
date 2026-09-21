---
name: api-tests
description: "Scaffold unit, integration, and e2e tests for any REST API in the project's configured test framework (first-class: Playwright + TypeScript, pytest + Python). Use when: writing tests for a new or existing endpoint; generating tests from an OpenAPI spec, ticket description, or plain English description of behaviour; covering status codes, schema validation, boundary values, negative cases, and auth. Reads the Test framework from .github/copilot-instructions.md and follows the matching conventions."
argument-hint: "Describe what you want to test — provide an endpoint URL/path, a brief description of the API behaviour, an OpenAPI spec, or a ticket key/description"
---

# API Tests — REST API Test Scaffold

## Purpose

Scaffold well-structured, maintainable test files for any REST API, in whichever
test framework the project uses.

Covers three levels:
- **Unit** — pure logic, no I/O (validators, parsers, mappers, helpers)
- **Integration** — single request/response cycle against a real or mocked endpoint
- **E2E** — multi-step journeys, auth flows, chained calls

All tests follow the conventions for the project's configured framework (see Step 0)
and any patterns already established in the codebase. Before writing code, check for
existing test files to match the fixtures, helpers, and style already in use.

---

## When to Use

- Adding tests for a new endpoint or API version
- Writing tests from an OpenAPI spec (use `openapi-to-tests` for full spec-driven generation)
- Covering boundary/equivalence classes for query params, request body fields, or headers
- Negative and error path tests (4xx, 5xx responses)
- Auth and header validation tests
- Schema/structure assertions on the response body
- Generating tests from a ticket key or AC description
- Any request mentioning "test", "spec", "fixture", "integration", "e2e", or "unit"

---

## Procedure

### Step 0 — Determine the test framework

Read the **Test framework** field from `.github/copilot-instructions.md` and load the
matching conventions:

- **Playwright + TypeScript** (or JavaScript) → load and follow [references/playwright-ts.md](./references/playwright-ts.md)
- **pytest + Python** → load and follow [references/pytest.md](./references/pytest.md)
- **Anything else, or not set** → ask the user which framework to use. If they name a
  framework the pack doesn't bundle, follow the closest bundled conventions and adapt the
  idioms to their framework.

Every code file you generate MUST follow the loaded conventions — file layout, fixtures,
assertions, parametrisation, and auth all come from that file. The remaining steps are
framework-neutral.

---

### Step 1 — Gather context

Before writing tests, collect:

1. **Endpoint** — HTTP method + path (e.g. `POST /api/v1/orders`)
2. **Request schema** — required/optional fields, types, constraints
3. **Response schema** — expected shape for success and error responses
4. **Auth mechanism** — API key, Bearer token, OAuth, mTLS, none
5. **Base URL / environment** — test/staging URL or config value
6. **Existing test patterns** — scan the test root for existing tests and shared setup

If any of the above is missing, ask the user before proceeding.

---

### Step 2 — Determine test levels

Use this decision tree for each scenario:

```
Is it testing a pure function with no HTTP calls? → Unit
Is it testing one request/response cycle? → Integration
Does it involve auth flows, chained calls, or multi-system paths? → E2E
```

When in doubt, prefer integration over e2e for API tests.

---

### Step 3 — Build the test inventory

For each scenario, define a row. Name each test per the loaded conventions file.

| Test | Level | Category | Input | Expected outcome |
|------|-------|----------|-------|-----------------|
| valid request returns 200 | Integration | Happy path | Valid body | 200 + response schema |
| missing required field returns 400 | Integration | Negative | Body missing required field | 400 + error body |
| invalid field type returns 422 | Integration | Negative | Wrong type for a field | 422 |
| unauthenticated request returns 401 | Integration | Auth | No auth header | 401 |
| boundary minimum accepted | Integration | Boundary | Field at minimum allowed value | 200 |
| boundary below minimum rejected | Integration | Boundary | Field one below minimum | 400 |

Cover at minimum: happy path, missing required fields, invalid types, auth failure, and at
least two boundary cases per constrained field.

---

### Step 4 — Scaffold the tests

Create the test files following the loaded conventions file exactly — file location and
naming, imports, fixtures/setup, and assertion style all come from that file. Do not invent
a different structure; match the framework's idioms and the existing codebase.

---

### Step 5 — Auth

Apply the appropriate pattern for the project. The concrete idiom (header, fixture,
config block) is in the loaded conventions file.

| Auth type | Approach |
|-----------|----------|
| Bearer token | Attach `Authorization: Bearer <token>` via shared setup |
| API key | Attach the API-key header via shared setup |
| OAuth2 | Fetch a token once in shared/global setup |
| mTLS | Supply client cert/key to the HTTP client |
| None | No auth setup needed |

Ask the user which auth pattern applies if it is not obvious from existing tests.

---

### Step 6 — Ticket marker (optional)

If the project already tags tests with a ticket key (check existing tests first), apply the
marker per the loaded conventions file. Do not introduce the pattern if it is not already used.

---

### Step 7 — Final checks before presenting output

- [ ] Every test has a clear, behaviour-describing name
- [ ] No test depends on another test's execution order
- [ ] Boundary tests cover min, max, a valid mid value, and an invalid value
- [ ] Error tests assert both status code AND response body structure
- [ ] No hardcoded credentials, tokens, or secrets in test files
- [ ] All shared setup lives in fixtures/config, not inside individual tests

---

## Related skills

- `openapi-to-tests` — generate a full test suite from an OpenAPI/Swagger spec
- `jira-testing-analysis` — assess whether a ticket is ready to test before writing tests
- `create-zephyr-tests` — create Zephyr test issues in Jira for a story's ACs
