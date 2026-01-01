import { NextResponse, NextRequest } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, products, users, categories } from "@/db/schema";
import { sql, eq, gte, and, desc } from "drizzle-orm";
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

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    const { searchParams } = new URL(request.url);
    
    const days = parseInt(searchParams.get("days") || "30");
    const daysAgo = new Date();
    daysAgo.setDate(daysAgo.getDate() - days);
    daysAgo.setHours(0, 0, 0, 0);

    // Revenue by day - query raw data - use unixepoch modifier for timestamp conversion
    const revenueByDayRaw = await db
      .select({
        date: sql<string>`DATE(${orders.createdAt}, 'unixepoch')`,
        revenue: sql<number>`COALESCE(SUM(${orders.total}), 0)`,
        orders: sql<number>`COUNT(*)`,
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

    // Generate all days in range and fill missing days
    const revenueMap = new Map<string, { revenue: number; orders: number }>();
    for (const row of revenueByDayRaw) {
      revenueMap.set(row.date, { revenue: row.revenue, orders: row.orders });
    }

    const revenueByDay: { date: string; revenue: number; orders: number }[] = [];
    for (let i = days - 1; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const dateStr = date.toISOString().split("T")[0];
      const data = revenueMap.get(dateStr) || { revenue: 0, orders: 0 };
      revenueByDay.push({
        date: dateStr,
        revenue: data.revenue,
        orders: data.orders,
      });
    }

    // Revenue by category
    const paidOrders = await db
      .select({
        items: orders.items,
      })
      .from(orders)
      .where(
        and(
          gte(orders.createdAt, daysAgo),
          eq(orders.paymentStatus, "paid")
        )
      );

    // Aggregate sales by product
    const productSales = new Map<string, number>();
    for (const order of paidOrders) {
      const items = order.items as OrderItem[];
      if (Array.isArray(items)) {
        for (const item of items) {
          const existing = productSales.get(item.productId) || 0;
          productSales.set(item.productId, existing + (item.price * item.quantity));
        }
      }
    }

    // Get product categories
    const allProducts = await db
      .select({
        id: products.id,
        categoryId: products.categoryId,
        categoryName: categories.name,
      })
      .from(products)
      .leftJoin(categories, eq(products.categoryId, categories.id));

    // Aggregate by category
    const categoryRevenue = new Map<string, number>();
    for (const product of allProducts) {
      const revenue = productSales.get(product.id) || 0;
      if (revenue > 0) {
        const catName = product.categoryName || "Uncategorized";
        const existing = categoryRevenue.get(catName) || 0;
        categoryRevenue.set(catName, existing + revenue);
      }
    }

    const revenueByCategory = Array.from(categoryRevenue.entries())
      .map(([name, revenue]) => ({ name, revenue }))
      .sort((a, b) => b.revenue - a.revenue);

    // Top customers
    const topCustomers = await db
      .select({
        customerName: orders.customerName,
        customerEmail: orders.customerEmail,
        totalSpent: sql<number>`SUM(${orders.total})`,
        orderCount: sql<number>`COUNT(*)`,
      })
      .from(orders)
      .where(
        and(
          gte(orders.createdAt, daysAgo),
          eq(orders.paymentStatus, "paid")
        )
      )
      .groupBy(orders.customerEmail)
      .orderBy(desc(sql`SUM(${orders.total})`))
      .limit(10);

    // Summary stats
    const totalRevenue = revenueByDay.reduce((sum, d) => sum + d.revenue, 0);
    const totalOrders = revenueByDay.reduce((sum, d) => sum + d.orders, 0);
    const avgOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

    // New customers count
    const newCustomersResult = await db
      .select({ count: sql<number>`COUNT(*)` })
      .from(users)
      .where(gte(users.createdAt, daysAgo));
    const newCustomers = newCustomersResult[0]?.count || 0;

    return NextResponse.json({
      summary: {
        totalRevenue,
        totalOrders,
        avgOrderValue,
        newCustomers,
      },
      revenueByDay,
      revenueByCategory,
      topCustomers,
    });
  } catch (error) {
    console.error("Reports error:", error);
    return NextResponse.json({ error: "Failed to fetch reports" }, { status: 500 });
  }
}
