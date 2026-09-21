"""Unit tests for order pricing helpers — pure logic, no I/O."""
import pytest

from orders.pricing import line_total


class TestLineTotal:
    def test_multiplies_price_by_quantity(self):
        assert line_total(500, 3) == 1500

    @pytest.mark.parametrize("quantity", [0, -1])
    def test_rejects_non_positive_quantity(self, quantity):
        with pytest.raises(ValueError):
            line_total(500, quantity)
