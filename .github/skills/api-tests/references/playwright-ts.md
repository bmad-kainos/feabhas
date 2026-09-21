# Playwright + TypeScript — API Test Conventions

Concrete conventions for scaffolding REST API tests with Playwright Test in
TypeScript. The `api-tests` skill loads this file when the project's **Test
framework** is Playwright + TypeScript (or JavaScript — drop the type
annotations). Playwright's `request` fixture (`APIRequestContext`) is used for
API testing — no browser is launched.

## File structure

```text
tests/
├── api/
│   ├── orders.contract.spec.ts   # status codes, headers, error shapes
│   └── orders.schema.spec.ts     # response body assertions
├── e2e/
│   └── checkout.journey.spec.ts  # multi-step journeys
└── fixtures/
    └── payloads.ts               # reusable request bodies
playwright.config.ts              # baseURL, projects, reporters
```

## Naming

- Spec file: `<concern>.spec.ts` — e.g. `orders.contract.spec.ts`.
- Test title: describe behaviour and outcome — e.g. `rejects a missing required field with 400`.
- Reuse payload factories from `tests/fixtures/` rather than inlining bodies.

## Standard spec file

```typescript
import { test, expect } from '@playwright/test';
import { validOrder } from '../fixtures/payloads';

test.describe('POST /api/v1/orders — contract', () => {
  test('valid request returns 200', async ({ request }) => {
    const response = await request.post('/api/v1/orders', { data: validOrder() });
    expect(response.status()).toBe(200);
  });

  test('missing required field returns 400', async ({ request }) => {
    const { customerId, ...body } = validOrder();
    const response = await request.post('/api/v1/orders', { data: body });
    expect(response.status()).toBe(400);
  });

  for (const { quantity, expected } of [
    { quantity: 0, expected: 400 },     // below minimum — rejected
    { quantity: 1, expected: 200 },     // lower boundary — accepted
    { quantity: 999, expected: 200 },   // upper boundary — accepted
    { quantity: 1000, expected: 400 },  // above maximum — rejected
  ]) {
    test(`quantity=${quantity} -> ${expected}`, async ({ request }) => {
      const response = await request.post('/api/v1/orders', {
        data: { ...validOrder(), quantity },
      });
      expect(response.status(), await response.text()).toBe(expected);
    });
  }
});
```

## Base URL & config (playwright.config.ts)

```typescript
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  use: {
    baseURL: process.env.API_BASE_URL ?? 'http://localhost:8000',
    extraHTTPHeaders: { Accept: 'application/json' },
  },
  reporter: [['list'], ['html', { open: 'never' }]],
});
```

## Reusable payloads (tests/fixtures/payloads.ts)

```typescript
export const validOrder = () => ({ customerId: 'abc-123', quantity: 1 });
```

- Return a fresh object from a factory so tests never share mutable state.
- For shared setup, use `test.extend` to create custom fixtures rather than `beforeAll` globals.

## Auth

| Auth type | In tests |
| --------- | -------- |
| Bearer    | set an `Authorization: Bearer <token>` header via `extraHTTPHeaders` in config or per request |
| API key   | `extraHTTPHeaders: { 'X-API-Key': process.env.API_KEY }` |
| OAuth2    | `globalSetup` that fetches a token once and stores it |
| mTLS      | `clientCertificates` in the config `use` block |
| None      | no setup |

## Schema assertions

```typescript
const body = await response.json();
expect(body).toMatchObject({ id: expect.any(String), status: expect.any(String) });
```

For strict contracts, validate against the OpenAPI schema (e.g. with `ajv`) rather than field-by-field.

## Parametrisation style

- Drive cases with a `for...of` over a typed array of `{ input, expected }` objects.
- Comment every row; cover min boundary, max boundary, a valid mid value, and an invalid value.

## What NOT to do

- No `waitForTimeout()` / sleeps.
- No hardcoded base URLs — use `baseURL`.
- No shared mutable payloads — use factories.
- No order-dependent tests.
- No `console.log` noise; no secrets in specs (use env vars).
