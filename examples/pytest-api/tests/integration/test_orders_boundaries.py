"""Boundary / equivalence tests for the quantity field (spec: 1..999)."""
import pytest


@pytest.mark.parametrize(
    "quantity, expected_status",
    [
        (0, 400),     # below minimum — rejected
        (1, 201),     # lower boundary — accepted
        (999, 201),   # upper boundary — accepted
        (1000, 400),  # above maximum — rejected
    ],
    ids=["below_min", "at_min", "at_max", "above_max"],
)
def test_quantity_boundaries(api_client, valid_order, quantity, expected_status):
    payload = {**valid_order, "quantity": quantity}
    response = api_client.post("/api/v1/orders", json=payload)
    assert response.status_code == expected_status, (
        f"quantity={quantity} returned {response.status_code}: {response.text}"
    )
