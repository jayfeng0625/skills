# Domain Glossary

The canonical vocabulary for this billing service. Use these terms exactly; do not substitute generic synonyms.

- **Subscriber** — a customer who holds at least one active **Plan**. "Customer" and "user" are not used in this domain; the billable entity is always a Subscriber.

- **Plan** — a named tier (e.g. `starter`, `pro`) that defines a price and the set of **Entitlements** it grants.

- **Entitlement** — a single capability a Subscriber's Plan grants (e.g. `export-csv`, `seat:unlimited`). What the product calls "premium features" are modelled as Entitlements. Whether a Subscriber has an Entitlement is always *resolved*, never assumed from a Plan's name.

- **Dunning** — the scheduled sequence of retries and Subscriber notifications that runs after a charge fails. "Retrying a failed payment" is Dunning. A Subscriber whose Dunning sequence exhausts without a successful charge is **delinquent**, and their Entitlements are revoked.

- **Grant / Revoke** — the two operations that change which Entitlements a Subscriber holds. A successful charge may **grant**; an exhausted Dunning sequence **revokes**.
