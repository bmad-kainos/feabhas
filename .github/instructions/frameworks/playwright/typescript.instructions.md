---
name: Playwright + TypeScript test conventions
description: Best practices for Playwright tests written in TypeScript.
applyTo: "**/*.spec.ts,**/e2e/**/*.ts,**/playwright.config.ts"
---

# Playwright + TypeScript — test conventions

## Locators
- Prefer user-facing, role-based locators: `getByRole`, `getByLabel`, `getByPlaceholder`, `getByText`.
- Avoid CSS/XPath and `nth()` chains — they break on markup changes. Use `getByTestId` only when no accessible handle exists.
- Store locators in variables; do not use the legacy `page.$` / `page.waitForSelector`.

## Waiting & synchronisation
- Never use `page.waitForTimeout()` (a hard sleep). Playwright auto-waits for actionability.
- Use web-first assertions that auto-retry: `await expect(locator).toBeVisible()`, `toHaveText`, `toHaveURL`.
- To wait for a specific condition use `waitForResponse` / `waitForLoadState`, never an arbitrary delay.

## Assertions
- Always `await expect(...)`. Prefer locator assertions over reading a value and then asserting on it.
- Assert on user-visible outcomes, not implementation detail.

## Structure & fixtures
- Group with `test.describe`; make steps readable with `test.step`.
- Share setup via `test.extend` fixtures, not `beforeAll` globals that hold state.
- Every test must run independently and in parallel.
- Authenticate once and reuse a `storageState` file across tests.

## Network
- Mock or stub with `page.route`; assert backend calls with the `request` fixture.

## Config
- Set `baseURL`; enable `trace: 'on-first-retry'` and `retries` in CI.

## Anti-patterns
- No `waitForTimeout`, no CSS/XPath selectors, no shared mutable state, no `console.log` noise, no secrets in specs.
