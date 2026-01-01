import { NextResponse, NextRequest } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, products, users } from "@/db/schema";
import { sql, eq, gte, and, lte } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

interface OrderItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
}

export async function GET(request: NextRequest) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    // Check admin access
    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    const { searchParams } = new URL(request.url);
    
    // Parse date range from query params
    const dateFrom = searchParams.get("dateFrom");
    const dateTo = searchParams.get("dateTo");
    const days = searchParams.get("days") || "7"; // Default to 7 days for chart

    // Get today's start
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Build date filter for revenue
    const dateFilter = dateFrom && dateTo
      ? and(
          gte(orders.createdAt, new Date(dateFrom)),
          lte(orders.createdAt, new Date(dateTo))
        )
      : undefined;

    // Total Revenue (with optional date filter)
    const revenueResult = await db
      .select({ total: sql<number>`COALESCE(SUM(${orders.total}), 0)` })
      .from(orders)
      .where(
        dateFilter
          ? and(eq(orders.paymentStatus, "paid"), dateFilter)
          : eq(orders.paymentStatus, "paid")
      );
    const totalRevenue = revenueResult[0]?.total || 0;

    // Orders Today
    const ordersTodayResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(orders)
      .where(gte(orders.createdAt, today));
    const ordersToday = ordersTodayResult[0]?.count || 0;

    // Pending Orders (for notifications)
    const pendingOrdersResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(orders)
      .where(eq(orders.status, "pending"));
    const pendingOrders = pendingOrdersResult[0]?.count || 0;

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

    // Revenue by day/hour (configurable days)
    const daysCount = parseInt(days) || 7;
    const daysAgo = new Date();
    daysAgo.setDate(daysAgo.getDate() - daysCount);
    daysAgo.setHours(0, 0, 0, 0);
    
    const revenueByDay: { date: string; revenue: number }[] = [];
    
    if (daysCount === 1) {
      // For "Today", group by hour
      const revenueByHourRaw = await db
        .select({
          hour: sql<number>`strftime('%H', ${orders.createdAt}, 'unixepoch')`,
          revenue: sql<number>`COALESCE(SUM(${orders.total}), 0)`,
        })
        .from(orders)
        .where(
          and(
            gte(orders.createdAt, daysAgo),
            eq(orders.paymentStatus, "paid")
          )
        )
        .groupBy(sql`strftime('%H', ${orders.createdAt}, 'unixepoch')`)
        .orderBy(sql`strftime('%H', ${orders.createdAt}, 'unixepoch')`);

      // Generate all 24 hours and fill missing with zero
      const hourMap = new Map<string, number>();
      for (const row of revenueByHourRaw) {
        hourMap.set(String(row.hour).padStart(2, "0"), row.revenue);
      }

      for (let h = 0; h < 24; h++) {
        const hourStr = String(h).padStart(2, "0");
        revenueByDay.push({
          date: `${hourStr}:00`,
          revenue: hourMap.get(hourStr) || 0,
        });
      }
    } else {
      // For multiple days, group by date
      const revenueByDayRaw = await db
        .select({
          date: sql<string>`DATE(${orders.createdAt}, 'unixepoch')`,
          revenue: sql<number>`COALESCE(SUM(${orders.total}), 0)`,
        })
        .from(orders)
        .where(
          and(
            gte(orders.createdAt, daysAgo),
            eq(orders.paymentStatus, "paid")
          )
        )
        .groupBy(sql`DATE(${orders.createdAt}, 'unixepoch')`)
        .orderBy(sql`DATE(${orders.createdAt}, 'unixepoch')`);

      // Generate all days in range and fill missing days with zero
      const revenueMap = new Map<string, number>();
      for (const row of revenueByDayRaw) {
        revenueMap.set(row.date, row.revenue);
      }

      for (let i = daysCount - 1; i >= 0; i--) {
        const date = new Date();
        date.setDate(date.getDate() - i);
        const dateStr = date.toISOString().split("T")[0];
        revenueByDay.push({
          date: dateStr,
          revenue: revenueMap.get(dateStr) || 0,
        });
      }
    }

    // Top Selling Products - aggregate from order items JSON
    const paidOrders = await db
      .select({
        items: orders.items,
      })
      .from(orders)
      .where(eq(orders.paymentStatus, "paid"));

    // Aggregate product sales from order items
    const productSales = new Map<string, { totalSold: number; revenue: number }>();
    for (const order of paidOrders) {
      const items = order.items as OrderItem[];
      if (Array.isArray(items)) {
        for (const item of items) {
          const existing = productSales.get(item.productId) || { totalSold: 0, revenue: 0 };
          existing.totalSold += item.quantity;
          existing.revenue += item.price * item.quantity;
          productSales.set(item.productId, existing);
        }
      }
    }

    // Get top 5 products by revenue
    const topProductIds = Array.from(productSales.entries())
      .sort((a, b) => b[1].revenue - a[1].revenue)
      .slice(0, 5)
      .map(([id]) => id);

    const topProductsData = topProductIds.length > 0
      ? await db
          .select({
            id: products.id,
            name: products.name,
            featuredImage: products.featuredImage,
          })
          .from(products)
          .where(sql`${products.id} IN (${sql.join(topProductIds.map(id => sql`${id}`), sql`, `)})`)
      : [];

    const topProducts = topProductsData.map((p) => ({
      ...p,
      totalSold: productSales.get(p.id)?.totalSold || 0,
      revenue: productSales.get(p.id)?.revenue || 0,
    })).sort((a, b) => b.revenue - a.revenue);

    // Low Stock Products (quantity <= 5)
    const lowStockProducts = await db
      .select({
        id: products.id,
        name: products.name,
        quantity: products.quantity,
        featuredImage: products.featuredImage,
      })
      .from(products)
      .where(
        and(
          eq(products.isActive, true),
          lte(products.quantity, 5)
        )
      )
      .orderBy(products.quantity)
      .limit(10);

    return NextResponse.json({
      stats: {
        totalRevenue,
        ordersToday,
        pendingOrders,
        activeProducts,
        totalUsers,
      },
      recentOrders,
      revenueByDay,
      topProducts,
      lowStockProducts,
    });
  } catch (error) {
    console.error("Admin stats error:", error);
    return NextResponse.json(
      { error: "Failed to fetch stats" },
      { status: 500 }
    );
  }
}

