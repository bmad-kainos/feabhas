---
name: <Tool> + <Language> test conventions
description: Best practices for <tool> tests written in <language>.
applyTo: "<comma-separated globs for this stack's test files>"
---

# <Tool> + <Language> — test conventions

## Locators / selectors
- <how to find elements/resources robustly; what to avoid>

## Waiting & synchronisation
- <auto-waiting vs hard waits; the no-sleep rule>

## Assertions
- <preferred assertion style; auto-retrying assertions if available>

## Structure & fixtures
- <test grouping, setup/teardown, isolation, parallelism>

## Test data
- <factories/builders; no shared mutable state>

## Anti-patterns
- <the short list of things never to do in this stack>
