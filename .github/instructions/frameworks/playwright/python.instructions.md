---
name: Playwright + Python test conventions
description: Best practices for Playwright tests in Python (pytest-playwright).
applyTo: "**/e2e/**/*.py,**/tests/e2e/**/*.py"
---

# Playwright + Python — test conventions

Uses `pytest-playwright` (the `page` fixture). Also follow the pytest conventions.

## Locators
- Use role-based locators: `page.get_by_role`, `get_by_label`, `get_by_text`.
- Avoid CSS/XPath; use `get_by_test_id` only as a fallback.

## Waiting & synchronisation
- Never `page.wait_for_timeout()`. Rely on auto-waiting.
- Use `from playwright.sync_api import expect` then `expect(locator).to_be_visible()` — it auto-retries.

## Assertions
- Prefer `expect(locator).to_have_text(...)` over manual `assert locator.text_content()`.

## Structure & fixtures
- Use pytest fixtures for setup; keep tests isolated and parallel-safe (`pytest-xdist`).
- Reuse authentication via `storage_state`.

## Network
- Mock with `page.route`; check backend calls with the `request` context.

## Anti-patterns
- No hard waits, no CSS/XPath, no shared mutable state, no secrets in code.
