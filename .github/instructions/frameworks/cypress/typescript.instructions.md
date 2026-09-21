---
name: Cypress + TypeScript test conventions
description: Best practices for Cypress end-to-end tests in TypeScript.
applyTo: "**/*.cy.ts,**/cypress/**/*.ts,**/cypress.config.ts"
---

# Cypress + TypeScript — test conventions

## Locators
- Prefer `data-cy` attributes (`cy.get('[data-cy=submit]')`) or `@testing-library/cypress` role queries.
- Avoid brittle CSS/XPath tied to styling or DOM structure.

## Retry-ability & waiting
- Cypress commands auto-retry — never use `cy.wait(<number>)` hard waits.
- To wait for a request, alias it with `cy.intercept` and `cy.wait('@alias')`.
- Do not assign command return values; use `.then()` or aliases (`.as('user')`).

## Assertions
- Use built-in retrying assertions: `.should('be.visible')`, `.should('have.text', ...)`.

## Structure & isolation
- Reset state in `beforeEach`; keep tests independent (Cypress enforces test isolation by default).
- Load data with `cy.fixture`; seed via API (`cy.request`) rather than the UI.

## Anti-patterns
- No `cy.wait(number)`, no `async/await` mixed into command chains, no shared state between tests, no secrets in specs.
