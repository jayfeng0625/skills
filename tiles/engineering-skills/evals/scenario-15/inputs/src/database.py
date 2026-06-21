import sqlite3


class Database:
    def __init__(self, path: str):
        self.conn = sqlite3.connect(path, check_same_thread=False)

    def create_tables(self) -> None:
        self.conn.execute(
            """
            CREATE TABLE IF NOT EXISTS orders (
                order_id TEXT,
                amount   REAL
            )
        """
        )
        self.conn.commit()

    def find_order(self, order_id: str):
        cursor = self.conn.execute(
            "SELECT order_id, amount FROM orders WHERE order_id = ?", (order_id,)
        )
        return cursor.fetchone()

    def insert_order(self, order_id: str, amount: float) -> None:
        self.conn.execute(
            "INSERT INTO orders (order_id, amount) VALUES (?, ?)",
            (order_id, amount),
        )
        self.conn.commit()

    def count_orders(self, order_id: str) -> int:
        cursor = self.conn.execute(
            "SELECT COUNT(*) FROM orders WHERE order_id = ?", (order_id,)
        )
        return cursor.fetchone()[0]

    def teardown(self) -> None:
        self.conn.execute("DROP TABLE IF EXISTS orders")
        self.conn.commit()
        self.conn.close()
