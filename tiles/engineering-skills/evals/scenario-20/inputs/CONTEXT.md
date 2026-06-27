# Domain Glossary

**Order** — A confirmed request from a Customer to purchase one or more items. An Order transitions through states: `pending`, `confirmed`, `shipped`, `delivered`, `cancelled`. An Order may contain multiple line items but is always owned by exactly one Customer.

**Customer** — An authenticated account holder who places Orders. Distinct from a guest checkout session, which carries no persistent identity. A Customer may have multiple payment methods on file.

**Payment** — A financial transaction that settles the balance of an Order. A Payment is always associated with exactly one Order and one payment method. Payments are authorised at order confirmation and captured at shipment. A Payment is either `authorised`, `captured`, or `voided`.

**Fulfilment** — The physical or digital process of delivering the items in an Order to the Customer. Fulfilment begins when an Order reaches `confirmed` state and ends when the Order reaches `delivered` state. A single Order may have multiple Fulfilment records if items ship separately.
