Use grill-with-docs to stress-test the following design proposal before we adopt it.

## Design proposal: Refund and Dispute flow

We want to add a refund flow to the platform. When a customer disputes a charge, we process a refund through the payment gateway and update the order status. The refund should be partial or full. If the dispute is resolved in the customer's favour, the refund is issued automatically; otherwise the dispute is closed with no refund. We also want to record why each refund happened so support can see the history.

Start by loading CONTEXT.md (it is in the inputs/ directory provided with this scenario — treat it as the repo's domain glossary at the repo root). Then grill the proposal: challenge any terminology that conflicts with or extends the glossary, walk each branch of the decision tree one question at a time, and write new glossary entries back to CONTEXT.md as terms are resolved. Offer an ADR only when a decision is hard to reverse, surprising without context, and the result of a real trade-off.
