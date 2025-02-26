import { drizzle } from 'drizzle-orm/better-sqlite3';
import Database from 'better-sqlite3';
import { env } from '$env/dynamic/private';

const client = new Database(env.DATABASE_URL ?? "local.db");
export const db = drizzle(client);
