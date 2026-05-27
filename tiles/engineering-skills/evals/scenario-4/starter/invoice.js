// Invoice processing module

function calculateLineTotal(quantity, unitPrice, discountPercent) {
  const subtotal = quantity * unitPrice;
  const discount = subtotal * (discountPercent / 100);
  return subtotal - discount;
}

function calculateInvoiceSubtotal(lineItems) {
  let subtotal = 0;
  for (const item of lineItems) {
    subtotal += calculateLineTotal(item.quantity, item.unitPrice, item.discountPercent || 0);
  }
  return subtotal;
}

function calculateTax(subtotal, taxRatePercent) {
  return subtotal * (taxRatePercent / 100);
}

function calculateInvoiceTotal(lineItems, taxRatePercent) {
  const subtotal = calculateInvoiceSubtotal(lineItems);
  const tax = calculateTax(subtotal, taxRatePercent);
  return subtotal + tax;
}

function formatCurrency(amount, currencyCode) {
  if (currencyCode === 'USD') {
    return '$' + amount.toFixed(2);
  } else if (currencyCode === 'EUR') {
    return '€' + amount.toFixed(2);
  } else if (currencyCode === 'GBP') {
    return '£' + amount.toFixed(2);
  } else {
    return amount.toFixed(2) + ' ' + currencyCode;
  }
}

function formatInvoiceSummary(invoice) {
  const subtotal = calculateInvoiceSubtotal(invoice.lineItems);
  const tax = calculateTax(subtotal, invoice.taxRatePercent);
  const total = subtotal + tax;
  const currencyCode = invoice.currencyCode || 'USD';

  return {
    subtotalFormatted: formatCurrency(subtotal, currencyCode),
    taxFormatted: formatCurrency(tax, currencyCode),
    totalFormatted: formatCurrency(total, currencyCode),
    subtotal: subtotal,
    tax: tax,
    total: total,
  };
}

function applyLateFee(invoice, daysOverdue) {
  const lateFeePercent = 0.05;
  const lateFeeMin = 25;
  const subtotal = calculateInvoiceSubtotal(invoice.lineItems);
  const tax = calculateTax(subtotal, invoice.taxRatePercent);
  const baseTotal = subtotal + tax;
  let lateFee = 0;
  if (daysOverdue > 0) {
    lateFee = Math.max(baseTotal * lateFeePercent, lateFeeMin);
  }
  return {
    baseTotal: baseTotal,
    lateFee: lateFee,
    amountDue: baseTotal + lateFee,
  };
}

module.exports = {
  calculateLineTotal,
  calculateInvoiceSubtotal,
  calculateTax,
  calculateInvoiceTotal,
  formatCurrency,
  formatInvoiceSummary,
  applyLateFee,
};
