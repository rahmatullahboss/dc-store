import { betterAuth } from "better-auth";
import { drizzleAdapter } from "better-auth/adapters/drizzle";
import { nextCookies } from "better-auth/next-js";
import type { Database } from "@/db";
import * as schema from "@/db/schema";

export function createAuth(db: Database) {
  return betterAuth({
    database: drizzleAdapter(db, {
      provider: "sqlite",
      schema: {
        user: schema.users,
        session: schema.sessions,
        account: schema.accounts,
        verification: schema.verifications,
      },
    }),
    emailAndPassword: {
      enabled: true,
      requireEmailVerification: false, // Set to true in production
    },
    socialProviders: {
      google: {
        clientId: process.env.GOOGLE_CLIENT_ID || "",
        clientSecret: process.env.GOOGLE_CLIENT_SECRET || "",
        enabled: !!(
          process.env.GOOGLE_CLIENT_ID && process.env.GOOGLE_CLIENT_SECRET
        ),
        // Additional client IDs for ID token verification from mobile apps
        // These are from the same Google Cloud project but different OAuth clients
        idTokenClientIds: [
          process.env.GOOGLE_CLIENT_ID || "", // Web client
          process.env.GOOGLE_IOS_CLIENT_ID || "", // iOS client
          process.env.GOOGLE_ANDROID_CLIENT_ID || "", // Android client
        ].filter(Boolean),
      },
    },
    session: {
      expiresIn: 60 * 60 * 24 * 7, // 7 days
      updateAge: 60 * 60 * 24, // 1 day
      cookieCache: {
        enabled: true,
        maxAge: 60 * 5, // 5 minutes
      },
    },
    user: {
      additionalFields: {
        role: {
          type: "string",
          required: false,
          defaultValue: "customer",
          input: false,
        },
        phone: {
          type: "string",
          required: false,
        },
      },
    },
    plugins: [nextCookies()],
    trustedOrigins: [
      process.env.NEXT_PUBLIC_APP_URL || "https://store.digitalcare.site",
    ],
  });
}

export type Auth = ReturnType<typeof createAuth>;
