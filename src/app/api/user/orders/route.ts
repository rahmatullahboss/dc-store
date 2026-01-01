import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, sessions } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// CORS headers for mobile app access
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

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

export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

// GET - Fetch user's orders
export async function GET(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json(
        { error: "Unauthorized", orders: [] },
        { status: 401, headers: corsHeaders }
      );
    }

    const db = await getDatabase();

    const userOrders = await db.query.orders.findMany({
      where: eq(orders.userId, userId),
      orderBy: [desc(orders.createdAt)],
      columns: {
        id: true,
        orderNumber: true,
        status: true,
        paymentStatus: true,
        paymentMethod: true,
        subtotal: true,
        shippingCost: true,
        total: true,
        items: true,
        shippingAddress: true,
        createdAt: true,
      },
    });

    return NextResponse.json(
      {
        orders: userOrders.map((order) => ({
          ...order,
          createdAt: order.createdAt?.toISOString(),
        })),
      },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error fetching orders:", error);
    return NextResponse.json(
      { error: "Failed to fetch orders", orders: [] },
      { status: 500, headers: corsHeaders }
    );
  }
}

