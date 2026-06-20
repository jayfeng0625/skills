Our CI pipeline has been reporting an intermittent failure in `OrderProcessorTest::test_concurrent_order_deduplication`. The test checks that when two identical orders are submitted simultaneously, only one is persisted — the second should be rejected as a duplicate.

The test passes consistently when run alone locally (`pytest tests/order_processor_test.py::test_concurrent_order_deduplication`), but fails roughly 30% of the time in CI, where the full test suite runs with `-n 4` (parallel workers via pytest-xdist). When it fails, the assertion error is:

```
AssertionError: Expected 1 order in DB, found 2
assert db.count_orders(order_id="ORD-9981") == 1
```

Nobody changed the deduplication logic recently. The failure started appearing about two weeks ago after we upgraded pytest-xdist from 2.5 to 3.2 and switched our test database setup from a module-scoped fixture to a session-scoped fixture to speed up the suite.

Diagnose and fix this. Follow a disciplined loop: build a reliable way to reproduce the failure, minimise to the smallest case that still fails, form ranked falsifiable hypotheses before looking at the fix, instrument to confirm which hypothesis is correct, apply a minimal fix, and write a regression test. Do not skip phases — document what each phase showed.
