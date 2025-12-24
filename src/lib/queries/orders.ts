import { eq, desc, and } from "drizzle-orm";
import { getDatabase } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import type { Order } from "@/db/schema";

/**
 * Get orders for a specific user
 */
export async function getOrdersByUser(userId: string): Promise<Order[]> {
  const db = await getDatabase();
  
  return db.query.orders.findMany({
    where: eq(orders.userId, userId),
    orderBy: [desc(orders.createdAt)],
  });
}

/**
 * Get order by order number (for tracking)
 */
export async function getOrderByNumber(orderNumber: string): Promise<Order | null> {
  const db = await getDatabase();
  
  const result = await db.query.orders.findFirst({
    where: eq(orders.orderNumber, orderNumber),
  });
  
  return result || null;
}

/**
 * Get order by order number and optional phone verification
 */
export async function getOrderByNumberAndPhone(
  orderNumber: string,
  phone?: string
): Promise<Order | null> {
  const db = await getDatabase();
  
  if (phone) {
    const result = await db.query.orders.findFirst({
      where: and(
        eq(orders.orderNumber, orderNumber),
        eq(orders.customerPhone, phone)
      ),
    });
    return result || null;
  }
  
  return getOrderByNumber(orderNumber);
}

/**
 * Get user order statistics
 */
export async function getUserOrderStats(userId: string): Promise<{
  totalOrders: number;
  totalSpent: number;
  pendingOrders: number;
  deliveredOrders: number;
}> {
  const db = await getDatabase();
  
  const userOrders = await db.query.orders.findMany({
    where: eq(orders.userId, userId),
  });
  
  return {
    totalOrders: userOrders.length,
    totalSpent: userOrders.reduce((sum, order) => sum + order.total, 0),
    pendingOrders: userOrders.filter((o) => 
      ["pending", "confirmed", "processing"].includes(o.status || "")
    ).length,
    deliveredOrders: userOrders.filter((o) => o.status === "delivered").length,
  };
}

/**
 * Get recent orders for a user (limited)
 */
export async function getRecentOrders(userId: string, limit: number = 3): Promise<Order[]> {
  const db = await getDatabase();
  
  return db.query.orders.findMany({
    where: eq(orders.userId, userId),
    orderBy: [desc(orders.createdAt)],
    limit,
  });
}
