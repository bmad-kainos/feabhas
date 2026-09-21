---
name: Playwright + JavaScript test conventions
description: Best practices for Playwright tests written in JavaScript.
applyTo: "**/*.spec.js,**/e2e/**/*.js,**/playwright.config.js"
---

# Playwright + JavaScript — test conventions

Same engine and APIs as Playwright + TypeScript, without static types.

## Locators
- Prefer role-based locators: `getByRole`, `getByLabel`, `getByPlaceholder`, `getByText`.
- Avoid CSS/XPath and `nth()`; use `getByTestId` only as a fallback.

## Waiting & synchronisation
- Never `page.waitForTimeout()`. Rely on auto-waiting and web-first assertions.
- Use `await expect(locator).toBeVisible()` / `toHaveText` — they auto-retry.
- Wait for real signals (`waitForResponse`, `waitForLoadState`), not delays.

## Assertions
- Always `await expect(...)`; assert on user-visible outcomes.

## Structure & fixtures
- Group with `test.describe`; use `test.step` for readable steps.
- Share setup with `test.extend`; keep each test isolated and parallel-safe.
- Reuse auth via a `storageState` file.

## Network
- Mock with `page.route`; assert APIs with the `request` fixture.

## Anti-patterns
- No hard waits, no CSS/XPath, no shared mutable state, no `console.log` noise, no secrets in specs.
