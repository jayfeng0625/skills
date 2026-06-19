// WorkspaceRepository — data access for workspace records.
// This module is intentionally SHALLOW: its interface is nearly as complex
// as each implementation detail it wraps.

import { db } from "./db";

export interface Workspace {
  id: string;
  stripeCustomerId: string;
  name: string;
  plan: string;
  trialEndsAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

// Eight individual methods — each is a thin wrapper around a single DB call.
// Callers must know and call all relevant methods themselves.

export function findWorkspaceById(id: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE id = $1", [id]).then((r) => r.rows[0] ?? null);
}

export function findWorkspaceByStripeCustomerId(
  stripeCustomerId: string
): Promise<Workspace | null> {
  return db
    .query("SELECT * FROM workspaces WHERE stripe_customer_id = $1", [stripeCustomerId])
    .then((r) => r.rows[0] ?? null);
}

export function findWorkspaceByName(name: string): Promise<Workspace | null> {
  return db
    .query("SELECT * FROM workspaces WHERE name = $1", [name])
    .then((r) => r.rows[0] ?? null);
}

export function createWorkspace(
  name: string,
  stripeCustomerId: string,
  plan: string
): Promise<Workspace> {
  return db
    .query(
      "INSERT INTO workspaces (name, stripe_customer_id, plan) VALUES ($1, $2, $3) RETURNING *",
      [name, stripeCustomerId, plan]
    )
    .then((r) => r.rows[0]);
}

export function updateWorkspacePlan(id: string, plan: string): Promise<Workspace> {
  return db
    .query("UPDATE workspaces SET plan = $1, updated_at = NOW() WHERE id = $2 RETURNING *", [
      plan,
      id,
    ])
    .then((r) => r.rows[0]);
}

export function updateWorkspaceName(id: string, name: string): Promise<Workspace> {
  return db
    .query("UPDATE workspaces SET name = $1, updated_at = NOW() WHERE id = $2 RETURNING *", [
      name,
      id,
    ])
    .then((r) => r.rows[0]);
}

export function updateWorkspaceTrialEndsAt(
  id: string,
  trialEndsAt: Date | null
): Promise<Workspace> {
  return db
    .query(
      "UPDATE workspaces SET trial_ends_at = $1, updated_at = NOW() WHERE id = $2 RETURNING *",
      [trialEndsAt, id]
    )
    .then((r) => r.rows[0]);
}

export function deleteWorkspace(id: string): Promise<void> {
  return db.query("DELETE FROM workspaces WHERE id = $1", [id]).then(() => undefined);
}
