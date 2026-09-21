"""HTTP contract tests for POST /api/v1/orders — status codes, schema, auth."""


class TestOrdersContract:
    def test_valid_request_returns_201(self, api_client, valid_order):
        response = api_client.post("/api/v1/orders", json=valid_order)
        assert response.status_code == 201, response.text

    def test_missing_customer_id_returns_400(self, api_client, valid_order):
        del valid_order["customer_id"]
        response = api_client.post("/api/v1/orders", json=valid_order)
        assert response.status_code == 400, response.text

    def test_response_has_order_id_and_status(self, api_client, valid_order):
        body = api_client.post("/api/v1/orders", json=valid_order).json()
        assert isinstance(body.get("id"), str)
        assert body.get("status") in {"pending", "confirmed"}

    def test_unauthenticated_request_returns_401(self, api_client, valid_order):
        response = api_client.post(
            "/api/v1/orders", json=valid_order, headers={"Authorization": ""}
        )
        assert response.status_code == 401
