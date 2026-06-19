// Minimal DB client stub — stands in for the real pg Pool in the eval sandbox.
export const db = {
  query(sql: string, params?: unknown[]): Promise<{ rows: any[] }> {
    throw new Error("db.query not available in eval sandbox — stub only");
  },
};
