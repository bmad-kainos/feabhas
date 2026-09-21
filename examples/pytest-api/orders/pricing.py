def line_total(unit_price_pence: int, quantity: int) -> int:
    """Total for an order line, in pence. Raises ValueError for a non-positive quantity."""
    if quantity <= 0:
        raise ValueError("quantity must be positive")
    return unit_price_pence * quantity
