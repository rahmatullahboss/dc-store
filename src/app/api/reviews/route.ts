import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { reviews, products, orders } from "@/db/schema";
import type { OrderItem } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";
import { nanoid } from "nanoid";

/**
 * POST /api/reviews - Submit a product review
 * Request: { productId, rating, title?, content? }
 * Requires authentication
 */
export async function POST(request: Request) {
  try {
    // Get authenticated user
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user?.id) {
      return NextResponse.json(
        { error: "Please login to submit a review" },
        { status: 401 }
      );
    }

    const userId = session.user.id;
    const body = await request.json() as {
      productId?: string;
      rating?: number;
      title?: string;
      content?: string;
    };

    const { productId, rating, title, content } = body;

    // Validate required fields
    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    if (!rating || rating < 1 || rating > 5) {
      return NextResponse.json(
        { error: "Rating must be between 1 and 5" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Check if product exists
    const product = await db
      .select({ id: products.id })
      .from(products)
      .where(eq(products.id, productId))
      .then((rows) => rows[0]);

    if (!product) {
      return NextResponse.json(
        { error: "Product not found" },
        { status: 404 }
      );
    }

    // Check if user already reviewed this product
    const existingReview = await db
      .select({ id: reviews.id })
      .from(reviews)
      .where(
        and(
          eq(reviews.productId, productId),
          eq(reviews.userId, userId)
        )
      )
      .then((rows) => rows[0]);

    if (existingReview) {
      return NextResponse.json(
        { error: "You have already reviewed this product" },
        { status: 400 }
      );
    }

    // Check if user has purchased this product (verified review)
    const userOrders = await db
      .select({ items: orders.items })
      .from(orders)
      .where(
        and(
          eq(orders.userId, userId),
          eq(orders.status, "delivered")
        )
      );

    const hasPurchased = userOrders.some(order => 
      (order.items as OrderItem[])?.some(item => item.productId === productId)
    );

    // Create review
    const reviewId = nanoid();
    await db.insert(reviews).values({
      id: reviewId,
      productId,
      userId,
      rating,
      title: title || null,
      content: content || null,
      isVerified: hasPurchased, // Mark as verified if user purchased
      isApproved: false, // Requires admin approval
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    return NextResponse.json({
      success: true,
      reviewId,
      isVerified: hasPurchased,
      message: hasPurchased 
        ? "Thank you! Your verified review has been submitted for approval."
        : "Thank you! Your review has been submitted for approval.",
    });
  } catch (error) {
    console.error("Review submission error:", error);
    return NextResponse.json(
      { error: "Failed to submit review" },
      { status: 500 }
    );
  }
}
