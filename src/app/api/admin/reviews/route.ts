import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { reviews, products, users } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
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
    const status = searchParams.get("status");

    const db = await getDatabase();

    let whereCondition;
    if (status === "pending") {
      whereCondition = eq(reviews.isApproved, false);
    } else if (status === "approved") {
      whereCondition = eq(reviews.isApproved, true);
    }

    const reviewList = await db
      .select({
        id: reviews.id,
        productId: reviews.productId,
        productName: products.name,
        userName: users.name,
        rating: reviews.rating,
        title: reviews.title,
        content: reviews.content,
        isApproved: reviews.isApproved,
        createdAt: reviews.createdAt,
      })
      .from(reviews)
      .leftJoin(products, eq(reviews.productId, products.id))
      .leftJoin(users, eq(reviews.userId, users.id))
      .where(whereCondition)
      .orderBy(desc(reviews.createdAt));

    return NextResponse.json({ reviews: reviewList });
  } catch (error) {
    console.error("Reviews list error:", error);
    return NextResponse.json({ error: "Failed to fetch reviews" }, { status: 500 });
  }
}
