import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// GET - Fetch user's orders
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    
    const userOrders = await db.query.orders.findMany({
      where: eq(orders.userId, session.user.id),
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

    return NextResponse.json({ 
      orders: userOrders.map(order => ({
        ...order,
        createdAt: order.createdAt?.toISOString(),
      })),
    });
  } catch (error) {
    console.error("Error fetching orders:", error);
    return NextResponse.json({ error: "Failed to fetch orders" }, { status: 500 });
  }
}
