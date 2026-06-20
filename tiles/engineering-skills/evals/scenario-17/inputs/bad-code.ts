// OrderProcessor — handles order submission for the e-commerce checkout flow.
// (Names have drifted; see inline comments for what each section actually does.)

interface Order {
  id: string;
  userId: string;
  items: Array<{ productId: string; qty: number; unitPrice: number }>;
  couponCode?: string;
  region: "US" | "EU" | "APAC";
  isWholesale: boolean;
}

interface User {
  id: string;
  email: string;
  loyaltyTier: "bronze" | "silver" | "gold";
}

// -------------------------------------------------------------------
// Problem 1: misleading name — this class also handles pricing, emails,
// and audit logging; it is not merely a "validator".
// -------------------------------------------------------------------
export class OrderValidator {
  private db: any;          // exposed as public-ish through passthrough methods
  private mailer: any;
  private auditLog: any;

  constructor(db: any, mailer: any, auditLog: any) {
    this.db = db;
    this.mailer = mailer;
    this.auditLog = auditLog;
  }

  // -------------------------------------------------------------------
  // Problem 2: shallow interface — callers must know about internal db
  // and call these passthroughs just to do anything useful.
  // -------------------------------------------------------------------
  getDb() { return this.db; }
  getMailer() { return this.mailer; }
  getAuditLog() { return this.auditLog; }

  // -------------------------------------------------------------------
  // Problem 3: one function doing 4 things — validate, price, discount,
  // and persist — with a misleading name ("validate" implies read-only).
  // -------------------------------------------------------------------
  async validateAndSubmit(order: Order, user: User): Promise<{ orderId: string; total: number }> {
    // 1. Validate
    if (!order.items || order.items.length === 0) {
      throw new Error("Order must have at least one item");
    }
    for (const item of order.items) {
      if (item.qty <= 0) throw new Error(`Invalid qty for ${item.productId}`);
      if (item.unitPrice < 0) throw new Error(`Negative price for ${item.productId}`);
    }

    // 2. Calculate base total
    let total = order.items.reduce((sum, i) => sum + i.qty * i.unitPrice, 0);

    // 3. Long conditional chain that could be a strategy/map pattern
    if (order.couponCode === "SAVE10") {
      total = total * 0.9;
    } else if (order.couponCode === "SAVE20") {
      total = total * 0.8;
    } else if (order.couponCode === "FREESHIP") {
      // no-op here, handled below in shipping
    } else if (order.couponCode === "GOLD50" && user.loyaltyTier === "gold") {
      total = total * 0.5;
    } else if (order.couponCode === "SILVER15" && user.loyaltyTier === "silver") {
      total = total * 0.85;
    } else if (order.couponCode && order.couponCode.startsWith("CORP_")) {
      total = total * 0.75;
    }

    // Add regional tax
    if (order.region === "EU") {
      total = total * 1.2;
    } else if (order.region === "APAC") {
      total = total * 1.1;
    } else if (order.region === "US") {
      total = total * 1.08;
    }

    // Add shipping
    if (order.isWholesale) {
      total += 0; // free shipping for wholesale
    } else if (order.couponCode === "FREESHIP") {
      total += 0;
    } else if (total > 100) {
      total += 0; // free shipping over $100
    } else {
      total += 9.99;
    }

    // Wholesale discount (stacks on top of everything)
    if (order.isWholesale) {
      total = total * 0.8;
    }

    // 4. Persist and notify — unrelated to validation, buried in this method
    const record = await this.db.insert("orders", { ...order, total, status: "pending" });
    await this.mailer.send(user.email, "Order confirmed", `Your order ${record.id} total: $${total.toFixed(2)}`);
    await this.auditLog.write({ event: "order.submitted", orderId: record.id, userId: user.id, total });

    return { orderId: record.id, total };
  }

  // -------------------------------------------------------------------
  // Problem 4 (again shallow interface): callers are expected to call
  // getDb() and talk directly to the DB to fetch order status themselves.
  // -------------------------------------------------------------------
  async getOrderStatus(orderId: string): Promise<string> {
    const row = await this.db.findOne("orders", { id: orderId });
    return row ? row.status : "not_found";
  }
}
