import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { users, orders, wishlist } from "@/db/schema";
import { eq, sql } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// GET - Fetch user profile with stats
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    
    // Fetch user profile
    const user = await db.query.users.findFirst({
      where: eq(users.id, session.user.id),
      columns: {
        id: true,
        name: true,
        email: true,
        phone: true,
        defaultAddress: true,
        preferences: true,
        createdAt: true,
      },
    });

    // Fetch order statistics
    const orderStats = await db
      .select({
        orderCount: sql<number>`count(*)`,
        totalSpent: sql<number>`coalesce(sum(${orders.total}), 0)`,
      })
      .from(orders)
      .where(eq(orders.userId, session.user.id));

    // Fetch wishlist count
    const wishlistStats = await db
      .select({
        count: sql<number>`count(*)`,
      })
      .from(wishlist)
      .where(eq(wishlist.userId, session.user.id));

    // Fetch recent orders (last 5)
    const recentOrders = await db.query.orders.findMany({
      where: eq(orders.userId, session.user.id),
      orderBy: (orders, { desc }) => [desc(orders.createdAt)],
      limit: 5,
      columns: {
        id: true,
        orderNumber: true,
        status: true,
        total: true,
        items: true,
        createdAt: true,
      },
    });

    const stats = orderStats[0] || { orderCount: 0, totalSpent: 0 };
    const wishlistCount = wishlistStats[0]?.count || 0;

    // Helper to safely parse JSON fields that might be strings
    const safeParseJson = (value: unknown): unknown => {
      if (typeof value === 'string') {
        try {
          return JSON.parse(value);
        } catch {
          return value;
        }
      }
      return value;
    };

    return NextResponse.json({ 
      profile: user ? {
        ...user,
        // Ensure JSON fields are properly parsed objects
        defaultAddress: safeParseJson(user.defaultAddress),
        preferences: safeParseJson(user.preferences),
      } : null,
      stats: {
        orderCount: Number(stats.orderCount) || 0,
        totalSpent: Number(stats.totalSpent) || 0,
        wishlistCount: Number(wishlistCount) || 0,
        rewardPoints: 0, // TODO: Implement rewards system
      },
      recentOrders: recentOrders.map(order => ({
        id: order.id,
        orderNumber: order.orderNumber,
        date: order.createdAt,
        status: order.status,
        total: order.total,
        items: Array.isArray(order.items) ? order.items.length : 0,
      })),
    });
  } catch (error) {
    console.error("Error fetching profile:", error);
    return NextResponse.json({ error: "Failed to fetch profile" }, { status: 500 });
  }
}

// PATCH - Update user profile with shipping info
export async function PATCH(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as {
      name?: string;
      phone?: string;
      defaultAddress?: {
        division?: string;
        district?: string;
        address?: string;
      };
      preferences?: {
        language?: string;
        currency?: string;
      };
    };

    const db = await getDatabase();
    
    // First, fetch existing user data to merge with new data
    const existingUser = await db.query.users.findFirst({
      where: eq(users.id, session.user.id),
      columns: {
        defaultAddress: true,
        preferences: true,
      },
    });
    
    const updateData: Record<string, unknown> = {
      updatedAt: new Date(),
    };

    if (body.name) {
      updateData.name = body.name;
    }

    if (body.phone) {
      updateData.phone = body.phone;
    }

    // Helper to safely parse JSON fields
    const safeParseJson = (value: unknown): Record<string, string> | null => {
      if (!value) return null;
      if (typeof value === 'string') {
        try {
          const parsed = JSON.parse(value);
          // Check if it's a valid object (not a corrupted char-indexed object)
          if (parsed && typeof parsed === 'object' && !Array.isArray(parsed)) {
            // Verify it has real property names (not just numeric indexes)
            const keys = Object.keys(parsed);
            if (keys.length === 0 || (keys[0] && isNaN(Number(keys[0])))) {
              return parsed;
            }
          }
          return null;
        } catch {
          return null;
        }
      }
      if (typeof value === 'object' && value !== null) {
        // Verify it's a real object, not corrupted
        const keys = Object.keys(value);
        if (keys.length === 0 || (keys[0] && isNaN(Number(keys[0])))) {
          return value as Record<string, string>;
        }
      }
      return null;
    };

    // Merge defaultAddress with existing data (only if existing is valid)
    if (body.defaultAddress) {
      const existingAddress = safeParseJson(existingUser?.defaultAddress);
      // Don't JSON.stringify - Drizzle's text({ mode: 'json' }) handles this automatically
      updateData.defaultAddress = {
        ...(existingAddress || {}),
        ...body.defaultAddress,
      };
    }

    // Merge preferences with existing data (only if existing is valid)
    if (body.preferences) {
      const existingPrefs = safeParseJson(existingUser?.preferences);
      // Don't JSON.stringify - Drizzle's text({ mode: 'json' }) handles this automatically
      updateData.preferences = {
        ...(existingPrefs || {}),
        ...body.preferences,
      };
    }

    await db
      .update(users)
      .set(updateData)
      .where(eq(users.id, session.user.id));

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error updating profile:", error);
    return NextResponse.json({ error: "Failed to update profile" }, { status: 500 });
  }
}
