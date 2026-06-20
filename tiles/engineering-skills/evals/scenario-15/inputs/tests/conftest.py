import os
import pytest
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from src.database import Database


@pytest.fixture(scope="session")
def db():
    """Session-scoped fixture: one DB instance shared across all workers and tests."""
    database = Database(":memory:")
    database.create_tables()
    yield database
    database.teardown()
