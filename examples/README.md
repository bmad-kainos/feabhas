# Examples

Worked example test suites showing what the `api-tests` skill produces for each first-class
framework, applied to a small **Orders API** (`POST /api/v1/orders`, `GET /api/v1/orders/{id}`).

- [pytest-api/](./pytest-api/) — pytest + Python
- [playwright-ts-api/](./playwright-ts-api/) — Playwright + TypeScript

Both cover the same scenarios: happy path, schema/contract, negative validation, boundary
values (data-driven), auth, and an end-to-end journey. They mirror the conventions in the
`api-tests` skill's reference files. Nothing here is wired to a real backend — they illustrate
structure and style.
