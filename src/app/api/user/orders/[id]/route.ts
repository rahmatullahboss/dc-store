import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, sessions } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// Helper to get user ID from Bearer token or session cookie
async function getUserId(request: Request): Promise<string | null> {
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

// GET - Fetch a specific order by ID
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { id } = await params;
    const db = await getDatabase();
    
    const order = await db.query.orders.findFirst({
      where: and(
        eq(orders.id, id),
        eq(orders.userId, userId)
      ),
    });

    if (!order) {
      return NextResponse.json({ error: "Order not found" }, { status: 404 });
    }

    return NextResponse.json({ 
      order: {
        ...order,
        createdAt: order.createdAt?.toISOString(),
      },
    });
  } catch (error) {
    console.error("Error fetching order:", error);
    return NextResponse.json({ error: "Failed to fetch order" }, { status: 500 });
  }
}
