import threading
import pytest

from src.order_processor import OrderProcessor


def test_concurrent_order_deduplication(db):
    """
    Two identical orders submitted simultaneously — only one should be persisted.

    Passes consistently when run alone. Fails ~30% of the time with -n 4
    (pytest-xdist parallel workers):
        AssertionError: Expected 1 order in DB, found 2
        assert db.count_orders(order_id="ORD-9981") == 1
    """
    processor = OrderProcessor(db)
    order_id = "ORD-9981"

    results = []

    def submit_order():
        result = processor.submit(order_id=order_id, amount=99.99)
        results.append(result)

    threads = [threading.Thread(target=submit_order) for _ in range(2)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

    assert db.count_orders(order_id=order_id) == 1, (
        f"Expected 1 order in DB, found {db.count_orders(order_id=order_id)}"
    )
