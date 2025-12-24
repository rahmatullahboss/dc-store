import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { users, orders } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// GET - Get single customer with order history
export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    
    // Get customer details
    const customer = await db.query.users.findFirst({
      where: eq(users.id, id),
    });

    if (!customer) {
      return NextResponse.json({ error: "Customer not found" }, { status: 404 });
    }

    // Get customer orders
    const customerOrders = await db
      .select({
        id: orders.id,
        orderNumber: orders.orderNumber,
        total: orders.total,
        status: orders.status,
        createdAt: orders.createdAt,
        items: orders.items,
      })
      .from(orders)
      .where(eq(orders.userId, id))
      .orderBy(desc(orders.createdAt));

    // Calculate stats
    const ordersCount = customerOrders.length;
    const totalSpent = customerOrders.reduce((sum, o) => sum + (o.total || 0), 0);

    // Format orders for response
    const formattedOrders = customerOrders.map((o) => ({
      id: o.id,
      orderNumber: o.orderNumber,
      total: o.total,
      status: o.status,
      createdAt: o.createdAt,
      itemsCount: Array.isArray(o.items) ? o.items.length : 0,
    }));

    return NextResponse.json({
      customer: {
        id: customer.id,
        name: customer.name,
        email: customer.email,
        phone: customer.phone,
        image: customer.image,
        role: customer.role,
        defaultAddress: customer.defaultAddress,
        createdAt: customer.createdAt,
        ordersCount,
        totalSpent,
        orders: formattedOrders,
      },
    });
  } catch (error) {
    console.error("Get customer error:", error);
    return NextResponse.json({ error: "Failed to fetch customer" }, { status: 500 });
  }
}
