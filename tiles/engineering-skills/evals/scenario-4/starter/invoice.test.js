const {
  calculateLineTotal,
  calculateInvoiceSubtotal,
  calculateTax,
  calculateInvoiceTotal,
  formatCurrency,
  formatInvoiceSummary,
  applyLateFee,
} = require('./invoice');

test('line item total is quantity times price', () => {
  expect(calculateLineTotal(2, 50, 0)).toBe(100);
});

test('line item total applies percentage discount', () => {
  expect(calculateLineTotal(2, 100, 10)).toBe(180);
});

test('invoice subtotal sums all line items', () => {
  const items = [
    { quantity: 1, unitPrice: 100, discountPercent: 0 },
    { quantity: 2, unitPrice: 50, discountPercent: 0 },
  ];
  expect(calculateInvoiceSubtotal(items)).toBe(200);
});

test('invoice subtotal applies line-item discounts', () => {
  const items = [
    { quantity: 1, unitPrice: 200, discountPercent: 50 },
  ];
  expect(calculateInvoiceSubtotal(items)).toBe(100);
});

test('tax is calculated as percentage of subtotal', () => {
  expect(calculateTax(200, 10)).toBe(20);
});

test('invoice total equals subtotal plus tax', () => {
  const items = [{ quantity: 1, unitPrice: 100, discountPercent: 0 }];
  expect(calculateInvoiceTotal(items, 10)).toBe(110);
});

test('USD amounts are formatted with dollar sign', () => {
  expect(formatCurrency(1234.5, 'USD')).toBe('$1234.50');
});

test('EUR amounts are formatted with euro sign', () => {
  expect(formatCurrency(99.9, 'EUR')).toBe('€99.90');
});

test('summary includes formatted subtotal, tax, and total', () => {
  const invoice = {
    lineItems: [{ quantity: 1, unitPrice: 100, discountPercent: 0 }],
    taxRatePercent: 10,
    currencyCode: 'USD',
  };
  const summary = formatInvoiceSummary(invoice);
  expect(summary.subtotalFormatted).toBe('$100.00');
  expect(summary.taxFormatted).toBe('$10.00');
  expect(summary.totalFormatted).toBe('$110.00');
});

test('overdue invoice includes late fee of at least $25', () => {
  const invoice = {
    lineItems: [{ quantity: 1, unitPrice: 100, discountPercent: 0 }],
    taxRatePercent: 0,
  };
  const result = applyLateFee(invoice, 5);
  expect(result.lateFee).toBe(25);
});

test('on-time invoice has no late fee', () => {
  const invoice = {
    lineItems: [{ quantity: 1, unitPrice: 100, discountPercent: 0 }],
    taxRatePercent: 0,
  };
  const result = applyLateFee(invoice, 0);
  expect(result.lateFee).toBe(0);
  expect(result.amountDue).toBe(100);
});
