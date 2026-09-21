# pytest + Python — API Test Conventions

Concrete conventions for scaffolding REST API tests in pytest. The `api-tests`
skill loads this file when the project's **Test framework** is pytest + Python.

## File structure

```text
tests/
├── conftest.py
├── unit/
│   └── test_<module>.py
├── integration/
│   └── test_<endpoint_concern>.py   # e.g. test_orders_contract.py
└── e2e/
    └── test_<journey>.py
```

## Naming

- Test file: `test_<concern>.py`.
- Test function: `test_<what>_<expected_outcome>` — e.g. `test_missing_field_returns_400`.
- Fixture: `lowercase_snake`. Constant: `UPPER_SNAKE`.

## Standard test file

```python
"""<One-line description of what this file tests.>"""
import pytest


class TestOrdersContract:
    """HTTP contract: status codes, headers, error shapes."""

    def test_valid_request_returns_200(self, api_client, valid_payload):
        response = api_client.post("/api/v1/orders", json=valid_payload)
        assert response.status_code == 200, response.text

    def test_missing_required_field_returns_400(self, api_client, valid_payload):
        del valid_payload["customer_id"]
        response = api_client.post("/api/v1/orders", json=valid_payload)
        assert response.status_code == 400, response.text

    @pytest.mark.parametrize("quantity, expected_status", [
        (0, 400),     # below minimum — rejected
        (1, 200),     # lower boundary — accepted
        (999, 200),   # upper boundary — accepted
        (1000, 400),  # above maximum — rejected
    ])
    def test_quantity_boundary_values(self, api_client, valid_payload, quantity, expected_status):
        valid_payload["quantity"] = quantity
        response = api_client.post("/api/v1/orders", json=valid_payload)
        assert response.status_code == expected_status, (
            f"quantity={quantity} returned {response.status_code}: {response.text}"
        )
```

## Fixtures (conftest.py)

```python
import os
import pytest
import httpx


@pytest.fixture(scope="session")
def api_client():
    base_url = os.environ.get("API_BASE_URL", "http://localhost:8000")
    with httpx.Client(base_url=base_url, timeout=10.0) as client:
        yield client


@pytest.fixture
def valid_payload():
    return {"customer_id": "abc-123", "quantity": 1}
```

- Never instantiate `httpx.Client` inside a test — use the fixture.
- `scope="session"` only for read-only shared resources (clients, loaded data).
- Default (function) scope for anything mutable; spread dicts (`{**BASE, ...}`) instead of mutating shared state.

## Auth

| Auth type | In tests |
| --------- | -------- |
| Bearer    | `Authorization: Bearer <token>` header via fixture |
| API key   | `X-API-Key` header via fixture |
| OAuth2    | session-scoped fixture that fetches a token once |
| mTLS      | pass cert/key to `httpx.Client` in the fixture |
| None      | no setup |

## Optional ticket marker

Only if the project already uses it (check existing tests):

```python
@pytest.mark.integration
@pytest.mark.jira('<TICKET_KEY>')
def test_example(...):
    ...
```

## Parametrisation style

- Comment every row; use `ids=` when values aren't self-describing.
- Cover min boundary, max boundary, a valid mid value, and an invalid value.

## Assertions

Non-trivial assertions carry a message with expected, received, and the parametrised value(s).

## What NOT to do

- No `time.sleep()`.
- No hardcoded base URLs — use the `api_client` fixture.
- No shared mutable state between tests.
- No order-dependent tests.
- No `print()` (use `pytest -s` when debugging); no secrets in test files.
</invoke>
