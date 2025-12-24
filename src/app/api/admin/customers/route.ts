import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { users } from "@/db/schema";
import { sql, desc } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

export async function GET(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const search = searchParams.get("search") || "";

    const db = await getDatabase();

    // Get customers with order stats
    const customerList = await db
      .select({
        id: users.id,
        name: users.name,
        email: users.email,
        phone: users.phone,
        createdAt: users.createdAt,
        ordersCount: sql<number>`COALESCE((SELECT COUNT(*) FROM orders WHERE orders.user_id = ${users.id}), 0)`,
        totalSpent: sql<number>`COALESCE((SELECT SUM(total) FROM orders WHERE orders.user_id = ${users.id} AND orders.payment_status = 'paid'), 0)`,
      })
      .from(users)
      .where(
        search
          ? sql`(${users.name} LIKE ${'%' + search + '%'} OR ${users.email} LIKE ${'%' + search + '%'})`
          : undefined
      )
      .orderBy(desc(users.createdAt));

    return NextResponse.json({ customers: customerList });
  } catch (error) {
    console.error("Customers list error:", error);
    return NextResponse.json({ error: "Failed to fetch customers" }, { status: 500 });
  }
}
