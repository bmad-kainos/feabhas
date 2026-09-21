# Playwright + TypeScript — Orders API example

A small worked test suite for an Orders API, following the conventions in
[`.github/skills/api-tests/references/playwright-ts.md`](../../.github/skills/api-tests/references/playwright-ts.md).

```text
playwright-ts-api/
├── playwright.config.ts
└── tests/
    ├── fixtures/payloads.ts
    ├── api/
    │   ├── orders.contract.spec.ts
    │   └── orders.boundaries.spec.ts
    └── e2e/
        └── checkout.journey.spec.ts
```

Run: `npx playwright test` (set `API_BASE_URL` for the target API). Illustrative only — the
tests expect a running Orders API.
