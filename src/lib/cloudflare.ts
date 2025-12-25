import { getCloudflareContext } from "@opennextjs/cloudflare";
import { createDb, type Database } from "@/db";
import { createAuth, type Auth } from "@/lib/auth";

let cachedDb: Database | null = null;
let cachedAuth: Auth | null = null;

export async function getEnv() {
  // Use async mode for ISR/static page compatibility
  const { env } = await getCloudflareContext({ async: true });
  return env as CloudflareEnv;
}

export async function getDatabase(): Promise<Database> {
  if (cachedDb) return cachedDb;

  const env = await getEnv();
  cachedDb = createDb(env.DB);
  return cachedDb;
}

export async function getAuth(): Promise<Auth> {
  if (cachedAuth) return cachedAuth;

  const db = await getDatabase();
  cachedAuth = createAuth(db);
  return cachedAuth;
}

// Reset cache (useful for testing)
export function resetCache() {
  cachedDb = null;
  cachedAuth = null;
}

