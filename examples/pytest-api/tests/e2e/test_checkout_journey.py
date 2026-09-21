"""End-to-end: create an order, then retrieve it."""
import pytest


@pytest.mark.e2e
def test_create_then_fetch_order(api_client, valid_order):
    created = api_client.post("/api/v1/orders", json=valid_order)
    assert created.status_code == 201, created.text
    order_id = created.json()["id"]

    fetched = api_client.get(f"/api/v1/orders/{order_id}")
    assert fetched.status_code == 200
    assert fetched.json()["id"] == order_id
