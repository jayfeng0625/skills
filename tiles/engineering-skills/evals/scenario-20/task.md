Use grill-with-docs to analyse this design proposal. Run the session autonomously — for each question you raise, provide your own recommended answer based on the existing glossary and design constraints, accept it, and immediately proceed to the next question. Do not pause for user input at any point. Write new glossary entries to CONTEXT.md and create qualifying ADRs inline as decisions crystallise.

Design proposal:

We want to add a refund flow to the payment system. When a customer disputes a charge, we process a refund through the payment gateway and update the order status. The refund should be traceable back to the original order and the customer should be notified.

The existing glossary (CONTEXT.md) defines: Order, Customer, Payment, Fulfilment.
