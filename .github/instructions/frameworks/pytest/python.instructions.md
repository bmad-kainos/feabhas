---
name: pytest + Python test conventions
description: Best practices for pytest test suites in Python.
applyTo: "**/test_*.py,**/*_test.py,**/conftest.py"
---

# pytest + Python — test conventions

## Structure
- Arrange–Act–Assert; one behaviour per test.
- Name tests `test_<what>_<expected_outcome>`; group related cases in a `Test<Thing>` class.

## Fixtures
- Put shared fixtures in `conftest.py`. Use the narrowest scope that is correct; `scope="session"` only for read-only shared resources.
- Never share mutable state between tests; spread dicts (`{**BASE, ...}`) instead of mutating a shared object.

## Parametrisation
- Use `@pytest.mark.parametrize` with `ids=` when values aren't self-describing.
- Cover the min boundary, max boundary, a valid mid value, and an invalid value.

## Assertions
- Non-trivial assertions carry a message stating expected, received, and the parametrised value(s).

## Markers
- Register markers in config; use them to select levels (`unit`, `integration`, `e2e`).

## Anti-patterns
- No `time.sleep()`; no network in unit tests; no order-dependent tests; no `print()` (use `-s`); no secrets in test files.
