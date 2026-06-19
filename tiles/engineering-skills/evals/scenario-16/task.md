Produce an architectural map of the PaymentService module. Use the source files and domain glossary provided below — no file reads required.

## Domain Glossary

**Payment** — A financial transaction for a Cart checkout or Order refund. Identified by a transactionId; states: pending, settled, failed.
**PaymentMethod** — The instrument used to make a Payment (card or bank_transfer). Carries an opaque gateway token.
**Order** — A confirmed Cart purchase. Carries a transactionId linking to the Payment.
**Cart** — A collection of line items not yet purchased. Transitions to an Order on checkout.

## Source: inputs/src/payments/PaymentService.ts

```ts
export interface PaymentResult {
  success: boolean;
  transactionId?: string;
  errorCode?: string;
}

export interface PaymentMethod {
  type: 'card' | 'bank_transfer';
  token: string;
}

interface PaymentGateway {
  charge(params: { amount: number; currency: string; method: PaymentMethod }): Promise<PaymentResult>;
  refund(params: { transactionId: string; amount?: number }): Promise<PaymentResult>;
  lookup(transactionId: string): Promise<{ status: 'pending' | 'settled' | 'failed' }>;
}

export class PaymentService {
  constructor(private readonly gateway: PaymentGateway) {}

  async processPayment(amount: number, currency: string, method: PaymentMethod): Promise<PaymentResult> {
    return this.gateway.charge({ amount, currency, method });
  }

  async refundPayment(transactionId: string, amount?: number): Promise<PaymentResult> {
    return this.gateway.refund({ transactionId, amount });
  }

  async getPaymentStatus(transactionId: string): Promise<'pending' | 'settled' | 'failed'> {
    const result = await this.gateway.lookup(transactionId);
    return result.status;
  }
}
```

## Source: inputs/src/cart/CartService.ts

```ts
import { PaymentService, PaymentMethod } from '../payments/PaymentService';

export class CartService {
  constructor(private readonly payments: PaymentService) {}

  async checkout(cart: Cart, method: PaymentMethod): Promise<Order> {
    const total = cart.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const result = await this.payments.processPayment(total, 'USD', method);
    if (!result.success) throw new Error(`Payment failed: ${result.errorCode}`);
    return { id: `order-${Date.now()}`, items: cart.items, transactionId: result.transactionId!, customerId: cart.customerId };
  }
}
```

## Source: inputs/src/orders/OrderService.ts

```ts
import { PaymentService } from '../payments/PaymentService';

export class OrderService {
  constructor(private readonly payments: PaymentService) {}

  async refundOrder(order: Order): Promise<void> {
    if (!order.transactionId) throw new Error('No payment to refund on this order');
    const result = await this.payments.refundPayment(order.transactionId);
    if (!result.success) throw new Error(`Refund failed: ${result.errorCode}`);
    order.status = 'refunded';
  }

  async syncPaymentStatus(order: Order): Promise<void> {
    if (!order.transactionId) return;
    order.paymentStatus = await this.payments.getPaymentStatus(order.transactionId);
  }
}
```

---

Using the source above, produce this exact compact map format:

```
PaymentService — <one-line responsibility>
  exports:  <key public symbols>
  called by:
    inputs/src/cart/CartService.ts — <why it calls in>
    inputs/src/orders/OrderService.ts — <why it calls in>
  depends on:
    <dep name> — <what it provides>
  fits: <architectural layer and role>
```

Rules:
- Under **exports**: list only publicly exported names (PaymentResult, PaymentMethod, PaymentService class and its methods). Do NOT list PaymentGateway — it is a private interface.
- Use domain glossary terms: Payment, PaymentMethod, Order, Cart.
- Name the architectural layer precisely (e.g. "application service layer", not just "service").

End with: "Next: `<file path>` — <one-line reason>"
