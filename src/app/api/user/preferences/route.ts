import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { users } from "@/db/schema";
import { eq } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

interface UserPreferences {
  language?: string;
  currency?: string;
}

// GET - Fetch user preferences
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    const user = await db.query.users.findFirst({
      where: eq(users.id, session.user.id),
      columns: {
        preferences: true,
      },
    });

    // Default preferences
    const preferences: UserPreferences = {
      language: "en",
      currency: "BDT",
      ...(user?.preferences as UserPreferences || {}),
    };

    return NextResponse.json({ preferences });
  } catch (error) {
    console.error("Error fetching preferences:", error);
    return NextResponse.json(
      { error: "Failed to fetch preferences" },
      { status: 500 }
    );
  }
}

// PATCH - Update user preferences
export async function PATCH(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as UserPreferences;
    const db = await getDatabase();

    // Fetch current preferences
    const user = await db.query.users.findFirst({
      where: eq(users.id, session.user.id),
      columns: {
        preferences: true,
      },
    });

    // Merge with existing preferences
    const updatedPreferences: UserPreferences = {
      ...(user?.preferences as UserPreferences || {}),
      ...(body.language !== undefined ? { language: body.language } : {}),
      ...(body.currency !== undefined ? { currency: body.currency } : {}),
    };

    await db
      .update(users)
      .set({
        preferences: updatedPreferences,
        updatedAt: new Date(),
      })
      .where(eq(users.id, session.user.id));

    return NextResponse.json({
      success: true,
      preferences: updatedPreferences,
    });
  } catch (error) {
    console.error("Error updating preferences:", error);
    return NextResponse.json(
      { error: "Failed to update preferences" },
      { status: 500 }
    );
  }
}
