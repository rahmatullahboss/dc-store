import { drizzle } from "drizzle-orm/d1";
import * as schema from "./schema";

export type Database = ReturnType<typeof createDb>;

export function createDb(d1: D1Database) {
  return drizzle(d1, { schema });
}

// For use in development with local D1
let db: Database | null = null;

export function getDb(d1: D1Database): Database {
  if (!db) {
    db = createDb(d1);
  }
  return db;
}
