import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, products, users } from "@/db/schema";
import { sql, eq, gte, and } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    // Check admin access
    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    // Get today's start
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Total Revenue
    const revenueResult = await db
      .select({ total: sql<number>`COALESCE(SUM(${orders.total}), 0)` })
      .from(orders)
      .where(eq(orders.paymentStatus, "paid"));
    const totalRevenue = revenueResult[0]?.total || 0;

    // Orders Today
    const ordersTodayResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(orders)
      .where(gte(orders.createdAt, today));
    const ordersToday = ordersTodayResult[0]?.count || 0;

    // Active Products
    const productsResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(products)
      .where(eq(products.isActive, true));
    const activeProducts = productsResult[0]?.count || 0;

    // Total Users
    const usersResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(users);
    const totalUsers = usersResult[0]?.count || 0;

    // Recent Orders (last 5)
    const recentOrders = await db
      .select({
        id: orders.id,
        orderNumber: orders.orderNumber,
        customerName: orders.customerName,
        total: orders.total,
        status: orders.status,
        createdAt: orders.createdAt,
      })
      .from(orders)
      .orderBy(sql`${orders.createdAt} DESC`)
      .limit(5);

    // Revenue by day (last 7 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const revenueByDay = await db
      .select({
        date: sql<string>`DATE(${orders.createdAt} / 1000, 'unixepoch')`,
        revenue: sql<number>`COALESCE(SUM(${orders.total}), 0)`,
      })
      .from(orders)
      .where(
        and(
          gte(orders.createdAt, sevenDaysAgo),
          eq(orders.paymentStatus, "paid")
        )
      )
      .groupBy(sql`DATE(${orders.createdAt} / 1000, 'unixepoch')`)
      .orderBy(sql`DATE(${orders.createdAt} / 1000, 'unixepoch')`);

    return NextResponse.json({
      stats: {
        totalRevenue,
        ordersToday,
        activeProducts,
        totalUsers,
      },
      recentOrders,
      revenueByDay,
    });
  } catch (error) {
    console.error("Admin stats error:", error);
    return NextResponse.json(
      { error: "Failed to fetch stats" },
      { status: 500 }
    );
  }
}
