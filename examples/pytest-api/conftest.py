import os

import httpx
import pytest


@pytest.fixture(scope="session")
def api_client():
    base_url = os.environ.get("API_BASE_URL", "http://localhost:8000")
    with httpx.Client(base_url=base_url, timeout=10.0) as client:
        yield client


@pytest.fixture
def valid_order():
    return {"customer_id": "cust-123", "quantity": 1, "currency": "GBP"}
