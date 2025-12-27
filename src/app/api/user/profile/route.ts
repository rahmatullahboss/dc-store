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

    return NextResponse.json({ 
      profile: user,
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
    };

    const db = await getDatabase();
    
    const updateData: Record<string, unknown> = {
      updatedAt: new Date(),
    };

    if (body.name) {
      updateData.name = body.name;
    }

    if (body.phone) {
      updateData.phone = body.phone;
    }

    if (body.defaultAddress) {
      updateData.defaultAddress = body.defaultAddress;
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
