---
name: Jest + TypeScript test conventions
description: Best practices for Jest (and Vitest) unit tests in TypeScript.
applyTo: "**/*.test.ts,**/*.test.tsx,**/__tests__/**/*.ts"
---

# Jest + TypeScript — test conventions

Applies equally to Vitest (same API surface).

## Structure
- Arrange–Act–Assert; group with `describe`, one behaviour per `it`/`test`.
- Name tests as behaviour: `it('rejects a negative quantity')`.

## Assertions
- Use specific matchers: `toEqual` for value equality, `toBe` for identity, `toThrow` for errors.
- For async, `await expect(promise).resolves/rejects...`.

## Mocking
- Mock at boundaries only; avoid over-mocking internal logic.
- Reset between tests: enable `clearMocks`/`restoreMocks` (or `jest.restoreAllMocks()` in `afterEach`).

## Isolation
- No shared mutable state across tests; build fresh data per test with factory functions.
- Avoid broad snapshot tests — assert specific, meaningful output instead.

## Anti-patterns
- No real network/filesystem in unit tests, no order-dependent tests, no leftover `console.log`, no secrets in tests.
