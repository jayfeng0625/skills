import { PaymentService } from '../payments/PaymentService';

interface Order {
  id: string;
  transactionId?: string;
  status: 'active' | 'refunded' | 'cancelled';
  paymentStatus?: 'pending' | 'settled' | 'failed';
}

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
