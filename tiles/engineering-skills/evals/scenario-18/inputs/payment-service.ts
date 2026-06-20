// payment-service.ts
// Shared payment processing module used by checkout and subscription flows.

<<<<<<< HEAD
// Branch: add-stripe-error-handling
// Added structured error handling so callers can distinguish retryable
// network failures from hard declines, and wrapped the return in a
// PaymentResult type so callers never see raw Stripe objects.

export interface PaymentResult {
  success: boolean;
  chargeId: string;
  errorCode?: "network_failure" | "card_declined" | "insufficient_funds";
  retryable: boolean;
}

export async function chargeCard(
  customerId: string,
  amountCents: number,
  currency: string,
): Promise<PaymentResult> {
  try {
    const charge = await stripe.charges.create({
      customer: customerId,
      amount: amountCents,
      currency,
    });
    return { success: true, chargeId: charge.id, retryable: false };
  } catch (err: any) {
    const code = err.code as string;
    if (code === "network_error" || code === "api_connection_error") {
      return { success: false, chargeId: "", errorCode: "network_failure", retryable: true };
    }
    if (code === "insufficient_funds") {
      return { success: false, chargeId: "", errorCode: "insufficient_funds", retryable: false };
    }
    return { success: false, chargeId: "", errorCode: "card_declined", retryable: false };
  }
}
=======
// Branch: support-multi-currency
// Extended chargeCard to accept an explicit currency and return the
// settled amount in that currency (Stripe returns the settled amount
// which may differ from the requested amount for FX conversions).
// Also changed the return type from Promise<string> (just the chargeId)
// to a richer object so callers can record the settled amount.

export interface ChargeReceipt {
  chargeId: string;
  settledAmountCents: number;
  currency: string;
}

export async function chargeCard(
  customerId: string,
  amountCents: number,
  currency: string,
): Promise<ChargeReceipt> {
  const charge = await stripe.charges.create({
    customer: customerId,
    amount: amountCents,
    currency,
  });
  return {
    chargeId: charge.id,
    settledAmountCents: charge.amount_captured,
    currency: charge.currency,
  };
}
>>>>>>> support-multi-currency
