from .database import Database


class OrderProcessor:
    def __init__(self, db: Database) -> None:
        self.db = db

    def submit(self, order_id: str, amount: float) -> dict:
        """Submit an order. Returns {status: created|duplicate, order_id: str}."""
        existing = self.db.find_order(order_id)
        if existing:
            return {"status": "duplicate", "order_id": order_id}

        self.db.insert_order(order_id=order_id, amount=amount)
        return {"status": "created", "order_id": order_id}
