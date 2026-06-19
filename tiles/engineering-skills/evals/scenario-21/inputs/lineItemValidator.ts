// LineItemValidator — validates LineItem objects before they are written to the Ledger.
// This module IS deep: a small, stable interface hides meaningful validation complexity.
// It should NOT be flagged as a shallow module.

export interface LineItem {
  amount: number; // must be a positive integer (minor units)
  description: string;
  categoryCode: string;
}

export type ValidationResult =
  | { valid: true }
  | { valid: false; errors: string[] };

const VALID_CATEGORY_CODES = new Set([
  "subscription_charge",
  "usage_charge",
  "credit_adjustment",
  "refund",
  "tax",
]);

const MAX_DESCRIPTION_LENGTH = 255;
const MIN_AMOUNT = 1; // at least 1 minor unit
const MAX_AMOUNT = 99_999_999; // $999,999.99 safety ceiling

/**
 * Validates a single LineItem. Returns a typed result — callers never need to
 * know about the individual rules; they only interact with the result shape.
 *
 * Deep because: one method call triggers six distinct validation rules,
 * normalisation of the category code lookup, and aggregation of all errors
 * into a single typed result — none of which the caller manages.
 */
export function validateLineItem(item: unknown): ValidationResult {
  const errors: string[] = [];

  if (typeof item !== "object" || item === null) {
    return { valid: false, errors: ["LineItem must be a non-null object"] };
  }

  const candidate = item as Record<string, unknown>;

  // Amount: must be a positive safe integer within bounds
  if (typeof candidate.amount !== "number") {
    errors.push("amount must be a number");
  } else if (!Number.isInteger(candidate.amount)) {
    errors.push("amount must be an integer (minor units)");
  } else if (candidate.amount < MIN_AMOUNT) {
    errors.push(`amount must be at least ${MIN_AMOUNT} minor unit`);
  } else if (candidate.amount > MAX_AMOUNT) {
    errors.push(`amount must not exceed ${MAX_AMOUNT} minor units`);
  }

  // Description: non-empty string within length limit
  if (typeof candidate.description !== "string") {
    errors.push("description must be a string");
  } else if (candidate.description.trim().length === 0) {
    errors.push("description must not be blank");
  } else if (candidate.description.length > MAX_DESCRIPTION_LENGTH) {
    errors.push(`description must not exceed ${MAX_DESCRIPTION_LENGTH} characters`);
  }

  // Category code: must be one of the known values
  if (typeof candidate.categoryCode !== "string") {
    errors.push("categoryCode must be a string");
  } else if (!VALID_CATEGORY_CODES.has(candidate.categoryCode)) {
    errors.push(
      `categoryCode must be one of: ${[...VALID_CATEGORY_CODES].join(", ")}`
    );
  }

  return errors.length === 0 ? { valid: true } : { valid: false, errors };
}
