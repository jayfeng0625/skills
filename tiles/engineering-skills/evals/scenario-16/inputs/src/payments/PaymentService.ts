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

  async processPayment(
    amount: number,
    currency: string,
    method: PaymentMethod,
  ): Promise<PaymentResult> {
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
