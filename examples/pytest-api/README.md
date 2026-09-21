# pytest + Python — Orders API example

A small worked test suite for an Orders API, following the conventions in
[`.github/skills/api-tests/references/pytest.md`](../../.github/skills/api-tests/references/pytest.md).

```text
pytest-api/
├── conftest.py                 # shared fixtures (api_client, valid_order)
├── orders/
│   └── pricing.py              # tiny pure helper under test (unit example)
└── tests/
    ├── unit/test_order_helpers.py
    ├── integration/test_orders_contract.py
    ├── integration/test_orders_boundaries.py
    └── e2e/test_checkout_journey.py
```

Run from this folder: `pytest` (set `API_BASE_URL` for the integration/e2e tests; the unit
tests need no network). Illustrative only — the integration/e2e tests expect a running Orders API.
