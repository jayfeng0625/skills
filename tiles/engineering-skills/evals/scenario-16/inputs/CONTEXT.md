# Domain Glossary

**Payment** — A financial transaction for a Cart checkout or Order refund. Identified by a transactionId; states: pending, settled, failed.

**PaymentMethod** — The instrument used to make a Payment (card or bank_transfer). Carries an opaque gateway token.

**Order** — A confirmed Cart purchase. Carries a transactionId linking to the Payment.

**Cart** — A collection of line items not yet purchased. Transitions to an Order on checkout.
