import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { wishlist, sessions } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// Helper to get user ID from Bearer token or session cookie
async function getUserId(request: NextRequest): Promise<string | null> {
  // First try Bearer token (for mobile app)
  const authHeader = request.headers.get("authorization");
  if (authHeader?.startsWith("Bearer ")) {
    const token = authHeader.slice(7);
    const db = await getDatabase();

    const session = await db
      .select()
      .from(sessions)
      .where(eq(sessions.token, token))
      .then((rows) => rows[0]);

    if (session && new Date(session.expiresAt) >= new Date()) {
      return session.userId;
    }
  }

  // Fallback to cookie-based session (for web)
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (session?.user) {
      return session.user.id;
    }
  } catch {
    // Ignore cookie session errors
  }

  return null;
}

// DELETE - Remove product from wishlist
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ productId: string }> }
) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { productId } = await params;

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    await db
      .delete(wishlist)
      .where(and(eq(wishlist.userId, userId), eq(wishlist.productId, productId)));

    return NextResponse.json({
      success: true,
      message: "Removed from wishlist",
    });
  } catch (error) {
    console.error("Error removing from wishlist:", error);
    return NextResponse.json(
      { error: "Failed to remove from wishlist" },
      { status: 500 }
    );
  }
}
