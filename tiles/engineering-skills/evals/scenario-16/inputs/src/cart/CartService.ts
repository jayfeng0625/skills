import { PaymentService, PaymentMethod } from '../payments/PaymentService';

interface CartItem { productId: string; price: number; quantity: number; }
interface Cart { id: string; items: CartItem[]; customerId: string; }
interface Order { id: string; items: CartItem[]; transactionId: string; customerId: string; }

export class CartService {
  constructor(private readonly payments: PaymentService) {}

  async checkout(cart: Cart, method: PaymentMethod): Promise<Order> {
    const total = cart.items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    const result = await this.payments.processPayment(total, 'USD', method);
    if (!result.success) throw new Error(`Payment failed: ${result.errorCode}`);
    return {
      id: `order-${Date.now()}`,
      items: cart.items,
      transactionId: result.transactionId!,
      customerId: cart.customerId,
    };
  }
}
