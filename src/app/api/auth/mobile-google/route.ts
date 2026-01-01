import { NextRequest, NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { users, accounts, sessions } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { nanoid } from "nanoid";

// CORS headers for mobile app access
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

// Google's token verification endpoint
const GOOGLE_TOKEN_INFO_URL = "https://oauth2.googleapis.com/tokeninfo";

// All valid Google OAuth client IDs for this project
const VALID_CLIENT_IDS = [
  process.env.GOOGLE_CLIENT_ID,
  process.env.GOOGLE_IOS_CLIENT_ID,
  process.env.GOOGLE_ANDROID_CLIENT_ID,
].filter(Boolean) as string[];

interface GoogleTokenInfo {
  iss: string;
  azp: string;
  aud: string;
  sub: string;
  email: string;
  email_verified: string;
  name?: string;
  picture?: string;
  given_name?: string;
  family_name?: string;
  exp: string;
}

interface RequestBody {
  idToken?: string;
}

export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

/**
 * Custom Google ID Token Sign-In Endpoint for Mobile Apps
 * This endpoint validates Google ID tokens from iOS/Android apps
 * and creates/updates user sessions in Better Auth compatible format
 */
export async function POST(request: NextRequest) {
  try {
    const body = (await request.json()) as RequestBody;
    const { idToken } = body;

    if (!idToken) {
      return NextResponse.json(
        { error: "Missing idToken" },
        { status: 400, headers: corsHeaders }
      );
    }

    // Verify the ID token with Google
    const tokenInfoResponse = await fetch(
      `${GOOGLE_TOKEN_INFO_URL}?id_token=${idToken}`
    );

    if (!tokenInfoResponse.ok) {
      console.error(
        "Google token verification failed:",
        tokenInfoResponse.status
      );
      return NextResponse.json(
        { error: "Invalid ID token" },
        { status: 401, headers: corsHeaders }
      );
    }

    const tokenInfo: GoogleTokenInfo = await tokenInfoResponse.json();

    // Verify the token is for our application
    if (!VALID_CLIENT_IDS.includes(tokenInfo.aud)) {
      console.error("Token audience mismatch:", tokenInfo.aud);
      console.error("Valid client IDs:", VALID_CLIENT_IDS);
      return NextResponse.json(
        { error: "Token not issued for this application" },
        { status: 401, headers: corsHeaders }
      );
    }

    // Verify issuer
    if (
      !["accounts.google.com", "https://accounts.google.com"].includes(
        tokenInfo.iss
      )
    ) {
      return NextResponse.json(
        { error: "Invalid token issuer" },
        { status: 401, headers: corsHeaders }
      );
    }

    // Token is valid - now create or get user
    const db = await getDatabase();
    const email = tokenInfo.email;
    const googleId = tokenInfo.sub;
    const name = tokenInfo.name || email.split("@")[0];
    const picture = tokenInfo.picture;

    // Check if user exists by email
    let user = await db
      .select()
      .from(users)
      .where(eq(users.email, email))
      .then((rows: (typeof users.$inferSelect)[]) => rows[0]);

    if (!user) {
      // Create new user
      const userId = nanoid();
      await db.insert(users).values({
        id: userId,
        email,
        name,
        image: picture,
        emailVerified: tokenInfo.email_verified === "true",
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      user = await db
        .select()
        .from(users)
        .where(eq(users.id, userId))
        .then((rows: (typeof users.$inferSelect)[]) => rows[0]);

      // Create Google account link
      await db.insert(accounts).values({
        id: nanoid(),
        userId: userId,
        accountId: googleId,
        providerId: "google",
        accessToken: idToken,
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    } else {
      // Update existing user if needed
      if (picture && picture !== user.image) {
        await db
          .update(users)
          .set({ image: picture, updatedAt: new Date() })
          .where(eq(users.id, user.id));
      }

      // Check if Google account is linked
      const existingAccount = await db
        .select()
        .from(accounts)
        .where(and(eq(accounts.userId, user.id), eq(accounts.providerId, "google")))
        .then((rows: (typeof accounts.$inferSelect)[]) => rows[0]);

      if (!existingAccount) {
        // Link Google account
        await db.insert(accounts).values({
          id: nanoid(),
          userId: user.id,
          accountId: googleId,
          providerId: "google",
          accessToken: idToken,
          createdAt: new Date(),
          updatedAt: new Date(),
        });
      }
    }

    // Create session
    const sessionToken = nanoid(32);
    const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000); // 7 days

    await db.insert(sessions).values({
      id: nanoid(),
      userId: user.id,
      token: sessionToken,
      expiresAt,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    // Return user data and token
    return NextResponse.json(
      {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          image: user.image,
        },
        token: sessionToken,
      },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Mobile Google Sign-In error:", error);
    return NextResponse.json(
      { error: "Authentication failed" },
      { status: 500, headers: corsHeaders }
    );
  }
}

